*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INTERFACE.SMAIL.AUTHORISE
*-----------------------------------------------------------------------------
!** Simple AUTHORISE template
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package infra.eb
*!

*** <region name= PROGRAM DESCRIPTION>
*** <desc>Program description</desc>
*-----------------------------------------------------------------------------
* Program Description
*** </region>

*** <region name= MODIFICATION HISTORY>
*** <desc>Modification history</desc>
*-----------------------------------------------------------------------------
* Modification History:
*-----------------------------------------------------------------------------
*** </region>

*** <region name= INSERTS>
*** <desc>Inserts</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
*** </region>
*-----------------------------------------------------------------------------

*** <region name= MAIN PROCESS LOGIC>
*** <desc>Main process logic</desc>
  GOSUB INITIALISE
  GOSUB PROCESS

  RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
*** <desc>Process</desc>
PROCESS:
  CALL REDO.R.INTERFACE.SMAIL.FILE.PROPERTIES

  RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
*** <desc>Initialise</desc>
INITIALISE:

  RETURN
*** </region>
END
