*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE RE.MISMATCH.APP.INFO.LOAD
*
*-----------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RE.STAT.MISMATCH
    $INSERT I_RE.MISMATCH.APP.INFO.COMMON
*
*-----------------------------------------------------------------------------
*

    FN.RE.STAT.MISMATCH = 'F.RE.STAT.MISMATCH'
    F.RE.STAT.MISMATCH = ''
    CALL OPF(FN.RE.STAT.MISMATCH, F.RE.STAT.MISMATCH)

    FN.RE.STAT.LINE.CONT = 'F.RE.STAT.LINE.CONT'
    F.RE.STAT.LINE.CONT = ''
    CALL OPF(FN.RE.STAT.LINE.CONT, F.RE.STAT.LINE.CONT)

    FN.MISMATCH.CONT.FILE = 'F.MISMATCH.CONTRACT.FILE'
    F.MISMATCH.CONT.FILE = ''
    CALL OPF(FN.MISMATCH.CONT.FILE, F.MISMATCH.CONT.FILE)

    FN.RE.STAT.REPORT.HEAD = 'F.RE.STAT.REPORT.HEAD'
    F.RE.STAT.REPORT.HEAD = ''
    CALL OPF(FN.RE.STAT.REPORT.HEAD, F.RE.STAT.REPORT.HEAD)

    ID.NEW = BATCH.DETAILS<3,1,1>
    V = RE.SMM.AUDIT.DATE.TIME

    MATREAD R.NEW FROM F.RE.STAT.MISMATCH, ID.NEW THEN
        LOC.REPORT.NAMES = R.NEW(RE.SMM.REPORT.NAME)

        YCOUNT.RPT.NAME = COUNT(R.NEW(RE.SMM.REPORT.NAME),VM)+1
        FOR YY = 1 TO YCOUNT.RPT.NAME
            Y.REPORT = LOC.REPORT.NAMES<1,YY>
            READ Y1.REC FROM F.RE.STAT.REPORT.HEAD, Y.REPORT THEN
                LOC.REPORT.RECS(YY) = Y1.REC
            END
        NEXT
    END

    RETURN
