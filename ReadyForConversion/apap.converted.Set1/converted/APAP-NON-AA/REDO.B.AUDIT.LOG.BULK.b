SUBROUTINE REDO.B.AUDIT.LOG.BULK(Y.ID)

    $INSERT I_TSA.COMMON
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AUDIT.TRAIL.LOG
    $INSERT I_REDO.B.AUDIT.LOG.BULD.COMMON
    $INSERT I_BATCH.FILES


    CALL F.READ(FN.REDO.AUDIT.TRAIL.LOG,Y.ID,R.REDO.AUDIT.TRAIL.LOG,F.REDO.AUDIT.TRAIL.LOG,LOG.ERR)

    IF NOT(R.REDO.AUDIT.TRAIL.LOG) THEN
        RETURN
    END

    R.REDO.AUDIT.TRAIL.LOG = CHANGE(R.REDO.AUDIT.TRAIL.LOG,@FM,Y.DELIM)

    Y.FILE.NAME = AGENT.NUMBER:TODAY:'SEP'

    READ Y.REC FROM Y.PTR,Y.FILE.NAME THEN
        Y.REC<-1> = R.REDO.AUDIT.TRAIL.LOG

        WRITE Y.REC ON Y.PTR,Y.FILE.NAME ON ERROR
*TUS-Convert cannot find the OPEN or OPF , not converted WRITE to F.WRITE
            CALL OCOMO("UNABLE TO WRITE REDO.AUDIT.TRAIL.LOG ":Y.ID)
        END
    END

END
