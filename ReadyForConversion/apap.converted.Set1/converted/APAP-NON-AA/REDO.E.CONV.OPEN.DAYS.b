SUBROUTINE REDO.E.CONV.OPEN.DAYS
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : A Conversion routien to the date difference between OPENING.DATE and RESOLUTION.DATE
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : PRADEEP S
* PROGRAM NAME : REDO.E.CONV.OPEN.DAYS
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 16-MAY-2011       PRADEEP SO         PACS00060849      INITIAL CREATION
* ----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.ISSUE.COMPLAINTS

    GOSUB PROCESS
RETURN

********
PROCESS:
********

    Y.OPEN.DATE = R.RECORD<ISS.COMP.OPENING.DATE>
    Y.RESOLVE.DATE = R.RECORD<ISS.COMP.DATE.RESOLUTION>

    IF Y.OPEN.DATE NE ''  AND Y.RESOLVE.DATE NE '' THEN
        NO.OF.DAYS = 'C'
        CALL CDD('',Y.OPEN.DATE,Y.RESOLVE.DATE,NO.OF.DAYS)
        O.DATA = ABS(NO.OF.DAYS)
    END

RETURN
