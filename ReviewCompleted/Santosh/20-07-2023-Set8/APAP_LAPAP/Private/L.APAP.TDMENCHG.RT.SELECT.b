* @ValidationCode : MjotMTQ1NTM1NTQzMDpDcDEyNTI6MTY4OTMxOTU3Mjg3NTpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Jul 2023 12:56:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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

    CALL F.READ(FN.DATE,'DO0010001',R.DATE, F.DATE, DATE.ERR)
    Y.LAST.WORKING.DAY = R.DATE<EB.DAT.LAST.WORKING.DAY>

    SEL.CMD = "SELECT " : FN.LCO
    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.RECS,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
