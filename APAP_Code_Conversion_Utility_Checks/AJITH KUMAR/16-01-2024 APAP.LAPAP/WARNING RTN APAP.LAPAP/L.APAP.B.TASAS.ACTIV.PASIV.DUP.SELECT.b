* @ValidationCode : MjoxOTE3ODM2MDMyOkNwMTI1MjoxNzA0NzkxNTIyNTI5OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 14:42:02
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
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE L.APAP.B.TASAS.ACTIV.PASIV.DUP.SELECT
*
* Client Name   : APAP
* Develop By    : Ashokkumar
* Description   : The routine to generate the Activasa and Pasivas report AR010.
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
  *  $INSERT I_BATCH.FILES
   * $INSERT I_TSA.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_L.APAP.B.TASAS.ACTIV.PASIV.DUP.COMMON
   $USING EB.Service


*IF NOT(CONTROL.LIST) THEN
    ControlListVal = EB.Service.getControlList() ;*R22 UTILITY MANUAL CONVERSION
    IF NOT(ControlListVal) THEN ;*R22 UTILITY MANUAL CONVERSION
    
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.PROCESS
RETURN

BUILD.CONTROL.LIST:
*******************
*    CALL EB.CLEAR.FILE(FN.DR.REG.PASIVAS.ACTIV.DUP, F.DR.REG.PASIVAS.ACTIV.DUP)
EB.Service.ClearFile(FN.DR.REG.PASIVAS.ACTIV.DUP, F.DR.REG.PASIVAS.ACTIV.DUP);* R22 UTILITY AUTO CONVERSION
    *CONTROL.LIST<-1> = "SELECT.AZ"
    ControlListVal<-1> = "SELECT.AZ" ;*R22 UTILITY MANUAL CONVERSION
    *CONTROL.LIST<-1> = "SELECT.AA"
    ControlListVal<-1> = "SELECT.AA" ;*R22 UTILITY MANUAL CONVERSION
    *CONTROL.LIST<-1> = "SELECT.AC"
    ControlListVal<-1> = "SELECT.AA" ;*R22 UTILITY MANUAL CONVERSION
RETURN

SEL.PROCESS:
************
    LIST.PARAMETER = ""
    BEGIN CASE
       * CASE CONTROL.LIST<1,1> EQ "SELECT.AZ"
            CASE ControlListVal<1,1> EQ "SELECT.AZ" ;*R22 UTILITY MANUAL CONVERSION
            LIST.PARAMETER<2> = "F.AZ.ACCOUNT"
            LIST.PARAMETER<3> = "VALUE.DATE EQ ":LAST.WORK.DAY

    *CASE CONTROL.LIST<1,1> EQ "SELECT.AC"
        CASE ControlListVal<1,1> EQ "SELECT.AC" ;*R22 UTILITY MANUAL CONVERSION
            LIST.PARAMETER<2> = "F.ACCOUNT"
*        LIST.PARAMETER<3> = "OPENING.DATE EQ ":LAST.WORK.DAY
            LIST.PARAMETTER<3> = "CATEGORY GE 6000 AND CATEGORY LE 6599"

    *CASE CONTROL.LIST<1,1> EQ "SELECT.AA"
        CASE ControlListVal<1,1> EQ"SELECT.AA";*R22 UTILITY MANUAL CONVERSION
            LIST.PARAMETER = ""
            LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
            LIST.PARAMETER<3> = "ARR.STATUS EQ 'CURRENT' AND START.DATE EQ ":LAST.WORK.DAY
    END CASE
*    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
EB.Service.BatchBuildList(LIST.PARAMETER, "");* R22 UTILITY AUTO CONVERSION
RETURN
END
