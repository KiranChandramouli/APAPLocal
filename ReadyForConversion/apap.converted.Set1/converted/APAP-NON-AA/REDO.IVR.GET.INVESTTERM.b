SUBROUTINE REDO.IVR.GET.INVESTTERM
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
*   To get the number of days as investment term.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 08-MAY-2014       RMONDRAGON      ODR-2011-02-0099     Initial Creation
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_ENQUIRY.COMMON

    GOSUB PROCESS

RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.START.DATE = FIELD(O.DATA,'-',1)
    Y.END.DATE = FIELD(O.DATA,'-',2)

    CALL CDD('',Y.START.DATE,Y.END.DATE,Y.DIFF)

    O.DATA = Y.DIFF:'D'

RETURN

*-----------------------------------------------------------------------------
END
