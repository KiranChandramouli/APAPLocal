$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Subrutina: L.APAP.CIERRE.ACC.AHORRO.SELECT
*  Creación: 05/10/2020
*     Autor: Félix Trinidad
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION

*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   T24.BP,BP is Removed , INSERT FILE MODIFIED
*---------------------------------------------------------------------------------------	-
SUBROUTINE L.APAP.CIERRE.ACC.AHORRO.SELECT
    $INSERT  I_COMMON
    $INSERT  I_EQUATE ;*r22 MANUAL CODE CONVERSION
    $INSERT  I_F.ACCOUNT ;*r22 MANUAL CODE CONVERSION
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT  I_F.ST.CONTROL.CUENTA.AHORRO ;*r22 MANUAL CODE CONVERSION
    $INSERT I_L.APAP.CIERRE.ACC.AHORRO.COMO ;*R22 MANUAL CONVERSION INSERT FILE NAME CHANGE

    
    SEL.CMD = "SELECT " : FN.ACCOUNT : " WITH ONLINE.ACTUAL.BAL EQ '' AND DATE.LAST.CR.CUST EQ '' AND CATEGORY BETWEEN '6000' AND '6599'"
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS, SEL.ERR)

*Envia la data de una Rutina a Otra, Cargando el Arreglo de Datos a Memoria
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
