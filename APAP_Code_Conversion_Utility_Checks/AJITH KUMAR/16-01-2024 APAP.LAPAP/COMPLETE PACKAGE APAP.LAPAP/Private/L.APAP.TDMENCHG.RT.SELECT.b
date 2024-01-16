* @ValidationCode : MjotMTQ1NTM1NTQzMDpDcDEyNTI6MTY5MDE2NzUzNjE2MTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:56
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
SUBROUTINE L.APAP.TDMENCHG.RT.SELECT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No changes
* 13-07-2023     Harishvikram C   Manual R22 conversion      BP Removed
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.LATAM.CARD.ORDER
    $INSERT  I_F.AC.CHARGE.REQUEST
    $INSERT  I_F.ST.LAPAP.TD.MEN.CH
    $INSERT  I_F.DATES
    $INSERT  I_L.APAP.TDMENCHG.COMMON
   $USING EB.Service

*    CALL F.READ(FN.DATE,'DO0010001',R.DATE, F.DATE, DATE.ERR)
IDVAR.1 = 'DO0010001' ;* R22 UTILITY AUTO CONVERSION
    CALL F.READ(FN.DATE,IDVAR.1,R.DATE, F.DATE, DATE.ERR);* R22 UTILITY AUTO CONVERSION
    Y.LAST.WORKING.DAY = R.DATE<EB.DAT.LAST.WORKING.DAY>

    SEL.CMD = "SELECT " : FN.LCO
    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.RECS,SEL.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION

RETURN

END
