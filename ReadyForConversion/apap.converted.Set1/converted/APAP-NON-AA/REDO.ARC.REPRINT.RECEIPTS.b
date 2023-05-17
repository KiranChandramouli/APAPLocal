SUBROUTINE REDO.ARC.REPRINT.RECEIPTS(ROU.ARGS,ROU.RESPONSE,RESPONSE.TYPE,STYLE.SHEET)
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : REDO.ARC.REPRINT.RECEIPTS
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    Y.TXN.DETAILS = System.getVariable("CURRENT.REPRN.VER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.TXN.DETAILS = ""
    END
    PDF.VER.ID = FIELD(Y.TXN.DETAILS," ",1)
    PDF.REC.ID = FIELD(Y.TXN.DETAILS," ",3)

    HEADER.FLD = ''
    DATA.FLD = ''
    FOOTER.FLD = ''
    Y.XSL = ''

    CALL AI.REDO.PRINT.RECEIPTS(PDF.VER.ID,PDF.REC.ID,HEADER.FLD,DATA.FLD,FOOTER.FLD,Y.XSL)

    IF Y.XSL EQ '' THEN
        E = "AI-PRINT.PDF"
        RETURN
    END

    PDF.HEADER = HEADER.FLD
    PDF.DATA = DATA.FLD
    PDF.FOOTER = FOOTER.FLD

    RESPONSE.TYPE = 'XML.ENQUIRY'
    STYLE.SHEET = '/transforms/dummy.xsl'
    Y.LEN=LEN(PDF.DATA)
    Y.RES=PDF.DATA[0,Y.LEN-3]

    XML.RECS = '<window><panes><pane><dataSection><enqResponse>'
    XML.RECS :='<r><c><cap>' : PDF.HEADER : PDF.DATA : PDF.FOOTER : '^^IMAGE=apaplogo.jpg^^PAGE=':Y.XSL:' </cap></c></r>'
    XML.RECS :='</enqResponse></dataSection></pane></panes></window>'
    ROU.RESPONSE = XML.RECS
RETURN
END
