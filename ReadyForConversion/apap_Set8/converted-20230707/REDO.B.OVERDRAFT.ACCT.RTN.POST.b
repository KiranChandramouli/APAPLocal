SUBROUTINE REDO.B.OVERDRAFT.ACCT.RTN.POST
*********************************************************************************************************
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Dev By       : V.P.Ashokkumar
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.LIMIT
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.OVERDRAFT.ACCT.RTN.COMMON

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN

INITIALISE:
************
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    FN.DR.OPER.OVERDRAF.WORKFILE = 'F.DR.OPER.OVERDRAF.WORKFILE'
    F.DR.OPER.OVERDRAF.WORKFILE = ''
    CALL OPF(FN.DR.OPER.OVERDRAF.WORKFILE,F.DR.OPER.OVERDRAF.WORKFILE)

    Y.RECORD.PARAM.ID = "REDO.OPER.RPT"
    R.REDO.H.REPORTS.PARAM = ''; PARAM.ERR = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.RECORD.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        FN.CHK.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    END

    Y.OUT.FILE.NAME = 'ACCOUNT_OVERDRAFT'
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    EXTRACT.FILE.ID = Y.OUT.FILE.NAME:'.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.csv'
    R.FILE.DATA = ''
*
    R.FIL = ''; FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID
    END
RETURN

PROCESS:
********
    SEL.CMD = ''; ID.LIST = ""; ID.CNT = ''; ERR.SEL = ''; R.FILE.DATA = ''; YHDR.ARRAY = ''; TWL.YOVERDRFT.2 = ''; TWL.YOVERDRFT.3 = ''
    YTOT.AMT.WNL = 0; YTOT.AMT.WL = 0; R.FILE.DATA.WL = ''; R.TOT.DATA = ''; T.YOVERDRFT.2 = ''; T.YOVERDRFT.3 = ''
    YHDR.ARRAY = "AGENCIA,OFICIAL DE CUENTA,TIPO DE CUENTA,NO.DE CUENTA,NO TARJETA DE DEBITO,NOMBRE DE LA CUENTA,CODIGO DE CLIENTE,MONEDA,BALANCE TOTAL,BALANCE DISPONIBLE,BALANCE EN TRANSITO,ESTATUS 1,ESTATUS 2,FECHA ULTIMA TXN,DESCRIP TRANSACCION,FECHA APERTURA,NO. CUENTA INVERSION"
    SEL.CMD = "SELECT ":FN.DR.OPER.OVERDRAF.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    ID.CTR = 1
    LOOP
        REMOVE REC.ID FROM ID.LIST SETTING OVER.POSN
    WHILE REC.ID:OVER.POSN
        R.DR.OPER.OVERDRAF.WORKFILE = ''; RD.ERR = ''
        CALL F.READ(FN.DR.OPER.OVERDRAF.WORKFILE, REC.ID, R.DR.OPER.OVERDRAF.WORKFILE, F.DR.OPER.OVERDRAF.WORKFILE, RD.ERR)
        IF NOT(R.DR.OPER.OVERDRAF.WORKFILE) THEN
            RETURN
        END
        YOVERDRFT = 0; YOVERDRFT.2 = 0; YOVERDRFT.3 = 0
        YOVERDRFT = FIELD(R.DR.OPER.OVERDRAF.WORKFILE,',',9)
        YOVERDRFT.2 = FIELD(R.DR.OPER.OVERDRAF.WORKFILE,',',10)
        YOVERDRFT.3 = FIELD(R.DR.OPER.OVERDRAF.WORKFILE,',',11)
        IF REC.ID[1,3] EQ 'WNL' THEN
            YTOT.AMT.WNL +=YOVERDRFT
            T.YOVERDRFT.2 += YOVERDRFT.2
            T.YOVERDRFT.3 += YOVERDRFT.3
            R.FILE.DATA<-1> = R.DR.OPER.OVERDRAF.WORKFILE
        END
        IF REC.ID[1,2] EQ 'WL' THEN
            YTOT.AMT.WL +=YOVERDRFT
            TWL.YOVERDRFT.2 += YOVERDRFT.2
            TWL.YOVERDRFT.3 += YOVERDRFT.3
            R.FILE.DATA.WL<-1> = R.DR.OPER.OVERDRAF.WORKFILE
        END
    REPEAT
    R.FILE.DATA = SORT(R.FILE.DATA)
    R.FILE.DATA.WL = SORT(R.FILE.DATA.WL)
    IF YTOT.AMT.WNL OR T.YOVERDRFT.2 THEN
        R.FILE.DATA<-1> = "TOTAL ,,,,,,,,":YTOT.AMT.WNL:",":T.YOVERDRFT.2:",":T.YOVERDRFT.3:",,,,,,"
    END
    IF YTOT.AMT.WL OR TWL.YOVERDRFT.2 THEN
        R.FILE.DATA.WL<-1> = "TOTAL ,,,,,,,,":YTOT.AMT.WL:",":TWL.YOVERDRFT.2:",":TWL.YOVERDRFT.3:",,,,,,"
    END

    R.TOT.DATA = YHDR.ARRAY:@FM:R.FILE.DATA:@FM:R.FILE.DATA.WL
    WRITE R.TOT.DATA ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
    END
RETURN
END
