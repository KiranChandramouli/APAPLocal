* @ValidationCode : Mjo0OTc4OTk0Njg6Q3AxMjUyOjE2ODEzODQ0MzY0NTI6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 16:43:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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


    Y.LIST = ''
    IF REMINDER.NOTICE.FREQ AND SDB.MAP.KEY THEN
        Y.COUNT = ''; Y.ERR = ''
        Y.SELECT = "SELECT ":FN.MB.SDB.STATUS:" WITH REMINDER.DUE.ON NE '' AND REMINDER.DUE.ON GE ":START.PERIOD:" AND REMINDER.DUE.ON LT ":END.PERIOD:" BY @ID"
        CALL EB.READLIST(Y.SELECT, Y.LIST, '', Y.COUNT, Y.ERR)
    END

    CALL BATCH.BUILD.LIST('', Y.LIST)

RETURN

END
