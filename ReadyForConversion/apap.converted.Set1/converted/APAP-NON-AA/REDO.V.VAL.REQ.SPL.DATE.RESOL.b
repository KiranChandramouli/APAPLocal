SUBROUTINE REDO.V.VAL.REQ.SPL.DATE.RESOL
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is Validation routine to check the date resolution is not less than today
* at the time of commitment
* This development is for ODR Reference PACS00071066
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
* 25-MAY-2011       Pradeep S        PACS00060849        Initial Creation
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.REQUESTS

    GOSUB PROCESS
RETURN

*********
PROCESS:
*********

    IF COMI AND COMI LT TODAY THEN
        ETEXT = 'EB-DATE.NOT.LT.TODAY'
        CALL STORE.END.ERROR
    END

RETURN

*---------------------------------------------------------------------------------------------------
END
