*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Subrutina: L.APAP.CIERRE.ACC.AHORRO.SELECT
*  Creación: 05/10/2020
*     Autor: Félix Trinidad
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.CIERRE.ACC.AHORRO.SELECT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.ACCOUNT.CLOSURE
    $INSERT BP I_F.ST.CONTROL.CUENTA.AHORRO
    $INSERT LAPAP.BP L.APAP.CIERRE.ACC.AHORRO.COMO

    
    SEL.CMD = "SELECT " : FN.ACCOUNT : " WITH ONLINE.ACTUAL.BAL EQ '' AND DATE.LAST.CR.CUST EQ '' AND CATEGORY BETWEEN '6000' AND '6599'"
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS, SEL.ERR)

    *Envia la data de una Rutina a Otra, Cargando el Arreglo de Datos a Memoria
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
