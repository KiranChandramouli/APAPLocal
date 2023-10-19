* @ValidationCode : MjoxMTg5OTM5MjMzOkNwMTI1MjoxNjgxMzg0NDMzODAzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 16:43:53
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
SUBROUTINE MB.E.DSF.GET.PERIOD(Y.DATA)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MB.SDB.POST

    IF R.NEW(SDB.POST.OFFER.EXPIRY.DATE) GT TODAY THEN
        FROM.DATE = TODAY
    END ELSE
        FROM.DATE = R.NEW(SDB.POST.OFFER.EXPIRY.DATE)
    END

    TO.DATE = R.NEW(SDB.POST.RENEW.FREQUENCY)[1,8]
    Y.DATA = OCONV(ICONV(FROM.DATE,"D"), "D4-E"):" To ":OCONV(ICONV(TO.DATE,"D4"), "D4")

RETURN

END
