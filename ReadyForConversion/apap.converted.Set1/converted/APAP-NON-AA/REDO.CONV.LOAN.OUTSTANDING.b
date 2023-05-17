SUBROUTINE REDO.CONV.LOAN.OUTSTANDING
*-----------------------------------------------------
*Description: This routine is to display the header
*-----------------------------------------------------

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
