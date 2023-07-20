*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.ASA.L.V.RT(PARTICIPANTE)
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT BP I_F.ST.L.APAP.ASAMBLEA.PARTIC
    $INSERT LAPAP.BP I_LAPAP.ASA.L.V.COMMON

    GOSUB EJECUTAR.LIMPIEZA.1


EJECUTAR.LIMPIEZA.1:

    Y.TABLA = FN.PA
    Y.PUNTERO = F.PA

    CALL OCOMO("TABLA: " : Y.TABLA)
    CALL OCOMO("PUNTERO: " : Y.PUNTERO)
    CALL F.READ(FN.PA,PARTICIPANTE,R.PA, F.PA, PA.ERR)
    IF R.PA NE '' THEN
        R.PA<ST.L.APA.CUENTA.PARTICIPO> = ''
        R.PA<ST.L.APA.CLIENTE.PARTICIPO> = ''

        CALL F.WRITE(FN.PA, PARTICIPANTE, R.PA)
        CALL JOURNAL.UPDATE(PARTICIPANTE)

    END

    RETURN
END
