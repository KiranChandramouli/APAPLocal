SUBROUTINE L.APAP.CUS.MAYOR.MENOR.LOAD

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_L.APAP.CUS.MAYOR.MENOR.COMMON


    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    R.CUSTOMER = ""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)


END
