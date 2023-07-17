$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.PAYMENT.AMT
*----------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    IF O.DATA ELSE
        RETURN
    END
    Y.AMT = FIELD(O.DATA,':',2)
    IF NUM(Y.AMT) AND Y.AMT THEN
        O.DATA = FIELD(O.DATA,':',1):" : ": TRIMB(FMT(Y.AMT,"L2,#19"))
    END


RETURN

END
