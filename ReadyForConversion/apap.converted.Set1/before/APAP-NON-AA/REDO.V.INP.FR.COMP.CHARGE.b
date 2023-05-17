*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.FR.COMP.CHARGE
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This Input routine is used to validate if the charge acquired
* from the account holds sufficient balance
*
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RENUGADEVI B
* PROGRAM NAME : REDO.V.INP.CLAIM.CHARGE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 25-AUG-2010       RENUGADEVI B       ODR-2009-12-0283  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_F.ACCOUNT
$INSERT I_F.FT.COMMISSION.TYPE
$INSERT I_F.REDO.FRONT.COMPLAINTS
$INSERT I_F.EB.CONTRACT.BALANCES		;*TUS S/E

  GOSUB INIT
  GOSUB PROCESS
  RETURN

*****
INIT:
*****

*
  FN.ACCOUNT              = 'F.ACCOUNT'
  F.ACCOUNT               = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.FT.COMMISSION.TYPE   = 'F.FT.COMMISSION.TYPE'
  F.FT.COMMISSION.TYPE    = ''
  CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

  RETURN

********
PROCESS:
********
  Y.ACCT.ID         = R.NEW(FR.CM.ACCOUNT.ID)
  Y.OPEN.CHANNEL    = R.NEW(FR.CM.OPENING.CHANNEL)
  Y.CHARGE          = R.NEW(FR.CM.CHARGE.KEY)

  CALL F.READ(FN.ACCOUNT, Y.ACCT.ID, R.ACCOUNT, F.ACCOUNT, ACC.ERR)
  CALL EB.READ.HVT ('EB.CONTRACT.BALANCES',Y.ACCT.ID, R.ECB, ECB.ERR)	;*TUS START
  IF Y.ACCT.ID THEN
    Y.CURR        = R.ACCOUNT<AC.CURRENCY>
   *Y.AMOUNT      = R.ACCOUNT<AC.WORKING.BALANCE>
    Y.AMOUNT      = R.ECB<ECB.WORKING.BALANCE>		;*TUS END
  END

  CALL F.READ(FN.FT.COMMISSION.TYPE, Y.CHARGE, R.FT.COMMISSION.TYPE, F.FT.COMMISSION.TYPE, CHAR.ERR)
  GOSUB CHARGE.CALCULATE

  IF Y.AMOUNT LT Y.FLAT.AMOUNT AND R.NEW(FR.CM.PRODUCT.TYPE) NE 'OTROS' THEN
    AF    = FR.CM.ACCOUNT.ID
    ETEXT = 'EB-INSUFFICIENT.FUNDS'
    CALL STORE.END.ERROR
  END
  RETURN

*****************
CHARGE.CALCULATE:
*****************

  IF R.FT.COMMISSION.TYPE THEN
    Y.COM.CURR    = R.FT.COMMISSION.TYPE<FT4.CURRENCY>
    CHANGE VM TO FM IN Y.COM.CURR
    Y.COUNT   = DCOUNT(Y.COM.CURR,FM)
    CNT           = 1

    LOOP
    WHILE CNT LE Y.COUNT
      Y.FLAT.AMOUNT = R.FT.COMMISSION.TYPE<FT4.FLAT.AMT, CNT>
      CNT++
    REPEAT
  END
  RETURN
END
