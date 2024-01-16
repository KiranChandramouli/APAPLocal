* @ValidationCode : MjotMTIxNjA0NDEzNjpDcDEyNTI6MTY5MDQzNDA4NTgzMjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Jul 2023 10:31:25
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
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*26-07-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED
*----------------------------------------------------------------------------------------
SUBROUTINE L.APAP.PASSBOOK.PRINT.OVRD
    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.TELLER ;*R22 MANUAL CONVERSION END

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


