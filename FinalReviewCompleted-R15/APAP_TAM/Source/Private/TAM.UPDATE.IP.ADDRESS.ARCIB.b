* @ValidationCode : MjozMjE3MjM1ODA6Q3AxMjUyOjE2ODQ0MTQxNDc3NTE6dmljdG86LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 May 2023 18:19:07
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE TAM.UPDATE.IP.ADDRESS.ARCIB(SAMPLE.ID,SAMPLE.RESPONSE,RESPONSE.TYPE,STYLE.SHEET)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Description   : This subroutine is is used to populate the Host name and IP address in TAM.HOST.DETAILS.TRACE.ARCIB
* In Parameter  : SAMPLE.ID, RESPONSE.TYPE & STYLE.SHEET
* Out Parameter : SAMPLE.RESPONSE
*-----------------------------------------------------------------------------
* Modification History :
*------------------------
*   DATE           WHO                     REFERENCE            DESCRIPTION
* 23-SEP-2010   John Christopher        ODR-2010-08-0465      INITIAL CREATION
*18-05-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*18-05-2023    VICTORIA S          R22 MANUAL CONVERSION   FIELD NAME UPDATED
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TAM.HOST.DETAILS.TRACE.ARCIB
    $INSERT I_EB.EXTERNAL.COMMON

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

    FN.TEMP = "F.TAM.HOST.DETAILS.TRACE.ARCIB"
    F.TEMP = ""
    TEMP.REC = ""
    CALL OPF(FN.TEMP,F.TEMP)
RETURN

*--------
PROCESS:
*--------


    USER.NAME=EB.EXTERNAL$USER.ID
    CURR.DATE = TIMEDATE()
    Y.IP = FIELD(SAMPLE.ID,"##",1)
    Y.SYS.NAME = FIELD(SAMPLE.ID,"##",2)
    TEMP.REC<HOST.DET.IB.IP.ADDRESS> = Y.IP ;*R22 MANUAL CONVERSION STARTS
    TEMP.REC<HOST.DET.IB.HOST.NAME> = Y.SYS.NAME
    TEMP.REC<HOST.DET.IB.DATE> = CURR.DATE[10,11] ;*R22 MANUAL CONVERSION END

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
