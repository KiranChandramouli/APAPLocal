$PACKAGE APAP.LAPAP
SUBROUTINE  L.APAP.JSON.PARSE(JSON.ITEM, DATA.ITEM, Y.UNROLL.ARRAY, Y.ERROR)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - Include to Insert , D to D.VAR , ++ to += , = to EQ and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

*PARSE.OBJECT subroutine.
*----------------------------------------------------------------------------------------------------------------------------------------------------
*Vars
    ST.POS = 1
    FN.POS = LEN(JSON.ITEM)
    JSON.ERROR = 0

    ST.DELIMIT = ""
    FN.DELIMIT = ""
    TP.DELIMIT = ""

    ST.DEPTH = 1
    FN.DEPTH = 1
    ST.INDEX = 0
    FN.INDEX = 0

    DATA.ITEM.TYPE = ""

*CLEAR OUTPUUT VARIABLE
    DATA.ITEM = ''
    Y.ERROR = ''
    Y.ERROR<3> = 'L.APAP.JSON.PARSE'
*----------------------------------------------------------------------------------------------------------------------------------------------------
*Parsing JSON
START:
*DEBUG
    BEGIN CASE
        CASE JSON.ITEM[ST.POS,1] EQ "{"
            GOSUB PARSE.OBJECT
        CASE JSON.ITEM[ST.POS,1] EQ "["
            GOSUB PARSE.ARRAY
        CASE 1;
            JSON.ERROR = ST.POS
            Y.ERROR<1> = 1
            Y.ERROR<2> = 'PASE ERRRO AT POS: ' : JSON.ERROR
    END CASE
*DEBUG
GOSUB END
RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------
PARSE.OBJECT:
    ST.POS += 1
    ERROR.CHECK.POS = 0
*
    LOOP
    UNTIL JSON.ITEM[ST.POS,1] = "}" OR ST.POS >= FN.POS OR JSON.ERROR > 0 DO
        IF ST.POS EQ ERROR.CHECK.POS THEN
*** We have not moved any further.  Parsing error
*
            JSON.ERROR = ST.POS
        END
        ERROR.CHECK.POS = ST.POS
*
*** Parse the information
*
        GOSUB PARSE.KEY
        GOSUB PARSE.VALUE
*
*** Add the Data
*

        IF Y.UNROLL.ARRAY EQ 'Y' THEN
            DATA.ITEM<1,-1> = KEY.NAME
            DATA.ITEM<2,-1> = VALUE
            DATA.ITEM<3,-1> = DATA.ITEM.TYPE
        END
        ELSE
            LOCATE KEY.NAME IN DATA.ITEM<1> SETTING KEY.POS THEN
                DATA.ITEM<2,KEY.POS,-1> = VALUE
                DATA.ITEM<3,KEY.POS,-1> = DATA.ITEM.TYPE
            END ELSE
                DATA.ITEM<1,-1> = KEY.NAME
                DATA.ITEM<2,-1> = VALUE
                DATA.ITEM<3,-1> = DATA.ITEM.TYPE
            END
        END
*
*** Look for comma, since this is another value
*
        TEST.POS = INDEX(JSON.ITEM[ST.POS,FN.POS],"}",1)
        IF TEST.POS EQ 0 THEN
            TEST.POS = FN.POS
        END
*
        NEXT.CHAR = JSON.ITEM[ST.POS,1]
        BEGIN CASE
            CASE NEXT.CHAR EQ ","
                ST.POS += 1
            CASE NEXT.CHAR EQ "}"
* do nothing
            CASE 1
                POS = INDEX(JSON.ITEM[ST.POS,TEST.POS],",",1)
                IF POS GT 0 THEN
*** Place Pointer just after the ','
*
                    ST.POS += POS
                END ELSE
*** Place the pointer on the "}"
*
                    ST.POS = ST.POS + TEST.POS - 1
                END
        END CASE
    REPEAT
    ST.POS += 1
RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------
PARSE.ARRAY:
*DEBUG
    ST.POS += 1
    ERROR.CHECK.POS = 0
*
    LOOP
    UNTIL JSON.ITEM[ST.POS,1] = "]" OR ST.POS >= FN.POS OR JSON.ERROR > 0 DO
        IF ST.POS EQ ERROR.CHECK.POS THEN
*** We have not moved any further.  Parsing error
*
            JSON.ERROR = ST.POS
        END
        ERROR.CHECK.POS = ST.POS
*
*** Parse the information
*
        KEY.NAME = 'ARRAY'
        GOSUB PARSE.VALUE
*
*** Add the Data
*
        IF Y.UNROLL.ARRAY EQ 'Y' THEN
            DATA.ITEM<1,-1> = KEY.NAME
            DATA.ITEM<2,-1> = VALUE
            DATA.ITEM<3,-1> = DATA.ITEM.TYPE
        END
        ELSE
            LOCATE KEY.NAME IN DATA.ITEM<1> SETTING KEY.POS THEN
                DATA.ITEM<2,KEY.POS,-1> = VALUE
                DATA.ITEM<3,KEY.POS,-1> = DATA.ITEM.TYPE
            END ELSE
                DATA.ITEM<1,-1> = KEY.NAME
                DATA.ITEM<2,-1> = VALUE
                DATA.ITEM<3,-1> = DATA.ITEM.TYPE
            END
        END

*
*** Look for comma, since this is another value
*
        TEST.POS = INDEX(JSON.ITEM[ST.POS,FN.POS],"}",1)
        IF TEST.POS EQ 0 THEN
            TEST.POS = FN.POS
        END
*
        NEXT.CHAR = JSON.ITEM[ST.POS,1]
        BEGIN CASE
            CASE NEXT.CHAR EQ ","
                ST.POS += 1
            CASE NEXT.CHAR EQ "}"
* do nothing
            CASE 1
                POS = INDEX(JSON.ITEM[ST.POS,TEST.POS],",",1)
                IF POS GT 0 THEN
*** Place Pointer just after the ','
*
                    ST.POS += POS
                END ELSE
*** Place the pointer on the "}"
*
                    ST.POS = ST.POS + TEST.POS - 1
                END
        END CASE
    REPEAT
    ST.POS += 1
RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------
PARSE.SUB.OBJECT:
*DEBUG
    ST.DELIMIT = "{"
    FN.DELIMIT = "}"
    TP.DELIMIT = "OBJECT"
    GOSUB PARSE.DELIMIT
RETURN

PARSE.SUB.ARRAY:
*DEBUG
    ST.DELIMIT = "["
    FN.DELIMIT = "]"
    TP.DELIMIT = "ARRAY"
    GOSUB PARSE.DELIMIT
RETURN

PARSE.DELIMIT:
*DEBUG
    POS = 1
    TEST.POS = 0
    EXIT.DEPTH = 0
    OCCUR = 1

    IF JSON.ITEM[ST.POS,1] EQ ST.DELIMIT THEN
        TEST.POS = ST.POS + POS

        LOOP
        UNTIL JSON.ERROR > 0  OR EXIT.DEPTH > 0
            FN.INDEX = INDEX(JSON.ITEM[TEST.POS,FN.POS],FN.DELIMIT,OCCUR)
            ST.INDEX = INDEX(JSON.ITEM[TEST.POS,FN.POS],ST.DELIMIT,OCCUR)

            IF ST.INDEX EQ 0 AND FN.INDEX EQ 0 THEN
                JSON.ERROR = ST.POS
            END

            IF ST.INDEX EQ 0 OR ST.INDEX GT FN.INDEX THEN
                ST.DEPTH += 1
                TEST.POS += FN.INDEX
                POS = FN.INDEX  + 1
                EXIT.DEPTH = ST.DEPTH
                DATA.ITEM.TYPE = TP.DELIMIT
            END
            ELSE
                OCCUR += 1
            END
        REPEAT
    END
*DEBUG
    VALUE = JSON.ITEM[ST.POS,POS]
*VALUE = "TEST.ARRAY.VALUE"
    ST.POS += POS
RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------
PARSE.KEY:
*DEBUG
    DELIMIT.STOP = 0
    OCCUR = 1

*To ignore spcaes
    Y.QUOTE = JSON.ITEM[ST.POS,1]
    LOOP
    WHILE Y.QUOTE = " " DO
        ST.POS += 1
        Y.QUOTE = JSON.ITEM[ST.POS,1]
    REPEAT

*To ignore semi colon delimiter bettween quotes/single quote
    IF Y.QUOTE EQ '"' OR Y.QUOTE EQ "'" THEN
        OCCUR += 1
        LOOP
            POS = INDEX(JSON.ITEM[ST.POS,FN.POS],Y.QUOTE,OCCUR)
            BEGIN CASE
                CASE JSON.ITEM[ST.POS + POS - 2,2]  EQ '\"'
                    OCCUR += 1
                CASE JSON.ITEM[ST.POS + POS - 1,1]  NE Y.QUOTE
                    OCCUR += 1
                CASE 1
                    DELIMIT.STOP = 1
            END CASE
        UNTIL DELIMIT.STOP DO
        REPEAT
    END

*DEBUG
    OCCUR = 1
    POS.DC = INDEX(JSON.ITEM[ST.POS + POS,FN.POS],":",OCCUR)
    POS  += POS.DC


    KEY.NAME = JSON.ITEM[ST.POS,POS-1]
*
    ST.POS += POS
*
    IF KEY.NAME[1,1] EQ '"' OR KEY.NAME[1,1] EQ "'" THEN
        Y.QUOTE = KEY.NAME[1,1]
        LAST.CHAR = KEY.NAME[LEN(KEY.NAME),1]
        IF KEY.NAME EQ LAST.CHAR THEN
            JSON.ERROR = ST.POS
        END
*
        VALUE = KEY.NAME[2,LEN(KEY.NAME)-2]
        GOSUB PROCESS.ESCAPE
*DEBUG
        KEY.NAME = VALUE

    END
RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------
PROCESS.ESCAPE:
*** Process the escape values in a string

    DELIMITS = OCONV(VALUE,"MC/N" :@VM: "MC/A")
    IF INDEX(DELIMITS,"\",1) THEN
        C.COUNT = 1
        LOOP
            C.POS = INDEX(VALUE,"\",C.COUNT)
        UNTIL C.POS = 0 DO
            NEXT.CHAR = VALUE[C.POS+1,1]
            BEGIN CASE
                CASE NEXT.CHAR EQ "\" OR NEXT.CHAR EQ "/" OR NEXT.CHAR EQ "'" OR NEXT.CHAR EQ '"'
                    VALUE = VALUE[1,C.POS] :NEXT.CHAR: VALUE[C.POS+2,LEN(VALUE)]
                    C.COUNT += 1
                CASE NEXT.CHAR EQ "f"
                    VALUE = VALUE[1,C.POS] :CHARX(12): VALUE[C.POS+2,LEN(VALUE)]
                CASE NEXT.CHAR EQ "n"
                    VALUE = VALUE[1,C.POS] :CHARX(10): VALUE[C.POS+2,LEN(VALUE)]
                CASE NEXT.CHAR EQ "r"
                    VALUE = VALUE[1,C.POS] :CHARX(13): VALUE[C.POS+2,LEN(VALUE)]
                CASE NEXT.CHAR EQ "t"
                    VALUE = VALUE[1,C.POS] :CHARX(9): VALUE[C.POS+2,LEN(VALUE)]
                CASE NEXT.CHAR EQ "u"
                    HEX.VALUE = VALUE[C.POS+1,4]
                    VALUE = VALUE[1,C.POS] :OCONV(HEX.VALUE,"MY"): VALUE[C.POS+6,LEN(VALUE)]
            END CASE
        REPEAT
    END
RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------
PARSE.VALUE:
*DEBUG
    NEXT.CHAR = JSON.ITEM[ST.POS,1]
    LOOP
    WHILE NEXT.CHAR EQ " " OR NEXT.CHAR EQ CHARX(09) OR NEXT.CHAR EQ CHARX(10) OR NEXT.CHAR EQ CHARX(13) DO
        ST.POS += 1
        NEXT.CHAR = JSON.ITEM[ST.POS,1]
    REPEAT

*DEBUG
    BEGIN CASE
        CASE NEXT.CHAR EQ "{"      ;* Parse Object
            GOSUB PARSE.SUB.OBJECT
*        CASE NEXT.CHAR = "["      ;* Parse Array
        CASE NEXT.CHAR EQ "["      ;* Parse Array;* R22 UTILITY AUTO CONVERSION
            GOSUB PARSE.SUB.ARRAY
*        CASE NEXT.CHAR = "t"      ;* Value: True
        CASE NEXT.CHAR EQ "t"      ;* Value: True;* R22 UTILITY AUTO CONVERSION
            GOSUB PARSE.TRUE
*        CASE NEXT.CHAR = "f"      ;* Value: False
        CASE NEXT.CHAR EQ "f"      ;* Value: False;* R22 UTILITY AUTO CONVERSION
            GOSUB PARSE.FALSE
*        CASE NEXT.CHAR = "n"      ;* Value: Null
        CASE NEXT.CHAR EQ "n"      ;* Value: Null;* R22 UTILITY AUTO CONVERSION
            GOSUB PARSE.NULL
*        CASE NEXT.CHAR = "'" OR NEXT.CHAR = '"' OR NEXT.CHAR = \"\
        CASE NEXT.CHAR EQ "'" OR NEXT.CHAR EQ '"' OR NEXT.CHAR EQ \"\;* R22 UTILITY AUTO CONVERSION
            GOSUB PARSE.STRING
        CASE 1
            GOSUB PARSE.NUMBER
    END CASE
RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------
PARSE.TRUE:
*DEBUG
    POS = 4
    VALUE = JSON.ITEM[ST.POS,POS]
    ST.POS += POS
    DATA.ITEM.TYPE = "BOOLEAN"
RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------
PARSE.FALSE:
*DEBUG
    POS = 5
    VALUE = JSON.ITEM[ST.POS,POS]
    ST.POS += POS
    DATA.ITEM.TYPE = "BOOLEAN"
RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------
PARSE.NULL:
*DEBUG
    POS = 4
    VALUE = JSON.ITEM[ST.POS,POS]
    ST.POS += POS
    DATA.ITEM.TYPE = "NULL"
RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------
PARSE.STRING:
    VALUE = ""
*
    Y.QUOTE = JSON.ITEM[ST.POS,1]
    ST.POS += 1
*
*** Find the next quote, but make sure we check for escaped
*** quotes.
*
    DELIMIT.STOP = 0
    OCCUR = 1
    LOOP
        QUOTE.POS = INDEX(JSON.ITEM[ST.POS,FN.POS],Y.QUOTE,OCCUR)
        BEGIN CASE
            CASE QUOTE.POS EQ 0
                QUOTE.POS = FN.POS + 1
            CASE JSON.ITEM[ST.POS + QUOTE.POS - 1,1] EQ "\"
                OCCUR += 1
            CASE 1
                DELIMIT.STOP = 1
        END CASE
    UNTIL DELIMIT.STOP DO
    REPEAT
*
*** Get the value, and translate the escaped information
*
    VALUE = JSON.ITEM[ST.POS,QUOTE.POS-1]
    GOSUB PROCESS.ESCAPE
    ST.POS += QUOTE.POS
    DATA.ITEM.TYPE = "STRING"
RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------
PARSE.NUMBER:
*DEBUG
    D.VAR = 1
    LOOP
        DELIMIT = OCONV(JSON.ITEM[ST.POS,FN.POS],"MC/N":@VM:"MC/A")[D.VAR,1]
    UNTIL INDEX(",}]",DELIMIT,1) DO
        D.VAR += 1
    REPEAT
    POS = INDEX(JSON.ITEM[ST.POS,FN.POS],DELIMIT,1) - 1
    VALUE = JSON.ITEM[ST.POS,POS]
    ST.POS += POS
    DATA.ITEM.TYPE = "NUMBER"
RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------
END:
*DEBUG
RETURN
END
