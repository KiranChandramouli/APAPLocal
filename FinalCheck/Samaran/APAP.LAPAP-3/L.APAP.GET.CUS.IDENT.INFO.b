$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.CUS.IDENT.INFO
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER

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
