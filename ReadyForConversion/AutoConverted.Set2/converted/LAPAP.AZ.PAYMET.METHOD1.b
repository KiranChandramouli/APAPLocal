SUBROUTINE LAPAP.AZ.PAYMET.METHOD1

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT


    ID = COMI
    CALL LAPAP.MON.DEFINE.PAYMENT(ID,RS,RT)

    IF RS EQ "CASHDEPOSIT" THEN
        COMI = RT
    END ELSE
        COMI = ""
    END


*DEBUG

END
