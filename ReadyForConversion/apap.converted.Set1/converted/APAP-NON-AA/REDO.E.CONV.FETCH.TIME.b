SUBROUTINE REDO.E.CONV.FETCH.TIME
*********************************************************************************
*Company Name: ASOCIACION POPULAR DE AHORROS Y PRISTAMOS
*Program Name: REDO.E.CONV.FETCH.TIME
*********************************************************************************
*Modification Details:
*=====================
*      Date          Who             Reference               Description
*     ------         -----           -------------           -------------
*    23 SEP 2010   MD Preethi       0DR-2010-03-131          Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

*-------------------------------------------------------------------------------------------------------
**********
*MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    Y.TIME.DATE = TIMEDATE()
    O.DATA = Y.TIME.DATE[1,8]

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
