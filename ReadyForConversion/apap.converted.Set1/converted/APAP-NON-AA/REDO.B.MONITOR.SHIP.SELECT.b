SUBROUTINE REDO.B.MONITOR.SHIP.SELECT
*-----------------------------------------------------------------------------
* 03/09/10 - Created by Victor Nava
*
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.MONITOR.SHIP.COMMON
*-----------------------------------------------------------------------------
*
    LIST.PARAMETER = ''
    LIST.PARAMETER<2> = FN.REDO.MON.SEND.QUEUE
    CALL BATCH.BUILD.LIST(LIST.PARAMETER,'')
*

RETURN
*-----------------------------------------------------------------------------
END
