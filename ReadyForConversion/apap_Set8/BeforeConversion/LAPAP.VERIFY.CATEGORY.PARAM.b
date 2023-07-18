*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.VERIFY.CATEGORY.PARAM(CUSI,CATI,RES)

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT BP I_F.ST.LAPAP.CATEGORY.PARAM

    FN.ACC = "F.ACCOUNT"
    FN.CUS = "F.CUSTOMER"
    FN.PAR = "F.ST.LAPAP.CATEGORY.PARAM"

    F.CUS = ""
    F.PAR = ""
    F.ACC = ""


    COMIP = CUSI
    CATEG = CATI

    CALL OPF(FN.ACC,F.ACC)
    CALL OPF(FN.CUS,F.CUS)
    CALL OPF(FN.PAR,F.PAR)
    CALL F.READ(FN.CUS,COMIP,R.CUS,F.CUS,ERR)
    CALL GET.LOC.REF("CUSTOMER","L.CU.TIPO.CL",POS)
    CLIENTE.TYPE = R.CUS<EB.CUS.LOCAL.REF,POS>

    CLIENTE.TYPE = EREPLACE(CLIENTE.TYPE," ", ".")

    CALL F.READ(FN.PAR,CLIENTE.TYPE,R.PAR,F.PAR,ERR2)
    PRODUCT.TYPE = R.PAR<ST.LAP22.PRODUCT.TYPE>

    M = DCOUNT(PRODUCT.TYPE,@VM)

    FOR A = 1 TO M STEP 1

        PT = PRODUCT.TYPE<1,A>

        IF PT EQ CATEG THEN

            RES = 1

        END

    NEXT A

    RETURN


END
