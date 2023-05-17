SUBROUTINE REDO.ARC.PDF.CONSULT(ROU.ARGS,ROU.RESPONSE,RESPONSE.TYPE,STYLE.SHEET)
*---------------------------------------------------------------------------------
*******************************************************************************************************************
*Company   Name    : APAP
*Developed By      : Temenos Application Management
*Program   Name    : REDO.ARC.PDF.CONSULT.DETAILS
*------------------------------------------------------------------------------------------------------------------
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
    $INSERT I_F.AZ.ACCOUNT


    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT  = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)


    PDF.HEADER=System.getVariable('CURRENT.SCA.PDF.HEADER')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        PDF.HEADER = ""
    END
    PDF.DATA=System.getVariable('CURRENT.SCA.PDF.DATA')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        PDF.DATA = ""
    END
    PDF.FOOTER=System.getVariable('CURRENT.SCA.PDF.FOOTER')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        PDF.FOOTER = ""
    END

    Y.ACCT.NO = System.getVariable('CURRENT.ACCT.NO')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.ACCT.NO = ""
    END
    CALL F.READ(FN.AZ.ACCOUNT,Y.ACCT.NO,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ERR)

    CALL REDO.CONVERT.ACCOUNT(Y.ACCT.NO,'',ARR.ID,ERR.TEXT)


    RESPONSE.TYPE = 'XML.ENQUIRY'
    STYLE.SHEET = '/transforms/dummy.xsl'
    Y.LEN=LEN(PDF.DATA)
    Y.RES=PDF.DATA[0,Y.LEN-3]

    XML.RECS = '<window><panes><pane><dataSection><enqResponse>'
    IF R.AZ.ACCOUNT THEN
        XML.RECS :='<r><c><cap>' : PDF.HEADER : PDF.DATA : PDF.FOOTER : '^^IMAGE=apaplogo.jpg^^PAGE=depositpodger.xsl </cap></c></r>'
    END ELSE
        IF ARR.ID THEN
            XML.RECS :='<r><c><cap>' : PDF.HEADER : PDF.DATA : PDF.FOOTER : '^^IMAGE=apaplogo.jpg^^PAGE=loanpodger.xsl </cap></c></r>'
        END ELSE
            XML.RECS :='<r><c><cap>' : PDF.HEADER : PDF.DATA : PDF.FOOTER : '^^IMAGE=apaplogo.jpg^^PAGE=savingpodger.xsl </cap></c></r>'
        END
    END
    XML.RECS :='</enqResponse></dataSection></pane></panes></window>'
    ROU.RESPONSE = XML.RECS
RETURN
END
