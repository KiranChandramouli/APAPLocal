* @ValidationCode : MjotMTUzNjY1OTY2OTpDcDEyNTI6MTcwMzc1ODY1Nzk0NDp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 28 Dec 2023 15:47:37
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
SUBROUTINE REDO.B.AA.UNC.PENDING.SELECT

*-------------------------------------------------
*Description: This batch routine is to change the arrangement status for inconsistent entries
*-------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 29-MAR-2023      Harsha                R22 Manual Conversion - No changes
* 29-MAR-2023      Conversion Tool       R22 Auto Conversion - No changes
*28-12-2023       VIGNESHWARI S      R22 MANUAL CONVERSTION - call rtn modified
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.AA.UNC.PENDING
    $INSERT I_REDO.B.AA.UNC.PENDING.COMMON
    $USING EB.Service

    GOSUB PROCESS

RETURN
*-------------------------------------------------
PROCESS:
*-------------------------------------------------

    SEL.CMD = "SELECT ":FN.REDO.AA.UNC.PENDING:" WITH ARR.STATUS EQ 'PENDING.CLOSURE'"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    *CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST) ;*R22 MANUAL CONVERSTION - call rtn modified
RETURN
END
