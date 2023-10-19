* @ValidationCode : MjoxODI4MTEzMDU4OkNwMTI1MjoxNjg5ODM5MDU2MDc4OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Jul 2023 13:14:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.V.AUT.AA.DISBURSE
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*  This routine is an AUTH routine attached to below versions,
*  FUNDS.TRANSFER,REDO.AA.DISBURSE
*
*
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*-----------------------------------------------------------------------------
*   Date               who           Reference            Description
* 04-28-2011          Bharath G         N.45              INITIAL CREATION
*13/07/2023	     CONVERSION TOOL                         AUTO R22 CODE CONVERSION-NOCHANGE
*13/07/2023	      VIGNESHWARI                            MANUAL R22 CODE CONVERSION-Variable is changed
*-----------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.AA.DISBURSE.UPDATE

    GOSUB INIT
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
******
INIT:
******
* Initialize all the variables

    Y.AA.ID = ''   ; Y.TOT.DISB.AMT = 0
    FN.REDO.AA.DISBURSE.UPDATE = 'F.REDO.AA.DISBURSE.UPDATE'
    F.REDO.AA.DISBURSE.UPDATE = ''
    R.REDO.AA.DISBURSE.UPDATE = ''
    CALL OPF(FN.REDO.AA.DISBURSE.UPDATE,F.REDO.AA.DISBURSE.UPDATE)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    R.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)


RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*
    Y.AA.ID = R.NEW(FT.DEBIT.ACCT.NO)
    CALL F.READ(FN.REDO.AA.DISBURSE.UPDATE,Y.AA.ID,R.REDO.AA.DISBURSE.UPDATE,F.REDO.AA.DISBURSE.UPDATE,UPD.ERR)
    IF R.REDO.AA.DISBURSE.UPDATE THEN
        *Y.TOT.DISB.AMT = R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.TOT.DISB.AMT>
        Y.TOT.DISB.AMT = R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.DISB.AMT>;*MANUAL R22 CODE CONVERSION
        Y.TOT.DISB.AMT = SUM(Y.TOT.DISB.AMT)
    END
    Y.TOT.DISB.AMT += R.NEW(FT.DEBIT.AMOUNT)
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.DISB.AMT>         = Y.TOT.DISB.AMT ;*MANUAL R22 CODE CONVERSION
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.BRANCH.ID,-1>         = R.NEW(FT.CREDIT.ACCT.NO)
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.DISB.TYPE,-1,-1>      = R.NEW(FT.PAYMENT.DETAILS)
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.DISB.AMT,-1,-1>       = R.NEW(FT.CREDIT.AMOUNT)
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.CREDIT.ACC,-1,-1>     = R.NEW(FT.CREDIT.ACCT.NO)
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.TRANS.REF,-1,-1>      = ID.NEW
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.CHEQUE.TYPE,-1,-1>    = ''
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.BENEFICIARY,-1,-1>    = ''
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.NARRATIVE,-1,-1>      = ''
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.REMARKS,-1,-1>        = ''
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.DISB.INDICATOR,-1,-1> = 'NOT.DISB'
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.DISB.REF.ID,-1,-1>    = ''


    CALL F.WRITE(FN.REDO.AA.DISBURSE.UPDATE,Y.AA.ID,R.REDO.AA.DISBURSE.UPDATE)

RETURN
*-----------------------------------------------------------------------------
END
