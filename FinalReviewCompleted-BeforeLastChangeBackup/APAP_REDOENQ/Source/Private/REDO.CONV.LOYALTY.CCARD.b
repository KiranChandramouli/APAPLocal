$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.LOYALTY.CCARD
*---------------------------------------------------
*Description: This is conversion routine to decide on the Version's.
*---------------------------------------------------
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

    GOSUB PROCESS
RETURN
*---------------------------------------------------
PROCESS:
*---------------------------------------------------


    IF NUM(O.DATA[1,4]) ELSE
        O.DATA = 'TOTALES'
    END

RETURN
END
