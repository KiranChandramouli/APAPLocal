SUBROUTINE REDO.B.AUDIT.LOG.BULK.SELECT

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AUDIT.TRAIL.LOG
    $INSERT I_REDO.B.AUDIT.LOG.BULD.COMMON

    SEL.CMD = 'SELECT ':FN.REDO.AUDIT.TRAIL.LOG
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,REC.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
