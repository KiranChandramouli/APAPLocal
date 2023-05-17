* Version 9 16/05/01  GLOBUS Release No. 200511 31/10/05
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.CCRG.TECHNICAL.RESERVES.RECORD
*-----------------------------------------------------------------------------
*** Simple SUBROUTINE REDO.CCRG.TECHNICAL.RESERVES, RECORD STAGE
* @author hpasquel@temenos.com
* @stereotype recordcheck
* @package REDO.CCRG
* @uses E
* @uses AF
*!
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.REDO.CCRG.TECHNICAL.RESERVES

* Check if the record is okay to input to...
    GOSUB CHECK.RECORD

RETURN
*-----------------------------------------------------------------------------
CHECK.RECORD:
*-----------------------------------------------------------------------------
* Input not allowed for matured contracts!
* Allows to update the field LOCAL.CCY
    IF R.NEW(REDO.CCRG.TR.LOCAL.CCY) NE LCCY THEN
        R.NEW(REDO.CCRG.TR.LOCAL.CCY) = LCCY
    END
RETURN
*-----------------------------------------------------------------------------
END
