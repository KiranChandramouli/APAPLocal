* @ValidationCode : MjoxMjQ3MDAzNzcyOkNwMTI1MjoxNjg0ODUxOTg4NDUxOklUU1M6LTE6LTE6MTc1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 19:56:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 175
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.LIST.CARD.MTH.TRANS(Y.FINAL.ARRAY)

*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE              ODR                   DEVELOPER                    VERSION
*--------          ----------------      --------------------      ----------------
* 15.Dec.2010     SUNNEL                 Krishna Murthy T.S        Initial creation
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN , VM to @VM , -- to -= , ++ to +=
* 13-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified
*---------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.CARD.BIN
    $USING APAP.TAM

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN


INITIALISE:

    CREDIT.CARD.ID = System.getVariable('CURRENT.CARD.ID')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN	;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        CREDIT.CARD.ID = ""
    END
    Y.GET.CCY = System.getVariable('CURRENT.VP.CCY')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN	;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.GET.CCY = ""
    END
    Y.CARD.NO = CREDIT.CARD.ID
    Y.CARD.ID = CREDIT.CARD.ID[1,6]

    CREDIT.CARD.ID = FMT(CREDIT.CARD.ID, 'R%19')

    FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
    F.REDO.CARD.BIN = ''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

    CALL F.READ(FN.REDO.CARD.BIN,Y.CARD.ID,R.REDO.CARD.BIN,F.REDO.CARD.BIN,CARD.ERR)

    MATCH.ENQ = 'AI.REDO.CCARD.LIM.PERIOD.CUR.MTH':@VM:'AI.REDO.CCARD.LIM.PERIOD.PREV.MTH':@VM:'AI.REDO.CCARD.LIM.PERIOD.PREV.TWO.MTH'

    BEGIN CASE
        CASE ENQ.SELECTION<1,1> EQ 'AI.REDO.CCARD.LIM.PERIOD.CUR.MTH'
            ST.RG.DATE = '1M'
            SIGN='-'
            CALL CALENDAR.DAY(TODAY,SIGN,ST.RG.DATE)

        CASE ENQ.SELECTION<1,1> EQ 'AI.REDO.CCARD.LIM.PERIOD.PREV.MTH'
            ST.RG.DATE = '2M'
            SIGN='-'
            CALL CALENDAR.DAY(TODAY,SIGN,ST.RG.DATE)

        CASE ENQ.SELECTION<1,1> EQ 'AI.REDO.CCARD.LIM.PERIOD.PREV.TWO.MTH'
            ST.RG.DATE = '3M'
            SIGN='-'
            CALL CALENDAR.DAY(TODAY,SIGN,ST.RG.DATE)

    END CASE

    CALL System.setVariable("CURRENT.CCARD.ENQ",ENQ.SELECTION<1,1>)

RETURN

PROCESS:

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
        CALL APAP.TAM.redoVpWsConsumer(ACTIVATION, WS.DATA);*R22 Manual Conversion

* Credit Card exits - Info obtained OK
        IF WS.DATA<1> EQ 'OK' THEN

            GOSUB CC.STMT.MVMTS
        END ELSE
* 'ERROR/OFFLINE'
            ENQ.ERROR<1> = WS.DATA<2>
        END
    END

RETURN

CC.STMT.MVMTS:
*------------*

*    CALL GET.LAST.DOM(ST.RG.DATE[1,6],LAST.DATE,LAST.DAY,MONTH.NAME)
*    Y.ST.DATE = ST.RG.DATE[1,6]:'01'
*    Y.EN.DATE = ST.RG.DATE[1,6]:LAST.DAY

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
        Y.CNT -= 1
    END

    LOOP
    WHILE Y.CNT GT 0

        IF WS.DATA<31,Y.CNT> EQ 'D' THEN
            Y.AMT = WS.DATA<29,Y.CNT>:'###':'0'
        END ELSE
            Y.AMT = '0':'###':WS.DATA<29,Y.CNT>
        END
        Y.FINAL.ARRAY<-1> = WS.DATA<27,Y.CNT>:'###':WS.DATA<28,Y.CNT>:'###':WS.DATA<30,Y.CNT>:'###':WS.DATA<26,Y.CNT>:'###':Y.AMT:'###':Y.CARD.NO:'###':Y.ST.DATE:'###':Y.EN.DATE:'###':WS.DATA<7,Y.CNT>:'###':WS.DATA<8,Y.CNT>:'###':Y.GET.CCY
        Y.CNT -= 1
        Y.POS += 1
    REPEAT

RETURN
