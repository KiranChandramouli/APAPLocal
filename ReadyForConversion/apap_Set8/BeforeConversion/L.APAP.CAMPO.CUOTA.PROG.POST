*-----------------------------------------------------------------------------
* <Rating>-42</Rating>
*-----------------------------------------------------------------------------
*-------------------------------------------------------------------------
* Rutina multi hilo para actualizar el campo ACTUAL.AMT cuota programada
* para los contratos que tiene monto igual a cero 0 en la tabla de
* de prelación con el monto COVID19
* Fecha: 17/12/2020
* Autor: APAP
*--------------------------------------------------------------------------
    SUBROUTINE L.APAP.CAMPO.CUOTA.PROG.POST

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT BP I_F.L.APAP.LOG.COVID19

    GOSUB MAIN.PROCESS
    RETURN

MAIN.PROCESS:
*************

    GOSUB OPEN.FILES
    GOSUB PROCESS

    RETURN

OPEN.FILES:
**********

    FN.L.APAP.LOG.COVID19 = 'F.ST.L.APAP.LOG.COVID19'
    FV.L.APAP.LOG.COVID19 = ''
    CALL OPF (FN.L.APAP.LOG.COVID19,FV.L.APAP.LOG.COVID19)

***directorio de salidad
    FN.CHK.DIR1 = "DMFILES"
    F.CHK.DIR1 = ""
    CALL OPF(FN.CHK.DIR1,F.CHK.DIR1)
    Y.FILE.NAME = "LOG.ERROR.CUOTA_PRO":TODAY:".txt"

    RETURN

PROCESS:
********

    SEL.CMD  = ''; NO.OF.RECS = ''; F.CHK.DIR = "" ; SEL.LIST= ''
    SEL.CMD = " SELECT " : FN.L.APAP.LOG.COVID19
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SE L.ERR)
    IF NO.OF.RECS EQ 0 THEN
        RETURN
    END
    Y.ARREGLO<-1> = "NUMERO DE AA|ESTADO|DETALLE ERROR"
    LOOP
        REMOVE Y.ID.RECORD FROM SEL.LIST SETTING REGISTRO.POS
    WHILE Y.ID.RECORD  DO
        CALL F.READ(FN.L.APAP.LOG.COVID19,Y.ID.RECORD,R.L.APAP.LOG.COVID19,FV.L.APAP.LOG.COVID19,ERROR1)
        Y.ARREGLO<-1> =  Y.ID.RECORD:"|FALLIDO|":R.L.APAP.LOG.COVID19<ST.L.A57.DETALLE>
    REPEAT

    GOSUB CHECK.ARCHIVO.FILES
    RETURN

CHECK.ARCHIVO.FILES:
    R.FIL = ''; READ.FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR1,Y.FILE.NAME,R.FIL,F.CHK.DIR1,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR1,Y.FILE.NAME
    END
    WRITE Y.ARREGLO ON F.CHK.DIR1, Y.FILE.NAME ON ERROR
        CALL OCOMO("Error en la escritura del archivo en el directorio":F.CHK.DIR1)
    END
    RETURN

END
