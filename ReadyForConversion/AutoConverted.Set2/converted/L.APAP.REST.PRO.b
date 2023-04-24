SUBROUTINE L.APAP.REST.PRO

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.RESTRICTIVE.LIST


    Y.APP.NAME= 'REDO.RESTRICTIVE.LIST'
    Y.VER.NAME= 'REDO.RESTRICTIVE.LIST,INPUT'

    FN.REDO.REST = 'F.REDO.RESTRICTIVE.LIST'
    FV.REDO.REST = ''
    CALL OPF(FN.REDO.REST,FV.REDO.REST)

    SELECT.STATEMENT = 'SELECT ':FN.REDO.REST : " WITH LISTA.RESTRICTIVA EQ CEDULAS.CANCELADAS "
    REST.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    CALL EB.READLIST(SELECT.STATEMENT,REST.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)


    LOOP
        REMOVE REST.ID FROM REST.LIST SETTING REST.MARK
    WHILE REST.ID : REST.MARK

        Y.TRANS.ID = REST.ID

        Y.APP.NAME = "REDO.RESTRICTIVE.LIST"

        Y.VER.NAME = Y.APP.NAME :",INPUT"

        Y.FUNC = "R"

        Y.PRO.VAL = "PROCESS"

        Y.GTS.CONTROL = ""

        Y.NO.OF.AUTH = ""

        FINAL.OFS = ""

        OPTIONS = ""

        Y.CAN.NUM = 0

        Y.CAN.MULT = ""

        R.ACC = ""

        CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.ACC,FINAL.OFS)

        CALL OFS.GLOBUS.MANAGER("DM.OFS.SRC.VAL", FINAL.OFS)


    REPEAT

    PRINT @(17,14) : "PRESIONAR TECLA PARA TERMINAR"
    INPUT XX

END