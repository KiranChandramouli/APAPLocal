* @ValidationCode : MjotMTE1MDk5MTc2MzpDcDEyNTI6MTY5MDE2NzU0NTExODpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.GEN.ACSTMT.FORM.RT.SELECT

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 20-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ST.LAPAP.CONTROL.ESTADOS
    $INSERT I_LAPAP.GEN.ACSTMT.FORM.RT.COMMON
   $USING EB.Service

    SEL.CMD = "SELECT " : FN.CE : " WITH BANK.DATE EQ " : TODAY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.RECS,SEL.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION

RETURN


END
