SUBROUTINE REDO.AUTH.CUSTID.CHECK
*--------------------------------------------------------------------------------------------------------------------------------
*   DESCRIPTION :
*
*   LAUNCHES NEXT VERSION
*
*--------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JOAQUIN COSTA
*
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------------------------------
* Date             Author          Reference         Description
* MAR-30-2012      J COSTA         GRUPO 7           Initial creation
* FEB-11-2013      Pradeep S       PACS00249000      New task changed to Next Task

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_REDO.ID.CARD.CHECK.COMMON
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
*CALL EB.SET.NEW.TASK(WNEXT.VERSION)
    CALL EB.SET.NEXT.TASK(WNEXT.VERSION)  ;* PACS00249000 - S/E
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1
*
    WNEXT.VERSION = R.NEW(REDO.CUS.PRF.T24.VERSION) : " I F3"
*
RETURN
*
* =========
OPEN.FILES:
* =========
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

        END CASE
*       Increase
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*
END
