*-------------------------------------------------------------------------
* <Rating>-20</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.CLAIMS.EB.CHANNEL
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* display the field description of EB.CHANNEL instead of the ID.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 16-SEP-2011         RIYAS      ODR-2011-07-0162     Initial Creation
*-------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.EB.CHANNEL

  GOSUB INITIALSE
  GOSUB CHECK.NOTES

  RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~~

  FN.EB.CHANNEL = 'F.EB.CHANNEL'
  F.EB.CHANNEL  = ''
  CALL OPF(FN.EB.CHANNEL,F.EB.CHANNEL)

  RETURN
*-------------------------------------------------------------------------
CHECK.NOTES:
*~~~~~~~~~~~
  Y.REC.DATA = O.DATA

  CALL F.READ(FN.EB.CHANNEL,Y.REC.DATA,R.EB.CHANNEL,F.EB.CHANNEL,LOOKUP.ERR)
  IF LNGG EQ 1 THEN
    O.DATA=R.EB.CHANNEL<EB.CHAN.DESC,1>
    RETURN
  END
  IF LNGG EQ 2 THEN
    IF R.EB.CHANNEL<EB.CHAN.DESC,2> THEN
      O.DATA = R.EB.CHANNEL<EB.CHAN.DESC,2>
    END ELSE
      O.DATA = R.EB.CHANNEL<EB.CHAN.DESC,1>
    END
  END

  RETURN
*-------------------------------------------------------------------------
END
