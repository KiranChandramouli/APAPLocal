$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.CLASSIFICATION
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Karthik T
* PROGRAM NAME: REDO.E.CNV.CLASSIFICATION
* ODR NO      : ODR-2010-03-0087
*-----------------------------------------------------------------------------
*DESCRIPTION: This routine is for displaying selection criteria at the header of the report
*

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM and CONVERT to CHANGE
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
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

    Y.SELECTION = O.DATA
    CHANGE '*' TO @FM IN Y.SELECTION     ;*R22 Auto Conversion  - CONVERT to CHANGE
    Y.DATA = Y.SELECTION<1>
    YCNT = DCOUNT(Y.SELECTION,@FM)
    Y.OUT.DATA = ''
    FOR II = 1 TO YCNT
        IF Y.SELECTION<II> NE '' THEN
            Y.OUT.DATA := Y.SELECTION<II>:','
        END
    NEXT II
    YY.DATA = LEN(Y.OUT.DATA)
    IF Y.OUT.DATA[YY.DATA,1] EQ ',' THEN
        Y.OUT.DATA = Y.OUT.DATA[1,YY.DATA-1]
    END
    IF Y.OUT.DATA EQ '' THEN
        Y.OUT.DATA='ALL'
    END
    O.DATA = Y.OUT.DATA
RETURN
END
