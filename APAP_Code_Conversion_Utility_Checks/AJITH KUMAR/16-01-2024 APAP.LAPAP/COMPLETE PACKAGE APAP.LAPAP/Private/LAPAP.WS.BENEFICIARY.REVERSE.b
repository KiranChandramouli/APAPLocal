* @ValidationCode : MjoxNTMwMjMxNzQ5OlVURi04OjE3MDI5ODgzODk4MzE6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:49
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*========================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.WS.BENEFICIARY.REVERSE(Y.INFO)
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.WS.BENEFICIARY.REVERSE
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
* Views/versions :(VERSION)BENEFICIARY,DMR |(ENQ)LAPAP.WS.BENEFICIARY.REVERSE
* EB record      : LAPAP.WS.BENEFICIARY.REVERSE
*========================================================================
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*24-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*19-12-2023    Narmadha V          Manual R22 Conversion    Call Routine Format Modified
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON   ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_ENQUIRY.COMMON    ;*R22 AUTO CODE CONVERSION.END
    $USING EB.Interface ;*Manual R22 Conversion
   $USING EB.TransactionControl

    FN.BEN = "F.BENEFICIARY"
    F.BEN = ""
    CALL OPF(FN.BEN,F.BEN)

    LOCATE "BEN" IN D.FIELDS<1> SETTING CUS.POS THEN
        ID = D.RANGE.AND.VALUE<CUS.POS>
    END

    APPL.NAME = "BENEFICIARY"
    VERS.NAME = "BENEFICIARY,DMR"
    Y.FUNC = "R"
    Y.PRO.VAL = "PROCESS"
    Y.ID  = ID
    RSS = ""

    CALL OFS.BUILD.RECORD(APPL.NAME,Y.FUNC,Y.PRO.VAL,VERS.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.ID,RSS,FINAL.OFS)
*   CALL OFS.POST.MESSAGE(FINAL.OFS,'',"DM.OFS.SRC.VAL",'')

    OFS.RESP= ""; TXN.COMMIT = "" ;* R22 Manual conversion - Start
* CALL OFS.GLOBUS.MANAGER("DM.OFS.SRC.VAL", FINAL.OFS)
*CALL OFS.CALL.BULK.MANAGER("DM.OFS.SRC.VAL", FINAL.OFS, OFS.RESP, TXN.COMMIT) ;* R22 Manual conversion - End
    EB.Interface.OfsCallBulkManager("DM.OFS.SRC.VAL", FINAL.OFS, OFS.RESP, TXN.COMMIT) ;*Manual R22 Conversion - Call Routine Fomrat Modified
    REQ = FINAL.OFS
    RES = ""
    OPTIONS<1> = "FT.BULK"

*   CALL OFS.CALL.BULK.MANAGER(OPTIONS, REQ, RES, TXNCOMMITTED)
*    CALL JOURNAL.UPDATE('')
EB.TransactionControl.JournalUpdate('');* R22 UTILITY AUTO CONVERSION

*    Y.INFO<-1> = RES:"*":RES:"*"

*    IF TXNCOMMITTED EQ 0 THEN
*        Y.INFO<-1> = "NO EXISTE EL BENEFICIARIO"
*    END
*    IF TXNCOMMITTED EQ 1 THEN
*        Y.INFO<-1> = "OK"
*    END


    Y.INFO<-1> = FINAL.OFS    ;* "Mensaje ..."

RETURN

END
