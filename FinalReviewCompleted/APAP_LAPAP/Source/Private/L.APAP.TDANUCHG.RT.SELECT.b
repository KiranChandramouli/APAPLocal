* @ValidationCode : MjotODI3NTU2NDA4OkNwMTI1MjoxNjkwMTY3NTM2MDM2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
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
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.TDANUCHG.RT.SELECT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No changes
* 13-07-2023     Harishvikram C   Manual R22 conversion       BP Removed
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.LATAM.CARD.ORDER
    $INSERT  I_F.AC.CHARGE.REQUEST
    $INSERT  I_F.ST.LAPAP.TD.ANUAL.CH
    $INSERT  I_F.DATES
    $INSERT  I_L.APAP.TDANUCHG.COMMON

    CALL F.READ(FN.DATE,'DO0010001',R.DATE, F.DATE, DATE.ERR)
    Y.LAST.WORKING.DAY = R.DATE<EB.DAT.LAST.WORKING.DAY>
*We better select the entire LATAM.CARD.ORDER TABLE because we cannot do calculated filter in select command.
    SEL.CMD = "SELECT " : FN.LCO
    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.RECS,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
