SUBROUTINE REDO.V.CHK.IDENTITY.TYPE
*--------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Shankar Raju
* PROGRAM NAME : REDO.CHK.CUSTOMER.TYPE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------------------------------
* Date             Author     Reference         Description
*
* 11-10-2011      Sudhar     teller issue  Making PASSPORT.COUNTRY field as non-inputable field
*                                                  to achieve the if Client is other than Passport.
*-----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.ID.CARD.CHECK

    GOSUB MAKE.NO.INPUT

RETURN
*---------------------------------------------------------------------------------------------------------------------------------------------------
MAKE.NO.INPUT:
*-------------

    IF (OFS$HOT.FIELD EQ 'IDENTITY.TYPE') OR (OFS$HOT.FIELD EQ '.IDENTITY.TYPE') THEN
        VAR.ID.TYPE = COMI
    END ELSE
        VAR.ID.TYPE = R.NEW(REDO.CUS.PRF.IDENTITY.TYPE)
    END

    IF VAR.ID.TYPE EQ 'PASAPORTE' THEN
        T(REDO.CUS.PRF.PASSPORT.COUNTRY)<3> = ''
    END ELSE
        R.NEW(REDO.CUS.PRF.PASSPORT.COUNTRY) = ''
        T(REDO.CUS.PRF.PASSPORT.COUNTRY)<3> = 'NOINPUT'
    END

RETURN
*---------------------------------------------------------------------------------------------------------------------------------------------------
END
