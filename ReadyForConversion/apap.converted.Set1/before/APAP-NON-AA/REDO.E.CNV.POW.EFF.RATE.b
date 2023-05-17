*-----------------------------------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.E.CNV.POW.EFF.RATE
*------------------------------------------------------------------------------------------------------
* DESCRIPTION : This CONVERSION routine should be attached to the below ENQUIRY REDO.SEC.TRADE.EFF.RATE
*-------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.E.CNV.POW.EFF.RATE
*---------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference           Description
* 19 Oct 2010      Naveen Kumar N     ODR-2010-07-0081    Initial creation
* 01 May 2011      Pradeep S          PACS00056285        Effective Rate formula changed
*---------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
*---------------------------------------------------------------------------------------------------------
  Y.DATA  = O.DATA
  Y.PART1 = FIELDS(Y.DATA,'/',1,1)
  Y.PART2 = FIELDS(Y.DATA,'/',2,1)
  RESULT  = PWR(Y.PART1,Y.PART2) - 1    ;*PACS00056285 - S/E
  O.DATA  = RESULT
*----------------------------------------------------------------------------------------------------------
  RETURN
END
