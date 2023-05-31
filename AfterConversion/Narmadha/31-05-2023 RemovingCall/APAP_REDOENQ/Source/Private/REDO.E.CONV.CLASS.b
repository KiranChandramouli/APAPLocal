$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.CLASS
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
*
    Y.DATA = O.DATA
    Y.LEN = LEN(Y.DATA)
    O.DATA = Y.DATA[1,Y.LEN-1]
*
RETURN
*
END
