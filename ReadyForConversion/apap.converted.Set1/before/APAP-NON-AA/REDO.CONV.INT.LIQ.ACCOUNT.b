*-------------------------------------------------------------------------
* <Rating>-20</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.INT.LIQ.ACCOUNT
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* display the field description of EB.LOOKUP instead of the ID.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 16-SEP-2011         RIYAS      ODR-2011-07-0162     Initial Creation
*-------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.EB.LOOKUP
$INSERT I_F.ACCOUNT
$INSERT I_F.AZ.ACCOUNT
  AZ.INTEREST.LIQU.ACCT
  GOSUB INITIALSE
  GOSUB CHECK.NOTES

  RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~~

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  LOC.REF.APPLICATION="ACCOUNT"
  LOC.REF.FIELDS='L.AC.REINVESTED'
  LOC.REF.POS=''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  POS.L.AC.REINVESTED = LOC.REF.POS<1,1>
  RETURN
*-------------------------------------------------------------------------
CHECK.NOTES:
*~~~~~~~~~~~

  Y.REC.DATA = O.DATA
  CALL F.READ(FN.ACCOUNT,Y.REC.DATA,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
  Y.LIQ.STATUS = R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.REINVESTED>

  IF Y.LIQ.STATUS EQ 'YES' THEN
    CALL F.READ(FN.AZ.ACCOUNT,Y.REC.DATA,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
    Y.LIQ.ACCT = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
    O.DATA = Y.LIQ.ACCT
  END ELSE
    O.DATA = ''
  END
  RETURN
*-------------------------------------------------------------------------
END
