*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.OFS.INTEREST.PAID.LOAD

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.DATES
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.AZ.ACCOUNT
    $INSERT T24.BP I_F.STMT.ACCT.CR

    $INSERT LAPAP.BP I_LAPAP.OFS.INTEREST.PAID.COMMON

    FN.AZ = "F.AZ.ACCOUNT"
    F.AZ = ""
    CALL OPF(FN.AZ,F.AZ)

    FN.ST = "F.STMT.ACCT.CR"
    F.ST = ""
    CALL OPF(FN.ST,F.ST)

    FN.DT = "F.DATES"
    F.DT = ""
    CALL OPF(FN.DT,F.DT)

    FN.AC = "F.ACCOUNT"
    F.AC = ""
    CALL OPF(FN.AC,F.ACC)

RETURN

END
