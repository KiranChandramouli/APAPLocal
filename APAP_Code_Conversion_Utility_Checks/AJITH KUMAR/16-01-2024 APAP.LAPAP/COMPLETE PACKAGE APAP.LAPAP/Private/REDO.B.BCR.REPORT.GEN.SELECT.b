* @ValidationCode : MjotMTE0OTg4OTY3OkNwMTI1MjoxNzA1MDQ2ODI4MDI2OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Jan 2024 13:37:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Version 1 13/04/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.BCR.REPORT.GEN.SELECT
*-----------------------------------------------------------------------------
* Select routine to setup the common area for the multi-threaded Close of Business
* job TEMPLATE.EOD.
*-----------------------------------------------------------------------------
* 2011-08-28 : PACS00060197  - C.22 Integration
*              hpasquel@temenos.com
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 24.04.2023       Conversion Tool       R22            Auto Conversion     - INSERT file folder name removed T24.BP, TAM.BP, LAPAP.BP
* 24.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON                       ;** R22 Auto Conversion - Start
    $INSERT I_EQUATE
  *  $INSERT I_BATCH.FILES
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_F.DATES                      ;** R22 Auto Conversion - End
   $USING EB.Service
*
    $INSERT I_F.REDO.BCR.REPORT.DATA            ;** R22 Auto Conversion - Start
    $INSERT I_REDO.B.BCR.REPORT.GEN.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.BCR.REPORT.EXEC            ;** R22 Auto Conversion - End
*

    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    LIST.PARAMETERS = '' ; ID.LIST = ''

*SEL.CMD = "SELECT ":FN.AA:" WITH ARR.STATUS EQ 'CURRENT' 'EXPIRED' 'PENDING.CLOSURE' 'CLOSE' AND PRODUCT.LINE EQ 'LENDING' AND PRODUCT.GROUP NE 'LINEAS.DE.CREDITO.TC' "
    SEL.CMD = "SELECT ":FN.AA:" WITH PRODUCT.LINE EQ 'LENDING' "
    CALL EB.READLIST(SEL.CMD,AA.LIST,'',NO.REC,PGM.ERR)

    CALL OCOMO("Total of records to process " : NO.REC)
*    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,AA.LIST)
EB.Service.BatchBuildList(LIST.PARAMETERS,AA.LIST);* R22 UTILITY AUTO CONVERSION
*    CALL EB.CLEAR.FILE(FN.DATA,F.DATA)
EB.Service.ClearFile(FN.DATA,F.DATA);* R22 UTILITY AUTO CONVERSION
RETURN
*-----------------------------------------------------------------------------
END
