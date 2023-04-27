$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.RTN.REDO.ACH.INWARD(Y.FINAL)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.FUNDS.TRANSFER

*PARA ABRIR EL ACHIVO DE FUNDS.TRANSFER
    FN.FT = "F.FUNDS.TRANSFER"
    FV.FT = ""
    CALL OPF(FN.FT, FV.FT)

    R.FT = ""
    FT.ERR = ""

    SEL.LIST = ""
    NO.OF.REC = ""
    SEL.ERR = ""
    Y.FECHA = ""

* SENTENCIA LOCATE
    LOCATE "DATE" IN D.FIELDS<1> SETTING CUS.POS THEN
        Y.FECHA = D.RANGE.AND.VALUE<CUS.POS>
    END

* FORMAMOS EL COMANDO A EJECUTAR
    SEL.CMD = "SELECT " : FN.FT : " WITH DEBIT.VALUE.DATE EQ '" : Y.FECHA : "' AND (DEBIT.ACCT.NO EQ 'DOP1265000020017' OR CREDIT.ACCT.NO EQ 'DOP1265000020017')"

* REALIZAMOS LA LLAMADA
    CALL EB.READLIST(SEL.CMD, SEL.LIST,"", NO.OF.REC, SEL.ERR)

    IF NO.OF.REC EQ 0 OR NO.OF.REC EQ '' THEN

*PARA ABRIR EL ACHIVO DE FUNDS.TRANSFER
        FN.FT = "F.FUNDS.TRANSFER$HIS"
        FV.FT = ""
        CALL OPF(FN.FT, FV.FT)

        SEL.LIST = ""
        NO.OF.REC = ""
        SEL.ERR = ""

* FORMAMOS EL COMANDO A EJECUTAR
        SEL.CMD = "SELECT " : FN.FT : " WITH DEBIT.VALUE.DATE EQ '" : Y.FECHA : "' AND (DEBIT.ACCT.NO EQ 'DOP1265000020017' OR CREDIT.ACCT.NO EQ 'DOP1265000020017')"

* REALIZAMOS LA LLAMADA
        CALL EB.READLIST(SEL.CMD, SEL.LIST,"", NO.OF.REC, SEL.ERR)
    END

    LOOP
        REMOVE Y.FT.ID FROM SEL.LIST SETTING FT.POS

    WHILE Y.FT.ID DO

        CALL F.READ(FN.FT,Y.FT.ID,R.FT, FV.FT, FT.ERR)

        Y.DB.ACCT.NO = R.FT<FT.DEBIT.ACCT.NO>
        Y.CR.ACCT.NO = R.FT<FT.CREDIT.ACCT.NO>
        Y.DB.AMOUNT = R.FT<FT.DEBIT.AMOUNT>
        Y.CR.AMOUNT = R.FT<FT.CREDIT.AMOUNT>
        Y.VAL.DATE = R.FT<FT.DEBIT.VALUE.DATE>
        Y.TRX.TYPE = R.FT<FT.TRANSACTION.TYPE>
        Y.DATE.TIME = R.FT<FT.DATE.TIME>

        Y.MONTO = ""

        IF Y.CR.AMOUNT THEN
            Y.MONTO =  "-":Y.CR.AMOUNT
        END ELSE
            Y.MONTO = Y.DB.AMOUNT
        END

        Y.POS = ""
        CALL GET.LOC.REF("FUNDS.TRANSFER","L.FT.CLIENT.NME",Y.POS)
        Y.NOMBRE.CL = R.FT<FT.LOCAL.REF,Y.POS>

        Y.POS = ""
        CALL GET.LOC.REF("FUNDS.TRANSFER","L.FT.CR.CARD.NO",Y.POS)
        Y.CARD.NO = R.FT<FT.LOCAL.REF,Y.POS>

        Y.FT.FINAL = SUBSTRINGS(Y.FT.ID,1,12)

        Y.FINAL<-1> = Y.FT.FINAL:"|":Y.DB.ACCT.NO:"|":Y.CR.ACCT.NO:"|":Y.VAL.DATE:"|":Y.DATE.TIME:"|":Y.TRX.TYPE:"|":Y.MONTO:"|":Y.NOMBRE.CL:"|":Y.CARD.NO

    REPEAT

END
