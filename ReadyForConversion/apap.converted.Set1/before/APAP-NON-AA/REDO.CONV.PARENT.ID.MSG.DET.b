*-------------------------------------------------------------------------
* <Rating>0</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.PARENT.ID.MSG.DET
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* display the field description of EB.LOOKUP instead of the ID.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 07-03-2012         RIYAS      ODR-2012-03-0162     Initial Creation
*-------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.EB.SECURE.MESSAGE
$INSERT I_F.TELLER
$INSERT I_F.REDO.AUT.INP.VERSION.NAME
$INSERT I_ENQUIRY.COMMON

  FN.EB.SECURE.MESSAGE = 'F.EB.SECURE.MESSAGE'
  F.EB.SECURE.MESSAGE  = ''
  CALL OPF(FN.EB.SECURE.MESSAGE,F.EB.SECURE.MESSAGE)

  FN.CUSTOMER  = 'F.CUSTOMER'
  F.CUSTOMER   = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  Y.TXN.DETAILS   = ''


  CALL F.READ(FN.EB.SECURE.MESSAGE,O.DATA,R.EB.SECURE.MESSAGE,F.EB.SECURE.MESSAGE,EB.SECURE.MESSAGE.ERR)
  Y.PARENT.MSG.ID = R.EB.SECURE.MESSAGE<EB.SM.PARENT.MESSAGE.ID>
  O.DATA = R.EB.SECURE.MESSAGE<EB.SM.MESSAGE>
  IF Y.PARENT.MSG.ID THEN
    CALL F.READ(FN.EB.SECURE.MESSAGE,Y.PARENT.MSG.ID,R.EB.SECURE.MESSAGE,F.EB.SECURE.MESSAGE,EB.SECURE.MESSAGE.ERR)
    O.DATA = R.EB.SECURE.MESSAGE<EB.SM.MESSAGE>

  END

  RETURN
