*-----------------------------------------------------------------------------
* <Rating>-143</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FI.VALIDATE.HEAD.AND.DATA(Y.INP.TXT.MSG, I.R.POS.VALUES, O.R.VALUES, O.ERROR.MSG)
******************************************************************************
*    Routine to validate the header and detail
*    Parameters:
*        Y.INP.TXT.MSG:    Input parameter to recived the TXT message
*        I.R.POS.VALUES: Input with the positions the record to validate
*                 POS<1> = Position the Total Records field in the header
*                 POS<2> = Position the Total Amount field in the header
*                 POS<3> = Position the Amount field in the detail
*                 POS<4> = Flag to indicate the control.digit has to be verify or no values: 0-No/1-Yes validate
*                 POS<5> = Position the EstadoArchivoEnPortal in the header has allways to be NUEVO.
*              POS<6> = Position the Code BCI entity DB in the header
*                 POS<7> = Position the Code BCI entity CR in the header
*      POS<8> = Currency code position in header record
*      POS<9> = BATCH ID position in header record
*        O.R.VALUES:     Output array with the values
*                 POS<1> = Total Records of the header
*                 POS<2> = Total Amount  of the header
*                 POS<3> = Calculate Total Records
*                 POS<4> = Calculate Total Amount
*                 POS<5> = Flag to indicate the sequential of file. Values: (0)seq.001 / (1)seq.002
*        O.ERR.MSG:      Output parameter to send the ERROR message get in the process
* =============================================================================
*
*    First Release : R09
*    Developed for : APAP
*    Developed by  : Ana Noriega
*    Date          : 2010/Oct/21
*
* Modifications:
* 20/05/2012 - cherrera@temenos.com
*              Some APAP issues about report format and FT validations
*=======================================================================
*
$INSERT I_COMMON
$INSERT I_EQUATE
*
$INSERT I_REDO.FI.VARIABLES.COMMON
$INSERT I_F.REDO.FI.CONTROL
*
*************************************************************************
*
  GOSUB INITIALISE
  GOSUB OPEN.FILES
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



  Y.INP.TXT.MSG = Y.DUMMY
*
  FOR I = 1 TO  Y.COUNT
*
    Y.INP.TXT.MSG = Y.DUMMY
    R.TXT.MSG = Y.INP.TXT.MSG<I>
*
    IF I = 1 THEN
      GOSUB A100.HEADER.VALIDATIONS
    END ELSE
      GOSUB A120.DETAIL.VALIDATIONS
    END
  NEXT I

*Validate Total Records y Amount
  IF O.R.VALUES<1>  NE  O.R.VALUES<3> THEN
    ERR.TEXT = "EB-ERROR.RECORDS.DATA":FM:O.R.VALUES<1>:VM:O.R.VALUES<3>
  END
  IF O.R.VALUES<2>  NE  O.R.VALUES<4> THEN
    ERR.TEXT = "EB-ERROR.AMOUNT.DATA":FM:O.R.VALUES<2>:VM:O.R.VALUES<4>
  END

  FI.DATO.NUM.REG     += O.R.VALUES<1>
  FI.DATO.MONTO.TOTAL += O.R.VALUES<2>
  FI.CALC.NUM.REG     += O.R.VALUES<3>
  FI.CALC.MONTO.TOTAL += O.R.VALUES<4>

  FI.DATO.NUM.REG      = FMT(FI.DATO.NUM.REG,"R,#15")
  FI.DATO.MONTO.TOTAL  = FMT(FI.DATO.MONTO.TOTAL,"R2,#15")
  FI.CALC.NUM.REG      = FMT(FI.CALC.NUM.REG,"R,#15")
  FI.CALC.MONTO.TOTAL  = FMT(FI.CALC.MONTO.TOTAL,"R2,#15")

*   MESSAGE ERROR
  GOSUB CONTROL.MSG.ERROR

*
  RETURN
*
* ======================
A100.HEADER.VALIDATIONS:
* ======================
*
*       H E A D E R      V A L I D A T I O N S
*
*Total Records y Amount
  O.R.VALUES<1>    = FIELD(R.TXT.MSG,",",I.R.POS.VALUES<1>)
  O.R.VALUES<2>    = FIELD(R.TXT.MSG,",",I.R.POS.VALUES<2>)
  FI.FILE.CURRENCY = FIELD(R.TXT.MSG,",",I.R.POS.VALUES<8>)
  FI.BATCH.ID      = FIELD(R.TXT.MSG,",",I.R.POS.VALUES<9>)

*Validate Record in Redo.Fi.Control
  IF PROCESS.GOAHEAD THEN
    GOSUB VALIDATE.ID.CONTROL
  END

*File State Portal
  IF PROCESS.GOAHEAD THEN
    GOSUB FILE.STATE.PORTAL
  END

*Validate Code BCI
  IF PROCESS.GOAHEAD THEN
    GOSUB VALIDATE.CODE.BCI
  END

*Validate Currency
  IF PROCESS.GOAHEAD THEN
    GOSUB VALIDATE.CURRENCY
  END

*
  RETURN
*
* ======================
A120.DETAIL.VALIDATIONS:
* ======================
*
*       D E T A I L       R E C O R D     V A L I D A T I O N S
*
*Total Records y Amount
  O.R.VALUES<3>  += 1
  O.R.VALUES<4>  += FIELD(R.TXT.MSG,",",I.R.POS.VALUES<3>)

*Contol Digit
  IF PROCESS.GOAHEAD THEN
*GOSUB CONTROL.DIGIT
  END

*Check Digit in Account
  W.STD.ACCOUNT = FIELD(R.TXT.MSG,",",4)
*CALL REDO.FI.CALC.CHECK.DIGIT(W.STD.ACCOUNT,WERROR.MSG)
*
  RETURN
*
* ================
VALIDATE.ID.CONTROL:
* ================
*
*   Paragraph that validate the ID in REDO.FI.CONTROL that not exist other the same
*
  O.R.VALUES<5> = "0"

*Read record
  CALL F.READ(FN.REDO.FI.CON, Y.REDO.FI.CON.ID, R.REDO.FI.CON, F.REDO.FI.CON, Y.ERR.REDO.FI.CON)
  IF R.REDO.FI.CON NE "" THEN
    Y.PROC.STATUS = R.REDO.FI.CON<REDO.FI.CON.PROC.STATUS>
    IF Y.PROC.STATUS EQ 'PROCESADO' THEN
      ERR.TEXT = 'EB-ERROR.RECORD.ALREADY.EXISTS'
      O.R.VALUES<5> = "1"     ;*Indicate sequential
    END
  END

*
  RETURN
*
* ---------------
FILE.STATE.PORTAL:
* ---------------
*
*   Paragraph that validate the value of State File Portal is equal to NUEVO

  IF I.R.POS.VALUES<5> NE "" THEN
    Y.STATE.PORTAL.CAL = FIELD(R.TXT.MSG,",",I.R.POS.VALUES<5>)
    IF Y.STATE.PORTAL.ORG NE Y.STATE.PORTAL.CAL THEN
      ERR.TEXT = "EB-ERROR.FILE.STATE.PORTAL"
    END
  END
*
  RETURN
*
*
* ---------------
VALIDATE.CODE.BCI:
* ---------------
*
*
*   Paragraph that validate the Code BCI

  IF I.R.POS.VALUES<6> NE "" AND I.R.POS.VALUES<7> NE "" THEN
    Y.CODE.BCI.DB.ORG  = FIELD(R.TXT.MSG,",",I.R.POS.VALUES<6>)
    Y.CODE.BCI.CR.ORG  = FIELD(R.TXT.MSG,",",I.R.POS.VALUES<7>)

*Calculate code BCI
    Y.CODE.BCI.DB.CAL = Y.CODE.BCI.DB.ORG
    Y.CODE.BCI.CR.CAL = Y.CODE.BCI.CR.ORG

*Validate
    IF Y.CODE.BCI.DB.ORG NE Y.CODE.BCI.DB.CAL THEN
      ERR.TEXT = "EB-ERROR.CODE.BCI.DB"
    END
    IF Y.CODE.BCI.CR.ORG NE Y.CODE.BCI.CR.CAL THEN
      ERR.TEXT = "EB-ERROR.CODE.BCI.CR"
    END
  END
*
  RETURN
*
* ================
VALIDATE.CURRENCY:
* ================
*
  IF NOT(FI.FILE.CURRENCY) THEN
    ERR.TEXT="CURRENCY.FIELD.EMPTY"
  END
*
  RETURN
*
* ------------
CONTROL.DIGIT:
* ------------
*
*   Paragraph that invokes the routine REDO.FI.CONTROL.DIGIT to get de Control.Digit an verify this value IN EACH RECORD
*

  IF I.R.POS.VALUES<4> EQ 1 THEN
    Y.COUNT.COMMA    = DCOUNT(R.TXT.MSG,",")
    Y.TEXT           = FIELD(R.TXT.MSG,",",1,Y.COUNT.COMMA-1)         ;*Remove Control Digit
    Y.CTRL.DIGIT.ORG = FIELD(R.TXT.MSG,",",Y.COUNT.COMMA)   ;*Get  Control Digit
    Y.TEXT           = CHANGE(Y.TEXT,",","")
    Y.TEXT.LEN       = LEN(Y.TEXT)
    Y.TEXT           = SUBSTRINGS(Y.TEXT,2,Y.TEXT.LEN)      ;*Remove D,

    CALL REDO.FI.CONTROL.DIGIT(Y.TEXT, Y.CTRL.DIGIT.CAL, O.ERROR.MSG)
*
    IF O.ERROR.MSG NE "" OR Y.CTRL.DIGIT.ORG NE Y.CTRL.DIGIT.CAL THEN
      ERR.TEXT = "EB-ERROR.CONTROL.DIGIT.WRONG"
    END
*
  END
*
  RETURN
*
*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
*   Paragraph
  IF ERR.TEXT NE "" THEN
    PROCESS.GOAHEAD = 0
    ETEXT           = ERR.TEXT
    WTEXT = ETEXT
    CALL TXT(WTEXT)
    O.ERR.MSG       = ""
    CALL STORE.END.ERROR
    O.ERROR.MSG     = WTEXT
    ETEXT           = ""
  END
*
  RETURN
*
* ---------
INITIALISE:
* ---------
*
*   WORK VARIABLES
  PROCESS.GOAHEAD     = 1
  LOOP.CNT            = 1
  MAX.LOOPS           = 1
  Y.DUMMY             = Y.INP.TXT.MSG
  Y.COUNT             = COUNT(Y.DUMMY,@FM)
  O.R.VALUES          = 0
  FI.DATO.NUM.REG     = 0
  FI.DATO.MONTO.TOTAL = 0
  FI.CALC.NUM.REG     = 0
  FI.CALC.MONTO.TOTAL = 0
*   HEAD
  Y.RECORDS           = 0
  Y.AMOUNT            = 0
*   DETAIL
  Y.TOT.RECORDS       = 0
  Y.TOT.AMOUNT        = 0
*   FILE.STATE.PORTAL
  Y.STATE.PORTAL.CAL  = ""
  Y.STATE.PORTAL.ORG  = "NUEVO"
*   VALIDATE.CODE.BCI
  Y.CODE.BCI.DB.CAL   = ""
  Y.CODE.BCI.DB.ORG   = ""
  Y.CODE.BCI.CR.CAL   = ""
  Y.CODE.BCI.CR.ORG   = ""
*   CONTROL DIGIT
  Y.COUNT.COMMA       = ""
  Y.TEXT              = ""
  Y.CTRL.DIGIT.ORG    = ""
  Y.CTRL.DIGIT.CAL    = ""
* RECORD IN REDO.FI.CONTROL
  Y.SEQ.FILE          = ".01"
  FN.REDO.FI.CON      = "F.REDO.FI.CONTROL"
  F.REDO.FI.CON       = ""
  Y.REDO.FI.CON.ID    = FI.INTERFACE:".":FIELD(Y.DUMMY<1>,",",I.R.POS.VALUES<9>):Y.SEQ.FILE
  Y.ERR.REDO.FI.CON   = ""
  R.REDO.FI.CON       = ""
  ERR.TEXT            = ""

*
  RETURN
*
*
* ---------
OPEN.FILES:
* ---------
*
*   OPEN  REDO.FI.CONTROL
  CALL OPF(FN.REDO.FI.CON,F.REDO.FI.CON)
*
  RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*

  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE
    CASE LOOP.CNT EQ 1
*       VALIDATES TXT MSG
      Y.INP.TXT.MSG = Y.DUMMY
      IF Y.INP.TXT.MSG EQ "" THEN
        ERR.TEXT = "EB-ERROR.THERE.ARE.NOT.TXT.MSG"
      END
    END CASE
    LOOP.CNT +=1
  REPEAT

*   MESSAGE ERROR
  GOSUB CONTROL.MSG.ERROR
*
  RETURN
*
END
