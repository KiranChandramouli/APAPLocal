SUBROUTINE L.APAP.V.CUS.ME.INDUSTRY.RT
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DATES


    Y.L.APAP.INDUSTRY = COMI
    Y.CUST.DATE.OF.BIRTH = R.NEW(EB.CUS.DATE.OF.BIRTH)
    Y.TODAY = R.DATES(EB.DAT.TODAY)
    C.DAYS = "C"

    IF Y.CUST.DATE.OF.BIRTH NE '' THEN
        CALL CDD("",Y.CUST.DATE.OF.BIRTH,Y.TODAY,C.DAYS)

        IF (C.DAYS LT 16 AND Y.L.APAP.INDUSTRY NE '930992') THEN
            MESSAGE = "EDAD CLIENTE NO PERMITE ACTIVIDAD ECONOMICA DIFERENTE A 930992"
            E = MESSAGE
            ETEXT = E
            CALL ERR
        END

    END

RETURN

END
