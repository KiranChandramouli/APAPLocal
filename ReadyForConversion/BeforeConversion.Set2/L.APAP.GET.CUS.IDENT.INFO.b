    SUBROUTINE L.APAP.GET.CUS.IDENT.INFO

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_ENQUIRY.COMMON
    $INSERT T24.BP I_F.CUSTOMER

    Y.CUSTOMER = O.DATA
    CUS.IDENT = ""
    IDENT.TYPE = ""
    CUS.ID = ""
    NAME = ""
    LASTN = ""
    DEFV = ""

**---------------------------------------
**ABRIR LA TABLA CUSTOMER
**---------------------------------------
    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""
    R.CUS = ""
    CUS.ERR = ""
    CALL OPF(FN.CUS,FV.CUS)

    CALL F.READ(FN.CUS, Y.CUSTOMER, R.CUS, FV.CUS, CUS.ERR)
    CALL LAPAP.CUSTOMER.IDENT(Y.CUSTOMER, CUS.IDENT, IDENT.TYPE, NAME, LASTN, DEFV)

    O.DATA = CUS.IDENT : "*" : IDENT.TYPE

    RETURN

END
