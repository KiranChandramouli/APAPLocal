*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.E.REMINDER.DUE.ON(REMIND.DUE.ON, SDB.ID)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.MB.SDB.PARAM
    $INSERT I_F.MB.SDB.STATUS

    FN.MB.SDB.PARAM = 'F.MB.SDB.PARAM'; F.MB.SDB.PARAM = ''
    CALL OPF(FN.MB.SDB.PARAM, F.MB.SDB.PARAM)

    FN.MB.SDB.STATUS = 'F.MB.SDB.STATUS'; F.MB.SDB.STATUS = ''
    CALL OPF(FN.MB.SDB.STATUS, F.MB.SDB.STATUS)

    Y.SDB.STATUS.ID = SDB.ID; R.SDB.STATUS = ''; SDB.ERR = ''
    CALL F.READ(FN.MB.SDB.STATUS, Y.SDB.STATUS.ID, R.SDB.STATUS, F.MB.SDB.STATUS, SDB.ERR)

    IF NOT(SDB.ERR) THEN
        Y.SDB.PARAM.ID = FIELD(SDB.ID, '.', 1,1); R.SDB.PARAM = ''; SDB.ERR = ''
        CALL F.READ(FN.MB.SDB.PARAM, Y.SDB.PARAM.ID, R.SDB.PARAM, F.MB.SDB.PARAM, SDB.ERR)
        IF NOT(SDB.ERR) THEN

            REMIND.FREQ = R.SDB.PARAM<SDB.PAR.2ND.REMINDER.FREQ>
            IF REMIND.FREQ AND R.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON> THEN
                REMIND.DUE.ON = R.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON>
                W.FREQ = "+":REMIND.FREQ
                CALL CDT('', REMIND.DUE.ON, W.FREQ)
            END ELSE
                REMIND.DUE.ON = ''
            END

        END

    END

    RETURN

END


