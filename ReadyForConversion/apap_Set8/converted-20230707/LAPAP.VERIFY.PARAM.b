SUBROUTINE LAPAP.VERIFY.PARAM

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ST.LAPAP.CATEGORY.PARAM

    CUSI = R.NEW(AC.CUSTOMER)
    CATI = R.NEW(AC.CATEGORY)

    FN.ACC = "F.ACCOUNT"
    F.ACC = ""


    CALL LAPAP.VERIFY.CATEGORY.PARAM(CUSI,CATI,RES)


    IF RES NE 1 THEN
        CALL REBUILD.SCREEN
        MESSAGE = "TIPO DE CLIENTE NO CORRESPONDE CON LA CATEGORIA DE CUENTA"
        E = MESSAGE
        CALL DISPLAY.MESSAGE(TEXT, '')
*CALL ERR
        RETURN

    END

RETURN

END
