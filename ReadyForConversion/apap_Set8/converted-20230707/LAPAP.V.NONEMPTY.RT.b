SUBROUTINE LAPAP.V.NONEMPTY.RT

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_F.ST.LAPAP.OCC.CUSTOMER
    $INSERT I_System


    IF R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) NE 'RNC' THEN

        IF R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) EQ 'NO CLIENTE APAP' THEN
            IF COMI EQ '' THEN
                TEXT = "Ingreso es requerido para no cliente APAP"
                ETEXT = TEXT
                E = TEXT
                CALL STORE.END.ERROR
            END
        END
    END

END
