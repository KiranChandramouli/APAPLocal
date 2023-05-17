SUBROUTINE REDO.DEPOSIT.UTIL(ROU.ARGS,ROU.RESPONSE,RESPONSE.TYPE,STYLE.SHEET)
*******************************************************************************************
*Company   Name    : APAP
*Developed By      : Temenos Application Management
*Program   Name    : REDO.DEPOSIT.UTIL
*------------------------------------------------------------------------------------------
*Description       : Generating PDF for ARC IB
*Linked With       : ARCPDF
*In  Parameter     : ENQ.DATA
*Out Parameter     : ENQ.DATA
*ODR  Number:

*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    PDF.DATA=System.getVariable('CURRENT.SCA.PDF.DATA')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        PDF.DATA = ""
    END
    RESPONSE.TYPE = 'XML.ENQUIRY'
    STYLE.SHEET = '/transforms/dummy.xsl'
    Y.LEN=LEN(PDF.DATA)
    Y.RES=PDF.DATA[0,Y.LEN-3]

    XML.RECS = '<window><panes><pane><dataSection><enqResponse>'
    XML.RECS :='<r><c><cap>' : PDF.DATA : '^^IMAGE=apaplogo.jpg^^PAGE=termdeposit.xsl </cap></c></r>'
    XML.RECS :='</enqResponse></dataSection></pane></panes></window>'
    ROU.RESPONSE = XML.RECS
RETURN
END
