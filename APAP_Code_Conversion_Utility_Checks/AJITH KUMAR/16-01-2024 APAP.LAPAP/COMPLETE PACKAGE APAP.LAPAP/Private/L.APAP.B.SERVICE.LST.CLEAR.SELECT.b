* @ValidationCode : MjozNTg1MTE5MTE6Q3AxMjUyOjE3MDI5ODgzNDU2MDM6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.B.SERVICE.LST.CLEAR.SELECT
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION

*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   T24.BP, is Removed , INSERT FILE MODIFIED
*18-12-2023    Santosh C           MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*----------------------------------------------------------------------------------------
****************************************************
* Company : APAP
* Decription: Routine to clear the JOB.LIST, BATCH.STATUS, JOB.STATUS & PROCESS.STATUS for the BATCH record
*             updated in the parameter table "L.APAP.REPORT.SERVICE.PARAM".
* Dev By   : Ashokkumar
*
*****************************************************
    $INSERT  I_COMMON ;*R22 MANUAL CONVERSION
    $INSERT  I_EQUATE
    $INSERT  I_F.LOCKING
*   $INSERT  I_F.BATCH ;*R22 MANUAL CONVERSION ;*R22 Manual Code Conversion_Utility Check
*   $INSERT  I_F.TSA.SERVICE ;*R22 Manual Code Conversion_Utility Check
    $INSERT  I_F.L.APAP.REPORT.SERVICE.PARAM ;*R22 MANUAL CONVERSION
    $INSERT  I_L.APAP.B.SERVICE.LST.CLEAR.COMMON ;*R22 MANUAL CONVERSION
    $USING EB.Service ;*R22 Manual Code Conversion_Utility Check


    GOSUB SELECT.PROCESS
RETURN

SELECT.PROCESS:
***************
    PARAM.ID = "SYSTEM"
    ERR.L.APAP.REPORT.SERVICE.PARAM = ''; R.L.APAP.REPORT.SERVICE.PARAM = ''; YSERVICE.NAM = ''
    CALL F.READ(FN.L.APAP.REPORT.SERVICE.PARAM,PARAM.ID,R.L.APAP.REPORT.SERVICE.PARAM,F.L.APAP.REPORT.SERVICE.PARAM,ERR.L.APAP.REPORT.SERVICE.PARAM)
    YSERVICE.NAM = R.L.APAP.REPORT.SERVICE.PARAM<RPT.SERVC.TSA.SERVICE.NAME>
*   CALL BATCH.BUILD.LIST('',YSERVICE.NAM)
    EB.Service.BatchBuildList('',YSERVICE.NAM)
RETURN
END
