* @ValidationCode : MjoxNzAyMDc3NjcyOkNwMTI1MjoxNjkxNjUyNDM0ODcyOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Aug 2023 12:57:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
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
* <Rating>-53</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.COL.FF.COLLECTOR.POST
* Service : BNK/L.APAP.COL.FF.COLLECTOR
*------------------------------------------------------------------------------
* Date                  Who                               Reference           Description
* ----                  ----                                ----                 ----
* 09-08-2023         Ajith Kumar         R22 Manual Code Conversion        LAPAP.BP,TAM.BP IS REMOVED,CALL RTN FORMAT CAN BE MODIFIED

* ----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT I_EQUATE
    $INSERT  I_F.REDO.INTERFACE.PARAM ;*R22 MANUAL CODE CONVERSION
    $INSERT  I_L.APAP.COL.COLLECTOR.COMMON ;*R22 MANUAL CODE CONVERSION
    $INSERT  I_F.TSA.SERVICE ;*R22 MANUAL CODE CONVERSION

    GOSUB INITIALISE

RETURN

INITIALISE:

    CALL L.APAP.COL.FF.COLLECTOR.LOAD
    APAP.LAPAP.lApapColFfCollectorLoad() ;*R22 MANUAL CODE CONVERSION
    CALL OCOMO( "Ejecuntando la rutina : L.APAP.COL.FF.COLLECTOR.POST")
    Y.EXTRACT.OUT.PATH=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.AUTO.PATH>
    LOOP
        REMOVE C.TABLE.ID FROM C.TABLES SETTING POS
    WHILE C.TABLE.ID:POS
        IF C.TABLE.ID EQ 'gestipogarantias' OR C.TABLE.ID EQ 'gesgarantias' THEN
            CONTINUE
        END
        GOSUB TABLE.PROCESS
    REPEAT
    EXE.TOUCH='touch ':Y.EXTRACT.OUT.PATH:'/chk_file'
    SHELL.TCH ='SH -c '
    DAEMON.TCH = SHELL.TCH:EXE.TOUCH
    EXECUTE DAEMON.TCH RETURNING RETURN.VALUE CAPTURING CAPTURE.TCH.VALUE
*----------------------------------------
    FN.CHK.DIR = Y.EXTRACT.OUT.PATH
    F.CHK.DIR = '';
    CALL OPF (FN.CHK.DIR,F.CHK.DIR)
    GOSUB SET.TMP.TIPOGARANTIAS;
    GOSUB SET.TMP.GARANTIAS;
*----------------------------------------


    R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PAYMENT.REF> = 1
    CALL F.WRITE('F.REDO.INTERFACE.PARAM','COL001',R.REDO.INTERFACE.PARAM)

RETURN

TABLE.PROCESS:
    SHELL.CMD ='SH -c '
    EXEC.COM="cat "
    OLD.OUT.FILES = 'SESSION':C.TABLE.ID:'*'
    EXE.CAT = "cat ":Y.EXTRACT.OUT.PATH:"/":OLD.OUT.FILES:" >> ":Y.EXTRACT.OUT.PATH:"/":C.TABLE.ID:'.txt'
    EXE.RM="rm ":Y.EXTRACT.OUT.PATH:"/":OLD.OUT.FILES

    DAEMON.CMD = SHELL.CMD:EXE.CAT
    DAEMON.REM.CMD = SHELL.CMD:EXE.RM

    EXECUTE DAEMON.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.CAT.VALUE
    EXECUTE DAEMON.REM.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.REM.VALUE
RETURN



**--------------------------
CHECK.ARCHIVO.FILES:
**--------------------------
    R.FIL = ''; READ.FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,Y.FILE.NAME,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,Y.FILE.NAME
    END
RETURN
*-----------------------------------

*-----------------------------------
SET.TMP.GARANTIAS:
*-------------------------

    SEL.CMD.GA = ''; SEL.LIST.GA = ''; NO.OF.RECS.GA = ''; SEL.ERR.GA = ''; Y.ID.RECORD.GA = '';
    Y.ARREGLO = ''; Y.DUPLICADOS = ''; Y.ID.TIPO.GAR = '';
    Y.FILE.NAME = C.TABLES<8>:".txt"
    SEL.CMD.GA = "SELECT ":FN.LAPAP.CONCAT.TMP.GESGARANTIAS
    CALL EB.READLIST(SEL.CMD.GA,SEL.LIST.GA,'',NO.OF.RECS.GA,SEL.ERR.GA)
    LOOP
        REMOVE Y.ID.RECORD.GA FROM SEL.LIST.GA SETTING REGISTROGA.POS
    WHILE Y.ID.RECORD.GA  DO
        CALL F.READ (FN.LAPAP.CONCAT.TMP.GESGARANTIAS,Y.ID.RECORD.GA,R.LAPAP.CONCAT.TMP.GESGARANTIAS,FV.LAPAP.CONCAT.TMP.GESGARANTIAS,ERROR.GESGARANTIAS)
        Y.ID.TIPO.GAR = FIELD(Y.ID.RECORD.GA,'|',1)
        LOCATE Y.ID.TIPO.GAR IN Y.DUPLICADOS<1> SETTING COD.POS4 THEN
            CONTINUE
        END
        Y.ARREGLO<-1> = R.LAPAP.CONCAT.TMP.GESGARANTIAS;
        Y.DUPLICADOS<-1> = FIELD(Y.ID.RECORD.GA,'|',1)
    REPEAT

    GOSUB CHECK.ARCHIVO.FILES
    WRITE Y.ARREGLO ON F.CHK.DIR, Y.FILE.NAME ON ERROR
        CALL OCOMO("Error en la escritura del archivo en el directorio":F.CHK.DIR)
    END

RETURN

*------------------------------
SET.TMP.TIPOGARANTIAS:
*------------------------------
    SEL.CMD.TG = ''; SEL.LIST.TG = ''; NO.OF.RECS.TG = ''; SEL.ERR.TG = ''; Y.ID.RECORD.TG = '';
    Y.ARREGLO = ''; Y.DUPLICADOS = '';
    Y.FILE.NAME = C.TABLES<7>:".txt"
    SEL.CMD.TG = "SELECT ":FN.LAPAP.CONCAT.TMP.TIPOGARANTIA
    CALL EB.READLIST(SEL.CMD.TG,SEL.LIST.TG,'',NO.OF.RECS.TG,SEL.ERR.TG)

    LOOP
        REMOVE Y.ID.RECORD.TG FROM SEL.LIST.TG SETTING REGISTROTG.POS
    WHILE Y.ID.RECORD.TG  DO
        CALL F.READ (FN.LAPAP.CONCAT.TMP.TIPOGARANTIA,Y.ID.RECORD.TG,R.LAPAP.CONCAT.TMP.TIPOGARANTIA,FV.LAPAP.CONCAT.TMP.TIPOGARANTIA,ERROR.TIPOGARANTIA)

        Y.ID.TIPO.GAR = FIELD(Y.ID.RECORD.TG,'|',1)
        LOCATE Y.ID.TIPO.GAR IN Y.DUPLICADOS<1> SETTING COD.POS3 THEN
            CONTINUE
        END
        Y.ARREGLO<-1> = R.LAPAP.CONCAT.TMP.TIPOGARANTIA;
        Y.DUPLICADOS<-1> = FIELD(Y.ID.RECORD.TG,'|',1)

    REPEAT
    GOSUB CHECK.ARCHIVO.FILES
    Y.ARREGLO = CHANGE(Y.ARREGLO,'*','~')
    WRITE Y.ARREGLO ON F.CHK.DIR, Y.FILE.NAME ON ERROR
        CALL OCOMO("Error en la escritura del archivo en el directorio":F.CHK.DIR)
    END

RETURN

END
