*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.AA.INT.RATE.TYPE.DEFAULT
*
* Routine defaults the RATE.REVIEW.TYPE to 'Back to Back' for certain type of loans
* This is attached to a RECORD field in the ACTIVITY.API
*
*
*---------------------------------------------------------------------------------
*
* Modification History
*
* 04/04/2011 - PACS00032743 - Ravikiran AV - Initial Creation
*
*
*---------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.INTEREST

*---------------------------------------------------------------------------------
MAIN.LOGIC:

GOSUB INITIALISE

GOSUB DEFAULT.INT.RATE.TYPE

RETURN
*---------------------------------------------------------------------------------
INITIALISE:

CALL GET.LOC.REF("AA.PRD.DES.INTEREST","L.AA.REV.RT.TY",REVRATE.POS)


RETURN
*---------------------------------------------------------------------------------
DEFAULT.INT.RATE.TYPE:

R.NEW(AA.INT.LOCAL.REF)<1,REVRATE.POS> = 'BACK.TO.BACK' ;* Default the field to Back to Back

RETURN
*---------------------------------------------------------------------------------
END
