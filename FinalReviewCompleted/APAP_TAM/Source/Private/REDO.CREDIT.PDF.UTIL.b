* @ValidationCode : MjotMTI2MDQyODQ0MDpDcDEyNTI6MTY4MzgwNTc4NTk0MDpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 May 2023 17:19:45
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.CREDIT.PDF.UTIL(ROU.ARGS,ROU.RESPONSE,RESPONSE.TYPE,STYLE.SHEET)

*******************************************************************************************
*Company   Name    : APAP
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CREDIT.PDF.UTIL
*------------------------------------------------------------------------------------------
*Description       : Generating PDF for ARC IB
*Linked With       : ARCPDF
*In  Parameter     : ENQ.DATA
*Out Parameter     : ENQ.DATA

*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
*23/07/2015                           Vignesh Kumaar R     PDF CREATION ISSUE
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, = Y.CNT - TO -= 1, - TO = 1, + TO = 1, new condition Add
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*---------------------------------------------------------------------------------

    $INSERT JBC.h
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_F.REDO.CARD.BIN
    $USING APAP.REDOCHNLS

    RESPONSE.TYPE = 'XML.ENQUIRY'
    STYLE.SHEET = '/transforms/dummy.xsl'

    CREDIT.CARD.ID = System.getVariable('CURRENT.CARD.ID')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN              ;** R22 Auto Conversion - Start
        CREDIT.CARD.ID = ""
    END                                             ;** R22 Auto Conversion - End
    CARD.ENQ.ID = System.getVariable('CURRENT.CCARD.ENQ')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN         ;** R22 Auto Conversion - Start
        CARD.ENQ.ID = ""
    END                                        ;** R22 Auto Conversion - End
    Y.GET.CCY = System.getVariable('CURRENT.VP.CCY')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;** R22 Auto Conversion - Start
        Y.GET.CCY = ""
    END                                  ;** R22 Auto Conversion - End


    Y.CARD.NO = CREDIT.CARD.ID
    Y.CARD.ID = CREDIT.CARD.ID[1,6]
    CREDIT.CARD.ID = FMT(CREDIT.CARD.ID, 'R%19')

    FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
    F.REDO.CARD.BIN = ''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

    CALL F.READ(FN.REDO.CARD.BIN,Y.CARD.ID,R.REDO.CARD.BIN,F.REDO.CARD.BIN,CARD.ERR)

    BEGIN CASE
        CASE CARD.ENQ.ID EQ 'AI.REDO.CCARD.LIM.PERIOD.CUR.MTH'
            ST.RG.DATE = '1M'
            SIGN='-'
            CALL CALENDAR.DAY(TODAY,SIGN,ST.RG.DATE)

        CASE CARD.ENQ.ID EQ 'AI.REDO.CCARD.LIM.PERIOD.PREV.MTH'
            ST.RG.DATE = '2M'
            SIGN='-'
            CALL CALENDAR.DAY(TODAY,SIGN,ST.RG.DATE)

        CASE CARD.ENQ.ID EQ 'AI.REDO.CCARD.LIM.PERIOD.PREV.TWO.MTH'
            ST.RG.DATE = '3M'
            SIGN='-'
            CALL CALENDAR.DAY(TODAY,SIGN,ST.RG.DATE)

    END CASE

*    GOSUB MAKE.WS.CALL
    GOSUB MAKE.DIRECT.CALL

*    OUT.ARR = CREDIT.CARD.ID
*    OUT.ARR := "###":ST.RG.DATE[5,2]
*    OUT.ARR := "###":ST.RG.DATE[1,4]

    OUT.ARR = Y.FINAL.ARRAY
    CRT Y.FINAL.ARRAY
    XML.RECS = '<window><panes><pane><dataSection><enqResponse>'
*    XML.RECS :='<r><c><cap>' : OUT.ARR : '^^IMAGE=apaplogo.jpg^^PAGE=creditededc.xsl </cap></c></r>'
    XML.RECS :='<r><c><cap>' : OUT.ARR : '</cap></c></r>'
    XML.RECS :='</enqResponse></dataSection></pane></panes></window>'
    ROU.RESPONSE = XML.RECS

RETURN

MAKE.DIRECT.CALL:
*---------------*


    IF NOT(CARD.ERR) THEN

        ACTIVATION = 'WS_T24_VPLUS'
        WS.DATA = ''
        WS.DATA<1> = 'CONSULTA_ESTADO_CUENTA_PDF'
        WS.DATA<2> = CREDIT.CARD.ID
        WS.DATA<3> = ST.RG.DATE[5,2]
        WS.DATA<4> = ST.RG.DATE[1,4]


* Invoke VisionPlus Web Service
        RESP.INFO = CALLJEE(ACTIVATION, WS.DATA)

* Credit Card exits - Info obtained OK
        IF WS.DATA<1> EQ 'OK' THEN
            Y.FINAL.ARRAY = WS.DATA
        END
    END

RETURN




MAKE.WS.CALL:
*-----------*

    IF NOT(CARD.ERR) THEN

        ACTIVATION = 'WS_T24_VPLUS'
        WS.DATA = ''
        WS.DATA<1> = 'CONSULTA_ESTADO_X_RANGO'
        WS.DATA<2> = CREDIT.CARD.ID

        IF Y.GET.CCY EQ 'USD' THEN
            Y.CCY.LIST = R.REDO.CARD.BIN<REDO.CARD.BIN.T24.CURRENCY>
            LOCATE Y.GET.CCY IN Y.CCY.LIST<1,1> SETTING Y.CCY.POS ELSE
                RETURN
            END
            WS.DATA<3> = '2'
        END ELSE
            WS.DATA<3> = '1'
        END

        WS.DATA<4> = ST.RG.DATE[5,2]
        WS.DATA<5> = ST.RG.DATE[1,4]


* Invoke VisionPlus Web Service
* CALL APAP.TAM.REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA);** R22 Manual conversion - CALL method format changed
        CALL APAP.TAM.redoVpWsConsumer(ACTIVATION, WS.DATA) ;*R22 Manual Conversion
* Credit Card exits - Info obtained OK
        IF WS.DATA<1> EQ 'OK' THEN

            GOSUB CC.STMT.MVMTS
        END
    END
RETURN

CC.STMT.MVMTS:
*------------*

    Y.EN.DATE = WS.DATA<5>

    Y.ST.DATE = '1M'
    SIGN='-'
    CALL CALENDAR.DAY(Y.EN.DATE,SIGN,Y.ST.DATE)

    WS.DATA = CHANGE(WS.DATA,'*',@VM)
    Y.CNT = DCOUNT(WS.DATA<31>,@VM)
    Y.POS = 1
    Y.TEMP = 2

    IF Y.GET.CCY EQ 'USD' THEN
        Y.GET.CCY = 'US$'
    END ELSE
        Y.GET.CCY = 'RD$'
    END

    IF WS.DATA<31,Y.CNT> EQ '' THEN
        Y.CNT -= 1           ;** R22 Auto conversion - = Y.CNT - TO -= 1
    END

    LOOP
    WHILE Y.CNT GT 0

        IF WS.DATA<31,Y.CNT> EQ 'D' THEN
            Y.AMT = WS.DATA<29,Y.CNT>:'###':'0'
        END ELSE
            Y.AMT = '0':'###':WS.DATA<29,Y.CNT>
        END
        Y.FINAL.ARRAY<-1> = WS.DATA<27,Y.CNT>:'###':WS.DATA<28,Y.CNT>:'###':WS.DATA<30,Y.CNT>:'###':WS.DATA<26,Y.CNT>:'###':Y.AMT:'###':Y.CARD.NO:'###':Y.ST.DATE:'###':Y.EN.DATE:'###':WS.DATA<7,Y.CNT>:'###':WS.DATA<8,Y.CNT>:'###':Y.GET.CCY
        Y.CNT -= 1        ;** R22 Auto conversion - - TO = 1
        Y.POS += 1         ;** R22 Auto conversion - + TO = 1
    REPEAT

RETURN
