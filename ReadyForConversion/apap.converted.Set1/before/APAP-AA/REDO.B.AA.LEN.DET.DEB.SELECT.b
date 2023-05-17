*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.AA.LEN.DET.DEB.SELECT
* -------------------------------------------------------------------------------------------------
* Description           : This is the Batch Select Routine used to select the records based on the
*                         conditions and pass the selected record array to main routine
* Developed By          : Vijayarani G
* Development Reference : 786844(FS-207-DE21)
* Attached To           : NA
* Attached As           : NA
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA

*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
* PACS00361224           Ashokkumar.V.P                 30/10/2014            New mapping changes - Rewritten the whole source.
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT TAM.BP I_REDO.B.AA.LEN.DET.DEB.COMMON

    GOSUB PROCESS
    RETURN

PROCESS:
********
    CALL EB.CLEAR.FILE(FN.DR.REG.DE21.WORKFILE, F.DR.REG.DE21.WORKFILE)
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
*    LIST.PARAMETER<3> = "START.DATE LE ":Y.LAST.WORK.DAY
    LIST.PARAMETER<3> := "(PRODUCT.GROUP EQ ":"COMERCIAL":" OR PRODUCT.GROUP EQ ":"LINEAS.DE.CREDITO":")"
    LIST.PARAMETER<3> := " AND PRODUCT.LINE EQ ":"LENDING"
*    LIST.PARAMETER<3> := " AND ((ARR.STATUS EQ ":"CURRENT":") OR (ARR.STATUS EQ ":"EXPIRED":"))"
    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

    RETURN
END
