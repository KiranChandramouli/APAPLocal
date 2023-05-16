* @ValidationCode : MjotMTA5MDAxNTkyMjpVVEYtODoxNjg0MjE0MjQ4OTY1OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 10:47:28
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
$PACKAGE APAP.LAPAP
*========================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.WS.BENEFICIARY.UPDATE(Y.INFO)
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.WS.BENEFICIARY.UPDATE
* Date           : 2018-12-18
* Item ID        : ----
*========================================================================
* Brief description :
* -------------------
* This a program allow reverse beneficiary through ENQ no file
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-12-18     Richard HC        Initial Development
*========================================================================
* Content summary :
* =================
* Table name     : FBNK.BENEFICIARY
* Auto Increment : N/A
* Views/versions :(VERSION)BENEFICIARY,DMR |(ENQ)LAPAP.WS.BENEFICIARY.UPDATE
* EB record      : LAPAP.WS.BENEFICIARY.UPDATE
*========================================================================
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED,F.READ TO CACHE.READ
*24-04-2023       Samaran T               R22 Manual Code Conversion       Call method format changed
*----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON     ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_ENQUIRY.COMMON     ;*R22 AUTO CODE CONVERSION.END

    FN.BEN = "F.BENEFICIARY"
    F.BEN = ""
    CALL OPF(FN.BEN,F.BEN)

    LOCATE "BEN" IN D.FIELDS<1> SETTING BEN.POS THEN
        ID = D.RANGE.AND.VALUE<BEN.POS>
    END
    LOCATE "NICK" IN D.FIELDS<1> SETTING NICK.POS THEN
        NICKNAME = D.RANGE.AND.VALUE<NICK.POS>
    END
    LOCATE "EMAIL" IN D.FIELDS<1> SETTING EMAIL.POS THEN
        BEN.EMAIL = D.RANGE.AND.VALUE<EMAIL.POS>
    END
    LOCATE "ACCT" IN D.FIELDS<1> SETTING ACCT.POS THEN
        ACCT.NO = D.RANGE.AND.VALUE<ACCT.POS>
    END
    LOCATE "PROD" IN D.FIELDS<1> SETTING PROD.POS THEN
        PROD.TYPE = D.RANGE.AND.VALUE<PROD.POS>
    END

    APPL.NAME = "BENEFICIARY"
    VERS.NAME = "BENEFICIARY,RAD"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.ID  = ID

    CALL CACHE.READ(FN.BEN, ID, R.BEN, BEN.ERR)      ;*R22 AUTO CODE CONVERSION
    CALL GET.LOC.REF("BENEFICIARY","L.BEN.EMAIL",POS1)
    CALL GET.LOC.REF("BENEFICIARY","L.BEN.PROD.TYPE",POS2)

    RSS<ARC.BEN.NICKNAME> = EREPLACE(NICKNAME, "~", " ")
    RSS<ARC.BEN.LOCAL.REF,POS1> = EREPLACE(BEN.EMAIL, "~", " ")


    IF ACCT.NO NE "" THEN
        RSS<ARC.BEN.BEN.ACCT.NO> = ACCT.NO
    END

    IF PROD.TYPE NE "" THEN
        RSS<ARC.BEN.LOCAL.REF,POS2> = PROD.TYPE
    END

    CALL OFS.BUILD.RECORD(APPL.NAME,Y.FUNC,Y.PRO.VAL,VERS.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.ID,RSS,FINAL.OFS)
    OFS.RESP="";TXN.COMMIT='';* R22 Manual conversion - start
*CALL OFS.GLOBUS.MANAGER("DM.OFS.SRC.VAL", FINAL.OFS)
    CALL OFS.CALL.BULK.MANAGER("DM.OFS.SRC.VAL", FINAL.OFS, OFS.RESP, TXN.COMMIT);* R22 Manual conversion - End
    CALL JOURNAL.UPDATE('')

    Y.INFO<-1> = FINAL.OFS    ;* "Mensaje ..."

RETURN

END
