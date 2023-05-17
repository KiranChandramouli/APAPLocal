*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.SAV.PDF.CONSULT(ROU.ARGS,ROU.RESPONSE,RESPONSE.TYPE,STYLE.SHEET)
*---------------------------------------------------------------------------------
*******************************************************************************************
*Company   Name    : APAP
*Developed By      : Temenos Application Management
*Program   Name    : REDO.SAV.PDF.CONSULT.DETAILS
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
  PDF.HEADER=System.getVariable('CURRENT.SCA.PDF.HEADER')
  PDF.DATA=System.getVariable('CURRENT.SCA.PDF.DATA')
  PDF.FOOTER=System.getVariable('CURRENT.SCA.PDF.FOOTER')
  RESPONSE.TYPE = 'XML.ENQUIRY'
  STYLE.SHEET = '/transforms/dummy.xsl'
  Y.LEN=LEN(PDF.DATA)
  Y.RES=PDF.DATA[0,Y.LEN-3]

  XML.RECS = '<window><panes><pane><dataSection><enqResponse>'
  XML.RECS :='<r><c><cap>' : PDF.HEADER : PDF.DATA : PDF.FOOTER : '^^IMAGE=apaplogo.jpg^^PAGE=currentpodger.xsl </cap></c></r>'
  XML.RECS :='</enqResponse></dataSection></pane></panes></window>'
  ROU.RESPONSE = XML.RECS
  RETURN
END
