SUBROUTINE L.APAP.UP.MENOR.EDAD

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

    Y.DIR.NAME='../interface/T24MENOREDAD'
    Y.FILE.NAME='MENOR.EDAD.TXT'

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    OPENSEQ Y.DIR.NAME,Y.FILE.NAME TO FV.PRT ELSE
        CALL OCOMO("CANNOT OPEN DIR")
    END

    LOOP
        READSEQ Y.REC FROM FV.PRT ELSE EOF = 1
    WHILE NOT(EOF)

        Y.TXN.TYPE=FIELD(Y.REC,",",1)

        SELECT.STATEMENT = 'SELECT ':FN.ACCOUNT : ' WITH @ID EQ ' : Y.TXN.TYPE : ' AND L.AC.NOTIFY.1 UNLIKE ...CLIENTE.MENOR...'
        ACCOUNT.LIST = ''
        LIST.NAME = ''
        SELECTED = ''
        SYSTEM.RETURN.CODE = ''
        CALL EB.READLIST(SELECT.STATEMENT,ACCOUNT.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

        LOOP
            REMOVE ACCOUNT.ID FROM ACCOUNT.LIST SETTING ACCOUNT.MARK
        WHILE ACCOUNT.ID : ACCOUNT.MARK

            R.ACCOUNT = ''
            YERR = ''
            CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,YERR)

            Y.TRANS.ID = ACCOUNT.ID

            Y.APP.NAME = "ACCOUNT"

            Y.VER.NAME = Y.APP.NAME :",MB.DM.LOAD"

            Y.FUNC = "I"

            Y.PRO.VAL = "PROCESS"

            Y.GTS.CONTROL = ""

            Y.NO.OF.AUTH = ""

            FINAL.OFS = ""

            OPTIONS = ""

            Y.CAN.NUM = 0

            Y.CAN.MULT = ""

            R.ACC = ""

            CALL GET.LOC.REF("ACCOUNT","L.AC.NOTIFY.1",ACC.POS)

            Y.CAN.MULT = R.ACCOUNT<AC.LOCAL.REF,ACC.POS>

            Y.CAN.NUM = DCOUNT(Y.CAN.MULT,@VM)

            Y.CAN.NUM += 1

            R.ACC<AC.LOCAL.REF,ACC.POS,Y.CAN.NUM> = "CLIENTE.MENOR"

            CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.ACC,FINAL.OFS)

*            CALL OFS.GLOBUS.MANAGER("MENOR.UPDATE", FINAL.OFS)

            OFS.MSG.ID = ''
            OFS.SOURCE.ID = "MENOR.UPDATE"
            OPTIONS = ''

            CALL OFS.POST.MESSAGE(FINAL.OFS,OFS.MSG.ID,OFS.SOURCE.ID,OPTIONS)

*            CALL JOURNAL.UPDATE('')

        REPEAT

    REPEAT
    CLOSESEQ FV.PRT

END
