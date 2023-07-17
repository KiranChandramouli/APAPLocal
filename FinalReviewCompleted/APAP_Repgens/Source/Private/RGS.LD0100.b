$PACKAGE APAP.Repgens

SUBROUTINE RGS.LD0100
REM "RGS.LD0100",230614-4
*------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*16-06-2023       Samaran T               R22 Manual Code Conversion       No Changes
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
    JULDATE = "JULDATE"
    LD.ADD.TO.DATE = "LD.ADD.TO.DATE"
    LD.EXTRCT.VAL = "LD.EXTRCT.VAL"
*************************************************************************
    YT.SMS.COMP = ID.COMPANY
    YT.SMS.FILE = "LD.LOANS.AND.DEPOSITS"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
    YT.SMS.FILE<-1> = "CURRENCY"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "DATES"
    YT.SMS.FILE<-1> = "CATEGORY"
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
    DIM YR.REC(32)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.LD0100"
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
        CALL FATAL.ERROR ("RGS.LD0100")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "LD.LOANS.AND.DEPOSITS"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
    YT.SMS.FILE<-1> = "CURRENCY"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "DATES"
    YT.SMS.FILE<-1> = "CATEGORY"
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
    YFILE = "F.DEPT.ACCT.OFFICER"; YF.DEPT.ACCT.OFFICER = ""
    CALL OPF (YFILE, YF.DEPT.ACCT.OFFICER)
    YFILE = "F.CURRENCY"; YF.CURRENCY = ""
    CALL OPF (YFILE, YF.CURRENCY)
    YFILE = "F.CUSTOMER"; YF.CUSTOMER = ""
    CALL OPF (YFILE, YF.CUSTOMER)
    YFILE = "F.DATES"; YF.DATES = ""
    CALL OPF (YFILE, YF.DATES)
    YFILE = "F.CATEGORY"; YF.CATEGORY = ""
    CALL OPF (YFILE, YF.CATEGORY)
*************************************************************************
    YFILE = "LD.LOANS.AND.DEPOSITS"
    FULL.FNAME = "F.LD.LOANS.AND.DEPOSITS"; YF.LD.LOANS.AND.DEPOSITS = ""
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
    CALL OPF (FULL.FNAME, YF.LD.LOANS.AND.DEPOSITS)
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
        MATREAD R.NEW FROM YF.LD.LOANS.AND.DEPOSITS, ID.NEW ELSE ID.NEW = "" ; MAT R.NEW = ""
        IF T.PWD THEN
            CALL CONTROL.USER.PROFILE ("RECORD")
            IF ETEXT THEN ID.NEW = ""
        END
        IF ID.NEW <> "" THEN
*
* Handle Decision Table
            YM.FINAL.MAT.DATE = R.NEW(7)
            YM.MAT.DATE.PARAM = YM.FINAL.MAT.DATE
            YM9.GOSUB = YM.MAT.DATE.PARAM
            YM.MAT.JULDATE = ""
            YM10.GOSUB = YM.MAT.JULDATE
            CALL @JULDATE (YM9.GOSUB, YM10.GOSUB)
            YM.MAT.DATE.PARAM = YM9.GOSUB
            YM.MAT.JULDATE = YM10.GOSUB
            YM.NEXT.WORK.DAY = R.NEW(250)
            IF YM.NEXT.WORK.DAY <> "" THEN
                YCOMP = "DATES_4_":YM.NEXT.WORK.DAY
                YFORFIL = YF.DATES
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.NEXT.WORK.DAY = YFOR.FD
            END
            YM.WORKDAY.PARAM = YM.NEXT.WORK.DAY
            YM13.GOSUB = YM.WORKDAY.PARAM
            YM.WORK.JULDATE = ""
            YM14.GOSUB = YM.WORK.JULDATE
            CALL @JULDATE (YM13.GOSUB, YM14.GOSUB)
            YM.WORKDAY.PARAM = YM13.GOSUB
            YM.WORK.JULDATE = YM14.GOSUB
            YM.INPUT.DATE = YM.WORK.JULDATE
            YM15.GOSUB = YM.INPUT.DATE
            YM.ADD.PARAM = "7"
            YM16.GOSUB = YM.ADD.PARAM
            YM.WORKDAY.PLUS.SEVEN = ""
            YM17.GOSUB = YM.WORKDAY.PLUS.SEVEN
            CALL @LD.ADD.TO.DATE (YM15.GOSUB, YM16.GOSUB, YM17.GOSUB)
            YM.INPUT.DATE = YM15.GOSUB
            YM.ADD.PARAM = YM16.GOSUB
            YM.WORKDAY.PLUS.SEVEN = YM17.GOSUB
            IF ((YM.WORK.JULDATE = YM.MAT.JULDATE) OR (YM.MAT.JULDATE > YM.WORK.JULDATE AND YM.MAT.JULDATE <= YM.WORKDAY.PLUS.SEVEN)) AND ((YM.FINAL.MAT.DATE < 0 OR YM.FINAL.MAT.DATE > 999)) THEN
                GOSUB 2000000
            END
1000:
        END
*
    REPEAT
    IF YKEYNO THEN
        YR.REC(32)  := @FM
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
    YM.ACCT.OFFICER.NAME = R.NEW(79)
    IF YM.ACCT.OFFICER.NAME <> "" THEN
        YCOMP = "DEPT.ACCT.OFFICER_2_":YM.ACCT.OFFICER.NAME
        YFORFIL = YF.DEPT.ACCT.OFFICER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.ACCT.OFFICER.NAME = YFOR.FD
    END
    YKEYFD = YM.ACCT.OFFICER.NAME

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

    FULL.TXN.ID = ""
    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

    YKEYFD = FMT(YM.ACCT.OFFICER.NAME,"27L")


    IF LEN(YKEYFD) > 27 THEN YKEYFD = YKEYFD[1,26]:"|"
    GOSUB 8000000
    YR.REC(1) = YM.ACCT.OFFICER.NAME
    YM.CURR = R.NEW(2)
    YKEYFD = YM.CURR

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

    FULL.TXN.ID = ""
    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

    YKEYFD = FMT(YM.CURR,"5L")


    IF LEN(YKEYFD) > 5 THEN YKEYFD = YKEYFD[1,4]:"|"
    GOSUB 8000000
    YM.CCY = R.NEW(2)
    IF YM.CCY <> "" THEN
        YCOMP = "CURRENCY_3_":YM.CCY
        YFORFIL = YF.CURRENCY
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.CCY = YFOR.FD
    END
    YKEYFD = YM.CCY

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

    FULL.TXN.ID = ""
    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

    YKEYFD = FMT(YM.CCY,"22L")


    IF LEN(YKEYFD) > 22 THEN YKEYFD = YKEYFD[1,21]:"|"
    GOSUB 8000000
    YR.REC(2) = YM.CCY
    YM.FINAL.MAT.DATE = R.NEW(7)
    YKEYFD = YM.FINAL.MAT.DATE

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

    FULL.TXN.ID = ""
    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

    YKEYFD = FMT(YM.FINAL.MAT.DATE,"13L")


    IF LEN(YKEYFD) > 13 THEN YKEYFD = YKEYFD[1,12]:"|"
    GOSUB 8000000
    YM.TOTAL.LIT = "TOTAL "
    YM.TOT.LIT.PRINT = YM.TOTAL.LIT
    YM1.TOT.LIT.PRINT = YM.TOT.LIT.PRINT
    YM.CCY.MNE.PRINT = YM.CCY
    YM.TOT.LIT.PRINT = YM.CCY.MNE.PRINT
    YM1.TOT.LIT.PRINT = YM1.TOT.LIT.PRINT : YM.TOT.LIT.PRINT
    YM.TOT.LIT.PRINT = YM1.TOT.LIT.PRINT
    YR.REC(3) = YM.TOT.LIT.PRINT
    YM.CONTRACT.NO = ID.NEW
    YKEYFD = FMT(YM.CONTRACT.NO,"R##-#####-#####")
    IF LEN(YKEYFD) > 14 THEN YKEYFD = YKEYFD[1,13]:"|"
    GOSUB 8000000
    YR.REC(4) = YM.CONTRACT.NO
    YM.CUSTOMER = R.NEW(1)
    IF YM.CUSTOMER <> "" THEN
        YCOMP = "CUSTOMER_2_":YM.CUSTOMER
        YFORFIL = YF.CUSTOMER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.CUSTOMER = YFOR.FD
    END
    YR.REC(5) = YM.CUSTOMER
    YTRUE.1 = 0
    YM.LIQ.CD = R.NEW(33)
    IF YM.LIQ.CD = 1 THEN
        YTRUE.1 = 1
        YM.LIQ.CD.PRINT = "AA"
    END
    IF NOT(YTRUE.1) THEN
        YM.LIQ.CD = R.NEW(33)
        IF YM.LIQ.CD = 3 THEN
            YTRUE.1 = 1
            YM.LIQ.CD.PRINT = "AM"
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.LIQ.CD = R.NEW(33)
        IF YM.LIQ.CD = 2 THEN
            YTRUE.1 = 1
            YM.LIQ.CD.PRINT = "PM"
        END
    END
    IF NOT(YTRUE.1) THEN YM.LIQ.CD.PRINT = ""
    YM.LIQ.CD.MOVE = YM.LIQ.CD.PRINT
    YR.REC(6) = YM.LIQ.CD.MOVE
    YM.FILE.NAME1 = "F.LMM.ACCOUNT.BALANCES"
    YM26.GOSUB = YM.FILE.NAME1
    YM.ACCBAL.KEY = ID.NEW
    YM1.ACCBAL.KEY = YM.ACCBAL.KEY
    YM.ACCBAL.KEY = "00"
    YM1.ACCBAL.KEY = YM1.ACCBAL.KEY : YM.ACCBAL.KEY
    YM.ACCBAL.KEY = YM1.ACCBAL.KEY
    YM.ACCBAL.KEY.PARAM = YM.ACCBAL.KEY
    YM27.GOSUB = YM.ACCBAL.KEY.PARAM
    YM.FIELD.NO1 = "6"
    YM28.GOSUB = YM.FIELD.NO1
    YM.OP.CODE1 = "LAST"
    YM29.GOSUB = YM.OP.CODE1
    YM.AMOUNT = ""
    YM30.GOSUB = YM.AMOUNT
    CALL @LD.EXTRCT.VAL (YM26.GOSUB, YM27.GOSUB, YM28.GOSUB, YM29.GOSUB, YM30.GOSUB)
    YM.FILE.NAME1 = YM26.GOSUB
    YM.ACCBAL.KEY.PARAM = YM27.GOSUB
    YM.FIELD.NO1 = YM28.GOSUB
    YM.OP.CODE1 = YM29.GOSUB
    YM.AMOUNT = YM30.GOSUB
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
    IF YM.AMOUNT <> "" THEN
        YM.AMOUNT = TRIM(FMT(YM.AMOUNT,"19R":YDEC))
    END
    YR.REC(7) = YM.AMOUNT
    YM.AMT.TOT = YM.AMOUNT
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
    IF YM.AMT.TOT <> "" THEN
        YM.AMT.TOT = TRIM(FMT(YM.AMT.TOT,"19R":YDEC))
    END
    YR.REC(8) = YM.AMT.TOT
    YM.INT.AMT = R.NEW(24)
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
    IF YM.INT.AMT <> "" THEN
        YM.INT.AMT = TRIM(FMT(YM.INT.AMT,"19R":YDEC))
    END
    YR.REC(9) = YM.INT.AMT
    YM.INT.AMT.TOT = R.NEW(24)
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
    IF YM.INT.AMT.TOT <> "" THEN
        YM.INT.AMT.TOT = TRIM(FMT(YM.INT.AMT.TOT,"19R":YDEC))
    END
    YR.REC(10) = YM.INT.AMT.TOT
    YM.COM.AMT = R.NEW(37)
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
    IF YM.COM.AMT <> "" THEN
        YM.COM.AMT = TRIM(FMT(YM.COM.AMT,"19R":YDEC))
    END
    YR.REC(11) = YM.COM.AMT
    YM.COM.AMT.TOT = R.NEW(37)
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
    IF YM.COM.AMT.TOT <> "" THEN
        YM.COM.AMT.TOT = TRIM(FMT(YM.COM.AMT.TOT,"19R":YDEC))
    END
    YR.REC(12) = YM.COM.AMT.TOT
    YM.FILE.NAME2 = "F.LMM.SCHEDULES"
    YM36.GOSUB = YM.FILE.NAME2
    YM.SHED.KEY.INTER = ID.NEW
    YM1.SHED.KEY.INTER = YM.SHED.KEY.INTER
    YM.MAT.DATE.PARAM = YM.FINAL.MAT.DATE
    YM9.GOSUB = YM.MAT.DATE.PARAM
    YM.MAT.JULDATE = ""
    YM10.GOSUB = YM.MAT.JULDATE
    CALL @JULDATE (YM9.GOSUB, YM10.GOSUB)
    YM.MAT.DATE.PARAM = YM9.GOSUB
    YM.MAT.JULDATE = YM10.GOSUB
    YM.SHED.KEY.INTER = YM.MAT.JULDATE
    YM.SHED.KEY.INTER = FMT(YM.SHED.KEY.INTER,"7L"); YM.SHED.KEY.INTER = YM.SHED.KEY.INTER[1,7]
    YM1.SHED.KEY.INTER = YM1.SHED.KEY.INTER : YM.SHED.KEY.INTER
    YM.SHED.KEY.INTER = YM1.SHED.KEY.INTER
    YM.SHED.KEY = YM.SHED.KEY.INTER
    YM1.SHED.KEY = YM.SHED.KEY
    YM.SHED.KEY = "00"
    YM1.SHED.KEY = YM1.SHED.KEY : YM.SHED.KEY
    YM.SHED.KEY = YM1.SHED.KEY
    YM.SHED.KEY.PARAM = YM.SHED.KEY
    YM37.GOSUB = YM.SHED.KEY.PARAM
    YM.FIELD.NO2 = "14"
    YM38.GOSUB = YM.FIELD.NO2
    YM.OP.CODE2 = "SUM"
    YM39.GOSUB = YM.OP.CODE2
    YM.FEE.AMT.SCHED = ""
    YM40.GOSUB = YM.FEE.AMT.SCHED
    CALL @LD.EXTRCT.VAL (YM36.GOSUB, YM37.GOSUB, YM38.GOSUB, YM39.GOSUB, YM40.GOSUB)
    YM.FILE.NAME2 = YM36.GOSUB
    YM.SHED.KEY.PARAM = YM37.GOSUB
    YM.FIELD.NO2 = YM38.GOSUB
    YM.OP.CODE2 = YM39.GOSUB
    YM.FEE.AMT.SCHED = YM40.GOSUB
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
    IF YM.FEE.AMT.SCHED <> "" THEN
        YM.FEE.AMT.SCHED = TRIM(FMT(YM.FEE.AMT.SCHED,"19R":YDEC))
    END
    YR.REC(13) = YM.FEE.AMT.SCHED
    YM.FEE.AMT.TOT = YM.FEE.AMT.SCHED
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
    IF YM.FEE.AMT.TOT <> "" THEN
        YM.FEE.AMT.TOT = TRIM(FMT(YM.FEE.AMT.TOT,"19R":YDEC))
    END
    YR.REC(14) = YM.FEE.AMT.TOT
    YM.CATEGORY = R.NEW(11)
    IF YM.CATEGORY <> "" THEN
        YCOMP = "CATEGORY_2_":YM.CATEGORY
        YFORFIL = YF.CATEGORY
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
        YM.CATEGORY = YFOR.FD
    END
    YR.REC(15) = YM.CATEGORY
    YM.CUST.ID = R.NEW(1)
    YR.REC(16) = YM.CUST.ID
    YTRUE.1 = 0
    YM.TOT.INT.TAX = R.NEW(155)
    YM.TAX.TEMP = YM.TOT.INT.TAX
    IF YM.TAX.TEMP <> "" THEN
        YTRUE.1 = 1
        YM.TOT.INT.TAX = R.NEW(155)
        YM.INT.TAX.DUMMY = YM.TOT.INT.TAX
    END
    IF NOT(YTRUE.1) THEN
        YM.TOT.INT.TAX = R.NEW(155)
        IF YM.TOT.INT.TAX = "" THEN
            YTRUE.1 = 1
            YM.INT.TAX.DUMMY = R.NEW(156)
        END
    END
    IF NOT(YTRUE.1) THEN YM.INT.TAX.DUMMY = ""
    YM.TAX.PRINT = YM.INT.TAX.DUMMY
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
    IF YM.TAX.PRINT <> "" THEN
        YM.TAX.PRINT = TRIM(FMT(YM.TAX.PRINT,"19R":YDEC))
    END
    YR.REC(17) = YM.TAX.PRINT
    YM.TAX.TOTAL = YM.INT.TAX.DUMMY
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
    IF YM.TAX.TOTAL <> "" THEN
        YM.TAX.TOTAL = TRIM(FMT(YM.TAX.TOTAL,"19R":YDEC))
    END
    YR.REC(18) = YM.TAX.TOTAL
    YM.COM.TAX = R.NEW(157)
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
    IF YM.COM.TAX <> "" THEN
        YM.COM.TAX = TRIM(FMT(YM.COM.TAX,"19R":YDEC))
    END
    YR.REC(19) = YM.COM.TAX
    YM.COM.TAX.TOTAL = YM.COM.TAX
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
    IF YM.COM.TAX.TOTAL <> "" THEN
        YM.COM.TAX.TOTAL = TRIM(FMT(YM.COM.TAX.TOTAL,"19R":YDEC))
    END
    YR.REC(20) = YM.COM.TAX.TOTAL
    YM.MAT.DATE.PRINT = YM.FINAL.MAT.DATE
    YR.REC(21) = YM.MAT.DATE.PRINT
    YM.START.DATE = R.NEW(6)
    YR.REC(22) = YM.START.DATE
    YTRUE.1 = 0
    IF YM.AMOUNT <> "" THEN
        YTRUE.1 = 1
        YM.ACCT.NO = R.NEW(67)
    END
    IF NOT(YTRUE.1) THEN YM.ACCT.NO = ""
    YR.REC(23) = YM.ACCT.NO
    YTRUE.1 = 0
    IF YM.INT.AMT <> "" THEN
        YTRUE.1 = 1
        YM.INT.ACCT = R.NEW(72)
    END
    IF NOT(YTRUE.1) THEN YM.INT.ACCT = ""
    YR.REC(24) = YM.INT.ACCT
    YTRUE.1 = 0
    IF YM.COM.AMT <> "" THEN
        YTRUE.1 = 1
        YM.COM.ACCT = R.NEW(77)
    END
    IF NOT(YTRUE.1) THEN YM.COM.ACCT = ""
    YR.REC(25) = YM.COM.ACCT
    YTRUE.1 = 0
    IF YM.FEE.AMT.SCHED <> "" THEN
        YTRUE.1 = 1
        YM.FEE.ACCT = R.NEW(78)
    END
    IF NOT(YTRUE.1) THEN YM.FEE.ACCT = ""
    YR.REC(26) = YM.FEE.ACCT
    YTRUE.1 = 0
    YM.SEND.PAYMENT = R.NEW(159)
    IF YM.SEND.PAYMENT = "NO" THEN
        YTRUE.1 = 1
        YM.NO.PAYMENT.PRINT = "*** NO PAYMENT SENT ***"
    END
    IF NOT(YTRUE.1) THEN YM.NO.PAYMENT.PRINT = ""
    YR.REC(27) = YM.NO.PAYMENT.PRINT
    YM.BLANK.LINE = " "
    YR.REC(28) = YM.BLANK.LINE
    YM.SEPARATOR1 = "*********************************"
    YR.REC(29) = YM.SEPARATOR1
    YM.SEPARATOR2 = "*********************************"
    YR.REC(30) = YM.SEPARATOR2
    YM.SEPARATOR3 = "*********************************"
    YR.REC(31) = YM.SEPARATOR3
    YM.SEPARATOR4 = "*********************************"
    YR.REC(32) = YM.SEPARATOR4
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
