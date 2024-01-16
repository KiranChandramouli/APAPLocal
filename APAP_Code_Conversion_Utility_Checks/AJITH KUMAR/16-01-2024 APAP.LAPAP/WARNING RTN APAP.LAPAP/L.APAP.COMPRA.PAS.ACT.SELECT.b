* @ValidationCode : MjotMTY5NTkwMjczOTpDcDEyNTI6MTcwNDc5Mjk3NDA4ODphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jan 2024 15:06:14
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
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     T24.BP is Removed,LAPAP.BP is Removed
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   INSERRT FILE CHANGE
*---------------------------------------------------------------------------------------	-
SUBROUTINE L.APAP.COMPRA.PAS.ACT.SELECT
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT ;* R22 Auto code conversion
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.CUSTOMER
  *  $INSERT I_BATCH.FILES
    $INSERT I_L.APAP.COMPRA.PAS.ACT.COMMON ;*R22 MANUAL CONVERSION - INSERT NAME CHANGE
    $INSERT I_F.DATES
    $INSERT I_F.BASIC.INTEREST
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.GROUP.CREDIT.INT
   $USING EB.Service
    SEL.CMD = " SELECT " : FN.CUS
    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.RECS,SEL.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION
RETURN
END
