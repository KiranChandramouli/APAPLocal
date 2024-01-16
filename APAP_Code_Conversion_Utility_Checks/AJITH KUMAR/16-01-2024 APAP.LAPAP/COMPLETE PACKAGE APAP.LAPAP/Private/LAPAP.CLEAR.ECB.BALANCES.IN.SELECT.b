* @ValidationCode : MjotMTY0OTM2OTM0NTpDcDEyNTI6MTcwNDgwMzY3MTYwNjphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jan 2024 18:04:31
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
SUBROUTINE LAPAP.CLEAR.ECB.BALANCES.IN.SELECT

*=====================================================================
* Routine is developed for BOAB client. This routine is used to do the below
* Its used to clear all available balances of AA account
* Update AA.SCHEDULED.ACTIVITY and AA.LENDING.NEXT.ACTIVITY
* PRODUCT.LINE - LENDING - Can modify as required for other lines
* Amount will parked in the Internal account enter by bank.
*======================================================================
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
   * $INSERT I_BATCH.FILES
   * $INSERT I_TSA.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AC.BALANCE.TYPE
    $INSERT I_F.AA.SCHEDULED.ACTIVITY
    $INSERT I_F.AA.ACTIVITY.BALANCES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_LAPAP.CLEAR.ECB.BALANCES.IN.COMMON
   $USING EB.Service

*    CALL EB.CLEAR.FILE(FN.ST.LAPAP.INFILEPRESTAMO, FV.ST.LAPAP.INFILEPRESTAMO)
EB.Service.ClearFile(FN.ST.LAPAP.INFILEPRESTAMO, FV.ST.LAPAP.INFILEPRESTAMO);* R22 UTILITY AUTO CONVERSION
*    CALL BATCH.BUILD.LIST('',RREC)
EB.Service.BatchBuildList('',RREC);* R22 UTILITY AUTO CONVERSION

RETURN
