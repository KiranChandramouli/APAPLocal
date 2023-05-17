*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE VAT.RTN(Y.DATA)

    $INSERT I_COMMON
    $INSERT I_EQUATE

    REFUND.AMOUNT=''
    VAT.AMOUNT=''


    LEN.AMT = LEN(Y.DATA)
    Y.DATA = Y.DATA[4,LEN.AMT]
    Y.DATA = FMT(Y.DATA, "12R,2")


    RETURN
END

