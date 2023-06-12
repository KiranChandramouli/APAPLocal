$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.DAYS.TO.MAT
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This is a conversion routine used in the enquiry REDO.SEC.TRADE.EFF.RATE
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.E.CNV.DAYS.TO.MAT
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference           Description
* 19 Oct 2010      Naveen Kumar N     ODR-2010-07-0081    Initial creation
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.SEC.TRADE
*------------------------------------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------------------------------------
*****
INIT:
*****
    FN.SEC.TRADE = "F.SEC.TRADE"
    F.SEC.TRADE  = ""
    R.SEC.TRADE  = ""
    E.SEC.TRADE  = ""
    CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)
RETURN
*------------------------------------------------------------------------------------------------------
********
PROCESS:
********
    CALL F.READ(FN.SEC.TRADE,O.DATA,R.SEC.TRADE,F.SEC.TRADE,E.SEC.TRADE)
    Y.VALUE.DATE  = R.SEC.TRADE<SC.SBS.VALUE.DATE>
    Y.MAT.DATE    = R.SEC.TRADE<SC.SBS.MATURITY.DATE>
    Y.NO.OF.DAYS  = 'C'
    CALL CDD('',Y.VALUE.DATE,Y.MAT.DATE,Y.NO.OF.DAYS)
    O.DATA        = Y.NO.OF.DAYS
RETURN
*------------------------------------------------------------------------------------------------------
END
