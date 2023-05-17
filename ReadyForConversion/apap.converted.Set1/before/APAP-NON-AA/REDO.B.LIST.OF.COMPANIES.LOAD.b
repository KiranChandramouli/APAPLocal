*-----------------------------------------------------------------------------
* <Rating>-87</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.LIST.OF.COMPANIES.LOAD
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine the report which contains companies where Directors and Officers have 10% or more share
*
* Developed By          : Mayurika Tiwary, Capgemini
*
* Development Reference : MV31
*
* Attached To           : Batch - BNK/REDO.B.LIST.OF.COMPANIES
*
* Attached As           : Multi Threaded Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : CUSTOMER.ID - Contains the Customer Number
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#2 : NA
*
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* MV31                   Mayurika Tiwary                 2014-02-14           Initial Draft
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.LIST.OF.COMPANIES.COMMON
$INSERT I_F.REDO.H.REPORTS.PARAM
$INSERT I_REDO.GENERIC.FIELD.POS.COMMON
$INSERT I_BATCH.FILES
*-----------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* The execution of the program begins here.
**

  GOSUB OPEN.PARA
  GOSUB PROCESS.PARA

  RETURN
*-----------------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* All the required files are opened here.
**
  FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
  F.REDO.H.REPORTS.PARAM  = ''
  CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER  = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.RELATION.CUSTOMER = 'F.RELATION.CUSTOMER'
  F.RELATION.CUSTOMER  = ''
  CALL OPF(FN.RELATION.CUSTOMER,F.RELATION.CUSTOMER)

  RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* The execution flow of the routine is mentioned here.
**
  GOSUB GET.PARAM.DETAILS
  GOSUB GET.RELATION.CODES
  GOSUB GET.REPORT.GEN.MONTH
  GOSUB OPEN.TEMP.PATH
  GOSUB GET.MULTI.LOCAL.REF

  RETURN
*-----------------------------------------------------------------------------------------------------------------
******************
GET.PARAM.DETAILS:
******************
* Here all the parameter details sre extracted using parameter id from parameter record.
**
  REDO.H.REPORTS.PARAM.ID = BATCH.DETAILS<3,1,1>

  CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
  IF R.REDO.H.REPORTS.PARAM THEN
    FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
    TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
    OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    FIELD.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
    DISPLAY.TEXT = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
    FILE.NAME = FILE.NAME:'TEMP':SESSION.NO
  END

  RETURN
*-----------------------------------------------------------------------------------------------------------------
*******************
GET.RELATION.CODES:
*******************
* Here all the relational codes are extracted from parameter record.
**
  LOCATE 'FL.SEL.CODES' IN FIELD.NAME<1,1> SETTING FL.FOUND.POS THEN
    FL.PARAM.SEL.CODES  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,FL.FOUND.POS>
    FL.PARAM.DISP.CODES = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,FL.FOUND.POS>
  END

  LOCATE 'SL.SEL.CODES' IN FIELD.NAME<1,1> SETTING SL.FOUND.POS THEN
    SL.PARAM.SEL.CODES = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,SL.FOUND.POS>
  END

  LOCATE 'APAP.CUST.NO' IN FIELD.NAME<1,1> SETTING CU.FOUND.POS THEN
    Y.APAP.CUST.NO=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,CU.FOUND.POS>
  END

  RETURN
*-----------------------------------------------------------------------------------------------------------------
*********************
GET.REPORT.GEN.MONTH:
*********************
* Here all the report generation month value is extracted from parameter record.
**
  LOCATE 'REP.GEN.MONTH' IN FIELD.NAME<1,1> SETTING GEN.FOUND.POS THEN
    REP.GEN.MONTHS = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,GEN.FOUND.POS>
  END

  RETURN
*-----------------------------------------------------------------------------------------------------------------
***************
OPEN.TEMP.PATH:
***************
* Here the sequential file is opened else fatal error is handled.
**
  OPENSEQ TEMP.PATH,FILE.NAME TO SEQ.PTR ELSE
    ERR.MSG = "UNABLE TO OPEN'":FILE.NAME:"'"
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    MON.TP = 04
    REC.CON = 'MV31-':ERR.MSG
    DESC = 'MV31-':ERR.MSG
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
  END

  RETURN
*-----------------------------------------------------------------------------------------------------------------
********************
GET.MULTI.LOCAL.REF:
********************
* The multiple local field values are fetched by extracting their respective position values.
**
  APPL.NAME = 'CUSTOMER'
  FIELD.NAME = 'L.CU.CIDENT':VM:'L.CU.RNC':VM:'L.CU.FOREIGN':VM:'L.APAP.INDUSTRY':VM:'L.CU.TIPO.CL':VM:'L.CU.DEBTOR':VM:'L.TIP.CLI'
  FIELD.POS  = ''

  CALL MULTI.GET.LOC.REF(APPL.NAME,FIELD.NAME,FIELD.POS)
  L.CU.CIDENT.POS     = FIELD.POS<1,1>
  L.CU.RNC.POS        = FIELD.POS<1,2>
  L.CU.FOREIGN.POS    = FIELD.POS<1,3>
  L.APAP.INDUSTRY.POS = FIELD.POS<1,4>
  L.CU.TIPO.CL.POS    = FIELD.POS<1,5>
  L.CU.DEBTOR.POS     = FIELD.POS<1,6>
  L.TIP.CLI.POS       = FIELD.POS<1,7>

  RETURN
*-----------------------------------------------------------------------------------------------------------------
END
