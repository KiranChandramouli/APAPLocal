* @ValidationCode : MjoxMzQ5OTI2NDU6Q3AxMjUyOjE2OTE1NjY4NTkwMjE6dmljdG86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Aug 2023 13:10:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Developed By            : APAP
*
* Developed On            : 23-03-2023
*
* Development Reference   : MDR-2479
*
* Development Description : Recibe los TT de autorizaciones de pago via cobros y los procesa de forma masiva haciendo el pago
*                          que corresponde para el producto castigado , legal ect.
* Attached To             : BATCH>BNK/LAPAP.PROC.COBROS.CJ
*
* Attached As             : Multithreaded Routine
*---------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*09-08-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED,$INCLUDE TO $INSERT
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.PROC.COBROS.CJ.POST
    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.OFS.SOURCE
    $INSERT I_F.REDO.PART.TT.PROCESS
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.H.REPORTS.PARAM ;*R22 MANUAL CONVERSION END
    
    GOSUB CARGAR.TABLAS
    GOSUB LECTURA.PARAMETROS
    GOSUB PROCESS
RETURN

CARGAR.TABLAS:
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM';
    FV.REDO.H.REPORTS.PARAM = '';
    CALL OPF (FN.REDO.H.REPORTS.PARAM ,FV.REDO.H.REPORTS.PARAM)

    FN.LAPAP.COBRO.AUT.WRITE = 'F.LAPAP.COBRO.AUT.WRITE';
    FV.LAPAP.COBRO.AUT.WRITE = '';
    CALL OPF (FN.LAPAP.COBRO.AUT.WRITE,FV.LAPAP.COBRO.AUT.WRITE)

    FN.DIR = 'DMFILES';
    FV.DIR = '';
    CALL OPF (FN.DIR,FV.DIR)

RETURN

LECTURA.PARAMETROS:
    Y.APAP.REP.PARAM.ID = "PAGO.CASTIGADO"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.APAP.REP.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.OUTPUT.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.FILE.NAME  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FILE.DIR   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
    END


    LOCATE "PARAMETROS.ARCHIVO" IN Y.FIELD.NME.ARR<1,1> SETTING NOMBRE.POS THEN
        Y.PARAMETROS.ARCHIVO.VAL = Y.FIELD.VAL.ARR<1,NOMBRE.POS>
        Y.PARAMETROS.ARCHIVO.TEXT = Y.DISP.TEXT.ARR<1,NOMBRE.POS>

        Y.PARAMETROS.ARCHIVO.VAL = CHANGE(Y.PARAMETROS.ARCHIVO.VAL,@SM,@VM) ;*R22 MANUAL CONVERSION
        Y.PARAMETROS.ARCHIVO.TEXT = CHANGE(Y.PARAMETROS.ARCHIVO.TEXT,@SM,@VM) ;*R22 MANUAL CONVERSION
    END


    LOCATE "NOMBRE.ARCHIVO" IN Y.PARAMETROS.ARCHIVO.VAL<1,1> SETTING NOMBRE1.POS THEN
        Y.NOMBRE.REPORTE  = Y.PARAMETROS.ARCHIVO.TEXT<1,NOMBRE1.POS>
    END



    FN.CHK.DIR1 = Y.OUTPUT.DIR;
    F.CHK.DIR1 = '';
    CALL OPF (FN.CHK.DIR1,F.CHK.DIR1)

RETURN

PROCESS:
********

    SEL.CMD  = ''; NO.OF.RECS = ''; F.CHK.DIR = "" ; SEL.LIST= ''
    SEL.CMD = " SELECT " : FN.LAPAP.COBRO.AUT.WRITE
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SEL.ERR)
    IF NO.OF.RECS EQ 0 THEN
        RETURN
    END
    Y.ARREGLO<-1> = "CUENTA DEBITO|CODIGO TRANSACION|PRESTAMO|MONTO|AUTORIZACION DE COBRO|RERENCIA DE PAGO FT|ESTADO |DETALLE ERROR"

    LOOP
        REMOVE Y.ID.RECORD FROM SEL.LIST SETTING REGISTRO.POS
    WHILE Y.ID.RECORD  DO
        CALL F.READ(FN.LAPAP.COBRO.AUT.WRITE,Y.ID.RECORD,R.LAPAP.COBRO.AUT.WRITE,FV.LAPAP.COBRO.AUT.WRITE,ERROR1)
        Y.ARREGLO<-1> = R.LAPAP.COBRO.AUT.WRITE
    REPEAT

    GOSUB CHECK.ARCHIVO.FILES
RETURN



CHECK.ARCHIVO.FILES:
    R.FIL = ''; READ.FIL.ERR = '' ; Y.FILE.NAME = Y.NOMBRE.REPORTE:".":TODAY:".csv"
    CALL F.READ(FN.CHK.DIR1,Y.FILE.NAME,R.FIL,F.CHK.DIR1,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR1,Y.FILE.NAME
    END
    WRITE Y.ARREGLO ON F.CHK.DIR1, Y.FILE.NAME ON ERROR
        CALL OCOMO("Error en la escritura del archivo en el directorio":F.CHK.DIR1)
    END
RETURN

END
