SUBROUTINE REDO.FI.CALC.CHECK.DIGIT(FI.STANDARD.ACCOUNT,WERROR.MSG)
*
******************************************************************************
*
*    VALIDATES INFORMATION IN APAP STANDARD ACCOUNT NUMBER
*
* =============================================================================
*
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2010-OCT-26
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_REDO.FI.VARIABLES.COMMON
*
*************************************************************************
*
RETURN  ;*BORRAR

GOSUB INITIALISE
GOSUB OPEN.FILES
GOSUB CHECK.PRELIM.CONDITIONS
IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
END
*
RETURN
*
* ======
PROCESS:
* ======
*
    W.SPLIT1 = FI.STANDARD.ACCOUNT[1,4]
    W.SPLIT2 = FI.STANDARD.ACCOUNT[5,24]
*
    W.SPLIT = W.SPLIT2 : W.SPLIT1
    GOSUB A050.CONVERT.STRING
*
    GOSUB A100.CALC.DIGIT
    IF NUMBER NE 1 THEN
        WERROR.MSG = "CANNOT.CREATE.IDX.&-FILE.&.IN.USE"::@FM:NUMBER:@VM:W.SPLIT
        CALL TXT(WERROR.MSG)
    END
*
RETURN
*
* ==================
A050.CONVERT.STRING:
* ==================
*
    FOR I.VAR = 1 TO 28
        YASCII.VALUE = W.SPLIT[I.VAR,1]
        IF NOT(NUM(YASCII.VALUE)) THEN
            YASCII.VALUE = SEQ(YASCII.VALUE) - 55
        END
        NUMBER = NUMBER : YASCII.VALUE
    NEXT
*
RETURN
*
* ==============
A100.CALC.DIGIT:
* ==============
*
    CICLO = 0
*
    LOOP
    WHILE NUMBER GE MODULO DO
        CICLO      +=1
        PART.NUMBER = NUMBER[1,Y.SPLIT.LENGTH]
        NUMBER      = NUMBER[Y.SPLIT.LENGTH + 1, LEN(NUMBER) - Y.SPLIT.LENGTH]
        RESULT      = MOD(PART.NUMBER,MODULO)
        NUMBER      = RESULT : NUMBER
    REPEAT
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD   = 1
    LOOP.CNT          = 1
    MAX.LOOPS         = 1
*
    MODULO            = 97
    Y.SPLIT.LENGTH    = 8
    Y.STD.ACCT.LENGTH = 28
*
    NUMBER = ""
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                IF LEN(FI.STANDARD.ACCOUNT) NE Y.STD.ACCT.LENGTH THEN
                    PROCESS.GOAHEAD = 0
                    WERROR.MSG = "EB-STANDARD.ACCOUNT.LENGTH.ERROR"
                    CALL TXT(WERROR.MSG)
                END

        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*
END
