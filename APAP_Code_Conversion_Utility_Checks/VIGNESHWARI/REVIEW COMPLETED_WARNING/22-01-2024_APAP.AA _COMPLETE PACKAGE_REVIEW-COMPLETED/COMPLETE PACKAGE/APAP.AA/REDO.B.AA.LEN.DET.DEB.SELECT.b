* @ValidationCode : MjotMTgyMzg4ODU4NTpDcDEyNTI6MTcwMzY4MTMzNzE3ODp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Dec 2023 18:18:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
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
* PACS00361224           Ashokkumar.V.P                 30/10/2014            New mapping changes - Rewritten the whole source

*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - INSERT file folder name removed T24.BP, LAPAP.BP
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - no changes
*27-12-2023       VIGNESHWARI S      R22 MANUAL CONVERSTION       call rtn modified
*
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON                                  ;** R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_REDO.B.AA.LEN.DET.DEB.COMMON            ;** R22 Auto conversion - END
    $USING EB.Service
    
    
    GOSUB PROCESS
RETURN

PROCESS:
********
    *CALL EB.CLEAR.FILE(FN.DR.REG.DE21.WORKFILE, F.DR.REG.DE21.WORKFILE)
    EB.Service.ClearFile(FN.DR.REG.DE21.WORKFILE, F.DR.REG.DE21.WORKFILE) ;*R22 MANUAL CODE CONVERSION- CALL RTN MODIFIED
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
*    LIST.PARAMETER<3> = "START.DATE LE ":Y.LAST.WORK.DAY
    LIST.PARAMETER<3> := "(PRODUCT.GROUP EQ ":"COMERCIAL":" OR PRODUCT.GROUP EQ ":"LINEAS.DE.CREDITO":")"
    LIST.PARAMETER<3> := " AND PRODUCT.LINE EQ ":"LENDING"
*    LIST.PARAMETER<3> := " AND ((ARR.STATUS EQ ":"CURRENT":") OR (ARR.STATUS EQ ":"EXPIRED":"))"
  *  CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
    EB.Service.BatchBuildList(LIST.PARAMETER, "") ;*R22 MANUAL CODE CONVERSION- CALL RTN MODIFIED

RETURN
END
