*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.UPD.BEN.OACT.RT.SELECT
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_F.CUSTOMER
    $INSERT I_L.APAP.UPD.BEN.OACT.RT.COMMON

    SEL.CMD = "SELECT " : FN.BEN : " WITH TRANSACTION.TYPE EQ AC25 AND L.BEN.OWN.ACCT NE YES"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.RECS,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

    RETURN

END
