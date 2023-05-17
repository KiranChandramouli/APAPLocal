SUBROUTINE REDO.CCRG.ALLOWED.APP.VAL.RTN
*-----------------------------------------------------------------------------
*!** Simple SUBROUTINE template
* @author:    anoriega@temenos.com
* @stereotype subroutine: Validate Routine
* @package:   REDO.CCRG
*!
*-----------------------------------------------------------------------------
*  This routine validate the application to add will be only CUSTOMER
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CCRG.RISK.LIMIT.PARAM
*-----------------------------------------------------------------------------

    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
PROCESS:
* Validate application value inputted
    Y.APPLICATION = COMI
    CALL REDO.CCRG.ALLOWED.APP('VAL.RTN',Y.APPLICATION)
RETURN
END
