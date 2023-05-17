*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.V.STATUS.CHK
*-------------------------------------------------------------------------
*DESCRIPTION:
*~~~~~~~~~~~~
* This routine is attached as the validation routine for the versions REDO.ADMIN.CHQ.DETAILS,STOP.PAY
*

*-------------------------------------------------------------------------
*DEVELOPMENT DETAILS:
*~~~~~~~~~~~~~~~~~~~~
*
*   Date               who           Reference            Description
*   ~~~~               ~~~           ~~~~~~~~~            ~~~~~~~~~~~
* 2-JUN-2010     SHANKAR RAJU     ODR-2010-03-0447     Initial Creation
* 23-MAY-2010    Bharath          PACS00023955         Reclassify status added
*-------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.ADMIN.CHQ.DETAILS


  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------
PROCESS:

* PACS00023955 - S
*IF R.OLD(ADMIN.CHQ.DET.STATUS) EQ 'PAID' OR R.OLD(ADMIN.CHQ.DET.STATUS) EQ 'CANCELLED' OR R.OLD(ADMIN.CHQ.DET.STATUS) EQ 'REISSUED' OR R.OLD(ADMIN.CHQ.DET.STATUS) EQ 'REINSTATED' THEN
  IF R.OLD(ADMIN.CHQ.DET.STATUS) EQ 'PAID' OR R.OLD(ADMIN.CHQ.DET.STATUS) EQ 'RECLASSIFY' OR  R.OLD(ADMIN.CHQ.DET.STATUS) EQ 'CANCELLED' OR R.OLD(ADMIN.CHQ.DET.STATUS) EQ 'REISSUED' OR R.OLD(ADMIN.CHQ.DET.STATUS) EQ 'REINSTATED' THEN
* PACS00023955 - E
    IF R.NEW(ADMIN.CHQ.DET.STATUS) EQ 'STOP.PAID.CNFRM' OR R.NEW(ADMIN.CHQ.DET.STATUS) EQ 'STOP.PAID.NON.CNFRM' THEN
      AF=ADMIN.CHQ.DET.STATUS
      ETEXT='EB-REDO.ADMIN.BLOCK':FM:R.OLD(ADMIN.CHQ.DET.STATUS)
      CALL STORE.END.ERROR
    END
  END
  RETURN
END
