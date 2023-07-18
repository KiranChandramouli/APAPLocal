*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.VERIFY.PARAM

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT BP I_F.ST.LAPAP.CATEGORY.PARAM

    CUSI = R.NEW(AC.CUSTOMER)
    CATI = R.NEW(AC.CATEGORY)

    FN.ACC = "F.ACCOUNT"
    F.ACC = ""


    CALL LAPAP.VERIFY.CATEGORY.PARAM(CUSI,CATI,RES)


    IF RES NE 1 THEN
        CALL REBUILD.SCREEN
        MESSAGE = "TIPO DE CLIENTE NO CORRESPONDE CON LA CATEGORIA DE CUENTA"
        E = MESSAGE
        CALL REM
        *CALL ERR
        RETURN

    END

    RETURN

END
