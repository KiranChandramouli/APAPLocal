* @ValidationCode : MjotODI0OTkxNDU1OkNwMTI1MjoxNjgyMzM1OTQ1ODk5OklUU1M6LTE6LTE6MTE2NDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1164
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                BP REMOVED , VM TO @VM
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------------------
SUBROUTINE LAPAP.AJUSTE.CURRACCOUNT

*----------------------------------------------
* ET-5401
* Fecha: 31/08/2020
* Fecha ultima modificacion: 09/09/2020
* Detalle: Se crearan dos archivos por separados: 1 para el ajuste del  CURACCOUNT y otro para disparar la actividad
* que actualiza el calendario de pagos
*----------------------------------------------

    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.DATES ;* AUTO R22 CODE CONVERSION END

    GOSUB OPEN.FILES
    GOSUB MAIN.PROCESS
    GOSUB CHECK.ARCHIVO.FILES
    GOSUB CHECK.ARCHIVO.FILES.2

RETURN

OPEN.FILES:
**********

    FN.AA.BILL = 'F.AA.BILL.DETAILS'
    F.AA.BILL = ''
    CALL OPF(FN.AA.BILL,F.AA.BILL)

    FN.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.ARRANGEMENT = ''
    CALL OPF(FN.ARRANGEMENT,F.ARRANGEMENT)

    FN.ARR.PS = "F.AA.ARR.PAYMENT.SCHEDULE"
    F.ARR.PS = ""
    CALL OPF(FN.ARR.PS, F.ARR.PS)

    FN.CHK.DIR1 = "DMFILES"
    F.CHK.DIR1 = ""
    CALL OPF(FN.CHK.DIR1,F.CHK.DIR1)

    Y.FILE.NAME = "CARGA.AJUSTE.CURACCOUNT.txt";
    Y.FILE.NAME.EXIT = "APAP.AJUSTE.CURACCOUNT.txt";
    Y.FILE.NAME.EXIT.2 = "APAP.ACTUALIZAR.CALENDARIO.PAGO.txt";
    Y.ARREGLO.PROPIEDADES = "";
    Y.ARREGLO.PROPIEDADES.2 = "";

RETURN

MAIN.PROCESS:
************

    Y.CONTEO = 0;

    R.CHK.DIR.1 = '' ; CHK.DIR.ERROR = '';
    CALL F.READ(FN.CHK.DIR1,Y.FILE.NAME,R.CHK.DIR.1,F.CHK.DIR1,CHK.DIR.ERROR)
    IF NOT(R.CHK.DIR.1) THEN
        RETURN
    END

    LOOP
        REMOVE Y.AA.ID FROM R.CHK.DIR.1 SETTING PROCESO.POS
    WHILE Y.AA.ID DO

        Y.AA.ID.POS = CHANGE(Y.AA.ID,',',@FM);
        Y.ARRANGEMENT.ID       = Y.AA.ID.POS<1>
        Y.MONTO.CURACCOUNT.IN  = Y.AA.ID.POS<2>

        R.ARRANGEMENT = ''; ERR.ARRAGEMENT = ''; CLIENTE.ID = ''
        CALL AA.GET.ARRANGEMENT(Y.ARRANGEMENT.ID,R.ARRANGEMENT,ERR.ARRAGEMENT)

        Y.COMPANY          = R.ARRANGEMENT<AA.ARR.CO.CODE>
        Y.ARR.STATUS       = R.ARRANGEMENT<AA.ARR.ARR.STATUS>

        IF Y.ARR.STATUS EQ 'CLOSE' THEN
            RETURN
        END

        GOSUB STRING.AJUSTE.CURRACCOUNT
        GOSUB STRING.CALENDARIO.PAGO

        Y.CONTEO += 1;
        CRT Y.CONTEO:".":Y.ARRANGEMENT.ID:"|PROCESADO|";

    REPEAT

RETURN


STRING.AJUSTE.CURRACCOUNT:
************************
    Y.ARREGLO.PROPIEDADES<-1> = "||":Y.ARRANGEMENT.ID:"||LENDING-ADJUST.BALANCE-MANT.SALD.CUOTA||":Y.COMPANY:"||MANT.SALD.CUOTA||ADJ.BAL.AMT:1:1||":Y.MONTO.CURACCOUNT.IN:"||"
RETURN

STRING.CALENDARIO.PAGO:
***********************
    Y.ARREGLO.PROPIEDADES.2<-1> = "||":Y.ARRANGEMENT.ID:"||LENDING-CHANGE-REPAYMENT.SCHEDULE||":Y.COMPANY:"||REPAYMENT.SCHEDULE||"
RETURN


CHECK.ARCHIVO.FILES:
********************

    R.CHK.DIR.1 = '' ; CHK.DIR.ERROR = '';
    CALL F.READ(FN.CHK.DIR1,Y.FILE.NAME.EXIT,R.CHK.DIR.1,F.CHK.DIR1,CHK.DIR.ERROR)

    IF R.CHK.DIR.1 THEN
        DELETE F.CHK.DIR1,Y.FILE.NAME.EXIT
    END

    WRITE Y.ARREGLO.PROPIEDADES ON F.CHK.DIR1, Y.FILE.NAME.EXIT ON ERROR
        CALL OCOMO("Error en la escritura del archivo en el directorio":F.CHK.DIR1)
    END

RETURN

CHECK.ARCHIVO.FILES.2:
********************

    R.CHK.DIR.1 = '' ; CHK.DIR.ERROR = '';
    CALL F.READ(FN.CHK.DIR1,Y.FILE.NAME.EXIT.2,R.CHK.DIR.1,F.CHK.DIR1,CHK.DIR.ERROR)

    IF R.CHK.DIR.1 THEN
        DELETE F.CHK.DIR1,Y.FILE.NAME.EXIT.2
    END

    WRITE Y.ARREGLO.PROPIEDADES.2 ON F.CHK.DIR1, Y.FILE.NAME.EXIT.2 ON ERROR
        CALL OCOMO("Error en la escritura del archivo en el directorio":F.CHK.DIR1)
    END

RETURN

END
