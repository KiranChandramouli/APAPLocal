$PACKAGE APAP.LAPAP
*========================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.FUND.SEND.MONITOR.LOAD
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.FUND.SEND.MONITOR.LOAD
* Date           : 2018-05-04
* Item ID        : CN004475
*========================================================================
* Brief description :
* -------------------
* This a multi-threading program for inject data in monitor interface
* without use any version.
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-05-04     Richard HC                Initial Development
*========================================================================
* Content summary :
* =================
* Table name     :
* Auto Increment :
* Views/versions :
* EB record      :
* Routine        :
*========================================================================
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CURRENCY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_LAPAP.FUND.SEND.MONITOR

    FN.FUND = "F.FUNDS.TRANSFER"
    F.FUND = ""

    FN.MON = "F.REDO.MON.SEND.QUEUE"
    F.MON = ""

    FN.CUS = "F.CUSTOMER"
    F.CUS = ""

    FN.ACC = "F.ACCOUNT"
    F.ACC = ""

    FN.TXN = "F.FT.TXN.TYPE.CONDITION"
    F.TXN = ""

    FN.CUR = "F.CURRENCY"
    F.CUR = ""


    CALL OPF(FN.FUND,F.FUND)
    CALL OPF(FN.MON,F.MON)
    CALL OPF(FN.CUS,F.CUS)
    CALL OPF(FN.ACC,F.ACC)
    CALL OPF(FN.TXN,F.TXN)
    CALL OPF(FN.CUR,F.CUR)


RETURN

END
