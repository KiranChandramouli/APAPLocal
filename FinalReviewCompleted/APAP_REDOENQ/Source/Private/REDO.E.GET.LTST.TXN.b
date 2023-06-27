* @ValidationCode : MjoxNDA2OTIzOTMwOkNwMTI1MjoxNjg0ODUxOTc1MjQ1OklUU1M6LTE6LTE6MTY5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 19:56:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 169
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.GET.LTST.TXN(Y.FINAL.ARRAY)

*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE              ODR                   DEVELOPER                    VERSION
*--------          ----------------      --------------------      ----------------
* 15.Dec.2010     SUNNEL                 Krishna Murthy T.S        Initial creation
* 23 MAY 2015                            VIGNESH KUMAAR M R        REVAMP OF THE ROUTINE
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN , VM to @VM , FM to @FM , -- to -= and ++ to +=
* 11-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified
*---------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_ENQUIRY.COMMON
    $USING APAP.TAM

    $INSERT I_F.REDO.CARD.BIN

    GOSUB INITIALISE
    GOSUB PROCESS

    IF Y.USD.ARRAY THEN
        Y.FINAL.ARRAY = Y.DOP.ARRAY:@FM:Y.USD.ARRAY
    END ELSE
        Y.FINAL.ARRAY = Y.DOP.ARRAY
    END

    IF Y.FINAL.ARRAY THEN
        APAP.TAM.redoClearHtmlDataProcess();*R22 Manual Conversion
        HTML.FOOTER = '^^FD30=':Y.TOT.DEB.USD:'^^FD31=':Y.TOT.CRE.USD:'^^FD33=':Y.TOT.DEB.DOP:'^^FD34=':Y.TOT.CRE.DOP
        Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            Y.USR.VAR = ""
        END
        Y.USR.VAR = Y.USR.VAR:"-":"CURRENT.HTML.FOOTER"

*    WRITE HTML.FOOTER TO F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ;*Tus Start
        CALL F.WRITE(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,HTML.FOOTER);*Tus End
    END
RETURN
*---------------------------------------------------------------------------------
INITIALISE:
*---------------------------------------------------------------------------------

    Y.TOT.DEB.USD = 0
    Y.TOT.CRE.USD = 0
    Y.TOT.DEB.DOP = 0
    Y.TOT.CRE.DOP = 0

    FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
    F.REDO.EB.USER.PRINT.VAR=''
    CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    ST.RG.DATE = '6M'
    SIGN = '-'
    END.RG.DATE = TODAY
    CALL CALENDAR.DAY(END.RG.DATE,SIGN,ST.RG.DATE)

    CREDIT.CARD.ID = System.getVariable('CURRENT.CARD.ID')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN		;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        CREDIT.CARD.ID = ""
    END
    IF NUM(CREDIT.CARD.ID) ELSE
        SLEEP 2
        CREDIT.CARD.ID = System.getVariable('CURRENT.CARD.ID')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN	 ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            CREDIT.CARD.ID = ""
        END
    END
    Y.CARD.ID = CREDIT.CARD.ID[1,6]

    CREDIT.CARD.ID = FMT(CREDIT.CARD.ID, 'R%19')

    ACTIVATION = 'WS_T24_VPLUS'
    WS.DATA = ''
    WS.DATA<1> = 'CONSULTA_MOVIMIENTOS_X_RANGO'
    WS.DATA<2> = CREDIT.CARD.ID
    WS.DATA<3> = ST.RG.DATE
    WS.DATA<4> = END.RG.DATE
    WS.DATA<5> = 'AL'

    WS.DATA<6> = '3'

* Invoke VisionPlus Web Service
    APAP.TAM.redoVpWsConsumer(ACTIVATION, WS.DATA);*R22 Manual Conversion

* Credit Card exits - Info obtained OK
    IF WS.DATA<1> EQ 'OK' THEN

        GOSUB LAST.FIVE.MVMTS
    END ELSE
* 'ERROR/OFFLINE'
        ENQ.ERROR<1> = WS.DATA<2>
    END

RETURN

LAST.FIVE.MVMTS:
*--------------*

    WS.DATA = CHANGE(WS.DATA,'*',@VM)
    Y.CNT = DCOUNT(WS.DATA<8>,@VM)

    Y.DOP.CNT = 0
    Y.USD.CNT = 0

    IF WS.DATA<8,Y.CNT> EQ '' THEN
        Y.CNT -= 1
    END

    LOOP
    WHILE Y.CNT GT 0

        IF Y.DOP.CNT GE 5 AND Y.USD.CNT GE 5 THEN
            RETURN
        END

        IF WS.DATA<6,Y.CNT> EQ 'D' THEN
            Y.AMT = WS.DATA<7,Y.CNT>:'###':'0'
            Y.DEB = WS.DATA<7,Y.CNT>
        END ELSE
            Y.AMT = '0':'###':WS.DATA<7,Y.CNT>
            Y.CRE = WS.DATA<7,Y.CNT>
        END

        IF WS.DATA<9,Y.CNT> EQ 'DOP' THEN
            IF Y.DOP.CNT GE 5 ELSE
                Y.CCY.MNE = 'RD$'
                Y.DOP.ARRAY<-1> = WS.DATA<5,Y.CNT>:'###':WS.DATA<3,Y.CNT>:'###':WS.DATA<8,Y.CNT>:'###':Y.CCY.MNE:'###':Y.AMT
                Y.TOT.DEB.DOP += Y.DEB
                Y.TOT.CRE.DOP += Y.CRE
                Y.DOP.CNT += 1
            END
        END ELSE
            IF Y.USD.CNT GE 5 ELSE
                Y.CCY.MNE = 'US$'
                Y.USD.ARRAY<-1> = WS.DATA<5,Y.CNT>:'###':WS.DATA<3,Y.CNT>:'###':WS.DATA<8,Y.CNT>:'###':Y.CCY.MNE:'###':Y.AMT
                Y.TOT.DEB.USD += Y.DEB
                Y.TOT.CRE.USD += Y.CRE
                Y.USD.CNT += 1
            END
        END
        Y.DEB = 0
        Y.CRE = 0
        Y.CNT -= 1



    REPEAT
RETURN
