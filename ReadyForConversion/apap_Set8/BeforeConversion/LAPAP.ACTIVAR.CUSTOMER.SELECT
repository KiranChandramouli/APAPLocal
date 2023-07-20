*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Subrutina: LAPAP.ACTIVAR.CUSTOMER.SELECT
*  Creación: 07/02/2022
*     Autor: Félix Trinidad
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.ACTIVAR.CUSTOMER.SELECT
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
*--Leo los Clientes de la Tabla FBNK.CR.OTHER.PRODUCT
    SEL.CMD = "SELECT " : FN.OTHER
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SEL.ERR)

    CALL BATCH.BUILD.LIST('',SEL.LIST)
    RETURN

END
