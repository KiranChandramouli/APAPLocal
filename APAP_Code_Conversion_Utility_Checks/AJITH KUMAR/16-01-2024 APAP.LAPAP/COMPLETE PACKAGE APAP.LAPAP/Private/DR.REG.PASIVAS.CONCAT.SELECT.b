* @ValidationCode : MjotMzE0MTI2ODg6Q3AxMjUyOjE3MDQ3OTExNjIyMjU6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Jan 2024 14:36:02
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
SUBROUTINE DR.REG.PASIVAS.CONCAT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.PASIVAS.CONCAT
* Date           : 27-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the Active rates
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author             Modification Description
*
* 09-Oct-2014   Ashokkumar.V.P       PACS00305233:- Removed multiple Account record selection.
* 16-Apr-2015   Ashokkumar.V.P       PACS00305233:- Changed for performance issue.
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  LAPAP.BP,T24.BP is removed ,$INCLUDE to$INSERT
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
  *  $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.PASIVAS.CONCAT.COMMON
   $USING EB.Service

   * IF NOT(CONTROL.LIST) THEN
   ControlListVal = EB.Service.getControlList() ;*R22 UTILITY MANUAL CONVERSION
    IF NOT(ControlListVal) THEN ;*R22 UTILITY MANUAL CONVERSION
       
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.PROCESS
RETURN

BUILD.CONTROL.LIST:
*******************
*    CALL EB.CLEAR.FILE(FN.DR.REG.PASIVAS.GROUP, F.DR.REG.PASIVAS.GROUP)
EB.Service.ClearFile(FN.DR.REG.PASIVAS.GROUP, F.DR.REG.PASIVAS.GROUP);* R22 UTILITY AUTO CONVERSION

   * CONTROL.LIST<-1> = "SELECT.AZ"
    *CONTROL.LIST<-1> = "GRP.16"
     ControlListVal<-1> = "SELECT.AZ" ;*R22 UTILITY MANUAL CONVERSION
     ControlListVal<-1> = "GRP.16" ;*R22 UTILITY MANUAL CONVERSION
RETURN

SEL.PROCESS:
************
    LIST.PARAMETER = ""
    BEGIN CASE
       * CASE CONTROL.LIST<1,1> EQ "SELECT.AZ"
            CASE ControlListVal<1,1> EQ "SELECT.AZ" ;*R22 UTILITY MANUAL CONVERSION
            LIST.PARAMETER<2> = "F.AZ.ACCOUNT"
            LIST.PARAMETER<3> = "VALUE.DATE EQ ":LAST.WORK.DAY
*            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
EB.Service.BatchBuildList(LIST.PARAMETER, "");* R22 UTILITY AUTO CONVERSION

    *CASE CONTROL.LIST<1,1> EQ "GRP.16"
        CASE ControlListVal<1,1> EQ "GRP.16" ;*R22 UTILITY MANUAL CONVERSION
            LIST.PARAMETER<2> = "F.ACCT.ENT.LWORK.DAY"
            LIST.PARAMETER<3> = "@ID LIKE 1..."
*            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
EB.Service.BatchBuildList(LIST.PARAMETER, "");* R22 UTILITY AUTO CONVERSION
    END CASE
RETURN

END
