* @ValidationCode : MjoxMjYwMDM4MTYxOlVURi04OjE3MDI2NDI2MTMxMjY6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Dec 2023 17:46:53
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.SDB.RENEWAL.LETTERS.LOAD
 
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
    $INSERT I_MB.SDB.RENEWAL.LETTERS.COMMON


    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.MB.SDB.PARAM = 'F.MB.SDB.PARAM'; F.MB.SDB.PARAM = ''
    CALL OPF(FN.MB.SDB.PARAM, F.MB.SDB.PARAM)

    FN.MB.SDB.STATUS = 'F.MB.SDB.STATUS'; F.MB.SDB.STATUS = ''
    CALL OPF(FN.MB.SDB.STATUS, F.MB.SDB.STATUS)

    COMP.ID = ID.COMPANY; R.MB.SDB.PARAM = ''; ER.MSG = ''
    CALL F.READ(FN.MB.SDB.PARAM, COMP.ID, R.MB.SDB.PARAM, F.MB.SDB.PARAM, ER.MSG)

    RENEWAL.NOTICE.FREQ = R.MB.SDB.PARAM<SDB.PAR.RENEW.NOTICE.FREQ>
    SDB.MAP.KEY = R.MB.SDB.PARAM<SDB.PAR.RENEW.LTR>

    IF RENEWAL.NOTICE.FREQ AND SDB.MAP.KEY THEN
        START.PERIOD = TODAY; W.FREQ = "+":RENEWAL.NOTICE.FREQ
        CALL CDT('', START.PERIOD, W.FREQ)

        END.PERIOD = R.DATES(EB.DAT.NEXT.WORKING.DAY); W.FREQ = "+":RENEWAL.NOTICE.FREQ
        CALL CDT('', END.PERIOD, W.FREQ)
    END

RETURN

END
