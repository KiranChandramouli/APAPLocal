SUBROUTINE TOT.AMT.RTN(Y.DATA)

    $INSERT I_COMMON
    $INSERT I_EQUATE


    REFUND.AMOUNT=''
    VAT.AMOUNT=''

    REFUND.AMOUNT = Y.DATA

    VAT.AMOUNT = REFUND.AMOUNT * 0.06


    Y.DATA=REFUND.AMOUNT+VAT.AMOUNT

RETURN

END
