*-----------------------------------------------------------------------------
* <Rating>-5</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FI.CENTRAL.BANK.FILE(I.XML.MSG, O.ERROR.MSG)
*
******************************************************************************
*
*    Routine processing XML files received from the Central Bank to APAP
*    Parameters:
*        I.XML.MSG:  Input parameter to recived the XML message
*        O.ERR.MSG:  Output parameter to send the ERROR message get in the process
*
* =============================================================================
*
*    First Release : R09
*    Developed for : APAP
*    Developed by  : Ana Noriega
*    Date          : 2010/Oct/21
*
*=======================================================================
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.FI.VARIABLES.COMMON
$INSERT I_F.REDO.FI.CONTROL
$INSERT I_F.REDO.INTERFACE.PARAM
$INSERT I_F.REDO.APAP.PARAM.EMAIL
$INSERT I_F.REDO.ISSUE.EMAIL
$INSERT I_F.REDO.TEMP.FI.CONTROL
$INSERT I_F.REDO.NOMINA.DET
$INSERT I_F.FT.COMMISSION.TYPE
$INSERT I_F.FT.CHARGE.TYPE
$INSERT I_F.FT.TXN.TYPE.CONDITION

*
*************************************************************************
*

  GOSUB INITIALISE

  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END
*
  RETURN
*
* ======
PROCESS:
* ======
*
*
  LOOP.CNT            = 1
  MAX.LOOPS           = 2
*
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD  DO
    BEGIN CASE
    CASE LOOP.CNT EQ 1        ;*           CONVERT FORMAT XML TO TXT
      CALL REDO.FI.CONVERT.XML.TO.TXT(I.XML.MSG, R.TXT.MSG, O.ERROR.MSG)
      IF O.ERROR.MSG THEN
        PROCESS.GOAHEAD = 0

      END

    CASE LOOP.CNT EQ 2        ;*           VALIDATE HEADER AND DETAIL
      W.TXT.MSG = R.TXT.MSG
      CALL REDO.FI.VALIDATE.HEAD.AND.DATA(R.TXT.MSG, R.POS.VALUES, R.VALUES, O.ERROR.MSG)
      IF O.ERROR.MSG THEN
        PROCESS.GOAHEAD = 0

      END
    END CASE
    IF O.ERROR.MSG THEN
      GOSUB CONTROL.MSG.ERROR ;*    MESSAGE ERROR
    END
    LOOP.CNT +=1
  REPEAT

  IF O.ERROR.MSG THEN
    Y.ERR.MSG = O.ERROR.MSG
  END
  GOSUB RECORD.FI.CONTROL     ;*    RECORD in FI.CONTROL

  IF PROCESS.GOAHEAD THEN
    GOSUB A150.SAVE.FILE.IN.DIR
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STATUS>       = Y.FINAL.STATUS

    CALL REDO.FI.RECORD.CONTROL(Y.ERR.MSG)

  END ELSE
    GOSUB MAIL.GENERATION
  END

*
  RETURN

*-----------------*
MAIL.GENERATION:
*-----------------*
  Y.TRANS.DATE = TODAY
  Y.TRANS.TIME= OCONV(TIME(), "MT")
  CHANGE ":" TO '' IN Y.TRANS.TIME
  Y.UNIQUE.ID = FI.W.REDO.FI.CONTROL.ID:"_":Y.TRANS.DATE:"_":Y.TRANS.TIME
  Y.REQUEST.FILE = Y.UNIQUE.ID:'.TXT'
  Y.ATTACH.FILENAME = 'ATTACHMENT':'_':Y.UNIQUE.ID:'.TXT'
  R.RECORD1 = ''
  Y.REF.FILE.NAME =  'BANCO CENTRAL STATUS'
  CALL REDO.FI.MAIL.FORMAT.GEN(FI.W.REDO.FI.CONTROL.ID,Y.MAIL.DESCRIPTION)
  R.RECORD1 = Y.FROM.MAIL.ADD.VAL:"#":Y.TO.MAIL.VALUE:'#':Y.REF.FILE.NAME:'#':Y.REF.FILE.NAME
  IF Y.MAIL.MSG THEN
    WRITE Y.MAIL.DESCRIPTION TO F.HRMS.ATTACH.FILE,Y.ATTACH.FILENAME
 
  END ELSE
    WRITE R.TXT.MSG TO F.HRMS.ATTACH.FILE,Y.ATTACH.FILENAME
 
  END
  WRITE R.RECORD1 TO F.HRMS.DET.FILE,Y.REQUEST.FILE
 

  RETURN
* ----------------
RECORD.FI.CONTROL:
* ----------------
*
  R.TXT.MSG = W.TXT.MSG

*   Generate ID
  IF R.VALUES<5> EQ "1" THEN
    Y.SEQ.FILE = ".02"
  END
  FI.W.REDO.FI.CONTROL.ID  = FI.INTERFACE:".":FIELD(R.TXT.MSG<1>,",",5):Y.SEQ.FILE
*   If the new values are diferent of null, set the data records.
  FI.W.REDO.FI.CONTROL<REDO.FI.CON.FILE.NAME>        = Y.FILE.TXT     ;*FI.FILE.ID
  FI.W.REDO.FI.CONTROL<REDO.FI.CON.FILE.DIR>         = FI.WORK.DIR
  FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROCESS.CONFIRM>  = FI.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.AUT.AVAIL.FUNDS>
  FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.DATE>        = TODAY
  FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.TIME>        = FIELD(TIMEDATE()," ",1)
  FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORD.FILE>  = FI.DATO.NUM.REG
  FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.AMOUNT.FILE>  = FI.DATO.MONTO.TOTAL
  FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORD.CALC>  = FI.CALC.NUM.REG
  FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.AMOUNT.CALC>  = FI.CALC.MONTO.TOTAL
  FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STATUS>      = "NO FALLIDO"
  IF Y.ERR.MSG THEN
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STATUS>  = "CARGA FALLIDA"
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STAT.D>  = Y.ERR.MSG
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORDS.OK> = 0
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC.OK> = 0
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORD.PROC> = 0
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC>     = 0
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORDS.FAIL> = 0
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC.FAIL>  = 0
  END
*   Save in Redo.Fi.Control
  CALL REDO.FI.RECORD.CONTROL(Y.ERR.MSG)


*
  RETURN
*
*
* ====================
A150.SAVE.FILE.IN.DIR:
* ====================
*

  W.TOT.FILE.AMT = FIELD(R.TXT.MSG<1>,',',12)
*Debit to enterprise account
  R.PARAM<1> = "NULL"
  R.PARAM<2> = "N"
  R.PARAM<3> = W.TOT.FILE.AMT
  R.PARAM<4> = Y.FILE.TXT
  R.PARAM<5> = FI.INTERFACE
  R.PARAM<6> = FI.CTA.DESTINO
  R.PARAM<7> = W.TOT.FILE.AMT
  R.PARAM<8> = "DOP"
  R.PARAM<9> = FI.W.REDO.FI.CONTROL.ID
  R.PARAM<10> = "S"
  R.PARAM<11> = FI.CTA.INTERMEDIA
  R.PARAM<12> = "BACENC"
  R.PARAM<13> = DR.TXN.CODE

  WRECORD.NUMBER       = 1
  W.ADDITIONAL.INFO     = ""
  W.ADDITIONAL.INFO<1>  = FI.BATCH.ID : "." : WRECORD.NUMBER          ;* THEIR.REFERENCE
  W.ADDITIONAL.INFO<2>  = FI.BATCH.ID : "." : WRECORD.NUMBER          ;* OUR.REFERENCE
  W.ADDITIONAL.INFO<3>  = FI.INTERFACE : "." : FI.BATCH.ID  ;* NARRATIVE
  W.ADDITIONAL.INFO<4>  = FI.W.REDO.FI.CONTROL.ID ;* TRANS.REFERENCE
  W.ADDITIONAL.INFO<5>  = WRECORD.NUMBER          ;* BATCH.ID
  W.ADDITIONAL.INFO     = CHANGE(W.ADDITIONAL.INFO,@FM,",")

  OUT.REF = ''

  DATO.OUT = "D|":FI.CTA.DESTINO: "|":R.PARAM<7>:"|DOP|-|":R.PARAM<7>:"|":W.ADDITIONAL.INFO<3>:"|":WRECORD.NUMBER

  IF W.TOT.FILE.AMT GT 0 THEN
    GOSUB FT.PROCESS
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.PARENT.FT.REF> = OUT.REF
    IF FIELD(OUT.RESP,'/',1)[1,2] NE 'FT' THEN

      Y.ERR.MSG = OUT.RESP
      Y.FINAL.STATUS = "FALLIDO"
      FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STAT.D>  = Y.ERR.MSG
      GOSUB CONTROL.MSG.ERROR
      RETURN
    END ELSE
      Y.FINAL.STATUS = "PROCESADO"
    END
  END ELSE
    Y.ERR.MSG = "EB-ERROR.NONE.FT.APPLIED"
    Y.FINAL.STATUS = "FALLIDO"
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STAT.D>  = Y.ERR.MSG
    W.TOT.FT.ERR += FI.DATO.MONTO.TOTAL
    GOSUB CONTROL.MSG.ERROR
    RETURN
  END

*
*   Opens and Writes TXT message in corresponding dir.


  R.TXT.MSG = W.TXT.MSG
  Y.COUNT   = COUNT(R.TXT.MSG,@FM)


  FOR II = 2 TO Y.COUNT
    GOSUB APPEND.ADDITIONAL.INFO
    Y.IN.MSG = R.TXT.MSG<II>
    Y.IN.MSG.N = II:R.TXT.MSG<II>
    R.TXT.MSG<II> = R.TXT.MSG<II> : "," : W.ADDITIONAL.INFO

    CALL REDO.FI.MSG.FORMAT(FI.INTERFACE,R.TXT.MSG<II>,DATO.OUT)

    IF Y.ERR.MSG NE "" THEN
      W.STATUS = "04"
      W.ERROR.MSG = Y.ERR.MSG
    END

    OUT.REF  = ''
    W.STATUS = "01"
    DATO.OUT = DATO.OUT
    GOSUB MESSAGE.FORMAT
  NEXT

  R.REDO.NOMINA.DET<RE.NM.DET.CTA.DESTINO>   =FI.CTA.DESTINO
  R.REDO.NOMINA.DET<RE.NM.DET.INTERFACE.TYPE>='BACEN'
  R.REDO.NOMINA.DET<RE.NM.DET.INTERFACE.NAME>=FI.INTERFACE
  CALL F.WRITE(FN.REDO.NOMINA.TEMP,FI.W.REDO.FI.CONTROL.ID,R.REDO.NOMINA.TEMP)
  CALL F.WRITE(FN.REDO.NOMINA.DET,FI.W.REDO.FI.CONTROL.ID,R.REDO.NOMINA.DET)
  RETURN
* =============
MESSAGE.FORMAT:
* =============
*
*   Paragraph to set message format to AC.ENTRY.PARAM


  V.CTA.CLIENTE = R.TXT.MSG<II>
  V.CTA.CLIENTE = FIELD(V.CTA.CLIENTE,",",5)

  GOSUB PROCESS.CTA.CLIENTE
  R.PARAM<1> = "NULL"
  R.PARAM<2> = "N"
  R.PARAM<3> = FIELD(DATO.OUT,"|",3)
  R.PARAM<4> = FI.FILE.ID
  R.PARAM<5> = FI.INTERFACE
  R.PARAM<6> = FI.CTA.INTERMEDIA
  R.PARAM<7> = FIELD(DATO.OUT,"|",3)
  R.PARAM<8> = FIELD(DATO.OUT,"|",4)
  R.PARAM<9> = FI.W.REDO.FI.CONTROL.ID
  R.PARAM<10>  = "N"
  R.PARAM<11>  = Y.CUENTA
  R.PARAM<12>  = "BACEN"
  R.PARAM<13>  = CR.TXN.CODE
  Y.PRESENT.CNT=II-1
  Y.TEMP.ID    =TODAY:FI.FILE.ID:STR("0",(5-LEN(Y.PRESENT.CNT))):Y.PRESENT.CNT
  CHANGE FM TO VM IN R.PARAM
  R.REDO.TEMP.FI.CONTROL<FI.TEMP.PARAM.VAL>  =R.PARAM
  R.REDO.TEMP.FI.CONTROL<FI.TEMP.STATUS>     =''
  R.REDO.TEMP.FI.CONTROL<FI.TEMP.MAIL.MSG>   =W.TXT.MSG<Y.PRESENT.CNT>
  R.REDO.TEMP.FI.CONTROL<FI.TEMP.INTER.TYPE> ='BACEN'
  CALL F.WRITE(FN.REDO.TEMP.FI.CONTROL,Y.TEMP.ID,R.REDO.TEMP.FI.CONTROL)
  R.REDO.NOMINA.TEMP<-1>=Y.TEMP.ID
*
  RETURN
*
* -----------
PROCESS.CTA.CLIENTE:
*------------
  Y.LEN       = LEN(V.CTA.CLIENTE)
  W.CUENTA.CLIENTE = SUBSTRINGS (V.CTA.CLIENTE,9, Y.LEN)
  Y.LEN2 = LEN(W.CUENTA.CLIENTE)

  NUM.POS.CUEN = Y.LEN2
  Y.SWITCH ="N"
  Y.CUENTA = ""
  FOR K.POSI = 1 TO NUM.POS.CUEN
    Y.CARACT = SUBSTRINGS(W.CUENTA.CLIENTE,K.POSI,1)
    IF Y.CARACT EQ "0" THEN
      IF Y.SWITCH EQ "N" THEN
        Y.SWITCH = "N"
      END ELSE
        Y.CUENTA = Y.CUENTA:Y.CARACT
      END
    END ELSE
      Y.SWITCH ="S"
      Y.CUENTA = Y.CUENTA:Y.CARACT
    END
  NEXT K.POSI
  RETURN
*
* ----------------
FT.PROCESS:
* ----------------
*   Paragraph that record the error message and move the file to the rejected directory renaming the file

  OUT.RESP = ''
  CALL REDO.FI.DEBIT.PROCES.BACEN(R.PARAM, OUT.REF, OUT.RESP)


  IF FIELD(OUT.RESP,'/',1)[1,2] NE 'FT' THEN

    Y.ERR.MSG = OUT.RESP
    W.STATUS = "04"
    W.ERROR.MSG = Y.ERR.MSG
  END ELSE
    Y.ERR.MSG = ''
  END

  RETURN
* ==============
* =====================
APPEND.ADDITIONAL.INFO:
* =====================
*
  WRECORD.NUMBER        = II - 1
  W.ADDITIONAL.INFO     = ""
  W.ADDITIONAL.INFO<1>  = FI.INTERFACE : "." : FI.BATCH.ID : "." : WRECORD.NUMBER         ;* TRANS.REFERENCE
  W.ADDITIONAL.INFO<2>  = FI.BATCH.ID : "." : WRECORD.NUMBER          ;* THEIR.REFERENCE
  W.ADDITIONAL.INFO<3>  = FI.BATCH.ID : "." : WRECORD.NUMBER          ;* OUR.REFERENCE
  W.ADDITIONAL.INFO<4>  = WRECORD.NUMBER          ;* RECORD NUMBER
*
  W.ADDITIONAL.INFO = CHANGE(W.ADDITIONAL.INFO,@FM,",")
*
  RETURN
*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
*   Paragraph

  IF O.ERROR.MSG THEN
    E.TEXT     = O.ERROR.MSG
    Y.NAME.DIR = FI.PATH.REJ
  END
*
  IF ERR.TEXT THEN
    PROCESS.GOAHEAD = 0
    ETEXT           = ERR.TEXT
    O.ERR.MSG       = ""
    CALL STORE.END.ERROR
    O.ERROR.MSG     = ETEXT
    ETEXT           = ""
  END
*
  IF O.ERROR.MSG THEN
    W.FILE.ID = CHANGE(Y.FILE.TXT,".txt",".rej")
    OPENSEQ FI.PATH.REJ, W.FILE.ID TO Y.SEQ.FILE.POINTER ELSE
      CREATE Y.SEQ.FILE.POINTER ELSE
        ERR.TEXT = "EB-ERROR.OPENING.OUTPUT.FILE"
      END
    END
    WRITESEQ I.XML.MSG TO Y.SEQ.FILE.POINTER ELSE
      ERR.TEXT = "EB-ERROR.WRITING.TO.OUTPUT.FILE"
    END
    WEOFSEQ   Y.SEQ.FILE.POINTER        ;* Writes an EOF
    CLOSESEQ  Y.SEQ.FILE.POINTER
  END
*
  RETURN
*
* ---------
INITIALISE:
* ---------
*
*   CONSTANTS
  C.TAG.BEGIN.HEADER      = "<encabezado>"
  C.TAG.END.HEADER        = "</encabezado>"
  C.TAG.BEGIN.DATA        = "<pago>"
  C.TAG.END.DATA          = "</pago>"
*   WORK VARIABLES
  PROCESS.GOAHEAD         = 1
  LOOP.CNT                = ""
  MAX.LOOPS               = ""
  W.CONTROL.DIGIT         = ""
  R.TXT.MSG               = ""
  O.R.DATA.LOG            = ""
  O.ERROR.MSG             = ""
  ERR.TEXT                = ""
  W.STATUS                = "01"
  Y.ERR.MSG2              = ""
  OUT.RESP                = ""
*
  R.POS.VALUES            = ""
  R.VALUES                = ""
  R.POS.VALUES<1>         = 11          ;*TotalRecord Header
  R.POS.VALUES<2>         = 12          ;*TotalAmount Header
  R.POS.VALUES<3>         = 4 ;*Amount Detail
  R.POS.VALUES<4>         = 1 ;*Validate Control Digit
  R.POS.VALUES<5>         = 15          ;*File State Portal
  R.POS.VALUES<6>         = 7 ;*Code BCI entity DB
  R.POS.VALUES<7>         = 8 ;*Code BCI entity CR
  R.POS.VALUES<8>         = 13          ;*Currency Code - Header record
  R.POS.VALUES<9>         = 5 ;* BATCH ID location - Header Record
*
  Y.NUM.HEADER.TAGS.BEGIN = ""
  Y.NUM.HEADER.TAGS.END   = ""
  Y.NUM.DATA.TAGS.BEGIN   = ""
  Y.NUM.DATA.TAGS.END     = ""
*
*   ID REDO.FI.CONTROL
  FI.W.REDO.FI.CONTROL.ID = ""
  FI.W.REDO.FI.CONTROL    = ""
  Y.SEQ.FILE              = ".01"
*
*   SAVE.FILE.IN.DIR
  Y.SEQ.FILE.POINTER      = ""
  Y.COUNT.FILE            = COUNT(FI.FILE.ID,".")
  Y.FILE.TXT              = FIELD(FI.FILE.ID,".",1,Y.COUNT.FILE) : ".txt"
  W.FILE.ID               = Y.FILE.TXT

*

  W.OUT.MSG               = ""
  W.CUSTOMER.INFO         = ""
  FI.INTERFACES           = ""

  FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
  F.REDO.INTERFACE.PARAM  = ""

  FN.REDO.APAP.PARAM.EMAIL = "F.REDO.APAP.PARAM.EMAIL"
  F.REDO.APAP.PARAM.EMAIL  = ""

  CALL CACHE.READ(FN.REDO.APAP.PARAM.EMAIL,'SYSTEM',R.EMAIL,MAIL.ERR)
  Y.FILE.PATH   = R.EMAIL<REDO.PRM.MAIL.IN.PATH.MAIL>
  Y.ATTACH.PATH = R.EMAIL<REDO.PRM.MAIL.ATTACH.PATH.MAIL>

  FN.HRMS.DET.FILE        = Y.FILE.PATH
  F.HRMS.DET.FILE         = ""
  CALL OPF(FN.HRMS.DET.FILE,F.HRMS.DET.FILE)

  FN.HRMS.ATTACH.FILE        = Y.ATTACH.PATH
  F.HRMS.ATTACH.FILE         = ""
  CALL OPF(FN.HRMS.ATTACH.FILE,F.HRMS.ATTACH.FILE)

  FN.REDO.ISSUE.MAIL = 'F.REDO.ISSUE.EMAIL'
  F.REDO.ISSUE.MAIL = ''
  R.REDO.ISSUE.MAIL = ''
  Y.ISSUE.EMAIL.ERR = ''
  CALL OPF(FN.REDO.ISSUE.MAIL,F.REDO.ISSUE.MAIL)

*  CALL F.READ(FN.REDO.ISSUE.MAIL,'SYSTEM',R.REDO.ISSUE.MAIL,F.REDO.ISSUE.MAIL,Y.ISSUE.EMAIL.ERR) ;*Tus Start 
CALL CACHE.READ(FN.REDO.ISSUE.MAIL,'SYSTEM',R.REDO.ISSUE.MAIL,Y.ISSUE.EMAIL.ERR) ; * Tus End
  IF R.REDO.ISSUE.MAIL THEN
    Y.FROM.MAIL.ADD.VAL =  R.REDO.ISSUE.MAIL<ISS.ML.MAIL.ID>
  END
  FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
  F.FT.TXN.TYPE.CONDITION = ''
  R.FT.TXN.TYPE.CONDITION = ''
  CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

  FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
  F.FT.COMMISSION.TYPE  = ''
  R.FT.COMMISSION.TYPE  = ''
  CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

  FN.FT.CHARGE.TYPE = 'F.FT.CHARGE.TYPE'
  F.FT.CHARGE.TYPE  = ''
  R.FT.CHARGE.TYPE  = ''
  CALL OPF(FN.FT.CHARGE.TYPE,F.FT.CHARGE.TYPE)

  CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)
  CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, FI.INTERFACE, R.REDO.INTERFACE.PARAM, Y.ERR)
  IF Y.ERR THEN
    PROCESS.GOAHEAD = 0
    E = "EB-PARAMETER.MISSING"
    CALL ERR
  END
  RIP.PARAM = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
  RIP.VALUE = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>
  DR.TXN.CODE     = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.DR.TXN.CODE>
  CR.TXN.CODE    = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.CR.TXN.CODE>
  RET.TXN.CODE    = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.RET.TXN.CODE>
  RET.TAX.CODE   = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.RET.TAX.CODE>
  Y.TO.MAIL.VALUE  = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.MAIL.ADDRESS>


  CALL F.READ(FN.FT.TXN.TYPE.CONDITION,DR.TXN.CODE,R.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION,FT.TXN.TYPE.CONDITION.ERR)
  Y.PAYROLL.COMM.TYPE       = R.FT.TXN.TYPE.CONDITION<FT6.COMM.TYPES>
  Y.PAYROLL.CHG.TYPE  = R.FT.TXN.TYPE.CONDITION<FT6.CHARGE.TYPES>
  IF Y.PAYROLL.CHG.TYPE THEN
    Y.PAYROLL.CHG.TYPE<2,-1> = 'CHG'
  END

  IF Y.PAYROLL.COMM.TYPE THEN
    CALL F.READ(FN.FT.COMMISSION.TYPE,Y.PAYROLL.COMM.TYPE,R.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE,FT.COMMISSION.TYPE.ERR)
    Y.PAY.COM.FLAT.AMT = R.FT.COMMISSION.TYPE<FT4.FLAT.AMT,1>
    Y.PAY.COM.PERCENT = R.FT.COMMISSION.TYPE<FT4.PERCENTAGE,1,1>
    Y.PAY.CATEG.ACCOUNT = R.FT.COMMISSION.TYPE<FT4.CATEGORY.ACCOUNT>
  END

  CTA.INTERMEDIA = "CTA.INTERMEDIA"
  CTA.DESTINO = "CTA.DESTINO"

  WPARAM.POS = 1
  LOCATE CTA.INTERMEDIA IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
    FI.CTA.INTERMEDIA = RIP.VALUE<1,PARAM.POS>
    WPARAM.POS   = PARAM.POS + 1
  END ELSE
    WERROR.MSG = "&.Directory.not.defined.in.&":FM:CTA.INTERMEDIA
  END

  WPARAM.POS = 1
  LOCATE CTA.DESTINO IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
    FI.CTA.DESTINO = RIP.VALUE<1,PARAM.POS>
    WPARAM.POS   = PARAM.POS + 1
  END ELSE
    WERROR.MSG = "&.Directory.not.defined.in.&":FM:CTA.DESTINO
  END

  FN.REDO.TEMP.FI.CONTROL='F.REDO.TEMP.FI.CONTROL'
  F.REDO.TEMP.FI.CONTROL =''
  CALL OPF(FN.REDO.TEMP.FI.CONTROL,F.REDO.TEMP.FI.CONTROL)

  FN.REDO.NOMINA.TEMP    ='F.REDO.NOMINA.TEMP'
  F.REDO.NOMINA.TEMP     =''
  CALL OPF(FN.REDO.NOMINA.TEMP,F.REDO.NOMINA.TEMP)

  FN.REDO.NOMINA.DET     ='F.REDO.NOMINA.DET'
  F.REDO.NOMINA.DET      =''
  CALL OPF(FN.REDO.NOMINA.DET,F.REDO.NOMINA.DET)

  RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
  LOOP.CNT            = 1
  MAX.LOOPS           = 3

  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE
    CASE LOOP.CNT EQ 1        ;*       VALIDATES XML FILE

      IF I.XML.MSG[1,5] NE "<?xml"  THEN
        O.ERROR.MSG = "EB-ERROR.THERE.ARE.NOT.XML.MSG"
      END

    CASE LOOP.CNT EQ 2        ;*        VALIDATES THAT THERE ARE HEADER TAGS

      Y.NUM.HEADER.TAGS.BEGIN  = COUNT(I.XML.MSG,C.TAG.BEGIN.HEADER)
      Y.NUM.HEADER.TAGS.END    = COUNT(I.XML.MSG,C.TAG.END.HEADER)
      IF Y.NUM.HEADER.TAGS.BEGIN   NE  Y.NUM.HEADER.TAGS.END THEN
        O.ERROR.MSG = "EB-ERROR.TAGS.HEADER.XML.MSG"
      END

    CASE LOOP.CNT EQ 3        ;*        VALIDATES THAT THERE ARE ALL DATA TAGS

      Y.NUM.DATA.TAGS.BEGIN = COUNT(I.XML.MSG,C.TAG.BEGIN.DATA)
      Y.NUM.DATA.TAGS.END   = COUNT(I.XML.MSG,C.TAG.END.DATA)
      IF Y.NUM.DATA.TAGS.BEGIN  NE  Y.NUM.DATA.TAGS.END THEN
        O.ERROR.MSG = "EB-ERROR.TAGS.DATA.XML.MSG"
      END

    END CASE
    LOOP.CNT +=1
  REPEAT

*   MESSAGE ERROR
  IF O.ERROR.MSG THEN
    GOSUB CONTROL.MSG.ERROR
  END
*
  RETURN
*

END
