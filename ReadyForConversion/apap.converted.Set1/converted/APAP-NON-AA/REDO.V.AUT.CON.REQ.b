SUBROUTINE REDO.V.AUT.CON.REQ
*---------------------------------------------------------------------------------
*This is an input routine for the version APAP.H.GARNISH.DETAILS,INP, it will check
*whether the registration of garnishment for APAP customer or not
*----------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : BHARATH C
* Program Name  : REDO.V.INP.GARNISHMENT.MAINT
* ODR NUMBER    : ODR-2009-10-0531
* HD Reference  : HD1016159
*LINKED WITH:APAP.H.GARNISH.DETAILS AS version routine
*----------------------------------------------------------------------
*Input param = none
*output param =none
*-----------------------------------------------------------------------
*MODIFICATION DETAILS:
*4.1.2010       ODR-2009-10-0531
* 16-02-2011        Prabhu.N         B.88-HD1040884      Auto Launch of Enquiry
* 12-05-2011        Pradeep S        PACS00060849        OBSERVATION Field created
*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.REDO.ISSUE.REQUESTS
    GOSUB PROCESS
RETURN

PROCESS:
    Y.CURRENT.REC=System.getVariable("CURRENT.REC")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CURRENT.REC = ""
    END

    CHANGE '*##' TO @FM IN Y.CURRENT.REC
    MATPARSE R.NEW FROM Y.CURRENT.REC

*PACS00060849 - S
    R.NEW(ISS.REQ.DOC.REV) = R.NEW(ISS.REQ.DOC.NAME)
    R.NEW(ISS.REQ.DOC.NAME) = R.NEW(ISS.REQ.DOC.RECEIVED)
    R.NEW(ISS.REQ.DOC.RECEIVED) = R.NEW(ISS.REQ.CARD.NO)
    R.NEW(ISS.REQ.CARD.NO) = R.NEW(ISS.REQ.OBSERVATIONS)
    R.NEW(ISS.REQ.OBSERVATIONS) = R.NEW(ISS.REQ.CONTACT.ATTEMPT)
    R.NEW(ISS.REQ.CONTACT.ATTEMPT) = ''

    Y.PDT.TYPE = R.NEW(ISS.REQ.PRODUCT.TYPE)

    BEGIN CASE

        CASE Y.PDT.TYPE EQ 'TARJETA.DE.CREDITO'
            T(ISS.REQ.ACCOUNT.ID)<3> = 'NOINPUT'
            N(ISS.REQ.CARD.NO) := '.1'
            R.NEW(ISS.REQ.ACCOUNT.ID) = ''
        CASE Y.PDT.TYPE EQ 'OTROS'
            R.NEW(ISS.REQ.ACCOUNT.ID) = ''
            R.NEW(ISS.REQ.CARD.NO) = ''
        CASE 1
            T(ISS.REQ.CARD.NO)<3> = 'NOINPUT'
            N(ISS.REQ.ACCOUNT.ID) := '.1'
            R.NEW(ISS.REQ.CARD.NO) = ''
    END CASE

    R.NEW(ISS.REQ.OPENING.DATE) = TODAY
    Y.TIME = OCONV(TIME(), 'MTS')
    R.NEW(ISS.REQ.RECEPTION.TIME) = Y.TIME
*PACS00060849 - E

RETURN
END
