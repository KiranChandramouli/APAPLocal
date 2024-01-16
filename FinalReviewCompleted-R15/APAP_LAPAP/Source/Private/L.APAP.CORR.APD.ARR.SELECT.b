* @ValidationCode : MjoxMTMzMDc3NjkxOkNwMTI1MjoxNzA1MDY3OTc1Mjk3OklUU1MxOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Jan 2024 19:29:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.LAPAP
**===========================================================================================================================================
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.CORR.APD.ARR.SELECT
**===========================================================================================================================================
**  This routine is developed to update AA.PROCESS.DETAILS. Where the AAA record has some missing AA.ARR.<<PROPERTY>> records in NAU.
**  Some of the child activities linked in AA.RR.CONTROL is not available in NAU
**
**  Correction will done to loop through AA.RR.CONTROL and remove the AAA which are missing in NAU
**  AA.PROCESS.DETAILS will be validated and missing AA.ARR.<<PROPERTY>> link will be removed
**  Then delete the MASTER activity.
*
**===========================================================================================================================================
*** Modification history
*--------------------------
*   DATE          WHO                 REFERENCE               DESCRIPTION
*   12-01-2024    Santosh        R22 MANUAL CONVERSION        BP removed, added I_ in COMMON file
**===========================================================================================================================================
    $INSERT I_COMMON
    $INSERT I_EQUATE
*   $INSERT I_BATCH.FILES
*   $INSERT I_TSA.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.PROCESS.DETAILS
    $INSERT I_AA.RR.CONTROL
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_L.APAP.CORR.APD.ARR.COMMON
    $USING EB.Service
**===========================================================================================================================================
    SEL.LIST = AA.ACCOUNT.LIST;
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION
RETURN
END
