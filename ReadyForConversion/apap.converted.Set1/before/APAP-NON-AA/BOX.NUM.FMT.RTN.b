*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE BOX.NUM.FMT.RTN(Y.DATA)

    $INSERT I_COMMON
    $INSERT I_EQUATE

    BOX.NUM = ''

    BOX.NUM = Y.DATA

    Y.DATA = FIELD(BOX.NUM, "-", 1, 1)

    RETURN

END

