*---------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
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
*---------------------------------------------------------------------------------------------

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT TAM.BP I_REDO.B.THIRD.RES.RECOVERY.COMMON
*
    GOSUB SELECT.PROCESS
    RETURN
*
SELECT.PROCESS:
*--------------
*
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
    LIST.PARAMETER<3> = "START.DATE LE ":Y.TODATE
    LIST.PARAMETER<3> := " AND (PRODUCT.GROUP EQ ":"CONSUMO":" OR PRODUCT.GROUP EQ ":"HIPOTECARIO":" OR PRODUCT.GROUP EQ ":"COMERCIAL":" OR PRODUCT.GROUP EQ ":"LINEAS.DE.CREDITO":")"
    LIST.PARAMETER<3> := " AND PRODUCT.LINE EQ ":"LENDING"
    LIST.PARAMETER<3> := " AND ((ARR.STATUS EQ ":"CURRENT":") OR (ARR.STATUS EQ ":"EXPIRED":"))"
    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
    RETURN
END
