*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.TDANUCHG.RT.SELECT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT TAM.BP I_F.LATAM.CARD.ORDER
    $INSERT T24.BP I_F.AC.CHARGE.REQUEST
    $INSERT BP I_F.ST.LAPAP.TD.ANUAL.CH
    $INSERT T24.BP I_F.DATES
    $INSERT LAPAP.BP I_L.APAP.TDANUCHG.COMMON

    CALL F.READ(FN.DATE,'DO0010001',R.DATE, F.DATE, DATE.ERR)
    Y.LAST.WORKING.DAY = R.DATE<EB.DAT.LAST.WORKING.DAY>
*We better select the entire LATAM.CARD.ORDER TABLE because we cannot do calculated filter in select command.
    SEL.CMD = "SELECT " : FN.LCO
    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.RECS,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

    RETURN

END
