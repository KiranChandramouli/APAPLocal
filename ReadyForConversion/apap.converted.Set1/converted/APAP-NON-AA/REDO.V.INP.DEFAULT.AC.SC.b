SUBROUTINE REDO.V.INP.DEFAULT.AC.SC

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.REDO.SC.MM.VERSION.PARAM

MAIN:


    FN.REDO.SC.MM.VERSION.PARAM = 'F.REDO.SC.MM.VERSION.PARAM'
    F.REDO.SC.MM.VERSION.PARAM = ''
    CALL OPF(FN.REDO.SC.MM.VERSION.PARAM,F.REDO.SC.MM.VERSION.PARAM)

    Y.ID = APPLICATION:PGM.VERSION
    CALL F.READ(FN.REDO.SC.MM.VERSION.PARAM,Y.ID,R.REDO.SC.MM.VERSION.PARAM,F.REDO.SC.MM.VERSION.PARAM,PAR.ERR)

    Y.CUR = R.NEW(SC.SBS.SECURITY.CURRENCY)

    LOCATE Y.CUR IN R.REDO.SC.MM.VERSION.PARAM<REDO.SMV.CURRENCY,1> SETTING POS THEN
        R.NEW(SC.SBS.BR.ACC.NO) = R.REDO.SC.MM.VERSION.PARAM<REDO.SMV.ACCOUNT,POS>
    END
RETURN

END
