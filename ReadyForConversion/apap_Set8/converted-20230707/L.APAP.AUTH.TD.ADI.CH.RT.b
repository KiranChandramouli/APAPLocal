SUBROUTINE L.APAP.AUTH.TD.ADI.CH.RT
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.AC.CHARGE.REQUEST
    $INSERT I_F.ST.LAPAP.TD.ADI.CH

    FN.CT = "F.CARD.TYPE"
    F.CT = ""
    R.CT = ""
    CT.ERR = ""
    CALL OPF(FN.CT,F.CT)

    FN.LCO = "F.LATAM.CARD.ORDER$NAU"
    F.LCO = ""
    R.LCO = ""
    TD.LCO = ""
    CALL OPF(FN.LCO,F.LCO)

    FN.TD.ADI = "F.ST.LAPAP.TD.ADI.CH"
    F.TD.ADI = ""
    R.TD.ADI = ""
    TD.ADI.ERR = ""
    CALL OPF(FN.TD.ADI,F.TD.ADI)

    Y.CARD.TYPE = ID.NEW[1,4]

    CALL F.READ(FN.TD.ADI,Y.CARD.TYPE,R.TD.ADI, F.TD.ADI, TD.ADI.ERR)
    Y.CHARGE.CODE = R.TD.ADI<1>


*CALL F.READ(FN.LCO,ID.NEW,R.LCO, F.LCO, TD.LCO)
*Y.CANT.CUS = DCOUNT(R.LCO<CARD.IS.CUSTOMER.NO>,@VM)
    Y.CANT.CUS = DCOUNT(R.NEW(CARD.IS.CUSTOMER.NO),@VM)
*Y.CUSTOMER = R.LCO<CARD.IS.CUSTOMER.NO, Y.CANT.CUS>
    Y.CUSTOMER = R.NEW(CARD.IS.CUSTOMER.NO)<1,Y.CANT.CUS>
*Y.CANT.ACC = DCOUNT(R.LCO<CARD.IS.ACCOUNT>,@VM)
    Y.CANT.ACC = DCOUNT(R.NEW(CARD.IS.ACCOUNT),@VM)
*Y.ACCOUNT = R.LCO<CARD.IS.ACCOUNT>
    Y.ACCOUNT = R.NEW(CARD.IS.ACCOUNT)<1,Y.CANT.ACC>
    Y.ST = R.NEW(CARD.IS.CARD.STATUS)
*Y.ST = R.LCO<CARD.IS.CARD.STATUS>
    IF Y.ST EQ 90 OR Y.ST EQ 92 OR Y.ST EQ 52 OR Y.ST EQ 74 OR Y.ST EQ 75 OR Y.ST EQ 80 OR Y.ST EQ 94 OR Y.ST EQ 95 OR Y.ST EQ 96 THEN

        IF V$FUNCTION EQ 'A' THEN

            GOSUB OFS.PROC
        END
    END



OFS.PROC:
    Y.TRANS.ID = ""
    Y.APP.NAME = "AC.CHARGE.REQUEST"
    Y.VER.NAME = Y.APP.NAME :",L.APAP.ADI"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = ""
    FINAL.OFS = ""
    OPTIONS = ""
    R.ACR = ""

    R.ACR<CHG.CHARGE.CODE> = Y.CHARGE.CODE
    R.ACR<CHG.CUSTOMER.NO> = Y.CUSTOMER
    R.ACR<CHG.DEBIT.ACCOUNT> = Y.ACCOUNT


    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.ACR,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"TD.ADI.CH",'')

RETURN


END
