$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.DEAL.FILTER(ENQ.DATA)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    LOCATE '@ID' IN ENQ.DATA<2,1> SETTING PAY.POS THEN
        ENQ.DATA<2,-1> = 'TILL.USER'
        ENQ.DATA<3,-1> = 'EQ'
        ENQ.DATA<4,-1> = OPERATOR
    END

RETURN
