SUBROUTINE LAPAP.1.V.RES.TYPE.RT
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ST.LAPAP.MOD.DIRECCIONES

    Y.VALUE = COMI

    IF Y.VALUE EQ '' THEN
        ETEXT = 'ESTE CAMPO ES MANDATORIO'
        CALL STORE.END.ERROR
    END
END
