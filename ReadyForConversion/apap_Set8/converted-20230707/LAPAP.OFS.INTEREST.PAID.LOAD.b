SUBROUTINE LAPAP.OFS.INTEREST.PAID.LOAD

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.STMT.ACCT.CR

    $INSERT I_LAPAP.OFS.INTEREST.PAID.COMMON

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
