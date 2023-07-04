$PACKAGE APAP.REDOENQ
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
*  DATE             WHO                   REFERENCE                  
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
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
