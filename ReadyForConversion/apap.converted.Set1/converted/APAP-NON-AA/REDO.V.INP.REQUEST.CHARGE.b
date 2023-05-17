SUBROUTINE REDO.V.INP.REQUEST.CHARGE
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
* PROGRAM NAME : REDO.V.INP.REQUEST.CHARGE
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
    $INSERT I_F.REDO.ISSUE.REQUESTS
    $INSERT I_F.EB.CONTRACT.BALANCES                ;*TUS S/E

    GOSUB INIT
    GOSUB PROCESS
RETURN

*****
INIT:
*****

    FN.REDO.ISSUE.REQUESTS    = 'F.REDO.ISSUE.REQUESTS'
    F.REDO.ISSUE.REQUESTS    = ''
    CALL OPF(FN.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS)
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
    Y.ACCT.ID         = R.NEW(ISS.REQ.ACCOUNT.ID)
    Y.OPEN.CHANNEL    = R.NEW(ISS.REQ.OPENING.CHANNEL)
    Y.CHARGE          = R.NEW(ISS.REQ.CHARGE.KEY)

    CALL F.READ(FN.ACCOUNT, Y.ACCT.ID, R.ACCOUNT, F.ACCOUNT, ACC.ERR)
    CALL EB.READ.HVT ('EB.CONTRACT.BALANCES', Y.ACCT.ID, R.ECB, ECB.ERR)                ;*TUS START
    IF Y.ACCT.ID THEN
        Y.CURR        = R.ACCOUNT<AC.CURRENCY>
*Y.AMOUNT      = R.ACCOUNT<AC.WORKING.BALANCE>
        Y.AMOUNT      = R.ECB<ECB.WORKING.BALANCE>                ;*TUS END
    END

    CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.CHARGE, R.FT.COMMISSION.TYPE, CHAR.ERR)
    GOSUB CHARGE.CALCULATE

    IF Y.AMOUNT LT Y.FLAT.AMOUNT AND R.NEW(ISS.REQ.PRODUCT.TYPE) NE 'OTROS' THEN
        AF    = ISS.REQ.ACCOUNT.ID
        ETEXT = 'EB-INSUFFICIENT.FUNDS'
        CALL STORE.END.ERROR
    END
RETURN

*****************
CHARGE.CALCULATE:
*****************

    IF R.FT.COMMISSION.TYPE THEN
        Y.COM.CURR    = R.FT.COMMISSION.TYPE<FT4.CURRENCY>
        CHANGE @VM TO @FM IN Y.COM.CURR
        Y.COUNT   = DCOUNT(Y.COM.CURR,@FM)
        CNT           = 1

        LOOP
        WHILE CNT LE Y.COUNT
            Y.FLAT.AMOUNT = R.FT.COMMISSION.TYPE<FT4.FLAT.AMT, CNT>
            CNT += 1
        REPEAT
    END
RETURN
END
