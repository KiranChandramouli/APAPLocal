SUBROUTINE REDO.BCR.REPORT.EXEC.ID
*-----------------------------------------------------------------------------
*** FIELD definitions FOR REDO.BCR.REPORT.EXEC.ID
*!
* @author hpasquel@temenos.com
* @stereotype id
* @package REDO.BCR
* @uses E
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------
* The ID must start with BCR
*-----------------------------------------------------------------------------
    IF ID.NEW[1,3] NE 'BCR' THEN
        E = 'ST-REDO.BCR.ID.NOT.VALID'
        E<2> = ID.NEW
    END

RETURN

END
