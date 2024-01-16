* @ValidationCode : MjotMTUxNjEzNTE5NTpDcDEyNTI6MTY5MDE2NzU1NzM3MzpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:17
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
*-------------------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE		  AUTHOR		         Modification                 DESCRIPTION
*13/07/2023	 VIGNESHWARI        MANUAL R22 CODE CONVERSION	      NOCHANGE
*13/07/2023	 CONVERSION TOOL    AUTO R22 CODE CONVERSION	   T24.BP,LAPAP.BP is removed in insertfile,$INCLUDE changed to $INSERT
*-------------------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.AZ.REINV.REVERSE.SELECT
*
* Description: This is routine to remove the inactive / closed deposit reinvested account.
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_REDO.AZ.REINV.REVERSE.COMMON
   $USING EB.Service

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    SEL.ACCT = ''; SEL.REC = ''; SEL.LIST = ''; SEL.ERR = ''; Y.AZ.CATEGORY = ''
RETURN

PROCESS:
********
    SEL.ACCT = "SELECT ":FN.ACCOUNT:" WITH ((CATEGORY GE '6013' AND CATEGORY LE '6020') OR (CATEGORY GE '6600' AND CATEGORY LE '6699')) AND (ONLINE.ACTUAL.BAL EQ 0 OR ONLINE.ACTUAL.BAL EQ '')"
    CALL EB.READLIST(SEL.ACCT,SEL.REC,'',SEL.LIST,SEL.ERR)
*    CALL BATCH.BUILD.LIST("",SEL.REC)
EB.Service.BatchBuildList("",SEL.REC);* R22 UTILITY AUTO CONVERSION
RETURN
END
