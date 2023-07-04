$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.POW.FORMULA
*-----------------------------------------------------------------------------------------------------
* DESCRIPTION : This CONVERSION routine should be attached to the below ENQUIRY REDO.SEC.TRADE.EFF.RATE
*------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.E.CNV.DAYS.TO.MAT
*------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference           Description
* 19 Oct 2010      Naveen Kumar N     ODR-2010-07-0081    Initial creation
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*-------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*-------------------------------------------------------------------------------------------------------
    Y.DATA = O.DATA
    O.DATA = PWR(O.DATA,-1)
*-------------------------------------------------------------------------------------------------------
RETURN
END
