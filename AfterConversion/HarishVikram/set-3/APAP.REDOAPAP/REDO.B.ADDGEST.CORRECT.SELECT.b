* @ValidationCode : MjoxMDY2MDA5NjM6Q3AxMjUyOjE2ODUwMDAzMzE4MTk6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 May 2023 13:08:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
*25-05-2023           Conversion Tool          R22 Auto Code conversion             No Changes
*25-05-2023           Harish vikaram C             Manual R22 Code Conversion         No Changes
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.ADDGEST.CORRECT.COMMON

    CALL F.READ(FN.SL,'REDO.AA.CORRECT',ID.LIST,F.SL,RET.ERROR)
    IF ID.LIST NE '' THEN
        LIST.PARAM = ''
        CALL BATCH.BUILD.LIST(LIST.PARAM,ID.LIST)
    END

RETURN
END
