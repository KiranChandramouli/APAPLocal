* @ValidationCode : MjotMjAyNDMyMDExNTpDcDEyNTI6MTY4MjMxNjEyMDA0NzpJVFNTOi0xOi0xOjM4NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 11:32:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 386
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.AUTO.DEF.INTERBRANCH
*------------------------------------------------------------------------
*Description: This is a Autom New Content Routine to default
* the values of Treasury Branch dept Code and respetive Internal Account.
*------------------------------------------------------------------------
* Input Argument : NA
* Out Argument : NA
* Deals With : FUNDS.TRANSFER,REDO.AA.INTERBRANCH.ACH
*------------------------------------------------------------------------
* Modification History :

*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------
* DATE WHO REFERENCE DESCRIPTION
* 19-JAN-2012 H GANESH PACS00175284 - N.45 Initial Draft.
* 13-JUL-2012 MARIMUTHU S PACS00203617
* 29-JUN-2017 Edwin Charles D
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.BRANCH.INT.ACCT.PARAM
    $INSERT I_F.REDO.ISSUE.DEPT.CODE
    $INSERT I_F.REDO.FT.TT.TRANSACTION
    $INSERT I_F.ACCOUNT

    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------
OPENFILES:
*------------------------------------------------------------------------
    FN.REDO.BRANCH.INT.ACCT.PARAM = 'F.REDO.BRANCH.INT.ACCT.PARAM'
    F.REDO.BRANCH.INT.ACCT.PARAM = ''
    CALL OPF(FN.REDO.BRANCH.INT.ACCT.PARAM,F.REDO.BRANCH.INT.ACCT.PARAM)

    FN.REDO.ISSUE.DEPT.CODE ='F.REDO.ISSUE.DEPT.CODE'
    F.REDO.ISSUE.DEPT.CODE = ''
    CALL OPF(FN.REDO.ISSUE.DEPT.CODE,F.REDO.ISSUE.DEPT.CODE)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
GET.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.BRANCH.INT.ACCT.PARAM,GET.ID,R.REDO.BRANCH.INT.ACCT.PARAM,PARA.ERR)
    Y.TREASURY.DEPT = R.REDO.BRANCH.INT.ACCT.PARAM<BR.INT.ACCT.TREASURY.DEPT>

    IF Y.TREASURY.DEPT ELSE
        E = 'EB-TREASURY.NT.PARAM'
    END
    R.NEW(FT.TN.L.FT.CMPNY.ID) = Y.TREASURY.DEPT
    CALL CACHE.READ(FN.REDO.ISSUE.DEPT.CODE,Y.TREASURY.DEPT,R.REDO.ISSUE.DEPT.CODE,Y.ERR)
    IF R.REDO.ISSUE.DEPT.CODE THEN
        R.NEW(FT.TN.CREDIT.ACCT.NO) = R.REDO.ISSUE.DEPT.CODE<REDO.IDC.DEPT.ACCT.NO>
        Y.AC.DI = R.REDO.ISSUE.DEPT.CODE<REDO.IDC.DEPT.ACCT.NO>
        CALL F.READ(FN.ACCOUNT,Y.AC.DI,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        R.NEW(FT.TN.CREDIT.CURRENCY) = R.ACCOUNT<AC.CURRENCY>
    END

RETURN
END
