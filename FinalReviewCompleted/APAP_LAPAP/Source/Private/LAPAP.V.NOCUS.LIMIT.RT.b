* @ValidationCode : MjotMTc1MDc0OTYyNzpDcDEyNTI6MTY4OTgzNDU1NDgwOTpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Jul 2023 11:59:14
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
*-----------------------------------------------------------------------------
* <Rating>-60</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.V.NOCUS.LIMIT.RT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No changes
* 13-07-2023     Harishvikram C   Manual R22 conversion       CALL routine format modified
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_GTS.COMMON
    $INSERT  I_System
    $INSERT  I_F.TELLER
    $INSERT  I_F.DATES
    $INSERT  I_F.ST.LAPAP.NOCUS.TXN.BIT
    $INSERT  I_F.ST.LAPAP.NOCUS.LIMIT
    $INSERT  I_F.CURRENCY

*--------------------------------------------------------------------------------------
* This subroutine is attached as a Verification-input Routine for TELLER,FXSN versions
* , it checks whether the occasional customer exceeds its monthly limit or not.
* By J.Q. on Sep 7 2022
*--------------------------------------------------------------------------------------

    GOSUB DO.INITIALIZE
    GOSUB DO.GET.ID
    GOSUB DO.GET.LIM
    IF (R.NEW(TT.TE.CUSTOMER.2) EQ '') AND (Y.LEGAL.ID NE '') AND (Y.COD.CLIENT EQ '' OR Y.COD.CLIENT EQ 'NA') THEN
        GOSUB DO.GET.LIST
        GOSUB DO.PROCESS

    END
RETURN
DO.INITIALIZE:

    APPL.NAME.ARR = "TELLER"
    FLD.NAME.ARR = "L.TT.LEGAL.ID" : @VM : "L.TT.CLIENT.COD"
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)

    Y.L.TT.LEGAL.ID.POS = FLD.POS.ARR<1,1>
    Y.L.TT.CLIENT.COD.POS = FLD.POS.ARR<1,2>


    START.DATE = TODAY
    DAY.COUNT = "-30C"
    CALL CDT('', START.DATE, DAY.COUNT)

*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)

    FN.NCBIT = "FBNK.ST.LAPAP.NOCUS.TXN.BIT"
    F.NCBIT = ""
    CALL OPF(FN.NCBIT,F.NCBIT)

    FN.NCLIM = "FBNK.ST.LAPAP.NOCUS.LIMIT"
    F.NCLIM = ""
    CALL OPF(FN.NCLIM,F.NCLIM)

    FN.CURREN = "FBNK.CURRENCY"
    F.CURREN = ""
    CALL OPF(FN.CURREN,F.CURREN)


RETURN

DO.GET.ID:
    Y.LEGAL.ID = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.LEGAL.ID.POS>
    Y.IDENTIFICATION = FIELD(Y.LEGAL.ID,'.',2)
    Y.COD.CLIENT = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.CLIENT.COD.POS>


RETURN

DO.GET.LIST:
    SEL.NCBIT = "SELECT ": FN.NCBIT :" WITH IDENTIFICATION EQ ": Y.IDENTIFICATION : " AND TXN.DATE GE ": START.DATE :" AND TXN.DATE LE " : TODAY
    ID.LIST = '' ; NO.RECS = 0
    CALL EB.READLIST(SEL.NCBIT, ID.LIST, '', NO.RECS, '')

RETURN

DO.GET.LIM:

    CALL F.READ(FN.NCLIM,"SYSTEM",R.NCLIM,F.NCLIM,NCLIM.ERR)
    Y.R.PERIOD = R.NCLIM<ST.LNCL.PERIOD>
    Y.R.LIM.AMT = R.NCLIM<ST.LNCL.TOT.AMT.LIMIT>
    Y.PERIOD = 'MONTHLY'
    Y.PA.LIM = ''

    CALL F.READ(FN.CURREN,"USD",R.CURREN,F.CURREN,CURREN.ERR)

    FIND Y.PERIOD IN Y.R.PERIOD SETTING V.FLD, V.VAL THEN

        Y.PA.LIM = Y.R.LIM.AMT<1,V.VAL>

        IF (R.CURREN) THEN
            Y.CURR.MARKET = R.CURREN<EB.CUR.CURRENCY.MARKET>

* Currency market 10 --> Efectivo
            FIND '10' IN Y.CURR.MARKET SETTING V.FLD2, V.VAL2 THEN
                Y.RATE = R.CURREN<EB.CUR.BUY.RATE>
                Y.RATE = Y.RATE<1,V.VAL2>

*MSG= ''
*MSG<-1> = 'Rate: ' : Y.RATE
*MSG<-1> = 'Limite :' : Y.PA.LIM
*MSG<-1> = 'Conversion :' : Y.PA.LIM * Y.RATE
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
                Y.PA.LIM = Y.PA.LIM * Y.RATE
            END

        END
    END

RETURN

DO.PROCESS:

    Y.SUM.AMT = 0
    LOOP
        REMOVE NCBIT.ID FROM ID.LIST SETTING MORE
    WHILE NCBIT.ID : MORE DO
        CALL F.READ(FN.NCBIT,NCBIT.ID,R.NCBIT,F.NCBIT,NCBIT.ERR)
        IF R.NCBIT THEN
            Y.TMP.AMT = R.NCBIT<ST.LNCTB.TXN.AMT>
            Y.SUM.AMT += Y.TMP.AMT
        END
    REPEAT
    Y.SUM.AMT += R.NEW(TT.TE.NET.AMOUNT)
    Y.PA.LIM = Y.PA.LIM *1

*MSG= ''
*MSG<-1> = 'Sumatoria :' : Y.SUM.AMT
*MSG<-1> = 'Limite :' : Y.PA.LIM
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
    IF Y.PA.LIM THEN
        IF Y.SUM.AMT GT Y.PA.LIM THEN
*MSG= ''
*MSG<-1> = 'Supera limite procedo a llamar: LAPAP.I.NOCUS.DECLINED.RT'
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)

*            CALL LAPAP.I.NOCUS.DECLINED.RT
            APAP.LAPAP.lapapINocusDeclinedRt()          ;*Manual R22 conversion

            SLEEP 1

            Y.DIFF = Y.SUM.AMT - Y.PA.LIM
            AF=19
*TEXT = "FX-NOCUS.AMT.EXCEED"
*CURRNO = DCOUNT(R.NEW(TT.TE.OVERRIDE),VM) + 1
*CALL STORE.OVERRIDE(CURRNO)
            TEXT = "Sobrepasa limite establecido"
            ETEXT = TEXT
*E = TEXT

            CALL STORE.END.ERROR
*CALL REM

*TEXT='LAPAP.OCC.CUS.LIM.EXC':FM:Y.DIFF
*YCURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),VM)+1
*CALL STORE.OVERRIDE(YCURR.NO)
        END
    END
RETURN

END
