* @ValidationCode : MjoxNjY0MjcxMjM0OkNwMTI1MjoxNzA0NzkxMzE4ODcyOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 14:38:38
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
SUBROUTINE DR.REG.REGN16.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.REGN16.EXTRACT
* Date           : 3-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the REDO.ISSUE.CLAIMS Details for each Customer
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*21/08/2014       Ashokkumar            PACS00366332- Added to run on Quaterly Basis
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INCLUDE LAPAP.BP TO $INSERT
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    *$INSERT I_BATCH.FILES
    $INSERT I_DR.REG.REGN16.EXTRACT.COMMON
   $USING EB.Service


   * IF NOT(CONTROL.LIST) THEN
        ControlListVal = EB.Service.getControlList() ;*R22 UTILITY MANUAL CONVERSION
    IF NOT(ControlListVal) THEN ;*R22 UTILITY MANUAL CONVERSION
        GOSUB BUILD.CONTROL.LIST
    END

    GOSUB SEL.PROCESS
RETURN

*-----------------------------------------------------------------------------
BUILD.CONTROL.LIST:
*******************

*    CALL EB.CLEAR.FILE(FN.DR.REG.REGN16.WORKFILE, F.DR.REG.REGN16.WORKFILE)
EB.Service.ClearFile(FN.DR.REG.REGN16.WORKFILE, F.DR.REG.REGN16.WORKFILE);* R22 UTILITY AUTO CONVERSION
   * CONTROL.LIST<-1> = "CLAIMS.DETAIL"
    ControlListVal<-1> = "CLAIMS.DETAIL";*R22 UTILITY MANUAL CONVERSION

RETURN
*-----------------------------------------------------------------------------
SEL.PROCESS:
************

    LIST.PARAMETER = ""

    BEGIN CASE
       * CASE CONTROL.LIST<1,1> EQ "CLAIMS.DETAIL"
            CASE ControlListVal<1,1> EQ "CLAIMS.DETAIL" ;*R22 UTILITY MANUAL CONVERSION
            LIST.PARAMETER<2> = "F.REDO.ISSUE.CLAIMS"
            LIST.PARAMETER<3> = "OPENING.DATE GE ":REP.START.DATE:" AND WITH OPENING.DATE LE ":REP.END.DATE:" AND WITH TYPE EQ ":TYPE.VAL
*            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
EB.Service.BatchBuildList(LIST.PARAMETER, "");* R22 UTILITY AUTO CONVERSION
        CASE 1
            DUMMY.LIST = ""
*            CALL BATCH.BUILD.LIST("",DUMM.LIST)
EB.Service.BatchBuildList("",DUMM.LIST);* R22 UTILITY AUTO CONVERSION
    END CASE
RETURN
*-----------------------------------------------------------------------------
END
