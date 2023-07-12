*========================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.FUND.SEND.MONITOR.SELECT
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.FUND.SEND.MONITOR.SELECT
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

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_LAPAP.FUND.SEND.MONITOR

    SEL.CMD = "SELECT FBNK.FUNDS.TRANSFER WITH TRANSACTION.TYPE EQ 'AC-3'"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,SEL.ERR)

*LOOP REMOVE ACC.ID FROM SEL.LIST SETTING CR.POS
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
