*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.TDANUCHG.RT.LOAD
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT TAM.BP I_F.LATAM.CARD.ORDER
    $INSERT T24.BP I_F.AC.CHARGE.REQUEST
    $INSERT BP I_F.ST.LAPAP.TD.ANUAL.CH
    $INSERT T24.BP I_F.DATES
    $INSERT LAPAP.BP I_L.APAP.TDANUCHG.COMMON
    $INSERT T24.BP I_F.ACCOUNT

    FN.CT = "F.CARD.TYPE"
    F.CT = ""
    R.CT = ""
    CT.ERR = ""
    CALL OPF(FN.CT,F.CT)

    FN.LCO = "F.LATAM.CARD.ORDER"
    F.LCO = ""
    R.LCO = ""
    TD.LCO = ""
    CALL OPF(FN.LCO,F.LCO)

    FN.TD.ANU = "F.ST.LAPAP.TD.ANUAL.CH"
    F.TD.ANU = ""
    R.TD.ANU = ""
    TD.ANU.ERR = ""
    CALL OPF(FN.TD.ANU,F.TD.ANU)

    FN.DATE = "F.DATES"
    F.DATE = ""
    R.DATE = ""
    DATE.ERR = ""
    CALL OPF(FN.DATE,F.DATE)

    FN.ACC = "F.ACCOUNT"
    F.ACC = ""
    R.ACC = ""
    ACC.ERR = ""
    CALL OPF(FN.ACC,F.ACC)

    RETURN

END
