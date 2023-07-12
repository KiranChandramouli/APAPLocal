*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.V.CUS.MAN.MAN.RT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT BP I_F.ST.LAPAP.LY.POINT.MAN
    $INSERT T24.BP I_F.CUSTOMER

    FN.CUS = 'F.CUSTOMER'
    F.CUS = ''
    CALL OPF(FN.CUS,F.CUS)

    Y.CUS.ID = R.NEW(ST.LAPLY.CODIGO.CLIENTE)
    IF Y.CUS.ID NE '' THEN
        CALL F.READ(FN.CUS,Y.CUS.ID,R.CUS,F.CUS,ERR.MDDE11)

        IF R.CUS EQ '' THEN
            TEXT = 'CODIGO CLIENTE INVALIDO.'
            CALL REM
            E = TEXT
            CALL STORE.END.ERROR
        END
    END

END
