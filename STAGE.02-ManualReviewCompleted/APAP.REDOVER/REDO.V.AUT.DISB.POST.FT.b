* @ValidationCode : MjotMTU2MzYzOTIwOTpDcDEyNTI6MTY4MDc3ODY3NTQ4NTpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 16:27:55
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
SUBROUTINE REDO.V.AUT.DISB.POST.FT
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*  This routine is an AUTH routine attached to REDO.AA.DISB.LOAN Template to post FT
*
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*-----------------------------------------------------------------------------
*   Date             who           Reference                        Description
* 04-28-2011       Bharath G         N.45                         INITIAL CREATION
*06-04-2023       Conversion Tool   R22 Auto Code conversion          No Changes
*06-04-2023       Samaran T         R22 Manual Code Conversion         No Changes
*-----------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ALTERNATE.ACCOUNT
    $INSERT I_F.REDO.AA.DISB.LOAN
    $INSERT I_F.REDO.BRANCH.INT.ACCT.PARAM

    GOSUB INIT
    GOSUB UPDATE.FUNDS.TRANSFER

RETURN
*-----------------------------------------------------------------------------
******
INIT:
******
* Initialize all the variables

    FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'
    F.ALTERNATE.ACCOUNT = ''
    R.ALTERNATE.ACCOUNT = ''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    R.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    R.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

RETURN
*-----------------------------------------------------------------------------
UPDATE.FUNDS.TRANSFER:
*-----------------------------------------------------------------------------
*
    Y.AA.ID = R.NEW(DISB.LN.ARRANGEMENT.ID)

    CALL F.READ(FN.ALTERNATE.ACCOUNT,Y.AA.ID,R.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT,ALT.AC.ERR)
    IF R.ALTERNATE.ACCOUNT THEN
        Y.DEBIT.ACCT.NO = R.ALTERNATE.ACCOUNT<AAC.GLOBUS.ACCT.NUMBER>

        CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)
        IF R.AA.ARRANGEMENT THEN
            R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>     = Y.DEBIT.ACCT.NO
            R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>    = R.NEW(DISB.LN.LOAN.CCY)
            R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>      = R.NEW(DISB.LN.TOT.DISB.AMT)
            R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>    = R.NEW(DISB.LN.MN.BRANCH.AC)
*            R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>  = R.NEW(DISB.LN.LOAN.CCY)
            R.FUNDS.TRANSFER<FT.PAYMENT.DETAILS,1> = ID.NEW
            GOSUB FORM.FUNDS.TRANSFER.OFS.MSG
        END
    END

RETURN
*--------------------------------------------------------------------------------
FORM.FUNDS.TRANSFER.OFS.MSG:
*--------------------------------------------------------------------------------
*
    APP.NAME = "FUNDS.TRANSFER"
    OFSFUNCT = 'I'
    PROCESS  = 'PROCESS'
    OFSVERSION = 'FUNDS.TRANSFER,INT.BRANCH.TRANSFER'
    GTSMODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = ''
    OFSRECORD = ''

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.FUNDS.TRANSFER,OFSRECORD)
    OFS.SOURCE.ID = 'REDO.LOAN.DISB'
    OFS.MSG.ID = ''
    OPTIONS = ''
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OPTIONS)

RETURN
*--------------------------------------------------------------------------------
END
