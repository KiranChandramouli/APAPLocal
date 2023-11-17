$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.ENQ.TIME
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


    Y.TIME.VAL = ''
    Y.TIME.VAL = TIMEDATE()
    O.DATA = Y.TIME.VAL[1,8]
RETURN
END
