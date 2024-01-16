$PACKAGE APAP.LAPAP
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
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION

*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION  T24.BP,BP is Removed , INSERT FILE  MODIFIED
*----------------------------------------------------------------------------------------
SUBROUTINE L.APAP.CAMPO.CUOTA.PROG.LOAD
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.AA.PAYMENT.SCHEDULE ;*R22 MANUAL CODE CONVERSION
    $INSERT  I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT I_F.L.APAP.LOG.COVID19
    $INSERT  I_L.APAP.CAMPO.CUOTA.PROG.COMMON ;*R22 MANUAL CODE CONVERSION

    GOSUB TABLAS

RETURN

TABLAS:
    FN.ST.L.APAP.COVID.PRELACIONIII = 'F.ST.L.APAP.COVI.PRELACIONIII'
    FV.ST.L.APAP.COVID.PRELACIONIII = ''
    CALL OPF (FN.ST.L.APAP.COVID.PRELACIONIII,FV.ST.L.APAP.COVID.PRELACIONIII)

    FN.L.APAP.LOG.COVID19 = 'F.ST.L.APAP.LOG.COVID19'
    FV.L.APAP.LOG.COVID19 = ''
    CALL OPF (FN.L.APAP.LOG.COVID19,FV.L.APAP.LOG.COVID19)

RETURN

END

