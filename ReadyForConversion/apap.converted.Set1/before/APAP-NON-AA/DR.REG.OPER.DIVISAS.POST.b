*--------------------------------------------------------------------------------------------------------------------------------
* <Rating>-120</Rating>
*--------------------------------------------------------------------------------------------------------------------------------
    SUBROUTINE DR.REG.OPER.DIVISAS.POST
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date        Author             Modification Description
* 12-Sep-2014   V.P.Ashokkumar     PACS00318671 - Rewritten to create 2 reports
* 31-Mar-2015   V.P.Ashokkumar     PACS00318671 - Fixed the CDT error.
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INCLUDE REGREP.BP I_DR.BLD.OPER.DIVISAS
    $INCLUDE TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INCLUDE TAM.BP I_F.REDO.FX.CCY.POSN
*
    GOSUB OPEN.FILES
    GOSUB INIT.PARA
    GOSUB PROCESS.PARA
    GOSUB CURR.DUMM.LOOP
    GOSUB PROCESS.US.CURR.VAL
    RETURN

OPEN.FILES:
***********
    FN.DR.OPER.DIVISAS.FILE = 'F.DR.OPER.DIVISAS.FILE'; F.DR.OPER.DIVISAS.FILE = ''; YFLD.TOT = ''
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'; F.REDO.H.REPORTS.PARAM  = ''; YDATE = ''
    FN.REDO.FX.CCY.POSN = 'F.REDO.FX.CCY.POSN'; F.REDO.FX.CCY.POSN = ''; YFLD3.TOT = ''
    CALL OPF(FN.DR.OPER.DIVISAS.FILE,F.DR.OPER.DIVISAS.FILE)
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    CALL OPF(FN.REDO.FX.CCY.POSN,F.REDO.FX.CCY.POSN)

    Y.LAST.WRK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    YDATE = Y.LAST.WRK.DAY[7,2]:'/':Y.LAST.WRK.DAY[5,2]:'/':Y.LAST.WRK.DAY[1,4]
    RETURN

INIT.PARA:
**********
    Y.REPORT.PARAM.ID = "REDO.DIVISAS"
    R.REDO.H.REPORTS.PARAM = ''; PARAM.ERR = ''; Y.TXNCDE.CONCP.ARR = ''; FN.CHK.DIR = ''
    Y.OUT.FILE.NAME = ''; Y.FIELD.NME.ARR = ''; Y.FIELD.VAL.ARR = ''; Y.DISP.TEXT.ARR = ''
    HEADER.ARR = ''; HEADER.DET.ARR = ''; RETURN.ARR = ''; RETURN.ARR.S = ''
    YY.CCY.GRP = ''; YYS.CCY.GRP = ''; YMONT.ARR.FOOT = ''; YSP.ARR.HEAD = ''
    YFLD.TOTS = ''; YFLD.TOTB = ''; YFLD3.TOTS = ''; YFLD3.TOTB = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.REPORT.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        FN.CHK.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.OUT.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
    END

    LOCATE "HEADER.DETAIL" IN Y.FIELD.NME.ARR<1,1> SETTING TXNHDD.POS THEN
        HEADER.DET.ARR<-1> = Y.FIELD.VAL.ARR<1,TXNHDD.POS,1>
        Y.TXNHDRD1.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNHDD.POS,2>
        Y.TXNHDRD2.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNHDD.POS,3>
        Y.TXNHDRD3.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNHDD.POS,4>
        Y.TXNHDRD4.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNHDD.POS,5>
        HEADER.DET.ARR<-1> = Y.TXNHDRD1.VAL.ARR:FMT(' ','L#10'):Y.TXNHDRD2.VAL.ARR
        HEADER.DET.ARR<-1> = Y.TXNHDRD3.VAL.ARR:FMT(' ','L#10'):Y.TXNHDRD4.VAL.ARR:" ":YDATE
    END

    LOCATE "HEADER.SUMMARY" IN Y.FIELD.NME.ARR<1,1> SETTING TXNCE.POS THEN
        HEADER.ARR<-1> = Y.FIELD.VAL.ARR<1,TXNCE.POS,1>
        HEADER.ARR<-1> = Y.FIELD.VAL.ARR<1,TXNCE.POS,2>
        Y.TXNHDR1.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNCE.POS,3>
        Y.TXNHDR2.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNCE.POS,4>
        Y.TXNHDR3.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNCE.POS,5>
        Y.TXNHDR4.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNCE.POS,6>
        HEADER.ARR<-1> = Y.TXNHDR1.VAL.ARR:FMT(' ','L#10'):Y.TXNHDR2.VAL.ARR
        HEADER.ARR<-1> = Y.TXNHDR3.VAL.ARR:FMT(' ','L#15'):Y.TXNHDR4.VAL.ARR:" ":YDATE
    END

    LOCATE "REPORT.SUMRY.BUY" IN Y.FIELD.NME.ARR<1,1> SETTING TXNBY.POS THEN
        Y.TXNSBUY.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNBY.POS>
        Y.TXNSBUY.DIS.ARR = Y.DISP.TEXT.ARR<1,TXNBY.POS>
    END

    LOCATE "REPORT.SUMRY.SEL" IN Y.FIELD.NME.ARR<1,1> SETTING TXNSE.POS THEN
        Y.TXNSSEL.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNSE.POS>
        Y.TXNSSEL.DIS.ARR = Y.DISP.TEXT.ARR<1,TXNSE.POS>
    END

    LOCATE "CURRENCY.LIST" IN Y.FIELD.NME.ARR<1,1> SETTING TXNCCY.POS THEN
        Y.TXNSCCY.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNCCY.POS>
        Y.TXNSCCY.DIS.ARR = Y.DISP.TEXT.ARR<1,TXNCCY.POS>
    END

    YMONT.ARR.FOOT<-1> = "TRANSACCIONES  DE  REMESAS||":FM:"  (ENTIDADES FINANCIERAS Y AGENTES REMESADORES) ||"
    YMONT.ARR.FOOT<-1> = "|MONTOS US$ Y RD$|TASA DE CAMBIO|TASA DE CAMBIO RD$/US$"

    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    EXTRACT.FILE.ID = Y.OUT.FILE.NAME:'SUM_':Y.LAST.WRK.DAY:'.txt'
    EXTRACT.DTFILE.ID = Y.OUT.FILE.NAME:'DET_':Y.LAST.WRK.DAY:'.txt'

    RETURN.ARR<-1> = HEADER.DET.ARR
    RETURN.ARR<-1> = FMT(' ','L#35')
    RETURN.ARR<-1> = "Numero de Recibo|Nombres y apellidos del cliente|Numero de identificación|Tipo de Operación|Moneda|Monto|Tasa|Concepto"
    RETURN.ARR.S<-1> = HEADER.ARR
    RETURN.ARR.S<-1> = FMT(' ','L#35')
    RETURN.ARR.S<-1> = "TIPO DE MONEDA|POSICION INICIAL|COMPRAS|VENTAS|POSICION FINAL"
    YSP.ARR.HEAD = FMT(' ','L#35')
    YSP.ARR.HEAD<-1> = "CLASIFICACION DE LAS COMPRAS US$||CLASIFICACION DE LAS VENTAS US$||"
    YSP.ARR.HEAD<-1> = "CONCEPTO|VALOR|CONCEPTO|VALOR||"
    YSP.ARR.HEAD<-1> = FMT(' ','L#35')
    RETURN

PROCESS.PARA:
*************
    SEL.CMD = "SELECT ":FN.DR.OPER.DIVISAS.FILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    ID.CTR = 1
    LOOP
    WHILE ID.CTR LE ID.CNT
        R.REC = ''; RD.ERR = ''; REC.ID = ''
        REC.ID = ID.LIST<ID.CTR>
        CALL F.READ(FN.DR.OPER.DIVISAS.FILE, REC.ID, R.REC, F.DR.OPER.DIVISAS.FILE, RD.ERR)
        IF REC.ID[1,4] EQ 'GRP1' THEN
            RETURN.ARR<-1> = R.REC
        END
        IF REC.ID[1,2] EQ 'G3' THEN
            GOSUB GROUP.ARRY.FORM
        END
        ID.CTR += 1
    REPEAT
    CALL F.WRITE(FN.CHK.DIR,EXTRACT.DTFILE.ID,RETURN.ARR)
    RETURN

GROUP.ARRY.FORM:
****************
    YFLD2 = ''; YFLD3 = ''; YFLD4 = ''; YB.FLD3 = ''
    YFLD5 = ''; YFLD6 = ''; YS.FLD3 = ''; Y.FLD3 = ''
    YFLD2 = FIELD(R.REC,'|',2)
    YFLD3 = FIELD(R.REC,'|',3)
    YFLD4 = FIELD(R.REC,'|',4)
    YFLD5 = FIELD(R.REC,'|',5)
    YFLD6 = FIELD(R.REC,'|',6)

    VS.POSN = ''; V.POSN = ''; CC.POSN = ''; CC1.POSN = ''
    IF REC.ID[1,3] EQ 'G3B' AND YFLD4 EQ 'USD' AND YFLD2 NE '' THEN
        FINDSTR YFLD2 IN YYB.ARR.GRP SETTING V.POSN THEN
            YVAL1 = FIELD(YYB.ARRY<V.POSN>,',',2)
            Y.FLD3 = YVAL1 + YFLD3
            YYB.ARRY<V.POSN> = YFLD2:',':Y.FLD3
        END ELSE
            YYB.ARRY<-1> = YFLD2:',':YFLD3
            YYB.ARR.GRP<-1> = YFLD2
        END
    END
    IF REC.ID[1,3] EQ 'G3B' THEN
        FINDSTR YFLD4 IN YY.CCY.GRP SETTING CC.POSN THEN
            YVAL1 = FIELD(YY.CCYG<CC.POSN>,',',2)
            YB.FLD3 = YVAL1 + YFLD3
            YVAL2 = FIELD(YY.CCYG<CC.POSN>,',',3)
            YY.CCYG<CC.POSN> = YFLD4:',':YB.FLD3:',':YVAL2
        END ELSE
            YY.CCYG<-1> = YFLD4:',':YFLD3:','
            YY.CCY.GRP<-1> = YFLD4
        END
        IF YFLD5 EQ LCCY AND YFLD4 EQ 'USD' THEN
            YFLD.TOTB = YFLD.TOTB + (YFLD3 * YFLD6)
            YFLD3.TOTB = YFLD3.TOTB + YFLD3
        END
    END

    IF REC.ID[1,3] EQ 'G3S' AND YFLD4 EQ 'USD' AND YFLD2 NE '' THEN
        FINDSTR YFLD2 IN YYS.ARR.GRP SETTING VS.POSN THEN
            YVAL1 = FIELD(YYS.ARRY<VS.POSN>,',',2)
            Y.FLD3 = YVAL1 + YFLD3
            YYS.ARRY<VS.POSN> = YFLD2:',':Y.FLD3
        END ELSE
            YYS.ARRY<-1> = YFLD2:',':YFLD3
            YYS.ARR.GRP<-1> = YFLD2
        END
    END
    IF REC.ID[1,3] EQ 'G3S' THEN
        FINDSTR YFLD4 IN YY.CCY.GRP SETTING CC1.POSN THEN
            YVAL1 = FIELD(YY.CCYG<CC1.POSN>,',',3)
            YS.FLD3 = YVAL1 + YFLD3
            YVAL2 = FIELD(YY.CCYG<CC1.POSN>,',',2)
            YY.CCYG<CC1.POSN> = YFLD4:',':YVAL2:',':YS.FLD3
        END ELSE
            YY.CCYG<-1> = YFLD4:',,':YFLD3
            YY.CCY.GRP<-1> = YFLD4
        END
        IF YFLD5 EQ LCCY AND YFLD4 EQ 'USD' THEN
            YFLD.TOTS = YFLD.TOTS + (YFLD3 * YFLD6)
            YFLD3.TOTS = YFLD3.TOTS + YFLD3
        END
    END
    RETURN

PROCESS.US.CURR.VAL:
********************
    YSEL.CNT = DCOUNT(Y.TXNSSEL.VAL.ARR,SM)
    YBUY.CNT = DCOUNT(Y.TXNSBUY.VAL.ARR,SM)
    IF YSEL.CNT < YBUY.CNT THEN
        YSEL.CNT = YBUY.CNT
    END
    YPROC.BCNT = 1; YPROC.SCNT = 1; YARR.CT = 0
    YB.CNT = 0; YS.CNT = 0; YFLG.V = 0
    LOOP
    WHILE YPROC.SCNT LE YSEL.CNT

        YTXNSEL.VAL.ARR = ''; YTXNSEL.DIS.ARR = ''; YGS.VAL = ''
        YTXNBUY.VAL.ARR = ''; YTXNBUY.DIS.ARR = ''; YGB.VAL = ''
        TSEL.POS = ''; TBUY.POS = ''
        YTXNSEL.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNSE.POS,YPROC.SCNT>
        YTXNSEL.DIS.ARR = Y.DISP.TEXT.ARR<1,TXNSE.POS,YPROC.SCNT>
        YTXNBUY.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNBY.POS,YPROC.BCNT>
        YTXNBUY.DIS.ARR = Y.DISP.TEXT.ARR<1,TXNBY.POS,YPROC.BCNT>

        GOSUB SPLIT.VARIAB.CHK
        IF YFLG.V EQ 1 THEN
            YSP.ARRY<YARR.CT> = YTXNBUY.DIS.ARR.LST:'|':YGB.VAL.LST:'|':YTXNSEL.DIS.ARR.LST:'|':YGS.VAL.LST:'|'
            YTXNBUY.DIS.ARR.LST = ''; YTXNSEL.DIS.ARR.LST = ''; YFLG.V = 0
            YPROC.SCNT++ ; YPROC.BCNT++ ; YB.CNT = 0; YS.CNT = 0
            CONTINUE
        END

        GOSUB AMBASANT.CHECK
        YPROC.SCNT++
        YPROC.BCNT++
        YB.CNT = 0; YS.CNT = 0
    REPEAT
    GOSUB FINAL.WRITE
    RETURN

SPLIT.VARIAB.CHK:
*****************
    IF YTXNBUY.VAL.ARR EQ '&&' THEN
        YTXNBUY.DIS.ARR.LST = YTXNBUY.DIS.ARR.LST:' ':YTXNBUY.DIS.ARR
        YFLG.V = 1; YB.CNT = 1
    END
    IF YTXNSEL.VAL.ARR EQ '&&' THEN
        YTXNSEL.DIS.ARR.LST = YTXNSEL.DIS.ARR.LST:' ':YTXNSEL.DIS.ARR
        YFLG.V = 1; YS.CNT = 1
    END

    BEGIN CASE
    CASE YB.CNT EQ 1 AND YS.CNT EQ 0
        YPROC.SCNT -= 1
    CASE YB.CNT EQ 0 AND YS.CNT EQ 1
        YPROC.BCNT -= 1
    END CASE
    RETURN

AMBASANT.CHECK:
***************
    IF (YTXNSEL.VAL.ARR NE '&&' AND YTXNBUY.VAL.ARR NE '&&') THEN
        IF  YTXNSEL.VAL.ARR NE '' THEN
            GOSUB TXNSEL.LOCATE
        END
        IF YTXNBUY.VAL.ARR NE '' THEN
            GOSUB TXNBUY.LOCATE
        END
        YSP.ARRY<-1> = YTXNBUY.DIS.ARR:'|':YGB.VAL:'|':YTXNSEL.DIS.ARR:'|':YGS.VAL:'|'
        YARR.CT += 1
        YTXNSEL.DIS.ARR.LST = YTXNSEL.DIS.ARR
        YTXNBUY.DIS.ARR.LST = YTXNBUY.DIS.ARR
        YGB.VAL.LST = YGB.VAL; YGS.VAL.LST = YGS.VAL
    END
    RETURN

TXNSEL.LOCATE:
*************
    LOCATE YTXNSEL.VAL.ARR IN YYS.ARR.GRP SETTING TSEL.POS THEN
        YVALS.ARR = YYS.ARRY<TSEL.POS>
        YGS.VAL = FIELD(YVALS.ARR,',',2)
    END
    RETURN

TXNBUY.LOCATE:
**************
    LOCATE YTXNBUY.VAL.ARR IN YYB.ARR.GRP SETTING TBUY.POS THEN
        YVALB.ARR = YYB.ARRY<TBUY.POS>
        YGB.VAL = FIELD(YVALB.ARR,',',2)
    END
    RETURN

FINAL.WRITE:
************
    YFXC.BUY.AVG = YFLD.TOTB / YFLD3.TOTB
    YFXC.BUY.AVG = FMT(YFXC.BUY.AVG,"L4%7")
    YFXC.SEL.AVG = YFLD.TOTS / YFLD3.TOTS
    YFXC.SEL.AVG = FMT(YFXC.SEL.AVG,"L4%7")
    YMONT.ARR.FOOT<-1> = "RD$|||COMPRA||":YFXC.BUY.AVG
    YMONT.ARR.FOOT<-1> = "US$|||VENTA||":YFXC.SEL.AVG
    YFIN.ARRY = RETURN.ARR.S:FM:YYS.CCY.GRP:FM:YSP.ARR.HEAD:FM:YSP.ARRY:FM:YMONT.ARR.FOOT
    CALL F.WRITE(FN.CHK.DIR,EXTRACT.FILE.ID,YFIN.ARRY)
    RETURN

CURR.DUMM.LOOP:
***************

    YCCYS.CNT = DCOUNT(Y.TXNSCCY.VAL.ARR,SM)
    YPROC.CNTS = 1; YARR.CTS = 0
    LOOP
    WHILE YPROC.CNTS LE YCCYS.CNT
        Y.TXNSCCY.VAL.ARR = ''; Y.TXNSCCY.DIS.ARR = ''; YCCY.FLD1 = ''
        YCCY.POS = ''; YCVM.POS = ''; YCSM.POS = ''; YCCY.FLD2 = ''; YTOT.AMT = ''
        Y.TXNSCCY.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNCCY.POS,YPROC.CNTS>
        Y.TXNSCCY.DIS.ARR = Y.DISP.TEXT.ARR<1,TXNCCY.POS,YPROC.CNTS>

        FINDSTR Y.TXNSCCY.VAL.ARR IN YY.CCY.GRP SETTING YCCY.POS,YCVM.POS,YCSM.POS THEN
            YCCY.LINE = YY.CCYG<YCCY.POS>
            YCCY.FLD2 = FIELD(YCCY.LINE,',',2)
            YCCY.FLD3 = FIELD(YCCY.LINE,',',3)
            GOSUB LAST.CCY.VAL
            YTOT.AMT = YL.FXC.TOTPOSN + YCCY.FLD2 - YCCY.FLD3
            YYS.CCY.GRP<-1> = Y.TXNSCCY.DIS.ARR:'|':YL.FXC.TOTPOSN:'|':YCCY.FLD2:'|':YCCY.FLD3:'|':YTOT.AMT
        END ELSE
            YYS.CCY.GRP<-1> = Y.TXNSCCY.DIS.ARR:'||||'
        END
        YPROC.CNTS++
    REPEAT
    RETURN

LAST.CCY.VAL:
*************
    YTN.LST.ID = Y.TXNSCCY.VAL.ARR:Y.LAST.WRK.DAY
    R.REDO.FX.CCY.POSN = ''; ERR.REDO.FX.CCY.POSN = ''
    CALL F.READ(FN.REDO.FX.CCY.POSN,CON.LST.ID,R.REDO.FX.CCY.POSN,F.REDO.FX.CCY.POSN,ERR.REDO.FX.CCY.POSN)
    YL.FX.BUY = R.REDO.FX.CCY.POSN<REDO.FX.BUY.POSITION>
    YL.FX.SEL = R.REDO.FX.CCY.POSN<REDO.FX.SELL.POSITION>
    YL.FXC.TOTPOSN = R.REDO.FX.CCY.POSN<REDO.FX.TOTAL.POSN>
    YL.TOT.L = YL.FX.BUY + YL.FX.SEL
    IF YL.FXC.TOTPOSN EQ YL.TOT.L THEN
        YL.FXC.TOTPOSN = '0'
        RETURN
    END
    YLOOP.LST.WDAY = ''; YLAST.YEAR = ''; YL.FXC.TOTPOSN = ''
    YLOOP.LST.WDAY = Y.LAST.WRK.DAY
    LOOP
    UNTIL YL.FXC.TOTPOSN NE ''
        IF LEN(YLOOP.LST.WDAY) NE 8 THEN
            RETURN
        END
        CALL CDT('',YLOOP.LST.WDAY,'-1W')
        CON.LST.ID = Y.TXNSCCY.VAL.ARR:YLOOP.LST.WDAY
        R.REDO.FX.CCY.POSN = ''; ERR.REDO.FX.CCY.POSN = ''
        CALL F.READ(FN.REDO.FX.CCY.POSN,CON.LST.ID,R.REDO.FX.CCY.POSN,F.REDO.FX.CCY.POSN,ERR.REDO.FX.CCY.POSN)
        IF R.REDO.FX.CCY.POSN THEN
            YL.FXC.TOTPOSN = R.REDO.FX.CCY.POSN<REDO.FX.TOTAL.POSN>
        END
    REPEAT
    RETURN
END
