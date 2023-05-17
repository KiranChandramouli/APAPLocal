*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INP.UPD.ADM.MGR.CHQ
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: MARIMUTHU S
* PROGRAM NAME: REDO.INP.UPD.ADM.MGR.CHQ
* ODR NO      : PACS00062902
*----------------------------------------------------------------------
*DESCRIPTION: This routine is input routine attached with FT,CHQ.OTHERS.LOAN.DUM to get the cheque number for admin as well as manager chq

*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER & FT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*18-07-2011  Marimuthu                      PACS00062902
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.ACCOUNT

  GOSUB PROCESS

  RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  IF APPLICATION EQ "FUNDS.TRANSFER" THEN

    VAR.CR.ACCT.NO = R.NEW(FT.CREDIT.ACCT.NO)

    CALL F.READ(FN.ACCOUNT,VAR.CR.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    VAR.CUST = R.ACCOUNT<AC.CUSTOMER>
    IF NOT(VAR.CUST) THEN
      CALL REDO.VCR.CHEQUE.NUMBER
    END ELSE
      CALL REDO.V.INP.DEFAULT.ACCT
    END
  END

  RETURN
*--------------------------------------------------
END
