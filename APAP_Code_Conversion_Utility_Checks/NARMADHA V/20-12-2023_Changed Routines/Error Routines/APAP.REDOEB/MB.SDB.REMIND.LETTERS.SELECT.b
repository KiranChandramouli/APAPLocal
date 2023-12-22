* @ValidationCode : MjoxNzM2MDEzMTE2OlVURi04OjE3MDI2OTk1ODE5ODU6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 Dec 2023 09:36:21
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
SUBROUTINE MB.SDB.REMIND.LETTERS.SELECT

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* 15-12-2023      Narmadha V        Manual R22 Conversion      Call Routine Format Modified
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
    $USING EB.Service

    Y.LIST = ''
    IF REMINDER.NOTICE.FREQ AND SDB.MAP.KEY THEN
        Y.COUNT = ''; Y.ERR = ''
        Y.SELECT = "SELECT ":FN.MB.SDB.STATUS:" WITH REMINDER.DUE.ON NE '' AND REMINDER.DUE.ON GE ":START.PERIOD:" AND REMINDER.DUE.ON LT ":END.PERIOD:" BY @ID"
        CALL EB.READLIST(Y.SELECT, Y.LIST, '', Y.COUNT, Y.ERR)
    END

* CALL BATCH.BUILD.LIST('', Y.LIST)
    EB.Service.BatchBuildList('', Y.LIST) ;*Manual R22 Conversion - Call Routine Format Modified
    
RETURN

END
