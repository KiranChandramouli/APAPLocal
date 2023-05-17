*-----------------------------------------------------------------------------
* <Rating>-38</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.PART.AMT.CHK

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER
*    $INCLUDE TAM.BP I_REDO.V.PART.PYMT.RULE1.COMMON
$INSERT I_System

* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU
* PROGRAM NAME : REDO.VAL.PART.AMT.CHK
*----------------------------------------------------------


* DESCRIPTION : This routine is a validation routine attached
* to AMOUNT.LOCAL.1 of TELLER,AA.PART.PYMNT & CREDIT.ACCOUNT.NO of FUNDS.TRANSFER,AA.PART.PYMT
* model bank version to do overpayment validations
* MODIFIED FOR : PACS00084115
*------------------------------------------------------------
MAIN:

  GOSUB PROCESS
  GOSUB PGM.END

PROCESS:

  Y.COMI = COMI
  IF Y.COMI EQ '' THEN
    RETURN
  END ELSE
    IF APPLICATION EQ 'TELLER' THEN
      Y.PART.AMT = System.getVariable("CURRENT.PART.AMT")
      R.NEW(TT.TE.VALUE.DATE.2) = TODAY
      IF Y.COMI LT Y.PART.AMT THEN
        AF = TT.TE.AMOUNT.LOCAL.1
        ETEXT = 'EB-REDO.LESS.PARTL.PYMT'
        CALL STORE.END.ERROR
      END
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
      Y.PART.AMT = System.getVariable("CURRENT.PART.AMT")
      IF Y.COMI LT Y.PART.AMT THEN
        AF = FT.CREDIT.AMOUNT
        ETEXT = 'EB-REDO.LESS.PARTL.PYMT'
        CALL STORE.END.ERROR
      END
    END
  END

  RETURN

PGM.END:

END
