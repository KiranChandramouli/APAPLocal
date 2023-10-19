* @ValidationCode : MjotMjExNDY1NDY0NzpDcDEyNTI6MTY4MjA3MzM4MjQzNDpJVFNTOi0xOi0xOjM4NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 385
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BUILD.AZ.REPRINT(ENQ.DATA)
*---------------------------------------------------------------------------
*---------------------------------------------------------------------------
*Description       : This routine is a build routine to display the given AZ Account number is approval for reprint
*Linked With       :
*Linked File       :
*--------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                DESCRIPTION
* 13-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 17-APR-2023     Conversion tool    R22 Manual conversion     No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.APAP.H.REPRINT.DEP
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*-----------
OPENFILES:
*-----------
    FN.APAP.H.REPRINT.DEP = 'F.REDO.APAP.H.REPRINT.DEP'
    F.APAP.H.REPRINT.DEP  = ''
    CALL OPF(FN.APAP.H.REPRINT.DEP,F.APAP.H.REPRINT.DEP)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
RETURN
*----------
PROCESS:
*----------

    LOCATE "@ID" IN ENQ.DATA<2,1> SETTING POS1 THEN
        VAR.AZ.ID =  ENQ.DATA<4,POS1>
    END

    CALL F.READ(FN.AZ.ACCOUNT,VAR.AZ.ID,R.AZ.ACC,F.AZ.ACCOUNT,AZ.ERR)

    VAR.AZ.VALUE.DATE = R.AZ.ACC<AZ.VALUE.DATE>

    VAR.ID = VAR.AZ.ID:"-":VAR.AZ.VALUE.DATE

    CALL F.READ(FN.APAP.H.REPRINT.DEP,VAR.ID,R.APAP.H.REPRINT,F.APAP.H.REPRINT.DEP,APAP.H.ERR)

    IF NOT(R.APAP.H.REPRINT) THEN
        ENQ.DATA<4,POS1> = 'ZZZZ'
    END ELSE
        VAR.FLAG = R.APAP.H.REPRINT<REDO.REP.DEP.REPRINT.FLAG>
        IF VAR.FLAG NE 'YES' THEN
            ENQ.DATA<4,POS1> = 'ZZZZ'
        END
    END
RETURN
*-------------------------
END
