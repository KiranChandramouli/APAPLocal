*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.ASA.L.V.RT.LOAD
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT BP I_F.ST.L.APAP.ASAMBLEA.PARTIC
    $INSERT LAPAP.BP I_LAPAP.ASA.L.V.COMMON

    GOSUB OPENER.EXEC
    RETURN

OPENER.EXEC:
    FN.PA = "FBNK.ST.L.APAP.ASAMBLEA.PARTIC"
    FV.PA = ""
    CALL OPF(FN.PA,F.PA)

    EXECUTE("CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.VOTANTE")
    EXECUTE("CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.VOTANTE$HIS")
    EXECUTE("CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.VOTANTE$NAU")
    RETURN
END
