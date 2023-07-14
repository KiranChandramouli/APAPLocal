$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.CLAIMS.CONTACT.CHANNEL
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
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - F.READ to CACHE.READ
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.CHANNEL

    GOSUB INITIALSE
    GOSUB CHECK.NOTES

RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~~

    FN.EB.CHANNEL = 'F.EB.CHANNEL'
    F.EB.CHANNEL  = ''
    CALL OPF(FN.EB.CHANNEL,F.EB.CHANNEL)

RETURN
*-------------------------------------------------------------------------
CHECK.NOTES:
*~~~~~~~~~~~
    Y.REC.DATA = O.DATA
    CALL CACHE.READ(FN.EB.CHANNEL, Y.REC.DATA, R.CHANNEL, LOOKUP.ERR)  ;*R22 Auto Conversion  - F.READ to CACHE.READ
    IF LNGG EQ 1 THEN
        O.DATA=R.CHANNEL<EB.CHAN.DESC,1>
        RETURN
    END
    IF LNGG EQ 2 THEN
        IF R.CHANNEL<EB.CHAN.DESC,2> THEN
            O.DATA = R.CHANNEL<EB.CHAN.DESC,2>
        END ELSE
            O.DATA = R.CHANNEL<EB.CHAN.DESC,1>
        END
    END
RETURN
*-------------------------------------------------------------------------
END
