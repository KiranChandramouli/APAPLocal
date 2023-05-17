*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ARC.PDF.CREDIT(ROU.ARGS,ROU.RESPONSE,RESPONSE.TYPE,STYLE.SHEET)

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_ENQ.SES.VAR.CREDIT.COMMON

  RESPONSE.TYPE = 'XML.ENQUIRY'
  STYLE.SHEET = '/transforms/host/hostdetail.xsl'
  Y.LEN=LEN(PDF.CREDIT.DATA)
  Y.RES=PDF.CREDIT.DATA[0,Y.LEN-3]

  XML.RECS = '<window><panes><pane><dataSection><enqResponse>'
  XML.RECS :='<r><c><cap>' : PDF.CREDIT.HEADER : Y.RES : '^^PAGE=ededc.xsl </cap></c></r>'
  XML.RECS :='</enqResponse></dataSection></pane></panes></window>'
  ROU.RESPONSE = XML.RECS
  RETURN
END
