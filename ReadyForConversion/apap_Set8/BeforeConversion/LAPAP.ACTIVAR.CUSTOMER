*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Subrutina: LAPAP.ACTIVAR.CUSTOMER(CR.OTHER.ID)
*  Creación: 07/02/2022
*     Autor: Félix Trinidad
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.ACTIVAR.CUSTOMER(CR.OTHER.ID)
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_TSA.COMMON
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT T24.BP I_F.CR.OTHER.PRODUCTS
    $INSERT LAPAP.BP I_LAPAP.ACTIVAR.CUSTOMER.COMMON

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

    CALL F.READ(FN.CUS,Y.CUSTOMER.ID,R.CUS, FV.CUS, CUS.ERR)

*--Verifico si el Status del Cliente es 2 = inactivo o 4 = Cerrado
    Y.STATUS = R.CUS<EB.CUS.CUSTOMER.STATUS>

    IF Y.STATUS EQ 2 OR Y.STATUS EQ 4 THEN
        R.CUS<EB.CUS.CUSTOMER.STATUS> = 1
        CALL F.WRITE(FN.CUS,Y.CUSTOMER.ID,R.CUS)
    END

    RETURN
END
