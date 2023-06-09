SUBROUTINE LAPAP.REV.ABONO.CHARG

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.L.APAP.GENERACION.CARGO
    $INSERT I_F.L.APAP.LIMITE.ABONADO

    GOSUB LOAD
    GOSUB PROCESS

*****
LOAD:
*****
    Y.FT.ID = ID.NEW.LAST

    FN.ST.L.APAP.GENERACION.CARGO = "F.ST.L.APAP.GENERACION.CARGO"
    FV.ST.L.APAP.GENERACION.CARGO = ""
    CALL OPF (FN.ST.L.APAP.GENERACION.CARGO,FV.ST.L.APAP.GENERACION.CARGO)

    FN.ST.L.APAP.LIMITE.ABONADO = "F.ST.L.APAP.LIMITE.ABONADO"
    F.ST.L.APAP.LIMITE.ABONADO = ""
    CALL OPF (FN.ST.L.APAP.LIMITE.ABONADO,F.ST.L.APAP.LIMITE.ABONADO)

    FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER"
    FV.FUNDS.TRANSFER = ""
    CALL OPF (FN.FUNDS.TRANSFER,FV.FUNDS.TRANSFER)

RETURN

********
PROCESS:
********
    SEL.CMD = ''; SEL.LIST = ''; NO.OF.REC = ''; SEL.ERR = ''
    SEL.CMD = " SELECT " : FN.ST.L.APAP.LIMITE.ABONADO: " WITH TRANSACTION EQ ":Y.FT.ID
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR)

    Y.CHARGE.ID = SEL.LIST
    R.CHARGE = ""; ERR.CHARGE = " "
    CALL F.READ (FN.ST.L.APAP.LIMITE.ABONADO,Y.CHARGE.ID,R.CHARGE,F.ST.L.APAP.LIMITE.ABONADO,ERR.CHARGE)
    Y.TRANSACTION.ID = R.CHARGE<ST.L.A61.TRANSACTION>

    IF Y.TRANSACTION.ID EQ Y.FT.ID THEN

        Y.APP.NAME                          = 'ST.L.APAP.LIMITE.ABONADO';
        Y.VER.NAME                          = Y.APP.NAME:',REVERS';
        Y.FUNC                              = 'R';
        Y.PRO.VAL                           = "PROCESS";
        Y.GTS.CONTROL                       = "";
        Y.NO.OF.AUTH                        = "";
        FINAL.OFS                           = "";
        Y.TRANS.ID                          = Y.CHARGE.ID;

        CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.CHARGE,FINAL.OFS)
        OFS.MSG.ID = ''; OFS.SOURCE.ID = "OFS.CARGO"; OPTIONS = ''
        CALL OFS.POST.MESSAGE(FINAL.OFS,OFS.MSG.ID,OFS.SOURCE.ID,OPTIONS)
    END
RETURN
END
