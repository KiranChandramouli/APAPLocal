SUBROUTINE REDO.V.CHK.INT.CR.ACBAL
*
*=======================================================================
*
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2012/JUL/19
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.TELLER
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
*--------
PROCESS:
*--------
*
    CALL REDO.VVR.INTER.CR.ACBAL
*
RETURN
*
*----------------------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------------------
*
    PROCESS.GOAHEAD = "1"
*
RETURN
*
*----------
OPEN.FILES:
*----------
*
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 1
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF R.NEW(TT.TE.RECORD.STATUS)[1,3] NE "RNA" THEN
                    PROCESS.GOAHEAD = ""
                END
        END CASE
*
*       Increase
*
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*
END
