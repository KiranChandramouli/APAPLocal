*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.GEN.ACSTMT.FORM.RT.SELECT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT BP I_F.ST.LAPAP.CONTROL.ESTADOS
    $INSERT LAPAP.BP I_LAPAP.GEN.ACSTMT.FORM.RT.COMMON

    SEL.CMD = "SELECT " : FN.CE : " WITH BANK.DATE EQ " : TODAY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.RECS,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

    RETURN


END
