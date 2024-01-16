* @ValidationCode : MjotMTc1NDQ5NzkzODpDcDEyNTI6MTcwNDc4ODQ1NTA1OTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jan 2024 13:50:55
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
SUBROUTINE DR.REG.COMM.LOAN.SECTOR.EXT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.COMMERCIAL.LOAN.SECTOR.EXTRACT
* Date           : 16-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the AA.ARRANGEMENT application where the AA.GROUP.PRODUCT = COMERCIAL
* and the AA.STATUS is equal to  ("CURRENT" or "EXPIRED")
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 03-Oct-2014  Ashokkumar           PACS00305229:- Displaying Credit lines details
* 12-May-2015  Ashokkumar.V.P       PACS00305229:- Added new fields mapping change.
* 26-Jun-2015  Ashokkumar.V.P       PACS00466618:- Fixed the NAB account created on same date for old NAB loans
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   T24.BP ,LAPAP.BP is removed, $INCLUDE to $INSERT
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
   * $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.COMMON
   $USING EB.Service

    *IF NOT(CONTROL.LIST) THEN
        ControlListVal = EB.Service.getControlList() ;*R22 UTILITY MANUAL CONVERSION
       IF NOT(ControlListVal) THEN ;*R22 UTILITY MANUAL CONVERSION
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.PROCESS
RETURN

*-----------------------------------------------------------------------------
BUILD.CONTROL.LIST:
*******************

*    CALL EB.CLEAR.FILE(FN.DR.REG.COM.LOAN.SECTOR.WORKFILE,F.DR.REG.COM.LOAN.SECTOR.WORKFILE)
EB.Service.ClearFile(FN.DR.REG.COM.LOAN.SECTOR.WORKFILE,F.DR.REG.COM.LOAN.SECTOR.WORKFILE);* R22 UTILITY AUTO CONVERSION
   * CONTROL.LIST<-1> = "AA.DETAILS"
     ControlListVal<-1> = "AA.DETAILS" ;*R22 UTILITY MANUAL CONVERSION

RETURN
*-----------------------------------------------------------------------------

SEL.PROCESS:
************

    LIST.PARAMETER = ""

    BEGIN CASE
      *  CASE CONTROL.LIST<1,1> EQ "AA.DETAILS"
            CASE ControlListVal<1,1> EQ "AA.DETAILS" ;*R22 UTILITY MANUAL CONVERSION
            LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
            LIST.PARAMETER<3> := "PRODUCT.LINE EQ ":"LENDING"
            LIST.PARAMETER<3> := " AND PRODUCT.GROUP EQ ":Y.TXNPGRP.VAL.ARR
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
