SUBROUTINE REDO.V.AUT.CON.COMP
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
    $INSERT I_F.REDO.ISSUE.COMPLAINTS
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
    R.NEW(ISS.COMP.OBSERVATIONS) = R.NEW(ISS.COMP.CONTACT.ATTEMPT)
    R.NEW(ISS.COMP.CONTACT.ATTEMPT) = ''
*PACS00060849 - E

RETURN
END
