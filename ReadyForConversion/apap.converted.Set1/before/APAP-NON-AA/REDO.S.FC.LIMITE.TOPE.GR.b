*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.FC.LIMITE.TOPE.GR(CUST.ID, CUST.OUT)
*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return evaluation of customer.
*
* Incoming:
* ---------
* CUST.ID - ID FROM CUSTOMER
*
* Outgoing:
* ---------
* CUST.OUT - data returned to the routine
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : mgudino - TAM Latin America
* Date            :
*
*-----------------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_System
$INSERT I_F.CUSTOMER
$INSERT I_RAPID.APP.DEV.COMMON
$INSERT I_F.REDO.CCRG.CUSTOMER
$INSERT I_F.REDO.CCRG.RISK.LIMIT.PARAM



  GOSUB INITIALISE
  GOSUB OPEN.FILES

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  Y.ERROR = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUSTOMER,F.CUSTOMER,Y.ERROR)
  IF R.CUSTOMER THEN
    IF R.CUSTOMER<EB.CUS.CUSTOMER.TYPE> EQ 'PROSPECT' THEN
      VI.ARR = ''
      RETURN
    END
  END

  GOSUB PROCESS.RESULT

  RETURN


*------------------------
PROCESS.RESULT:
*=============
  R.REDO.CCRG.RISK.LIMIT.PARAM = ''
  YERR = ''
  REDO.CCRG.RISK.LIMIT.PARAM.ID = Y.ID.NAME.LIM
  CALL F.READ(FN.REDO.CCRG.RISK.LIMIT.PARAM,REDO.CCRG.RISK.LIMIT.PARAM.ID,R.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARAM,YERR)
  IF YERR THEN
    ETEXT = "EB-FC-READ.ERROR" : FM : REDO.CCRG.RISK.LIMIT.PARAM.ID
    CUST.OUT = ETEXT
  END ELSE
    CUST.OUT = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.MAX.AMOUNT>
  END


  RETURN

*------------------------
INITIALISE:
*=========
  PROCESS.GOAHEAD = 1
  FN.REDO.CCRG.RISK.LIMIT.PARAM = 'F.REDO.CCRG.RISK.LIMIT.PARAM'
  F.REDO.CCRG.RISK.LIMIT.PARAM = ''
  ID.CUST = ''
  ID.CUST.LIM = ''
  CUST.OUT = ''
  Y.VER.INSURANCE = 'MAN'
  Y.INS.ID = ''
  R.REDO.CCRG.CUSTOMER = ''
  Y.OFS.MSG.RES = ''
  Y.OFS.MSG.REQ = ''

  Y.ID.NAME.LIM = 'RISK.GROUP.TOTAL'

  RETURN

*------------------------
OPEN.FILES:
*=========
  CALL OPF(FN.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARAM)

  RETURN
*------------
END
