$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.THIRD.RES.RECOVERY.SELECT
*---------------------------------------------------------------------------------------------
*
* Description           : Batch routine to report information about files with tax data checks and electronic transfer that should be send to the Government Entity (SB)

* Developed By          : Thilak Kumar K
*
* Development Reference :
*
* Attached To           : Batch - BNK/REDO.B.THIRD.RES.RECOVERY
*
* Attached As           : Online Batch Routine to COB
*---------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*---------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*---------------------------------------------------------------------------------------------
*   Date       Author              Modification Description
* 29/10/2014  Ashokkumar.V.P        PACS00353049 - New mapping changes
** 24-04-2023 R22 Auto Conversion
** 24-04-2023 Skanda R22 Manual Conversion - No changes
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_REDO.B.THIRD.RES.RECOVERY.COMMON ;* R22 Auto conversion
   $USING EB.Service
*
    GOSUB SELECT.PROCESS
RETURN
*
SELECT.PROCESS:
*--------------
*
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
    LIST.PARAMETER<3> = "START.DATE LE ":Y.TODATE
*    LIST.PARAMETER<3> := " AND (PRODUCT.GROUP EQ ":"CONSUMO":" OR PRODUCT.GROUP EQ ":"HIPOTECARIO":" OR PRODUCT.GROUP EQ ":"COMERCIAL":" OR PRODUCT.GROUP EQ ":"LINEAS.DE.CREDITO":")"
    LIST.PARAMETER<3> := " AND PRODUCT.LINE EQ ":"LENDING"
    LIST.PARAMETER<3> := " AND ((ARR.STATUS EQ ":"CURRENT":") OR (ARR.STATUS EQ ":"EXPIRED":"))"
*    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
EB.Service.BatchBuildList(LIST.PARAMETER, "");* R22 UTILITY AUTO CONVERSION
RETURN
END
