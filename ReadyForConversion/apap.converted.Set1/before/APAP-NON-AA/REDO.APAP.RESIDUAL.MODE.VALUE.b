*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.RESIDUAL.MODE.VALUE
*----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEYACHANDRAN S
* PROGRAM NAME:
* ODR NO      :
*----------------------------------------------------------------------
* DESCRIPTION  :This routine is used to check the transactions are entering properly or not in payment mode
*               based upon the residual mode value. *
* IN PARAMETER :NA
* OUT PARAMETER:NA
* LINKED WITH  :
* LINKED FILE  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                 REFERENCE           DESCRIPTION
* 28.09.2010   Jeyachandran S                           INITIAL CREATION
*-------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.MULTI.TRANSACTION.SERVICE
$INSERT I_F.ACCOUNT
$INSERT I_F.ACCT.ACTIVITY

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROCESS
  GOSUB GOEND
  RETURN
*---------
INIT:
  RETURN

*--------------
OPENFILES:

  FN.MULTI.TRANSACTION.SERVICE = 'F.MULTI.TRANSACTION.SERVICE'
  F.MULTI.TRANSACTION.SERVICE = ''
  CALL OPF(FN.MULTI.TRANSACTION.SERVICE,F.MULTI.TRANSACTION.SERVICE)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.ACCT.ACTIVITY = 'F.ACCT.ACTIVITY'
  F.ACCT.ACTIVITY = ''
  CALL OPF(FN.ACCT.ACTIVITY,F.ACCT.ACTIVITY)
  RETURN
*-------------
PROCESS:

  Y.SET.MODE.VAL = COMI
  Y.SET.MODE = R.NEW(REDO.MTS.SETTLEMENT.MODE)

  IF (Y.SET.MODE EQ 'CHEQUE' AND Y.SET.MODE.VAL EQ 'CHEQUE') THEN
    R.NEW(REDO.MTS.VERSION.1) = ''
    R.NEW(REDO.MTS.VERSION.2) = ''
    R.NEW(REDO.MTS.VERSION.3) = ''
  END

  IF (Y.SET.MODE EQ 'CHEQUE' AND Y.SET.MODE.VAL EQ '') THEN
    R.NEW(REDO.MTS.VERSION.1) = ''
    R.NEW(REDO.MTS.VERSION.2) = ''
    R.NEW(REDO.MTS.VERSION.3) = ''
  END

  Y.RESIDUAL.VAL = R.NEW(REDO.MTS.RESIDUAL)
  IF Y.RESIDUAL.VAL EQ 'NO' THEN
    T(REDO.MTS.RESIDUAL.MODE)<3> = 'NOINPUT'
  END

  RETURN
*--------------
GOEND:
END
