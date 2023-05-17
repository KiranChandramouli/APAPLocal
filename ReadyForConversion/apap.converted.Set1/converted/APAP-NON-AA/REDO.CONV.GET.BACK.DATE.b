SUBROUTINE REDO.CONV.GET.BACK.DATE
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* to the the date
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 03-MAY-2012         RIYAS         PACS00194267     Initial Creation
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    Y.PERIOD= '-90':'C'
    Y.TODAY = TODAY
    CALL CDT('',Y.TODAY,Y.PERIOD)
    O.DATA = Y.TODAY:' ':TODAY
RETURN
END
