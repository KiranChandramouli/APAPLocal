SUBROUTINE REDO.FI.RCL.USD
******************************************************************************
*
*    Provides Currency code
*
* =============================================================================
*
*    First Release : Adriana Velasco
*    Developed for : APAP
*    Developed by  : Adriana velasco
*    Date          : 2010/Oct/20
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.VERSION
*
*************************************************************************
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
* ======
PROCESS:
* ======
*
*
    COMI = "DOP"
RETURN
*
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD = 1
*
*
RETURN
*
*
* ---------
OPEN.FILES:
* ---------
*
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 1

    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1

        END CASE
        LOOP.CNT +=1
    REPEAT
*
RETURN
*
END
