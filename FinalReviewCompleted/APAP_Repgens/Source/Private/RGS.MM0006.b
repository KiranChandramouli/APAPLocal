<<<<<<< Updated upstream
* @ValidationCode : MjoxMDc2NDgzNDg5OkNwMTI1MjoxNjg4NTM2OTAzNTgyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jul 2023 11:31:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
=======
* @ValidationCode : MjoxMDc2NDgzNDg5OkNwMTI1MjoxNjg2OTE4NzE3MjY4OklUU1MxOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Jun 2023 18:01:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
>>>>>>> Stashed changes
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
<<<<<<< Updated upstream
* @ValidationInfo : Strict flag       : true
=======
* @ValidationInfo : Strict flag       : N/A
>>>>>>> Stashed changes
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.Repgens

SUBROUTINE RGS.MM0006
REM "RGS.MM0006",230614-4
*************************************************************************
*MODIFICATION HISTORY:
*DATE               WHO                   REFERENCE                 DESCRIPTION
*15-06-2023       Suresh             MANUAL R22 CODE CONVERSION   Package added
*************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_RC.COMMON
    $INSERT I_SCREEN.VARIABLES
    $INSERT I_F.COMPANY
    $INSERT I_F.USER
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.DATES
    SAVE.ID.COMPANY = ID.COMPANY
*************************************************************************
    YT.SMS.COMP = ID.COMPANY
    YT.SMS.FILE = "MM.MONEY.MARKET"
    YT.SMS.FILE<-1> = "DATES"
    YT.SMS.FILE<-1> = "ACCOUNT.CLASS"
    YT.SMS.FILE<-1> = "LMM.TEXT"
    YCOUNT = COUNT(YT.SMS.FILE,@FM)+1
    LOOP
        YID.COMP = YT.SMS.COMP<1>; DEL YT.SMS.COMP<1>
        FOR YAF = 1 TO YCOUNT
            YSMS.FILE = YT.SMS.FILE<YAF>
            YPW.OK = 0; Y = 1; X = 1
            LOOP WHILE X DO
                LOCATE YSMS.FILE IN R.USER<EB.USE.APPLICATION,Y> SETTING X ELSE X = 0
                IF X THEN
                    GOSUB 9300000
                    IF X THEN
                        IF R.USER<EB.USE.FUNCTION,X> = "N" THEN
                            IF R.USER<EB.USE.VERSION,X> THEN
                                Y += 1; X = 1
                            END ELSE
                                X = 0; YPW.OK = "NO"
                            END
                        END ELSE
                            Y = X+1; YPW.OK = 1; X = 0
                        END
                    END ELSE
                        Y += 1; X = 1
                    END
                END
* update pointers to definitions in version record
            REPEAT
            IF NOT(YPW.OK) THEN
* when no password for selected pgm ask for a global password
                LOCATE "ALL.PG" IN R.USER<EB.USE.APPLICATION,1> SETTING X ELSE X = 0
                GOSUB 9300000
* ask for a password for all programs
                IF NOT(X) THEN
                    YPGM.TYPE = ""; CALL PGM.TABLE (YSMS.FILE, YPGM.TYPE)
                    Y = "ALL.PG.":YPGM.TYPE[1,1]
                    LOCATE Y IN R.USER<EB.USE.APPLICATION,1> SETTING X ELSE X = 0
                    GOSUB 9300000
* ask for a password for the type of the program
                END
                YPW.OK = 1
            END
            IF NOT(YPW.OK) OR YPW.OK = "NO" THEN
                MSG = "NO PASSWORD FOR FILE=":YSMS.FILE
                MSG<2> = "SECURITY"
                CALL PRO("NO PASSWORD FOR FILE=":YSMS.FILE)
                TEXT = "SECURITY VIOLATION"
                CALL REM  ; RETURN  ;* end of pgm
            END
        NEXT YAF
    WHILE YT.SMS.COMP REPEAT
*************************************************************************
    YBLOCKNO = 0; YKEYNO = 0; YWRITNO = 0
    YT.FORFIL = ""; YKEYFD = ""
    YFD.LEN = ""; YPART.S = ""; YPART.L = ""
    DIM YR.REC(10)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.MM0006"
    YOLDFILE = 1
    OPEN "", YFILE TO F.FILE ELSE YOLDFILE = 0
    IF NOT(PHNO) THEN PRINT @(0,10):
    IF YOLDFILE THEN
        CLEARFILE F.FILE
        PRINT "FILE ":YFILE:"  CLEARED"
    END ELSE
        ERROR.MESSAGE = ""
        Y.OUT.FILE = FIELD(YFILE,".",2,99)
        SCHEMA.NAME = ""
        CALL EB.DETERMINE.SCHEMA(Y.OUT.FILE, ID.COMPANY, SCHEMA.NAME)
        IF SCHEMA.NAME THEN
            Y.OUT.FILE<7> = SCHEMA.NAME
        END
        CALL EBS.CREATE.FILE(Y.OUT.FILE,"",ERROR.MESSAGE)
    END
    OPEN "", YFILE TO F.FILE ELSE
        TEXT = "CANNOT OPEN ":YFILE
        CALL FATAL.ERROR ("RGS.MM0006")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "MM.MONEY.MARKET"
    YT.SMS.FILE<-1> = "DATES"
    YT.SMS.FILE<-1> = "ACCOUNT.CLASS"
    YT.SMS.FILE<-1> = "LMM.TEXT"
    YCOUNT = COUNT(R.USER<EB.USE.APPLICATION>,@VM)+1
    FOR YAV = 1 TO YCOUNT
        IF R.USER<EB.USE.DATA.COMPARISON,YAV> THEN
            YRESTR = R.USER<EB.USE.COMPANY.RESTR,YAV>
            IF YRESTR THEN
                IF YRESTR = YCOM THEN YRESTR = ""
            END
            IF NOT(YRESTR) THEN
                YAPPLI = R.USER<EB.USE.APPLICATION,YAV>
                LOCATE YAPPLI IN YT.SMS.FILE<1> SETTING X ELSE X = 0
                IF X THEN
                    IF (INDEX(R.USER<EB.USE.FUNCTION,YAV>,"P",1)) OR (INDEX(R.USER<EB.USE.FUNCTION,YAV>,"S",1)) THEN
                        LOCATE YAPPLI IN YT.SMS<1,1> SETTING X ELSE
                            YT.SMS<1,-1> = YAPPLI
                        END
                        YT.SMS<2,X,-1> = YAV
                    END
                END
            END
        END
    NEXT YAV
*
    YFILE = "F.DATES"; YF.DATES = ""
    CALL OPF (YFILE, YF.DATES)
    YFILE = "F.ACCOUNT.CLASS"; YF.ACCOUNT.CLASS = ""
    CALL OPF (YFILE, YF.ACCOUNT.CLASS)
    YFILE = "F.LMM.TEXT"; YF.LMM.TEXT = ""
    CALL OPF (YFILE, YF.LMM.TEXT)
*************************************************************************
    YFILE = "MM.MONEY.MARKET"
    FULL.FNAME = "F.MM.MONEY.MARKET"; YF.MM.MONEY.MARKET = ""
    LOCATE YFILE IN YT.SMS<1,1> SETTING X ELSE
        X = 0; T.PWD = ""
    END
    IF X THEN
        T.PWD = YT.SMS<2,X>
        CONVERT @SM TO @FM IN T.PWD
    END
    SS.REC = ""
    CALL GET.STANDARD.SELECTION.DETS(YFILE,SS.REC)
    LOCATE "CO.CODE" IN SS.REC<SSL.SYS.FIELD.NAME,1> SETTING COMP.FOUND ELSE COMP.FOUND = ""
    CALL OPF (FULL.FNAME, YF.MM.MONEY.MARKET)
    CLEARSELECT
    IF C$MULTI.BOOK AND COMP.FOUND THEN
        SEL.ARGS = " WITH CO.CODE EQUAL ":ID.COMPANY
    END ELSE
        SEL.ARGS = ""
    END
    SELECT.CMMD = "SELECT ":FULL.FNAME:SEL.ARGS
    CALL EB.READLIST(SELECT.CMMD,YID.LIST,"","","")
    LOOP
        REMOVE ID.NEW FROM YID.LIST SETTING YDELIM
    WHILE ID.NEW:YDELIM
        MATREAD R.NEW FROM YF.MM.MONEY.MARKET, ID.NEW ELSE ID.NEW = "" ; MAT R.NEW = ""
        IF T.PWD THEN
            CALL CONTROL.USER.PROFILE ("RECORD")
            IF ETEXT THEN ID.NEW = ""
        END
        IF ID.NEW <> "" THEN
*
* Handle Decision Table
            YM.TODAY = R.NEW(91)
            IF YM.TODAY <> "" THEN
                YCOMP = "DATES_1_":YM.TODAY
                YFORFIL = YF.DATES
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.TODAY = YFOR.FD
            END
            YTRUE.1 = 0
            YM.CATEGORY = R.NEW(7)
            IF YM.CATEGORY >= 21050 THEN
                YTRUE.1 = 1
                YM.PAYMENT.DATE = R.NEW(5)
            END
            IF NOT(YTRUE.1) THEN
                YM.CATEGORY = R.NEW(7)
                IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
                    YTRUE.1 = 1
                    YM.PAYMENT.DATE = R.NEW(6)
                END
            END
            IF NOT(YTRUE.1) THEN YM.PAYMENT.DATE = ""
            YM.PAYM.DATE.MINUS.3 = YM.PAYMENT.DATE
            YM1.PAYM.DATE.MINUS.3 = YM.PAYM.DATE.MINUS.3
            YM.PAYM.DATE.MINUS.3 = "3"
            IF NUM(YM1.PAYM.DATE.MINUS.3) = NUMERIC THEN IF NUM(YM.PAYM.DATE.MINUS.3) = NUMERIC THEN
                IF LEN(YM1.PAYM.DATE.MINUS.3) = 8 THEN IF ABS(YM.PAYM.DATE.MINUS.3) < 10000 THEN
                    YM.PAYM.DATE.MINUS.3 = "-":YM.PAYM.DATE.MINUS.3:"W"
                    CALL CDT("", YM1.PAYM.DATE.MINUS.3, YM.PAYM.DATE.MINUS.3)
                END
                IF YM1.PAYM.DATE.MINUS.3 = 0 THEN YM1.PAYM.DATE.MINUS.3 = ""
            END
            YM.PAYM.DATE.MINUS.3 = YM1.PAYM.DATE.MINUS.3
            YTRUE.1 = 0
            YM.CATEGORY = R.NEW(7)
            IF YM.CATEGORY >= 21050 THEN
                YTRUE.1 = 1
                YM.REM.ACCOUNT = R.NEW(22)
            END
            IF NOT(YTRUE.1) THEN
                YM.CATEGORY = R.NEW(7)
                IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
                    YTRUE.1 = 1
                    YM.REM.ACCOUNT = R.NEW(23)
                END
            END
            IF NOT(YTRUE.1) THEN YM.REM.ACCOUNT = ""
            YTRUE.1 = 0
            YM.CATEGORY = R.NEW(7)
            IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
                YTRUE.1 = 1
                YM.REM.INT.ACCT = R.NEW(28)
            END
            IF NOT(YTRUE.1) THEN YM.REM.INT.ACCT = ""
            IF YM.PAYM.DATE.MINUS.3 <= YM.TODAY AND YM.PAYMENT.DATE > 999 AND ((YM.REM.ACCOUNT >= 1 AND YM.REM.ACCOUNT <= 9) OR (YM.REM.INT.ACCT >= 1 AND YM.REM.INT.ACCT <= 9)) THEN
                GOSUB 2000000
            END
1000:
        END
*
    REPEAT
    IF YKEYNO THEN
        YR.REC(10)  := @FM
        MATWRITE YR.REC TO F.FILE, YKEY
    END
*
    IF NOT(PHNO) THEN PRINT @(41,L1ST-3):YBLOCKNO+YWRITNO:
    IF SAVE.ID.COMPANY # ID.COMPANY THEN
        CALL LOAD.COMPANY(SAVE.ID.COMPANY)
    END
RETURN
*************************************************************************
*
* Define and Write record
2000000:
*
    YKEY = ""; MAT YR.REC = ""
    YTRUE.1 = 0
    YM.CATEGORY = R.NEW(7)
    IF YM.CATEGORY >= 21050 THEN
        YTRUE.1 = 1
        YM.PAYMENT.DATE = R.NEW(5)
    END
    IF NOT(YTRUE.1) THEN
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
            YTRUE.1 = 1
            YM.PAYMENT.DATE = R.NEW(6)
        END
    END
    IF NOT(YTRUE.1) THEN YM.PAYMENT.DATE = ""
    YM.KEY.DATE = YM.PAYMENT.DATE
    YKEYFD = YM.KEY.DATE

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

    FULL.TXN.ID = ""
    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

    YKEYFD = FMT(YM.KEY.DATE,"10L")


    IF LEN(YKEYFD) > 10 THEN YKEYFD = YKEYFD[1,9]:"|"
    GOSUB 8000000
    YM.DISPLAY.DATE = YM.PAYMENT.DATE
    YR.REC(1) = YM.DISPLAY.DATE
    YM.CUSTOMER = R.NEW(1)
    YR.REC(2) = YM.CUSTOMER
    YM.CCY = R.NEW(2)
    YR.REC(3) = YM.CCY
    YM.PRINCIPAL = R.NEW(3)
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
    IF YM.PRINCIPAL <> "" THEN
        YM.PRINCIPAL = TRIM(FMT(YM.PRINCIPAL,"19R":YDEC))
    END
    YR.REC(4) = YM.PRINCIPAL
    YM.REFERENCE = ID.NEW
    YR.REC(5) = YM.REFERENCE
    YTRUE.1 = 0
    YTRUE.2 = 0
    YM.CATEGORY = R.NEW(7)
    IF YM.CATEGORY >= 21050 THEN
        YTRUE.2 = 1
        YM.REM.ACCOUNT = R.NEW(22)
    END
    IF NOT(YTRUE.2) THEN
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
            YTRUE.2 = 1
            YM.REM.ACCOUNT = R.NEW(23)
        END
    END
    IF NOT(YTRUE.2) THEN YM.REM.ACCOUNT = ""
    IF YM.REM.ACCOUNT = 1 THEN
        YTRUE.1 = 1
        YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
        IF YM.LMM.TEXT.CATEGORY <> "" THEN
            YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
            YFORFIL = YF.ACCOUNT.CLASS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.LMM.TEXT.CATEGORY = YFOR.FD
        END
        YM.TEXT.1 = YM.LMM.TEXT.CATEGORY
        IF YM.TEXT.1 <> "" THEN
            YCOMP = "LMM.TEXT_1_":YM.TEXT.1
            YFORFIL = YF.LMM.TEXT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
            YM.TEXT.1 = YFOR.FD
        END
        YM.TEXT = YM.TEXT.1
    END
    IF NOT(YTRUE.1) THEN
        YTRUE.2 = 0
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY >= 21050 THEN
            YTRUE.2 = 1
            YM.REM.ACCOUNT = R.NEW(22)
        END
        IF NOT(YTRUE.2) THEN
            YM.CATEGORY = R.NEW(7)
            IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
                YTRUE.2 = 1
                YM.REM.ACCOUNT = R.NEW(23)
            END
        END
        IF NOT(YTRUE.2) THEN YM.REM.ACCOUNT = ""
        IF YM.REM.ACCOUNT = 2 THEN
            YTRUE.1 = 1
            YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
            IF YM.LMM.TEXT.CATEGORY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LMM.TEXT.CATEGORY = YFOR.FD
            END
            YM.TEXT.2 = YM.LMM.TEXT.CATEGORY
            IF YM.TEXT.2 <> "" THEN
                YCOMP = "LMM.TEXT_2_":YM.TEXT.2
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT.2 = YFOR.FD
            END
            YM.TEXT = YM.TEXT.2
        END
    END
    IF NOT(YTRUE.1) THEN
        YTRUE.2 = 0
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY >= 21050 THEN
            YTRUE.2 = 1
            YM.REM.ACCOUNT = R.NEW(22)
        END
        IF NOT(YTRUE.2) THEN
            YM.CATEGORY = R.NEW(7)
            IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
                YTRUE.2 = 1
                YM.REM.ACCOUNT = R.NEW(23)
            END
        END
        IF NOT(YTRUE.2) THEN YM.REM.ACCOUNT = ""
        IF YM.REM.ACCOUNT = 3 THEN
            YTRUE.1 = 1
            YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
            IF YM.LMM.TEXT.CATEGORY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LMM.TEXT.CATEGORY = YFOR.FD
            END
            YM.TEXT.3 = YM.LMM.TEXT.CATEGORY
            IF YM.TEXT.3 <> "" THEN
                YCOMP = "LMM.TEXT_3_":YM.TEXT.3
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT.3 = YFOR.FD
            END
            YM.TEXT = YM.TEXT.3
        END
    END
    IF NOT(YTRUE.1) THEN
        YTRUE.2 = 0
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY >= 21050 THEN
            YTRUE.2 = 1
            YM.REM.ACCOUNT = R.NEW(22)
        END
        IF NOT(YTRUE.2) THEN
            YM.CATEGORY = R.NEW(7)
            IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
                YTRUE.2 = 1
                YM.REM.ACCOUNT = R.NEW(23)
            END
        END
        IF NOT(YTRUE.2) THEN YM.REM.ACCOUNT = ""
        IF YM.REM.ACCOUNT = 4 THEN
            YTRUE.1 = 1
            YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
            IF YM.LMM.TEXT.CATEGORY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LMM.TEXT.CATEGORY = YFOR.FD
            END
            YM.TEXT.4 = YM.LMM.TEXT.CATEGORY
            IF YM.TEXT.4 <> "" THEN
                YCOMP = "LMM.TEXT_4_":YM.TEXT.4
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT.4 = YFOR.FD
            END
            YM.TEXT = YM.TEXT.4
        END
    END
    IF NOT(YTRUE.1) THEN
        YTRUE.2 = 0
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY >= 21050 THEN
            YTRUE.2 = 1
            YM.REM.ACCOUNT = R.NEW(22)
        END
        IF NOT(YTRUE.2) THEN
            YM.CATEGORY = R.NEW(7)
            IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
                YTRUE.2 = 1
                YM.REM.ACCOUNT = R.NEW(23)
            END
        END
        IF NOT(YTRUE.2) THEN YM.REM.ACCOUNT = ""
        IF YM.REM.ACCOUNT = 5 THEN
            YTRUE.1 = 1
            YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
            IF YM.LMM.TEXT.CATEGORY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LMM.TEXT.CATEGORY = YFOR.FD
            END
            YM.TEXT.5 = YM.LMM.TEXT.CATEGORY
            IF YM.TEXT.5 <> "" THEN
                YCOMP = "LMM.TEXT_5_":YM.TEXT.5
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT.5 = YFOR.FD
            END
            YM.TEXT = YM.TEXT.5
        END
    END
    IF NOT(YTRUE.1) THEN
        YTRUE.2 = 0
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY >= 21050 THEN
            YTRUE.2 = 1
            YM.REM.ACCOUNT = R.NEW(22)
        END
        IF NOT(YTRUE.2) THEN
            YM.CATEGORY = R.NEW(7)
            IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
                YTRUE.2 = 1
                YM.REM.ACCOUNT = R.NEW(23)
            END
        END
        IF NOT(YTRUE.2) THEN YM.REM.ACCOUNT = ""
        IF YM.REM.ACCOUNT = 6 THEN
            YTRUE.1 = 1
            YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
            IF YM.LMM.TEXT.CATEGORY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LMM.TEXT.CATEGORY = YFOR.FD
            END
            YM.TEXT.6 = YM.LMM.TEXT.CATEGORY
            IF YM.TEXT.6 <> "" THEN
                YCOMP = "LMM.TEXT_6_":YM.TEXT.6
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT.6 = YFOR.FD
            END
            YM.TEXT = YM.TEXT.6
        END
    END
    IF NOT(YTRUE.1) THEN
        YTRUE.2 = 0
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY >= 21050 THEN
            YTRUE.2 = 1
            YM.REM.ACCOUNT = R.NEW(22)
        END
        IF NOT(YTRUE.2) THEN
            YM.CATEGORY = R.NEW(7)
            IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
                YTRUE.2 = 1
                YM.REM.ACCOUNT = R.NEW(23)
            END
        END
        IF NOT(YTRUE.2) THEN YM.REM.ACCOUNT = ""
        IF YM.REM.ACCOUNT = 7 THEN
            YTRUE.1 = 1
            YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
            IF YM.LMM.TEXT.CATEGORY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LMM.TEXT.CATEGORY = YFOR.FD
            END
            YM.TEXT.7 = YM.LMM.TEXT.CATEGORY
            IF YM.TEXT.7 <> "" THEN
                YCOMP = "LMM.TEXT_7_":YM.TEXT.7
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT.7 = YFOR.FD
            END
            YM.TEXT = YM.TEXT.7
        END
    END
    IF NOT(YTRUE.1) THEN
        YTRUE.2 = 0
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY >= 21050 THEN
            YTRUE.2 = 1
            YM.REM.ACCOUNT = R.NEW(22)
        END
        IF NOT(YTRUE.2) THEN
            YM.CATEGORY = R.NEW(7)
            IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
                YTRUE.2 = 1
                YM.REM.ACCOUNT = R.NEW(23)
            END
        END
        IF NOT(YTRUE.2) THEN YM.REM.ACCOUNT = ""
        IF YM.REM.ACCOUNT = 8 THEN
            YTRUE.1 = 1
            YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
            IF YM.LMM.TEXT.CATEGORY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LMM.TEXT.CATEGORY = YFOR.FD
            END
            YM.TEXT.8 = YM.LMM.TEXT.CATEGORY
            IF YM.TEXT.8 <> "" THEN
                YCOMP = "LMM.TEXT_8_":YM.TEXT.8
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT.8 = YFOR.FD
            END
            YM.TEXT = YM.TEXT.8
        END
    END
    IF NOT(YTRUE.1) THEN
        YTRUE.2 = 0
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY >= 21050 THEN
            YTRUE.2 = 1
            YM.REM.ACCOUNT = R.NEW(22)
        END
        IF NOT(YTRUE.2) THEN
            YM.CATEGORY = R.NEW(7)
            IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
                YTRUE.2 = 1
                YM.REM.ACCOUNT = R.NEW(23)
            END
        END
        IF NOT(YTRUE.2) THEN YM.REM.ACCOUNT = ""
        IF YM.REM.ACCOUNT = 9 THEN
            YTRUE.1 = 1
            YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
            IF YM.LMM.TEXT.CATEGORY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LMM.TEXT.CATEGORY = YFOR.FD
            END
            YM.TEXT.9 = YM.LMM.TEXT.CATEGORY
            IF YM.TEXT.9 <> "" THEN
                YCOMP = "LMM.TEXT_9_":YM.TEXT.9
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT.9 = YFOR.FD
            END
            YM.TEXT = YM.TEXT.9
        END
    END
    IF NOT(YTRUE.1) THEN YM.TEXT = ""
    YR.REC(6) = YM.TEXT
    YM.OUR.REMARKS = R.NEW(19)
    YR.REC(7) = YM.OUR.REMARKS
    YM.BROKER = R.NEW(17)
    YR.REC(8) = YM.BROKER
    YTRUE.1 = 0
    YM.CATEGORY = R.NEW(7)
    IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
        YTRUE.1 = 1
        YM.INTEREST.AMOUNT = R.NEW(14)
    END
    IF NOT(YTRUE.1) THEN YM.INTEREST.AMOUNT = ""
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
    IF YM.INTEREST.AMOUNT <> "" THEN
        YM.INTEREST.AMOUNT = TRIM(FMT(YM.INTEREST.AMOUNT,"19R":YDEC))
    END
    YR.REC(9) = YM.INTEREST.AMOUNT
    YTRUE.1 = 0
    YTRUE.2 = 0
    YM.CATEGORY = R.NEW(7)
    IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
        YTRUE.2 = 1
        YM.REM.INT.ACCT = R.NEW(28)
    END
    IF NOT(YTRUE.2) THEN YM.REM.INT.ACCT = ""
    IF YM.REM.INT.ACCT = 1 THEN
        YTRUE.1 = 1
        YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
        IF YM.LMM.TEXT.CATEGORY <> "" THEN
            YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
            YFORFIL = YF.ACCOUNT.CLASS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.LMM.TEXT.CATEGORY = YFOR.FD
        END
        YM.TEXT.1 = YM.LMM.TEXT.CATEGORY
        IF YM.TEXT.1 <> "" THEN
            YCOMP = "LMM.TEXT_1_":YM.TEXT.1
            YFORFIL = YF.LMM.TEXT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
            YM.TEXT.1 = YFOR.FD
        END
        YM.TEXTI = YM.TEXT.1
    END
    IF NOT(YTRUE.1) THEN
        YTRUE.2 = 0
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
            YTRUE.2 = 1
            YM.REM.INT.ACCT = R.NEW(28)
        END
        IF NOT(YTRUE.2) THEN YM.REM.INT.ACCT = ""
        IF YM.REM.INT.ACCT = 2 THEN
            YTRUE.1 = 1
            YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
            IF YM.LMM.TEXT.CATEGORY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LMM.TEXT.CATEGORY = YFOR.FD
            END
            YM.TEXT.2 = YM.LMM.TEXT.CATEGORY
            IF YM.TEXT.2 <> "" THEN
                YCOMP = "LMM.TEXT_2_":YM.TEXT.2
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT.2 = YFOR.FD
            END
            YM.TEXTI = YM.TEXT.2
        END
    END
    IF NOT(YTRUE.1) THEN
        YTRUE.2 = 0
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
            YTRUE.2 = 1
            YM.REM.INT.ACCT = R.NEW(28)
        END
        IF NOT(YTRUE.2) THEN YM.REM.INT.ACCT = ""
        IF YM.REM.INT.ACCT = 3 THEN
            YTRUE.1 = 1
            YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
            IF YM.LMM.TEXT.CATEGORY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LMM.TEXT.CATEGORY = YFOR.FD
            END
            YM.TEXT.3 = YM.LMM.TEXT.CATEGORY
            IF YM.TEXT.3 <> "" THEN
                YCOMP = "LMM.TEXT_3_":YM.TEXT.3
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT.3 = YFOR.FD
            END
            YM.TEXTI = YM.TEXT.3
        END
    END
    IF NOT(YTRUE.1) THEN
        YTRUE.2 = 0
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
            YTRUE.2 = 1
            YM.REM.INT.ACCT = R.NEW(28)
        END
        IF NOT(YTRUE.2) THEN YM.REM.INT.ACCT = ""
        IF YM.REM.INT.ACCT = 4 THEN
            YTRUE.1 = 1
            YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
            IF YM.LMM.TEXT.CATEGORY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LMM.TEXT.CATEGORY = YFOR.FD
            END
            YM.TEXT.4 = YM.LMM.TEXT.CATEGORY
            IF YM.TEXT.4 <> "" THEN
                YCOMP = "LMM.TEXT_4_":YM.TEXT.4
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT.4 = YFOR.FD
            END
            YM.TEXTI = YM.TEXT.4
        END
    END
    IF NOT(YTRUE.1) THEN
        YTRUE.2 = 0
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
            YTRUE.2 = 1
            YM.REM.INT.ACCT = R.NEW(28)
        END
        IF NOT(YTRUE.2) THEN YM.REM.INT.ACCT = ""
        IF YM.REM.INT.ACCT = 5 THEN
            YTRUE.1 = 1
            YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
            IF YM.LMM.TEXT.CATEGORY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LMM.TEXT.CATEGORY = YFOR.FD
            END
            YM.TEXT.5 = YM.LMM.TEXT.CATEGORY
            IF YM.TEXT.5 <> "" THEN
                YCOMP = "LMM.TEXT_5_":YM.TEXT.5
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT.5 = YFOR.FD
            END
            YM.TEXTI = YM.TEXT.5
        END
    END
    IF NOT(YTRUE.1) THEN
        YTRUE.2 = 0
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
            YTRUE.2 = 1
            YM.REM.INT.ACCT = R.NEW(28)
        END
        IF NOT(YTRUE.2) THEN YM.REM.INT.ACCT = ""
        IF YM.REM.INT.ACCT = 6 THEN
            YTRUE.1 = 1
            YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
            IF YM.LMM.TEXT.CATEGORY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LMM.TEXT.CATEGORY = YFOR.FD
            END
            YM.TEXT.6 = YM.LMM.TEXT.CATEGORY
            IF YM.TEXT.6 <> "" THEN
                YCOMP = "LMM.TEXT_6_":YM.TEXT.6
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT.6 = YFOR.FD
            END
            YM.TEXTI = YM.TEXT.6
        END
    END
    IF NOT(YTRUE.1) THEN
        YTRUE.2 = 0
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
            YTRUE.2 = 1
            YM.REM.INT.ACCT = R.NEW(28)
        END
        IF NOT(YTRUE.2) THEN YM.REM.INT.ACCT = ""
        IF YM.REM.INT.ACCT = 7 THEN
            YTRUE.1 = 1
            YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
            IF YM.LMM.TEXT.CATEGORY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LMM.TEXT.CATEGORY = YFOR.FD
            END
            YM.TEXT.7 = YM.LMM.TEXT.CATEGORY
            IF YM.TEXT.7 <> "" THEN
                YCOMP = "LMM.TEXT_7_":YM.TEXT.7
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT.7 = YFOR.FD
            END
            YM.TEXTI = YM.TEXT.7
        END
    END
    IF NOT(YTRUE.1) THEN
        YTRUE.2 = 0
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
            YTRUE.2 = 1
            YM.REM.INT.ACCT = R.NEW(28)
        END
        IF NOT(YTRUE.2) THEN YM.REM.INT.ACCT = ""
        IF YM.REM.INT.ACCT = 8 THEN
            YTRUE.1 = 1
            YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
            IF YM.LMM.TEXT.CATEGORY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LMM.TEXT.CATEGORY = YFOR.FD
            END
            YM.TEXT.8 = YM.LMM.TEXT.CATEGORY
            IF YM.TEXT.8 <> "" THEN
                YCOMP = "LMM.TEXT_8_":YM.TEXT.8
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT.8 = YFOR.FD
            END
            YM.TEXTI = YM.TEXT.8
        END
    END
    IF NOT(YTRUE.1) THEN
        YTRUE.2 = 0
        YM.CATEGORY = R.NEW(7)
        IF YM.CATEGORY < 21050 AND YM.CATEGORY THEN
            YTRUE.2 = 1
            YM.REM.INT.ACCT = R.NEW(28)
        END
        IF NOT(YTRUE.2) THEN YM.REM.INT.ACCT = ""
        IF YM.REM.INT.ACCT = 9 THEN
            YTRUE.1 = 1
            YM.LMM.TEXT.CATEGORY = "SUSPLMMCR"
            IF YM.LMM.TEXT.CATEGORY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.LMM.TEXT.CATEGORY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LMM.TEXT.CATEGORY = YFOR.FD
            END
            YM.TEXT.9 = YM.LMM.TEXT.CATEGORY
            IF YM.TEXT.9 <> "" THEN
                YCOMP = "LMM.TEXT_9_":YM.TEXT.9
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT.9 = YFOR.FD
            END
            YM.TEXTI = YM.TEXT.9
        END
    END
    IF NOT(YTRUE.1) THEN YM.TEXTI = ""
    YR.REC(10) = YM.TEXTI
*
    YKEYNO = YKEYNO + 1
    IF YKEYNO > 9999 THEN
        YKEY = YKEY:YKEYNO
    END ELSE
        YKEY = YKEY : FMT(YKEYNO,'5"0"R')
    END
    MATWRITE YR.REC TO F.FILE, YKEY
*
    IF NOT(PHNO) THEN
        IF YWRITNO < 9 THEN
            YWRITNO = YWRITNO + 1
        END ELSE
            YWRITNO = 0; YBLOCKNO = YBLOCKNO + 10
            PRINT @(41,L1ST-3):YBLOCKNO+YWRITNO:
        END
    END
RETURN
*************************************************************************
*
* Update Key (and convert invalid Key char.)
8000000:
*
    YLEN.KEY = LEN(YKEYFD)
    FOR YNO = 1 TO YLEN.KEY
        YKEY.CHR = YKEYFD[YNO,1]
        IF YKEY.CHR MATCHES "1A" OR YKEY.CHR MATCHES "1N" THEN
            YKEY = YKEY : YKEY.CHR
        END ELSE
            IF INDEX(".$",YKEY.CHR,1) THEN
                YKEY = YKEY : YKEY.CHR
            END ELSE
                YKEY = YKEY : "&"
            END
        END
    NEXT YNO
RETURN
*************************************************************************
*
* Update table of Parameters of foreign file
9000000:
*
    LOCATE YCOMP IN YT.FORFIL<1,1> SETTING YLOC.FOR ELSE
        YFOR.ID = FIELD(YCOMP,"_",3)
        YFOR.FD = FIELD(YCOMP,"_",2)
        YFOR.AF = FIELD(YFOR.FD,".",1)
        YFOR.AV = FIELD(YFOR.FD,".",2)
        YFOR.AS = FIELD(YFOR.FD,".",3)
*
        T.PWD.SAVE = T.PWD; T.PWD = ""
        IF YT.SMS THEN
            LOCATE FIELD(YCOMP,"_",1) IN YT.SMS<1,1> SETTING T.PWD ELSE NULL
        END
        IF T.PWD THEN
            MAT R.NEW.LAST = MAT R.NEW
            ID.NEW.SAVE = ID.NEW; ID.NEW = YFOR.ID
            MATREAD R.NEW FROM YFORFIL, ID.NEW ELSE MAT R.NEW = ""
            T.PWD = YT.SMS<2,T.PWD>; CONVERT @SM TO @FM IN T.PWD
            CALL CONTROL.USER.PROFILE ("RECORD")
            IF ETEXT THEN
                YFOR.FD = "@"
            END ELSE
                YFOR.FD = R.NEW(YFOR.AF)
            END
            MAT R.NEW = MAT R.NEW.LAST; ID.NEW = ID.NEW.SAVE
        END ELSE
            IF FIELD(YCOMP,"_",1) = "DATES"  AND (RUNNING.UNDER.BATCH) THEN
                COB.N.W.DATE = R.DATES(YFOR.AF)
                YFOR.FD = COB.N.W.DATE
            END ELSE
                READV YFOR.FD FROM YFORFIL, YFOR.ID, YFOR.AF ELSE YFOR.FD = ""
            END
        END
        T.PWD = T.PWD.SAVE; T.PWD.SAVE = ""
*
        IF NOT(YHANDLE.LNGG) THEN
            IF YFOR.AV <> "" THEN YFOR.FD = YFOR.FD<1,YFOR.AV,YFOR.AS>
        END ELSE
            IF YFOR.FD<1,LNGG> = "" THEN
                YFOR.FD = YFOR.FD<1,1>
            END ELSE
                YFOR.FD = YFOR.FD<1,LNGG>
            END
        END
        IF NOT(COUNT(YFOR.FD,@VM)) THEN
            DEL YT.FORFIL<1,50>; DEL YT.FORFIL<2,50>
            INS YCOMP BEFORE YT.FORFIL<1,1>
            INS YFOR.FD BEFORE YT.FORFIL<2,1>
        END
        YLOC.FOR = 0
    END
    IF YLOC.FOR THEN YFOR.FD = YT.FORFIL<2,YLOC.FOR>
    IF YPART.S <> "" THEN
        YCOUNT.FOR = COUNT(YFOR.FD,@VM)+1
        FOR YAV.FOR = 1 TO YCOUNT.FOR
            YCOUNT.AS.FOR = COUNT(YFOR.FD<1,YAV.FOR>,@SM)+1
            FOR YAS.FOR = 1 TO YCOUNT.AS.FOR
                IF YFD.LEN = "" THEN
                    YFOR.FD<1,YAV.FOR,YAS.FOR> = FIELD(YFOR.FD<1,YAV.FOR,YAS.FOR>,YPART.S,YPART.L)
                END ELSE
                    X = FMT(YFOR.FD<1,YAV.FOR,YAS.FOR>,YFD.LEN)
                    YFOR.FD<1,YAV.FOR,YAS.FOR> = X[YPART.S,YPART.L]
                END
            NEXT YAS.FOR
        NEXT YAV.FOR
    END
RETURN
*************************************************************************
*
* Ask for valid file password in connection with Company code
9300000:
*
    IF X THEN IF R.USER<EB.USE.COMPANY.RESTR,X> THEN
        IF R.USER<EB.USE.COMPANY.RESTR,X> <> YID.COMP THEN X = 0
    END
RETURN
*************************************************************************
END
