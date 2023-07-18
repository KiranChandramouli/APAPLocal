*========================================================================
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.ACC.MASSIVE.NOTICE.LOAD
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.ACC.MASSIVE.NOTICE.LOAD
* Date           : 2019-05-21
* Item ID        : --------------
*========================================================================
* Brief description :
* -------------------
* This program allow ....
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2019-05-21     Richard HC        Initial Development
*========================================================================
* Content summary :
* =================
* Table name     :F.ACCOUNT
* Auto Increment :N/A
* Views/versions :
* EB record      :N/A
* Routine        :LAPAP.ACC.MASSIVE.NOTICE.LOAD
*========================================================================

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT LAPAP.BP I_LAPAP.ACC.MASSIVE.NOTICE.COMMON

    FN.ACC = "F.ACCOUNT"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)

    RETURN

END
