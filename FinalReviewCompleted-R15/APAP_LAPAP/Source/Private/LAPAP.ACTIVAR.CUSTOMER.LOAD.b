$PACKAGE APAP.LAPAP
* Subrutina: LAPAP.ACTIVAR.CUSTOMER.LOAD
*  Creación: 07/02/2022
*     Autor: Félix Trinidad
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.ACTIVAR.CUSTOMER.LOAD
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CR.OTHER.PRODUCTS
    $INSERT I_LAPAP.ACTIVAR.CUSTOMER.COMMON

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
