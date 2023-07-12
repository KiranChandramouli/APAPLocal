*-----------------------------------------------------------------------------
* <Rating>154</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.REPORTE.UNICO.WOF.POST
*--------------------------------------------------------------------------------------------------------------------
* Description           : Rutina post,  la cual lee los registro insertado por la rutina MAIN LAPAP.REPORTE.UNICO.WOF
*                         y genera el reporte unico posterior para prestamo castigados WOFF
* Developed On          : 19-11-2019
* Developed By          : APAP
* Development Reference : GDC-704
*--------------------------------------------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_TSA.COMMON
    $INSERT BP I_F.ST.LAPAP.INFILEPRESTAMO
    $INSERT T24.BP I_F.EB.CONTRACT.BALANCES
    $INSERT T24.BP I_F.DATES
    $INSERT T24.BP I_F.AA.BILL.DETAILS
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT T24.BP I_F.AA.OVERDUE
    $INSERT T24.BP I_F.AA.INTEREST
    $INSERT T24.BP I_F.AA.TERM.AMOUNT
    $INSERT T24.BP I_F.AA.ACCOUNT.DETAILS
    $INSERT T24.BP I_F.AA.PAYMENT.SCHEDULE
    $INSERT T24.BP I_F.AA.INTEREST.ACCRUALS
    $INSERT T24.BP I_F.AA.ACCOUNT
    $INSERT T24.BP I_F.AA.CUSTOMER
    $INSERT T24.BP I_F.AA.ARRANGEMENT
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT LAPAP.BP I_LAPAP.REPORTE.UNICO.WOF.COMMON


MAIN.PROCES:
    GOSUB OPEN.FILES
    GOSUB READ.REPORT.PARAM
    GOSUB GENERACION.INFILE
    RETURN
OPEN.FILES:
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    FN.ST.LAPAP.INFILEPRESTAMO  = 'F.ST.LAPAP.INFILEPRESTAMO'
    FV.ST.LAPAP.INFILEPRESTAMO = ''
    CALL OPF(FN.ST.LAPAP.INFILEPRESTAMO,FV.ST.LAPAP.INFILEPRESTAMO)
    RETURN
READ.REPORT.PARAM:
    ID.REPORT = 'LAPAP.ECB.BALANCES.WOF'
    CALL F.READ(FN.REDO.H.REPORTS.PARAM,ID.REPORT,R.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM,ERROR.REPORT.PARAM)
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
        LOCATE "REPORTE.UNICO.POST" IN Y.FIELD.NME.ARR<1,1> SETTING COD.POS2 THEN
            Y.REPORTE.UNICO.POST = Y.FIELD.VAL.ARR<1,COD.POS2>
            Y.REPORTE.UNICO.POST = CHANGE(Y.REPORTE.UNICO.POST,SM,FM)
            Y.REPORTE.UNICO.POST = CHANGE(Y.REPORTE.UNICO.POST,VM,FM)
        END
        LOCATE "RUTA.INFILES" IN Y.FIELD.NME.ARR<1,1> SETTING COD.POS3 THEN
            Y.RUTA.INFILES = Y.FIELD.VAL.ARR<1,COD.POS3>
            Y.RUTA.INFILES = CHANGE(Y.RUTA.INFILES,SM,FM)
            Y.RUTA.INFILES = CHANGE(Y.RUTA.INFILES,VM,FM)
        END
        RETURN
GENERACION.INFILE:
        SEL.CMD  = ''; NO.OF.RECS = '' SEL.ERR = ''
        FN.CHK.DIR = Y.RUTA.INFILES ; F.CHK.DIR = "" ; Y.LISTA.CONSTANTE = ''
        CALL OPF(FN.CHK.DIR,F.CHK.DIR)
        SEL.CMD = " SELECT " : FN.ST.LAPAP.INFILEPRESTAMO
        CALL EB.READLIST(SEL.CMD, Y.LISTA.CONSTANTE, '',NO.OF.RECS,SEL.ERR)
        GOSUB WRITE.REPORTE.UNICO.POS
        RETURN
WRITE.REPORTE.UNICO.POS:
        Y.ID.RECORD = '' ; Y.ARREGLO = '' ; REGISTRO.POS = '' ; ERROR.LAPAP.INFILEPRESTAMO = '' ; R.ST.LAPAP.INFILEPRESTAMO = ''
        Y.FILE.NAME = Y.REPORTE.UNICO.POST:".":TODAY:".csv" ; SEL.LIST = Y.LISTA.CONSTANTE
        Y.HEADER = "ARRANGEMENT.ID,START.DATE,CONTRATO,PRODUCT.GROUP,PRODUCT,ARR.STATUS,ESTADO.ACTUAL,TIPO.PRODUCTO,"
        Y.HEADER = Y.HEADER : "ID.CLIENTE,COMPANY,ID.ALTERNO.LEGACY,ID.ALTERNO.PLAN.Z,ID.ALTERNO.WOF,FECHA.ORIGINAL.APERT,FECHA.APERTURA,"
        Y.HEADER = Y.HEADER : "FECHA.VENCIMIENTO,FECHA.CASTIGO,MONTO.ORIGINAL,ESTATUS,CONDICION1,CONDICION2,OBSERVACIONES,FECHA.INICIO.ADJUDICACION,"
        Y.HEADER = Y.HEADER : "COMPAÑIA.AFILIADA,TIPO.CAMPAÑA,CODEUDOR,OFICIAL.PRINCIPAL,CODIGO.SUCURSAL,ORIGEN.DE.LOS.RECURSOS,TIPO.FACILIDAD.CREDITICIA,DIA.DE.PAGO,"
        Y.HEADER = Y.HEADER : "BILL.DATE,ACCOUNTWOF,PRINCIPALINTWOF,PRINCIPALINWOF,PENALTYINTWOF,PRADMSEGWOF,PRADMVARWOF,PRMORAWOF,CANTIDAD.CUOTA"
        Y.ARREGLO<-1> = Y.HEADER
        LOOP
            REMOVE Y.ID.RECORD FROM SEL.LIST SETTING REGISTRO.POS
        WHILE Y.ID.RECORD  DO
            CALL F.READ(FN.ST.LAPAP.INFILEPRESTAMO,Y.ID.RECORD,R.ST.LAPAP.INFILEPRESTAMO,FV.ST.LAPAP.INFILEPRESTAMO,ERROR.LAPAP.INFILEPRESTAMO)
            GOSUB GET.REGISTRO.INFILE.UNICO.POS
            Y.ARREGLO<-1> = Y.FINAL
        REPEAT
        GOSUB CHECK.ARCHIVO.FILES
        WRITE Y.ARREGLO ON F.CHK.DIR, Y.FILE.NAME ON ERROR
            CALL OCOMO("Error en la escritura del archivo en el directorio":F.CHK.DIR)
        END

        RETURN
CHECK.ARCHIVO.FILES:
        R.FIL = ''; READ.FIL.ERR = ''
        CALL F.READ(FN.CHK.DIR,Y.FILE.NAME,R.FIL,F.CHK.DIR,READ.FIL.ERR)
        IF R.FIL THEN
            DELETE F.CHK.DIR,Y.FILE.NAME
        END
        RETURN
GET.REGISTRO.INFILE.UNICO.POS:
        Y.FINAL = ""
        Y.FINAL = R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.ARRANGEMENT.ID> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.START.DATE> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.CONTRATO> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.PRODUCT.GROUP>  : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.PRODUCT> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.ARR.STATUS> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.ESTADO.ACTUAL> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.TIPO.PRODUCTO> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.ID.CLIENTE> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.COMPANY> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.ID.ALTERNO.LEGACY> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.ID.ALTERNO.PLAN.Z> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.ID.ALTERNO.WOF> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.FECHA.ORIGINAL.APE> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.FECHA.APERTURA> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.FECHA.VENCIMIENTO> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.FECHA.CASTIGO> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.MONTO.ORIGINAL> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.ESTATUS> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.CONDICION1> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.CONDICION2> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.OBSERVACIONES> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.FECHA.INICIO.ADJUD> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.COMPANIA.AFILIADA> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.TIPO.CAMPANA> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.CODEUDOR> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.OFICIAL.PRINCIPAL> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.CODIGO.SUCURSAL> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.ORIGEN.DE.LOS.RECU> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.TIPO.FACILIDAD.CRE> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.DIA.DE.PAGO> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.BILL.DATE> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.ACCOUNTWOF> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.PRINCIPALINTWOF> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.PRINCIPALINWOF> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.PENALTYINTWOF> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.PRADMSEGWOF> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.PRADMVARWOF> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.PRMORAWOF> : ","
        Y.FINAL = Y.FINAL : R.ST.LAPAP.INFILEPRESTAMO<ST.LAP64.CANTIDAD.CUOTA>
        RETURN
    END
