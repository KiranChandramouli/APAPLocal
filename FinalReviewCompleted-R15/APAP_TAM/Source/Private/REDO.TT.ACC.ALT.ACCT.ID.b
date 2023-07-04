* @ValidationCode : MjoyMzI2MzMzMDg6Q3AxMjUyOjE2ODMwMjAyNDE2NDE6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 May 2023 15:07:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TT.ACC.ALT.ACCT.ID(Y.ACCT.TITLE)
*-------------------------------------------------------------
*Description: This routine is call routine from deal slip of TT

*-------------------------------------------------------------
*Input Arg : Y.INP.DEAL
*Out Arg   : Y.INP.DEAL
*Deals With: TT payement
*Modify    :btorresalbornoz
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*17/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION         FM TO @FM, VM TO @VM, SM TO @SM
*17/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT

    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------------------------------------------
    GET.ACCT.TITLE = R.NEW(TT.TE.ACCOUNT.1)
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    CALL F.READ(FN.ACCOUNT,GET.ACCT.TITLE,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    Y.ACCT.TITLE = R.ACCOUNT<AC.ALT.ACCT.ID>
    Y.ACCT.TITLE = CHANGE(Y.ACCT.TITLE,@SM,@VM)
    Y.ACCT.TITLE = CHANGE(Y.ACCT.TITLE,@FM,@VM)
    Y.ACCT.TITLE = Y.ACCT.TITLE<1,1>

    IF Y.ACCT.TITLE EQ '' THEN
        GET.ACCT.TITLE = R.NEW(TT.TE.ACCOUNT.2)
        CALL F.READ(FN.ACCOUNT,GET.ACCT.TITLE,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
        Y.ACCT.TITLE = R.ACCOUNT<AC.ALT.ACCT.ID>
        Y.ACCT.TITLE = CHANGE(Y.ACCT.TITLE,@SM,@VM)
        Y.ACCT.TITLE = CHANGE(Y.ACCT.TITLE,@FM,@VM)
        Y.ACCT.TITLE = Y.ACCT.TITLE<1,1>
    END

    Y.ACCT.TITLE = FMT(Y.ACCT.TITLE,"R#20")

RETURN
END
