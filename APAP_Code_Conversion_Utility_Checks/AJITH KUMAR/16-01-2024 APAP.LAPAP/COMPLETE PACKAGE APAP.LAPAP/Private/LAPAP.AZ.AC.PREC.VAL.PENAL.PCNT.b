* @ValidationCode : MjozMzE2OTk4MTQ6Q3AxMjUyOjE3MDA4NDI2NjE1NjA6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Nov 2023 21:47:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-60</Rating>
*-----------------------------------------------------------------------------
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.AZ.AC.PREC.VAL.PENAL.PCNT
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management / Mod by APAP
*Program   Name    : LAPAP.AZ.AC.PREC.VAL.PENAL.PCNT
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a VALIDATION ROUTINE attached to the field L.AZ.PENAL.PER of version
*                    AZ.ACCOUNT,FD.PRECLOSE. It is used to calculate and levy the PENALTY AMOUNT if the
*                    preclosure for the deposit is done not within grace days for roll over deposits and
*                    for the preclosure of deposit which has no roll over
*In Parameter      :
*Out Parameter     :
*Files  Used       : AZ.ACCOUNT               As             I/O          Mode
*                    REDO.AZ.DISCOUNT.RATE
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*  Date              Who                 Reference                  Description
*  ------            ------              -------------              ------------
*  14/06/2010        REKHA S             ODR-2009-10-0336 N.18      Initial Creation
*  11 MAR 2011       H GANESH            PACS00032973  - N.18       Modified as per issue
*  05 MAR 2019       GOPALA KRISHNAN R    PACS00736522               ISSUE FIX
*  24/11/2023        Santosh          R22 Manual Conversion    BP Removed From Inserts, Changed FM/VM/ to @FM/@VM
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.AZ.DISCOUNT.RATE
    $INSERT I_F.LAPAP.AZ.PENAL.RATE
    GOSUB MAIN.PROCESS
RETURN
*--------------------------------------------------------------------------------------------------------------
MAIN.PROCESS:
*--------------------------------------------------------------------------------------------------------------
    FN.LAPAP.AZ.PENAL.RATE = 'F.ST.LAPAP.AZ.PENAL.RATE'
    F.LAPAP.AZ.PENAL.RATE = ''
    CALL OPF(FN.LAPAP.AZ.PENAL.RATE,F.LAPAP.AZ.PENAL.RATE)

* PACS00736522 - S
    PRINCIPAL.OLD = ""
    PRINCIPAL.OLD = R.NEW.LAST(AZ.ORIG.PRINCIPAL)
    IF PRINCIPAL.OLD THEN
        C$SPARE(399) = R.NEW.LAST(AZ.ORIG.PRINCIPAL)
    END ELSE
        C$SPARE(399) = R.NEW(AZ.PRINCIPAL)
    END
* PACS00736522 - E

    FN.REDO.AZ.DISCOUNT.RATE='F.REDO.AZ.DISCOUNT.RATE'
    F.REDO.AZ.DISCOUNT.RATE=''
    CALL OPF(FN.REDO.AZ.DISCOUNT.RATE,F.REDO.AZ.DISCOUNT.RATE)

    GOSUB GET.LOCAL.FLD.POS
    Y.ROL.DATE   = R.NEW(AZ.ROLLOVER.DATE)
    IF Y.ROL.DATE THEN
        Y.FINAL.DATE = Y.ROL.DATE
    END
    ELSE
        Y.FINAL.DATE = R.NEW(AZ.MATURITY.DATE)
    END
    Y.GR.DAYS    = R.NEW(AZ.LOCAL.REF)<1,LOC.GRACE.DAYS>
    Y.GR.DAYS    = '+':Y.GR.DAYS:'W'
    CALL CDT('',Y.FINAL.DATE,Y.GR.DAYS)

    Y.PENAL.AMT  = R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PENAL.AMT>
    Y.PENAL.AMT  = ABS(Y.PENAL.AMT)
*DEBUG
    IF Y.ROL.DATE THEN
        IF TODAY LT Y.FINAL.DATE THEN
            IF COMI NE Y.PENAL.AMT THEN
                ETEXT = 'AZ-PENAL.PER.CHECK':@FM:Y.PENAL.AMT
                CALL STORE.END.ERROR
                ETEXT = ''
            END
            RETURN
        END
    END

    GOSUB GET.INT.RATE
*DEBUG
    IF COMI GT Y.PENAL.PER THEN
        ETEXT = 'AZ-PENAL.PER.CHECK':@FM:Y.PENAL.PER
        CALL STORE.END.ERROR
        ETEXT=''
        RETURN
    END
    Y.PEN.PERCENT=COMI
    CALL REDO.AZ.PENAL.AMT.CALC(Y.PEN.PERCENT,Y.PREC.DEP.DAYS,PEN.AMT)
    R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PENAL.AMT>=PEN.AMT

RETURN
*--------------------------------------------------------------------------------------------------------------
GET.INT.RATE:
*--------------------------------------------------------------------------------------------------------------
    Y.PREC.DEP.DAYS=R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PR.DEP.DAY>
    Y.CATEGORY=R.NEW(AZ.CATEGORY)
    CALL F.READ(FN.LAPAP.AZ.PENAL.RATE,Y.CATEGORY,R.LAPAP.AZ.PENAL.RATE,F.LAPAP.AZ.PENAL.RATE,Y.AZ.P.ERR)



    IF R.LAPAP.AZ.PENAL.RATE THEN
        Y.REF.DATE = R.LAPAP.AZ.PENAL.RATE<ST.LAP50.FROM.DATE>
        Y.AZ.CREATE.DATE =  R.NEW(AZ.CREATE.DATE)
        IF Y.AZ.CREATE.DATE GE Y.REF.DATE THEN
            Y.MIN.AMT = R.LAPAP.AZ.PENAL.RATE<ST.LAP50.MINIMUM.CHARGE>
            GOSUB GET.PENAL.RATE
        END ELSE
            CALL F.READ(FN.REDO.AZ.DISCOUNT.RATE,Y.CATEGORY,R.REDO.AZ.DISCOUNT.RATE,F.REDO.AZ.DISCOUNT.RATE,Y.AZ.DIS.ERR)
            IF R.REDO.AZ.DISCOUNT.RATE THEN
                GOSUB GET.PENAL.RATE.ORIG
            END ELSE
                Y.PENAL.PER=0.00
                RETURN
            END
        END
    END ELSE
        Y.PENAL.PER=0.00
        RETURN
    END

RETURN

*--------------------------------------------------------------------------------------------------------------
GET.PENAL.RATE.ORIG:
*--------------------------------------------------------------------------------------------------------------
    Y.DATE.RANGE =R.REDO.AZ.DISCOUNT.RATE<REDO.DIS.RATE.DATE.RANGE>
    Y.DATE.RNG.CNT=DCOUNT(Y.DATE.RANGE,@VM)
    Y.VAR1=1
    Y.START.DATE=FIELD(Y.DATE.RANGE<1,Y.VAR1>,'-',1)
    IF Y.PREC.DEP.DAYS LT Y.START.DATE THEN       ;* If suppose preclosure happens before the pre-defined days in REDO.AZ.DISCOUNT.RATE.(i.e if DATE.RANGE begins from 30 days and preclosure happens with that days)
        Y.PENAL.PER=0.00
        RETURN
    END
    LOOP
    WHILE Y.VAR1 LE Y.DATE.RNG.CNT
        Y.START.DATE=FIELD(Y.DATE.RANGE<1,Y.VAR1>,'-',1)
        Y.END.DATE=FIELD(Y.DATE.RANGE<1,Y.VAR1>,'-',2)
        IF Y.VAR1 EQ Y.DATE.RNG.CNT THEN          ;* This is for Default Case at last multivalue of table REDO.AZ.DISCOUNT.RATE
            Y.PENAL.PER=R.REDO.AZ.DISCOUNT.RATE<REDO.DIS.RATE.PENAL.PERCENT,Y.VAR1>
        END
        IF Y.PREC.DEP.DAYS GE Y.START.DATE AND Y.PREC.DEP.DAYS LE Y.END.DATE THEN
            Y.PENAL.PER=R.REDO.AZ.DISCOUNT.RATE<REDO.DIS.RATE.PENAL.PERCENT,Y.VAR1>
            Y.VAR1 = Y.DATE.RNG.CNT+1   ;* Instead of Break Statement
        END
        Y.VAR1++
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------------
GET.PENAL.RATE:
*--------------------------------------------------------------------------------------------------------------
*DEBUG
    Y.DATE.RANGE  =  R.LAPAP.AZ.PENAL.RATE<ST.LAP50.DATE.RANGE>
    Y.DATE.RNG.CNT  = DCOUNT(Y.DATE.RANGE,@VM)
    Y.VAR1   = 1
    Y.START.DATE = FIELD(Y.DATE.RANGE<1,Y.VAR1>,'-',1)
    IF Y.PREC.DEP.DAYS LT Y.START.DATE THEN       ;* If suppose preclosure happens before the pre-defined days in REDO.AZ.DISCOUNT.RATE.(i.e if DATE.RANGE begins from 30 days and preclosure happens with that days)
        Y.PENAL.PER=0.00
        RETURN
    END

    Y.REMAIN.CAL.DAYS = "C"
    Y.CREATED.DATE = R.NEW(AZ.CREATE.DATE)
    Y.MATURITY.DATE = R.NEW(AZ.MATURITY.DATE)

    Y.FINAL.DATE1 = TODAY

    Y.LEFT.DEP.DAYS = 'C'
    CALL CDD('',Y.FINAL.DATE1,Y.MATURITY.DATE,Y.LEFT.DEP.DAYS)

    IF Y.CREATED.DATE LE Y.FINAL.DATE1 THEN       ;* IF preclusure happens on or before 30 days of creation, apply maximium penalty.
        CALL CDD('',Y.CREATED.DATE, Y.FINAL.DATE1, REMAIN.CAL.DAYS)
        IF (REMAIN.CAL.DAYS LT 30) OR (Y.PREC.DEP.DAYS LT 30) THEN
            Y.PENAL.PER= R.LAPAP.AZ.PENAL.RATE<ST.LAP50.PENAL.PERCENT,Y.DATE.RNG.CNT>
            RETURN
        END

    END
****

****

    LOOP
    WHILE Y.VAR1 LE Y.DATE.RNG.CNT
        Y.START.DATE = FIELD(Y.DATE.RANGE<1,Y.VAR1>,'-',1)
        Y.END.DATE  = FIELD(Y.DATE.RANGE<1,Y.VAR1>,'-',2)
        IF Y.VAR1 EQ Y.DATE.RNG.CNT THEN          ;* This is for Default Case at last multivalue of table REDO.AZ.DISCOUNT.RATE
            Y.PENAL.PER = R.LAPAP.AZ.PENAL.RATE<ST.LAP50.PENAL.PERCENT,Y.VAR1>
        END
*Fix, Instead of using total dep days, lets uso remaining left days
        IF Y.LEFT.DEP.DAYS GE Y.START.DATE AND Y.LEFT.DEP.DAYS LE Y.END.DATE THEN
            Y.PENAL.PER =  R.LAPAP.AZ.PENAL.RATE<ST.LAP50.PENAL.PERCENT,Y.VAR1>
            Y.VAR1 = Y.DATE.RNG.CNT+1   ;* Instead of Break Statement
        END
        Y.VAR1++
    REPEAT

RETURN

*--------------------------------------------------------------------------------------------------------------
GET.LOCAL.FLD.POS:
******************
    APPL.ARRAY = 'AZ.ACCOUNT'
    FLD.ARRAY  = 'L.AZ.PENAL.AMT':@VM:'L.AZ.PR.DEP.DAY':@VM:'L.AZ.GRACE.DAYS'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.AZ.PENAL.AMT = FLD.POS<1,1>
    LOC.L.AZ.PR.DEP.DAY = FLD.POS<1,2>
    LOC.GRACE.DAYS      = FLD.POS<1,3>

RETURN
*--------------------------------------------------------------------------------------------------------------
END
