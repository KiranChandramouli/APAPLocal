SUBROUTINE REDO.B.CONS.LOAN.DET.SELECT
* -------------------------------------------------------------------------------------------------
* Description           : This is the Batch Select Routine used to select the records based on the
*                         conditions and pass the selected record array to main routine
* Developed By          : Vijayarani G
* Development Reference : 786834(FS-209-DE23)
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
* PACS00340818           Ashokkumar.V.P                 31/10/2014            New mapping changes - Rewritten the whole source.
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CONS.LOAN.DET.COMMON

    GOSUB PROCESS
RETURN

PROCESS:
********
    CALL EB.CLEAR.FILE(FN.DR.REG.DE23.WORKFILE, F.DR.REG.DE23.WORKFILE)
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
*    LIST.PARAMETER<3> = "START.DATE LT ":TODAY
    LIST.PARAMETER<3> := "(PRODUCT.GROUP EQ ":"CONSUMO":" OR PRODUCT.GROUP EQ ":"LINEAS.DE.CREDITO":")"
    LIST.PARAMETER<3> := " AND PRODUCT.LINE EQ ":"LENDING"
*    LIST.PARAMETER<3> := " AND ((ARR.STATUS EQ ":"CURRENT":") OR (ARR.STATUS EQ ":"EXPIRED":"))"
    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
RETURN
END
