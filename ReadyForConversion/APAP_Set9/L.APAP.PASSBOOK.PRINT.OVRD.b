*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.PASSBOOK.PRINT.OVRD
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.TELLER

    SEARCH.STRING = "DESEA IMPRIMIR LIBRETA? NO"
    STRING.TO.BE.SEARCHED = R.NEW(78)
    AUTHORISER = R.NEW(83)
    RECORD.STATUS = R.NEW(79)

    FINDSTR "OFS_BROWSERTC" IN AUTHORISER SETTING FIELD.POSITION, VALUE.POSITION THEN

        CURR.NO = 1

    END ELSE

        FINDSTR SEARCH.STRING IN STRING.TO.BE.SEARCHED SETTING FIELD.POSITION, VALUE.POSITION THEN

            IF RECORD.STATUS NE "INAO" THEN
                TEXT = 'L.APAP.PASSBOOK.PRINT.OVRD'
                CURR.NO = 1
                CALL STORE.OVERRIDE(CURR.NO)
            END 
        END

    END

END


