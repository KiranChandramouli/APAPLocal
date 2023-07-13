* @ValidationCode : MjoxMzgwNjU2Mjg2OkNwMTI1MjoxNjg5MjQyNzMyMjE5OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 15:35:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Bank name: APAP
* Decription: Rutina para generar archivo INFILES y procesar en la etapa de cobro automatico ruedala tu cuota
* Developed By: APAP
* Date:  09/02/2021
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       FM TO @FM, ++ to +=, BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       F.CHK.DIR to F.CHK.DIR1
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.DEB.DIRECT.RTC.AUT.POST

    $INSERT I_COMMON                                ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_L.APAP.DEB.DIRECT.RTC.AUT.COMMON     ;*R22 Auto conversion - End

    GOSUB OPEN.FILES
    GOSUB MAIN.PROCESS

RETURN

MAIN.PROCESS:
*************
    Y.HEADER = "Numero de AA|Estado|Comentario"; Y.CNT.SUCCES = 0; Y.CNT.FAILED = 0;
    SEL.CMD = ''; NO.OF.REC = ''; RET.CODE = '' ; Y.ARRAY.SUCCES = ''; Y.ARRAY.FALLIDOS = '';
    SEL.CMD = "SELECT ":FN.LAPAP.CONCATE.DEB.DIR
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE AAA.ID FROM SEL.LIST SETTING AAA.POS
    WHILE AAA.ID:AAA.POS DO
        CALL F.READ (FN.LAPAP.CONCATE.DEB.DIR,AAA.ID,R.LAPAP.CONCATE.DEB.DIR,F.LAPAP.CONCATE.DEB.DIR,ERROR.CONCATE)
        Y.DETALLE = R.LAPAP.CONCATE.DEB.DIR
        Y.DETALLE = CHANGE(Y.DETALLE,"*",@FM)
        Y.ESTADO = Y.DETALLE<1>
        Y.DECRIPCION = Y.DETALLE<2>
        IF Y.ESTADO EQ 'SUCCESS' THEN
            Y.CNT.SUCCES += 1
            IF Y.CNT.SUCCES EQ 1 THEN
                Y.ARRAY.SUCCES<-1> = Y.HEADER;
            END
            Y.ARRAY.SUCCES<-1> = AAA.ID:"|":Y.ESTADO:"|":Y.DECRIPCION
        END ELSE
            Y.CNT.FAILED += 1;
            IF Y.CNT.FAILED EQ 1 THEN
                Y.ARRAY.FALLIDOS<-1> = Y.HEADER;
            END
            Y.ARRAY.FALLIDOS<-1> = AAA.ID:"|":Y.ESTADO:"|":Y.DECRIPCION
        END

    REPEAT
    IF Y.ARRAY.SUCCES NE '' THEN
        Y.FILE.NAME = Y.ARCHIVO.REPORTE.SUCCES;
        Y.ARREGLO = Y.ARRAY.SUCCES
        GOSUB SET.ESCRITURA.ARCHIVOS
    END
    IF Y.ARRAY.FALLIDOS NE '' THEN
        Y.FILE.NAME = Y.ARCHIVO.REPORTE.FAILED;
        Y.ARREGLO = Y.ARRAY.FALLIDOS
        GOSUB SET.ESCRITURA.ARCHIVOS
    END


RETURN

OPEN.FILES:
    Y.ARCHIVO.REPORTE.SUCCES = "Reporte procesados":TODAY:".csv";
    Y.ARCHIVO.REPORTE.FAILED = "Reporte fallidos":TODAY:".csv";
    FN.LAPAP.CONCATE.DEB.DIR = "F.LAPAP.CONCATE.DEB.DIR";
    F.LAPAP.CONCATE.DEB.DIR = "";
    CALL OPF (FN.LAPAP.CONCATE.DEB.DIR,F.LAPAP.CONCATE.DEB.DIR)
    FN.CHK.DIR1 = "DMFILES";
    F.CHK.DIR1 = "";
    CALL OPF(FN.CHK.DIR1,F.CHK.DIR1)
RETURN

SET.ESCRITURA.ARCHIVOS:
    CALL F.READ(FN.CHK.DIR1,Y.FILE.NAME,R.DIR.INPUT,F.CHK.DIR1, ERROR.DIR.INPUT)
    IF (R.DIR.INPUT) THEN
        CALL F.DELETE(FN.CHK.DIR1,Y.FILE.NAME)
    END
    WRITE Y.ARREGLO ON F.CHK.DIR1, Y.FILE.NAME ON ERROR
        CALL OCOMO("NO SE PUEDE HACER EXCRITURA EN EL DIRECTORIO ":F.CHK.DIR1: "ARCHIVO: ":Y.FILE.NAME)       ;*Manual R22 conversion F.CHK.DIR to F.CHK.DIR1
    END

RETURN

END
