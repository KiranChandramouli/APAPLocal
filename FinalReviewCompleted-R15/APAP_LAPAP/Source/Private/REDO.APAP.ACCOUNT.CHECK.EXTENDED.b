* @ValidationCode : MjotNDczNDMyMzQxOlVURi04OjE2ODQyMjI4MjE2MDA6SVRTUzotMTotMToxOTI6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:21
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 192
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.APAP.ACCOUNT.CHECK.EXTENDED
*----------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*24-04-2023       Samaran T               R22 Manual Code Conversion       Call Routine Format Modified
*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON    ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER     ;*R22 AUTO CODE CONVERSION.END
    $USING APAP.REDOAPAP

    IF VAL.TEXT EQ '' THEN
        GOSUB CHECK.FIDUCIA.ACCT
    END

    APAP.REDOAPAP.redoApapAccountCheck()    ;*R22 MANUAL CODE CONVERSION

RETURN

********************
CHECK.FIDUCIA.ACCT:
********************
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    Y.NUMERO.CTA = COMI

    CALL F.READ(FN.ACCOUNT,Y.NUMERO.CTA,R.ACCOUNT,F.ACCOUNT,R.AC.ERR)

    IF R.ACCOUNT THEN
        Y.AC.CATEG = R.ACCOUNT<AC.CATEGORY>
        IF Y.AC.CATEG EQ '6023' THEN
            APP.ID="ENQ L.APAP.ENQ.CTA.FIDUCIA ACCOUNT.NUMBER EQ " :Y.NUMERO.CTA
            CALL EB.SET.NEW.TASK(APP.ID)
        END
    END

RETURN

END
