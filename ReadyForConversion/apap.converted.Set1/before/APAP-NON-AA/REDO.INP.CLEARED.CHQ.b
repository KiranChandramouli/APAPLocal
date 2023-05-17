*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INP.CLEARED.CHQ
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.INP.CLEARED.CHQ
*-------------------------------------------------------------------------
* Description: This routine is a Auto New Content routine
*
*----------------------------------------------------------
* Linked with:  FUNDS.TRANSFER,CH.RTN
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 21-09-10          ODR-2010-09-0251              Initial Creation
*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.REDO.CLEARING.OUTWARD

  GOSUB OPEN.FILE
  GOSUB PROCESS
  RETURN

OPEN.FILE:
*Opening Files

  FN.REDO.OUTWARD.CLEARING = 'F.REDO.CLEARING.OUTWARD'
  F.REDO.OUTWARD.CLEARING = ''
  CALL OPF(FN.REDO.OUTWARD.CLEARING,F.REDO.OUTWARD.CLEARING)

  RETURN

PROCESS:

*Get the Payment Details

  VAR.PAY.DETAILS = R.NEW(FT.PAYMENT.DETAILS)

* Read REDO.CLEARING.OUTWARD and get the status and raise the override

  CALL F.READ(FN.REDO.OUTWARD.CLEARING,VAR.PAY.DETAILS,R.REDO.OUTWARD.CLEARING,F.REDO.OUTWARD.CLEARING,OUTWARD.ERR)
  VAR.CHQ.STATUS = R.REDO.OUTWARD.CLEARING<CLEAR.OUT.CHQ.STATUS>
  IF VAR.CHQ.STATUS EQ "CLEARED" THEN
    CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),VM) + 1
    TEXT = "CLEARED.CHEQUE"
    CALL STORE.OVERRIDE(CURR.NO)
  END
  RETURN
END
