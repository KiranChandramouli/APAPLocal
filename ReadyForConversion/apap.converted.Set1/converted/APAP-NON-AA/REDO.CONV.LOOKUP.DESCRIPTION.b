SUBROUTINE REDO.CONV.LOOKUP.DESCRIPTION
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

    Y.REC.DATA = O.DATA
    Y.EB.ID = "EB.STATUS*":Y.REC.DATA

    CALL F.READ(FN.EB.LOOKUP,Y.EB.ID,R.EB.LOOKUP,F.EB.LOOKUP,ERR.EB)
    O.DATA = R.EB.LOOKUP<EB.LU.DESCRIPTION>

RETURN
*-------------------------------------------------------------------------
END
