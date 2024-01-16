* @ValidationCode : MjoyMDQ2MjIxNzQ6Q3AxMjUyOjE2OTAxNjc1MzU2NzU6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:55
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
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.SOYB.BAL.RT.SELECT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No changes
* 13-07-2023     Harishvikram C   Manual R22 conversion       BP Removed
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.ST.L.APAP.SOYB
    $INSERT  I_APAP.SOYB.BAL.COMMON
   $USING EB.Service

    GOSUB DO.SELECT
RETURN

DO.SELECT:
    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT " : FN.AC : " WITH CATEGORY GE 6000 AND CATEGORY LE 6599 AND CATEGORY NE 6013 AND CATEGORY NE 6014 AND CATEGORY NE 6015 AND CATEGORY NE 6016 AND CATEGORY NE 6017 AND CATEGORY NE 6018 AND CATEGORY NE 6019 AND CATEGORY NE 6020"
    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.REC)
EB.Service.BatchBuildList('',SEL.REC);* R22 UTILITY AUTO CONVERSION

RETURN

END
