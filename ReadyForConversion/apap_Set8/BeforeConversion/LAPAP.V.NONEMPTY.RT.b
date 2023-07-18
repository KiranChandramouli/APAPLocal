*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.V.NONEMPTY.RT

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_GTS.COMMON
    $INSERT BP I_F.REDO.ID.CARD.CHECK
    $INSERT BP I_F.ST.LAPAP.OCC.CUSTOMER
    $INSERT T24.BP I_System


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
