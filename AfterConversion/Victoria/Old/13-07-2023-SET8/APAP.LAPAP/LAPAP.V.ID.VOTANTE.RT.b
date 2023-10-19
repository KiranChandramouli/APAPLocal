$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED
*13-07-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.V.ID.VOTANTE.RT
    $INSERT I_COMMON ;*R22 AUTO CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.ST.L.APAP.ASAMBLEA.PARTIC
    $INSERT I_F.ST.L.APAP.ASAMBLEA.VOTANTE ;*R22 AUTO CONVERSION END

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
