*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.V.ID.VOTANTE.RT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT BP I_F.ST.L.APAP.ASAMBLEA.PARTIC
    $INSERT BP I_F.ST.L.APAP.ASAMBLEA.VOTANTE

    IF V$FUNCTION EQ 'I' THEN
        FN.VOT = "FBNK.ST.L.APAP.ASAMBLEA.VOTANTE"
        FV.VOT = ""
        CALL OPF(FN.VOT,FV.VOT)
        Y.RECORD.ID = COMI
        CALL F.READ(FN.VOT, Y.RECORD.ID, R.VOT, FV.VOT, PA.ERR)
        IF R.VOT NE '' THEN
            E = "OPERACION NO VALIDA, CEDULA YA ESTA REGISTRADA."
            CALL ERR
            MESSAGE = 'REPEAT'
            V$ERROR = 1
            RETURN
        END

    END

END
