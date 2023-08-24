$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.TAIL.COMO
*--------------------------------------------
*Description: This routine is to tail to the como for enquiry
*--------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    Y.COMO.NAME = O.DATA

    CMD.TAIL = 'tail -50 &COMO&/':Y.COMO.NAME
    EXECUTE CMD.TAIL CAPTURING RESULT
    IF VC EQ 1 THEN
        VM.COUNT = DCOUNT(RESULT,@FM)
        O.DATA = RESULT<VC>
    END ELSE
        O.DATA = RESULT<VC>
    END



RETURN
END
