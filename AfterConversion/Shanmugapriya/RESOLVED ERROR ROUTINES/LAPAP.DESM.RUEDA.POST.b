* @ValidationCode : MjotODAwMzU1OTg6Q3AxMjUyOjE2ODUwODMyMTI2NjY6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 May 2023 12:10:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.DESM.RUEDA.POST
    
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 18.05.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, T24.BP & TAM.BP removed
* 18.05.2023       Shanmugapriya M       R22            Manual Conversion   - Variable initialised
*
*------------------------------------------------------------------------------------------------------
    

    $INSERT I_COMMON                    ;** R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.DATES                          ;** R22 Auto conversion - END

    GOSUB MAIN.PROCESS

RETURN

MAIN.PROCESS:
*************

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

OPEN.FILES:
**********

    FN.LAPAP.DESM.RUEDA = "F.LAPAP.DESM.RUEDA";
    F.LAPAP.DESM.RUEDA = "";
    CALL OPF (FN.LAPAP.DESM.RUEDA,F.LAPAP.DESM.RUEDA)

    Y.GRUPO1 = "";
    Y.GRUPO2 = "";
    Y.GRUPO3 = "";
    Y.GRUPO4 = "";
    Y.GRUPO5 = "";
    Y.GRUPO5.REV = "";
    Y.GRUPO6 = "";
    Y.EXCLUIDOS = "";

***directorio de salidad
    FN.CHK.DIR1 = "DMFILES";
    F.CHK.DIR1 = "";
    CALL OPF(FN.CHK.DIR1,F.CHK.DIR1)

    FN.CHK.DIR1.REV = "DMFILES/RTC.REVERSO";
    F.CHK.DIR1.REV = "";
    CALL OPF(FN.CHK.DIR1.REV,F.CHK.DIR1.REV)

RETURN

PROCESS:
********

    SEL.CMD  = ''; NO.OF.RECS = ''; F.CHK.DIR = "" ; SEL.LIST= '';
    SEL.CMD = " SELECT " : FN.LAPAP.DESM.RUEDA;
*CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SE L.ERR)
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SEL.ERR)      ;* R22 Manual conversion

    LOOP
        REMOVE Y.ID.RECORD FROM SEL.LIST SETTING REGISTRO.POS
    WHILE Y.ID.RECORD  DO
        CALL F.READ(FN.LAPAP.DESM.RUEDA,Y.ID.RECORD,R.LAPAP.DESM.RUEDA,F.LAPAP.DESM.RUEDA,ERROR.MIGR)
        Y.ID = Y.ID.RECORD
        Y.ID = CHANGE(Y.ID,'*',@FM)
        BEGIN CASE
            CASE Y.ID<2> EQ 'GRUPO1'
                Y.GRUPO1<-1> = R.LAPAP.DESM.RUEDA
            CASE Y.ID<2> EQ 'GRUPO2'
                Y.GRUPO2<-1> = R.LAPAP.DESM.RUEDA
            CASE Y.ID<2> EQ 'GRUPO3'
                Y.GRUPO3<-1> = R.LAPAP.DESM.RUEDA
            CASE Y.ID<2> EQ 'GRUPO4'
                Y.GRUPO4<-1> = R.LAPAP.DESM.RUEDA
            CASE Y.ID<2> EQ 'GRUPO5'
                Y.GRUPO5<-1> = R.LAPAP.DESM.RUEDA
            CASE Y.ID<2> EQ 'GRUPO5.REV'
                Y.GRUPO5.REV<-1> = R.LAPAP.DESM.RUEDA
            CASE Y.ID<2> EQ 'GRUPO6'
                Y.GRUPO6<-1> = R.LAPAP.DESM.RUEDA
            CASE Y.ID<2> EQ 'EXCLUIDO'
                Y.EXCLUIDOS<-1> = R.LAPAP.DESM.RUEDA
            CASE 1
                Y.VALOR = "NO REGISTRO"
        END CASE
    REPEAT

    IF Y.EXCLUIDOS NE '' THEN
        Y.FILE.NAME = 'CARGA0.PRESTAMOS.EXCLUIDOS.txt';
        Y.ARREGLO = Y.EXCLUIDOS
        GOSUB CHECK.ARCHIVO.FILES
    END

    Y.FILE.NAME = 'CARGA1.AJUSTE.CUR.ACC.txt';
    Y.ARREGLO = Y.GRUPO1
    GOSUB CHECK.ARCHIVO.FILES

    Y.FILE.NAME = 'CARGA2.CAMBIO.TASA.txt';
    Y.ARREGLO = Y.GRUPO2
    GOSUB CHECK.ARCHIVO.FILES

    Y.FILE.NAME = 'CARGA3.AJUSTE.PRIMA.SEGUROS.txt';
    Y.ARREGLO =  Y.GRUPO3
    GOSUB CHECK.ARCHIVO.FILES

    Y.FILE.NAME = 'CARGA4.ACTUALIZAR.CUOTA.PROG.txt';
    Y.ARREGLO = Y.GRUPO4
    GOSUB CHECK.ARCHIVO.FILES

    Y.FILE.NAME = 'CARGA5.MANT.POLIZA.txt';
    Y.ARREGLO = Y.GRUPO5
    GOSUB CHECK.ARCHIVO.FILES

    Y.FILE.NAME = 'CARGA5.MANT.POLIZA.REVE.txt';
    Y.ARREGLO = Y.GRUPO5.REV
    GOSUB CHECK.ARCHIVO.FILES.REV

    Y.FILE.NAME = 'INFILE.MONTO.PRELACION.txt';
    Y.ARREGLO = Y.GRUPO6
    GOSUB CHECK.ARCHIVO.FILES

RETURN

CHECK.ARCHIVO.FILES:
*******************

    R.FIL = ''; READ.FIL.ERR = '';
    CALL F.READ(FN.CHK.DIR1,Y.FILE.NAME,R.FIL,F.CHK.DIR1,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR1,Y.FILE.NAME
    END

    WRITE Y.ARREGLO ON F.CHK.DIR1, Y.FILE.NAME ON ERROR
        CALL OCOMO("Error en la escritura del archivo en el directorio":F.CHK.DIR1)
    END

RETURN

CHECK.ARCHIVO.FILES.REV:
***********************

    R.FIL.REV = ''; READ.FIL.ERR.REV = '';
    CALL F.READ(FN.CHK.DIR1.REV,Y.FILE.NAME,R.FIL.REV,F.CHK.DIR1.REV,READ.FIL.ERR.REV)
    IF R.FIL.REV THEN
        DELETE F.CHK.DIR1.REV,Y.FILE.NAME
    END

    WRITE Y.ARREGLO ON F.CHK.DIR1.REV, Y.FILE.NAME ON ERROR
        CALL OCOMO("Error en la escritura del archivo en el directorio":F.CHK.DIR1.REV)
    END

RETURN

END
