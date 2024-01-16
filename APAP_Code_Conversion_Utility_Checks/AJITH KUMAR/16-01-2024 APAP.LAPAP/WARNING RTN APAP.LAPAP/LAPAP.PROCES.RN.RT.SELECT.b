* @ValidationCode : MjotMTQ5NDQxNDAxMzpDcDEyNTI6MTcwNTAzNzUzMTM3Mzphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jan 2024 11:02:11
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
SUBROUTINE LAPAP.PROCES.RN.RT.SELECT
*--------------------------------------------------------------------------------------------------
* Description           : Rutina SELECT para el proceso de actualizacion RN o RT
* Developed On          : 23-10-2021
* Developed By          : APAP
* Development Reference : ET-5416
*--------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 14-07-2023    Narmadha V             R22 Manual Conversion   No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion -START
    $INSERT I_EQUATE
   * $INSERT I_BATCH.FILES
   * $INSERT I_TSA.COMMON
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_LAPAP.PROCES.RN.RT.COMMON ;*R22 Auto Conversion -END
   $USING EB.Service



*    CALL EB.CLEAR.FILE(FN.LAPAP.CONCATE.RN.RT, FV.LAPAP.CONCATE.RN.RT)
EB.Service.ClearFile(FN.LAPAP.CONCATE.RN.RT, FV.LAPAP.CONCATE.RN.RT);* R22 UTILITY AUTO CONVERSION
    SEL.CMD = " SELECT " : FN.AA.ARRANGEMENT.ACTIVITY:" WITH EFFECTIVE.DATE EQ ":TODAY:" AND ACTIVITY EQ ":Y.ACTIVIDAD
    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.RECS,SEL.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION

RETURN

END
