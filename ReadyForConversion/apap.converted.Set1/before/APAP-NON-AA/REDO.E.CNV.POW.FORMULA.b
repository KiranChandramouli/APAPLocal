*-----------------------------------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------------------------------
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
