FUNCTION redoIsLastDay(yDate)
******************************************************************************
*
*    Check if the date is the last day in its current month
*
* =============================================================================
*
*    First Release : Paul Pasquel
*    Developed for : TAM
*    Developed by  : TAM
*    Date          : 2011-11-12
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
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
RETURN yResult
*
* ======
PROCESS:
* ======
*
*
    COMI = yDate : "M0131"
    Y.DAY = COMI[7,2]
    Y.DAY.TO.CHECK = Y.DAY + 0
    IF Y.DAY.TO.CHECK GT 1 THEN
        Y.DAY -= 1
    END
    COMI = yDate[1,6] : Y.DAY
    CALL CFQ
    yResult = COMI[1,8] EQ yDate
RETURN
*
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD = 1
    yResult = 0
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
*
RETURN
*
END
