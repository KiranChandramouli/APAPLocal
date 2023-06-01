* @ValidationCode : Mjo0MzM3ODc3ODk6Q3AxMjUyOjE2ODU1MzAxMDAwNjQ6aGFpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 16:18:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.CUS.IDENT(Y.INP.DEAL)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - Include to Insert and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - CALL RTN ROUTINE MODIFIED
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

*CALL DR.REG.GET.CUST.TYPE(RS.CUS, OUT.ARR)
    APAP.LAPAP.drRegGetCustType(RS.CUS, OUT.ARR);*R22 MANUAL CODE CONVERSION

    Y.INP.DEAL = EREPLACE(OUT.ARR<2>, "-", "")

RETURN

END
