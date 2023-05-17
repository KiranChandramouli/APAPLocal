*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CLAIM.STATUS.MAP.ID
*------------------------------------------------------------------------------
*------------------------------------------------------------------------------
* DESCRIPTION : This routine is used to check the ID value for the table
* REDO.CLAIM.STATUS.MAP
*------------------------------------------------------------------------------
*------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : PRADEEP S
* PROGRAM NAME : REDO.CLAIM.STATUS.MAP.ID
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE           DESCRIPTION
* 13-MAY-2011      Pradeep S          PACS00060849        INITIAL CREATION
* ----------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE

  GOSUB PROCESS
  RETURN

********
PROCESS:
********
  Y.ID = ID.NEW
  Y.VALID.ID = 'REDO.ISSUE.CLAIMS,CLOSE':VM:'REDO.ISSUE.COMPLAINTS,CLOSE':VM:'REDO.ISSUE.REQUESTS,CLOSE':VM:'REDO.ISSUE.CLAIMS,NOTIFY':VM:'REDO.ISSUE.COMPLAINTS,NOTIFY':VM:'REDO.ISSUE.REQUESTS,NOTIFY'

  IF Y.ID MATCHES Y.VALID.ID ELSE
    E = "Enter Valid Reference"
  END
  RETURN
END
