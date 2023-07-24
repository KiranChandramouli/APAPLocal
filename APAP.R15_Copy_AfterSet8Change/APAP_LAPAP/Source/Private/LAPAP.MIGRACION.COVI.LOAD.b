* @ValidationCode : MjotMzgwMzI3MTIwOlVURi04OjE2ODk3NDk2NTQxMzQ6SVRTUzotMTotMTo0OTE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:14
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 491
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.MIGRACION.COVI.LOAD
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 13-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 13-07-2023    Narmadha V             R22 Manual conversion   No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;* R22 Auto Conversion - STRAT
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_LAPAP.MIGRACION.COVI.COMO ;* R22 Auto Conversion - END

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
