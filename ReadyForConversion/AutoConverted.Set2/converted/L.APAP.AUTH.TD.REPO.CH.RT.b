*-----------------------------------------------------------------------------
* <Rating>40</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.AUTH.TD.REPO.CH.RT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT TAM.BP I_F.LATAM.CARD.ORDER
    $INSERT T24.BP I_F.AC.CHARGE.REQUEST
    $INSERT BP I_F.ST.L.APAP.TD.REPO.CHG.PARAMS
    $INSERT BP I_F.ST.L.APAP.TD.REPO.CHG.PARA.AD

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

    FN.TD.REPO = "F.ST.L.APAP.TD.REPO.CHG.PARAMS"
    F.TD.REPO = ""
    R.TD.REPO = ""
    TD.REPO.ERR = ""
    CALL OPF(FN.TD.REPO,F.TD.REPO)
    FN.TD.REPO.ADI = "F.ST.L.APAP.TD.REPO.CHG.PARA.AD"
    F.TD.REPO.ADI = ""
    R.TD.REPO.ADI = ""
    TD.REPO.ADI.ERR = ""
    CALL OPF(FN.TD.REPO.ADI,F.TD.REPO.ADI)

    Y.VERSION.NAME = PGM.VERSION

    CALL GET.LOC.REF("LATAM.CARD.ORDER","RELATION.REASON",LCO.POS.1)

    Y.RELATION.REASON = R.NEW(CARD.IS.LOCAL.REF)<1,LCO.POS.1>

    IF Y.VERSION.NAME EQ ",REDO.PRINCIPAL" THEN
        CALL F.READ(FN.TD.REPO,Y.RELATION.REASON,R.TD.REPO, F.TD.REPO, TD.REPO.ERR)
    END
    IF Y.VERSION.NAME EQ ",REDO.ADDITIONAL" THEN
        CALL F.READ(FN.TD.REPO.ADI,Y.RELATION.REASON,R.TD.REPO, F.TD.REPO.ADI, TD.REPO.ADI.ERR)
    END

    Y.CARD.TYPE =  R.NEW(CARD.IS.CARD.TYPE)

    IF R.TD.REPO NE '' THEN

        FINDSTR Y.CARD.TYPE IN R.TD.REPO<2> SETTING Ap, Vp THEN


            Y.CHARGE.CODE = R.TD.REPO<1,Vp>
            IF Y.CHARGE.CODE NE '' THEN



                Y.CANT.CUS = DCOUNT(R.NEW(CARD.IS.CUSTOMER.NO),@VM)

                Y.CUSTOMER = R.NEW(CARD.IS.CUSTOMER.NO)<1,Y.CANT.CUS>

                Y.CANT.ACC = DCOUNT(R.NEW(CARD.IS.ACCOUNT),@VM)

                Y.ACCOUNT = R.NEW(CARD.IS.ACCOUNT)<1,Y.CANT.ACC>
                Y.ST = R.NEW(CARD.IS.CARD.STATUS)

                IF V$FUNCTION EQ 'A' THEN

                    GOSUB OFS.PROC
                END
            END


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
