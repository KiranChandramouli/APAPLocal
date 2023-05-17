SUBROUTINE REDO.B.MONITOR.MAP.SELECT
*-----------------------------------------------------------------------------
*
* 30/08/2010 - Created by Cesar Yepez
*
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.MONITOR.MAP.COMMON
*-----------------------------------------------------------------------------
*

    LIST.PARAMETER = ''
    LIST.PARAMETER<2> = FN.REDO.MON.MAP.QUEUE
    CALL BATCH.BUILD.LIST(LIST.PARAMETER,'')
*

RETURN
*-----------------------------------------------------------------------------
END
