*-------------------------------------------------------------------------
* <Rating>-20</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.OPP.STATUS.DESC
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry REDO.CONTACT.ENQ>CONTACT.STATUS to
* display the field description of EB.LOOKUP instead of the ID.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 24-AUG-2011     SHANKAR RAJU     ODR-2011-07-0162     Initial Creation
*-------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.CR.OPPORTUNITY.STATUS

  GOSUB INITIALSE
  GOSUB CHECK.NOTES

  RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~~

  FN.CR.OPPORTUNITY.STATUS = 'F.CR.OPPORTUNITY.STATUS'
  F.CR.OPPORTUNITY.STATUS  = ''
  R.CR.OPPORTUNITY.STATUS  = ''
  CALL OPF(FN.CR.OPPORTUNITY.STATUS,F.CR.OPPORTUNITY.STATUS)

  RETURN
*-------------------------------------------------------------------------
CHECK.NOTES:
*~~~~~~~~~~~

  Y.REC.DATA = O.DATA

  CALL F.READ(FN.CR.OPPORTUNITY.STATUS,Y.REC.DATA,R.CR.OPPORTUNITY.STATUS,F.CR.OPPORTUNITY.STATUS,ERR.OPS)

  Y.DESC.OPS = R.CR.OPPORTUNITY.STATUS<CR.OPS.DESC,2>

  IF Y.DESC.OPS THEN
    O.DATA = Y.DESC.OPS
  END ELSE
    O.DATA = R.CR.OPPORTUNITY.STATUS<CR.OPS.DESC,1>
  END

  RETURN
*-------------------------------------------------------------------------
END
