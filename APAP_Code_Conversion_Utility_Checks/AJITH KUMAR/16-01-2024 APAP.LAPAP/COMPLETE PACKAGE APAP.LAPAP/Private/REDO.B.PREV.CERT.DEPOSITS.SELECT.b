* @ValidationCode : MjoyMjg1MDIzNDk6Q3AxMjUyOjE3MDUzODEwNzYxNjA6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 Jan 2024 10:27:56
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
SUBROUTINE REDO.B.PREV.CERT.DEPOSITS.SELECT
* -------------------------------------------------------------------------------------------------
* Description           : This is the Batch Load Routine used to initalize all the required variables
*
* Developed By          : Amaravathi Krithika B
* Development Reference : CA01
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
* Defect Reference       Modified By      Date of Change        Change Details
* (RTC/TUT/PACS)
*                    CONVERSION TOOL        24/05/2023       AUTO R22 CODE CONVERSION - NEWLINE ADDED,T24.BP IS REMOVED, CHANGED Y.LST.WORKING TO YTODAY.DAT
*                    VIGNESWARI             06/06/2023       MANUAL R22 CODE CONVERSION - Y.STAT.MONTH and YTODAY.DAT Added in I_REDO.B.PREV.CERT.DEPOSITS.COMMON file
*----------------------------------------------------------------------------------------

*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
 *   $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_REDO.B.PREV.CERT.DEPOSITS.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
   $USING EB.Service

    GOSUB SEL.DEPOSITS
RETURN

SEL.DEPOSITS:
*-----------
   * IF CONTROL.LIST EQ "" THEN
        ControlListVal = EB.Service.getControlList() ;*R22 UTILITY MANUAL CONVERSION
        IF NOT(ControlListVal) THEN ;*R22 UTILITY MANUAL CONVERSION
    
        *CONTROL.LIST = "AZ":@FM:"ACBAL.HIST"
        ControlListVal = "AZ":@FM:"ACBAL.HIST" ;*R22 UTILITY MANUAL CONVERSION
    END
    BEGIN CASE
       * CASE CONTROL.LIST<1> EQ "AZ"
            CASE ControlListVal<1,1> EQ "AZ" ;*R22 UTILITY MANUAL CONVERSION
*            CALL EB.CLEAR.FILE(FN.DR.REG.CA01.WORKFILE,F.DR.REG.CA01.WORKFILE) ;*AUTO R22 CODE CONVERSION
EB.Service.ClearFile(FN.DR.REG.CA01.WORKFILE,F.DR.REG.CA01.WORKFILE) ;*AUTO R22 CODE CONVERSION;* R22 UTILITY AUTO CONVERSION
            SEL.AZ.ACC = "SELECT ":FN.AZ.ACC:" WITH VALUE.DATE GE ":Y.STAT.MONTH:" AND VALUE.DATE LE ":YTODAY.DAT
            CALL EB.READLIST(SEL.AZ.ACC,SEL.LIST.AZ,'',NO.OF.REC,SEL.ERR)
*            CALL BATCH.BUILD.LIST('',SEL.LIST.AZ)
EB.Service.BatchBuildList('',SEL.LIST.AZ);* R22 UTILITY AUTO CONVERSION
    *CASE CONTROL.LIST<1> EQ "ACBAL.HIST"
        CASE ControlListVal<1,1> EQ "ACBAL.HIST"
            SEL.AZ.HIS = "SELECT ":FN.AZ.ACC.BAL.HIST:" WITH DATE GE ":Y.STAT.MONTH:" AND DATE LE ":YTODAY.DAT:" BY-DSND @ID ";*R22 Manual Conversion - Y.STAT.MONTH and YTODAY.DAT Added in I_REDO.B.PREV.CERT.DEPOSITS.COMMON file
            CALL EB.READLIST(SEL.AZ.HIS,SEL.LIST.AZ,'',NO.OF.REC,SEL.ERR.HIS)
*            CALL BATCH.BUILD.LIST('',SEL.LIST.AZ)
EB.Service.BatchBuildList('',SEL.LIST.AZ);* R22 UTILITY AUTO CONVERSION
    END CASE
RETURN
END
