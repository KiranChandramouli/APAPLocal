*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.OFS.INTEREST.PAID.SELECT

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.DATES
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.AZ.ACCOUNT
    $INSERT T24.BP I_F.STMT.ACCT.CR

    $INSERT LAPAP.BP I_LAPAP.OFS.INTEREST.PAID.COMMON

    SEL.CMD.AZ = "SELECT FBNK.AZ.ACCOUNT"
    CALL EB.READLIST(SEL.CMD.AZ,SEL.LIST.AZ,'',NO.OF.RECS,SEL.ERR.AZ)

    CALL BATCH.BUILD.LIST('',SEL.LIST.AZ)
*CALL LAPAP.OFS.INTEREST.PAID(SEL.LIST.AZ)

    RETURN

END
