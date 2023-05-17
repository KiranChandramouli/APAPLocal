SUBROUTINE REDO.AZ.AC.FD.PREC.INP
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AZ.AC.FD.PREC.INP
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a INPUT ROUTINE attached to the version AZ.ACCOUNT,FD.PRECLOSE
*                    It is to generate override and discount the peanlty amount from interest of DEPOSIT
*In Parameter      :
*Out Parameter     :
*Files  Used       : AZ.ACCOUNT               As             I/O          Mode
*                    REDO.AZ.DISCOUNT.RATE
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
* Date            Who                 Reference               Description
* ------          ------              -------------           -------------
* 15/06/2010      REKHA S             ODR-2009-10-0336 N.18   Initial Creation
* 11 MAR 2011     H GANESH            PACS00032973  - N.18    Modified as per issue
* 04-AUG-2011     JEEVA T             PACS00032973 -N.18      Modified as per issue
* 21-DEC-2011     Sudharsanan S       PACS00164582 - N.18     Modified
* 02-04-2013      Arundev             PACS00263478            4466 Cadena 180 (Issues Criticos)
* 19/06/2013      Vignesh Kumaar R    PACS00296987            Reduce Tax amount in cancelation amount
*
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.OVERRIDE
    $INSERT I_F.ACCOUNT
    $INSERT I_GTS.COMMON
    $INSERT I_F.AZ.SCHEDULES
    $INSERT I_System
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.ACCR.ACCT.CR
    $INSERT I_AZ.ACCOUNT.COMMON
    $INSERT I_F.STMT.ACCT.CR

    IF V$FUNCTION NE 'I' THEN
        RETURN
    END

    IF OFS$OPERATION EQ 'PROCESS' THEN
        GOSUB INIT
        GOSUB SUPPRESS.OVRIDE
        GOSUB MAIN.PROCESS
    END


RETURN
*--------------------------------------------------------------------------------------------------------
INIT:
*****
    TEXT =''
    YCURR.NO = ''

    FN.ACCR.ACCT.CR = 'F.ACCR.ACCT.CR'
    F.ACCR.ACCT.CR = ''
    CALL OPF(FN.ACCR.ACCT.CR, F.ACCR.ACCT.CR)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.OVERRIDE = 'F.OVERRIDE'
    F.OVERRIDE  = ''
    CALL OPF(FN.OVERRIDE,F.OVERRIDE)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AZ.SCHEDULES = 'F.AZ.SCHEDULES'
    F.AZ.SCHEDULES = ''
    CALL OPF(FN.AZ.SCHEDULES,F.AZ.SCHEDULES)

    FN.APP = 'F.AZ.PRODUCT.PARAMETER'
    F.APP = ''
    CALL OPF(FN.APP,F.APP)

    FN.STMT.ACCT.CR = 'FBNK.STMT.ACCT.CR'
    F.STMT.ACCT.CR=''
    CALL OPF(FN.STMT.ACCT.CR,F.STMT.ACCT.CR)

    Y.LOC.REF.APPLN = 'TELLER':@FM:'AZ.ACCOUNT':@FM:'ACCOUNT'
    Y.LOC.REF.FIELDS = 'L.TT.DEP.AMT':@FM:'L.AZ.GRACE.DAYS':@VM:'L.AZ.PENAL.AMT':@VM:'L.TYPE.INT.PAY':@VM:'L.AZ.PENAL.PER':@VM:'L.AZ.IN.TRANSIT':@FM:'L.AC.AV.BAL'
    Y.LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(Y.LOC.REF.APPLN,Y.LOC.REF.FIELDS,Y.LOC.REF.POS)
    LOC.L.TT.DEP.AMT    = Y.LOC.REF.POS<1,1>
    POS.L.AZ.GRACE.DAYS = Y.LOC.REF.POS<2,1>
    LOC.AZ.PEN.AMT      = Y.LOC.REF.POS<2,2>
    POS.L.TYPE.INT.PAY  = Y.LOC.REF.POS<2,3>
    POS.L.AZ.PENAL.PER  = Y.LOC.REF.POS<2,4>
    POS.L.AZ.IN.TRANSIT = Y.LOC.REF.POS<2,5>
    POS.L.AC.AV.BAL     = Y.LOC.REF.POS<3,1>

RETURN
*-----------------------------------------------------------------------
SUPPRESS.OVRIDE:
*-----------------------------------------------------------------------

    Y.STORED.OVERRIDES = R.NEW(AZ.OVERRIDE)

    IF OFS.VAL.ONLY NE 1 THEN
        FINDSTR 'AZ.TOT.AMT.DUE' IN Y.STORED.OVERRIDES SETTING POS.FM,POS.VM THEN
            DEL R.NEW(AZ.OVERRIDE)<POS.FM,POS.VM>
            OFS$OVERRIDES<2,POS.VM> = "YES"
        END

        FINDSTR 'AZ.PRECLOSE.AMT.DUE' IN Y.STORED.OVERRIDES SETTING POS.FM.NEW,POS.VM.NEW THEN
            DEL R.NEW(AZ.OVERRIDE)<POS.FM.NEW,POS.VM.NEW>
            OFS$OVERRIDES<2,POS.VM.NEW> = "YES"
        END
*PACS00164582 - S
        FINDSTR 'AZ.AC.REP' IN Y.STORED.OVERRIDES SETTING POS.FM.REP,POS.VM.REP THEN
            DEL R.NEW(AZ.OVERRIDE)<POS.FM.REP,POS.VM.REP>
            OFS$OVERRIDES<2,POS.VM.REP> = "YES"
        END
*PACS00164582 - E
    END

RETURN
*---------------------------------------------------------------------------------------------------------
MAIN.PROCESS:
*************
    Y.OVERRIDE.COND='NO'
    IF APPLICATION EQ 'TELLER' THEN
        Y.AZ.ID=R.NEW(TT.TE.ACCOUNT.1)
        CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,Y.AZ.ERR)

        IF R.NEW(TT.TE.AMOUNT.LOCAL.1) GT R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.DEP.AMT> THEN
            ETEXT = "TT-AMT.CHECK"
            CALL STORE.END.ERROR
        END
        Y.ROLLOVER.DATE=R.AZ.ACCOUNT<AZ.ROLLOVER.DATE>
        IF Y.ROLLOVER.DATE NE '' THEN
            Y.NO.OF.GRC.DAYS=R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.L.AZ.GRACE.DAYS>
            Y.NO.OF.GRC.DAYS='+':Y.NO.OF.GRC.DAYS:'W'
            Y.GRACE.END.DATE=Y.ROLLOVER.DATE
            CALL CDT('',Y.GRACE.END.DATE,Y.NO.OF.GRC.DAYS)
            IF TODAY GE Y.ROLLOVER.DATE AND TODAY LE Y.GRACE.END.DATE THEN
                Y.OVERRIDE.COND='NO'
            END ELSE
                Y.OVERRIDE.COND='YES'
            END
        END ELSE
            Y.OVERRIDE.COND='YES'
        END
        IF Y.OVERRIDE.COND EQ 'YES' THEN
            TEXT='AZ-DEP.PRECLOSE'
            YCURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM)+1
            CALL STORE.OVERRIDE(YCURR.NO)
        END

    END
    IF APPLICATION EQ 'AZ.ACCOUNT' THEN
        Y.ROLLOVER.DATE=R.NEW(AZ.ROLLOVER.DATE)
        IF Y.ROLLOVER.DATE NE '' THEN
            Y.NO.OF.GRC.DAYS=R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.GRACE.DAYS>
            Y.NO.OF.GRC.DAYS='+':Y.NO.OF.GRC.DAYS:'W'
            Y.GRACE.END.DATE=Y.ROLLOVER.DATE
            CALL CDT('',Y.GRACE.END.DATE,Y.NO.OF.GRC.DAYS)
            IF TODAY GE Y.ROLLOVER.DATE AND TODAY LE Y.GRACE.END.DATE THEN
                Y.OVERRIDE.COND='NO'
            END ELSE
                Y.OVERRIDE.COND='YES'
            END
        END ELSE
            Y.OVERRIDE.COND='YES'
        END

        IF Y.OVERRIDE.COND EQ 'YES' THEN
            TEXT='AZ-DEP.PRECLOSE'
            YCURR.NO = DCOUNT(R.NEW(AZ.OVERRIDE),@VM)+1
            CALL STORE.OVERRIDE(YCURR.NO)
        END
        Y.INTRANSIT=R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.IN.TRANSIT>
        IF Y.INTRANSIT EQ 'YES' THEN
            TEXT = "AZ.IN.TRANSIT"
            CURR.NO = DCOUNT(R.NEW(AZ.OVERRIDE),@VM)+1
            CALL STORE.OVERRIDE(CURR.NO)
        END
        GOSUB GET.TOTAL.DUE

    END

RETURN
*------------------------------------------------------------
GET.TOTAL.DUE:
*------------------------------------------------------------
*Getting the Overdue Amount

    CALL F.READ(FN.ACCOUNT,ID.NEW,R.INT.ACCOUNT,F.ACCOUNT,ACCT.ERR)

**    IF R.NEW(AZ.SCHEDULES) EQ 'Y' THEN
**        GOSUB GET.INTEREST.AMOUNT
**       CALL F.READ(FN.AZ.SCHEDULES,ID.NEW,R.AZ.SCHEDULES,F.AZ.SCHEDULES,AZ.SCH.ERR)

* Fix for PACS00296987 [Reduce Tax amount in cancelation amount #1]

*        Y.PAID.INTEREST = SUM(R.AZ.SCHEDULES<AZ.SLS.TYPE.I>)

**       Y.GET.DATES = R.AZ.SCHEDULES<AZ.SLS.DATE>
**      Y.PAID.INTEREST = 0
**      Y.POS.CNT = 0
**      LOOP
**          REMOVE Y.DATE.VAL FROM Y.GET.DATES SETTING Y.DATE.POS
**      WHILE Y.DATE.VAL:Y.DATE.POS
**         Y.POS.CNT += 1
**         IF Y.DATE.VAL LT TODAY THEN
**            Y.PAID.INTEREST = Y.PAID.INTEREST + R.AZ.SCHEDULES<AZ.SLS.TYPE.I,Y.POS.CNT>
**        END

**    REPEAT

* End of Fix

**      Y.BAL.INTEREST = INTEREST.AMOUNT - Y.PAID.INTEREST
**  END ELSE
**     GOSUB GET.INTEREST.AMOUNT
**    Y.BAL.INTEREST = INTEREST.AMOUNT
**  END
    AMOUNT           = C$SPARE(399)
*    CALL F.READ(FN.ACCR.ACCT.CR, ID.NEW, R.ACCR.ACCT.CR, F.ACCR.ACCT.CR, Y.ACCR.ERR)
*
*    Y.BAL.INTEREST = R.ACCR.ACCT.CR<IC.ACRCR.TOTAL.INTEREST>
*
*    Y.INT.RATE = R.ACCR.ACCT.CR<IC.ACRCR.CR.INT.RATE>
*
*    Y.INTEREST.RATE = R.NEW(AZ.INTEREST.RATE)
*
*    IF Y.INT.RATE NE Y.INTEREST.RATE THEN
*
*        Y.START.DATE =   R.ACCR.ACCT.CR<IC.ACRCR.PERIOD.FIRST.DATE>
*        Y.END.DATE =     R.ACCR.ACCT.CR<IC.ACRCR.PERIOD.LAST.DATE>
*        Y.FIXED.RATE =   Y.INTEREST.RATE
*        REDEM.AMT =    R.ACCR.ACCT.CR<IC.ACRCR.CR.VAL.BALANCE,1>
*        AC.CCY =       R.ACCR.ACCT.CR<IC.ACRCR.LIQUIDITY.CCY>
*
*        INT.BASIS = 'A'
*        CALL AZ.INTEREST.CALC(Y.START.DATE,Y.END.DATE,Y.FIXED.RATE,REDEM.AMT,INT.BASIS,AZ$REGION,AC.CCY,'Y',TOTAL.RATE,INT.AMTS,RESERVED.3,RESERVED.2,RESERVED.1)
*        Y.BAL.INTEREST =  TOTAL.RATE
*
*    END
*
*    SUBJECT.AMT = Y.BAL.INTEREST
*    GOSUB CALC.TAX.AMOUNT
*    Y.TOTAL.DUE = AMOUNT + Y.TOTAL.INTEREST - Y.PEN.AMT
* Fix for PACS00296987 [Reduce Tax amount in cancelation amount #2]
*    SUBJECT.AMT = Y.TOTAL.INTEREST
*    GOSUB CALC.TAX.AMOUNT
*    Y.TOTAL.DUE = AMOUNT + Y.TOTAL.INTEREST - Y.PEN.AMT - TOT.TAX
*    Y.TOTAL.DUE = FMT(Y.TOTAL.DUE,'15R,2')
* End of Fix

    Y.PEN.AMT   = R.NEW(AZ.LOCAL.REF)<1,LOC.AZ.PEN.AMT>
    REC.ID = ID.NEW
    SEL.CMD = "SELECT ":FN.STMT.ACCT.CR:" WITH @ID LIKE ":REC.ID:"..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',Y.TOT.LIST,CUST.ERR)
    R.STMT.ACCT.CR=''
    Y.ERR=''
    CNT='1'
    ORIG.DATE=''
    LOOP
    WHILE CNT LE Y.TOT.LIST
        STMT.ID = SEL.LIST<CNT>
        REC.DATE = FIELD(STMT.ID,'-',2)
        IF CNT EQ '1' THEN
            REC.ID = STMT.ID
            ORIG.DATE = REC.DATE
        END
        IF ORIG.DATE LT REC.DATE THEN
            ORIG.DATE = REC.DATE
            REC.ID = STMT.ID
        END
        CNT += 1
    REPEAT
    CALL F.READ(FN.STMT.ACCT.CR,REC.ID,R.STMT.ACCT.CR,F.STMT.ACCT.CR,Y.ERR)
    AMOUNT = SUM(R.STMT.ACCT.CR<IC.STMCR.CR.VAL.BALANCE>)
    GRAND.TOTAL = R.STMT.ACCT.CR<IC.STMCR.GRAND.TOTAL>
    Y.BAL.INTEREST = R.STMT.ACCT.CR<IC.STMCR.TOTAL.INTEREST>
    VAR.PENAL.AMT = AMOUNT + GRAND.TOTAL - Y.PEN.AMT
    VAR.PENAL.AMT = FMT(VAR.PENAL.AMT,'15R,2')
    IF R.NEW(AZ.LOCAL.REF)<1,POS.L.TYPE.INT.PAY> EQ 'Reinvested' THEN
        Y.INT.ACCOUNT = R.NEW(AZ.INTEREST.LIQU.ACCT)
        CALL F.READ(FN.ACCOUNT,Y.INT.ACCOUNT,R.INT.ACC,F.ACCOUNT,ACC.ERR)
        Y.TOTAL.INTEREST = Y.BAL.INTEREST + R.INT.ACC<AC.LOCAL.REF,POS.L.AC.AV.BAL>
    END ELSE
        Y.TOTAL.INTEREST = Y.BAL.INTEREST         ;*PACS00263478
    END

*   TEXT = 'REDO.AZ.TOTAL.DUE':FM:VAR.PENAL.AMT
*   YCURR.NO = DCOUNT(R.NEW(AZ.OVERRIDE),VM)+1
*   CALL STORE.OVERRIDE(YCURR.NO)



    Y.BAL.INTEREST = FMT(Y.BAL.INTEREST,'15R,2')  ;*PACS00296987
    TEXT = 'REDO.AZ.UNPAID.INT':@FM:Y.BAL.INTEREST
    YCURR.NO = DCOUNT(R.NEW(AZ.OVERRIDE),@VM)+1
    CALL STORE.OVERRIDE(YCURR.NO)

    VAR.PENAL.PERCENT = System.getVariable("CURRENT.PENAL.PERCENT")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        VAR.PENAL.PERCENT = ""
    END
    Y.PENAL.PERCENT = R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.PENAL.PER>

    IF Y.PENAL.PERCENT NE VAR.PENAL.PERCENT THEN
        TEXT = 'AZ-PENALTY.RATE.CHANGE'
        YCURR.NO =  DCOUNT(R.NEW(AZ.OVERRIDE),@VM)+1
        CALL STORE.OVERRIDE(YCURR.NO)
    END
RETURN
*--------------------------------------------------------------------
GET.INTEREST.AMOUNT:
*--------------------------------------------------------------------

    CALL CACHE.READ(FN.APP,R.NEW(AZ.ALL.IN.ONE.PRODUCT),R.APP,APP.ERR)
    START.DATE       = R.NEW(AZ.VALUE.DATE)
    AZ.INT.RATE      = R.NEW(AZ.INTEREST.RATE)
    END.DATE = TODAY


    AMOUNT           = C$SPARE(399)
    UNROUND.INT.AMT  = ''
    ACCR.DAYS        = 0
    INT.BASIS        = R.APP<AZ.APP.INT.BASIS>[1,1]
    INTEREST.AMOUNT  = ''
    CURRENCY         = R.NEW(AZ.CURRENCY)
    ROUND.TYPE       = ''
    CALL EB.INTEREST.CALC(START.DATE, END.DATE,AZ.INT.RATE,AMOUNT,UNROUND.INT.AMT,ACCR.DAYS,INT.BASIS,CURRENCY,INTEREST.AMOUNT,ROUND.TYPE,'')

RETURN

*----------------------------------------------------------------------------------------------------------------------
CALC.TAX.AMOUNT:
*----------------------------------------------------------------------------------------------------------------------

    TAX.CUST = R.NEW(AZ.CUSTOMER)
    TAX.CCY = R.NEW(AZ.CURRENCY)
    TAX.KEY = R.NEW(AZ.TAX.KEY)
    TOT.TAX = ''
    TAX.ACCT = ''
    TAX.RATE = ''

    CALL AZ.TAX.CALC(TAX.CUST,SUBJECT.AMT,TAX.CCY,TAX.KEY,TOT.TAX,TAX.ACCT,TAX.RATE)

RETURN
*----------------------------------------------------------------------------------------
END
