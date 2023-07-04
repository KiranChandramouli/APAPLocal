*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.MON.GET.TYPE-PERSON

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.CUSTOMER

*---------------------
* Defining prpierties
*---------------------

    FN.ACC = "F.ACCOUNT"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)


    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    CALL OPF(FN.CUS,F.CUS)

    ID = COMI

    CALL F.READ(FN.ACC,ID,R.ACC,F.ACC,ERRC)
    CUSTOMER.ID = R.ACC<AC.CUSTOMER>

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
