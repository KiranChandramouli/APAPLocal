SUBROUTINE REDO.E.NOF.SEC.TRADE.SUM(DATA.ENQ)
*
******************************************************************************
*
* Subroutine Type : NOFILE ROUTINE
* Attached to     : ENQ REDO.SEC.TRADE.SUM
* Attached as     : NOFILE ROUTINE
* Primary Purpose : Extract information from SEC.TRADE
*
* Incoming:
* ---------
* Date      - One or a range of dates
* Portfolio - Portfolio to search
* Id.       - @id of the security
*
* Outgoing:
* ---------
* DATA.ENQ - data returned to the enquiry
*
*-----------------------------------------------------------------------
* Modification History:
*
* Development for : APAP  CR.38
* Development by  : Adriana Velasco - TAM Latin America
* Date            : Oct.13, 2011
*
*=======================================================================
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
*
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SEC.ACC.MASTER

*************************************************************************

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
RETURN
*
* ======
PROCESS:
* ======

*Validate the selection
    GOSUB VALIDATE.SELECTION

* Execute the search
    CALL EB.READLIST(Y.SEL.COMMAND,SEC.TRADE.LIST,LIST.NAME,SELECTED,SYS.RTN.CODE)

* Get Detail of the enquiry
    LOOP
        REMOVE Y.SEC.TRADE.ID FROM SEC.TRADE.LIST SETTING Y.POS
    WHILE Y.SEC.TRADE.ID : Y.POS
        GOSUB GET.DATA.DETAIL
    REPEAT

* Write TOTAL line
    Y.TOT.PRIMA.OUT = FMT(Y.TOT.PRIMA.OUT,"R2,#30")
    Y.TOT.DESC.OUT  = FMT(Y.TOT.DESC.OUT,"R2,#30")

    R.TOTAL<-1> = '' : @VM : '' : @VM : '' : @VM : '' : @VM : '' : @VM : '': @VM : '' : @VM : Y.TOT.PRIMA.OUT : @VM : Y.TOT.DESC.OUT

* Header's Lines
    GOSUB HEAD.PROCESS

* Populate output variable
    IF PROCESS.GOAHEAD THEN

        CHANGE @VM TO "*" IN R.HEAD.1
        CHANGE @VM TO "*" IN R.HEAD.2
        CHANGE @VM TO "*" IN R.HEAD.3
        CHANGE @VM TO "*" IN R.DETAIL
        CHANGE @VM TO "*" IN R.TOTAL

        DATA.ENQ<-1> = R.HEAD.1
        DATA.ENQ<-1> = R.HEAD.2
        DATA.ENQ<-1> = R.HEAD.3
        DATA.ENQ<-1> = R.DETAIL
        DATA.ENQ<-1> = R.TOTAL

    END

*
RETURN
*
* =================
VALIDATE.SELECTION:
* ================
    Y.SEL.COMMAND = 'SELECT ':FN.SEC.TRADE

*By Security Id even Portfolio has value
    IF (Y.PORTFOLIO NE '' AND Y.SECURITY.ID NE '') OR (Y.PORTFOLIO EQ '' AND Y.SECURITY.ID NE '') THEN
        GOSUB SELECT.BY.SECURITY
    END
*By Portfolio
    IF Y.PORTFOLIO NE '' AND Y.SECURITY.ID EQ '' THEN
        GOSUB SELECT.BY.PORTFOLIO
    END
*Search all
    IF Y.PORTFOLIO EQ '' AND Y.SECURITY.ID EQ ' ' THEN
        GOSUB SELECT.ALL
    END

RETURN
* =================
SELECT.BY.SECURITY:
* =================

    Y.SEL.COMMAND := ' WITH @ID EQ '  : Y.SECURITY.ID

RETURN

* ==================
SELECT.BY.PORTFOLIO:
* ==================

    Y.SEL.COMMAND := ' WITH CUST.SEC.ACC EQ '  : Y.PORTFOLIO

RETURN

* =========
SELECT.ALL:
* =========
    Y.SEL.COMMAND := ' '

RETURN

* =============
READ.SEC.TRADE:
* =============

    CALL F.READ(FN.SEC.TRADE,Y.SEC.TRADE.ID,R.SEC.TRADE,F.SEC.TRADE,Y.ERR)
    IF NOT(R.SEC.TRADE) THEN
        Y.TEXT = "ST-REDO.SEC.TRADE.NO.FOUND"
        GOSUB GET.ERROR
    END

RETURN

* ==================
READ.SEC.ACC.MASTER:
* ==================
    CALL F.READ(FN.SEC.ACC.MASTER,Y.SECURITY.ACCOUNT,R.SEC.ACC.MASTER,F.SEC.ACC.MASTER,Y.ERR)
    IF NOT(R.SEC.ACC.MASTER) THEN
        Y.TEXT = "ST-REDO.SEC.ACC.MASTER.NO.FOUND"
        GOSUB GET.ERROR
    END
RETURN

* ===========
HEAD.PROCESS:
* ===========

    R.HEAD.1 = 'REPORTE DIARIO AMORTIZACIONES PRIMA Y DESCUENTO': @VM : '' : @VM : '' : @VM : '' : @VM : '' : @VM : '' : @VM : '' : @VM : '' : @VM : ''
    R.HEAD.2 = '' : @VM : 'AJUSTE CONTABLE': @VM :'' : @VM : '' : @VM : '' : @VM : '' : @VM : '' : @VM : '' : @VM : ''
    R.HEAD.3 = '' : @VM : '' : @VM : 'FECHA: ': TODAY : @VM :'' : @VM : '' : @VM : '' : @VM : '' : @VM : '' : @VM : ''

RETURN
*
* =============
GET.DATA.DETAIL:
* =============
*
*  Get info from SEC.TRADE
    Y.DISC.AMT        = 0
    Y.PRIMA.AMT       = 0
    Y.VALUE.DATE      = ""
    Y.MATURITY.DATE   = ""
    Y.DATE.OUT        = ""
    Y.DATE.REP        = ""
    Y.PORTFOLIO.OUT   = ""
    Y.CATEGORY.OUT    = ""
    Y.NO.CONTRATO     = ""
    Y.ACCR.AMT.X.CONTRACT = 0
    Y.PENDING.AMORT.X.CONTRACT = 0
    Y.AMORT.PRIMA.OUT = 0
    Y.AMORT.DESC.OUT  = 0

    R.SEC.TRADE = ''
    GOSUB READ.SEC.TRADE
    IF PROCESS.GOAHEAD THEN
        Y.SECURITY.ACCOUNT = R.SEC.TRADE<SC.SBS.CUST.SEC.ACC,1>
        GOSUB READ.SEC.ACC.MASTER
        IF PROCESS.GOAHEAD THEN
*Category
            Y.CATEGORY = R.SEC.ACC.MASTER<SC.SAM.CATEGORY>
            Y.NO.CONTRATO = Y.SEC.TRADE.ID
*Value date
            Y.VALUE.DATE         = R.SEC.TRADE<SC.SBS.VALUE.DATE>
*Madurity date
            Y.MATURITY.DATE      = R.SEC.TRADE<SC.SBS.MATURITY.DATE>
*Discount amount
            Y.DISC.AMT = R.SEC.TRADE<SC.SBS.LOCAL.REF,Y.DIS.AMT.POS>
            Y.DISC.AMT = TRIM(Y.DISC.AMT,' ',"B")
            Y.FACE.VALUE = R.SEC.TRADE<SC.SBS.CUST.NO.NOM>

*Portfolio
            Y.PORTFOLIO.ID = R.SEC.TRADE<SC.SBS.CUST.SEC.ACC,1>
            Y.FLAG.EXCLUDE = 'N'
            GOSUB VALIDATE.DATES
            IF Y.FLAG.EXCLUDE EQ 'N' THEN
                GOSUB SET.FROM.TO.DATE
                IF PROCESS.GOAHEAD THEN
                    GOSUB PROCESS.GET.INFO
                    Y.AMORT.PRIMA.OUT = FMT(Y.ACCR.AMT.X.CONTRACT,"R2,#30")
                    Y.AMORT.DESC.OUT  = FMT(Y.PENDING.AMORT.X.CONTRACT,"R2,#30")
                    Y.TOT.PRIMA.OUT  += Y.ACCR.AMT.X.CONTRACT
                    Y.TOT.DESC.OUT   += Y.PENDING.AMORT.X.CONTRACT
                    Y.DATE.OUT        = Y.DATE.REP

* Write DETAIL line
                    R.DETAIL<-1> = '' : @VM : '' : @VM : '' : @VM : Y.DATE.OUT : @VM : Y.PORTFOLIO.OUT : @VM : Y.CATEGORY.OUT : @VM : Y.NO.CONTRATO : @VM : Y.AMORT.PRIMA.OUT : @VM : Y.AMORT.DESC.OUT
                END
            END
        END
    END

*
RETURN
*
* ===============
PROCESS.GET.INFO:
* ===============
    Y.CATEGORY.OUT  = Y.CATEGORY
    Y.PORTFOLIO.OUT =  Y.PORTFOLIO.ID


    Y.NO.OF.DAYS       = 'C'
    IF Y.VALUE.DATE NE '' AND Y.MATURITY.DATE NE '' THEN
        CALL CDD('',Y.VALUE.DATE,Y.MATURITY.DATE,Y.NO.OF.DAYS)
    END
    Y.CNT              = "1"
    LOOP
    WHILE Y.CNT LE Y.NO.OF.DAYS

        Y.DAYS.DIV.COUP = Y.CNT/Y.NO.OF.DAYS
        Y.PD.BY.FC = 1 + (Y.DISC.AMT / Y.FACE.VALUE)
        Y.EFF.RATE = (PWR(Y.PD.BY.FC,Y.DAYS.DIV.COUP) - 1) * 100

        Y.ACCR.AMT = (Y.EFF.RATE * Y.FACE.VALUE) / 100
        Y.PENDING.AMORT = Y.DISC.AMT - Y.ACCR.AMT

        IF Y.CNT EQ 1 THEN
            Y.MARGINAL = Y.ACCR.AMT
            Y.DATE = Y.VALUE.DATE
        END ELSE
            NEXT.DATE      = '1D'
            CALL CALENDAR.DAY(Y.VALUE.DATE,'+',NEXT.DATE)
            Y.DATE = NEXT.DATE
            Y.VALUE.DATE     = NEXT.DATE
            Y.MARGINAL = Y.ACCR.AMT - Y.ACCR.AMT.LAST
        END

        IF Y.DATE GE Y.DATE.FROM.PROC AND Y.DATE LE Y.DATE.TO.PROC THEN
            Y.ACCR.AMT.X.CONTRACT = Y.ACCR.AMT
            Y.PENDING.AMORT.X.CONTRACT = Y.MARGINAL
            Y.DATE.REP = Y.DATE
        END

        Y.ACCR.AMT.LAST = Y.ACCR.AMT

        Y.CNT += 1
    REPEAT

RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD   = 1
    R.HEAD.1          = ""
    R.HEAD.2          = ""
    R.HEAD.3          = ""
    R.DETAIL          = ""
    R.TOTAL           = ""
    DATA.EACH.PLAN    = ""

    Y.TOT.PRIMA.OUT   = 0
    Y.TOT.DESC.OUT    = 0


* Get local fields from SEC.TRADE application

    Y.APPL    = "SEC.TRADE"
    Y.FLD     = "L.DISC.AMOUNT"
    Y.FLD.POS = ''

    CALL MULTI.GET.LOC.REF(Y.APPL,Y.FLD,Y.FLD.POS)
    Y.DIS.AMT.POS = Y.FLD.POS
*
RETURN
*

* =========
OPEN.FILES:
* =========
*
* SEC.TRADE Application
    FN.SEC.TRADE = "F.SEC.TRADE"
    F.SEC.TRADE = ""
    CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)

*SEC.ACC.MASTER Application
    FN.SEC.ACC.MASTER = "F.SEC.ACC.MASTER"
    F.SEC.ACC.MASTER  = ""
    CALL OPF(FN.SEC.ACC.MASTER,F.SEC.ACC.MASTER)

*
RETURN
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
* Validate Date From (Optional)
    LOCATE 'DATE.FROM' IN D.FIELDS<1> SETTING Y.POS.ID THEN
        Y.DATE.FROM = D.RANGE.AND.VALUE<Y.POS.ID>
    END ELSE
        Y.DATE.FROM = ''
    END
* Validate Date To (Optional)
    IF PROCESS.GOAHEAD THEN
        LOCATE 'DATE.TO' IN D.FIELDS<1> SETTING Y.POS.ID THEN
            Y.DATE.TO = D.RANGE.AND.VALUE<Y.POS.ID>
* If DATE.TO was inputed, it can't be greater than DATE.FROM
            IF Y.DATE.TO NE '' THEN
                IF Y.DATE.FROM GT Y.DATE.TO THEN
                    Y.TEXT = "ST-REDO.DATE.FROM.GT.DATE.TO"
                    GOSUB GET.ERROR
                END
            END
        END ELSE
            Y.DATE.TO = ''
        END
    END
* Validate the Portfolio (Optional)
    IF PROCESS.GOAHEAD THEN
        LOCATE 'PORTFOLIO' IN D.FIELDS<1> SETTING Y.POS.ID THEN
            Y.PORTFOLIO = D.RANGE.AND.VALUE<Y.POS.ID>
        END ELSE
            Y.PORTFOLIO = ''
        END
    END
* Validate the Id of security (Optional)
    IF PROCESS.GOAHEAD THEN
        LOCATE 'SECURITY.ID' IN D.FIELDS<1> SETTING Y.POS.ID THEN
            Y.SECURITY.ID = D.RANGE.AND.VALUE<Y.POS.ID>
        END ELSE
            Y.SECURITY.ID = ''
        END
    END


RETURN
*
* =============
VALIDATE.DATES:
* =============
* Validate DATE's for each record of SEC.TRADE

    IF Y.DATE.TO AND Y.DATE.TO GT Y.MATURITY.DATE THEN
        Y.FLAG.EXCLUDE = 'S'
    END

    IF Y.DATE.TO AND Y.DATE.TO LT Y.VALUE.DATE THEN
        Y.FLAG.EXCLUDE = 'S'
    END

    IF Y.DATE.FROM AND Y.DATE.FROM GT Y.MATURITY.DATE THEN
        Y.FLAG.EXCLUDE = 'S'
    END

    IF Y.DATE.FROM AND Y.DATE.FROM LT Y.VALUE.DATE THEN
        Y.FLAG.EXCLUDE = 'S'
    END

RETURN

* ===============
SET.FROM.TO.DATE:
* ===============

    BEGIN CASE

        CASE Y.DATE.FROM NE '' AND Y.DATE.TO EQ ''
            IF Y.DATE.FROM LT TODAY THEN
                Y.DATE.TO.PROC = TODAY
            END ELSE
                Y.DATE.TO.PROC = Y.MATURITY.DATE
            END

        CASE Y.DATE.FROM EQ '' AND Y.DATE.TO NE ''
            IF Y.DATE.TO LT TODAY THEN
                Y.DATE.FROM.PROC = TODAY
            END ELSE
                Y.DATE.FROM.PROC = Y.VALUE.DATE
            END

        CASE Y.DATE.FROM EQ ''  AND Y.DATE.TO EQ ''
            Y.DATE.FROM.PROC = Y.VALUE.DATE
            Y.DATE.TO.PROC = TODAY

    END CASE


RETURN

* ========
GET.ERROR:
* ========
    CALL TXT(Y.TEXT)
    ENQ.ERROR<-1> = Y.TEXT
    PROCESS.GOAHEAD = 0

RETURN
*
END
