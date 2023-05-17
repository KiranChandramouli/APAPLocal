SUBROUTINE REDO.E.CNV.TIME.CALC
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Karthik T
* PROGRAM NAME: REDO.E.CNV.TIME.CALC
* ODR NO      : ODR-2010-03-0087
*-----------------------------------------------------------------------------
*DESCRIPTION: This routine is for displaying time at the header of the report
*

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*----------------------------------------------------------------------*

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

*-----------------*
MAIN.PROCESS:
*-----------------*
*Paragragh where actual execution of the program takes place
    GOSUB PROCESS
RETURN
*-------*
PROCESS:
*-------*
    O.DATA = ''
    Y.TIME = TIME()
    Y.CONV = OCONV(Y.TIME,"MTS")
    O.DATA = Y.CONV
RETURN
END
