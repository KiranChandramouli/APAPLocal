SUBROUTINE REDO.APAP.DEAL.CONV.DATE(SYS.DATE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.APAP.DEAL.CONV.DATE
*Reference Number  : ODR-2007-10-0074
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the date and Convert the date into
*                   dd mon yy (e.g. 01 JAN 09)
*LINKED WITH       :
* ----------------------------------------------------------------------------------
*MODIFICATION HISTORY:
* DATE            WHO             REFERENCE              DESCRIPTION
* 20 JUL 2012     Pradeep S       PACS00209521           Date format changed
*-----------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE


*GOSUB PROCESS
    GOSUB NEW.PROCESS
RETURN

NEW.PROCESS:

    TEMP.COMI = COMI ; TEMP.N1=N1 ; TEMP.T1 = T1
    COMI= SYS.DATE ; N1=8 ; T1=".D"
    CALL IN2D(N1,T1)
    SYS.DATE = V$DISPLAY
    COMI = TEMP.COMI ; N1 = TEMP.N1 ; T1 = TEMP.T1

RETURN

PROCESS:

    Y.DATE  = SYS.DATE
    Y.DAY   = Y.DATE[2]
    Y.YEAR  = Y.DATE[1,4]
    Y.MONTH = Y.DATE[5,2]

    BEGIN CASE

        CASE Y.MONTH EQ 1
            Y.MONTH = 'January'
        CASE Y.MONTH EQ 2
            Y.MONTH = 'February'
        CASE Y.MONTH EQ 3
            Y.MONTH = 'March'
        CASE Y.MONTH EQ 4
            Y.MONTH = 'April'
        CASE Y.MONTH EQ 5
            Y.MONTH = 'May'
        CASE Y.MONTH EQ 6
            Y.MONTH = 'June'
        CASE Y.MONTH EQ 7
            Y.MONTH = 'July'
        CASE Y.MONTH EQ 8
            Y.MONTH = 'August'
        CASE Y.MONTH EQ 9
            Y.MONTH = 'September'
        CASE Y.MONTH EQ 10
            Y.MONTH = 'October'
        CASE Y.MONTH EQ 11
            Y.MONTH = 'November'
        CASE Y.MONTH EQ 12
            Y.MONTH = 'December'

    END CASE

    SYS.DATE = Y.MONTH:' ':Y.DAY:',':' ':Y.YEAR

RETURN
END
