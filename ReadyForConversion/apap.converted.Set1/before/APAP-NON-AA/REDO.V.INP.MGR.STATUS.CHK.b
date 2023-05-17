*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.V.INP.MGR.STATUS.CHK
*-------------------------------------------------------------------------
*DESCRIPTION:
*~~~~~~~~~~~~
* This routine is attached as the validation routine for the versions REDO.MGR.CHQ.DETAILS,STOP.PAY
*

*-------------------------------------------------------------------------
*DEVELOPMENT DETAILS:
*~~~~~~~~~~~~~~~~~~~~
*
*   Date               who           Reference            Description
*   ~~~~               ~~~           ~~~~~~~~~            ~~~~~~~~~~~
* 12-May-2010      Bharath G         ODR-2010-03-0447     Initial Creation
*-------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.MANAGER.CHQ.DETAILS

  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------
PROCESS:
  IF R.OLD(MAN.CHQ.DET.STATUS) EQ 'PAID' OR R.OLD(MAN.CHQ.DET.STATUS) EQ 'CANCELLED' OR R.OLD(MAN.CHQ.DET.STATUS) EQ 'REISSUED' OR R.OLD(MAN.CHQ.DET.STATUS) EQ 'REINSTATED' THEN
    IF R.NEW(MAN.CHQ.DET.STATUS) EQ 'STOP.PAID.CNFRM' OR R.NEW(MAN.CHQ.DET.STATUS) EQ 'STOP.PAID.NON.CNFRM' THEN
      AF=MAN.CHQ.DET.STATUS
      ETEXT='EB-REDO.ADMIN.BLOCK':FM:R.OLD(MAN.CHQ.DET.STATUS)
      CALL STORE.END.ERROR
    END
  END
  RETURN
END
