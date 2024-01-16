$PACKAGE APAP.LAPAP
* Subrutina: LAPAP.ACTIVAR.CUSTOMER(CR.OTHER.ID)
*  Creación: 07/02/2022
*     Autor: Félix Trinidad
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.ACTIVAR.CUSTOMER(CR.OTHER.ID)
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

    GOSUB PROCESS.1
RETURN

PROCESS.1:

*--Busco el Registro de Other para Obtener El Id del Cliente.
    R.OTHER = ""
    OTHER.ERR = ""

    CALL F.READ(FN.OTHER, CR.OTHER.ID, R.OTHER, FV.OTHER, OTHER.ERR)

*--Busco el cliente en Customer
    R.CUS = ""
    CUS.ERR = ""
    Y.CUSTOMER.ID = R.OTHER<CR.OP.CUSTOMER>
    Y.STATUS = ''

*    CALL F.READ(FN.CUS,Y.CUSTOMER.ID,R.CUS, FV.CUS, CUS.ERR)
    CALL F.READU(FN.CUS,Y.CUSTOMER.ID,R.CUS, FV.CUS, CUS.ERR,'');* R22 UTILITY AUTO CONVERSION

*--Verifico si el Status del Cliente es 2 = inactivo o 4 = Cerrado
    Y.STATUS = R.CUS<EB.CUS.CUSTOMER.STATUS>

    IF Y.STATUS EQ 2 OR Y.STATUS EQ 4 THEN
        R.CUS<EB.CUS.CUSTOMER.STATUS> = 1
        CALL F.WRITE(FN.CUS,Y.CUSTOMER.ID,R.CUS)
    END

RETURN
END
