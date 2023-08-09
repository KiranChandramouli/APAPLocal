* @ValidationCode : MjotMTgyMzY1OTk5ODpDcDEyNTI6MTY5MDE3NjA1MjU4NzpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 10:50:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE			           AUTHOR			          Modification                            DESCRIPTION
*13/07/2023	               CONVERSION TOOL          AUTO R22 CODE CONVERSION			      NOCHANGE
*13/07/2023	               VIGNESHWARI      	    MANUAL R22 CODE CONVERSION		          NOCHANGE
*-----------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.CHECK.ACCT.CCY
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.CHECK.ACCT.CCY
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the Bank name
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.T24.FUND.SERVICES

    GOSUB PROCESS
RETURN

PROCESS:

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    ACCT.ID = COMI
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    VAR.CCY = R.ACCOUNT<AC.CURRENCY>
    IF VAR.CCY NE LCCY THEN
        AF = TFS.SURROGATE.AC
        ETEXT = "EB-INVALID.CCY"
        CALL STORE.END.ERROR
    END

RETURN
END
