SUBROUTINE REDO.TT.ACCOUNT.SELECT
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
*   Date               who           Reference            Description
*  20-12-2010        JEEVA T          N.45              INITIAL CREATION
*------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
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
    FN.MULTI.BRANCH.INTERNAL.ACCOUNT = 'F.MULTI.BRANCH.INTERNAL.ACCOUNT'
    F.MULTI.BRANCH.INTERNAL.ACCOUNT = ''
    CALL OPF(FN.MULTI.BRANCH.INTERNAL.ACCOUNT,F.MULTI.BRANCH.INTERNAL.ACCOUNT)

RETURN

*-------*
PROCESS:
*-------*

*-----------------------------------------------------*
*Raising Error Message if the operation Status is Closes
*-----------------------------------------------------*


*  CALL F.READ(FN.MULTI.BRANCH.INTERNAL.ACCOUNT,REC.ID,R.MULTI.BRANCH.INTERNAL.ACCOUNT,F.MULTI.BRANCH.INTERNAL.ACCOUNT,BR.MSG) ;*Tus Start
    CALL CACHE.READ(FN.MULTI.BRANCH.INTERNAL.ACCOUNT,REC.ID,R.MULTI.BRANCH.INTERNAL.ACCOUNT,BR.MSG) ; * Tus End

    VAR.VERSION.NAME = R.MULTI.BRANCH.INTERNAL.ACCOUNT<REDO.BR.ACCT.VERSION>
    VAR.ACCOUNT      = R.MULTI.BRANCH.INTERNAL.ACCOUNT<REDO.BR.ACCT.ACCOUNT>

    Y.VERSION.NAME = APPLICATION:PGM.VERSION
    LOOP
        REMOVE VAR.VERSION FROM VAR.VERSION.NAME SETTING POS1
    WHILE VAR.VERSION:POS1
        LOCATE Y.VERSION.NAME IN VAR.VERSION SETTING POS THEN
            R.NEW(TT.TE.ACCOUNT.1) = R.MULTI.BRANCH.INTERNAL.ACCOUNT<REDO.BR.ACCT.ACCOUNT,POS>
        END
    REPEAT
RETURN
END
