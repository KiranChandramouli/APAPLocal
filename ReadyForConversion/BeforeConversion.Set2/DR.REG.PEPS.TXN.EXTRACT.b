*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE DR.REG.PEPS.TXN.EXTRACT(REC.ID)
*********
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
* 15-Aug-2014     V.P.Ashokkumar       PACS00396224 - Initial Release
*-----------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_TSA.COMMON
    $INSERT T24.BP I_F.DATES
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.STMT.ENTRY
    $INSERT T24.BP I_F.FUNDS.TRANSFER
    $INSERT T24.BP I_F.TELLER
    $INSERT T24.BP I_F.INDUSTRY
    $INSERT T24.BP I_F.RELATION.CUSTOMER
    $INCLUDE LAPAP.BP I_DR.REG.PEPS.TXN.EXTRACT.COMMON
    $INCLUDE TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INCLUDE REGREP.BP I_F.DR.REG.213IF01.CONCAT
*
    GOSUB PROCESS
    RETURN

PROCESS:
********
    CONCAT.ID = REC.ID
    R.DR.REG.213IF01.CONCAT = ''; DR.REG.213IF01.CONCAT.ERR = ''; YCR.DATE = ''; STMT.VAL.LST = ''; YSTMT.REL.CUST = ''
    CALL F.READ(FN.DR.REG.213IF01.CONCAT,CONCAT.ID,R.DR.REG.213IF01.CONCAT,F.DR.REG.213IF01.CONCAT,DR.REG.213IF01.CONCAT.ERR)
    STMT.VAL.LST = R.DR.REG.213IF01.CONCAT<DR.213IF01.CONCAT.PEP.STMT.ID>
    YCR.ADATE = R.DR.REG.213IF01.CONCAT<DR.213IF01.CONCAT.CR.DATE>
    LOOP
        REMOVE YSTMT.VAL FROM STMT.VAL.LST SETTING STMT.POSN
    WHILE YSTMT.VAL:STMT.POSN
        STMT.VAL = FIELD(YSTMT.VAL,'*',1)
        YSTMT.REL.CUST = FIELD(YSTMT.VAL,'*',4)
        R.STMT.ENTRY = ''; STMT.ENTRY.ERR = ''
        YCU.PEPS = ''; YSTMT.CUST = ''; TEMPR.CUSTOMER = ''
        YCU.PEPS.V = ''; YOPER.TYPE = ''; YREC.STAT = ''; TEMPR.YSTMT.CUST = ''
        CALL F.READ(FN.STMT.ENTRY,STMT.VAL,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENTRY.ERR)
        IF NOT(R.STMT.ENTRY) THEN
            RETURN
        END
        YSTMT.CUST = R.STMT.ENTRY<AC.STE.CUSTOMER.ID>
        IF NOT(YSTMT.CUST) THEN
            YSTMT.CUST = FIELD(CONCAT.ID,'-',1)
        END
        GOSUB READ.CUSTOMER
        TEMPR.YSTMT.CUST = YSTMT.CUST
        TEMPR.CUSTOMER = R.CUSTOMER
        YCU.PEPS = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.PEPS.POS>
        YCU.PEPS.V = YCU.PEPS
        GOSUB MAIN.PROCESS
    REPEAT
    RETURN

MAIN.PROCESS:
*************
    GOSUB PEPS.SI.INIT
    IF YCU.PEPS NE 'SI' THEN
        RETURN
    END

    TXN.REF = R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
    ACCT.TYPE = R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
    YSTMT.CUST = R.STMT.ENTRY<AC.STE.CUSTOMER.ID>
    YCCY = R.STMT.ENTRY<AC.STE.CURRENCY>
    YSYS.ID = R.STMT.ENTRY<AC.STE.SYSTEM.ID>

    GOSUB FT.TT.PROCESS
    IF (NOT(R.TELLER) OR NOT(R.FUNDS.TRANSFER)) AND YREC.STAT EQ 'REVE' THEN
        RETURN
    END
    IF NOT(YOPER.TYPE) THEN
        RETURN
    END
    GOSUB GET.CUSTOMER.VALUES
    GOSUB GET.INTER.OPER
    YCUST.NME = ''; YFAM.NAME = ''
    GOSUB L.CU.TIPO.CL.FIELD
    GOSUB GEND.PEP.CHK
    GOSUB CU.PEPS.CHK
    GOSUB ARRY.FORMAT
    GOSUB WRITE.ARRY
    RETURN

WRITE.ARRY:
***********
    REP.LINE = OUT.ARR<1>:OUT.ARR<2>:YCUST.NME:YFAM.NAME:INT.NATION:YREL.TYPE:PEP.NME:PEP.POS:PEP.INSTIT:COUNT.CDE:YOPER.TYPE:YCCY
*    REP.LINE = INTER.OPER:",":IDEN.CUST:",":YCUST.NME:",":YFAM.NAME:",":INT.NATION:",":YREL.TYPE:",":PEP.NME:",":PEP.POS:",":PEP.INSTIT:",":COUNT.CDE:",":YOPER.TYPE:",":YCCY
    LAST.WRK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    STMT.VALID = ''; STMT.VALID = STMT.VAL:"-":TEMPR.YSTMT.CUST:"~":YOPER.TYPE
    IF (LAST.WRK.DATE[5,2] EQ '06' OR LAST.WRK.DATE[5,2] EQ '12') THEN
        GOSUB HALF.MTH.RPT
    END ELSE
        CALL F.WRITE(FN.DR.REG.PEPS.WORKFILE, STMT.VALID, REP.LINE)
    END
    RETURN

HALF.MTH.RPT:
*************
    IF (YCR.ADATE GE YST.DATE AND YCR.ADATE LE YED.DATE) THEN
        STMT.VAL = 'HF':STMT.VALID
        CALL F.WRITE(FN.DR.REG.PEPS.WORKFILE, STMT.VAL, REP.LINE)
    END ELSE
        CALL F.WRITE(FN.DR.REG.PEPS.WORKFILE, STMT.VALID, REP.LINE)
    END
    RETURN

ARRY.FORMAT:
************
    INTER.OPER = FMT(OUT.ARR<1>,"L#2")
    IDEN.CUST = FMT(OUT.ARR<2>,"L#15")
    YCUST.NME = FMT(YCUST.NME,"L#60")
    YFAM.NAME = FMT(YFAM.NAME,"L#60")
    INT.NATION = FMT(INT.NATION,"L#2")
    YREL.TYPE = FMT(YREL.TYPE,"R%2")
    PEP.NME = FMT(PEP.NME,"L#60")
    PEP.POS = FMT(PEP.POS,"L#60")
    PEP.INSTIT = FMT(PEP.INSTIT,"L#60")
    COUNT.CDE = FMT(COUNT.CDE,"L#2")
    YOPER.TYPE = FMT(YOPER.TYPE,"R%2")
    YCCY = FMT(YCCY,"L#3")
    RETURN

L.CU.TIPO.CL.FIELD:
*******************
    IF L.CU.TIPO.CL.VAL EQ "PERSONA FISICA" OR L.CU.TIPO.CL.VAL EQ "CLIENTE MENOR" THEN
        YCUST.NME = YGIV.NME
        YFAM.NAME = YFAM.NME
    END
    IF L.CU.TIPO.CL.VAL EQ "PERSONA JURIDICA" THEN
        YCUST.NME = Y.NAME.1:' ':Y.NAME.2
        YFAM.NAME = Y.SHORT.NAME
    END
    RETURN

FT.TT.PROCESS:
**************
    BEGIN CASE
    CASE YSYS.ID EQ 'FT'
        FT.ID = TXN.REF
        YREC.STAT = ''
        GOSUB READ.HIST.FT
        YREC.STAT = R.FUNDS.TRANSFER<FT.RECORD.STATUS>
        FT.TXN.TYPE = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
        GOSUB FT.TXN.CHK
    CASE YSYS.ID EQ 'TT'
        TXN.REF = FIELD(TXN.REF,'\',1)
        GOSUB READ.HIST.TELLER
        GOSUB READ.TELLER
        YREC.STAT = R.TELLER<TT.TE.RECORD.STATUS>
        TT.TXN.CDE = R.TELLER<TT.TE.TRANSACTION.CODE>
        GOSUB TT.TXN.CHK
    END CASE
    RETURN

READ.HIST.TELLER:
*****************
    TT.ERR = ''; R.TELLER = ''; ERRH.TT = ''
    CALL EB.READ.HISTORY.REC(F.TT.HIS,TXN.REF,R.TELLER,ERRH.TT)
    RETURN

READ.HIST.FT:
*************
    R.FUNDS.TRANSFER = ''; FT.ERR = ''
    CALL EB.READ.HISTORY.REC(F.FT.HIS,TXN.REF,R.FUNDS.TRANSFER,ERRH.FT)
    RETURN

READ.TELLER:
************
    IF NOT(R.TELLER) THEN
        CALL F.READ(FN.TELLER,TXN.REF,R.TELLER,F.TELLER,TT.ERR)
    END
    RETURN

FT.TXN.CHK:
***********
*    YOPER.TYPE = FT.TXN.TYPE
    LOCATE FT.TXN.TYPE IN Y.TXNTYE.VAL.ARR<1,1> SETTING TXNTE.POS THEN
        YOPER.TYPE = Y.TXNTYE.DIS.ARR<1,TXNTE.POS>
    END
    RETURN

TT.TXN.CHK:
***********
*    YOPER.TYPE = TT.TXN.CDE
    LOCATE TT.TXN.CDE IN Y.TXNCDE.VAL.ARR<1,1> SETTING TXNCE.POS THEN
        YOPER.TYPE = Y.TXNCDE.DIS.ARR<1,TXNCE.POS>
    END
    RETURN

CU.PEPS.CHK:
***********
    BEGIN CASE
    CASE YCU.PEPS.V EQ 'NO'
        PEP.NME = YP.GIV.NME:' ':YP.FAM.NME
        PEP.POS = LP.CU.POS.COMP.VAL
        PEP.INSTIT = YP.EMP.NME
        COUNT.CDE = YP.RESID
    CASE YCU.PEPS.V EQ 'SI'
        PEP.NME = ''
        PEP.POS = L.CU.POS.COMP.VAL
        PEP.INSTIT = YEMP.NME
        COUNT.CDE = YRESID
    END CASE
    RETURN

PEPS.SI.INIT:
*************
    GOSUB READ.RELATION.CUSTOMER
    BEGIN CASE
    CASE YCU.PEPS EQ 'SI'
        GOSUB GET.PEP.CUST.VAL
    CASE YCU.PEPS EQ 'NO' AND R.RELATION.CUSTOMER NE ''
        GOSUB NOT.SI.REL.CHK
    END CASE
    IF YCU.PEPS NE 'SI' AND YSTMT.REL.CUST NE '' THEN
        YSTMT.CUST = YSTMT.REL.CUST
        GOSUB READ.RELATION.CUSTOMER
        GOSUB NOT.SI.REL.CHK
    END
    RETURN

NOT.SI.REL.CHK:
***************
    REL.CNT = DCOUNT(R.RELATION.CUSTOMER<EB.RCU.IS.RELATION>,VM)
    YSICNT = 0
    LOOP
    UNTIL YSICNT EQ REL.CNT
        YSICNT++
        YOR.RELAT.CODE = ''; YSTMT.CUST = ''
        YSTMT.CUST = R.RELATION.CUSTOMER<EB.RCU.OF.CUSTOMER,YSICNT>
        YOR.RELAT.CODE = R.RELATION.CUSTOMER<EB.RCU.IS.RELATION,YSICNT>
        GOSUB READ.CUSTOMER
        YCU.PEPS = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.PEPS.POS>
        GOSUB NOT.PEP.CHK
    REPEAT
    RETURN

NOT.PEP.CHK:
************
    IF YCU.PEPS EQ 'SI' AND YOR.RELAT.CODE MATCHES Y.REL.VAL.ARR1 THEN
        YREL.CODE = YOR.RELAT.CODE
        GOSUB GET.PEP.CUST.VAL
        YSICNT = REL.CNT
    END
    RETURN

GET.PEP.CUST.VAL:
*****************
    GOSUB GET.PEP.CUST.INIT
    YP.RESID = R.CUSTOMER<EB.CUS.RESIDENCE>
    YP.GEND = R.CUSTOMER<EB.CUS.GENDER>
    YP.GIV.NME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
    YP.FAM.NME = R.CUSTOMER<EB.CUS.FAMILY.NAME>
    YP.EMP.NME = R.CUSTOMER<EB.CUS.EMPLOYERS.NAME>
    LP.CU.TIPO.CL.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>
    LP.CU.CIDENT.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
    LP.CU.POS.COMP.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.POS.COMP.POS>
    RETURN

GET.PEP.CUST.INIT:
******************
    YP.RESID = ''; YP.GIV.NME = '';YP.FAM.NME = ''
    YP.EMP.NME = ''; LP.CU.TIPO.CL.VAL = ''; YP.GEND = ''
    LP.CU.POS.COMP.VAL = ''; LP.CU.CIDENT.VAL = ''
    RETURN

GET.INTER.OPER:
***************
    OUT.ARR = ''
    CALL DR.REG.GET.CUST.TYPE(R.CUSTOMER,OUT.ARR)
    RETURN

***********************
READ.RELATION.CUSTOMER:
***********************
* In this para of the program, file RELATION.CUSTOMER is read
    R.RELATION.CUSTOMER  = '';    RELATION.CUSTOMER.ER = ''
    CALL F.READ(FN.RELATION.CUSTOMER,YSTMT.CUST,R.RELATION.CUSTOMER,F.RELATION.CUSTOMER,RELATION.CUSTOMER.ER)
    RETURN

GEND.PEP.CHK:
*************
    YREL.TYPE = ''
    IF YCU.PEPS.V EQ 'SI' THEN
        YREL.CODE = ''
        RETURN
    END

    BEGIN CASE
    CASE YREL.CODE EQ '1' AND YP.GEND EQ 'MALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '01'
    CASE YREL.CODE EQ '1' AND YP.GEND EQ 'FEMALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '02'
    CASE YREL.CODE EQ '2' AND YP.GEND EQ 'MALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '03'
    CASE YREL.CODE EQ '2' AND YP.GEND EQ 'FEMALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '04'
    CASE YREL.CODE EQ '3' AND YP.GEND EQ 'MALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '05'
    CASE YREL.CODE EQ '3' AND YP.GEND EQ 'FEMALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '06'
    CASE (YREL.CODE EQ '4' OR YREL.CODE EQ '5') AND YP.GEND EQ 'MALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '07'
    CASE (YREL.CODE EQ '4' OR YREL.CODE EQ '5') AND YP.GEND EQ 'FEMALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '08'
    CASE YREL.CODE EQ '6' AND YP.GEND EQ 'MALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '09'
    CASE YREL.CODE EQ '6' AND YP.GEND EQ 'FEMALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '10'
    CASE YREL.CODE EQ '7' OR YREL.CODE EQ '8'
        YREL.TYPE = '11'
    CASE YREL.CODE EQ '9' AND YP.GEND EQ 'MALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '12'
    CASE YREL.CODE EQ '9' AND YP.GEND EQ 'FEMALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '13'
    CASE YREL.CODE EQ '10' AND YP.GEND EQ 'MALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '14'
    CASE YREL.CODE EQ '10' AND YP.GEND EQ 'FEMALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '15'
    CASE YREL.CODE EQ '12' AND YP.GEND EQ 'MALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '16'
    CASE YREL.CODE EQ '12' AND YP.GEND EQ 'FEMALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '17'
    CASE YREL.CODE EQ '11' AND YP.GEND EQ 'MALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '18'
    CASE YREL.CODE EQ '11' AND YP.GEND EQ 'FEMALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '19'
    CASE (YREL.CODE EQ '15' OR YREL.CODE EQ '16') AND YP.GEND EQ 'MALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '20'
    CASE (YREL.CODE EQ '15' OR YREL.CODE EQ '16') AND YP.GEND EQ 'FEMALE' AND YCU.PEPS EQ 'SI'
        YREL.TYPE = '21'
    CASE 1
        YREL.TYPE = ''
    END CASE
    RETURN

READ.CUSTOMER:
**************
    CUS.ERR = ''; R.CUST = ''; YREL.CUSTOMER = ''
    CALL F.READ(FN.CUSTOMER,YSTMT.CUST,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    YREL.CUSTOMER = R.CUSTOMER<EB.CUS.REL.CUSTOMER>
    RETURN

GET.CUSTOMER.VALUES:
********************
    GOSUB GET.CUSTOMER.INIT
    R.CUSTOMER = TEMPR.CUSTOMER
    INT.NATION = R.CUSTOMER<EB.CUS.NATIONALITY>
    YGEND = R.CUSTOMER<EB.CUS.GENDER>
    YLEGAL.VAL = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    YRESID = R.CUSTOMER<EB.CUS.RESIDENCE>
    YGIV.NME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
    YFAM.NME = R.CUSTOMER<EB.CUS.FAMILY.NAME>
    YEMP.NME = R.CUSTOMER<EB.CUS.EMPLOYERS.NAME>
    Y.NAME.1 = R.CUSTOMER<EB.CUS.NAME.1,LNGG>
    Y.NAME.2 = R.CUSTOMER<EB.CUS.NAME.2,LNGG>
    IF NOT(Y.NAME.1) THEN
        Y.NAME.1 = R.CUSTOMER<EB.CUS.NAME.1,1>
    END
    IF NOT(Y.NAME.2) THEN
        Y.NAME.2 = R.CUSTOMER<EB.CUS.NAME.2,1>
    END
    Y.SHORT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
    L.CU.TIPO.CL.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>
    L.CU.CIDENT.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
    L.CU.RNC.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
    L.CU.POS.COMP.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.POS.COMP.POS>
    L.CU.APAP.INDUST.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.APAP.INDUSTRY.POS>
    L.CU.ACTANAC.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.ACTANAC.POS>
    L.CU.NOUNICO.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.NOUNICO.POS>
    RETURN

GET.CUSTOMER.INIT:
******************
    INT.NATION = ''; YRESID = ''; YGEND = ''; Y.NAME.1 = ''; Y.NAME.2 = ''
    YLEGAL.VAL = '';YGIV.NME = ''; YFAM.NME = ''; Y.SHORT.NAME = ''
    YEMP.NME = ''; L.CU.APAP.INDUST.VAL = ''; L.CU.RNC.VAL = ''
    L.CU.TIPO.CL.VAL = '';L.CU.CIDENT.VAL = ''; L.CU.NOUNICO.VAL = ''
    L.CU.POS.COMP.VAL = ''; I.L.AA.CATEG.VAL = ''; L.CU.ACTANAC.VAL = ''
    RETURN
END