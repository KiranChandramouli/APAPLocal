* @ValidationCode : MjotMzAxMTA2MTkwOkNwMTI1MjoxNjkyNzczMTM3ODYzOnZpY3RvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 Aug 2023 12:15:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-61</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*23-08-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED,VM TO @VM,FM TO @FM
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.OVR.LOW.CARD.RT
    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.LAPAP.BIN.SEQ.CTRL
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_F.REDO.CARD.GENERATION ;*R22 MANUAL CONVERSION END

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

        CURRNO = DCOUNT(R.NEW(REDO.CARD.GEN.CURR.NO),@VM) + 1 ;*R22 MANUAL CONVERSION
        TEXT = 'LAPAP.LOW.CARD.AVL' : @FM : Y.AVL ;*R22 MANUAL CONVERSION
        CALL STORE.OVERRIDE(CURRNO)
    END
RETURN
END
