*-------------------------------------------------------------------------
* <Rating>-20</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.CLAIMS.L.AC.STATUS
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

  GOSUB INITIALSE
  GOSUB CHECK.NOTES

  RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~~

  FN.EB.LOOKUP = 'F.EB.LOOKUP'
  F.EB.LOOKUP  = ''
  CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

  RETURN
*-------------------------------------------------------------------------
CHECK.NOTES:
*~~~~~~~~~~~

  Y.LOOKUP.ID = O.DATA
  CALL F.READ(FN.EB.LOOKUP,Y.LOOKUP.ID,R.LOOKUP,F.EB.LOOKUP,LOOKUP.ERR)
  IF LNGG EQ 1 THEN
    O.DATA=R.LOOKUP<EB.LU.DESCRIPTION,1>
    RETURN
  END
  IF LNGG EQ 2 THEN
    IF R.LOOKUP<EB.LU.DESCRIPTION,2> THEN
      O.DATA = R.LOOKUP<EB.LU.DESCRIPTION,2>
    END ELSE
      O.DATA = R.LOOKUP<EB.LU.DESCRIPTION,1>
    END
  END

  RETURN
*-------------------------------------------------------------------------
END
