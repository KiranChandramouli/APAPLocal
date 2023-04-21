*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.MIGRACION.COVI.LOAD
    
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO                REFERENCE                 DESCRIPTION

* 21-APR-2023     Conversion tool    R22 Auto conversion       No changes

*-----------------------------------------------------------------------------

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_TSA.COMMON
    $INSERT T24.BP I_F.AA.BILL.DETAILS
    $INSERT T24.BP I_F.AA.PAYMENT.SCHEDULE
    $INSERT T24.BP I_F.AA.ARRANGEMENT
    $INSERT T24.BP I_F.AA.ACCOUNT.DETAILS
    $INSERT LAPAP.BP I_LAPAP.MIGRACION.COVI.COMO

    GOSUB OPEN.FILES

    RETURN


OPEN.FILES:
**********

    FN.AA.BILL = 'F.AA.BILL.DETAILS'
    F.AA.BILL = ''
    CALL OPF(FN.AA.BILL,F.AA.BILL)
    FN.L.APAP.CONVI.MIG = "F.L.APAP.CONVI.MIG"
    FV.L.APAP.CONVI.MIG = ""
    CALL OPF (FN.L.APAP.CONVI.MIG,FV.L.APAP.CONVI.MIG)

    FN.CHK.DIR = "&SAVEDLISTS&" ; F.CHK.DIR = ""
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    FN.CHK.DIR1 = "DMFILES"
    F.CHK.DIR1 = ""
    CALL OPF(FN.CHK.DIR1,F.CHK.DIR1)
    FN.AA.BILL.DETAILS.HIST = "F.AA.BILL.DETAILS.HIST"
    FV.AA.BILL.DETAILS.HIST = ""
    CALL OPF (FN.AA.BILL.DETAILS.HIST,FV.AA.BILL.DETAILS.HIST)

*ARCHIVO DE CARGA QUE CONTIENE EL LISTADO DE LOS PRESTAMOS
    Y.ARCHIVO.NOMBRE.ARCHIVO = "BD_APLAZAMIENTO_CUOTAS.txt"

*FILTRO DEL RANGO DE FECHA DE LAS FACTURAS
    Y.FECHA.FACTURA = "20200301"
    Y.FECHA.FIN.FACTURA = "20200431"

    Y.YYYY.MM = "202007"
    Y.YYYY.MM.NOPAGO = "202006"

    Y.YYYY.MM1 = "202006"
    Y.YYYY.MM1.NOPAGO = "202005"

*Condiciones para los prestamos que tengan una sola cuota pendiente de pago en Abril [CONSTANTE, SOLO.INTERES]
    Y.YYYY.CUOTA.NOPAGO.SOLO.INTERES.ABRIL = "202006"
    Y.MM.MES.NOPAGO.ABRIL = '04'
    Y.YYYY.CUOTA.NOPAGO.ABRIL = "202007"

    RETURN

END
