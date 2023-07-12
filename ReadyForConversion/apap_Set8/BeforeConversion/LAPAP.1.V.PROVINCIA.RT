*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.1.V.PROVINCIA.RT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT BP I_F.ST.LAPAP.MOD.DIRECCIONES
    $INSERT BP I_F.ST.LAPAP.RD.PROVINCES


    IF R.NEW(ST.MDIR.PAIS) EQ 'DO' THEN
        FN.PROVINCE = "F.ST.LAPAP.RD.PROVINCES"
        F.PROVINCE = ""
        CALL OPF(FN.PROVINCE,F.PROVINCE)

        Y.VALUE = COMI
        Y.ID.PROVINCIA = EREPLACE(Y.VALUE," ",".")

        IF Y.VALUE EQ '' THEN
            ETEXT = "ESTE CAMPO ES MANDATORIO CUANDO EL PAIS ES REP. DOMINICANA (DO)."
            CALL STORE.END.ERROR
            RETURN
        END
        CALL F.READ(FN.PROVINCE,Y.ID.PROVINCIA,R.PROVINCES,F.PROVINCE,ERR.PROVINCES)

        IF ERR.PROVINCES NE '' THEN
            ETEXT = "INDIQUE UNO DE LOS POSIBLE VALORES DE LA LISTA PARA EL CAMPO PROVINCIA."
            CALL STORE.END.ERROR
            RETURN
        END


    END
    RETURN

END
