SUBROUTINE LAPAP.VAL.IDENT.CEDULA


    $INSERT I_COMMON

    $INSERT I_EQUATE

    $INSERT I_F.DEPT.ACCT.OFFICER

    VAL.IDENTIFICACION   =  COMI

    CALL REDO.S.CALC.CHECK.DIGIT(VAL.IDENTIFICACION)

    IF VAL.IDENTIFICACION EQ "PASS" THEN

        TEXT = "LA CEDULA ES VALIDA"
        CALL DISPLAY.MESSAGE(TEXT, '')

    END ELSE

        TEXT = "LA CEDULA NO ES VALIDA, VERIFIQUE SI ES UN PASAPORTE"
        CALL DISPLAY.MESSAGE(TEXT, '')

    END
