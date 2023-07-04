* @ValidationCode : MjotOTE4NDQ2ODE0OkNwMTI1MjoxNjgzNTI4NjQxODY3OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 May 2023 12:20:41
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
SUBROUTINE REDO.ARC.PRINT.RECEIPTS(ROU.ARGS,ROU.RESPONSE,RESPONSE.TYPE,STYLE.SHEET)
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : REDO.ARC.PRINT.RECEIPTS
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 10-APR-2023     Conversion tool    R22 Auto conversion       IF condition added
* 10-APR-2023     Conversion tool    R22 Auto conversion       CALL routine format modified
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System



    FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
    F.REDO.EB.USER.PRINT.VAR=''
    CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)

    Y.USR = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - start
        Y.USR = ""
    END					;*R22 Auto conversion - end
    Y.USR.VAR = Y.USR:"-":"CURRENT.ARC.VER"

*  READ PDF.VER.ID FROM F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ELSE PDF.VER.ID = "" ;*Tus Start
    CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,PDF.VER.ID,F.REDO.EB.USER.PRINT.VAR,PDF.VER.ID.ERR)
    IF PDF.VER.ID.ERR THEN
        PDF.VER.ID =''
    END ;*Tus End

    Y.USR.VAR = Y.USR:"-":"CURRENT.ARC.REC"

*  READ PDF.REC.ID FROM F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ELSE PDF.REC.ID = "" ;*Tus Start
    CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,PDF.REC.ID,F.REDO.EB.USER.PRINT.VAR,PDF.REC.ID.ERR)
    IF PDF.REC.ID.ERR THEN
        PDF.REC.ID = ""
    END ;*Tus End

    HEADER.FLD = ''
    DATA.FLD = ''
    FOOTER.FLD = ''
    Y.XSL = ''

*CALL APAP.REDOCHNLS.AI.REDO.PRINT.RECEIPTS(PDF.VER.ID,PDF.REC.ID,HEADER.FLD,DATA.FLD,FOOTER.FLD,Y.XSL) ;*Manual R22 conversion
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
