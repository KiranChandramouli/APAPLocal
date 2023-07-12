*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.VALI.PAY.COVID.SELECT
*-----------------------------------------------------------------------------
* Bank name: APAP
* Decription: Rutina SELECT Validar los pagos realizdos a los cotratos COVID19 con el monto de prelacion
* Logica: Lee todos los pagos realizados en el dia de las tablas (FBNK.AA.ARRANGEMENT.ACTIVITY,FBNK.FUNDS.TRASNFER)
* y va contra la tabla F.ST.L.APAP.COVI.PRELACIONIII
* y verifica si contrato se encuentra en esa tabla y tiene monto pendiente y le recta el valor que tenga
* monto pagado FT
* Developed By: APAP
* Date:  10122020
*-----------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT T24.BP I_F.FUNDS.TRANSFER
    $INSERT T24.BP I_F.AA.PAYMENT.SCHEDULE
    $INSERT T24.BP I_F.AA.ARRANGEMENT
    $INSERT  BP I_F.ST.L.APAP.PRELACION.COVI19.DET
    $INSERT BP I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT LAPAP.BP I_L.APAP.VALI.PAY.COVID.COMMON

    GOSUB PROCESS
    RETURN

PROCESS:
********
    SEL.CMD = '' ; SEL.LIST = '' ; NO.OF.REC = '' ; RET.CODE = ''
    SEL.CMD = "SELECT ":FN.AAA:" WITH EFFECTIVE.DATE EQ ":TODAY:" AND ACTIVITY EQ ":Y.ACTIVIDADES
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
    RETURN
END
