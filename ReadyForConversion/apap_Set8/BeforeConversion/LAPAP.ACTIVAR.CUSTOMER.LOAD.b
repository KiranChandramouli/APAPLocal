*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Subrutina: LAPAP.ACTIVAR.CUSTOMER.LOAD
*  Creación: 07/02/2022
*     Autor: Félix Trinidad
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.ACTIVAR.CUSTOMER.LOAD
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_TSA.COMMON
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT T24.BP I_F.CR.OTHER.PRODUCTS
    $INSERT LAPAP.BP I_LAPAP.ACTIVAR.CUSTOMER.COMMON

    GOSUB INITIAL
    GOSUB OPENER

    RETURN

INITIAL:
    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""

    FN.OTHER = "F.CR.OTHER.PRODUCTS"
    FV.OTHER = ""

    RETURN

OPENER:
    CALL OPF(FN.CUS,FV.CUS)
    CALL OPF(FN.OTHER,FV.OTHER)

    SEL.CMD = ""
    Y.CUSTOMER.ID = ""
    Y.STATUS = ""

    RETURN
END
