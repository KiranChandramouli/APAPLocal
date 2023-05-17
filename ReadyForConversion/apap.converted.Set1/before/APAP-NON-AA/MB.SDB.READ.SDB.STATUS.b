*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.SDB.READ.SDB.STATUS(MB.SDB.STATUS.ID,R.MB.SDB.STATUS)
*-----------------------------------------------------------------------------
    $INSERT I_F.MB.SDB.STATUS

    FN.MB.SDB.STATUS = 'F.MB.SDB.STATUS'
    F.MB.SDB.STATUS = ''
    CALL OPF(FN.MB.SDB.STATUS,F.MB.SDB.STATUS)

    R.MB.SDB.STATUS = ''
    YERR = ''
    CALL F.READ(FN.MB.SDB.STATUS,MB.SDB.STATUS.ID,R.MB.SDB.STATUS,F.MB.SDB.STATUS,YERR)

    RETURN
*-----------------------------------------------------------------------------
END

