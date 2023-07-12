*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
*-------------------------------------------------------------------------
* Rutina multi hilo para actualizar el campo ACTUAL.AMT cuota programada
* para los contratos que tiene monto igual a cero 0 en la tabla de
* de prelación con el monto COVID19
* Fecha: 17/12/2020
* Autor: APAP
*--------------------------------------------------------------------------
    SUBROUTINE L.APAP.CAMPO.CUOTA.PROG.SELECT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.AA.PAYMENT.SCHEDULE
    $INSERT BP I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT BP I_F.L.APAP.LOG.COVID19
    $INSERT LAPAP.BP I_L.APAP.CAMPO.CUOTA.PROG.COMMON
    GOSUB PROCESS

    RETURN

PROCESS:
********
    CALL EB.CLEAR.FILE(FN.L.APAP.LOG.COVID19,FV.L.APAP.LOG.COVID19)
    SEL.CMD = '' ; SEL.LIST = '' ; NO.OF.REC = '' ; RET.CODE = ''
    SEL.CMD = "SELECT ":FN.ST.L.APAP.COVID.PRELACIONIII:" WITH MONTO.COVI19 LE '0'"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
    RETURN

END
