*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.E.DSF.GET.PERIOD(Y.DATA)

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

