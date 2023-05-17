SUBROUTINE REDO.CONFIRM.PASSWORD.ID
*-----------------------------------------------------------------------------
*** FIELD definitions FOR TEMPLATE
*!
* @author youremail@temenos.com
* @stereotype id
* @package infra.eb
* @uses E
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------
* TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-----------------------------------------------------------------------------

    TEMP.ID = ID.NEW
    STR.NUEVO = FMT(TEMP.ID,'R%9')
    TEMP2.ID = TODAY : STR.NUEVO

    ID.NEW = TEMP2.ID

RETURN

END
