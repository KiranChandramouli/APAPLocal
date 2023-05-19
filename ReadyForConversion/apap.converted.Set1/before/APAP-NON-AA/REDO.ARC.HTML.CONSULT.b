*-----------------------------------------------------------------------------
* <Rating>-60</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ARC.HTML.CONSULT(ROU.ARGS,ROU.RESPONSE,RESPONSE.TYPE,STYLE.SHEET)
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : REDO.ARC.HTML.CONSULT
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System

  FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
  F.REDO.EB.USER.PRINT.VAR=''
  CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)

  Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
  Y.HTML.VAR = Y.USR.VAR:"-":"CURRENT.HTML.HEADER"

*  READ HTML.HEADER FROM F.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR ELSE ;*Tus Start 
CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR,HTML.HEADER,F.REDO.EB.USER.PRINT.VAR,HTML.HEADER.ERR)
 IF HTML.HEADER.ERR THEN  ;* Tus End
    HTML.HEADER = ''
  END
  Y.HTML.VAR = Y.USR.VAR:"-":"CURRENT.HTML.DATA"

*  READ HTML.DATA FROM F.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR ELSE ;*Tus Start 
CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR,HTML.DATA,F.REDO.EB.USER.PRINT.VAR,HTML.DATA.ERR)
 IF HTML.DATA.ERR THEN  ;* Tus End
    HTML.DATA = ''
  END
  Y.HTML.VAR = Y.USR.VAR:"-":"CURRENT.HTML.FOOTER"

*  READ HTML.FOOTER FROM F.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR ELSE ;*Tus Start 
CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR,HTML.FOOTER,F.REDO.EB.USER.PRINT.VAR,HTML.FOOTER.ERR)
 IF HTML.FOOTER.ERR THEN  ;* Tus End
    HTML.FOOTER = ''
  END
  Y.HTML.VAR = Y.USR.VAR:"-":"CURRENT.HTML.BODY"

*  READ HTML.BODY FROM F.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR ELSE ;*Tus Start 
CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR,HTML.BODY,F.REDO.EB.USER.PRINT.VAR,HTML.BODY.ERR)
 IF HTML.BODY.ERR THEN  ;* Tus End
    HTML.BODY = ''
  END
  Y.HTML.VAR = Y.USR.VAR:"-":"CURRENT.HTML.PAGE"

*  READ HTML.PAGE FROM F.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR ELSE ;*Tus Start 
CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR,HTML.PAGE,F.REDO.EB.USER.PRINT.VAR,HTML.PAGE.ERR)
 IF HTML.PAGE.ERR THEN  ;* Tus End
    HTML.PAGE = ''
  END

  RESPONSE.TYPE = 'XML.ENQUIRY'
  STYLE.SHEET = '/transforms/dummy.xsl'

*      Y.LEN=LEN(HTML.DATA)
*      Y.RES=HTML.DATA[0,Y.LEN-3]

  XML.RECS = '<window><panes><pane><dataSection><enqResponse>'
  XML.RECS :='<r><c><cap>' : HTML.HEADER : HTML.DATA : HTML.FOOTER : HTML.BODY : '^^IMAGE=apaplogo.jpg^^PAGE=':HTML.PAGE:' </cap></c></r>'
  XML.RECS :='</enqResponse></dataSection></pane></panes></window>'
  ROU.RESPONSE = XML.RECS
  RETURN
END