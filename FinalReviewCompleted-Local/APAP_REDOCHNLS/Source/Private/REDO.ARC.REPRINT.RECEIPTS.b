* @ValidationCode : Mjo1ODAzMDY2NzM6Q3AxMjUyOjE2ODM1Mjg2NjYyNDA6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 08 May 2023 12:21:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS
SUBROUTINE REDO.ARC.REPRINT.RECEIPTS(ROU.ARGS,ROU.RESPONSE,RESPONSE.TYPE,STYLE.SHEET)
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : REDO.ARC.REPRINT.RECEIPTS
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* 10-APR-2023     Conversion tool    R22 Auto conversion       IF condition added
* 10-APR-2023      Harishvikram C   Manual R22 conversion      CALL Routine format modified
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    Y.TXN.DETAILS = System.getVariable("CURRENT.REPRN.VER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - START
        Y.TXN.DETAILS = ""
    END					;*R22 Auto conversion - END
    PDF.VER.ID = FIELD(Y.TXN.DETAILS," ",1)
    PDF.REC.ID = FIELD(Y.TXN.DETAILS," ",3)

    HEADER.FLD = ''
    DATA.FLD = ''
    FOOTER.FLD = ''
    Y.XSL = ''

    CALL APAP.REDOCHNLS.aiRedoPrintReceipts(PDF.VER.ID,PDF.REC.ID,HEADER.FLD,DATA.FLD,FOOTER.FLD,Y.XSL) ;*Manual R22 conversion

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
