* @ValidationCode : MjotMzMwNDE0OTg1OkNwMTI1MjoxNjgxMjAyMzY0OTcyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 14:09:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE TAM.UPDATE.IP.ADDRESS(SAMPLE.ID,SAMPLE.RESPONSE,RESPONSE.TYPE,STYLE.SHEET)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Description   : This subroutine is is used to populate the Host name and IP address in TAM.HOST.DETAILS.TRACE
* In Parameter  : SAMPLE.ID, RESPONSE.TYPE & STYLE.SHEET
* Out Parameter : SAMPLE.RESPONSE
*-----------------------------------------------------------------------------
* Modification History :
*------------------------
*   DATE           WHO                     REFERENCE            DESCRIPTION
* 23-SEP-2010   John Christopher        ODR-2010-08-0465      INITIAL CREATION
* 11.04.2023    Conversion Tool            R22                Auto Conversion     - No changes
* 11.04.2023    Shanmugapriya M            R22                Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TAM.HOST.DETAILS.TRACE

    GOSUB INIT
    GOSUB PROCESS
    GOSUB XML.PROCESS

RETURN

*-----
INIT:
*-----

    ENQ.OUTPUT = ''
    RESPONSE.TYPE = 'XML.ENQUIRY'
    STYLE.SHEET = '/transforms/host/hostdetail.xsl'

    FN.TEMP = "F.TAM.HOST.DETAILS.TRACE"
    F.TEMP = ""
    TEMP.REC = ""
    CALL OPF(FN.TEMP,F.TEMP)
RETURN

*--------
PROCESS:
*--------

    USER.NAME = OPERATOR
    Y.IP = FIELD(SAMPLE.ID,"##",1)
    Y.SYS.NAME = FIELD(SAMPLE.ID,"##",2)
    TEMP.REC<HOST.DET.IP.ADDRESS> = Y.IP
    TEMP.REC<HOST.DET.HOST.NAME> = Y.SYS.NAME
    TEMP.REC<HOST.DET.DATE> = TODAY
    CALL F.WRITE(FN.TEMP,USER.NAME,TEMP.REC)
    CALL JOURNAL.UPDATE(TEMP.REC)
RETURN

*------------
XML.PROCESS:
*------------
    XML.RECS = '<window><panes><pane><dataSection><enqResponse>'
    IF Y.IP NE '' AND Y.SYS.NAME NE '' THEN
        XML.RECS :='<r><c><cap>SUCCESS</cap></c></r>'
    END ELSE
        XML.RECS :='<r><c><cap>ERROR</cap></c></r>'
    END

    XML.RECS :='</enqResponse></dataSection></pane></panes></window>'
    SAMPLE.RESPONSE = XML.RECS
RETURN
END
