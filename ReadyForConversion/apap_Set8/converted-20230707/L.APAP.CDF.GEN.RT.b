SUBROUTINE L.APAP.CDF.GEN.RT(Y.ID.ACC)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CARD.RENEWAL
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_F.REDO.LY.POINTS
    $INSERT I.L.APAP.CDF.GEN.RT.COMMON
*--$INSERT BP I_F.ST.COUNT.CDF.GEN.RT

    GOSUB GET.ACCOUNTS
RETURN

GET.ACCOUNTS:
    Y.ACC.ID = Y.ID.ACC
*--    Y.DATE = TIMEDATE()

*--EXECUTE 'COMO ON DOMINGO.TXT':Y.DATE
*-- CRT 'Entre En Main'

    R.ACC = ""
    CALL F.READ(FN.ACC,Y.ACC.ID,R.ACC,FV.ACC,ACC.ERR)

    IF R.ACC NE '' THEN
        Y.CUSTOMER    = R.ACC<AC.CUSTOMER>
        Y.CARD.RENEWAL.ID  = Y.CUSTOMER : "-" :  Y.ACC.ID
        Y.CATEGORY    = R.ACC<AC.CATEGORY>
        GOSUB GET.CARDS
    END

*-- EXECUTE 'COMO OFF'

RETURN

GET.CARDS:

    R.CR = ""
    CALL F.READ(FN.CR,Y.CARD.RENEWAL.ID,R.CR,FV.CR,CR.ERR)
*--WE'LL LOOP OVER CARD.RENEWAL TABLE TO LOOK UP CARDS FOR THIS CUSTOMER-ACCOUNT RECORD.
    IF R.CR NE '' THEN
        Y.REDO.RENEW.PREV.CARD.NO = R.CR<REDO.RENEW.PREV.CARD.NO>
        Y.CANT.CARDS = DCOUNT(Y.REDO.RENEW.PREV.CARD.NO,@VM)
        FOR A = 1 TO Y.CANT.CARDS STEP 1
            Y.ACTUAL.CARD = R.CR<REDO.RENEW.PREV.CARD.NO, A>
*-- WE'LL FORMAT CARD NUMBER CAUSE WE ARE INTERESTED IN THE 16 DIGITS WHICH CARD NUMERE ARE MADE OF...
            Y.ACTUAL.CARD = Y.ACTUAL.CARD[6,16]
            GOSUB GET.TXNS
        NEXT A
    END

RETURN

GET.TXNS:
*--WE'LL LOOK TRANSACTIONS FOR THE 16 DIGITS CARD WE GOT IN THE PREVIOUS BLOCK...
    SEL.CMD.ATM.REVERSAL = "SELECT " : FN.AR : " WITH TXN.REF LIKE FT... AND TXN.DATE GE ": Y.START.DATE : " AND TXN.DATE LE " : Y.END.DATE : "  AND MRCHT.CATEG EQ 5542 5541 5912 5411 AND CARD.NUMBER EQ " : Y.ACTUAL.CARD
    CALL EB.READLIST(SEL.CMD.ATM.REVERSAL,SEL.AR.LIST,"",NO.OF.RECS.AR,SEL.AR.ERROR)
*--IF THE SELECTION ARRAY ISN'T EMPTY WE GOT TRANSACTIONS, SO LET'S INCREMENT BY 1 THE CARDS COUNTER...

    Y.TOTAL.CARDS = 0
    Y.TOTAL.TXN = 0
    Y.TOTAL.CERITOS.GEN = 0

    IF SEL.AR.LIST NE '' THEN
        Y.TOTAL.CARDS += 1
    END

    LOOP REMOVE Y.AR.ID FROM SEL.AR.LIST SETTING AR.POS
    WHILE Y.AR.ID DO
        Y.TOTAL.TXN += 1
        R.AR = ""
        CALL F.READ(FN.AR,Y.AR.ID,R.AR,FV.AR,AR.ERR)

        Y.PRODUCTO     = Y.CATEGORY
        Y.ID.TXN     = R.AR<AT.REV.TXN.REF>
        Y.AT.REV.TXN.AMOUNT  = R.AR<AT.REV.TXN.AMOUNT>
        Y.AT.REV.CURRENCY.CODE  = R.AR<AT.REV.CURRENCY.CODE>
        Y.AT.REV.EXCH.RATE   = R.AR<AT.REV.EXCH.RATE>
        Y.CERITOS.ACTUAL   = 0
        Y.VALOR.MON.ACTUAL   = 0
        IF Y.AT.REV.CURRENCY.CODE  EQ 214 THEN
            Y.CERITOS.INT    = INT(Y.AT.REV.TXN.AMOUNT)
            Y.CERITOS.MUL    = INT(Y.CERITOS.INT * 0.01)
            Y.CERITOS.ACTUAL   = INT(Y.CERITOS.MUL)
            Y.VALOR.MON.ACTUAL   = Y.CERITOS.ACTUAL
        END
        IF Y.AT.REV.CURRENCY.CODE EQ 840 THEN
            Y.CERITOS.INT    = INT(Y.AT.REV.TXN.AMOUNT)
            Y.CERITOS.MUL    = INT(Y.CERITOS.INT * Y.AT.REV.EXCH.RATE)
            Y.CERITOS.MUL2    = INT(Y.CERITOS.MUL * 0.01)
            Y.CERITOS.ACTUAL   = INT(Y.CERITOS.MUL2)
            Y.VALOR.MON.INT   = INT(Y.AT.REV.TXN.AMOUNT)
            Y.VALOR.MON.MUL   = INT(Y.VALOR.MON.INT * Y.AT.REV.EXCH.RATE)
            Y.VALOR.MON.MUL2   = INT(Y.VALOR.MON.MUL * 0.02)
            Y.VALOR.MON.ACTUAL   = INT(Y.VALOR.MON.MUL2)
        END
        Y.GEN.DATE = TODAY
        Y.AVL.DATE = TODAY
        Y.DUE.DATE = Y.ANIO.ACTUAL + 3 : Y.MES.ACTUAL : Y.GEN.DATE[7,2]
        Y.TOTAL.CERITOS.GEN += Y.CERITOS.ACTUAL

        GOSUB SEND.OFS.MSG
    REPEAT

*--Actualizo la Tabla de los Contadores
    IF Y.TOTAL.CARDS NE 0 THEN
        GOSUB SET.COUNT
    END

RETURN

SEND.OFS.MSG:
    Y.TRANS.ID   = Y.CUSTOMER
    Y.APP.NAME   = "REDO.LY.POINTS"
    Y.VER.NAME   = Y.APP.NAME :",REC.MAN.AUT2"
    Y.FUNC    = "I"
    Y.PRO.VAL   = "PROCESS"
    Y.GTS.CONTROL  = ""
    Y.NO.OF.AUTH  = "0"
    FINAL.OFS   = ""
    OPTIONS   = ""
    Y.CAN.NUM   = 0
    Y.CAN.MULT   = ""
    R.LP.FIN   = ""

    R.LP = ""
    CALL F.READ(FN.LP,Y.CUSTOMER,R.LP,FV.LP,LP.ERR)
    IF R.LP NE '' THEN
        Y.REDO.PT.PRODUCT = R.LP<REDO.PT.PRODUCT>
        Y.REDO.PT.PRODUCT.CANT = DCOUNT(Y.REDO.PT.PRODUCT,@VM)
*--IF CURRENT LY RECORD ONLY HAVE ONE PRODUCT LET'S ATTACH NEW SUBVALUE AT MULTIVALUE 1 AND SUBVALUE INCREMENTED BY 1
        IF Y.REDO.PT.PRODUCT.CANT EQ 1 AND R.LP<REDO.PT.PRODUCT, 1> EQ Y.CATEGORY THEN
            R.LP.FIN<REDO.PT.PRODUCT, 1>   = Y.CATEGORY
            Y.REDO.PT.PROGRAM = R.LP<REDO.PT.PROGRAM>
            Y.REDO.PT.PROGRAM.CANT = DCOUNT(Y.REDO.PT.PROGRAM,@SM)
            Y.SM.POS = Y.REDO.PT.PROGRAM.CANT + 1
            R.LP.FIN<REDO.PT.PROGRAM, 1, Y.SM.POS>      = "PL00014"
            R.LP.FIN<REDO.PT.TXN.ID, 1, Y.SM.POS>      = Y.ID.TXN
            R.LP.FIN<REDO.PT.QUANTITY, 1, Y.SM.POS>     = Y.CERITOS.ACTUAL
            R.LP.FIN<REDO.PT.QTY.VALUE, 1, Y.SM.POS>     = Y.VALOR.MON.ACTUAL
            R.LP.FIN<REDO.PT.MAN.QTY, 1, Y.SM.POS>     = Y.CERITOS.ACTUAL
            R.LP.FIN<REDO.PT.MAN.QTY.VALUE, 1, Y.SM.POS>    = Y.VALOR.MON.ACTUAL
            R.LP.FIN<REDO.PT.GEN.DATE, 1, Y.SM.POS>     = Y.GEN.DATE
            R.LP.FIN<REDO.PT.AVAIL.DATE, 1, Y.SM.POS>    = Y.AVL.DATE
            R.LP.FIN< REDO.PT.EXP.DATE, 1, Y.SM.POS>     = Y.DUE.DATE
            R.LP.FIN<REDO.PT.MAN.DESC, 1, Y.SM.POS>     = "CARGA TD FAMILIAR BATCH"
            R.LP.FIN<REDO.PT.MAN.STATUS, 1, Y.SM.POS>    = "SI"
            R.LP.FIN<REDO.PT.STATUS, 1, Y.SM.POS>     = "No.Liberada"
*--OTHERWISE IF I GOT HERE IT DOES MEAN THAT; I HAVE MORE THAN ONE PRODUCT, LET'S FIND THE POSITION OF PRODUCT 6021
*--<CATEGORY SHOULD HAVE THAT VALUE AS IS 20170606>IN THIS CASE AND ATTACH NEW SUBVALUE TO THE CORRESPONDING MULTIVALUE POSITION
        END ELSE
            FINDSTR Y.CATEGORY IN Y.REDO.PT.PRODUCT SETTING Ap, Vp THEN
                T.CUENTAS.PROCE = " CAMPO ":Ap:", VALOR ":Vp
                Y.REDO.PT.PROGRAM = R.LP<REDO.PT.PROGRAM, Vp>
                Y.REDO.PT.PROGRAM.CANT = DCOUNT(Y.REDO.PT.PRODUCT.CANT,@SM)
                Y.SM.POS = Y.REDO.PT.PROGRAM.CANT + 1
                R.LP.FIN<REDO.PT.PROGRAM, Vp, Y.SM.POS>     = "PL00014"
                R.LP.FIN<REDO.PT.TXN.ID, Vp, Y.SM.POS>      = Y.ID.TXN
                R.LP.FIN<REDO.PT.QUANTITY, Vp, Y.SM.POS>     = Y.CERITOS.ACTUAL
                R.LP.FIN<REDO.PT.QTY.VALUE, Vp, Y.SM.POS>    = Y.VALOR.MON.ACTUAL
                R.LP.FIN<REDO.PT.MAN.QTY, Vp, Y.SM.POS>     = Y.CERITOS.ACTUAL
                R.LP.FIN<REDO.PT.MAN.QTY.VALUE, Vp, Y.SM.POS>   = Y.VALOR.MON.ACTUAL
                R.LP.FIN<REDO.PT.GEN.DATE, Vp, Y.SM.POS>     = Y.GEN.DATE
                R.LP.FIN<REDO.PT.AVAIL.DATE, Vp, Y.SM.POS>    = Y.AVL.DATE
                R.LP.FIN< REDO.PT.EXP.DATE, Vp, Y.SM.POS>    = Y.DUE.DATE
                R.LP.FIN<REDO.PT.MAN.DESC, Vp, Y.SM.POS>    = "CARGA TD FAMILIAR BATCH"
                R.LP.FIN<REDO.PT.MAN.STATUS, Vp, Y.SM.POS>   = "SI"
                R.LP.FIN<REDO.PT.STATUS, Vp, Y.SM.POS>    = "No.Liberada"
*--PRINT "2 IF"
            END ELSE
*--IF THE DESIRED CATEGORY WASN'T FOUND LET'S INCREMENT THE MULTIVALUE BY 1 THEN IT SUBVALUE BY 1
                Y.VM.POS = Y.REDO.PT.PRODUCT.CANT + 1
                Y.REDO.PT.PROGRAM = R.LP<REDO.PT.PROGRAM, Y.VM.POS>
                Y.REDO.PT.PROGRAM.CANT = DCOUNT(Y.REDO.PT.PRODUCT.CANT,@SM)
                Y.SM.POS = Y.REDO.PT.PROGRAM.CANT + 1
                R.LP.FIN<REDO.PT.PROGRAM, Y.VM.POS, Y.SM.POS>     = "PL00014"
                R.LP.FIN<REDO.PT.TXN.ID, Y.VM.POS, Y.SM.POS>      = Y.ID.TXN
                R.LP.FIN<REDO.PT.QUANTITY, Y.VM.POS, Y.SM.POS>     = Y.CERITOS.ACTUAL
                R.LP.FIN<REDO.PT.QTY.VALUE, Y.VM.POS, Y.SM.POS>     = Y.VALOR.MON.ACTUAL
                R.LP.FIN<REDO.PT.MAN.QTY, Y.VM.POS, Y.SM.POS>     = Y.CERITOS.ACTUAL
                R.LP.FIN<REDO.PT.MAN.QTY.VALUE, Y.VM.POS, Y.SM.POS>    = Y.VALOR.MON.ACTUAL
                R.LP.FIN<REDO.PT.GEN.DATE, Y.VM.POS, Y.SM.POS>     = Y.GEN.DATE
                R.LP.FIN<REDO.PT.AVAIL.DATE, Y.VM.POS, Y.SM.POS>    = Y.AVL.DATE
                R.LP.FIN< REDO.PT.EXP.DATE, Y.VM.POS, Y.SM.POS>    = Y.DUE.DATE
                R.LP.FIN<REDO.PT.MAN.DESC, Y.VM.POS, Y.SM.POS>    = "CARGA TD FAMILIAR BATCH"
                R.LP.FIN<REDO.PT.MAN.STATUS, Y.VM.POS, Y.SM.POS>   = "SI"
                R.LP.FIN<REDO.PT.STATUS, Y.VM.POS, Y.SM.POS>     = "No.Liberada"
*--PRINT "3 IF"
            END
        END

*--WE GOT HERE IF THE RECORD FOR THIS CUSTOMER AT LY POINTS TABLE DOESN'T EXIST, SO LET'S ATTACH NEW VALUES AT POSITION 1
    END ELSE
        R.LP.FIN<REDO.PT.PRODUCT, 1>      = Y.CATEGORY
        R.LP.FIN<REDO.PT.PROGRAM, 1>      = "PL00014"
        R.LP.FIN<REDO.PT.TXN.ID, 1>      = Y.ID.TXN
        R.LP.FIN<REDO.PT.QUANTITY, 1>     = INT(Y.CERITOS.ACTUAL)
        R.LP.FIN<REDO.PT.QTY.VALUE, 1>     = INT(Y.VALOR.MON.ACTUAL)
        R.LP.FIN<REDO.PT.MAN.QTY, 1>      = INT(Y.CERITOS.ACTUAL)
        R.LP.FIN<REDO.PT.MAN.QTY.VALUE, 1>    = INT(Y.VALOR.MON.ACTUAL)
        R.LP.FIN<REDO.PT.GEN.DATE, 1>     = Y.GEN.DATE
        R.LP.FIN<REDO.PT.AVAIL.DATE, 1>    = Y.AVL.DATE
        R.LP.FIN< REDO.PT.EXP.DATE, 1>     = Y.DUE.DATE
        R.LP.FIN<REDO.PT.MAN.DESC, 1>     = "CARGA TD FAMILIAR BATCH"
        R.LP.FIN<REDO.PT.MAN.STATUS, 1>    = "SI"
        R.LP.FIN<REDO.PT.STATUS, 1>     = "No.Liberada"
*--PRINT "4 IF"
    END

    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.LP.FIN,FINAL.OFS)
    CALL OFS.GLOBUS.MANAGER("DIARY.OFS", FINAL.OFS)

*-- PRINT "OFS: " : FINAL.OFS
    CALL OCOMO("PROCESSED: CUSTOMER=":Y.CUSTOMER:",TXN.REF=":Y.ID.TXN:", CARD=":Y.ACTUAL.CARD:", ACCT=":Y.ACC.ID:", CERITOS=":INT(Y.CERITOS.ACTUAL):"::>")
    CALL OCOMO("OFS.SENT/RESPONSE: ": FINAL.OFS)

RETURN

**********
*--GET.COUNT:
**********
*--    CRT 'Entre AL Get.Count'
*--    Y.COUNT.ID = "CDF" : Y.ANIO.ACTUAL.FMT : Y.MES.ACTUAL

*--    CALL F.READ(FN.COUNT,Y.COUNT.ID,R.COUNT,FV.COUNT,ERR.COUNT)

*--    IF R.COUNT EQ '' THEN
*--        Y.TOTAL.CARDS = 0
*--        Y.TOTAL.TXN = 0
*--        Y.TOTAL.CERITOS.GEN = 0

*--        GOSUB SET.COUNT
*--    END ELSE
*--       Y.TOTAL.CARDS = R.COUNT<ST.COU62.TOTAL.CARDS>
*--       Y.TOTAL.TXN = R.COUNT<ST.COU62.TOTAL.TXN>
*--       Y.TOTAL.CERITOS.GEN = R.COUNT<ST.COU62.TOTAL.CERITOS.GEN>
*--    END

*--    CRT 'Encontre un Registro ' : Y.COUNT.ID
*--    CRT 'Y.TOTAL.CARDS ' : Y.TOTAL.CARDS
*--    CRT 'Y.TOTAL.TXN ' : Y.TOTAL.TXN
*--    CRT 'Y.TOTAL.CERITOS.GEN ' : Y.TOTAL.CERITOS.GEN

*--RETURN

**********
SET.COUNT:
**********
*-- CRT 'Grabe un Rgistro ' : Y.COUNT.ID
*-- CRT 'Y.TOTAL.CARDS ' : Y.TOTAL.CARDS
*-- CRT 'Y.TOTAL.TXN ' : Y.TOTAL.TXN
*-- CRT 'Y.TOTAL.CERITOS.GEN ' : Y.TOTAL.CERITOS.GEN

    Y.COUNT.ID = "CDF" : Y.ANIO.ACTUAL.FMT : Y.MES.ACTUAL
    Y.DATE = TIMEDATE()

    Y.TABLE.ID = Y.ACTUAL.CARD : Y.COUNT.ID: Y.DATE
    Y.VALUES = Y.COUNT.ID : "|" : Y.TOTAL.CARDS : "|" : Y.TOTAL.TXN : "|" : Y.TOTAL.CERITOS.GEN

    CALL F.WRITE(FN.COUNT,Y.TABLE.ID,Y.VALUES)
RETURN

END
