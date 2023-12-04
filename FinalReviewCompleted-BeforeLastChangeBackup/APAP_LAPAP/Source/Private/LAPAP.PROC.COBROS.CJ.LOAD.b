* @ValidationCode : MjozNTIzODY4Mzk6Q3AxMjUyOjE3MDA4NDI2NzQ3Njk6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Nov 2023 21:47:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*09-08-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED, $INCLUDE TO $INSERT,VM TO @VM, SM TO @SM
*21/11/2023     Suresh             R22 Manual Conversion   Latest Routine Changes Merged
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.PROC.COBROS.CJ.LOAD
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

    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.OFS.SOURCE
    $INSERT I_F.REDO.PART.TT.PROCESS
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_LAPAP.PROC.COBROS.CJ.COMMON ;*R22 MANUAL CONVERSION END

    GOSUB CARGAR.TABLAS
    GOSUB LECTURA.PARAMETROS
RETURN

CARGAR.TABLAS:
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM';
    FV.REDO.H.REPORTS.PARAM = '';
    CALL OPF (FN.REDO.H.REPORTS.PARAM ,FV.REDO.H.REPORTS.PARAM)

    FN.LAPAP.COBRO.AUT.WRITE = 'F.LAPAP.COBRO.AUT.WRITE';
    FV.LAPAP.COBRO.AUT.WRITE = '';
    CALL OPF (FN.LAPAP.COBRO.AUT.WRITE,FV.LAPAP.COBRO.AUT.WRITE)

* FN.DIR = 'DMFILES';
* FV.DIR = '';
*CALL OPF (FN.DIR,FV.DIR)

    FN.REDO.PART.TT.PROCESS = 'F.REDO.PART.TT.PROCESS';
    FV.REDO.PART.TT.PROCESS = '';
    CALL OPF (FN.REDO.PART.TT.PROCESS,FV.REDO.PART.TT.PROCESS)

    FN.ACCOUNT = 'F.ACCOUNT';
    F.ACCOUNT = '';

    CALL OPF (FN.ACCOUNT,F.ACCOUNT)

    CALL GET.LOC.REF("ACCOUNT","L.AC.AV.BAL",POS.AVL.BAL) ;* Latest Routine- Changes

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


    FN.DIR = Y.OUTPUT.DIR;
    FV.DIR = '';
    CALL OPF (FN.DIR,FV.DIR)




    LOCATE "TIPO.PAGOS" IN Y.FIELD.NME.ARR<1,1> SETTING TIPOPAGOS.POS THEN
        Y.TIPO.PAGOS.VAL = Y.FIELD.VAL.ARR<1,TIPOPAGOS.POS>
        Y.TIPO.PAGOS.TEXT = Y.DISP.TEXT.ARR<1,TIPOPAGOS.POS>

        Y.TIPO.PAGOS.VAL = CHANGE(Y.TIPO.PAGOS.VAL,@SM,@VM) ;*R22 MANUAL CONVERSION
        Y.TIPO.PAGOS.TEXT = CHANGE(Y.TIPO.PAGOS.TEXT,@SM,@VM) ;*R22 MANUAL CONVERSION
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



    LOCATE "NOMBRE.INFILE" IN Y.PARAMETROS.ARCHIVO.VAL<1,1> SETTING NOMBRE2.POS THEN
        Y.INFILE.NAME = Y.PARAMETROS.ARCHIVO.TEXT<1,NOMBRE2.POS>
    END


    LOCATE "VERSION" IN Y.FIELD.NME.ARR<1,1> SETTING VERSION.POS THEN
        Y.VERSION.OFS = Y.FIELD.VAL.ARR<1,VERSION.POS>
        Y.VERSION.OFS = CHANGE(Y.VERSION.OFS,@SM,@FM) ;*R22 MANUAL CONVERSION
        Y.VERSION.OFS = CHANGE(Y.VERSION.OFS,@VM,@FM) ;*R22 MANUAL CONVERSION
        Y.VERSION.OFS = Y.VERSION.OFS<1>
    END


RETURN

END
