* @ValidationCode : MjotODQyMjU3MjI5OkNwMTI1MjoxNjgxMzcwNTk1MjUyOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 12:53:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.TEMP.DEB.ACC.SAV.CUR
*-------------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is used as validation routine for the DEBIT.ACCT.NO field in FT
*-------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who                       Reference                 Description
* 06-06-2017        Edwin Charles D             R15 Upgrade              Initial Creation
*13-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*13-04-2023       Samaran T               R22 Manual Code Conversion       No Change
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.FT.TT.TRANSACTION

MAIN:

    GOSUB PROCESS
    GOSUB PGM.END

PROCESS:

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    Y.DEB.ACC = COMI

    IF Y.DEB.ACC[1,2] EQ 'AA' THEN
        CALL F.READ(FN.AA.ARRANGEMENT,Y.DEB.ACC,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARR.ER)
        IF R.AA.ARRANGEMENT THEN
            Y.DEB.ACC = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
        END
    END

    CALL F.READ(FN.ACCOUNT,Y.DEB.ACC,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF NOT(R.ACCOUNT) THEN
        RETURN
    END
    Y.AA.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>

    IF Y.AA.ID EQ '' THEN
        AF = FT.TN.DEBIT.ACCT.NO
        ETEXT = 'EB-LOAN.ACC.MISS'
        CALL STORE.END.ERROR
    END ELSE
        R.NEW(FT.TN.DEBIT.CURRENCY) = R.ACCOUNT<AC.CURRENCY>
    END

PGM.END:

END
