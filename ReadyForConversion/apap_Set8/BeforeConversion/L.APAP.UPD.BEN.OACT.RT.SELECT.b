*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.UPD.BEN.OACT.RT.SELECT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.BENEFICIARY
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT LAPAP.BP I_L.APAP.UPD.BEN.OACT.RT.COMMON

    SEL.CMD = "SELECT " : FN.BEN : " WITH TRANSACTION.TYPE EQ AC25 AND L.BEN.OWN.ACCT NE YES"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.RECS,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

    RETURN

END
