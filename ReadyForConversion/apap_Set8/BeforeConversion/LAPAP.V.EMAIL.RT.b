*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.V.EMAIL.RT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT BP I_F.ST.LAPAP.MOD.DIRECCIONES

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
