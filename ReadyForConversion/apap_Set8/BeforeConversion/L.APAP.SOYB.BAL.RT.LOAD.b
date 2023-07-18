*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.SOYB.BAL.RT.LOAD
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.DATES
    $INSERT BP I_F.ST.L.APAP.SOYB
    $INSERT LAPAP.BP I_APAP.SOYB.BAL.COMMON

    GOSUB INITIAL

    RETURN

INITIAL:
    FN.AC = "F.ACCOUNT"
    F.AC = ""
    CALL OPF(FN.AC,F.AC)
    FN.SOYB = "FBNK.ST.L.APAP.SOYB"
    F.SOYB = ""
    CALL OPF(FN.SOYB,F.SOYB)
    Y.FECHA = R.DATES(EB.DAT.TODAY)

    EXECUTE("CLEAR.FILE FBNK.ST.L.APAP.SOYB")
    EXECUTE("CLEAR.FILE FBNK.ST.L.APAP.SOYB$HIS")

    RETURN

END
