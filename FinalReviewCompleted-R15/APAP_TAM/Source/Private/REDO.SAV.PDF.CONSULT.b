* @ValidationCode : MjotMzc0OTM1MzM2OkNwMTI1MjoxNjg0ODQyMTMwNjc4OklUU1M6LTE6LTE6LTY6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -6
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
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
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           IF CONDITION ADDED
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    PDF.HEADER=System.getVariable('CURRENT.SCA.PDF.HEADER')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*AUTO R22 CODE CONVERSION - START
        PDF.HEADER = ""
    END ;*AUTO R22 CODE CONVERSION - END
    PDF.DATA=System.getVariable('CURRENT.SCA.PDF.DATA')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*AUTO R22 CODE CONVERSION - START
        PDF.DATA = ""
    END ;*AUTO R22 CODE CONVERSION - END
    PDF.FOOTER=System.getVariable('CURRENT.SCA.PDF.FOOTER')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*AUTO R22 CODE CONVERSION - START
        PDF.FOOTER = ""
    END ;*AUTO R22 CODE CONVERSION - END
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
