*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.REP.RATES.AND.FEES.LOAD
*------------------------------------------------------------------------------------------------------------------------------------------
*
* Description           : Batch routine to report information about files

* Developed By          : Thilak Kumar K
*
* Development Reference : TC01
*
* Attached To           : Batch - BNK/REDO.B.REP.RATES.AND.FEES
*
* Attached As           : Online Batch Routine to COB
*--------------------------------------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*--------------------------------------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*  NA                    Thenmalar T                      19-Feb-2014           Modified as per clarification received
*--------------------------------------------------------------------------------------------------------------------------------------------

  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_F.DATES
  $INSERT I_BATCH.FILES
  $INSERT I_F.FUNDS.TRANSFER
  $INSERT I_F.TELLER
  $INSERT I_F.FOREX
  $INSERT I_F.FT.COMMISSION.TYPE
  $INSERT I_F.FT.CHARGE.TYPE
$INSERT I_REDO.B.REP.RATES.AND.FEES.COMMON
$INSERT I_F.REDO.H.REPORTS.PARAM
*
  GOSUB INITIALISE
*
  RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------
*
INITIALISE:
*----------
*Initialize all the files and varibles
  FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
  F.REDO.H.REPORTS.PARAM  = ''
*
  FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
  F.FUNDS.TRANSFER  = ''
*
  FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
  F.FUNDS.TRANSFER.HIS  = ''
*
  FN.FOREX = 'F.FOREX'
  F.FOREX  = ''
*
  FN.FOREX.HIS = 'F.FOREX$HIS'
  F.FOREX.HIS  = ''
*
  FN.TELLER = 'F.TELLER'
  F.TELLER = ''
*
  FN.TELLER.HIS = 'F.TELLER$HIS'
  F.TELLER.HIS = ''
*
  FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
  F.FT.COMMISSION.TYPE = ''
*
  FN.FT.CHARGE.TYPE = 'F.FT.CHARGE.TYPE'
  F.FT.CHARGE.TYPE = ''
*

  FN.REDO.L.ALL.FT.TT.FX.IDS = 'F.REDO.L.ALL.FT.TT.FX.IDS'
  F.REDO.L.ALL.FT.TT.FX.IDS = ''
  CALL OPF(FN.REDO.L.ALL.FT.TT.FX.IDS,F.REDO.L.ALL.FT.TT.FX.IDS)

  CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
  CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)
  CALL OPF(FN.TELLER,F.TELLER)
  CALL OPF(FN.TELLER.HIS,F.TELLER.HIS)
  CALL OPF(FN.FOREX,F.FOREX)
  CALL OPF(FN.FOREX.HIS,F.FOREX.HIS)
  CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
  CALL OPF(FN.FT.CHARGE.TYPE,F.FT.CHARGE.TYPE)

*
  Y.APP = "FUNDS.TRANSFER":FM:"TELLER":FM:"FOREX"

!20140410(S) - Added local ref fields - L.TT.COMM.CODE

  Y.FIELDS = "L.FT.PAY.METHOD":VM:"L.TT.COMM.CODE":FM:"L.TT.PAY.METHOD":VM:"L.TT.COMM.CODE":FM:"L.FX.PAY.METHOD"

  Y.FIELD.POS = ""
  CALL MULTI.GET.LOC.REF(Y.APP,Y.FIELDS,Y.FIELD.POS)
  L.FT.METHOD.POS = Y.FIELD.POS<1,1>
  Y.FT.COMM.CODE.POS = Y.FIELD.POS<1,2>
  L.TT.METHOD.POS = Y.FIELD.POS<2,1>
  Y.TT.COMM.CODE.POS = Y.FIELD.POS<2,2>
!20140410(E)

  L.FX.METHOD.POS = Y.FIELD.POS<3,1>
*
  Y.PARAM.ID = BATCH.DETAILS<3,1,1>
  CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,Y.PARAM.ERR)
*
  IF R.REDO.H.REPORTS.PARAM NE '' THEN
    Y.FILE.ID       = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
    Y.FILE.DIR      = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
    Y.FIELD.NAME    = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    Y.FIELD.VALUE   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
    Y.DISPLAY.TEXT  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
  END
*
  CHANGE VM TO FM IN Y.FIELD.VALUE
  CHANGE VM TO FM IN Y.DISPLAY.TEXT
*
  LOCATE "CATEGORY.FROM" IN Y.FIELD.NAME<1,1> SETTING Y.CATEG.FROM.POS THEN
    Y.CATEG.FROM = Y.FIELD.VALUE<Y.CATEG.FROM.POS>
  END
*
  LOCATE "CATEGORY.TO" IN Y.FIELD.NAME<1,1> SETTING Y.CATEG.TO.POS THEN
    Y.CATEG.TO = Y.FIELD.VALUE<Y.CATEG.TO.POS>
  END
*
  LOCATE "PAY.METHOD" IN Y.FIELD.NAME<1,1> SETTING Y.PAY.METHOD.POS THEN
    Y.PAY.METHOD   = Y.FIELD.VALUE<Y.PAY.METHOD.POS>
    Y.DISPLAY.CODES= Y.DISPLAY.TEXT<Y.PAY.METHOD.POS>
  END
*
  LOCATE "FX.PAY.METHOD" IN Y.FIELD.NAME<1,1> SETTING Y.FX.PAY.METHOD.POS THEN
    Y.FX.PAY.METHOD.VAL = Y.FIELD.VALUE<Y.FX.PAY.METHOD.POS>
    Y.FX.DISPLAY.CODES = Y.DISPLAY.TEXT<Y.FX.PAY.METHOD.POS>
  END
*
  LOCATE "FT.COMMISSION.TYPE" IN Y.FIELD.NAME<1,1> SETTING Y.FT.COMM.POS THEN
    Y.FT.COMM      = Y.FIELD.VALUE<Y.FT.COMM.POS>
    Y.FT.COMM.CODES = Y.DISPLAY.TEXT<Y.FT.COMM.POS>
  END
*
  LOCATE "PERCENTAGE" IN Y.FIELD.NAME<1,1> SETTING Y.PERC.POS THEN
    Y.PERCENTAGE = Y.FIELD.VALUE<Y.PERC.POS>
  END
*
  LOCATE "CALC.TYPE" IN Y.FIELD.NAME<1,1> SETTING Y.TYP.POS THEN
    Y.TYPE      = Y.FIELD.VALUE<Y.TYP.POS>
    Y.TYPE.CODE = Y.DISPLAY.TEXT<Y.TYP.POS>
  END
*
  LOCATE "FLAT.AMT" IN Y.FIELD.NAME<1,1> SETTING Y.FLAT.POS THEN
    Y.FLAT.TYPE = Y.FIELD.VALUE<Y.FLAT.POS>
  END
*
  Y.FILE.NAME = Y.FILE.ID:".TEMP.":SESSION.NO
*
  CHANGE VM TO '' IN Y.FILE.DIR
*
  OPENSEQ Y.FILE.DIR,Y.FILE.NAME TO SEQ.PTR ELSE
    CREATE Y.FILE.NAME ELSE
      Y.ERR.MSG   = "Unable to Open '":Y.FILE.NAME:"'"
      GOSUB RAISE.ERR.C.22
      RETURN
    END
  END
*

  Y.ONE.MONTH.PREV.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)[1,6]:01
  Y.LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)[1,6]:31

  RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------
*
RAISE.ERR.C.22:
*--------------
*Handling error process
*----------------------
*
  MON.TP    = "13"
  REC.CON   = "TC01-":Y.ERR.MSG
  DESC      = "TC01-":Y.ERR.MSG
  INT.CODE  = 'REP001'
  INT.TYPE  = 'ONLINE'
  BAT.NO    = ''
  BAT.TOT   = ''
  INFO.OR   = ''
  INFO.DE   = ''
  ID.PROC   = ''
  EX.USER   = ''
  EX.PC     = ''
  CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
  RETURN
*
*--------------------------------------------------------------------------------------------------------------------------------------------
END
