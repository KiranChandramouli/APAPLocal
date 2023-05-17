*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.V.SDB.AUTH.STO
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MB.SDB.STATUS
    $INSERT I_F.STANDING.ORDER

*  PACS00514342 - Routine written for the mentioned issue - Since we have changed OFS.POST.MESSAGE instead of OGM in MB.SDB.POST
*  we need to update the transaction reference in MB.SDB.CHARGES through version routine
*  This routine needs to be attached in SDB CHARGES version

    IF (V$FUNCTION EQ 'R') THEN
        RETURN
    END

    GOSUB INIT.FILE
    GOSUB WRITE.FILE
    RETURN

INIT.FILE:

    FN.MB.SDB.STATUS= 'F.MB.SDB.STATUS'
    F.MB.SDB.STATUS = ''

    CALL OPF(FN.MB.SDB.STATUS,F.MB.SDB.STATUS)
    Y.DEBIT.REF = R.NEW(STO.DEBIT.THEIR.REF)

    Y.SDB.STAT.ID = ID.COMPANY:".":Y.DEBIT.REF

    RETRY = "P"

    CALL F.READU(FN.MB.SDB.STATUS,Y.SDB.STAT.ID,R.MB.SDB.STAT,F.MB.SDB.STATUS,ERR.MB.STAT,RETRY)

    RETURN

WRITE.FILE:

    IF R.MB.SDB.STAT THEN
        R.MB.SDB.STAT<SDB.STA.STO.REF> = ID.NEW
        CALL F.WRITE(FN.MB.SDB.STATUS,Y.SDB.STAT.ID,R.MB.SDB.STAT)
    END

    RETURN


END
