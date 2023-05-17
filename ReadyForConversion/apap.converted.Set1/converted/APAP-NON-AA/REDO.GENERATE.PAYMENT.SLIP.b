SUBROUTINE REDO.GENERATE.PAYMENT.SLIP
*-----------------------------------------------------------------------------
*Description: This routine is to produce the deal of Loan Repayment during Authorisation.

    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB PROCESS

RETURN
*-------------------------------------------------
PROCESS:
*-------------------------------------------------

    OFS$DEAL.SLIP.PRINTING = 1
    DEAL.SLIP.CALL = 'FT.AA.PAY.RCPT'
    CALL PRODUCE.DEAL.SLIP(DEAL.SLIP.CALL)

RETURN
END
