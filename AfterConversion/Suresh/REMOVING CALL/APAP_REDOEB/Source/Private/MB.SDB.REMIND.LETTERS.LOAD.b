* @ValidationCode : Mjo4NTc1OTE2NDY6Q3AxMjUyOjE2ODEzODQ0MzYzMzc6SVRTUzotMTotMTo0MDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 16:43:56
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
SUBROUTINE MB.SDB.REMIND.LETTERS.LOAD

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.USER
    $INSERT I_F.DATES
    $INSERT I_F.MB.SDB.STATUS
    $INSERT I_F.MB.SDB.PARAM
    $INSERT I_MB.SDB.REMIND.LETTERS.COMMON


    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.MB.SDB.PARAM = 'F.MB.SDB.PARAM'; F.MB.SDB.PARAM = ''
    CALL OPF(FN.MB.SDB.PARAM, F.MB.SDB.PARAM)

    FN.MB.SDB.STATUS = 'F.MB.SDB.STATUS'; F.MB.SDB.STATUS = ''
    CALL OPF(FN.MB.SDB.STATUS, F.MB.SDB.STATUS)

    COMP.ID = ID.COMPANY; R.MB.SDB.PARAM = ''; ER.MSG = ''
    CALL F.READ(FN.MB.SDB.PARAM, COMP.ID, R.MB.SDB.PARAM, F.MB.SDB.PARAM, ER.MSG)

    REMINDER.NOTICE.FREQ = R.MB.SDB.PARAM<SDB.PAR.2ND.REMINDER.FREQ>
    SDB.MAP.KEY = R.MB.SDB.PARAM<SDB.PAR.REMINDER.LTR>

    IF REMINDER.NOTICE.FREQ AND SDB.MAP.KEY THEN
        START.PERIOD = TODAY
        END.PERIOD = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    END

RETURN

END
