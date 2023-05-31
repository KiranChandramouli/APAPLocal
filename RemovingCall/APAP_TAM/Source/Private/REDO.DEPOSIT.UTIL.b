* @ValidationCode : MjotMTkxODY4NDY1NzpDcDEyNTI6MTY4MTExNTIwNzY2MDpJVFNTOi0xOi0xOi0yOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:56:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -2
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
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

* Date             Who                   Reference      Description
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - New condition added
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    PDF.DATA=System.getVariable('CURRENT.SCA.PDF.DATA')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN        ;** R22 Auto Conversion - Start
        PDF.DATA = ""
    END                                       ;** R22 Auto Conversion - End
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
