* @ValidationCode : MjotMTAyMjAxMTY3NDpDcDEyNTI6MTcwNDE5OTc3MzY0Mzp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Jan 2024 18:19:33
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
SUBROUTINE REDO.CONV.AA.DISB.PROCESS.SELECT

*-------------------------------------------------
*Description: This batch routine is to change the arrangement status for inconsistent entries
*-------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE        
* 29-MAR-2023      Conversion Tool       R22 Auto Conversion - No changes          
* 29-MAR-2023      Harsha                R22 Manual Conversion - No changes     
* 02-JAN-2024     VIGNESHWARI                R22 Manual Conversion - CALL method format changed                        
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.CONV.AA.DISB.PROCESS.COMMON
    $USING EB.Service

    GOSUB PROCESS

RETURN
*-------------------------------------------------
PROCESS:
*-------------------------------------------------

    SEL.CMD = "SELECT ":FN.REDO.DISB.CHAIN:" WITH DATE LT '20170811'"
    SEL.LIST = ''
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)
   * CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST);* R22 Manual Conversion - CALL method format changed 
RETURN
END
