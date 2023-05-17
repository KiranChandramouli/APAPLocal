*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AUTH.UPD.WAIVE.LEDGER.ACCT
*-------------------------------------------------------------------L-------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.AUTH.UPD.WAIVE.LEDGER.ACCT
*--------------------------------------------------------------------------------
* Description: This routine is for updating local concat file for WAIVE LEDGER FEE is set to yes
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 02-12-2011      Jeeva T     For COB Performance
*
*----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT

  GOSUB OPEN.FILE

  GOSUB PROCESS.FILE

  RETURN

*---------------------------------------------------------------------------------
OPEN.FILE:
*---------------------------------------------------------------------------------
  FN.REDO.WAIVE.LEDGER.ACCT = 'F.REDO.WAIVE.LEDGER.ACCT'
  F.REDO.WAIVE.LEDGER.ACCT = ''
  CALL OPF(FN.REDO.WAIVE.LEDGER.ACCT,F.REDO.WAIVE.LEDGER.ACCT)

  RETURN
*---------------------------------------------------------------------------------
PROCESS.FILE:
*---------------------------------------------------------------------------------

  Y.TRANS.ID = APPLICATION
  IF R.NEW(AC.WAIVE.LEDGER.FEE) EQ 'Y' THEN
    GOSUB INSERT.CONCAT.TABLE
  END
  IF R.NEW(AC.WAIVE.LEDGER.FEE) NE 'Y' THEN
    GOSUB DELETE.CONCAT.TABLE
  END
  RETURN
*----------------------
INSERT.CONCAT.TABLE:
*----------------------

  CALL F.READ(FN.REDO.WAIVE.LEDGER.ACCT,Y.TRANS.ID,R.REDO.WAIVE.LEDGER.ACCT,F.REDO.WAIVE.LEDGER.ACCT,LED.ERR)
  LOCATE ID.NEW IN R.REDO.WAIVE.LEDGER.ACCT SETTING PO ELSE
    R.REDO.WAIVE.LEDGER.ACCT<-1> = ID.NEW
    CALL F.WRITE(FN.REDO.WAIVE.LEDGER.ACCT,Y.TRANS.ID,R.REDO.WAIVE.LEDGER.ACCT)
  END
  RETURN
*----------------------
DELETE.CONCAT.TABLE:
*----------------------
  CALL F.READ(FN.REDO.WAIVE.LEDGER.ACCT,Y.TRANS.ID,R.REDO.WAIVE.LEDGER.ACCT,F.REDO.WAIVE.LEDGER.ACCT,LED.ERR)
  LOCATE ID.NEW IN R.REDO.WAIVE.LEDGER.ACCT SETTING PO THEN
    DEL R.REDO.WAIVE.LEDGER.ACCT<PO>
    CALL F.WRITE(FN.REDO.WAIVE.LEDGER.ACCT,Y.TRANS.ID,R.REDO.WAIVE.LEDGER.ACCT)
  END
  RETURN
*----------------------
END
