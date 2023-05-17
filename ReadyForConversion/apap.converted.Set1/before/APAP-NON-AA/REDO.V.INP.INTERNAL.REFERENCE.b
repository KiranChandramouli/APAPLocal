*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.INTERNAL.REFERENCE

*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep S
* Program Name  : REDO.V.INP.INTERNAL.REFERENCE
*-------------------------------------------------------------------------
* Description: This routine is input routine to default
*              DEBIT.THIER.REFERENCE/CREDIT.THEIR.REFERENCE for FUNDS.TRANSFER.
*-------------------------------------------------------------------------
* Linked with   :
* In parameter  :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------
* DATE         Name          ODR / HD REF              DESCRIPTION
* 14-09-12     Pradeep S     PACS00183693              Initial creation
*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER

  GOSUB INIT
  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN

PROCESS:
*********

  BEGIN CASE

  CASE APPLICATION EQ "FUNDS.TRANSFER"
    IF R.NEW(FT.DEBIT.ACCT.NO) THEN
      Y.ACCT.ID = R.NEW(FT.DEBIT.ACCT.NO)
      GOSUB READ.ACCT
      IF Y.AA.FLAG THEN
        R.NEW(FT.DEBIT.THEIR.REF) = Y.ACCT.ID
        RETURN
      END
    END

    IF R.NEW(FT.DEBIT.ACCT.NO) MATCHES "3A..." THEN
      Y.ACCT.ID = R.NEW(FT.CREDIT.ACCT.NO)
      GOSUB READ.ACCT
      IF Y.AA.FLAG THEN
        R.NEW(FT.CREDIT.THEIR.REF) = Y.ACCT.ID
        RETURN
      END
    END

  END CASE

  RETURN

READ.ACCT:
***********

  R.ACC = ''
  Y.AA.ID = ''
  CALL F.READ(FN.ACCT,Y.ACCT.ID,R.ACC,F.ACCT,ERR.ACC)
  IF R.ACC AND R.ACC<AC.ARRANGEMENT.ID> MATCHES "AA..." THEN
    Y.AA.FLAG = @TRUE
    Y.AA.ID = R.ACC<AC.ARRANGEMENT.ID>
  END
  RETURN


INIT:
******

  Y.AA.FLAG = @FALSE
  Y.ACCT.ID = ''

  RETURN

OPEN.FILES:
************

  FN.ACCT = 'F.ACCOUNT'
  F.ACCT = ''
  CALL OPF(FN.ACCT,F.ACCT)

  RETURN

END
