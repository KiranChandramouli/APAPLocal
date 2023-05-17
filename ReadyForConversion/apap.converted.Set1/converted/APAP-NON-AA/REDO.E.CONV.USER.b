SUBROUTINE REDO.E.CONV.USER
***********************************************************************
*COMPANY NAME : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*DESCRIPTION  : This routine is a conversion rouitne for REDO.E.AA.ARR.ACTIVITY.It will
*return the inputter name
*IN PARAMETER :  NA
*OUT PARAMETER:  NA
*LINKED WITH  :  REDO.E.AA.ARR.ACTIVITY
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*10.07.2010  PRABHU N   ODR-2010-08-0017   INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB INITIALISE
    GOSUB READ.AND.ASSIGN
RETURN

*----------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------


    Y.INPUT.USER = O.DATA

RETURN


*-----------------------------------------------------------------
READ.AND.ASSIGN:
*-----------------------------------------------------------------
* Value of O.DATA is assigned to Customer ID to read the particular customer data
*-----------------------------------------------------------------


    IF INDEX(Y.INPUT.USER, '_', 1) THEN
        O.DATA= Y.INPUT.USER['_', 2, 1]
    END
RETURN
END
