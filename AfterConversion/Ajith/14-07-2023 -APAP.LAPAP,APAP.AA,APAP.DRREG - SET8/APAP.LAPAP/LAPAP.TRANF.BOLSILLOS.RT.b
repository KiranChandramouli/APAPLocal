$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     T24.BP ,BP is Removed
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   NO CHANGE
*---------------------------------------------------------------------------------------	-
SUBROUTINE LAPAP.TRANF.BOLSILLOS.RT

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.VERSION ;*R22 Auto code conversion
    $INSERT I_F.COMPANY
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.ACCOUNT
    $INSERT I_F.L.APAP.TRANS.BOLSILLO ;*R22 Auto code conversion


    GOSUB LOAD
    GOSUB PROCESS
*====
LOAD:
*====
    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    Y.BOL.DEBIT                 = R.NEW(ST.L.A19.BOLSILLO.DEBITO)
    Y.MON.TRANS                 = R.NEW(ST.L.A19.MONTO)

RETURN

*======
PROCESS:
*======

    R.AC.LOCKED =''; AC.LOCKED.ERR = ''
    CALL F.READ(FN.AC.LOCKED.EVENTS,Y.BOL.DEBIT,R.AC.LOCKED,F.AC.LOCKED.EVENTS,AC.LOCKED.ERR)

    Y.MON.DEBIT         = R.AC.LOCKED<AC.LCK.LOCKED.AMOUNT>

    Y.NEW.BAL           = Y.MON.DEBIT - Y.MON.TRANS
    Y.FINAL.BAL = ABS(Y.NEW.BAL)

    IF Y.MON.TRANS GT Y.MON.DEBIT THEN
        TEXT = "El bosillo: ":Y.BOL.DEBIT:" no posee fondos suficientes. Fondos actuales del bolsillo: ":Y.MON.DEBIT
        ETEXT = TEXT
        E = TEXT
        CALL ERR
    END

    Y.TRANS.ID                          = Y.BOL.DEBIT;
    Y.APP.NAME                          = "AC.LOCKED.EVENTS";
    Y.VER.NAME                          = Y.APP.NAME :",L.APAP.UPDATE.BOL";
    Y.FUNC                              = "I";
    Y.PRO.VAL                           = "PROCESS";
    Y.GTS.CONTROL                       = "";
    Y.NO.OF.AUTH                        = "0";
    FINAL.OFS                           = "";

    R.AC.LOCKED<AC.LCK.LOCKED.AMOUNT>           = Y.FINAL.BAL

    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.AC.LOCKED,FINAL.OFS)

    OFS.MSG.ID = ''; OFS.SOURCE.ID = "OFSBLSILLO"; OPTIONS = ''
    CALL OFS.POST.MESSAGE(FINAL.OFS,OFS.MSG.ID,OFS.SOURCE.ID,OPTIONS)
*CALL JOURNAL.UPDATE(Y.BOL.DEBIT)

RETURN

END
