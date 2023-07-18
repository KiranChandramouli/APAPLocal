*-----------------------------------------------------------------------------
* <Rating>44</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.TDMENCHG.RT(Y.LCO.ID)
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT TAM.BP I_F.LATAM.CARD.ORDER
    $INSERT T24.BP I_F.AC.CHARGE.REQUEST
    $INSERT BP I_F.ST.LAPAP.TD.MEN.CH
    $INSERT T24.BP I_F.DATES
    $INSERT LAPAP.BP I_L.APAP.TDMENCHG.COMMON
    $INSERT T24.BP I_F.ACCOUNT

    Y.CAN.PROCESS.FLAG = 'Y'
    CALL F.READ(FN.LCO,Y.LCO.ID,R.LCO, F.LCO, TD.LCO.ERR)
    Y.CANT.CUS = DCOUNT(R.LCO<CARD.IS.CUSTOMER.NO>,@VM)
    Y.CUSTOMER = R.LCO<CARD.IS.CUSTOMER.NO, Y.CANT.CUS>
    Y.CANT.ACC = DCOUNT(R.LCO<CARD.IS.ACCOUNT>,@VM)
    Y.ACCOUNT = R.LCO<CARD.IS.ACCOUNT, Y.CANT.ACC>
    Y.ST = R.LCO<CARD.IS.CARD.STATUS>
    Y.TYPE.OF.CARD = R.LCO<CARD.IS.TYPE.OF.CARD>
    Y.CARD.TYPE = R.LCO<CARD.IS.CARD.TYPE>

    CALL F.READ(FN.ACC,Y.ACCOUNT,R.ACC, F.ACC, ACC.ERR)
*Excluir de realizar cargos las cuentas de categoría 6007 (ACCOUNT>CATEGORY>6007)
    IF R.ACC<AC.CATEGORY> EQ '6007' THEN
        Y.CAN.PROCESS.FLAG = 'N'
    END
*Excluir de realizar cargos las cuentas marcadas no realizar cargos (ACCOUNT> WAIVE.LEDGER.FEE>Y)
    IF R.ACC<AC.WAIVE.LEDGER.FEE> EQ 'Y' THEN
        Y.CAN.PROCESS.FLAG = 'N'
    END
*Excluir de realizar cargos las cuentas inactivas 3 años y abandonadas (ACCOUNT>L.AC.STATUS1>3YINACTIVE), (ACCOUNT>L.AC.STATUS1>ABANDONED)
    CALL GET.LOC.REF("ACCOUNT","L.AC.STATUS1",AC.POS.1)
    CALL GET.LOC.REF("ACCOUNT","L.AC.STATUS2",AC.POS.2)
    IF R.ACC<AC.LOCAL.REF,AC.POS.1> EQ '3YINACTIVE' THEN
        Y.CAN.PROCESS.FLAG = 'N'
    END
    IF R.ACC<AC.LOCAL.REF,AC.POS.1> EQ 'ABANDONED' THEN
        Y.CAN.PROCESS.FLAG = 'N'
    END
*Excluir de realizar cargos las cuentas con estatus fallecidas (ACCOUNT>L.AC.STATUS2>DECEASED)
    IF R.ACC<AC.LOCAL.REF,AC.POS.2> EQ 'DECEASED' THEN
        Y.CAN.PROCESS.FLAG = 'N'
    END
*Excluir de realizar cargos las TD adicionales(LATAM.CARD.ORDER>TYPE.OF.CARD>ADDITIONAL/ADICIONAL) de las TDVF (LATAM.CARD.ORDER>CARD.TYPE>TDVF)
    IF Y.CARD.TYPE EQ 'TDVF' THEN
        IF Y.TYPE.OF.CARD EQ 'ADDITIONAL' OR Y.TYPE.OF.CARD EQ 'ADICIONAL' THEN
            Y.CAN.PROCESS.FLAG = 'N'
        END
    END
    T.MSG = Y.LCO.ID : " " : TD.LCO.ERR
    CALL OCOMO(T.MSG)

    IF Y.CAN.PROCESS.FLAG EQ 'Y' THEN
        IF Y.ST EQ 74 OR Y.ST EQ 90 OR Y.ST EQ 94 THEN
*PROCESS
            Y.CARD.T = Y.LCO.ID[1,4]
            CALL F.READ(FN.TD.MEN,Y.CARD.T,R.TD.MEN, F.TD.MEN, TD.MEN.ERR)
            Y.QNT.CC = DCOUNT(R.TD.MEN<2>,@VM)    ;*ST.LAP10.ACC.CATEGORY TO 2
            CC.POS = ''
            FOR A = 1 TO Y.QNT.CC STEP 1
                IF R.TD.MEN<2,A> EQ R.ACC<AC.CATEGORY> THEN
                    CC.POS = A
                    BREAK
                END
            NEXT A
            Y.CHARGE.CODE = R.TD.MEN<1,CC.POS>

            IF CC.POS NE '' THEN
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
            END ELSE
                CALL OCOMO(Y.LCO.ID : "|" : R.ACC<AC.CATEGORY> : "|" : Y.ST : "|" : "CARGO-CATEGORIA NO PARAMETRIZADO")
            END


        END
    END

*CALL JOURNAL.UPDATE('')

    RETURN

END
