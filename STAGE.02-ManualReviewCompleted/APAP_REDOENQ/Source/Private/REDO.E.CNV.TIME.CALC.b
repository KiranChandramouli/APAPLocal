$PACKAGE APAP.REDOENQ
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
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
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
