SUBROUTINE REDO.AZ.AC.PREC.REC.ROLL.OVER
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AZ.AC.PREC.REC.ROLL.OVER
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a CHECK RECORD ROUTINE attached to version AZ.ACCOUNT,FD.PRECLOSE
*                    It is used to calculate the preclosure deposit days.It is done
*                    by checking if deposit has roll over then number of days between ROLL OVER DATE and
*                    SYSTEM DATE is calculated otherwise number of days between DEPOSIT START DATE and SYSTEM
*                    DATE is calculated
*In Parameter      :
*Out Parameter     :
*Files  Used       : AZ.ACCOUNT               As             I/O          Mode
*
*----------------------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
* Date          Who               Reference               Description
* ------        ------            -------------           -------------
* 14/06/2010    REKHA S           ODR-2009-10-0336 N.18   Initial Creation
* 11 MAR 2011   H GANESH          PACS00032973 - N.18     Modified as per issue
* 13/09/2013    Vignesh Kumaar R  PACS00296987            Reduce Tax amount in cancelation amount
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_System
    $INSERT I_F.REDO.AZ.FUND.PARAM
    $INSERT I_F.REDO.AZ.DISCOUNT.RATE
    $INSERT I_F.AZ.PRODUCT.PARAMETER

    GOSUB INIT
    IF Y.FUNCTION NE 'S' THEN
        GOSUB MAIN.PROCESS
    END

RETURN
*--------------------------------------------------------------------------------------------------------
INIT:
*****
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.REDO.AZ.DISCOUNT.RATE = 'F.REDO.AZ.DISCOUNT.RATE'
    F.REDO.AZ.DISCOUNT.RATE = ''
    CALL OPF( FN.REDO.AZ.DISCOUNT.RATE,F.REDO.AZ.DISCOUNT.RATE)

    FN.REDO.AZ.FUND.PARM = 'F.REDO.AZ.FUND.PARAM'

    VAR.ID = 'SYSTEM'

    CALL CACHE.READ(FN.REDO.AZ.FUND.PARM,VAR.ID,R.FUND.PARAM,FUND.ERR)

    FN.AZ.PRODUCT.PARAMETER = 'F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAMETER = ''

    Y.CATEGORY=R.NEW(AZ.ALL.IN.ONE.PRODUCT)
    CALL OPF(FN.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER)

    CALL F.READ(FN.AZ.PRODUCT.PARAMETER,Y.CATEGORY,R.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER,Y.AZ.ERR)
    INT.DAY.BASIS = R.AZ.PRODUCT.PARAMETER<AZ.APP.INT.BASIS>


    ROLLOVER.DATE = ''
    Y.PREC.DEP.DAYS = ''
    YDATE = ''
    YDATE2 = ''
    Y.VALUE = '0'
    Y.FUNCTION = V$FUNCTION

RETURN
*--------------------------------------------------------------------------------------------------------
MAIN.PROCESS:
*************

    GOSUB GET.LOCAL.FLD.POS
    VAR.CURRENCY =  R.NEW(AZ.CURRENCY)
    IF R.NEW(AZ.NOMINATED.ACCOUNT) EQ '' THEN
        IF PGM.VERSION NE ',NOR.TELLER.PRECLOSURE' THEN
            R.NEW(AZ.NOMINATED.ACCOUNT)=R.NEW(AZ.INTEREST.LIQU.ACCT)
        END ELSE
            CCY.PARAM = R.FUND.PARAM<REDO.FUND.CURRENCY>
            CHANGE @VM TO @FM IN CCY.PARAM
            LOCATE VAR.CURRENCY IN CCY.PARAM SETTING CCY.POS THEN
                VAR.ACCT.NUM = R.FUND.PARAM<REDO.FUND.ACCT.NUMBER,CCY.POS>
                R.NEW(AZ.NOMINATED.ACCOUNT) = VAR.ACCT.NUM
            END
        END
    END
    ROLLOVER.DATE = R.NEW(AZ.ROLLOVER.DATE)
    IF ROLLOVER.DATE THEN
        YDATE = ROLLOVER.DATE
        YDATE2 = TODAY


        CALL BD.CALC.DAYS(YDATE,YDATE2, INT.DAY.BASIS , ACCR.DAYS)

        Y.PREC.DEP.DAYS=ACCR.DAYS
        R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PR.DEP.DAY> = Y.PREC.DEP.DAYS
        GOSUB CHECK.FOR.PENALTY   ;* This Para checks whether to calculate penalty or not
    END  ELSE
        YDATE = R.NEW(AZ.VALUE.DATE)
        YDATE2 = TODAY

        CALL BD.CALC.DAYS(YDATE,YDATE2, INT.DAY.BASIS , ACCR.DAYS)

        Y.PREC.DEP.DAYS=ACCR.DAYS

        R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PR.DEP.DAY> = Y.PREC.DEP.DAYS
        GOSUB BEF.ROLLOVER
    END
    Y.PENAL.PERCENT = R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PENAL.PER>
    CALL System.setVariable('CURRENT.PENAL.PERCENT',Y.PENAL.PERCENT)
RETURN
********************
BEF.ROLLOVER:
********************
* This part raises a penalty for preclosure before maturity(Deposit Not Rolled Over)

    CATEGORY = R.NEW(AZ.CATEGORY)
    CALL F.READ(FN.REDO.AZ.DISCOUNT.RATE,CATEGORY,R.REDO.AZ.DISCOUNT.RATE,F.REDO.AZ.DISCOUNT.RATE,Y.AZ.DIS.ERR)
    IF R.REDO.AZ.DISCOUNT.RATE THEN
        GOSUB GET.PENAL.RATE
    END ELSE
        R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PENAL.PER> = '0.00'
        CALL REDO.AZ.PENAL.AMT.CALC(Y.VALUE,Y.PREC.DEP.DAYS,PEN.AMT)
        R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PENAL.AMT> = PEN.AMT
        RETURN
    END

RETURN
********************
GET.PENAL.RATE:
********************

    Y.DATE.RANGE =R.REDO.AZ.DISCOUNT.RATE<REDO.DIS.RATE.DATE.RANGE>
    Y.DATE.RNG.CNT=DCOUNT(Y.DATE.RANGE,@VM)
    Y.VAR1=1
    Y.START.DATE=FIELD(Y.DATE.RANGE<1,Y.VAR1>,'-',1)
    IF Y.PREC.DEP.DAYS LT Y.START.DATE THEN         ;* If suppose preclosure happens before the pre-defined days in REDO.AZ.DISCOUNT.RATE.(i.e if DATE.RANGE begins from 30 days and preclosure happens with that days)
        R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PENAL.PER> = '0.00'
        CALL REDO.AZ.PENAL.AMT.CALC(Y.VALUE,Y.PREC.DEP.DAYS,PEN.AMT)
        R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PENAL.AMT> = PEN.AMT
        RETURN
    END
    LOOP
    WHILE Y.VAR1 LE Y.DATE.RNG.CNT
        Y.START.DATE=FIELD(Y.DATE.RANGE<1,Y.VAR1>,'-',1)
        Y.END.DATE=FIELD(Y.DATE.RANGE<1,Y.VAR1>,'-',2)
        IF Y.VAR1 EQ Y.DATE.RNG.CNT THEN    ;* This is for Default Case at last multivalue of table REDO.AZ.DISCOUNT.RATE
            Y.PENAL.PER=R.REDO.AZ.DISCOUNT.RATE<REDO.DIS.RATE.PENAL.PERCENT,Y.VAR1>
        END
        IF Y.PREC.DEP.DAYS GE Y.START.DATE AND Y.PREC.DEP.DAYS LE Y.END.DATE THEN
            Y.PENAL.PER=R.REDO.AZ.DISCOUNT.RATE<REDO.DIS.RATE.PENAL.PERCENT,Y.VAR1>
            Y.VAR1=Y.DATE.RNG.CNT + 1
        END
        Y.VAR1 += 1
    REPEAT

    R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PENAL.PER> = Y.PENAL.PER
    CALL REDO.AZ.PENAL.AMT.CALC(Y.PENAL.PER,Y.PREC.DEP.DAYS,PEN.AMT)
    R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PENAL.AMT> = PEN.AMT

RETURN
*******************
CHECK.FOR.PENALTY:
*******************
    Y.NO.OF.GRC.DAYS=R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.GRACE.DAYS>
    Y.NO.OF.GRC.DAYS='+':Y.NO.OF.GRC.DAYS:'W'
    Y.GRACE.END.DATE=ROLLOVER.DATE
    CALL CDT('',Y.GRACE.END.DATE,Y.NO.OF.GRC.DAYS)
    IF TODAY GE ROLLOVER.DATE AND TODAY LE Y.GRACE.END.DATE THEN
        R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PENAL.PER> = '0.00'
        CALL REDO.AZ.PENAL.AMT.CALC(Y.VALUE,Y.PREC.DEP.DAYS,PEN.AMT)
        R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PENAL.AMT> = PEN.AMT
    END ELSE
        GOSUB BEF.ROLLOVER
    END

RETURN
*******************
GET.LOCAL.FLD.POS:
******************
    APPL.ARRAY = 'AZ.ACCOUNT'
    FLD.ARRAY  = 'L.AZ.PR.DEP.DAY':@VM:'L.AZ.PENAL.AMT':@VM:'L.AZ.PENAL.PER':@VM:'L.AZ.GRACE.DAYS'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.AZ.PR.DEP.DAY = FLD.POS<1,1>
    LOC.L.AZ.PENAL.AMT = FLD.POS<1,2>
    LOC.L.AZ.PENAL.PER = FLD.POS<1,3>
    POS.L.AZ.GRACE.DAYS=  FLD.POS<1,4>

RETURN
END
