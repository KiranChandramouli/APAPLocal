SUBROUTINE REDO.E.GET.USENQ
*-----------------------------------------------------------------------------
*** Simple SUBROUTINE template
* @author @temenos.com
* @stereotype subroutine
* @package infra.eb
*!
*-----------------------------------------------------------------------------
* Modification History:
*
*            Creation: This routine returns current user to current ENQUIRY column
*            returns OPERATOR. Used HOLD.CONTROL enquiry list.
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*-----------------------------------------------------------------------------
    GOSUB INITIALISE

    WCURR.USER = OPERATOR
    O.DATA     = WCURR.USER

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*
RETURN
*
END
