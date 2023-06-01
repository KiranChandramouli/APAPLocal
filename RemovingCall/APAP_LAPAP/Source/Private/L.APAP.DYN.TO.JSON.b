* @ValidationCode : MjotMTM3NzYyNjcxODpDcDEyNTI6MTY4NDIxNTQzOTM5NDpJVFNTOi0xOi0xOi0xMToxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 11:07:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -11
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE  L.APAP.DYN.TO.JSON(Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.DYN.RESPONSE.TYPE, Y.OBJECT.TYPE, Y.JSON.RESPONSE, Y.ERROR)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       CHAR to CHARX, = to EQ, BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      CALL RTN FORMAT MODIFIED
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion
    $INSERT I_EQUATE ;*R22 Auto conversion

*Subroutine Convert a Dynamic Array to Json .
*----------------------------------------------------------------------------------------------------------------------------------------------------
*CLEAR OUTPUT VARIAVLE
    Y.JSON.RESPONSE = ''
    Y.ERROR = ''
    Y.ERROR<3> = 'L.APAP.DYN.TO.JSON'
    Y.ITEM.KEY = ''
    Y.ITEM.VALUE = ''
    Y.JSON.ITEM = ''

*DEBUG
    Y.CNT = DCOUNT(Y.DYN.RESPONSE.KEY, @FM)
    FOR V.I = 1 TO Y.CNT STEP 1
        Y.ITEM.KEY = Y.DYN.RESPONSE.KEY<V.I>
        Y.ITEM.VALUE = Y.DYN.RESPONSE.VALUE<V.I>

*JSON ESCAPE CHARATERS
        CHANGE '\' TO '\\' IN Y.ITEM.VALUE
        CHANGE '"' TO '\"' IN Y.ITEM.VALUE
        CHANGE '/' TO '\/' IN Y.ITEM.VALUE
        CHANGE CHARX(9) TO '\t' IN Y.ITEM.VALUE ;*R22 Auto conversion
        CHANGE CHARX(10) TO '\n' IN Y.ITEM.VALUE ;*R22 Auto conversion
        CHANGE CHARX(13) TO '\r' IN Y.ITEM.VALUE ;*R22 Auto conversion

        BEGIN CASE
            CASE Y.ITEM.KEY[1,1] EQ '*'
                Y.JSON.ITEM = '*'
            CASE COUNT(Y.ITEM.VALUE,@SM) GT 0
*CALL L.APAP.SM.TO.JSON.ARRAY(Y.ITEM.VALUE, Y.JSON.ITEM)  ;*R22 MANAUAL CODE CONVERSION
                CALL APAP.LAPAP.lApapSmToJsonArray(Y.ITEM.VALUE, Y.JSON.ITEM)  ;*R22 MANAUAL CODE CONVERSION
                Y.JSON.ITEM = QUOTE(Y.ITEM.KEY) : ':' : Y.JSON.ITEM
            CASE COUNT(Y.ITEM.VALUE,@VM) GT 0
*CALL L.APAP.VM.TO.JSON.ARRAY(Y.ITEM.VALUE, Y.JSON.ITEM) ;*R22 MANUAL CODE CONVERSION
                CALL APAP.LAPAP.lApapVmToJsonArray(Y.ITEM.VALUE, Y.JSON.ITEM)  ;*R22 MANUAL CODE CONVERSION
                Y.JSON.ITEM = QUOTE(Y.ITEM.KEY) : ':' : Y.JSON.ITEM
            CASE 1
                Y.JSON.ITEM = QUOTE(Y.ITEM.KEY) : ':' : QUOTE(Y.ITEM.VALUE)
        END CASE

        IF Y.JSON.ITEM NE '*' THEN
            IF Y.JSON.RESPONSE EQ '' THEN
                Y.JSON.RESPONSE = Y.JSON.ITEM
            END
            ELSE
                Y.JSON.RESPONSE := ',' : Y.JSON.ITEM
            END
        END
    NEXT V.I

    Y.JSON.RESPONSE = '{' : Y.JSON.RESPONSE : '}'

RETURN
END
