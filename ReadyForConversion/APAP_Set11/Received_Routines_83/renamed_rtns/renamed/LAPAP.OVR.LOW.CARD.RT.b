*-----------------------------------------------------------------------------
* <Rating>-61</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.OVR.LOW.CARD.RT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.COMPANY
    $INSERT BP I_F.LAPAP.BIN.SEQ.CTRL
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT TAM.BP I_F.REDO.CARD.GENERATION

*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    IF V$FUNCTION NE "R" OR R.NEW(REDO.CARD.GEN.RECORD.STATUS) NE 'RNAU' THEN
        GOSUB OPEN.PARA
        GOSUB PROCESS.PARA
    END

    RETURN
*--------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened


    FN.BIN.CTRL = "F.ST.LAPAP.BIN.SEQ.CTRL"
    F.BIN.CTRL = ""
    CALL OPF(FN.BIN.CTRL , F.BIN.CTRL)

    FN.REDO.H.REPORT.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORT.PARAM = 'F.REDO.H.REPORTS.PARAM'
    CALL OPF(FN.REDO.H.REPORT.PARAM,F.REDO.H.REPORT.PARAM)


    RETURN
*---------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
    Y.BIN.REC = R.NEW(REDO.CARD.GEN.BIN)
    IF LEN(Y.BIN.REC)  EQ 6 THEN
        Y.BIN.REC := '00'
    END
    GOSUB DO.READ.PARAM
    GOSUB DO.READ.CTRL

    Y.BIN = R.NEW(REDO.CARD.GEN.BIN)
    GOSUB DO.OVR
    RETURN

DO.READ.PARAM:
    CALL F.READ(FN.REDO.H.REPORT.PARAM, "RANDOM.PAN", R.PARAM1, F.REDO.H.REPORT.PARAM, PARAM1.ERR)

    FIND "CAP.COUNT.BIN" IN R.PARAM1<REDO.REP.PARAM.FIELD.NAME> SETTING F.POS, V.POS THEN
        Y.CAP.NUMBER = R.PARAM1<REDO.REP.PARAM.FIELD.VALUE,V.POS>
    END

    FIND "AVL.ALERT.COUNT" IN R.PARAM1<REDO.REP.PARAM.FIELD.NAME> SETTING F.POS, V.POS THEN
        Y.ALERT.NUMBER = R.PARAM1<REDO.REP.PARAM.FIELD.VALUE,V.POS>
    END

    RETURN

DO.READ.CTRL:

    CALL F.READ(FN.BIN.CTRL, Y.BIN.REC, R.B.C, F.BIN.CTRL, BIN.CTRL.ERR)

    Y.AVL = R.B.C<ST.LAP73.AVL.COUNT>
    RETURN

DO.OVR:
    IF Y.AVL NE '' AND (Y.AVL LE Y.ALERT.NUMBER) THEN

        CURRNO = DCOUNT(R.NEW(REDO.CARD.GEN.CURR.NO),VM) + 1
        TEXT = 'LAPAP.LOW.CARD.AVL' : FM : Y.AVL
        CALL STORE.OVERRIDE(CURRNO)
    END
    RETURN
END
