*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.IN.TD.REPO.NO.DUP.RT
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INSERT BP I_F.ST.L.APAP.TD.REPO.CHG.PARAMS
    $INSERT BP I_F.ST.L.APAP.TD.REPO.CHG.PARA.AD

    AF = ST.L.A22.CARD.TYPE
    CALL DUP

    RETURN
