$PACKAGE APAP.TAM
** 19-04-2023 R22 Auto Conversion no changes
** 19-04-2023 Skanda R22 Manual Conversion - No changes

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
