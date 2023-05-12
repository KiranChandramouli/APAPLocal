$PACKAGE APAP.TAM
SUBROUTINE REDO.RE.GET.ARC.USER(CUSTOMER.IDENTITY)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached to EB.CONTEXT to get the loan paid percentage.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 24-AUG-2011     SHANKAR RAJU     ODR-2011-07-0162     Initial Creation
** 13-04-2023 R22 Auto Conversion no changes
** 13-04-2023 Skanda R22 Manual Conversion - No changes
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.EXTERNAL.USER

    GOSUB SEL.FILES
    GOSUB PROCESS

RETURN

SEL.FILES:
*---------
    FN.EB.EXTERNAL.USER = 'F.EB.EXTERNAL.USER'
    F.EB.EXTERNAL.USER  = ''
    CALL OPF(FN.EB.EXTERNAL.USER,F.EB.EXTERNAL.USER)

    SEL.CMD = "SELECT ":FN.EB.EXTERNAL.USER:" WITH CUSTOMER EQ ":CUSTOMER.IDENTITY:" AND CHANNEL EQ INTERNET"
    CALL EB.READLIST(SEL.CMD,ARC.ID.LST,'',NO.OF.REC.ARR,SEL.ERR)

RETURN

PROCESS:
*-------

    IF ARC.ID.LST THEN
        CUSTOMER.IDENTITY = 0
    END ELSE
        CUSTOMER.IDENTITY = 1
    END

RETURN

END
