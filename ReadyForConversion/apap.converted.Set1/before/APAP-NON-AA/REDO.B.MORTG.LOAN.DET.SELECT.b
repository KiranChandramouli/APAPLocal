*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.MORTG.LOAN.DET.SELECT
* -------------------------------------------------------------------------------------------------
* Description           : This is the Batch Select Routine used to select the records based on the
*                         conditions and pass the selected record array to main routine
* Developed By          : Vijayarani G
* Development Reference : 786872(FS-210-DE25)
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
* PACS00362987           Ashokkumar.V.P                 29/10/2014            New mapping changes - Rewritten the whole source.
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT TAM.BP I_REDO.B.MORTG.LOAN.DET.COMMON

    GOSUB PROCESS
    RETURN

PROCESS:
********
    CALL EB.CLEAR.FILE(FN.REDO.B.MORTG.LOAN.WORKFILE, F.REDO.B.MORTG.LOAN.WORKFILE)

    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
*    LIST.PARAMETER<3> = "START.DATE LT ":TODAY
    LIST.PARAMETER<3> := "PRODUCT.GROUP EQ 'HIPOTECARIO'"
    LIST.PARAMETER<3> := " AND PRODUCT.LINE EQ ":"LENDING"
*    LIST.PARAMETER<3> := " AND ((ARR.STATUS EQ ":"CURRENT":") OR (ARR.STATUS EQ ":"EXPIRED":"))"
    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
    RETURN
END
