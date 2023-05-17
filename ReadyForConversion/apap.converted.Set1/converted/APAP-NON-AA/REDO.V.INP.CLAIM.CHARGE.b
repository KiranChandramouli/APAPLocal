SUBROUTINE REDO.V.INP.CLAIM.CHARGE
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
*01-MAR-2010        PRABHU              HD1100464        other type account not required
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.REDO.ISSUE.CLAIMS
*Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*Tus End

    GOSUB INIT
    GOSUB PROCESS
RETURN

*****
INIT:
*****

    FN.REDO.ISSUE.CLAIMS    = 'F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS     = ''
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)
*
    FN.ACCOUNT              = 'F':R.COMPANY(3):'.ACCOUNT'
    F.ACCOUNT               = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.FT.COMMISSION.TYPE   = 'F':R.COMPANY(3):'.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE    = ''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

RETURN

********
PROCESS:
********
    Y.ACCT.ID         = R.NEW(ISS.CL.ACCOUNT.ID)
    Y.OPEN.CHANNEL    = R.NEW(ISS.CL.OPENING.CHANNEL)
    Y.CHARGE          = R.NEW(ISS.CL.CHARGE.KEY)

    CALL F.READ(FN.ACCOUNT, Y.ACCT.ID, R.ACCOUNT, F.ACCOUNT, ACC.ERR)
    R.ECB= '' ; ECB.ERR= '' ;*Tus Start
    CALL EB.READ.HVT("EB.CONTRACT.BALANCES",Y.ACCT.ID,R.ECB,ECB.ERR);*Tus End

    IF Y.ACCT.ID THEN
        Y.CURR        = R.ACCOUNT<AC.CURRENCY>
*  Y.AMOUNT      = R.ACCOUNT<AC.WORKING.BALANCE>;*Tus Start
        Y.AMOUNT      = R.ECB<ECB.WORKING.BALANCE>;*Tus End
    END

    CALL F.READ(FN.FT.COMMISSION.TYPE, Y.CHARGE, R.FT.COMMISSION.TYPE, F.FT.COMMISSION.TYPE, CHAR.ERR)
    GOSUB CHARGE.CALCULATE

    IF Y.AMOUNT LT Y.FLAT.AMOUNT AND R.NEW(ISS.CL.PRODUCT.TYPE) NE 'OTROS' THEN
        AF    = ISS.CL.ACCOUNT.ID
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
