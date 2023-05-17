SUBROUTINE REDO.APAP.SEL.CRIT.DISPLAY
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.SEL.CRIT.DISPLAY
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.APAP.SEL.CRIT.DISPLAY is the convertion Routine
*This routine is attached to Nofile Enquiry to Display the Selection Criteris Label & Values in Header Section
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who            ODR Reference      Description
*   ------         ------           -------------     ------------------
* 24 DEC 2010    Satish@Contractor  ODR-2011-03-0083  Initial Creation
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    SEL.VAL = FIELD(O.DATA,'#',1)
    SEL.LAB = FIELD(O.DATA,'#',2)

    Y.DATA = '';  SEL.CT = DCOUNT(SEL.LAB,'*')-1
    FOR II = 1 TO SEL.CT
        IF FIELD(SEL.VAL,'*',II) THEN
            Y.DATA:= FIELD(SEL.LAB,'*',II):' : ':FIELD(SEL.VAL,'*',II):' - '
        END
    NEXT II
    CHANGE @SM TO ' ' IN Y.DATA
    O.DATA = Y.DATA

RETURN

END
