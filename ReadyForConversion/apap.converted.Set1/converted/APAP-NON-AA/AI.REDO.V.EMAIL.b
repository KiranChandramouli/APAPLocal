SUBROUTINE AI.REDO.V.EMAIL(Y.EMAIL.TXT)
*-----------------------------------------------------------------------------
* This subroutine will validate a field containing an e-mail address.
*-----------------------------------------------------------------------------
*       Revision History
*
*       First Release:  February 8th
*       Developed for:  APAP
*       Developed by:   Martin Macias - Temenos - MartinMacias@temenos.com
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB VALIDA
RETURN

*---------
VALIDA:
*---------

    ER.STR.GLOBAL = "[^a-zA-Z0-9@_.-]"
    ER.STR.ID = "[^a-zA-Z0-9_.-]"
    ER.STR.DOM = "[^a-zA-Z0-9.-]"
    ER.STR.SPC = "[_.-]"

    IF REGEXP(Y.EMAIL.TXT,ER.STR.GLOBAL) NE 0 THEN
        ETEXT ='AI-INVALID.EMAIL'
        CALL STORE.END.ERROR
        RETURN
    END

    EMAIL.ID = FIELD(Y.EMAIL.TXT,"@",1)
    EMAIL.DOM = Y.EMAIL.TXT[LEN(EMAIL.ID)+2,LEN(Y.EMAIL.TXT)-LEN(EMAIL.ID)+1]

    IF LEN(EMAIL.ID) EQ 0 OR LEN(EMAIL.DOM) EQ 0 THEN
        ETEXT ='AI-INVALID.EMAIL'
        CALL STORE.END.ERROR
        RETURN
    END

    IF REGEXP(EMAIL.DOM,ER.STR.DOM) NE 0 OR REGEXP(EMAIL.ID,ER.STR.ID) NE 0 THEN
        ETEXT ='AI-INVALID.EMAIL'
        CALL STORE.END.ERROR
        RETURN
    END

    IF EMAIL.DOM[LEN(EMAIL.DOM),1] EQ '.' THEN
        ETEXT ='AI-INVALID.EMAIL'
        CALL STORE.END.ERROR
        RETURN
    END

*       ID Process

    PREV.SPC = 'N'
    FOR I.VAR = 1 TO LEN(EMAIL.ID)
        IF REGEXP(EMAIL.ID[I.VAR,1],ER.STR.SPC) NE 0 THEN
            IF PREV.SPC EQ 'Y' OR I.VAR EQ 1 OR I.VAR EQ LEN(EMAIL.ID) THEN
                ETEXT ='AI-INVALID.EMAIL'
                CALL STORE.END.ERROR
                RETURN
            END
            PREV.SPC = 'Y'
        END ELSE
            PREV.SPC = 'N'
        END

    NEXT I.VAR

    NOT.END = 0
    Y.CNT.DOM = 0
    LOOP WHILE NOT.END EQ 0 DO
        Y.CNT.DOM += 1
        PREV.DOM = FIELD(EMAIL.DOM,".",1)

        IF LEN(PREV.DOM) EQ 0 THEN
            ETEXT ='AI-INVALID.EMAIL'
            CALL STORE.END.ERROR
            NOT.END = 1
            RETURN
        END

        IF PREV.DOM NE EMAIL.DOM THEN
            EMAIL.DOM = EMAIL.DOM[LEN(PREV.DOM)+2,LEN(EMAIL.DOM)-LEN(PREV.DOM)+1]
        END ELSE
            EMAIL.DOM = ''
            NOT.END = 1
        END

        IF Y.CNT.DOM GE 2 THEN
            IF LEN(PREV.DOM) LT 2 OR LEN(PREV.DOM) GT 4 THEN
                ETEXT ='AI-INVALID.EMAIL'
                CALL STORE.END.ERROR
                RETURN
            END
        END

        PREV.SPC = 'N'
        FOR I.VAR = 1 TO LEN(PREV.DOM)
            IF REGEXP(PREV.DOM[I.VAR,1],ER.STR.SPC) NE 0 THEN
                IF PREV.SPC EQ 'Y' OR I.VAR EQ 1 OR I.VAR EQ LEN(PREV.DOM) THEN
                    ETEXT ='AI-INVALID.EMAIL'
                    CALL STORE.END.ERROR
                    RETURN
                END
                PREV.SPC = 'Y'
            END ELSE
                PREV.SPC = 'N'
            END
        NEXT I.VAR

    REPEAT

    IF Y.CNT.DOM LT 2 THEN
        ETEXT ='AI-INVALID.EMAIL'
        CALL STORE.END.ERROR
        RETURN
    END

RETURN

END
