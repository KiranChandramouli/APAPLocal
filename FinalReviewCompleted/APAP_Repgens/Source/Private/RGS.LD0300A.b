$PACKAGE APAP.Repgens

SUBROUTINE RGS.LD0300A
REM "RGS.LD0300A",230614-4
*-----------------------------------------------------------------------------------
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
    LD.EXTRACT.DATE.SUM = "LD.EXTRACT.DATE.SUM"
    LD.EXTRCT.VAL = "LD.EXTRCT.VAL"
*************************************************************************
    YT.SMS.COMP = ID.COMPANY
    YT.SMS.FILE = "LMM.SCHEDULES"
    YT.SMS.FILE<-1> = "LD.LOANS.AND.DEPOSITS"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
    YT.SMS.FILE<-1> = "DATES"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "INTEREST.BASIS"
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
    DIM YR.REC(54)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.LD0300A"
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
        CALL FATAL.ERROR ("RGS.LD0300A")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "LMM.SCHEDULES"
    YT.SMS.FILE<-1> = "LD.LOANS.AND.DEPOSITS"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
    YT.SMS.FILE<-1> = "DATES"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "INTEREST.BASIS"
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
    YFILE = "F.LD.LOANS.AND.DEPOSITS"; YF.LD.LOANS.AND.DEPOSITS = ""
    CALL OPF (YFILE, YF.LD.LOANS.AND.DEPOSITS)
    YFILE = "F.DEPT.ACCT.OFFICER"; YF.DEPT.ACCT.OFFICER = ""
    CALL OPF (YFILE, YF.DEPT.ACCT.OFFICER)
    YFILE = "F.DATES"; YF.DATES = ""
    CALL OPF (YFILE, YF.DATES)
    YFILE = "F.CUSTOMER"; YF.CUSTOMER = ""
    CALL OPF (YFILE, YF.CUSTOMER)
    YFILE = "F.INTEREST.BASIS"; YF.INTEREST.BASIS = ""
    CALL OPF (YFILE, YF.INTEREST.BASIS)
*************************************************************************
    YFILE = "LMM.SCHEDULES"
    FULL.FNAME = "F.LMM.SCHEDULES"; YF.LMM.SCHEDULES = ""
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
    CALL OPF (FULL.FNAME, YF.LMM.SCHEDULES)
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
        MATREAD R.NEW FROM YF.LMM.SCHEDULES, ID.NEW ELSE ID.NEW = "" ; MAT R.NEW = ""
        IF T.PWD THEN
            CALL CONTROL.USER.PROFILE ("RECORD")
            IF ETEXT THEN ID.NEW = ""
        END
        IF ID.NEW <> "" THEN
*
* Handle Decision Table
            YM.SHED.KEY = ID.NEW
            YM.LD.KEY = YM.SHED.KEY
            YM.LD.KEY = FMT(YM.LD.KEY,"19L"); YM.LD.KEY = YM.LD.KEY[1,12]
            YM.COMP.CD = YM.LD.KEY
            IF YM.COMP.CD <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_187_":YM.COMP.CD
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.COMP.CD = YFOR.FD
            END
            YM.TODAYS.DATE = YM.COMP.CD
            IF YM.TODAYS.DATE <> "" THEN
                YCOMP = "DATES_14_":YM.TODAYS.DATE
                YFORFIL = YF.DATES
                YPART.S = 1; YPART.L = 7; YFD.LEN = "7L"; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.TODAYS.DATE = YFOR.FD
            END
            YM.EVENT.DATE = YM.SHED.KEY
            YM.EVENT.DATE = FMT(YM.EVENT.DATE,"19L"); YM.EVENT.DATE = YM.EVENT.DATE[13,7]
            YM.EVENT.DATE.PARAM = ""
            YM8.GOSUB = YM.EVENT.DATE.PARAM
            YM.DATE.REQD.DUMMY = ""
            YM9.GOSUB = YM.DATE.REQD.DUMMY
            YM.DATE.SUM = ""
            YM10.GOSUB = YM.DATE.SUM
            YM.OP.CODE1 = "SUM"
            YM11.GOSUB = YM.OP.CODE1
            CALL @LD.EXTRACT.DATE.SUM (YM8.GOSUB, YM9.GOSUB, YM10.GOSUB, YM11.GOSUB)
            YM.EVENT.DATE.PARAM = YM8.GOSUB
            YM.DATE.REQD.DUMMY = YM9.GOSUB
            YM.DATE.SUM = YM10.GOSUB
            YM.OP.CODE1 = YM11.GOSUB
            YM.TYPE.R = R.NEW(6)
            YM.LD.CHAR = YM.LD.KEY
            YM.LD.CHAR = FMT(YM.LD.CHAR,"12L"); YM.LD.CHAR = YM.LD.CHAR[1,2]
            IF (YM.EVENT.DATE > YM.TODAYS.DATE AND YM.EVENT.DATE <= YM.DATE.SUM) AND (YM.TYPE.R <> "") AND (YM.LD.CHAR = "LD") THEN
                GOSUB 2000000
            END
        END
*
    REPEAT
    IF YKEYNO THEN
        YR.REC(54)  := @FM
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
    YM.SHED.KEY = ID.NEW
    YM.LD.KEY = YM.SHED.KEY
    YM.LD.KEY = FMT(YM.LD.KEY,"19L"); YM.LD.KEY = YM.LD.KEY[1,12]
    YM.ACCT.OFFICER.KEY = YM.LD.KEY
    IF YM.ACCT.OFFICER.KEY <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_79_":YM.ACCT.OFFICER.KEY
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.ACCT.OFFICER.KEY = YFOR.FD
    END
    YM.ACCT.OFFICER.NAME = YM.ACCT.OFFICER.KEY
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
    YM.EVENT.DATE = YM.SHED.KEY
    YM.EVENT.DATE = FMT(YM.EVENT.DATE,"19L"); YM.EVENT.DATE = YM.EVENT.DATE[13,7]
    YM.EVENT.DATE.DUMMY = YM.EVENT.DATE
    YM13.GOSUB = YM.EVENT.DATE.DUMMY
    YM.DATE.REQD = ""
    YM14.GOSUB = YM.DATE.REQD
    YM.DATE.SUM.DUMMY = ""
    YM15.GOSUB = YM.DATE.SUM.DUMMY
    YM.OP.CODE2 = "CONC"
    YM16.GOSUB = YM.OP.CODE2
    CALL @LD.EXTRACT.DATE.SUM (YM13.GOSUB, YM14.GOSUB, YM15.GOSUB, YM16.GOSUB)
    YM.EVENT.DATE.DUMMY = YM13.GOSUB
    YM.DATE.REQD = YM14.GOSUB
    YM.DATE.SUM.DUMMY = YM15.GOSUB
    YM.OP.CODE2 = YM16.GOSUB
    YM.DATE.REQD.PRINT = YM.DATE.REQD
    YKEYFD = YM.DATE.REQD.PRINT
    YKEYFD = FMT(YM.DATE.REQD.PRINT,"11L")
    IF LEN(YKEYFD) > 11 THEN YKEYFD = YKEYFD[1,10]:"|"
    GOSUB 8000000
    YR.REC(2) = YM.DATE.REQD.PRINT
    YM.LD.KEY.PRINT = YM.LD.KEY
    YKEYFD = FMT(YM.LD.KEY.PRINT,"R##-#####-#####")
    IF LEN(YKEYFD) > 14 THEN YKEYFD = YKEYFD[1,13]:"|"
    GOSUB 8000000
    YR.REC(3) = YM.LD.KEY.PRINT
    YM.CUST.KEY = YM.LD.KEY
    IF YM.CUST.KEY <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_1_":YM.CUST.KEY
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.CUST.KEY = YFOR.FD
    END
    YM.CUST.NAME = YM.CUST.KEY
    IF YM.CUST.NAME <> "" THEN
        YCOMP = "CUSTOMER_2_":YM.CUST.NAME
        YFORFIL = YF.CUSTOMER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.CUST.NAME = YFOR.FD
    END
    YR.REC(4) = YM.CUST.NAME
    YM.CCY = YM.LD.KEY
    IF YM.CCY <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_2_":YM.CCY
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.CCY = YFOR.FD
    END
    YR.REC(5) = YM.CCY
    YM.PRINC.AMT.LIT = "O/S Principal Amt. :"
    YR.REC(6) = YM.PRINC.AMT.LIT
    YM.ACCBAL.FILE = "F.LMM.ACCOUNT.BALANCES"
    YM24.GOSUB = YM.ACCBAL.FILE
    YM.ACCBAL.KEY = YM.LD.KEY
    YM1.ACCBAL.KEY = YM.ACCBAL.KEY
    YM.ACCBAL.KEY = "00"
    YM1.ACCBAL.KEY = YM1.ACCBAL.KEY : YM.ACCBAL.KEY
    YM.ACCBAL.KEY = YM1.ACCBAL.KEY
    YM.ACCBAL.KEY.PARAM = YM.ACCBAL.KEY
    YM25.GOSUB = YM.ACCBAL.KEY.PARAM
    YM.FIELD.NO = "6"
    YM26.GOSUB = YM.FIELD.NO
    YM.EXTRACT.OP.CODE = "LAST"
    YM27.GOSUB = YM.EXTRACT.OP.CODE
    YM.PRINC.AMT = ""
    YM28.GOSUB = YM.PRINC.AMT
    CALL @LD.EXTRCT.VAL (YM24.GOSUB, YM25.GOSUB, YM26.GOSUB, YM27.GOSUB, YM28.GOSUB)
    YM.ACCBAL.FILE = YM24.GOSUB
    YM.ACCBAL.KEY.PARAM = YM25.GOSUB
    YM.FIELD.NO = YM26.GOSUB
    YM.EXTRACT.OP.CODE = YM27.GOSUB
    YM.PRINC.AMT = YM28.GOSUB
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
    IF YM.PRINC.AMT <> "" THEN
        YM.PRINC.AMT = TRIM(FMT(YM.PRINC.AMT,"19R":YDEC))
    END
    YR.REC(7) = YM.PRINC.AMT
    YM.CUSTOMER.NO = YM.LD.KEY
    IF YM.CUSTOMER.NO <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_1_":YM.CUSTOMER.NO
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.CUSTOMER.NO = YFOR.FD
    END
    YR.REC(8) = YM.CUSTOMER.NO
    YM.LIT.1 = "Interest Rate Type :"
    YR.REC(9) = YM.LIT.1
    YTRUE.1 = 0
    YM.INT.RATE.TYPE = YM.LD.KEY
    IF YM.INT.RATE.TYPE <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_13_":YM.INT.RATE.TYPE
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.RATE.TYPE = YFOR.FD
    END
    IF YM.INT.RATE.TYPE = 1 THEN
        YTRUE.1 = 1
        YM.INT.RATE.TYPE.DUM = "FIXED"
    END
    IF NOT(YTRUE.1) THEN
        YM.INT.RATE.TYPE = YM.LD.KEY
        IF YM.INT.RATE.TYPE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_13_":YM.INT.RATE.TYPE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.RATE.TYPE = YFOR.FD
        END
        IF YM.INT.RATE.TYPE = 2 THEN
            YTRUE.1 = 1
            YM.INT.RATE.TYPE.DUM = "PERIODIC AUTOMATIC"
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.INT.RATE.TYPE = YM.LD.KEY
        IF YM.INT.RATE.TYPE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_13_":YM.INT.RATE.TYPE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.RATE.TYPE = YFOR.FD
        END
        IF YM.INT.RATE.TYPE = 3 THEN
            YTRUE.1 = 1
            YM.INT.RATE.TYPE.DUM = "FLOATING"
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.INT.RATE.TYPE = YM.LD.KEY
        IF YM.INT.RATE.TYPE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_13_":YM.INT.RATE.TYPE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.RATE.TYPE = YFOR.FD
        END
        IF YM.INT.RATE.TYPE = 4 THEN
            YTRUE.1 = 1
            YM.INT.RATE.TYPE.DUM = "PERIODIC MANUAL"
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.INT.RATE.TYPE = YM.LD.KEY
        IF YM.INT.RATE.TYPE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_13_":YM.INT.RATE.TYPE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.RATE.TYPE = YFOR.FD
        END
        IF YM.INT.RATE.TYPE = 5 THEN
            YTRUE.1 = 1
            YM.INT.RATE.TYPE.DUM = "PERIODIC STRAIGHT"
        END
    END
    IF NOT(YTRUE.1) THEN YM.INT.RATE.TYPE.DUM = ""
    YM.INT.RATE.TYPE.PRINT = YM.INT.RATE.TYPE.DUM
    YR.REC(10) = YM.INT.RATE.TYPE.PRINT
    YTRUE.1 = 0
    YM.MAT.DATE = YM.LD.KEY
    IF YM.MAT.DATE <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_7_":YM.MAT.DATE
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.MAT.DATE = YFOR.FD
    END
    YM.MAT.DATE.CHECK = YM.MAT.DATE
    IF YM.MAT.DATE.CHECK > 999 THEN
        YTRUE.1 = 1
        YM.MAT.DATE = YM.LD.KEY
        IF YM.MAT.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_7_":YM.MAT.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.MAT.DATE = YFOR.FD
        END
        YM.MAT.DATE.DUMMY = YM.MAT.DATE
    END
    IF NOT(YTRUE.1) THEN
        YM.MAT.DATE = YM.LD.KEY
        IF YM.MAT.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_7_":YM.MAT.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.MAT.DATE = YFOR.FD
        END
        YM.MAT.DATE.CHECK = YM.MAT.DATE
        IF YM.MAT.DATE.CHECK <= 999 THEN
            YTRUE.1 = 1
            YM.MAT.DATE = YM.LD.KEY
            IF YM.MAT.DATE <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_7_":YM.MAT.DATE
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.MAT.DATE = YFOR.FD
            END
            YM.CALL.NOTICE.LIT = YM.MAT.DATE
            YM1.CALL.NOTICE.LIT = YM.CALL.NOTICE.LIT
            YM.CALL.NOTICE.LIT = " D/N"
            YM1.CALL.NOTICE.LIT = YM1.CALL.NOTICE.LIT : YM.CALL.NOTICE.LIT
            YM.CALL.NOTICE.LIT = YM1.CALL.NOTICE.LIT
            YM.MAT.DATE.DUMMY = YM.CALL.NOTICE.LIT
        END
    END
    IF NOT(YTRUE.1) THEN YM.MAT.DATE.DUMMY = ""
    YM.MAT.DATE.PRINT = YM.MAT.DATE.DUMMY
    YR.REC(11) = YM.MAT.DATE.PRINT
    YM.PRINT.COLON = ":"
    YR.REC(12) = YM.PRINT.COLON
    YM.VAL.DATE = YM.LD.KEY
    IF YM.VAL.DATE <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_6_":YM.VAL.DATE
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.VAL.DATE = YFOR.FD
    END
    YR.REC(13) = YM.VAL.DATE
    YM.LIT.2 = "Interest Basis . . :"
    YR.REC(14) = YM.LIT.2
    YM.INT.BASIS.KEY = YM.LD.KEY
    IF YM.INT.BASIS.KEY <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_14_":YM.INT.BASIS.KEY
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.BASIS.KEY = YFOR.FD
    END
    YM.INT.BASIS = YM.INT.BASIS.KEY
    IF YM.INT.BASIS <> "" THEN
        YCOMP = "INTEREST.BASIS_2_":YM.INT.BASIS
        YFORFIL = YF.INTEREST.BASIS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.BASIS = YFOR.FD
    END
    YM.INT.BASIS.PRINT = YM.INT.BASIS
    YR.REC(15) = YM.INT.BASIS.PRINT
    YM.LIT.3 = "Comm Basis. . . . .:"
    YR.REC(16) = YM.LIT.3
    YM.COM.BASIS.KEY = YM.LD.KEY
    IF YM.COM.BASIS.KEY <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_34_":YM.COM.BASIS.KEY
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.COM.BASIS.KEY = YFOR.FD
    END
    YM.COM.BASIS = YM.COM.BASIS.KEY
    IF YM.COM.BASIS <> "" THEN
        YCOMP = "INTEREST.BASIS_2_":YM.COM.BASIS
        YFORFIL = YF.INTEREST.BASIS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.COM.BASIS = YFOR.FD
    END
    YM.COM.BASIS.PRINT = YM.COM.BASIS
    YR.REC(17) = YM.COM.BASIS.PRINT
    YM.LIT.4 = "Int. Payment Method:"
    YR.REC(18) = YM.LIT.4
    YTRUE.1 = 0
    YM.INT.PAY.METH = YM.LD.KEY
    IF YM.INT.PAY.METH <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_15_":YM.INT.PAY.METH
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.PAY.METH = YFOR.FD
    END
    IF YM.INT.PAY.METH = 1 THEN
        YTRUE.1 = 1
        YM.INT.PAY.DUM = "INTEREST BEARING"
    END
    IF NOT(YTRUE.1) THEN
        YM.INT.PAY.METH = YM.LD.KEY
        IF YM.INT.PAY.METH <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_15_":YM.INT.PAY.METH
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.PAY.METH = YFOR.FD
        END
        IF YM.INT.PAY.METH = 2 THEN
            YTRUE.1 = 1
            YM.INT.PAY.DUM = "DISCOUNTED"
        END
    END
    IF NOT(YTRUE.1) THEN YM.INT.PAY.DUM = ""
    YM.INT.PAY.PRINT = YM.INT.PAY.DUM
    YR.REC(19) = YM.INT.PAY.PRINT
    YM.LIT.5 = "Comm. Paymt. Method:"
    YR.REC(20) = YM.LIT.5
    YTRUE.1 = 0
    YM.COMM.PAYMT.METH = YM.LD.KEY
    IF YM.COMM.PAYMT.METH <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_35_":YM.COMM.PAYMT.METH
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.COMM.PAYMT.METH = YFOR.FD
    END
    IF YM.COMM.PAYMT.METH = 1 THEN
        YTRUE.1 = 1
        YM.COM.PAY.DUM = "INTEREST BEARING"
    END
    IF NOT(YTRUE.1) THEN
        YM.COMM.PAYMT.METH = YM.LD.KEY
        IF YM.COMM.PAYMT.METH <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_35_":YM.COMM.PAYMT.METH
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COMM.PAYMT.METH = YFOR.FD
        END
        IF YM.COMM.PAYMT.METH = 2 THEN
            YTRUE.1 = 1
            YM.COM.PAY.DUM = "DISCOUNTED"
        END
    END
    IF NOT(YTRUE.1) THEN YM.COM.PAY.DUM = ""
    YM.COM.PAY.PRINT = YM.COM.PAY.DUM
    YR.REC(21) = YM.COM.PAY.PRINT
    YM.LIT.6 = "Interest Rate. . . :"
    YR.REC(22) = YM.LIT.6
    YM.INT.RATE = YM.LD.KEY
    IF YM.INT.RATE <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_16.1_":YM.INT.RATE
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.RATE = YFOR.FD
    END
    YR.REC(23) = YM.INT.RATE
    YM.LIT.7 = "New Interest Rate. :"
    YR.REC(24) = YM.LIT.7
    YM.NEW.INT.RATE = YM.LD.KEY
    IF YM.NEW.INT.RATE <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_129.1_":YM.NEW.INT.RATE
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.NEW.INT.RATE = YFOR.FD
    END
    YR.REC(25) = YM.NEW.INT.RATE
    YM.LIT.8 = "Interest Key . . . :"
    YR.REC(26) = YM.LIT.8
    YM.INT.KEY = YM.LD.KEY
    IF YM.INT.KEY <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_17_":YM.INT.KEY
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.KEY = YFOR.FD
    END
    YR.REC(27) = YM.INT.KEY
    YM.LIT.9 = "Interest Spread. . :"
    YR.REC(28) = YM.LIT.9
    YM.INT.SPREAD = YM.LD.KEY
    IF YM.INT.SPREAD <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_18_":YM.INT.SPREAD
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.SPREAD = YFOR.FD
    END
    YR.REC(29) = YM.INT.SPREAD
    YM.LIT.10 = "New Spread . . . . :"
    YR.REC(30) = YM.LIT.10
    YM.NEW.SPREAD = YM.LD.KEY
    IF YM.NEW.SPREAD <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_131_":YM.NEW.SPREAD
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.NEW.SPREAD = YFOR.FD
    END
    YR.REC(31) = YM.NEW.SPREAD
    YM.LIT.11 = "First Day Accrual. :"
    YR.REC(32) = YM.LIT.11
    YM.FIRST.DAY.ACCR = YM.LD.KEY
    IF YM.FIRST.DAY.ACCR <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_19_":YM.FIRST.DAY.ACCR
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.FIRST.DAY.ACCR = YFOR.FD
    END
    YR.REC(33) = YM.FIRST.DAY.ACCR
    YM.LIT.13 = "MIS Interest Key . :"
    YR.REC(34) = YM.LIT.13
    YM.MIS.INT.KEY = YM.LD.KEY
    IF YM.MIS.INT.KEY <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_21_":YM.MIS.INT.KEY
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.MIS.INT.KEY = YFOR.FD
    END
    YR.REC(35) = YM.MIS.INT.KEY
    YM.LIT.14 = "MIS Interest Rate. :"
    YR.REC(36) = YM.LIT.14
    YM.MIS.INT.RATE = YM.LD.KEY
    IF YM.MIS.INT.RATE <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_22_":YM.MIS.INT.RATE
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.MIS.INT.RATE = YFOR.FD
    END
    YR.REC(37) = YM.MIS.INT.RATE
    YM.LIT.16 = "Capitalisation . . :"
    YR.REC(38) = YM.LIT.16
    YM.CAPITALISATION = YM.LD.KEY
    IF YM.CAPITALISATION <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_23_":YM.CAPITALISATION
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.CAPITALISATION = YFOR.FD
    END
    YR.REC(39) = YM.CAPITALISATION
    YM.LIT.19 = "Liquidation Method :"
    YR.REC(40) = YM.LIT.19
    YM.LIQ.CD = YM.LD.KEY
    IF YM.LIQ.CD <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_44_":YM.LIQ.CD
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.LIQ.CD = YFOR.FD
    END
    YM.LIQ.CD.PRINT = YM.LIQ.CD
    YR.REC(41) = YM.LIQ.CD.PRINT
    YM.LIT.17 = "Commission Rate. . :"
    YR.REC(42) = YM.LIT.17
    YM.COMM.RATE = YM.LD.KEY
    IF YM.COMM.RATE <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_36.1_":YM.COMM.RATE
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.COMM.RATE = YFOR.FD
    END
    YR.REC(43) = YM.COMM.RATE
    YM.LIT.18 = "New Commission Rate:"
    YR.REC(44) = YM.LIT.18
    YM.NEW.COMM.RATE = YM.LD.KEY
    IF YM.NEW.COMM.RATE <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_135.1_":YM.NEW.COMM.RATE
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.NEW.COMM.RATE = YFOR.FD
    END
    YR.REC(45) = YM.NEW.COMM.RATE
    YM.LIT.12 = "Int. Ref. Number . :"
    YR.REC(46) = YM.LIT.12
    YM.INT.REF.NO = YM.LD.KEY
    IF YM.INT.REF.NO <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_20_":YM.INT.REF.NO
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.REF.NO = YFOR.FD
    END
    YR.REC(47) = YM.INT.REF.NO
    YM.LIT.20 = "Comm Rate Val Date :"
    YR.REC(48) = YM.LIT.20
    YM.COM.DATE.REQD = YM.LD.KEY
    YCOUNT.RPL = COUNT(YM.COM.DATE.REQD,@VM)+1
    FOR YAV.RPL = 1 TO YCOUNT.RPL
        IF YM.COM.DATE.REQD<1,YAV.RPL> <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_136_":YM.COM.DATE.REQD<1,YAV.RPL>
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.DATE.REQD<1,YAV.RPL> = YFOR.FD
        END
    NEXT YAV.RPL
    YR.REC(49) = YM.COM.DATE.REQD
    YM.BLANK.LINE = " "
    YR.REC(50) = YM.BLANK.LINE
    YM.END.REC.LIT1 = "*********************************"
    YR.REC(51) = YM.END.REC.LIT1
    YM.END.REC.LIT2 = "*********************************"
    YR.REC(52) = YM.END.REC.LIT2
    YM.END.REC.LIT3 = "*********************************"
    YR.REC(53) = YM.END.REC.LIT3
    YM.END.REC.LIT4 = "*********************************"
    YR.REC(54) = YM.END.REC.LIT4
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
