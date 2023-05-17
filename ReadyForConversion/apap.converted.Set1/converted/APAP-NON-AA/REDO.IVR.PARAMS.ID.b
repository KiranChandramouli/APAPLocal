SUBROUTINE REDO.IVR.PARAMS.ID
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

    IF COMI EQ 'SYSTEM' THEN
        RETURN
    END

    IF NUM(COMI) THEN
        RETURN
    END

    E = 'EB-NOT.VALID.ID'
RETURN

END
