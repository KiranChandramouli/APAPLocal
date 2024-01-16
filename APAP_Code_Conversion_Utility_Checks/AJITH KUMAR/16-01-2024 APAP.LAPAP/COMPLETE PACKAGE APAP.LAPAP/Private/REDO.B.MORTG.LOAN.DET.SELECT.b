$PACKAGE APAP.LAPAP
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
* PACS00362987           Ashokkumar.V.P                 29/10/2014            New mapping changes - Rewritten the whole source
** 24-04-2023 R22 Auto Conversion
** 24-04-2023 Skanda R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_REDO.B.MORTG.LOAN.DET.COMMON ;* R22 Auto conversion
   $USING EB.Service

    GOSUB PROCESS
RETURN

PROCESS:
********
*    CALL EB.CLEAR.FILE(FN.REDO.B.MORTG.LOAN.WORKFILE, F.REDO.B.MORTG.LOAN.WORKFILE)
EB.Service.ClearFile(FN.REDO.B.MORTG.LOAN.WORKFILE, F.REDO.B.MORTG.LOAN.WORKFILE);* R22 UTILITY AUTO CONVERSION

    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
*    LIST.PARAMETER<3> = "START.DATE LT ":TODAY
    LIST.PARAMETER<3> := "PRODUCT.GROUP EQ 'HIPOTECARIO'"
    LIST.PARAMETER<3> := " AND PRODUCT.LINE EQ ":"LENDING"
*    LIST.PARAMETER<3> := " AND ((ARR.STATUS EQ ":"CURRENT":") OR (ARR.STATUS EQ ":"EXPIRED":"))"
*    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
EB.Service.BatchBuildList(LIST.PARAMETER, "");* R22 UTILITY AUTO CONVERSION
RETURN
END
