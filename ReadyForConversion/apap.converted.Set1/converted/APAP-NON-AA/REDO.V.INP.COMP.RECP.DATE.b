SUBROUTINE REDO.V.INP.COMP.RECP.DATE
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is Input routine to update the values of DATE & TIME field of REDO.APAP.CLAIMS
* at the time of commitment
* This development is for ODR Reference ODR-2009-12-0283
* Input/Output:
*--------------
* IN  : N/A
* OUT : N/A
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
* Revision History:
*------------------------------------------------------------------------------------------
* Date              who              Reference            Description
* 27-JUL-2010       B Renugadevi     ODR-2009-12-0283    Initial Creation
* 13-MAR-2011        Prabhu N         HD1100441           Manadatory check removed for the fields CLIENT.CONTACTED,NOTES,CLOSE.NOTIFICATION
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.COMPLAINTS

    GOSUB INIT
    GOSUB PROCESS
RETURN

******
INIT:
******
    FN.REDO.ISSUE.COMPLAINTS = 'F.REDO.ISSUE.COMPLAINTS'
    F.REDO.ISSUE.COMPLAINTS  = ''
    CALL OPF(FN.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS)
RETURN

*********
PROCESS:
*********

    Y.TIME      = OCONV(TIME(), "MTS")

    IF R.NEW(ISS.COMP.STATUS) EQ "OPEN" THEN
        R.NEW(ISS.COMP.OPENING.DATE) = TODAY
    END
    IF R.NEW(ISS.COMP.STATUS) EQ "RESOLVED NOTIFIED" THEN
        R.NEW(ISS.COMP.DATE.NOTIFICATION) = TODAY
    END
    IF R.NEW(ISS.COMP.STATUS) EQ "CLOSED" THEN
        R.NEW(ISS.COMP.CLOSING.DATE) = TODAY
        GOSUB UPDATE.CLOSED.FIELD
    END

    R.NEW(ISS.COMP.RECEPTION.TIME) = Y.TIME

RETURN
********************
UPDATE.CLOSED.FIELD:
********************

    IF R.NEW(ISS.COMP.CLOSING.STATUS) EQ ''  THEN
        AF = ISS.COMP.CLOSING.STATUS
        ETEXT = 'EB-INPUT.MAND'
        CALL STORE.END.ERROR
    END

    IF R.NEW(ISS.COMP.CLOSING.REMARKS) EQ '' THEN
        AF = ISS.COMP.CLOSING.REMARKS
        ETEXT = 'EB-INPUT.MAND'
        CALL STORE.END.ERROR
    END

    IF R.NEW(ISS.COMP.INTERNAL.REMARKS) EQ '' THEN
        AF = ISS.COMP.INTERNAL.REMARKS
        ETEXT = 'EB-INPUT.MAND'
        CALL STORE.END.ERROR
    END

    IF R.NEW(ISS.COMP.USER.REMARKS) EQ '' THEN
        AF = ISS.COMP.USER.REMARKS
        ETEXT = 'EB-INPUT.MAND'
        CALL STORE.END.ERROR
    END

RETURN
*---------------------------------------------------------------------------------------------------
END
