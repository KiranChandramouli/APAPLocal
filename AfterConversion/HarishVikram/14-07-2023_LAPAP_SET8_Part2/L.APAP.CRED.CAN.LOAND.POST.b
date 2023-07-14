* @ValidationCode : Mjo3ODMzOTc1Njg6Q3AxMjUyOjE2ODkyNDE5NzAyMDU6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jul 2023 15:22:50
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
SUBROUTINE L.APAP.CRED.CAN.LOAND.POST
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed in INSERTFILE, F.READ to CACHE.READ
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON                           ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_F.DATES
    $INSERT I_F.ST.LAPAP.REPORTDE16            ;*R22 Auto conversion - End

    GOSUB GET.LOARD.TABLE
    GOSUB GET.CONTANTES.VAR
    GOSUB SET.ESCRITURA.FINAL
GET.LOARD.TABLE:
****************
    FN.DATES = 'F.DATES'
    FV.DATES = ''
    CALL OPF(FN.DATES,FV.DATES)
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    FN.LAPAP.REPORTDE16 = "F.ST.LAPAP.REPORTDE16"
    F.LAPAP.REPORTDE16 = ''
    CALL OPF(FN.LAPAP.REPORTDE16,F.LAPAP.REPORTDE16)

RETURN
GET.CONTANTES.VAR:
*******************
    GOSUB GET.FECHA.CORTE
    Y.APAP.REP.PARAM.ID = 'REDO.DE16'
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.APAP.REP.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.OUTPUT.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.FILE.NAME  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FILE.DIR   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
    END
    Y.DIR.NAME = Y.OUTPUT.DIR
    Y.FILE.NAME = Y.FILE.NAME:"_":Y.FECHA.CORTE:".TXT"
    Y.SAVE.NAME = 'F.REPORTE.DE16'
    Y.SAVE.DIR = Y.FILE.DIR
RETURN
GET.FECHA.CORTE:
****************
    R.FECHAS = ''; ERR.FECHAS = ''
    CALL CACHE.READ(FN.DATES, 'DO0010001', R.FECHAS, ERR.FECHAS)         ;*R22 Auto conversion
    Y.FECHA.CORTE = R.FECHAS<EB.DAT.LAST.WORKING.DAY>
RETURN
SET.ESCRITURA.FINAL:
**********************
    Y.SECUENCIA = 0 ; Y.FINAL = ''
    DELETESEQ Y.DIR.NAME, Y.FILE.NAME ELSE NULL
    OPENSEQ Y.DIR.NAME,Y.FILE.NAME TO FV.PTR ELSE
        CREATE FV.PTR ELSE
            CRT "NO SE PUEDE ABRIR ARCHIVO: " : Y.FILE.NAME : " DEL DIRECTORIO: " : Y.DIR.NAME
            STOP
        END
    END
*******LEER EL REGISTRO
    SEL.CMD = " SELECT " : FN.LAPAP.REPORTDE16
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SEL.ERR)
    LOOP
        REMOVE PROCESS.ID FROM SEL.LIST SETTING FI.POS
    WHILE PROCESS.ID DO
        R.LAPAP.REPORTDE16 = ''; REPORTDE16.ERROR = ''
        CALL F.READ(FN.LAPAP.REPORTDE16,PROCESS.ID, R.LAPAP.REPORTDE16,F.LAPAP.REPORTDE16,REPORTDE16.ERROR)
        IF (R.LAPAP.REPORTDE16) THEN
            Y.SECUENCIA += 1
            CAMPO.VAL1 = FMT(Y.SECUENCIA,'L#7')
            Y.FINAL = CAMPO.VAL1:R.LAPAP.REPORTDE16
            WRITESEQ Y.FINAL TO FV.PTR ELSE
                CRT "NO SE PRUEDE ESCRIBIR EL ARCHIVO: " : Y.FILE.NAME
                STOP
            END
        END
    REPEAT
    CLOSESEQ FV.PTR
RETURN
END
