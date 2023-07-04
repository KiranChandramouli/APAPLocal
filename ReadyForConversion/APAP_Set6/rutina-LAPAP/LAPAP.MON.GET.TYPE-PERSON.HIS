*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.MON.GET.TYPE-PERSON.HIS

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.CUSTOMER

*---------------------
* Defining prpierties
*---------------------

    FN.ACC = "F.ACCOUNT$HIS"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)


    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    CALL OPF(FN.CUS,F.CUS)

    ID = COMI

*---------------
* Opening Tables
*---------------

    ACC = ID
    CALL LAPAP.VERIFY.ACC(ACC,RES)
    Y.ACC.ID = RES

    IF ACC NE Y.ACC.ID THEN

        CALL F.READ.HISTORY(FN.ACC,Y.ACC.ID,R.HIS,F.ACC,ERRH)
        CUSTOMER.ID = R.HIS<AC.CUSTOMER>

        CALL F.READ(FN.CUS,CUSTOMER.ID,R.CUS,F.CUS,ERRCUS)
        CALL GET.LOC.REF("CUSTOMER","L.CU.TIPO.CL",POS)
        CUSTOMER.TYPE = R.CUS<EB.CUS.LOCAL.REF,POS>

        IF CUSTOMER.TYPE EQ "PERSONA FISICA" THEN
            COMI = "N"
        END ELSE
            COMI = "J"
        END

        RETURN

    END ELSE

        CALL F.READ.HISTORY(FN.ACC,ID,R.HIS,F.ACC,ERRH)
        CUSTOMER.ID = R.HIS<AC.CUSTOMER>

        CALL F.READ(FN.CUS,CUSTOMER.ID,R.CUS,F.CUS,ERRCUS)
        CALL GET.LOC.REF("CUSTOMER","L.CU.TIPO.CL",POS)
        CUSTOMER.TYPE = R.CUS<EB.CUS.LOCAL.REF,POS>

        IF CUSTOMER.TYPE EQ "PERSONA FISICA" THEN
            COMI = "N"
        END ELSE
            COMI = "J"
        END

        RETURN

    END

END
