SUBROUTINE LAPAP.V.EMAIL.RT
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ST.LAPAP.MOD.DIRECCIONES

    Y.EMAIL = COMI
*DEBUG
    IF Y.EMAIL EQ '' THEN
*TEXT = "EL CAMPO E-MAIL ESTA BLANCO"
*CALL REM
        RETURN
    END
    Y.REGEX = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$"
    Y.EVALUADO =  REGEXP(Y.EMAIL, Y.REGEX)
*DEBUG
    IF Y.EVALUADO EQ 1 THEN
        RETURN
    END ELSE
        ETEXT = "EL E-MAIL INGRESADO NO ES VALIDO."
        CALL STORE.END.ERROR
        RETURN
    END

END
