SUBROUTINE REDO.CONV.CLAIMS.DOC.REV
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* display the field description of EB.LOOKUP instead of the ID.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 16-SEP-2011         RIYAS      ODR-2011-07-0162     Initial Creation
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.LOOKUP

    GOSUB CHECK.NOTES

RETURN
*-------------------------------------------------------------------------
CHECK.NOTES:
*~~~~~~~~~~~
    Y.REC.DATA = O.DATA
    IF Y.REC.DATA EQ 'YES' THEN
        O.DATA = 'SI'
    END
RETURN
*-------------------------------------------------------------------------
END
