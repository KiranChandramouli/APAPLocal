SUBROUTINE REDO.V.VAL.ARC.STATUS
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a validation routine to the version CR.CONTACT.LOG,REDO.PWD.AMEND to
* make the field CONTACT.NOTES mandatory if STATUS ne ACEPTA or FIRMADO
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 24-AUG-2011     SHANKAR RAJU     ODR-2011-07-0162     Initial Creation
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CR.CONTACT.LOG

    GOSUB CHECK.NOTES

RETURN
*-------------------------------------------------------------------------
CHECK.NOTES:
*~~~~~~~~~~~

    Y.CONTACT.STATUS = R.NEW(CR.CONT.LOG.CONTACT.STATUS)
    Y.CONTACT.NOTES = R.NEW(CR.CONT.LOG.CONTACT.NOTES)

    IF COMI EQ '' THEN
        IF Y.CONTACT.STATUS NE 'FIRMADO' THEN
            AF = CR.CONT.LOG.CONTACT.NOTES
            ETEXT = 'EB-REDO.ENTER.COMMENT'
            CALL STORE.END.ERROR
        END
    END

RETURN
*-------------------------------------------------------------------------
END
