$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.LOAN.OUTSTANDING
*-----------------------------------------------------
*Description: This routine is to display the header
*-----------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - SM to @SM
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    GOSUB PROCESS

RETURN
*-----------------------------------------------------
PROCESS:
*-----------------------------------------------------
    Y.FIELD.NAME = O.DATA

    LOCATE Y.FIELD.NAME IN ENQ.SELECTION<2,1> SETTING POS1 THEN
        Y.SEL.VALUES = ENQ.SELECTION<4,POS1>
        CHANGE @SM TO ' ' IN Y.SEL.VALUES
        O.DATA = Y.SEL.VALUES
    END ELSE
        O.DATA = ''
    END



RETURN
END
