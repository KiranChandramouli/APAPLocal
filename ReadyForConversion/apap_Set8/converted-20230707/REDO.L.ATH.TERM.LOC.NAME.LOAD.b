SUBROUTINE REDO.L.ATH.TERM.LOC.NAME.LOAD

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.ATH.SETTLMENT
    $INSERT I_REDO.L.ATH.TERM.LOC.NAME.COMMON

    FN.REDO.ATH.SETTLMENT='F.REDO.ATH.SETTLMENT'
    F.REDO.ATH.SETTLMENT =''
    CALL OPF(FN.REDO.ATH.SETTLMENT,F.REDO.ATH.SETTLMENT)

    YSTART.DATE = ''; YEND.DATE = ''
    YSTART.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    YEND.DATE = TODAY

RETURN
END
