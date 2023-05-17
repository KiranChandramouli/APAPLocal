SUBROUTINE S.REDO.GET.EB.ERROR.TXT(P.IN.EB.ERROR.ID,P.IN.VARS,P.OUT.MSG)
*-----------------------------------------------------------------------------
*!** Simple SUBROUTINE template
* @author:    vpanchi@temenos.com
* @stereotype subroutine: Routine
* @package:   REDO.CCRG
*!
*-----------------------------------------------------------------------------
*  Routine that permits to show the error message to the user
*  This is used for batch process
*
*  Input Param:
*  ------------
*  P.IN.EB.ERROR.ID:
*     Error message code
*  P.IN.VARS
*     Variables
*
*  Output Param:
*  ------------
*  P.OUT.MSG:
*            User message
*-----------------------------------------------------------------------------
* Modification Details:
*=====================
*
*--------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN

*** <region name= INITIALISE>
*** <desc>Initialise the variables</desc>
****
INITIALISE:
    PROCESS.GOAHEAD = 1
    Y.MSG           = P.IN.EB.ERROR.ID
*
RETURN
*** </region>

*** <region name= PROCESS>
*** Process the message
PROCESS:
    CALL EB.GET.ERROR.MESSAGE(Y.MSG)
*P.OUT.MSG = Y.MSG<1,1>

* Assign the value to variable
    P.OUT.MSG = Y.MSG
    P.OUT.MSG<2> = P.IN.VARS
    CALL TXT(P.OUT.MSG)
*
RETURN
*** </region>

*-----------------------------------------------------------------------------
*** <region name= CHECK.PRELIM.CONDITIONS>
***
CHECK.PRELIM.CONDITIONS:
    IF NOT(P.IN.EB.ERROR.ID) THEN
        PROCESS.GOAHEAD = 0
    END
RETURN
*** </region>
END
