*-------------------------------------------------------------------------
* <Rating>-20</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE REDO.CONVERT.AZ.ACCOUNT
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* display the field description of AZ.ACCOUNT instead of the ID
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 16-SEP-2011         RIYAS      ODR-2011-07-0162     Initial Creation
*-------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ACCOUNT

  GOSUB INITIALSE
  GOSUB CHECK.NOTES

  RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~~

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  LREF.APP = 'ACCOUNT'
  LREF.FIELDS = 'L.AC.AZ.ACC.REF'
  LREF.POS=''
  CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
  Y.AZ.REF.POS = LREF.POS<1,1>

  RETURN
*-------------------------------------------------------------------------
CHECK.NOTES:
*~~~~~~~~~~~
  Y.REC.DATA = O.DATA
  CALL F.READ(FN.ACCOUNT,Y.REC.DATA,R.ACCOUNT,F.ACCOUNT,AC.ERR)
  O.DATA = R.ACCOUNT<AC.LOCAL.REF,Y.AZ.REF.POS>
  RETURN
*-------------------------------------------------------------------------
END
