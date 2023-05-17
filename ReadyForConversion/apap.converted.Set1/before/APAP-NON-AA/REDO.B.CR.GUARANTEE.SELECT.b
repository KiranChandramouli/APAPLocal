*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.CR.GUARANTEE.SELECT
* -------------------------------------------------------------------------------------------------
* Description           : This is the Batch Select Routine used to select the records based on the
*                         conditions and pass the selected record array to main routine
* Developed By          : Vijayarani G
* Development Reference : 786711(FS-200-DE03)
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
*--------------------------------------------------------------------------------------------------
* PACS00353058          Ashokkumar.V.P                  11/11/2014           Changes the fields based on new mapping
* PACS00460181          Ashokkumar.V.P                  26/05/2015           Changes the fields based on new mapping
* PACS00460181          Ashokkumar.V.P                  02/06/2015           Changes the fields based on new mapping.
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT TAM.BP I_REDO.B.CR.GUARANTEE.COMMON

    GOSUB PROCESS
    RETURN

PROCESS:
********
    CALL EB.CLEAR.FILE(FN.DR.REG.DE03.WORKFILE, F.DR.REG.DE03.WORKFILE)
    LIST.PARAMETER = ''
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
    LIST.PARAMETER<3> := "PRODUCT.LINE EQ ":"LENDING"
*    LIST.PARAMETER<3> := " AND ((ARR.STATUS EQ ":"CURRENT":") OR (ARR.STATUS EQ ":"EXPIRED":"))"
    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
*
    RETURN
END
