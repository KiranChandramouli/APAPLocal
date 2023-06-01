* @ValidationCode : MjotMTMxNjU2NjEwNjpDcDEyNTI6MTY4MTM4NDQzMzg4MDpJVFNTOi0xOi0xOjQwMDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 16:43:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 400
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.E.REMINDER.DUE.ON(REMIND.DUE.ON, SDB.ID)

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
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
