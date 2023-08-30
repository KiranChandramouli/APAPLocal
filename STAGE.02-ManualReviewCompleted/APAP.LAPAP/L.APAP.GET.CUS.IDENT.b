$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.CUS.IDENT(Y.INP.DEAL)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - Include to Insert and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.COMPANY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.L.NCF.STOCK

    OUT.ARR = ''

*--PARA ABRIR EL ACHIVO REDO.L.NCF.STOCK
    FN.CUS = "FBNK.CUSTOMER"
    FV.CUS = ""
    RS.CUS = ""
    CUS.ERR = ""

    CALL OPF(FN.CUS, FV.CUS)
    CALL F.READ(FN.CUS, Y.INP.DEAL, RS.CUS, FV.CUS, CUS.ERR)

    CALL DR.REG.GET.CUST.TYPE(RS.CUS, OUT.ARR)

    Y.INP.DEAL = EREPLACE(OUT.ARR<2>, "-", "")

RETURN

END
