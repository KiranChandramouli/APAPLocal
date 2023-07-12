* Subrutina: LAPAP.ACTIVAR.CUSTOMER.SELECT
*  Creación: 07/02/2022
*     Autor: Félix Trinidad
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.ACTIVAR.CUSTOMER.SELECT
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
*--Leo los Clientes de la Tabla FBNK.CR.OTHER.PRODUCT
    SEL.CMD = "SELECT " : FN.OTHER
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SEL.ERR)

    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN

END
