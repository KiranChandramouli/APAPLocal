$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.RATE.CHANGE
*---------------------------------------------------
*Description: This is conversion routine to decide on the Version's.
*---------------------------------------------------
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

    GOSUB PROCESS
RETURN
*---------------------------------------------------
PROCESS:
*---------------------------------------------------

    IF O.DATA ELSE
        RETURN
    END

    BEGIN CASE

        CASE O.DATA EQ 'EXTRACT'
            O.DATA = 'REDO.RATE.CHANGE,EXTRACT.INPUT'
        CASE O.DATA EQ 'MASSIVE'
            O.DATA = 'REDO.RATE.CHANGE,MASSIVE.INPUT'
        CASE O.DATA EQ 'REPLACE'
            O.DATA = 'REDO.RATE.CHANGE,REPLACE.INPUT'
    END CASE

RETURN
END
