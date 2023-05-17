*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.TEMP.FT.ACCOUNT.SELECT
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is ID routine attached to TELLER, CUSTOMER, ACCOUNT, FUNDS.TRANSFER,
*USER and TELLER.ID version to prevent transaction input if status is closed
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY :
*
* Revision History:
*------------------------------------------------------------------------------------------
* Date              who                 Reference         Description
* 06-06-2017       Edwin Charles D     R15 Upgrade      Initial Creation
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.REDO.FT.TT.TRANSACTION
    $INSERT I_F.ACCOUNT
    $INSERT I_F.MULTI.BRANCH.INTERNAL.ACCOUNT

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS
    RETURN

*----*
INIT:
*----*
*-----------*
*Initialising
*-----------*
    REC.ID='SYSTEM'
    RETURN

*---------*
OPEN.FILES:
*---------*
*------------*
*Opening files
*------------*

    FN.MULTI.BRANCH.INTERNAL.ACCOUNT ='F.MULTI.BRANCH.INTERNAL.ACCOUNT'
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    F.MULTI.BRANCH.INTERNAL.ACCOUNT = ''
    CALL OPF(FN.MULTI.BRANCH.INTERNAL.ACCOUNT,F.MULTI.BRANCH.INTERNAL.ACCOUNT)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    RETURN

*-------*
PROCESS:
*-------*

    CALL CACHE.READ(FN.MULTI.BRANCH.INTERNAL.ACCOUNT,REC.ID,R.MULTI.BRANCH.INTERNAL.ACCOUNT,Y.ERR)
    VAR.VERSION.NAME = R.MULTI.BRANCH.INTERNAL.ACCOUNT<REDO.BR.ACCT.VERSION>
    Y.VERSION.NAME = APPLICATION:PGM.VERSION

    LOCATE Y.VERSION.NAME IN VAR.VERSION.NAME<1,1> SETTING POS THEN
        R.NEW(FT.TN.CREDIT.ACCT.NO) = R.MULTI.BRANCH.INTERNAL.ACCOUNT<REDO.BR.ACCT.ACCOUNT,POS>
    END

    Y.ACCT = '' ; Y.ARR.ID = ''
    Y.ARR.ID = COMI
    IF Y.ARR.ID[1,2] EQ 'AA' THEN
        IN.ACC.ID = ''
        IN.ARR.ID = Y.ARR.ID
        OUT.ID = ''
        ERR.TEXT = ''
        CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)
        Y.ACCT = OUT.ID
    END ELSE
        IN.ACC.ID = Y.ARR.ID
        IN.ARR.ID = ''
        OUT.ID = ''
        ERR.TEXT = ''
        Y.ACCT = Y.ARR.ID
        CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)
        Y.ARR.ID = OUT.ID
    END

    CALL F.READ(FN.ACCOUNT,Y.ACCT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    R.NEW(FT.TN.DEBIT.CURRENCY)   = R.ACCOUNT<AC.CURRENCY>
    IF R.ACCOUNT<AC.ARRANGEMENT.ID> EQ '' THEN
        AF = FT.TN.DEBIT.ACCT.NO
        ETEXT = "EB-NOT.ARRANGEMENT.ID"
        CALL STORE.END.ERROR
        RETURN
    END
    R.AA.ACCOUNT.DETAILS = ''; Y.EFF.DATE = ''
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,AA.ARR.ERR)
    IF R.AA.ACCOUNT.DETAILS THEN
        Y.EFF.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.CONTRACT.DATE>
        IF Y.EFF.DATE NE '' AND R.NEW(FT.TN.DEBIT.VALUE.DATE) LT Y.EFF.DATE THEN
            AF = FT.TN.DEBIT.VALUE.DATE
            ETEXT = "EB-VALUE.DATE.LT.ARR.DATE"
            CALL STORE.END.ERROR
            RETURN
        END
        IF Y.EFF.DATE NE '' AND R.NEW(FT.TN.CREDIT.VALUE.DATE) LT Y.EFF.DATE THEN
            AF = FT.TN.CREDIT.VALUE.DATE
            ETEXT = "EB-VALUE.DATE.LT.ARR.DATE"
            CALL STORE.END.ERROR
            RETURN
        END
    END
    RETURN

    IF Y.VERSION.NAME EQ 'FUNDS.TRANSFER,REDO.AA.LTCC' THEN
        R.NEW(FT.TN.ORDERING.CUST) = R.ACCOUNT<AC.CUSTOMER>
    END

    RETURN
END
