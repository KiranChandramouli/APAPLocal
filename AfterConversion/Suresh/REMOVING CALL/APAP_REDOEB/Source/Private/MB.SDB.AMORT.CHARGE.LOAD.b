* @ValidationCode : Mjo5MDE4NDE4MjU6Q3AxMjUyOjE2ODEzODQ0MzQ4NDY6SVRTUzotMTotMTo1OTg6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 16:43:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 598
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.SDB.AMORT.CHARGE.LOAD
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
*    $INCLUDE GLOBUS.BP I_COMMON        ;*/ TUS START
*    $INCLUDE GLOBUS.BP I_EQUATE
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.PARAM
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.STATUS
*    $INCLUDE CAPLATFORM.BP I_MB.SDB.AMORT.CHARGE.COMMON
*    $INCLUDE CAPLATFORM.BP I_F.OFS.SOURCE

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MB.SDB.PARAM
    $INSERT I_F.MB.SDB.STATUS
    $INSERT I_MB.SDB.AMORT.CHARGE.COMMON
    $INSERT I_F.OFS.SOURCE        ;*/ TUS END

    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.STANDING.ORDER = 'F.STANDING.ORDER'; F.STANDING.ORDER = ''
    CALL OPF(FN.STANDING.ORDER, F.STANDING.ORDER)

    FN.MB.SDB.STATUS = 'F.MB.SDB.STATUS'; FP.MB.SDB.STATUS = ''
    CALL OPF(FN.MB.SDB.STATUS, FP.MB.SDB.STATUS)

    FN.MB.SDB.PARAM = 'F.MB.SDB.PARAM'; FP.MB.SDB.PARAM = ''
    CALL OPF(FN.MB.SDB.PARAM, FP.MB.SDB.PARAM)

    FN.MB.SDB.TYPE = 'F.MB.SDB.TYPE'; FP.MB.SDB.TYPE = ''
    CALL OPF(FN.MB.SDB.TYPE, FP.MB.SDB.TYPE)

*PACS00329153 - S
    FN.OFS.SOURCE = 'F.OFS.SOURCE'; F.OFS.SOURCE = ''
    CALL OPF(FN.OFS.SOURCE, F.OFS.SOURCE)
*PACS00329153 - E


    LAST.MTH.END = TODAY; LAST.MTH.END[7,2] = '01'
    CALL CDT('', LAST.MTH.END, '-1C')

    SAVE.COMI = COMI; COMI = LAST.MTH.END:'M0131'
    CALL CFQ; THIS.MTH.END = COMI[1,8]; COMI = SAVE.COMI

    THIS.MTH.START = THIS.MTH.END; THIS.MTH.START[7,2] = '01'

RETURN

END
