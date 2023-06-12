* @ValidationCode : Mjo2NTY2NzcyNjA6Q3AxMjUyOjE2ODY1NzEyMDEzNjE6SVRTUzE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Jun 2023 17:30:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
*-----------------------------------------------------------------------------
* <Rating>-134</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE AA.GET.INTEREST.RATE.AUTH

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : AA.GET.INTEREST.RATE.AUTH
*--------------------------------------------------------------------------------
* Description: This is a Post routine for Interest property to raise the AC.LOCKED.EVENTS for Collateral of that Loan
*
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
* DATE WHO REFERENCE DESCRIPTION
* 12-May-2011 H GANESH PACS00054299 - B.37 INITIAL CREATION
* 12-Jun-2023  Santosh  Manual R22 conversion   New argument added in AA.BUILD.PAYMENT.SCHEDULE.SCHEDULES
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.LIMIT
    $INSERT I_F.COLLATERAL
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY


    IF c_aalocActivityStatus EQ 'AUTH' THEN
        GOSUB INIT
        GOSUB PROCESS
    END
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.LI.COLLATERAL.RIGHT='F.LI.COLLATERAL.RIGHT'
    F.LI.COLLATERAL.RIGHT=''
    CALL OPF(FN.LI.COLLATERAL.RIGHT,F.LI.COLLATERAL.RIGHT)

    FN.RIGHT.COLLATERAL='F.RIGHT.COLLATERAL'
    F.RIGHT.COLLATERAL=''
    CALL OPF(FN.RIGHT.COLLATERAL,F.RIGHT.COLLATERAL)

    FN.COLLATERAL='F.COLLATERAL'
    F.COLLATERAL=''
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS=''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    R.OFS.FINAL.ARRAY=''
    R.RIGHT.COLLATERAL=''
    Y.FLAG=''

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

*Y.LIMIT.REFERENCE = C$SPARE(500)
    GOSUB GET.LIMIT.REF
    IF Y.LIMIT.REFERENCE EQ '' THEN
        RETURN
    END ELSE
        Y.CUSTOMER.ID = c_aalocArrActivityRec<AA.ARR.ACT.CUSTOMER>
*AA Changes 20161013
*REF.NO = FMT(FIELD(Y.LIMIT.REFERENCE,'.',1,1),"7'0'R")
        REF.NO = FMT(Y.LIMIT.REFERENCE,"7'0'R")
*SEQ.NO = FMT(FIELD(Y.LIMIT.REFERENCE,'.',2,1),"2'0'R")
        SEQ.NO = Y.SERIAL.NUMBER
*AA Changes 20161013
        Y.LIMIT.ID = Y.CUSTOMER.ID:".":REF.NO:".":SEQ.NO
    END
    GOSUB GET.LOC.REF

    CALL F.READ(FN.LI.COLLATERAL.RIGHT,Y.LIMIT.ID,R.LI.COLLATERAL.RIGHT,F.LI.COLLATERAL.RIGHT,ERR.LI.COLLATERAL.RIGHT)

    Y.LI.COL.CNT=DCOUNT(R.LI.COLLATERAL.RIGHT,@FM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.LI.COL.CNT
        Y.COLLATERAL.RIGHT.ID=R.LI.COLLATERAL.RIGHT<Y.VAR1>
        CALL F.READ(FN.RIGHT.COLLATERAL,Y.COLLATERAL.RIGHT.ID,R.RIGHT.COLLATERAL.ARR,F.RIGHT.COLLATERAL,ERR.RIGHT.COLLATERAL)
        R.RIGHT.COLLATERAL<-1>=R.RIGHT.COLLATERAL.ARR
        Y.VAR1++
    REPEAT

    GOSUB LOCK.AMOUNT

RETURN
*-----------------------------------------------------------
LOCK.AMOUNT:
*-----------------------------------------------------------
* This part locks all the deposit and accounts given as collateral for this Loan

    GOSUB GET.INTEREST.AMT

    Y.DISB.AMOUNT=c_aalocArrActivityRec<AA.ARR.ACT.TXN.AMOUNT>
    Y.AMOUNT.BAL=Y.DISB.AMOUNT+INT.AMT
    Y.COLLATERAL.CNT=DCOUNT(R.RIGHT.COLLATERAL,@FM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.COLLATERAL.CNT
        Y.COLLATERAL.ID=R.RIGHT.COLLATERAL<Y.VAR1>
        CALL F.READ(FN.COLLATERAL,Y.COLLATERAL.ID,R.COLLATERAL,F.COLLATERAL,ERR.COLLATERAL)
        Y.ACCOUNT.ID=R.COLLATERAL<COLL.APPLICATION.ID>
        GOSUB RAISE.LOCK
        IF Y.FLAG EQ 1 THEN
            BREAK
        END
        Y.VAR1++
    REPEAT
    IF R.OFS.FINAL.ARRAY THEN
        OFS.SRC='REDO.CHQ.ISSUE'
        OPTIONS=''
        CALL OFS.POST.MESSAGE(R.OFS.FINAL.ARRAY,OFS.MSG.ID,OFS.SRC,OPTIONS)
    END
RETURN
*-----------------------------------------------------------
RAISE.LOCK:
*-----------------------------------------------------------
* This part raises a AC.LOCKED.EVENTS for the accounts belongs to that collateral

    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.AC.AVL.BAL=R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.AV.BAL>
    Y.PREV.BAL=Y.AMOUNT.BAL
    Y.AMOUNT.BAL=Y.AMOUNT.BAL-Y.AC.AVL.BAL
    IF Y.AMOUNT.BAL LE 0 THEN
        Y.LOCK.AMOUNT=Y.PREV.BAL
        Y.FLAG=1
    END ELSE
        Y.LOCK.AMOUNT=Y.AC.AVL.BAL
    END
    R.ALE=''
    R.ALE<AC.LCK.ACCOUNT.NUMBER>=Y.ACCOUNT.ID
    R.ALE<AC.LCK.DESCRIPTION>=c_aalocArrActivityId
    R.ALE<AC.LCK.FROM.DATE>=TODAY
    R.ALE<AC.LCK.LOCKED.AMOUNT>=Y.LOCK.AMOUNT

    APP.NAME = 'AC.LOCKED.EVENTS'
    OFSFUNCT='I'
    PROCESS = ''
    OFSVERSION = 'AC.LOCKED.EVENTS,REDO.LOCK.LOAN'
    GTSMODE = ''
    TRANSACTION.ID=''
    OFSRECORD = ''
    OFS.MSG.ID =''
    OFS.ERR = ''
    NO.OF.AUTH=0

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.ALE,OFSRECORD)

    R.OFS.FINAL.ARRAY<-1>=OFSRECORD

RETURN
*-------------------------------------------------------
GET.INTEREST.AMT:
*-------------------------------------------------------
* This part gets the interest amount for the arrangement
    Y.ARRANGEMENT.ID=c_aalocArrId

    GOSUB GET.INTEREST.PROP

    GOSUB GET.SCHEDULE.DETAILS

    SCHEDULE.INFO=''
    SCHEDULE.INFO<1> = Y.ARRANGEMENT.ID
    SCHEDULE.INFO<2> = Y.PAY.START.DATE
    SCHEDULE.INFO<3> = OUT.PROPERTY
    SCHEDULE.INFO<4> = R.PAY.SCHED
*TUS AA Changes - 20161019
*    END.DATE = R.PAY.SCHED<1,AA.PS.PAYMENT.END.DATE>
    END.DATE = R.ACC.DET<AA.AD.PAYMENT.END.DATE>      ;*Single Value in R15
*TUS END
    NO.CYCLES=''
    ADJUST.FINAL.AMOUNT=''
    REQD.END.DATE=''
    CHARGE.CALC.INFO = '' ;*Manual R22 conversion - New argument in AA.BUILD.PAYMENT.SCHEDULE.SCHEDULES
*TUS PARAM CHANGES - 20161024
*   CALL AA.BUILD.PAYMENT.SCHEDULE.SCHEDULES(SCHEDULE.INFO, REQD.END.DATE, NO.CYCLES, ADJUST.FINAL.AMOUNT, PAYMENT.DATES, PAYMENT.TYPES, PAYMENT.METHODS, PAYMENT.AMOUNTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, OUTSTANDING.AMOUNT,FINAL.PRINCIPAL.POS,RET.ERROR)
*   CALL AA.BUILD.PAYMENT.SCHEDULE.SCHEDULES(SCHEDULE.INFO, REQD.END.DATE, NO.CYCLES, ADJUST.FINAL.AMOUNT, PAYMENT.DATES, PAYMENT.TYPES, PAYMENT.METHODS, PAYMENT.AMOUNTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, TAX.DETAILS, OUTSTANDING.AMOUNT, FINAL.PRINCIPAL.POS, PAYMENT.PERCENTAGES, PAYMENT.MIN.AMOUNTS, PAYMENT.DEFER.DATES, PAYMENT.BILL.TYPES, RET.ERROR)

    CALL AA.BUILD.PAYMENT.SCHEDULE.SCHEDULES(SCHEDULE.INFO, REQD.END.DATE, NO.CYCLES, ADJUST.FINAL.AMOUNT, PAYMENT.DATES, PAYMENT.TYPES, PAYMENT.METHODS, PAYMENT.AMOUNTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, TAX.DETAILS, OUTSTANDING.AMOUNT, FINAL.PRINCIPAL.POS, PAYMENT.PERCENTAGES, PAYMENT.MIN.AMOUNTS, PAYMENT.DEFER.DATES, PAYMENT.BILL.TYPES, CHARGE.CALC.INFO, RET.ERROR)   ;*Manual R22 conversion - CHARGE.CALC.INFO argument added
*TUS END
    GOSUB GET.INTEREST.AMOUNT


*---------------------------------------------------------------------------
GET.INTEREST.PROP:
*---------------------------------------------------------------------------
* This part gets the principal interest property of that arrangement

    PROP.NAME='PRINCIPAL'         ;* Interest Property to obtain
    OUT.PROP=''
    CALL REDO.GET.INTEREST.PROPERTY(Y.ARRANGEMENT.ID,PROP.NAME,OUT.PROP,ERR)
    PROPERTY=OUT.PROP
RETURN
*---------------------------------------------------------------------------
GET.SCHEDULE.DETAILS:
*---------------------------------------------------------------------------
* This part gets the payment schedule details such as payment start date. Pay Sch Product condition

    R.PAY.SCHED = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARRANGEMENT.ID, 'PAYMENT.SCHEDULE','','', RET.IDS, R.PAY.SCHED, RET.ERR)
    IN.PROPERTY.CLASS='PAYMENT.SCHEDULE'
    R.OUT.AA.RECORD=''
    OUT.PROPERTY=''
    CALL REDO.GET.PROPERTY.NAME(Y.ARRANGEMENT.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)

    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.ARRANGEMENT.ID,R.ACC.DET,F.AA.ACCOUNT.DETAILS,ACC.DET.ERR)
    Y.PAY.START.DATE= R.ACC.DET<AA.AD.PAYMENT.START.DATE>       ;* Payment start date

RETURN

*---------------------------------------------------------------------------
GET.INTEREST.AMOUNT:
*---------------------------------------------------------------------------
* This part locates the principal interest property from schedule infomation and sums the amount

    NO.OF.DATES = DCOUNT(PAYMENT.DATES,@FM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE NO.OF.DATES
        TOT.TYPES = DCOUNT(PAYMENT.TYPES<Y.VAR1>,@VM)
        GOSUB GET.INTEREST
        Y.VAR1++
    REPEAT

RETURN
*---------------------------------------------------------------------------
GET.INTEREST:
*---------------------------------------------------------------------------
* Here we gets the principal interest part

    Y.VAR2=1
    LOOP
    WHILE Y.VAR2 LE TOT.TYPES
        PROP.LIST = PAYMENT.PROPERTIES<Y.VAR1,Y.VAR2> ;* This is the list of properties due for the current date
        PROP.AMT = PAYMENT.PROPERTIES.AMT<Y.VAR1,Y.VAR2>        ;* This is the list of property amt for each property
        LOCATE PROPERTY IN PROP.LIST<1,1,1> SETTING INT.PROP.POS THEN
            INT.AMT += PROP.AMT<1,1,INT.PROP.POS>
        END
        Y.VAR2++
    REPEAT
RETURN

*-----------------------------------------------------------
GET.LIMIT.REF:
*-----------------------------------------------------------
* This part gets the Limit Reference of that arrangement
    EFF.DATE = ''
    PROP.CLASS='LIMIT'
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
*   CALL REDO.CRR.GET.CONDITIONS(c_aalocArrId,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
    APAP.AA.redoCrrGetConditions(c_aalocArrId,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)  ;*Manual R22 conversion
    
    Y.LIMIT.REFERENCE=R.CONDITION<AA.LIM.LIMIT.REFERENCE>
* AA Changes 20161013
    Y.SERIAL.NUMBER =R.CONDITION<AA.LIM.LIMIT.SERIAL>
* AA Changes 20161013
RETURN
*-------------------------------------------------------
GET.LOC.REF:
*-------------------------------------------------------

    LOC.REF.APPLICATION="ACCOUNT"
    LOC.REF.FIELDS='L.AC.AV.BAL'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AC.AV.BAL=LOC.REF.POS<1,1>

RETURN

END
