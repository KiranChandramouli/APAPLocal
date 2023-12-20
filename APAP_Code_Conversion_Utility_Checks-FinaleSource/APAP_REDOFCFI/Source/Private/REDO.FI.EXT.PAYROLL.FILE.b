* @ValidationCode : MjotMTA5Mzg5NjU2NDpDcDEyNTI6MTcwMjk5MDk0OTUxOTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 18:32:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI

SUBROUTINE REDO.FI.EXT.PAYROLL.FILE(IN.TXT.MSG,OUT.ERR.MSG)
*=====================================================================================================
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1 I TO I.VAR
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*24-10-2023		VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES         Interface Change by Santiago
*17-12-2023          VIGNESHWARI                       MANUAL R22 CODE CONVERSION            VARIABLE IS ASSIGN,OPF IS ADDED
*-----------------------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.FI.VARIABLES.COMMON
    $INSERT I_F.REDO.FI.CONTROL
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.APAP.PARAM.EMAIL
    $INSERT I_F.REDO.ISSUE.EMAIL
    $INSERT I_F.REDO.TEMP.FI.CONTROL
    $INSERT I_F.REDO.NOMINA.DET
    $USING APAP.TAM
*
*******************************************************************************************************
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
*   Principal Process
*
*   Validate File


    APAP.REDOFCFI.redoFiExtPayrollValidate(IN.TXT.MSG,Y.VAR.WORK,Y.NEW.TXT.MSG,UPD.IN.TXT.MSG,Y.ERR.MSG) ;*MANUAL R22 CODE CONVERSION
 
    IN.TXT.MSG = UPD.IN.TXT.MSG
    GOSUB CONTROL.MSG.ERROR
 
    FI.CTA.DESTINO  = Y.VAR.WORK<2>
    Y.TO.MAIL.VALUE = Y.VAR.WORK<3>
    R.REDO.NOMINA.DET<RE.NM.DET.CTA.DESTINO>    =FI.CTA.DESTINO
    R.REDO.NOMINA.DET<RE.NM.DET.INTERFACE.NAME> =FI.INTERFACE
    R.REDO.NOMINA.DET<RE.NM.DET.INTERFACE.TYPE> ='EXTNOMINA'

    GOSUB RECORD.FI.CONTROL

    IF Y.ERR.MSG EQ ''  THEN

        GOSUB SAVE.FILE.IN.DIR
        Y.ERR.MSG = ''
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STATUS>       = Y.FINAL.STATUS
        APAP.REDOFCFI.redoFiRecordControl(Y.ERR.MSG) ;* MANUAL R22 CODE CONVERSION
    END
    IF Y.ERR.MSG THEN
        GOSUB MAIL.GENERATION
    END
*
RETURN
*
* ---------------
MAIL.GENERATION:
* ---------------

    Y.TRANS.DATE = TODAY
    Y.TRANS.TIME = OCONV(TIME(), "MT")
    CHANGE ":" TO '' IN Y.TRANS.TIME
    Y.UNIQUE.ID = FI.W.REDO.FI.CONTROL.ID:"_":Y.TRANS.DATE:"_":Y.TRANS.TIME
    Y.REQUEST.FILE = Y.UNIQUE.ID:'.TXT'
    Y.ATTACH.FILENAME = 'ATTACHMENT':'_':Y.UNIQUE.ID:'.TXT'
    R.RECORD1 = ''
    Y.REF.FILE.NAME =  'EXTERNAL NOMINA STATUS'
    APAP.REDOFCFI.redoFiMailFormatGen(FI.W.REDO.FI.CONTROL.ID,Y.MAIL.DESCRIPTION) ;* MANUAL R22 CODE CONVERSION
    R.RECORD1 = Y.FROM.MAIL.ADD.VAL:"#":Y.TO.MAIL.VALUE:'#':Y.REF.FILE.NAME:'#':Y.REF.FILE.NAME
    IF Y.MAIL.MSG THEN
        WRITE Y.MAIL.DESCRIPTION TO F.HRMS.ATTACH.FILE,Y.ATTACH.FILENAME
    END ELSE
        WRITE IN.TXT.MSG TO F.HRMS.ATTACH.FILE,Y.ATTACH.FILENAME
    END
    WRITE R.RECORD1 TO F.HRMS.DET.FILE,Y.REQUEST.FILE

RETURN

* ----------------
RECORD.FI.CONTROL:
* ----------------
*
*   Total Records
    Y.COUNT.NEW.TXT = DCOUNT(Y.NEW.TXT.MSG,@FM)
    FI.W.REDO.FI.CONTROL.ID  = Y.VAR.WORK<1>

*   Redo.Fi.Control
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.FILE.NAME>        = FI.FILE.ID
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.FILE.DIR>         = FI.WORK.DIR
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROCESS.CONFIRM>  = FI.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.AUT.AVAIL.FUNDS>
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.DATE>        = TODAY
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.TIME>        = FIELD(TIMEDATE()," ",1)
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORD.FILE>  = FI.DATO.NUM.REG
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.AMOUNT.FILE>  = FI.DATO.MONTO.TOTAL
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORD.CALC>  = FI.CALC.NUM.REG
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.AMOUNT.CALC>  = FI.CALC.MONTO.TOTAL
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STATUS>      = "CARGA NO FALLIDA"
*   If there is a Msg Error set the status and description of the cause
    IF Y.ERR.MSG THEN
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STATUS>      = "CARGA FALLIDA"
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STAT.D>      = Y.ERR.MSG
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORDS.OK>   = 0
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC.OK>   = 0
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORD.PROC>  = 0
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC>      = 0
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORDS.FAIL> = 0
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC.FAIL> = 0
    END
*   Save in Redo.Fi.Control
    APAP.REDOFCFI.redoFiRecordControl(Y.ERR.MSG) ;* MANUAL R22 CODE CONVERSION

RETURN
*
* ---------------
SAVE.FILE.IN.DIR:
* ---------------
*

    CONTADO.EXTRA = Y.COUNT.NEW.TXT + 1
    W.TOL.FILE.AMT = FIELD(IN.TXT.MSG<1>,',',4)

* Debit to enterprise account
    R.PARAM<1>  = "NULL"
    R.PARAM<2>  = "N"
    R.PARAM<3>  = W.TOL.FILE.AMT
    R.PARAM<4>  = FI.FILE.ID
    R.PARAM<5>  = FI.INTERFACE
    R.PARAM<6>  = FI.CTA.DESTINO          ;*this account is from extnomina
    R.PARAM<7>  = W.TOL.FILE.AMT
    R.PARAM<8>  = "DOP"
    R.PARAM<9>  = FI.W.REDO.FI.CONTROL.ID
    R.PARAM<10> = "S"
    R.PARAM<11> = FI.CTA.INTERMEDIA

    IF FI.INTERFACE EQ 'EXTNOMINA' THEN
        R.PARAM<12> = "NOMINAEXT"
    END ELSE
        R.PARAM<12> = "NOMINAEXTNOTAX"
    END

    R.PARAM<13> = DR.TXN.CODE

    WRECORD.NUMBER        = CONTADO.EXTRA
    W.ADDITIONAL.INFO     = ""
    W.ADDITIONAL.INFO<1>  = FI.BATCH.ID : "." : WRECORD.NUMBER          ;* THEIR.REFERENCE
    W.ADDITIONAL.INFO<2>  = FI.BATCH.ID : "." : WRECORD.NUMBER          ;* OUR.REFERENCE
    W.ADDITIONAL.INFO<3>  = FI.INTERFACE : "." : FI.BATCH.ID  ;* NARRATIVE
    W.ADDITIONAL.INFO<4>  = FI.W.REDO.FI.CONTROL.ID ;* TRANS.REFERENCE
    W.ADDITIONAL.INFO<5>  = WRECORD.NUMBER          ;* BATCH.ID
    W.ADDITIONAL.INFO     = CHANGE(W.ADDITIONAL.INFO,@FM,",")

    Y.STT.REC        = ""
    Y.IN.MSG         = FI.CTA.DESTINO:",":FI.DATO.MONTO.TOTAL:",DOP,-"
    Y.NEW.TXT.MSG<CONTADO.EXTRA> = Y.IN.MSG:",":W.ADDITIONAL.INFO
	;*CAMBIO	;*Interface Change by Santiago-start
    ;*APAP.REDOFCFI.redoFiMsgFormat(FI.INTERFACE,Y.NEW.TXT.MSG<CONTADO.EXTRA>,DATO.OUT) ;* MANUAL R22 CODE CONVERSION
	;*CAMBIO
	DATO.OUT = Y.NEW.TXT.MSG<CONTADO.EXTRA>	;*Interface Change by Santiago-end
	
    IF W.TOL.FILE.AMT GT 0 THEN

*APAP.TAM.REDO.FI.EXT.DEBIT.PROCES(R.PARAM, OUT.RESP, OUT.ERR)

        APAP.TAM.redoFiExtDebitProces(R.PARAM, OUT.RESP, OUT.ERR);* MANUAL R22 CODE CONVERSION
        Y.PARENT.FT.REF = OUT.RESP
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.PARENT.FT.REF> = Y.PARENT.FT.REF

        IF  FIELD(OUT.ERR,'/',1)[1,2] NE 'FT' THEN
            Y.ERR.MSG = OUT.ERR
            Y.STT.REC = "FALLIDO"
            Y.FINAL.STATUS = "FALLIDO"
            FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STAT.D>  = OUT.ERR<1>
            GOSUB CONTROL.MSG.ERROR
            RETURN
        END ELSE
            Y.STT.REC = "PROCESADO"
            Y.FINAL.STATUS ="PROCESADO"
        END

    END ELSE
        E = "EB-ERROR.NONE.FT.APPLIED"
        Y.ERR.MSG = E
        Y.STT.REC = "FALLIDO"
        Y.FINAL.STATUS = "FALLIDO"
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STAT.D>  = Y.ERR.MSG
        GOSUB CONTROL.MSG.ERROR
        RETURN
    END

    I.VAR = CONTADO.EXTRA
    GOSUB REPORT.FORMAT

    FOR I.VAR = 1 TO Y.COUNT.NEW.TXT
        OUT.RESP     = ''
        OUT.RESP<1>  = ''
        Y.PRESENT.CNT=I.VAR
        GOSUB APPEND.ADDITIONAL.INFO
        GOSUB MESSAGE.FORMAT
    NEXT
    CALL F.WRITE(FN.REDO.NOMINA.TEMP,FI.W.REDO.FI.CONTROL.ID,R.REDO.NOMINA.TEMP)
    CALL F.WRITE(FN.REDO.NOMINA.DET,FI.W.REDO.FI.CONTROL.ID,R.REDO.NOMINA.DET)
RETURN
* ---------------------
APPEND.ADDITIONAL.INFO:
* ---------------------
*
* Paragraph that add data to send to the FT
*

    WRECORD.NUMBER        = I.VAR
    W.ADDITIONAL.INFO     = ""
    W.ADDITIONAL.INFO<1>  = FI.BATCH.ID : "." : WRECORD.NUMBER          ;* THEIR.REFERENCE
    W.ADDITIONAL.INFO<2>  = FI.BATCH.ID : "." : WRECORD.NUMBER          ;* OUR.REFERENCE
    W.ADDITIONAL.INFO<3>  = FI.INTERFACE : "." : FI.BATCH.ID  ;* NARRATIVE
    W.ADDITIONAL.INFO<4>  = FI.W.REDO.FI.CONTROL.ID ;* TRANS.REFERENCE
    W.ADDITIONAL.INFO<5>  = WRECORD.NUMBER          ;* BATCH.ID
    W.ADDITIONAL.INFO     = CHANGE(W.ADDITIONAL.INFO,@FM,",")
*
RETURN
*
* =============
MESSAGE.FORMAT:
* =============
*
*   Paragraph to set message format to AC.ENTRY.PARAM
*

    Y.STT.REC        = ""
    Y.IN.MSG         = Y.NEW.TXT.MSG<I.VAR>
    Y.NEW.TXT.MSG<I.VAR> = Y.NEW.TXT.MSG<I.VAR>:",":W.ADDITIONAL.INFO
	
	;*CAMBIO ;*Interface Change by Santiago-start
    ;*APAP.REDOFCFI.redoFiMsgFormat(FI.INTERFACE,Y.NEW.TXT.MSG<I.VAR>,DATO.OUT) ;* MANUAL R22 CODE CONVERSION
	
	
	DATO.OUT = Y.NEW.TXT.MSG<I.VAR>	;*Interface Change by Santiago-end
    R.PARAM<1>  = "NULL"
    R.PARAM<2>  = "N"
	DATO3 = FIELD(DATO.OUT,",",2) ;*Interface Change by Santiago
    R.PARAM<3>  = FIELD(DATO.OUT,",",2) ;*Interface Change by Santiago
    R.PARAM<4>  = FI.FILE.ID
    R.PARAM<5>  = FI.INTERFACE
    R.PARAM<6>  = FI.CTA.INTERMEDIA
	DATO7 = FIELD(DATO.OUT,",",2) 	;*Interface Change by Santiago-start
    R.PARAM<7>  = FIELD(DATO.OUT,",",2)
	DATO8 = FIELD(DATO.OUT,",",3)
    R.PARAM<8>  = FIELD(DATO.OUT,",",3)	;*Interface Change by Santiago-end
    R.PARAM<9>  = FI.W.REDO.FI.CONTROL.ID
    R.PARAM<10> = "N"
	DATO11 = FIELD(DATO.OUT,",",1)	;*Interface Change by Santiago
    R.PARAM<11> = FIELD(DATO.OUT,",",1)	;*Interface Change by Santiago
    R.PARAM<12> = "NOMINA"
    R.PARAM<13> = CR.TXN.CODE
;*CAMBIO	;*Interface Change by Santiago

    Y.TEMP.ID=FI.W.REDO.FI.CONTROL.ID:STR("0",(5-LEN(Y.PRESENT.CNT))):Y.PRESENT.CNT
    R.REDO.NOMINA.TEMP<-1>=Y.TEMP.ID
    CHANGE @FM TO @VM IN R.PARAM
    R.REDO.TEMP.FI.CONTROL<FI.TEMP.PARAM.VAL>=R.PARAM
    R.REDO.TEMP.FI.CONTROL<FI.TEMP.STATUS>   =''
    R.REDO.TEMP.FI.CONTROL<FI.TEMP.MAIL.MSG>  =IN.TXT.MSG<I.VAR+1>
    R.REDO.TEMP.FI.CONTROL<FI.TEMP.INTER.TYPE>='EXTNOMINA'
    CALL F.WRITE(FN.REDO.TEMP.FI.CONTROL,Y.TEMP.ID,R.REDO.TEMP.FI.CONTROL)

*
RETURN
*
* ============
REPORT.FORMAT:
* ============
*
*   Paragraph to set report message to REDO.FI.E.REPORT
*   and save log in REDO.INTERFACE.REC.ACT
*
*

    IF Y.ERR.MSG NE "" THEN
        W.STATUS       = "04"
        W.RESP.MSG    = Y.ERR.MSG
        Y.MAIL.MSG<-1> = IN.TXT.MSG<I.VAR+1>:'-':'FAILURE'


    END ELSE
        W.STATUS          = "01"
        W.RESP.MSG       = "OK"
        W.TOTAL.TRANSACC += R.PARAM<3>
        Y.MAIL.MSG<-1>    = IN.TXT.MSG<I.VAR+1>:'-':'SUCCESS'
    END

    Y.ID.RCL  = FI.INTERFACE:".R"         ;*The id is NOMINA.R
    Y.TOT.REC = Y.COUNT - 1
    Y.IN.MSG  = WRECORD.NUMBER:",":Y.IN.MSG:",":W.STATUS:",":Y.ERR.MSG

 
*
*  Call RCL to set data to send report
    ;*CAMBIO	;*Interface Change by Santiago-start
    ;*APAP.REDOFCFI.redoFiMsgFormat(Y.ID.RCL,Y.IN.MSG,Y.OUT.MSG) ;* MANUAL R22 CODE CONVERSION
	;*CAMBIO	;*Interface Change by Santiago-end
*  Save record in log tabla REDO.INTERFACE.REC.ACT


	Y.OUT.MSG = Y.IN.MSG	;*Interface Change by Santiago

    FI.INTERFACES = FI.INTERFACE:".INT"
    FI.INT.ACT.ID = "ENM001"

    Y.OUT.MSG = Y.OUT.MSG :"@":W.RESP.MSG:"@":OUT.RESP<1>

*
RETURN
*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
*   Paragraph that record the error message and move the file to the rejected directory renaming the file
*
    IF Y.ERR.MSG THEN
        ETEXT            = Y.ERR.MSG
        OUT.ERR.MSG      = Y.ERR.MSG
        Y.NAME.DIR       = FI.PATH.REJ
    END
*
    IF ETEXT THEN
        PROCESS.GOAHEAD = 0
        OUT.ERR.MSG     = ""
        CALL STORE.END.ERROR
        OUT.ERR.MSG     = ETEXT
        ETEXT           = ""
    END
*

    IF OUT.ERR.MSG NE "" THEN
        Y.FILE.ID = CHANGE(FI.FILE.ID,".txt",".rej")
        OPENSEQ FI.PATH.REJ, Y.FILE.ID TO Y.SEQ.FILE.POINTER ELSE
            CREATE Y.SEQ.FILE.POINTER ELSE
                OUT.ERR.MSG = "Error.Opening.Output.File"
            END
        END

        OPENSEQ FI.PATH.REJ, Y.FILE.ID TO Y.SEQ.FILE.POINTER ELSE
            CREATE Y.SEQ.FILE.POINTER ELSE
                OUT.ERR.MSG = "Error.Opening.Output.File"
            END
        END

        WRITESEQ IN.TXT.MSG TO Y.SEQ.FILE.POINTER ELSE
            OUT.ERR.MSG = "Error.Writing.To.Output.File"
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
*   General Variables
    FI.W.REDO.FI.CONTROL = ''
    PROCESS.GOAHEAD      = 1
    LOOP.CNT             = 1
    MAX.LOOPS            = 1
*   MessageTXT
    Y.SEPARATOR.REC      = CHARX(13):CHARX(10)        ;*CHAR(13) is CR, CHAR(13) is LF ;* AUTO R22 CODE CONVERSION CHAR TO CHARX
    IN.TXT.MSG           = CHANGE(IN.TXT.MSG,Y.SEPARATOR.REC,@FM)
    Y.COUNT              = COUNT(IN.TXT.MSG,@FM)
    Y.COUNT.NEW.TXT      = 0
*   Parameters to send
    Y.VAR.WORK           = ""
    Y.NEW.TXT.MSG        = ""
*   Save.File.In.Dir
    Y.ERR.MSG            = ""
    Y.FILE.ID            = ""
    Y.SEQ.FILE.POINTER   = ""
    DATO.OUT             = ""
    R.PARAM              = ""
*
    Y.IN.MSG             = ""
    Y.OUT.MSG            = ""
    Y.STT.REC            = "PROCESADO"
    W.STATUS             = "01"
*
    FI.INTERFACES        = ""
    OUT.ERR.MSG          = ""
*
    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
    F.REDO.INTERFACE.PARAM = ""
*
    FN.REDO.APAP.PARAM.EMAIL = "F.REDO.APAP.PARAM.EMAIL"
    F.REDO.APAP.PARAM.EMAIL  = ""
    CALL OPF(FN.REDO.APAP.PARAM.EMAIL,F.REDO.APAP.PARAM.EMAIL);*MANUAL R22 CODE CONVERSION -OPF IS ADDED
    ID.VAR='SYSTEM'
    CALL CACHE.READ(FN.REDO.APAP.PARAM.EMAIL,'SYSTEM',R.EMAIL,MAIL.ERR);*MANUAL R22 CODE CONVERSION  - VARIABLE IS ASSIGN
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
    CALL CACHE.READ(FN.REDO.ISSUE.MAIL,ID.VAR,R.REDO.ISSUE.MAIL,Y.ISSUE.EMAIL.ERR) ; * Tus End  ;*MANUAL R22 CODE CONVERSION- VARIABLE IS ASSIGN
    IF R.REDO.ISSUE.MAIL THEN
        Y.FROM.MAIL.ADD.VAL =  R.REDO.ISSUE.MAIL<ISS.ML.MAIL.ID>
    END


    FN.REDO.TEMP.FI.CONTROL='F.REDO.TEMP.FI.CONTROL'
    F.REDO.TEMP.FI.CONTROL =''
    CALL OPF(FN.REDO.TEMP.FI.CONTROL,F.REDO.TEMP.FI.CONTROL)

    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)
    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, FI.INTERFACE, R.REDO.INTERFACE.PARAM, Y.ERR)
    IF Y.ERR THEN
        PROCESS.GOAHEAD = 0
        E = "EB-PARAMETER.MISSING"
        CALL ERR
    END

    FN.REDO.NOMINA.TEMP='F.REDO.NOMINA.TEMP'
    F.REDO.NOMINA.TEMP =''
    CALL OPF(FN.REDO.NOMINA.TEMP,F.REDO.NOMINA.TEMP)

    FN.REDO.NOMINA.DET ='F.REDO.NOMINA.DET'
    F.REDO.NOMINA.DET  =''
    CALL OPF(FN.REDO.NOMINA.DET,F.REDO.NOMINA.DET)

    RIP.PARAM        = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    RIP.VALUE        = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>
    DR.TXN.CODE      = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.DR.TXN.CODE>
    CR.TXN.CODE      = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.CR.TXN.CODE>
    RET.TXN.CODE     = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.RET.TXN.CODE>
    RET.TAX.CODE     = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.RET.TAX.CODE>

    CTA.INTERMEDIA = "CTA.INTERMEDIA"
* The bussiness account for debits is token from the concern record in REDO.INTERFACE.PARAM wich use the same ID as the company

    WPARAM.POS = 1
    LOCATE CTA.INTERMEDIA IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
        FI.CTA.INTERMEDIA = RIP.VALUE<1,PARAM.POS>
        WPARAM.POS   = PARAM.POS + 1
    END ELSE
        WERROR.MSG = "&.Intermediate.Account.not.defined.in.&":@FM:CTA.INTERMEDIA
    END

RETURN
*

*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 1
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1        ;*    Validate TXT file exists
                IF IN.TXT.MSG EQ "" THEN
                    Y.ERR.MSG =  "File.Is.Empty"
                END
        END CASE
*Message Error
        GOSUB CONTROL.MSG.ERROR
*Increase
        LOOP.CNT +=1
    REPEAT
*
RETURN

END
