* @ValidationCode : MjoxNjAwODQxMzY2OkNwMTI1MjoxNzA1MzgyNjk4NTM4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Jan 2024 10:54:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.B.ADDGEST.CORRECT.SELECT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                DESCRIPTION
*25-05-2023           Conversion Tool          R22 Auto Code conversion           No Changes
*25-05-2023           Harish vikaram C         Manual R22 Code Conversion         No Changes
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.ADDGEST.CORRECT.COMMON
    $USING EB.Service

*    CALL F.READ(FN.SL,'REDO.AA.CORRECT',ID.LIST,F.SL,RET.ERROR)
    IDVAR.1 = 'REDO.AA.CORRECT' ;* R22 UTILITY AUTO CONVERSION
    CALL F.READ(FN.SL,IDVAR.1,ID.LIST,F.SL,RET.ERROR);* R22 UTILITY AUTO CONVERSION
    IF ID.LIST NE '' THEN
        LIST.PARAM = ''
*        CALL BATCH.BUILD.LIST(LIST.PARAM,ID.LIST)
        EB.Service.BatchBuildList(LIST.PARAM,ID.LIST);* R22 UTILITY AUTO CONVERSION
    END

RETURN
END
