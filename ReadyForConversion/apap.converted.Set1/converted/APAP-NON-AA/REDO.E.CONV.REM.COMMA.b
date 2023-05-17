SUBROUTINE REDO.E.CONV.REM.COMMA
****************************************************
*Company Name: Asociacion Popular de Ahorros y Prestamos
*Program Name: REDO.E.CONV.ABS.RTN
************************************************************
*Description: This conversion routine returns the entered selection values seperated by comma
************************************************************
*Modification Details:
*=====================
*      Date          Who             Reference               Description
*     ------         -----           -------------           -------------
*   10/09/2010       SHANKAR RAJU    0DR-2010-07-0073 FX002  Initial Creation
*******************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

*Process Para:
***************

    FINAL.CLASS = ''
    Y.CLASSIF = O.DATA
    TOT.CLAS = DCOUNT(Y.CLASSIF,',')
    Y.START = 1
    LOOP
    WHILE Y.START LE TOT.CLAS
        Y.CLASS.VAL = FIELD(Y.CLASSIF,',',Y.START)
        IF Y.CLASS.VAL NE '' THEN
            IF FINAL.CLASS EQ '' THEN
                FINAL.CLASS = Y.CLASS.VAL
            END ELSE
                FINAL.CLASS := ',':Y.CLASS.VAL
            END
        END
        Y.START += 1
    REPEAT

    O.DATA=FINAL.CLASS

RETURN

END
