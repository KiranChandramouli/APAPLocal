$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.B.SERVICE.LST.CLEAR(SERVICE.ID)

****************************************************
* Company : APAP
* Decription: Routine to clear the JOB.LIST, BATCH.STATUS, JOB.STATUS & PROCESS.STATUS for the BATCH record
*             updated in the parameter table "L.APAP.REPORT.SERVICE.PARAM".
* Dev By   : Ashokkumar
*
*****************************************************
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION

*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   t24.BP,BP is Removed
*----------------------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT I_F.LOCKING ;*R22 MANUAL CONVERSION
    $INSERT  I_F.BATCH
    $INSERT  I_F.TSA.SERVICE ;*R22 MANUAL CONVERSION
    $INSERT  I_F.L.APAP.REPORT.SERVICE.PARAM
    $INSERT  I_L.APAP.B.SERVICE.LST.CLEAR.COMMON


    GOSUB PROCESS
RETURN

PROCESS:
********
    ERR.TSA.SERVICE = ''; R.TSA.SERVICE = ''; YTS.STATUS = ''
    CALL F.READ(FN.TSA.SERVICE,SERVICE.ID,R.TSA.SERVICE,F.TSA.SERVICE,ERR.TSA.SERVICE)
    YTS.STATUS = R.TSA.SERVICE<TS.TSM.SERVICE.CONTROL>
    IF YTS.STATUS MATCHES 'START':VM:'AUTO' THEN
        PRINT "Running Batch record skipped for resetting ":SERVICE.ID
        RETURN
    END

    ERR.BATCH = ''; R.BATCH = ''; YUPD = 0
    CALL F.READ(FN.BATCH,SERVICE.ID,R.BATCH,F.BATCH,ERR.BATCH)
    IF R.BATCH<BAT.PROCESS.STATUS> NE '0' THEN
        YUPD = 1
        R.BATCH<BAT.PROCESS.STATUS> = '0'
    END
    YJOB.STAT = R.BATCH<BAT.JOB.STATUS>
    YJOB.STAT.CNT = DCOUNT(YJOB.STAT,SM)
    FOR I = 1 TO YJOB.STAT.CNT
        YJOB.NAM = ''
        IF R.BATCH<BAT.JOB.STATUS,I> NE 0 THEN
            YUPD = 1
            R.BATCH<BAT.JOB.STATUS,I> = '0'
        END
        YJOB.NAM = R.BATCH<BAT.JOB.NAME,I>
        GOSUB PROCESS.LOCKING
    NEXT I
    IF YUPD EQ 1 THEN
        PRINT "Restting the Batch record status ":SERVICE.ID
        CALL F.WRITE(FN.BATCH,SERVICE.ID,R.BATCH)
    END

    SEL.REC = "SELECT ":FN.BATCH.STATUS:" WITH @ID LIKE ":SERVICE.ID:"..."
    EXECUTE SEL.REC RTNLIST BTS.STAT.LST
    LOOP
        REMOVE BT.ID FROM BTS.STAT.LST SETTING BL.POSN
    WHILE BT.ID:BL.POSN
        PRINT "Deleting F.BATCH.STATUS record ":BT.ID
        CALL F.DELETE(FN.BATCH.STATUS,BT.ID)
    REPEAT
    CALL JOURNAL.UPDATE('')
RETURN

PROCESS.LOCKING:
****************
    LOCK.LIST.ID = SERVICE.ID:'-':YJOB.NAM:'-':I
    R.LOCKING = ''; ERR.LOCKING = ''; YLOCKING = ''
    CALL F.READ(FN.LOCKING,LOCK.LIST.ID,R.LOCKING,FV.LOCKING,ERR.LOCKING)
    IF R.LOCKING THEN
        YLOCKING = R.LOCKING<EB.LOK.CONTENT>
        PRINT "Deleting the F.LOCKING record ":LOCK.LIST.ID
        DELETE F.LOCKING,LOCK.LIST.ID
        IF YLOCKING THEN
            PRINT "Deleting the F.LOCKING record ":YLOCKING
            DELETE F.LOCKING,YLOCKING

            PRINT "Clearing JOB.LIST Record ":YLOCKING
            YCLEAR.FL = "CLEAR.FILE ":YLOCKING
            EXECUTE YCLEAR.FL
        END
    END
RETURN
END
