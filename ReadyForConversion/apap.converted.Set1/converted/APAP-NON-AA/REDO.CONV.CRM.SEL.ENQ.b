SUBROUTINE REDO.CONV.CRM.SEL.ENQ
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* to design drilldown values
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 20-APR-2012         RIYAS      ODR-2011-07-0162     Initial Creation
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CR.CONTACT.LOG

    GOSUB INITIALSE
    GOSUB CHECK.NOTES

RETURN
*~~~~~~~~
INITIALSE:
*~~~~~~~~~

    FN.CR.CONTACT.LOG = 'F.CR.CONTACT.LOG'
    F.CR.CONTACT.LOG  = ''
    CALL OPF(FN.CR.CONTACT.LOG,F.CR.CONTACT.LOG)

RETURN
*~~~~~~~~~~~
CHECK.NOTES:
*~~~~~~~~~~~

    CALL F.READ(FN.CR.CONTACT.LOG,O.DATA,R.CR.CONTACT.LOG,F.CR.CONTACT.LOG,CR.CONTACT.LOG.ERR)
    Y.CONTRACT.ID  = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTRACT.ID>
    Y.CONTACT.TYPE = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.TYPE>

    BEGIN CASE
        CASE Y.CONTACT.TYPE EQ "RECLAMACION"
            GOSUB RECLAMACION
        CASE Y.CONTACT.TYPE EQ "SOLICITUD"
            GOSUB SOLICITUD
        CASE Y.CONTACT.TYPE EQ "QUEJAS"
            GOSUB QUEJAS
    END CASE

RETURN
*~~~~~~~~~~~
RECLAMACION:
*~~~~~~~~~~~

    Y.LEN.CLM.ID = LEN(Y.CONTRACT.ID)
    IF Y.LEN.CLM.ID EQ 14 THEN
        Y.ID.PART1 = '0':Y.CONTRACT.ID[1,3]
        Y.ID.PART2 = Y.CONTRACT.ID[4,4]
        Y.ID.PART3 = Y.CONTRACT.ID[8,2]
        Y.ID.PART4 = Y.CONTRACT.ID[10,5]
    END ELSE
        Y.ID.PART1 = Y.CONTRACT.ID[1,4]
        Y.ID.PART2 = Y.CONTRACT.ID[5,4]
        Y.ID.PART3 = Y.CONTRACT.ID[9,2]
        Y.ID.PART4 = Y.CONTRACT.ID[11,5]
    END

    Y.CLAIMS.ID  = Y.ID.PART1:'-':Y.ID.PART2:'-':Y.ID.PART3:'-':Y.ID.PART4
    O.DATA = 'REDO.ISSUE.CLAIMS,OPEN':' S ':Y.CLAIMS.ID

RETURN
*~~~~~~~~~~~
SOLICITUD:
*~~~~~~~~~~~

    Y.LEN.REQ.ID = LEN(Y.CONTRACT.ID)
    Y.CUS.LENGTH = Y.LEN.REQ.ID - 14
    Y.ID.PART1 = Y.CONTRACT.ID[1,Y.CUS.LENGTH]
    Y.ID.PART2 = Y.CONTRACT.ID[Y.CUS.LENGTH+1,7]
    Y.ID.PART3 = Y.CONTRACT.ID[Y.CUS.LENGTH+8,7]

    Y.REQUEST.ID = Y.ID.PART1:'.':Y.ID.PART2:'.':Y.ID.PART3
    O.DATA = 'REDO.ISSUE.REQUESTS,OPEN':' S ':Y.REQUEST.ID

RETURN
*~~~~~~~~~~~
QUEJAS:
*~~~~~~~~~~~

    Y.LEN.COMP.ID = LEN(Y.CONTRACT.ID)
    Y.CUS.LENGTH = Y.LEN.COMP.ID - 14
    Y.ID.PART1 = Y.CONTRACT.ID[1,Y.CUS.LENGTH]
    Y.ID.PART2 = Y.CONTRACT.ID[Y.CUS.LENGTH+1,7]
    Y.ID.PART3 = Y.CONTRACT.ID[Y.CUS.LENGTH+8,7]

    Y.COMPLAINTS.ID = Y.ID.PART1:'.':Y.ID.PART2:'.':Y.ID.PART3
    O.DATA = 'REDO.ISSUE.COMPLAINTS,OPEN':' S ':Y.COMPLAINTS.ID

RETURN
*-------------------------------------------------------------------------
END
