*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.L.ATH.TERM.LOC.NAME.LOAD

    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_F.DATES
    $INCLUDE TAM.BP I_F.REDO.ATH.SETTLMENT
    $INCLUDE TAM.BP I_REDO.L.ATH.TERM.LOC.NAME.COMMON

    FN.REDO.ATH.SETTLMENT='F.REDO.ATH.SETTLMENT'
    F.REDO.ATH.SETTLMENT =''
    CALL OPF(FN.REDO.ATH.SETTLMENT,F.REDO.ATH.SETTLMENT)

    YSTART.DATE = ''; YEND.DATE = ''
    YSTART.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    YEND.DATE = TODAY

    RETURN
END
