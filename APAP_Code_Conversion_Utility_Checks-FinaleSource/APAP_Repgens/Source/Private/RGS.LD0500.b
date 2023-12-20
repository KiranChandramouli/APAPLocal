$PACKAGE APAP.Repgens

SUBROUTINE RGS.LD0500
REM "RGS.LD0500",230614-4
*-------------------------------------------------------------------------------
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
    LD.EXTRCT.SUBSEQ.DT = "LD.EXTRCT.SUBSEQ.DT"
    JULDATE = "JULDATE"
    LD.EXTRCT.VAL = "LD.EXTRCT.VAL"
*************************************************************************
    YT.SMS.COMP = ID.COMPANY
    YT.SMS.FILE = "LD.LOANS.AND.DEPOSITS"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
    YT.SMS.FILE<-1> = "LMM.ACCOUNT.BALANCES"
    YT.SMS.FILE<-1> = "DATES"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "LMM.SCHEDULES"
    YT.SMS.FILE<-1> = "ACCOUNT.CLASS"
    YT.SMS.FILE<-1> = "LMM.TEXT"
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
    DIM YR.REC(66)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.LD0500"
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
        CALL FATAL.ERROR ("RGS.LD0500")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "LD.LOANS.AND.DEPOSITS"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
    YT.SMS.FILE<-1> = "LMM.ACCOUNT.BALANCES"
    YT.SMS.FILE<-1> = "DATES"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "LMM.SCHEDULES"
    YT.SMS.FILE<-1> = "ACCOUNT.CLASS"
    YT.SMS.FILE<-1> = "LMM.TEXT"
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
    YFILE = "F.LMM.ACCOUNT.BALANCES"; YF.LMM.ACCOUNT.BALANCES = ""
    CALL OPF (YFILE, YF.LMM.ACCOUNT.BALANCES)
    YFILE = "F.DATES"; YF.DATES = ""
    CALL OPF (YFILE, YF.DATES)
    YFILE = "F.CUSTOMER"; YF.CUSTOMER = ""
    CALL OPF (YFILE, YF.CUSTOMER)
    YFILE = "F.LMM.SCHEDULES"; YF.LMM.SCHEDULES = ""
    CALL OPF (YFILE, YF.LMM.SCHEDULES)
    YFILE = "F.ACCOUNT.CLASS"; YF.ACCOUNT.CLASS = ""
    CALL OPF (YFILE, YF.ACCOUNT.CLASS)
    YFILE = "F.LMM.TEXT"; YF.LMM.TEXT = ""
    CALL OPF (YFILE, YF.LMM.TEXT)
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
            YM.PRIN.ACT = R.NEW(67)
            YM.INT.ACT = R.NEW(72)
            YM.FEE.ACT = R.NEW(78)
            YM.COM.ACT = R.NEW(77)
            YM.DRAWDOWN.ACT = R.NEW(12)
            YM.CONTRACT.STATUS = R.NEW(90)
            IF (((YM.PRIN.ACT >= 1 AND YM.PRIN.ACT <= 9)) OR ((YM.INT.ACT >= 1 AND YM.INT.ACT <= 9)) OR ((YM.FEE.ACT >= 1 AND YM.FEE.ACT <= 9)) OR ((YM.COM.ACT >= 1 AND YM.COM.ACT <= 9)) OR ((YM.DRAWDOWN.ACT >= 1 AND YM.DRAWDOWN.ACT <= 9))) AND ((YM.CONTRACT.STATUS = "CUR") OR (YM.CONTRACT.STATUS = "FWD")) THEN
                GOSUB 2000000
            END
1000:
        END
*
    REPEAT
    IF YKEYNO THEN
        YR.REC(66)  := @FM
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
    YM.CONTRACT.NO = ID.NEW
    YKEYFD = FMT(YM.CONTRACT.NO,"R##-#####-#####")
    IF LEN(YKEYFD) > 14 THEN YKEYFD = YKEYFD[1,13]:"|"
    GOSUB 8000000
    YR.REC(2) = YM.CONTRACT.NO
    YTRUE.1 = 0
    YM.SHED.DATES.KEY = YM.CONTRACT.NO
    YM1.SHED.DATES.KEY = YM.SHED.DATES.KEY
    YM.SHED.DATES.KEY = "00"
    YM1.SHED.DATES.KEY = YM1.SHED.DATES.KEY : YM.SHED.DATES.KEY
    YM.SHED.DATES.KEY = YM1.SHED.DATES.KEY
    YM.DATES.KEY.PARAM1 = YM.SHED.DATES.KEY
    YM13.GOSUB = YM.DATES.KEY.PARAM1
    YM.TODAYS.DATE = R.NEW(250)
    IF YM.TODAYS.DATE <> "" THEN
        YCOMP = "DATES_14_":YM.TODAYS.DATE
        YFORFIL = YF.DATES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TODAYS.DATE = YFOR.FD
    END
    YM.PREVIOUS.DATE1 = YM.TODAYS.DATE
    YM14.GOSUB = YM.PREVIOUS.DATE1
    YM.EVENT.DATE1 = ""
    YM15.GOSUB = YM.EVENT.DATE1
    YM.EVENT.DATE.NO1 = "1"
    YM16.GOSUB = YM.EVENT.DATE.NO1
    CALL @LD.EXTRCT.SUBSEQ.DT (YM13.GOSUB, YM14.GOSUB, YM15.GOSUB, YM16.GOSUB)
    YM.DATES.KEY.PARAM1 = YM13.GOSUB
    YM.PREVIOUS.DATE1 = YM14.GOSUB
    YM.EVENT.DATE1 = YM15.GOSUB
    YM.EVENT.DATE.NO1 = YM16.GOSUB
    YM.DIFF1 = YM.EVENT.DATE1
    YM1.DIFF1 = YM.DIFF1
    YM.TODAYS.DATE = R.NEW(250)
    IF YM.TODAYS.DATE <> "" THEN
        YCOMP = "DATES_14_":YM.TODAYS.DATE
        YFORFIL = YF.DATES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TODAYS.DATE = YFOR.FD
    END
    YM.DIFF1 = YM.TODAYS.DATE
    IF NUM(YM1.DIFF1) = NUMERIC THEN IF NUM(YM.DIFF1) = NUMERIC THEN
        YM1.DIFF1 = YM1.DIFF1 - YM.DIFF1
        IF YM1.DIFF1 = 0 THEN YM1.DIFF1 = ""
    END
    YM.DIFF1 = YM1.DIFF1
    IF (YM.DIFF1 <= 5) AND ((YM.DIFF1 >= 0) OR (YM.DIFF1 = "")) THEN
        YTRUE.1 = 1
        YM.EVENT.FLAG1 = "**"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.FLAG1 = ""
    YR.REC(3) = YM.EVENT.FLAG1
    YM.DATE.PRINT1 = ""
    YM19.GOSUB = YM.DATE.PRINT1
    YM.EVENT.DATE.DUMMY1 = YM.EVENT.DATE1
    YM.JUL.EVENT.DATE1 = YM.EVENT.DATE.DUMMY1
    YM20.GOSUB = YM.JUL.EVENT.DATE1
    CALL @JULDATE (YM19.GOSUB, YM20.GOSUB)
    YM.DATE.PRINT1 = YM19.GOSUB
    YM.JUL.EVENT.DATE1 = YM20.GOSUB
    YR.REC(4) = YM.DATE.PRINT1
    YM.CUST.NAME = R.NEW(1)
    IF YM.CUST.NAME <> "" THEN
        YCOMP = "CUSTOMER_2_":YM.CUST.NAME
        YFORFIL = YF.CUSTOMER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.CUST.NAME = YFOR.FD
    END
    YR.REC(5) = YM.CUST.NAME
    YM.CCY = R.NEW(2)
    YR.REC(6) = YM.CCY
    YTRUE.1 = 0
    YM.LIQ.CD = R.NEW(33)
    IF YM.LIQ.CD = 1 THEN
        YTRUE.1 = 1
        YM.LIQ.CD.DUM = "AA"
    END
    IF NOT(YTRUE.1) THEN
        YM.LIQ.CD = R.NEW(33)
        IF YM.LIQ.CD = 2 THEN
            YTRUE.1 = 1
            YM.LIQ.CD.DUM = "PM"
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.LIQ.CD = R.NEW(33)
        IF YM.LIQ.CD = 3 THEN
            YTRUE.1 = 1
            YM.LIQ.CD.DUM = "AM"
        END
    END
    IF NOT(YTRUE.1) THEN YM.LIQ.CD.DUM = ""
    YM.LIQ.CD.PRINT = YM.LIQ.CD.DUM
    YR.REC(7) = YM.LIQ.CD.PRINT
    YTRUE.1 = 0
    YM.SHED.KEY.INT1 = ID.NEW
    YM1.SHED.KEY.INT1 = YM.SHED.KEY.INT1
    YM.SHED.KEY.INT1 = YM.EVENT.DATE1
    YM.SHED.KEY.INT1 = FMT(YM.SHED.KEY.INT1,"7L"); YM.SHED.KEY.INT1 = YM.SHED.KEY.INT1[1,7]
    YM1.SHED.KEY.INT1 = YM1.SHED.KEY.INT1 : YM.SHED.KEY.INT1
    YM.SHED.KEY.INT1 = YM1.SHED.KEY.INT1
    YM.SHED.KEY1 = YM.SHED.KEY.INT1
    YM1.SHED.KEY1 = YM.SHED.KEY1
    YM.SHED.KEY1 = "00"
    YM1.SHED.KEY1 = YM1.SHED.KEY1 : YM.SHED.KEY1
    YM.SHED.KEY1 = YM1.SHED.KEY1
    YM.TYPE.P1 = YM.SHED.KEY1
    IF YM.TYPE.P1 <> "" THEN
        YCOMP = "LMM.SCHEDULES_2_":YM.TYPE.P1
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.P1 = YFOR.FD
    END
    IF YM.TYPE.P1 <> "" THEN
        YTRUE.1 = 1
        YM.PRINC.LIT = "PRIN : "
    END
    IF NOT(YTRUE.1) THEN YM.PRINC.LIT = ""
    YR.REC(8) = YM.PRINC.LIT
    YM.SHED.KEY.INT1 = ID.NEW
    YM1.SHED.KEY.INT1 = YM.SHED.KEY.INT1
    YM.SHED.KEY.INT1 = YM.EVENT.DATE1
    YM.SHED.KEY.INT1 = FMT(YM.SHED.KEY.INT1,"7L"); YM.SHED.KEY.INT1 = YM.SHED.KEY.INT1[1,7]
    YM1.SHED.KEY.INT1 = YM1.SHED.KEY.INT1 : YM.SHED.KEY.INT1
    YM.SHED.KEY.INT1 = YM1.SHED.KEY.INT1
    YM.SHED.KEY1 = YM.SHED.KEY.INT1
    YM1.SHED.KEY1 = YM.SHED.KEY1
    YM.SHED.KEY1 = "00"
    YM1.SHED.KEY1 = YM1.SHED.KEY1 : YM.SHED.KEY1
    YM.SHED.KEY1 = YM1.SHED.KEY1
    YM.PRINC.AMT = YM.SHED.KEY1
    IF YM.PRINC.AMT <> "" THEN
        YCOMP = "LMM.SCHEDULES_3_":YM.PRINC.AMT
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.PRINC.AMT = YFOR.FD
    END
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
    IF YM.PRINC.AMT <> "" THEN
        YM.PRINC.AMT = TRIM(FMT(YM.PRINC.AMT,"19R":YDEC))
    END
    YR.REC(9) = YM.PRINC.AMT
    YTRUE.1 = 0
    YM.TYPE.P1 = YM.SHED.KEY1
    IF YM.TYPE.P1 <> "" THEN
        YCOMP = "LMM.SCHEDULES_2_":YM.TYPE.P1
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.P1 = YFOR.FD
    END
    IF YM.TYPE.P1 <> "" THEN
        YTRUE.1 = 1
        YTRUE.2 = 0
        YM.PRIN.ACT = R.NEW(67)
        IF YM.PRIN.ACT = 1 THEN
            YTRUE.2 = 1
            YTRUE.3 = 0
            YM.CAT.CD = R.NEW(11)
            YM.VAL.JULDATE = ID.NEW
            YM.DATE.DIFF = YM.VAL.JULDATE
            YM1.DATE.DIFF = YM.DATE.DIFF
            YM.TODAYS.DATE = R.NEW(250)
            IF YM.TODAYS.DATE <> "" THEN
                YCOMP = "DATES_14_":YM.TODAYS.DATE
                YFORFIL = YF.DATES
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.TODAYS.DATE = YFOR.FD
            END
            YM.DATE.DIFF = YM.TODAYS.DATE
            IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
            END
            YM.DATE.DIFF = YM1.DATE.DIFF
            IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                YTRUE.3 = 1
                YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
            END
            IF NOT(YTRUE.3) THEN
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                END
            END
            IF NOT(YTRUE.3) THEN
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                END
            END
            IF NOT(YTRUE.3) THEN
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                END
            END
            IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
            YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
            YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
            IF YM.ADVICE.TEXT.KEY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.ADVICE.TEXT.KEY = YFOR.FD
            END
            YM.TEXT1 = YM.ADVICE.TEXT.KEY
            IF YM.TEXT1 <> "" THEN
                YCOMP = "LMM.TEXT_1_":YM.TEXT1
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT1 = YFOR.FD
            END
            YM.PRINC.TEXT = YM.TEXT1
        END
        IF NOT(YTRUE.2) THEN
            YM.PRIN.ACT = R.NEW(67)
            IF YM.PRIN.ACT = 2 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT2 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT2 <> "" THEN
                    YCOMP = "LMM.TEXT_2_":YM.TEXT2
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT2 = YFOR.FD
                END
                YM.PRINC.TEXT = YM.TEXT2
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.PRIN.ACT = R.NEW(67)
            IF YM.PRIN.ACT = 3 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT3 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT3 <> "" THEN
                    YCOMP = "LMM.TEXT_3_":YM.TEXT3
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT3 = YFOR.FD
                END
                YM.PRINC.TEXT = YM.TEXT3
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.PRIN.ACT = R.NEW(67)
            IF YM.PRIN.ACT = 4 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT4 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT4 <> "" THEN
                    YCOMP = "LMM.TEXT_4_":YM.TEXT4
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT4 = YFOR.FD
                END
                YM.PRINC.TEXT = YM.TEXT4
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.PRIN.ACT = R.NEW(67)
            IF YM.PRIN.ACT = 5 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT5 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT5 <> "" THEN
                    YCOMP = "LMM.TEXT_5_":YM.TEXT5
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT5 = YFOR.FD
                END
                YM.PRINC.TEXT = YM.TEXT5
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.PRIN.ACT = R.NEW(67)
            IF YM.PRIN.ACT = 6 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT6 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT6 <> "" THEN
                    YCOMP = "LMM.TEXT_6_":YM.TEXT6
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT6 = YFOR.FD
                END
                YM.PRINC.TEXT = YM.TEXT6
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.PRIN.ACT = R.NEW(67)
            IF YM.PRIN.ACT = 7 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT7 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT7 <> "" THEN
                    YCOMP = "LMM.TEXT_7_":YM.TEXT7
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT7 = YFOR.FD
                END
                YM.PRINC.TEXT = YM.TEXT7
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.PRIN.ACT = R.NEW(67)
            IF YM.PRIN.ACT = 8 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT8 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT8 <> "" THEN
                    YCOMP = "LMM.TEXT_8_":YM.TEXT8
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT8 = YFOR.FD
                END
                YM.PRINC.TEXT = YM.TEXT8
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.PRIN.ACT = R.NEW(67)
            IF YM.PRIN.ACT = 9 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT9 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT9 <> "" THEN
                    YCOMP = "LMM.TEXT_9_":YM.TEXT9
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT9 = YFOR.FD
                END
                YM.PRINC.TEXT = YM.TEXT9
            END
        END
        IF NOT(YTRUE.2) THEN YM.PRINC.TEXT = ""
        YM.PRINC.TEXT.PRINT = YM.PRINC.TEXT
    END
    IF NOT(YTRUE.1) THEN YM.PRINC.TEXT.PRINT = ""
    YR.REC(10) = YM.PRINC.TEXT.PRINT
    YTRUE.1 = 0
    YM.TYPE.P1 = YM.SHED.KEY1
    IF YM.TYPE.P1 <> "" THEN
        YCOMP = "LMM.SCHEDULES_2_":YM.TYPE.P1
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.P1 = YFOR.FD
    END
    IF YM.TYPE.P1 <> "" THEN
        YTRUE.1 = 1
        YTRUE.2 = 0
        YM.PRIN.ACT = R.NEW(67)
        YM.PRIN.ACT.TEMP = YM.PRIN.ACT
        IF (YM.PRIN.ACT.TEMP < 1 OR YM.PRIN.ACT.TEMP > 9) THEN
            YTRUE.2 = 1
            YM.PRIN.ACT = R.NEW(67)
            YM.PRIN.ACT.DUM = YM.PRIN.ACT
        END
        IF NOT(YTRUE.2) THEN
            YM.PRIN.ACT = R.NEW(67)
            IF (YM.PRIN.ACT >= 1 AND YM.PRIN.ACT <= 9) THEN
                YTRUE.2 = 1
                YM.SUSP.ACT.NO.INT = YM.CCY
                YM1.SUSP.ACT.NO.INT = YM.SUSP.ACT.NO.INT
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.SUSP.ACT.NO.INT = YM.ADVICE.TEXT.KEY
                YM1.SUSP.ACT.NO.INT = YM1.SUSP.ACT.NO.INT : YM.SUSP.ACT.NO.INT
                YM.SUSP.ACT.NO.INT = YM1.SUSP.ACT.NO.INT
                YM.SUSP.ACT.NO = YM.SUSP.ACT.NO.INT
                YM1.SUSP.ACT.NO = YM.SUSP.ACT.NO
                YM.SUSP.ACT.NO = R.NEW(176)<1,1>
                YM1.SUSP.ACT.NO = YM1.SUSP.ACT.NO : YM.SUSP.ACT.NO
                YM.SUSP.ACT.NO = YM1.SUSP.ACT.NO
                YM.PRIN.ACT.DUM = YM.SUSP.ACT.NO
            END
        END
        IF NOT(YTRUE.2) THEN YM.PRIN.ACT.DUM = ""
        YM.PRIN.ACT.PRINT = YM.PRIN.ACT.DUM
    END
    IF NOT(YTRUE.1) THEN YM.PRIN.ACT.PRINT = ""
    YR.REC(11) = YM.PRIN.ACT.PRINT
    YM.CAT.LIT = R.NEW(11)
    IF YM.CAT.LIT <> "" THEN
        YCOMP = "CATEGORY_2_":YM.CAT.LIT
        YFORFIL = YF.CATEGORY
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
        YM.CAT.LIT = YFOR.FD
    END
    YR.REC(12) = YM.CAT.LIT
    YM.CUST.ID = R.NEW(1)
    YR.REC(13) = YM.CUST.ID
    YTRUE.1 = 0
    YM.TYPE.I1 = YM.SHED.KEY1
    IF YM.TYPE.I1 <> "" THEN
        YCOMP = "LMM.SCHEDULES_4_":YM.TYPE.I1
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.I1 = YFOR.FD
    END
    IF YM.TYPE.I1 <> "" THEN
        YTRUE.1 = 1
        YM.INT.LIT = "INTR : "
    END
    IF NOT(YTRUE.1) THEN YM.INT.LIT = ""
    YR.REC(14) = YM.INT.LIT
    YTRUE.1 = 0
    YM.TYPE.I1 = YM.SHED.KEY1
    IF YM.TYPE.I1 <> "" THEN
        YCOMP = "LMM.SCHEDULES_4_":YM.TYPE.I1
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.I1 = YFOR.FD
    END
    IF YM.TYPE.I1 <> "" THEN
        YTRUE.1 = 1
        YTRUE.2 = 0
        YM.INT.PAYMT.METH = R.NEW(15)
        YM.CONTRACT.STATUS = R.NEW(90)
        YM.TODAYS.GREGDATE = R.NEW(250)
        IF YM.TODAYS.GREGDATE <> "" THEN
            YCOMP = "DATES_1_":YM.TODAYS.GREGDATE
            YFORFIL = YF.DATES
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.TODAYS.GREGDATE = YFOR.FD
        END
        YM.ACCBAL.KEY = YM.CONTRACT.NO
        YM1.ACCBAL.KEY = YM.ACCBAL.KEY
        YM.ACCBAL.KEY = "00"
        YM1.ACCBAL.KEY = YM1.ACCBAL.KEY : YM.ACCBAL.KEY
        YM.ACCBAL.KEY = YM1.ACCBAL.KEY
        YM.INT.START.DATE = YM.ACCBAL.KEY
        IF YM.INT.START.DATE <> "" THEN
            YCOMP = "LMM.ACCOUNT.BALANCES_51_":YM.INT.START.DATE
            YFORFIL = YF.LMM.ACCOUNT.BALANCES
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.START.DATE = YFOR.FD
        END
        IF (YM.INT.PAYMT.METH = 1) OR ((YM.INT.PAYMT.METH = 2) AND (YM.CONTRACT.STATUS = "FWD" OR YM.INT.START.DATE = YM.TODAYS.GREGDATE)) THEN
            YTRUE.2 = 1
            YM.INT.AMT.DUM = R.NEW(24)
        END
        IF NOT(YTRUE.2) THEN
            YM.INT.PAYMT.METH = R.NEW(15)
            YM.CONTRACT.STATUS = R.NEW(90)
            YM.TODAYS.GREGDATE = R.NEW(250)
            IF YM.TODAYS.GREGDATE <> "" THEN
                YCOMP = "DATES_1_":YM.TODAYS.GREGDATE
                YFORFIL = YF.DATES
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.TODAYS.GREGDATE = YFOR.FD
            END
            YM.ACCBAL.KEY = YM.CONTRACT.NO
            YM1.ACCBAL.KEY = YM.ACCBAL.KEY
            YM.ACCBAL.KEY = "00"
            YM1.ACCBAL.KEY = YM1.ACCBAL.KEY : YM.ACCBAL.KEY
            YM.ACCBAL.KEY = YM1.ACCBAL.KEY
            YM.INT.START.DATE = YM.ACCBAL.KEY
            IF YM.INT.START.DATE <> "" THEN
                YCOMP = "LMM.ACCOUNT.BALANCES_51_":YM.INT.START.DATE
                YFORFIL = YF.LMM.ACCOUNT.BALANCES
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.INT.START.DATE = YFOR.FD
            END
            IF (YM.INT.PAYMT.METH = 2) AND (YM.CONTRACT.STATUS = "CUR" AND YM.INT.START.DATE <> YM.TODAYS.GREGDATE) THEN
                YTRUE.2 = 1
                YM.INT.AMT.DUM = " DISCOUNTED"
            END
        END
        IF NOT(YTRUE.2) THEN YM.INT.AMT.DUM = ""
        YM.INT.AMT.PRINT = YM.INT.AMT.DUM
    END
    IF NOT(YTRUE.1) THEN YM.INT.AMT.PRINT = ""
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
    IF YM.INT.AMT.PRINT <> "" THEN
        YM.INT.AMT.PRINT = TRIM(FMT(YM.INT.AMT.PRINT,"19R":YDEC))
    END
    YR.REC(15) = YM.INT.AMT.PRINT
    YTRUE.1 = 0
    YM.TYPE.I1 = YM.SHED.KEY1
    IF YM.TYPE.I1 <> "" THEN
        YCOMP = "LMM.SCHEDULES_4_":YM.TYPE.I1
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.I1 = YFOR.FD
    END
    IF YM.TYPE.I1 <> "" THEN
        YTRUE.1 = 1
        YTRUE.2 = 0
        YM.INT.ACT = R.NEW(72)
        IF YM.INT.ACT = 1 THEN
            YTRUE.2 = 1
            YTRUE.3 = 0
            YM.CAT.CD = R.NEW(11)
            YM.VAL.JULDATE = ID.NEW
            YM.DATE.DIFF = YM.VAL.JULDATE
            YM1.DATE.DIFF = YM.DATE.DIFF
            YM.TODAYS.DATE = R.NEW(250)
            IF YM.TODAYS.DATE <> "" THEN
                YCOMP = "DATES_14_":YM.TODAYS.DATE
                YFORFIL = YF.DATES
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.TODAYS.DATE = YFOR.FD
            END
            YM.DATE.DIFF = YM.TODAYS.DATE
            IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
            END
            YM.DATE.DIFF = YM1.DATE.DIFF
            IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                YTRUE.3 = 1
                YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
            END
            IF NOT(YTRUE.3) THEN
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                END
            END
            IF NOT(YTRUE.3) THEN
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                END
            END
            IF NOT(YTRUE.3) THEN
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                END
            END
            IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
            YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
            YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
            IF YM.ADVICE.TEXT.KEY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.ADVICE.TEXT.KEY = YFOR.FD
            END
            YM.TEXT1 = YM.ADVICE.TEXT.KEY
            IF YM.TEXT1 <> "" THEN
                YCOMP = "LMM.TEXT_1_":YM.TEXT1
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT1 = YFOR.FD
            END
            YM.INT.TEXT = YM.TEXT1
        END
        IF NOT(YTRUE.2) THEN
            YM.INT.ACT = R.NEW(72)
            IF YM.INT.ACT = 2 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT2 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT2 <> "" THEN
                    YCOMP = "LMM.TEXT_2_":YM.TEXT2
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT2 = YFOR.FD
                END
                YM.INT.TEXT = YM.TEXT2
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.INT.ACT = R.NEW(72)
            IF YM.INT.ACT = 3 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT3 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT3 <> "" THEN
                    YCOMP = "LMM.TEXT_3_":YM.TEXT3
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT3 = YFOR.FD
                END
                YM.INT.TEXT = YM.TEXT3
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.INT.ACT = R.NEW(72)
            IF YM.INT.ACT = 4 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT4 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT4 <> "" THEN
                    YCOMP = "LMM.TEXT_4_":YM.TEXT4
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT4 = YFOR.FD
                END
                YM.INT.TEXT = YM.TEXT4
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.INT.ACT = R.NEW(72)
            IF YM.INT.ACT = 5 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT5 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT5 <> "" THEN
                    YCOMP = "LMM.TEXT_5_":YM.TEXT5
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT5 = YFOR.FD
                END
                YM.INT.TEXT = YM.TEXT5
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.INT.ACT = R.NEW(72)
            IF YM.INT.ACT = 6 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT6 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT6 <> "" THEN
                    YCOMP = "LMM.TEXT_6_":YM.TEXT6
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT6 = YFOR.FD
                END
                YM.INT.TEXT = YM.TEXT6
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.INT.ACT = R.NEW(72)
            IF YM.INT.ACT = 7 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT7 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT7 <> "" THEN
                    YCOMP = "LMM.TEXT_7_":YM.TEXT7
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT7 = YFOR.FD
                END
                YM.INT.TEXT = YM.TEXT7
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.INT.ACT = R.NEW(72)
            IF YM.INT.ACT = 8 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT8 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT8 <> "" THEN
                    YCOMP = "LMM.TEXT_8_":YM.TEXT8
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT8 = YFOR.FD
                END
                YM.INT.TEXT = YM.TEXT8
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.INT.ACT = R.NEW(72)
            IF YM.INT.ACT = 9 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT9 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT9 <> "" THEN
                    YCOMP = "LMM.TEXT_9_":YM.TEXT9
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT9 = YFOR.FD
                END
                YM.INT.TEXT = YM.TEXT9
            END
        END
        IF NOT(YTRUE.2) THEN YM.INT.TEXT = ""
        YM.INT.TEXT.PRINT = YM.INT.TEXT
    END
    IF NOT(YTRUE.1) THEN YM.INT.TEXT.PRINT = ""
    YR.REC(16) = YM.INT.TEXT.PRINT
    YTRUE.1 = 0
    YM.TYPE.I1 = YM.SHED.KEY1
    IF YM.TYPE.I1 <> "" THEN
        YCOMP = "LMM.SCHEDULES_4_":YM.TYPE.I1
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.I1 = YFOR.FD
    END
    IF YM.TYPE.I1 <> "" THEN
        YTRUE.1 = 1
        YTRUE.2 = 0
        YM.INT.ACT = R.NEW(72)
        YM.INT.ACT.TEMP = YM.INT.ACT
        IF (YM.INT.ACT.TEMP < 1 OR YM.INT.ACT.TEMP > 9) THEN
            YTRUE.2 = 1
            YM.INT.ACT = R.NEW(72)
            YM.INT.ACT.DUM = YM.INT.ACT
        END
        IF NOT(YTRUE.2) THEN
            YM.INT.ACT = R.NEW(72)
            IF (YM.INT.ACT >= 1 AND YM.INT.ACT <= 9) THEN
                YTRUE.2 = 1
                YM.SUSP.ACT.NO.INT = YM.CCY
                YM1.SUSP.ACT.NO.INT = YM.SUSP.ACT.NO.INT
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.SUSP.ACT.NO.INT = YM.ADVICE.TEXT.KEY
                YM1.SUSP.ACT.NO.INT = YM1.SUSP.ACT.NO.INT : YM.SUSP.ACT.NO.INT
                YM.SUSP.ACT.NO.INT = YM1.SUSP.ACT.NO.INT
                YM.SUSP.ACT.NO = YM.SUSP.ACT.NO.INT
                YM1.SUSP.ACT.NO = YM.SUSP.ACT.NO
                YM.SUSP.ACT.NO = R.NEW(176)<1,1>
                YM1.SUSP.ACT.NO = YM1.SUSP.ACT.NO : YM.SUSP.ACT.NO
                YM.SUSP.ACT.NO = YM1.SUSP.ACT.NO
                YM.INT.ACT.DUM = YM.SUSP.ACT.NO
            END
        END
        IF NOT(YTRUE.2) THEN YM.INT.ACT.DUM = ""
        YM.INT.ACT.PRINT = YM.INT.ACT.DUM
    END
    IF NOT(YTRUE.1) THEN YM.INT.ACT.PRINT = ""
    YR.REC(17) = YM.INT.ACT.PRINT
    YTRUE.1 = 0
    YM.MAT.DATE = R.NEW(7)
    YM.MAT.DATE.CHECK = YM.MAT.DATE
    IF YM.MAT.DATE.CHECK > 999 THEN
        YTRUE.1 = 1
        YM.MAT.DATE = R.NEW(7)
        YM.MAT.DATE.DUMMY = YM.MAT.DATE
    END
    IF NOT(YTRUE.1) THEN
        YM.MAT.DATE = R.NEW(7)
        YM.MAT.DATE.CHECK = YM.MAT.DATE
        IF YM.MAT.DATE.CHECK <= 999 THEN
            YTRUE.1 = 1
            YM.MAT.DATE = R.NEW(7)
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
    YR.REC(18) = YM.MAT.DATE.PRINT
    YM.COLON = ":"
    YR.REC(19) = YM.COLON
    YM.VAL.DATE = R.NEW(6)
    YR.REC(20) = YM.VAL.DATE
    YTRUE.1 = 0
    YM.TYPE.C1 = YM.SHED.KEY1
    IF YM.TYPE.C1 <> "" THEN
        YCOMP = "LMM.SCHEDULES_8_":YM.TYPE.C1
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.C1 = YFOR.FD
    END
    IF YM.TYPE.C1 <> "" THEN
        YTRUE.1 = 1
        YM.COM.LIT = "COMM : "
    END
    IF NOT(YTRUE.1) THEN YM.COM.LIT = ""
    YR.REC(21) = YM.COM.LIT
    YTRUE.1 = 0
    YM.TYPE.C1 = YM.SHED.KEY1
    IF YM.TYPE.C1 <> "" THEN
        YCOMP = "LMM.SCHEDULES_8_":YM.TYPE.C1
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.C1 = YFOR.FD
    END
    IF YM.TYPE.C1 <> "" THEN
        YTRUE.1 = 1
        YTRUE.2 = 0
        YM.COMM.PAYMT.METH = R.NEW(35)
        YM.CONTRACT.STATUS = R.NEW(90)
        YM.TODAYS.GREGDATE = R.NEW(250)
        IF YM.TODAYS.GREGDATE <> "" THEN
            YCOMP = "DATES_1_":YM.TODAYS.GREGDATE
            YFORFIL = YF.DATES
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.TODAYS.GREGDATE = YFOR.FD
        END
        YM.ACCBAL.KEY = YM.CONTRACT.NO
        YM1.ACCBAL.KEY = YM.ACCBAL.KEY
        YM.ACCBAL.KEY = "00"
        YM1.ACCBAL.KEY = YM1.ACCBAL.KEY : YM.ACCBAL.KEY
        YM.ACCBAL.KEY = YM1.ACCBAL.KEY
        YM.COM.START.DATE = YM.ACCBAL.KEY
        IF YM.COM.START.DATE <> "" THEN
            YCOMP = "LMM.ACCOUNT.BALANCES_66_":YM.COM.START.DATE
            YFORFIL = YF.LMM.ACCOUNT.BALANCES
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.START.DATE = YFOR.FD
        END
        IF (YM.COMM.PAYMT.METH = 1) OR ((YM.COMM.PAYMT.METH = 2) AND (YM.CONTRACT.STATUS = "FWD" OR YM.COM.START.DATE = YM.TODAYS.GREGDATE)) THEN
            YTRUE.2 = 1
            YM.COM.AMT.DUM = R.NEW(37)
        END
        IF NOT(YTRUE.2) THEN
            YM.COMM.PAYMT.METH = R.NEW(35)
            YM.CONTRACT.STATUS = R.NEW(90)
            YM.TODAYS.GREGDATE = R.NEW(250)
            IF YM.TODAYS.GREGDATE <> "" THEN
                YCOMP = "DATES_1_":YM.TODAYS.GREGDATE
                YFORFIL = YF.DATES
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.TODAYS.GREGDATE = YFOR.FD
            END
            YM.ACCBAL.KEY = YM.CONTRACT.NO
            YM1.ACCBAL.KEY = YM.ACCBAL.KEY
            YM.ACCBAL.KEY = "00"
            YM1.ACCBAL.KEY = YM1.ACCBAL.KEY : YM.ACCBAL.KEY
            YM.ACCBAL.KEY = YM1.ACCBAL.KEY
            YM.COM.START.DATE = YM.ACCBAL.KEY
            IF YM.COM.START.DATE <> "" THEN
                YCOMP = "LMM.ACCOUNT.BALANCES_66_":YM.COM.START.DATE
                YFORFIL = YF.LMM.ACCOUNT.BALANCES
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.COM.START.DATE = YFOR.FD
            END
            IF (YM.COMM.PAYMT.METH = 2) AND (YM.CONTRACT.STATUS = "CUR" AND YM.COM.START.DATE <> YM.TODAYS.GREGDATE) THEN
                YTRUE.2 = 1
                YM.COM.AMT.DUM = " DISCOUNTED"
            END
        END
        IF NOT(YTRUE.2) THEN YM.COM.AMT.DUM = ""
        YM.COM.AMT.PRINT = YM.COM.AMT.DUM
    END
    IF NOT(YTRUE.1) THEN YM.COM.AMT.PRINT = ""
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
    IF YM.COM.AMT.PRINT <> "" THEN
        YM.COM.AMT.PRINT = TRIM(FMT(YM.COM.AMT.PRINT,"19R":YDEC))
    END
    YR.REC(22) = YM.COM.AMT.PRINT
    YTRUE.1 = 0
    YM.TYPE.C1 = YM.SHED.KEY1
    IF YM.TYPE.C1 <> "" THEN
        YCOMP = "LMM.SCHEDULES_8_":YM.TYPE.C1
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.C1 = YFOR.FD
    END
    IF YM.TYPE.C1 <> "" THEN
        YTRUE.1 = 1
        YTRUE.2 = 0
        YM.COM.ACT = R.NEW(77)
        IF YM.COM.ACT = 1 THEN
            YTRUE.2 = 1
            YTRUE.3 = 0
            YM.CAT.CD = R.NEW(11)
            YM.VAL.JULDATE = ID.NEW
            YM.DATE.DIFF = YM.VAL.JULDATE
            YM1.DATE.DIFF = YM.DATE.DIFF
            YM.TODAYS.DATE = R.NEW(250)
            IF YM.TODAYS.DATE <> "" THEN
                YCOMP = "DATES_14_":YM.TODAYS.DATE
                YFORFIL = YF.DATES
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.TODAYS.DATE = YFOR.FD
            END
            YM.DATE.DIFF = YM.TODAYS.DATE
            IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
            END
            YM.DATE.DIFF = YM1.DATE.DIFF
            IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                YTRUE.3 = 1
                YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
            END
            IF NOT(YTRUE.3) THEN
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                END
            END
            IF NOT(YTRUE.3) THEN
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                END
            END
            IF NOT(YTRUE.3) THEN
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                END
            END
            IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
            YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
            YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
            IF YM.ADVICE.TEXT.KEY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.ADVICE.TEXT.KEY = YFOR.FD
            END
            YM.TEXT1 = YM.ADVICE.TEXT.KEY
            IF YM.TEXT1 <> "" THEN
                YCOMP = "LMM.TEXT_1_":YM.TEXT1
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT1 = YFOR.FD
            END
            YM.COM.TEXT = YM.TEXT1
        END
        IF NOT(YTRUE.2) THEN
            YM.COM.ACT = R.NEW(77)
            IF YM.COM.ACT = 2 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT2 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT2 <> "" THEN
                    YCOMP = "LMM.TEXT_2_":YM.TEXT2
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT2 = YFOR.FD
                END
                YM.COM.TEXT = YM.TEXT2
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.COM.ACT = R.NEW(77)
            IF YM.COM.ACT = 3 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT3 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT3 <> "" THEN
                    YCOMP = "LMM.TEXT_3_":YM.TEXT3
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT3 = YFOR.FD
                END
                YM.COM.TEXT = YM.TEXT3
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.COM.ACT = R.NEW(77)
            IF YM.COM.ACT = 4 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT4 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT4 <> "" THEN
                    YCOMP = "LMM.TEXT_4_":YM.TEXT4
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT4 = YFOR.FD
                END
                YM.COM.TEXT = YM.TEXT4
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.COM.ACT = R.NEW(77)
            IF YM.COM.ACT = 5 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT5 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT5 <> "" THEN
                    YCOMP = "LMM.TEXT_5_":YM.TEXT5
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT5 = YFOR.FD
                END
                YM.COM.TEXT = YM.TEXT5
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.COM.ACT = R.NEW(77)
            IF YM.COM.ACT = 6 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT6 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT6 <> "" THEN
                    YCOMP = "LMM.TEXT_6_":YM.TEXT6
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT6 = YFOR.FD
                END
                YM.COM.TEXT = YM.TEXT6
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.COM.ACT = R.NEW(77)
            IF YM.COM.ACT = 7 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT7 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT7 <> "" THEN
                    YCOMP = "LMM.TEXT_7_":YM.TEXT7
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT7 = YFOR.FD
                END
                YM.COM.TEXT = YM.TEXT7
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.COM.ACT = R.NEW(77)
            IF YM.COM.ACT = 8 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT8 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT8 <> "" THEN
                    YCOMP = "LMM.TEXT_8_":YM.TEXT8
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT8 = YFOR.FD
                END
                YM.COM.TEXT = YM.TEXT8
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.COM.ACT = R.NEW(77)
            IF YM.COM.ACT = 9 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT9 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT9 <> "" THEN
                    YCOMP = "LMM.TEXT_9_":YM.TEXT9
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT9 = YFOR.FD
                END
                YM.COM.TEXT = YM.TEXT9
            END
        END
        IF NOT(YTRUE.2) THEN YM.COM.TEXT = ""
        YM.COM.TEXT.PRINT = YM.COM.TEXT
    END
    IF NOT(YTRUE.1) THEN YM.COM.TEXT.PRINT = ""
    YR.REC(23) = YM.COM.TEXT.PRINT
    YTRUE.1 = 0
    YM.TYPE.C1 = YM.SHED.KEY1
    IF YM.TYPE.C1 <> "" THEN
        YCOMP = "LMM.SCHEDULES_8_":YM.TYPE.C1
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.C1 = YFOR.FD
    END
    IF YM.TYPE.C1 <> "" THEN
        YTRUE.1 = 1
        YTRUE.2 = 0
        YM.COM.ACT = R.NEW(77)
        YM.COM.ACT.TEMP = YM.COM.ACT
        IF (YM.COM.ACT.TEMP < 1 OR YM.COM.ACT.TEMP > 9) THEN
            YTRUE.2 = 1
            YM.COM.ACT = R.NEW(77)
            YM.COM.ACT.DUM = YM.COM.ACT
        END
        IF NOT(YTRUE.2) THEN
            YM.COM.ACT = R.NEW(77)
            IF (YM.COM.ACT >= 1 AND YM.COM.ACT <= 9) THEN
                YTRUE.2 = 1
                YM.SUSP.ACT.NO.INT = YM.CCY
                YM1.SUSP.ACT.NO.INT = YM.SUSP.ACT.NO.INT
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.SUSP.ACT.NO.INT = YM.ADVICE.TEXT.KEY
                YM1.SUSP.ACT.NO.INT = YM1.SUSP.ACT.NO.INT : YM.SUSP.ACT.NO.INT
                YM.SUSP.ACT.NO.INT = YM1.SUSP.ACT.NO.INT
                YM.SUSP.ACT.NO = YM.SUSP.ACT.NO.INT
                YM1.SUSP.ACT.NO = YM.SUSP.ACT.NO
                YM.SUSP.ACT.NO = R.NEW(176)<1,1>
                YM1.SUSP.ACT.NO = YM1.SUSP.ACT.NO : YM.SUSP.ACT.NO
                YM.SUSP.ACT.NO = YM1.SUSP.ACT.NO
                YM.COM.ACT.DUM = YM.SUSP.ACT.NO
            END
        END
        IF NOT(YTRUE.2) THEN YM.COM.ACT.DUM = ""
        YM.COM.ACT.PRINT = YM.COM.ACT.DUM
    END
    IF NOT(YTRUE.1) THEN YM.COM.ACT.PRINT = ""
    YR.REC(24) = YM.COM.ACT.PRINT
    YTRUE.1 = 0
    YM.TYPE.F1 = YM.SHED.KEY1
    IF YM.TYPE.F1 <> "" THEN
        YCOMP = "LMM.SCHEDULES_12_":YM.TYPE.F1
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.F1 = YFOR.FD
    END
    IF YM.TYPE.F1 <> "" THEN
        YTRUE.1 = 1
        YM.FEE.LIT = "FEES : "
    END
    IF NOT(YTRUE.1) THEN YM.FEE.LIT = ""
    YR.REC(25) = YM.FEE.LIT
    YTRUE.1 = 0
    YM.TYPE.F1 = YM.SHED.KEY1
    IF YM.TYPE.F1 <> "" THEN
        YCOMP = "LMM.SCHEDULES_12_":YM.TYPE.F1
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.F1 = YFOR.FD
    END
    IF YM.TYPE.F1 <> "" THEN
        YTRUE.1 = 1
        YM.FILE.NAME = "F.LMM.SCHEDULES"
        YM176.GOSUB = YM.FILE.NAME
        YM.SHED.KEY.PARAM = YM.SHED.KEY1
        YM177.GOSUB = YM.SHED.KEY.PARAM
        YM.FIELD.NO = "14"
        YM178.GOSUB = YM.FIELD.NO
        YM.OP.CODE = "SUM"
        YM179.GOSUB = YM.OP.CODE
        YM.FEE.AMOUNT = ""
        YM180.GOSUB = YM.FEE.AMOUNT
        CALL @LD.EXTRCT.VAL (YM176.GOSUB, YM177.GOSUB, YM178.GOSUB, YM179.GOSUB, YM180.GOSUB)
        YM.FILE.NAME = YM176.GOSUB
        YM.SHED.KEY.PARAM = YM177.GOSUB
        YM.FIELD.NO = YM178.GOSUB
        YM.OP.CODE = YM179.GOSUB
        YM.FEE.AMOUNT = YM180.GOSUB
        YM.FEE.AMT.PRINT = YM.FEE.AMOUNT
    END
    IF NOT(YTRUE.1) THEN YM.FEE.AMT.PRINT = ""
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
    IF YM.FEE.AMT.PRINT <> "" THEN
        YM.FEE.AMT.PRINT = TRIM(FMT(YM.FEE.AMT.PRINT,"19R":YDEC))
    END
    YR.REC(26) = YM.FEE.AMT.PRINT
    YTRUE.1 = 0
    YM.TYPE.F1 = YM.SHED.KEY1
    IF YM.TYPE.F1 <> "" THEN
        YCOMP = "LMM.SCHEDULES_12_":YM.TYPE.F1
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.F1 = YFOR.FD
    END
    IF YM.TYPE.F1 <> "" THEN
        YTRUE.1 = 1
        YTRUE.2 = 0
        YM.FEE.ACT = R.NEW(78)
        IF YM.FEE.ACT = 1 THEN
            YTRUE.2 = 1
            YTRUE.3 = 0
            YM.CAT.CD = R.NEW(11)
            YM.VAL.JULDATE = ID.NEW
            YM.DATE.DIFF = YM.VAL.JULDATE
            YM1.DATE.DIFF = YM.DATE.DIFF
            YM.TODAYS.DATE = R.NEW(250)
            IF YM.TODAYS.DATE <> "" THEN
                YCOMP = "DATES_14_":YM.TODAYS.DATE
                YFORFIL = YF.DATES
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.TODAYS.DATE = YFOR.FD
            END
            YM.DATE.DIFF = YM.TODAYS.DATE
            IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
            END
            YM.DATE.DIFF = YM1.DATE.DIFF
            IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                YTRUE.3 = 1
                YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
            END
            IF NOT(YTRUE.3) THEN
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                END
            END
            IF NOT(YTRUE.3) THEN
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                END
            END
            IF NOT(YTRUE.3) THEN
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                END
            END
            IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
            YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
            YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
            IF YM.ADVICE.TEXT.KEY <> "" THEN
                YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                YFORFIL = YF.ACCOUNT.CLASS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.ADVICE.TEXT.KEY = YFOR.FD
            END
            YM.TEXT1 = YM.ADVICE.TEXT.KEY
            IF YM.TEXT1 <> "" THEN
                YCOMP = "LMM.TEXT_1_":YM.TEXT1
                YFORFIL = YF.LMM.TEXT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.TEXT1 = YFOR.FD
            END
            YM.FEE.TEXT = YM.TEXT1
        END
        IF NOT(YTRUE.2) THEN
            YM.FEE.ACT = R.NEW(78)
            IF YM.FEE.ACT = 2 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT2 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT2 <> "" THEN
                    YCOMP = "LMM.TEXT_2_":YM.TEXT2
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT2 = YFOR.FD
                END
                YM.FEE.TEXT = YM.TEXT2
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.FEE.ACT = R.NEW(78)
            IF YM.FEE.ACT = 3 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT3 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT3 <> "" THEN
                    YCOMP = "LMM.TEXT_3_":YM.TEXT3
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT3 = YFOR.FD
                END
                YM.FEE.TEXT = YM.TEXT3
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.FEE.ACT = R.NEW(78)
            IF YM.FEE.ACT = 4 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT4 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT4 <> "" THEN
                    YCOMP = "LMM.TEXT_4_":YM.TEXT4
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT4 = YFOR.FD
                END
                YM.FEE.TEXT = YM.TEXT4
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.FEE.ACT = R.NEW(78)
            IF YM.FEE.ACT = 5 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT5 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT5 <> "" THEN
                    YCOMP = "LMM.TEXT_5_":YM.TEXT5
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT5 = YFOR.FD
                END
                YM.FEE.TEXT = YM.TEXT5
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.FEE.ACT = R.NEW(78)
            IF YM.FEE.ACT = 6 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT6 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT6 <> "" THEN
                    YCOMP = "LMM.TEXT_6_":YM.TEXT6
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT6 = YFOR.FD
                END
                YM.FEE.TEXT = YM.TEXT6
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.FEE.ACT = R.NEW(78)
            IF YM.FEE.ACT = 7 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT7 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT7 <> "" THEN
                    YCOMP = "LMM.TEXT_7_":YM.TEXT7
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT7 = YFOR.FD
                END
                YM.FEE.TEXT = YM.TEXT7
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.FEE.ACT = R.NEW(78)
            IF YM.FEE.ACT = 8 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT8 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT8 <> "" THEN
                    YCOMP = "LMM.TEXT_8_":YM.TEXT8
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT8 = YFOR.FD
                END
                YM.FEE.TEXT = YM.TEXT8
            END
        END
        IF NOT(YTRUE.2) THEN
            YM.FEE.ACT = R.NEW(78)
            IF YM.FEE.ACT = 9 THEN
                YTRUE.2 = 1
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.TEXT9 = YM.ADVICE.TEXT.KEY
                IF YM.TEXT9 <> "" THEN
                    YCOMP = "LMM.TEXT_9_":YM.TEXT9
                    YFORFIL = YF.LMM.TEXT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                    YM.TEXT9 = YFOR.FD
                END
                YM.FEE.TEXT = YM.TEXT9
            END
        END
        IF NOT(YTRUE.2) THEN YM.FEE.TEXT = ""
        YM.FEE.TEXT.PRINT = YM.FEE.TEXT
    END
    IF NOT(YTRUE.1) THEN YM.FEE.TEXT.PRINT = ""
    YR.REC(27) = YM.FEE.TEXT.PRINT
    YTRUE.1 = 0
    YM.TYPE.F1 = YM.SHED.KEY1
    IF YM.TYPE.F1 <> "" THEN
        YCOMP = "LMM.SCHEDULES_12_":YM.TYPE.F1
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.F1 = YFOR.FD
    END
    IF YM.TYPE.F1 <> "" THEN
        YTRUE.1 = 1
        YTRUE.2 = 0
        YM.FEE.ACT = R.NEW(78)
        YM.FEE.ACT.TEMP = YM.FEE.ACT
        IF (YM.FEE.ACT.TEMP < 1 OR YM.FEE.ACT.TEMP > 9) THEN
            YTRUE.2 = 1
            YM.FEE.ACT = R.NEW(78)
            YM.FEE.ACT.DUM = YM.FEE.ACT
        END
        IF NOT(YTRUE.2) THEN
            YM.FEE.ACT = R.NEW(78)
            IF (YM.FEE.ACT >= 1 AND YM.FEE.ACT <= 9) THEN
                YTRUE.2 = 1
                YM.SUSP.ACT.NO.INT = YM.CCY
                YM1.SUSP.ACT.NO.INT = YM.SUSP.ACT.NO.INT
                YTRUE.3 = 0
                YM.CAT.CD = R.NEW(11)
                YM.VAL.JULDATE = ID.NEW
                YM.DATE.DIFF = YM.VAL.JULDATE
                YM1.DATE.DIFF = YM.DATE.DIFF
                YM.TODAYS.DATE = R.NEW(250)
                IF YM.TODAYS.DATE <> "" THEN
                    YCOMP = "DATES_14_":YM.TODAYS.DATE
                    YFORFIL = YF.DATES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.TODAYS.DATE = YFOR.FD
                END
                YM.DATE.DIFF = YM.TODAYS.DATE
                IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                    YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                    IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                END
                YM.DATE.DIFF = YM1.DATE.DIFF
                IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF <= 0) THEN
                    YTRUE.3 = 1
                    YM.ACC.CLASS.KEY.DUM = "SUSPLMMMCR"
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21099)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21124))) AND (YM.DATE.DIFF <= 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21001 AND YM.CAT.CD <= 21029)) OR ((YM.CAT.CD >= 21045 AND YM.CAT.CD <= 21049))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMDR"
                    END
                END
                IF NOT(YTRUE.3) THEN
                    YM.CAT.CD = R.NEW(11)
                    YM.VAL.JULDATE = ID.NEW
                    YM.DATE.DIFF = YM.VAL.JULDATE
                    YM1.DATE.DIFF = YM.DATE.DIFF
                    YM.TODAYS.DATE = R.NEW(250)
                    IF YM.TODAYS.DATE <> "" THEN
                        YCOMP = "DATES_14_":YM.TODAYS.DATE
                        YFORFIL = YF.DATES
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.TODAYS.DATE = YFOR.FD
                    END
                    YM.DATE.DIFF = YM.TODAYS.DATE
                    IF NUM(YM1.DATE.DIFF) = NUMERIC THEN IF NUM(YM.DATE.DIFF) = NUMERIC THEN
                        YM1.DATE.DIFF = YM1.DATE.DIFF - YM.DATE.DIFF
                        IF YM1.DATE.DIFF = 0 THEN YM1.DATE.DIFF = ""
                    END
                    YM.DATE.DIFF = YM1.DATE.DIFF
                    IF (((YM.CAT.CD >= 21050 AND YM.CAT.CD <= 21074)) OR ((YM.CAT.CD >= 21090 AND YM.CAT.CD <= 21094)) OR ((YM.CAT.CD >= 21101 AND YM.CAT.CD <= 21119))) AND (YM.DATE.DIFF > 0) THEN
                        YTRUE.3 = 1
                        YM.ACC.CLASS.KEY.DUM = "SUSPLMMCR"
                    END
                END
                IF NOT(YTRUE.3) THEN YM.ACC.CLASS.KEY.DUM = ""
                YM.ACC.CLASS.KEY = YM.ACC.CLASS.KEY.DUM
                YM.ADVICE.TEXT.KEY = YM.ACC.CLASS.KEY
                IF YM.ADVICE.TEXT.KEY <> "" THEN
                    YCOMP = "ACCOUNT.CLASS_3.1_":YM.ADVICE.TEXT.KEY
                    YFORFIL = YF.ACCOUNT.CLASS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.ADVICE.TEXT.KEY = YFOR.FD
                END
                YM.SUSP.ACT.NO.INT = YM.ADVICE.TEXT.KEY
                YM1.SUSP.ACT.NO.INT = YM1.SUSP.ACT.NO.INT : YM.SUSP.ACT.NO.INT
                YM.SUSP.ACT.NO.INT = YM1.SUSP.ACT.NO.INT
                YM.SUSP.ACT.NO = YM.SUSP.ACT.NO.INT
                YM1.SUSP.ACT.NO = YM.SUSP.ACT.NO
                YM.SUSP.ACT.NO = R.NEW(176)<1,1>
                YM1.SUSP.ACT.NO = YM1.SUSP.ACT.NO : YM.SUSP.ACT.NO
                YM.SUSP.ACT.NO = YM1.SUSP.ACT.NO
                YM.FEE.ACT.DUM = YM.SUSP.ACT.NO
            END
        END
        IF NOT(YTRUE.2) THEN YM.FEE.ACT.DUM = ""
        YM.FEE.ACT.PRINT = YM.FEE.ACT.DUM
    END
    IF NOT(YTRUE.1) THEN YM.FEE.ACT.PRINT = ""
    YR.REC(28) = YM.FEE.ACT.PRINT
    YM.BLANK.LINE1 = "."
    YR.REC(29) = YM.BLANK.LINE1
    YTRUE.1 = 0
    YM.SHED.DATES.KEY = YM.CONTRACT.NO
    YM1.SHED.DATES.KEY = YM.SHED.DATES.KEY
    YM.SHED.DATES.KEY = "00"
    YM1.SHED.DATES.KEY = YM1.SHED.DATES.KEY : YM.SHED.DATES.KEY
    YM.SHED.DATES.KEY = YM1.SHED.DATES.KEY
    YM.DATES.KEY.PARAM2 = YM.SHED.DATES.KEY
    YM28.GOSUB = YM.DATES.KEY.PARAM2
    YM.PREVIOUS.DATE2 = YM.EVENT.DATE.DUMMY1
    YM29.GOSUB = YM.PREVIOUS.DATE2
    YM.EVENT.DATE2 = ""
    YM30.GOSUB = YM.EVENT.DATE2
    YM.EVENT.DATE.NO2 = "2"
    YM31.GOSUB = YM.EVENT.DATE.NO2
    CALL @LD.EXTRCT.SUBSEQ.DT (YM28.GOSUB, YM29.GOSUB, YM30.GOSUB, YM31.GOSUB)
    YM.DATES.KEY.PARAM2 = YM28.GOSUB
    YM.PREVIOUS.DATE2 = YM29.GOSUB
    YM.EVENT.DATE2 = YM30.GOSUB
    YM.EVENT.DATE.NO2 = YM31.GOSUB
    IF (YM.EVENT.DATE2 <> "") THEN
        YTRUE.1 = 1
        YM.END.OF.DATE1.LIT1 = "*********************************"
    END
    IF NOT(YTRUE.1) THEN YM.END.OF.DATE1.LIT1 = ""
    YR.REC(30) = YM.END.OF.DATE1.LIT1
    YTRUE.1 = 0
    IF (YM.EVENT.DATE2 <> "") THEN
        YTRUE.1 = 1
        YM.END.OF.DATE1.LIT2 = "*********************************"
    END
    IF NOT(YTRUE.1) THEN YM.END.OF.DATE1.LIT2 = ""
    YR.REC(31) = YM.END.OF.DATE1.LIT2
    YTRUE.1 = 0
    IF (YM.EVENT.DATE2 <> "") THEN
        YTRUE.1 = 1
        YM.END.OF.DATE1.LIT3 = "******************"
    END
    IF NOT(YTRUE.1) THEN YM.END.OF.DATE1.LIT3 = ""
    YR.REC(32) = YM.END.OF.DATE1.LIT3
    YM.BLANK.LINE2 = "."
    YR.REC(33) = YM.BLANK.LINE2
    YTRUE.1 = 0
    IF (YM.EVENT.DATE2 <> "") THEN
        YTRUE.1 = 1
        YM.EVENT.DATE2.LIT = "EVENT DATE 2 : "
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.DATE2.LIT = ""
    YR.REC(34) = YM.EVENT.DATE2.LIT
    YTRUE.1 = 0
    IF (YM.EVENT.DATE2 <> "") THEN
        YTRUE.1 = 1
        YM.DATE.REQD2 = ""
        YM33.GOSUB = YM.DATE.REQD2
        YM.EVENT.DATE.DUMMY2 = YM.EVENT.DATE2
        YM.JUL.EVENT.DATE2 = YM.EVENT.DATE.DUMMY2
        YM34.GOSUB = YM.JUL.EVENT.DATE2
        CALL @JULDATE (YM33.GOSUB, YM34.GOSUB)
        YM.DATE.REQD2 = YM33.GOSUB
        YM.JUL.EVENT.DATE2 = YM34.GOSUB
        YM.DATE.PRINT2 = YM.DATE.REQD2
    END
    IF NOT(YTRUE.1) THEN YM.DATE.PRINT2 = ""
    YR.REC(35) = YM.DATE.PRINT2
    YTRUE.1 = 0
    IF (YM.EVENT.DATE2 <> "") THEN
        YTRUE.1 = 1
        YM.EVENT.LIT = "EVENT : "
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.LIT = ""
    YR.REC(36) = YM.EVENT.LIT
    YTRUE.1 = 0
    YM.SHED.KEY.INT2 = ID.NEW
    YM1.SHED.KEY.INT2 = YM.SHED.KEY.INT2
    YM.SHED.KEY.INT2 = YM.EVENT.DATE2
    YM.SHED.KEY.INT2 = FMT(YM.SHED.KEY.INT2,"7L"); YM.SHED.KEY.INT2 = YM.SHED.KEY.INT2[1,7]
    YM1.SHED.KEY.INT2 = YM1.SHED.KEY.INT2 : YM.SHED.KEY.INT2
    YM.SHED.KEY.INT2 = YM1.SHED.KEY.INT2
    YM.SHED.KEY2 = YM.SHED.KEY.INT2
    YM1.SHED.KEY2 = YM.SHED.KEY2
    YM.SHED.KEY2 = "00"
    YM1.SHED.KEY2 = YM1.SHED.KEY2 : YM.SHED.KEY2
    YM.SHED.KEY2 = YM1.SHED.KEY2
    YM.TYPE.P2 = YM.SHED.KEY2
    IF YM.TYPE.P2 <> "" THEN
        YCOMP = "LMM.SCHEDULES_2_":YM.TYPE.P2
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.P2 = YFOR.FD
    END
    IF YM.TYPE.P2 <> "" THEN
        YTRUE.1 = 1
        YM.EVENT.P2 = "P"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.P2 = ""
    YR.REC(37) = YM.EVENT.P2
    YTRUE.1 = 0
    YM.SHED.KEY.INT2 = ID.NEW
    YM1.SHED.KEY.INT2 = YM.SHED.KEY.INT2
    YM.SHED.KEY.INT2 = YM.EVENT.DATE2
    YM.SHED.KEY.INT2 = FMT(YM.SHED.KEY.INT2,"7L"); YM.SHED.KEY.INT2 = YM.SHED.KEY.INT2[1,7]
    YM1.SHED.KEY.INT2 = YM1.SHED.KEY.INT2 : YM.SHED.KEY.INT2
    YM.SHED.KEY.INT2 = YM1.SHED.KEY.INT2
    YM.SHED.KEY2 = YM.SHED.KEY.INT2
    YM1.SHED.KEY2 = YM.SHED.KEY2
    YM.SHED.KEY2 = "00"
    YM1.SHED.KEY2 = YM1.SHED.KEY2 : YM.SHED.KEY2
    YM.SHED.KEY2 = YM1.SHED.KEY2
    YM.TYPE.I2 = YM.SHED.KEY2
    IF YM.TYPE.I2 <> "" THEN
        YCOMP = "LMM.SCHEDULES_4_":YM.TYPE.I2
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.I2 = YFOR.FD
    END
    IF YM.TYPE.I2 <> "" THEN
        YTRUE.1 = 1
        YM.EVENT.I2 = "I"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.I2 = ""
    YR.REC(38) = YM.EVENT.I2
    YTRUE.1 = 0
    YM.SHED.KEY.INT2 = ID.NEW
    YM1.SHED.KEY.INT2 = YM.SHED.KEY.INT2
    YM.SHED.KEY.INT2 = YM.EVENT.DATE2
    YM.SHED.KEY.INT2 = FMT(YM.SHED.KEY.INT2,"7L"); YM.SHED.KEY.INT2 = YM.SHED.KEY.INT2[1,7]
    YM1.SHED.KEY.INT2 = YM1.SHED.KEY.INT2 : YM.SHED.KEY.INT2
    YM.SHED.KEY.INT2 = YM1.SHED.KEY.INT2
    YM.SHED.KEY2 = YM.SHED.KEY.INT2
    YM1.SHED.KEY2 = YM.SHED.KEY2
    YM.SHED.KEY2 = "00"
    YM1.SHED.KEY2 = YM1.SHED.KEY2 : YM.SHED.KEY2
    YM.SHED.KEY2 = YM1.SHED.KEY2
    YM.TYPE.C2 = YM.SHED.KEY2
    IF YM.TYPE.C2 <> "" THEN
        YCOMP = "LMM.SCHEDULES_8_":YM.TYPE.C2
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.C2 = YFOR.FD
    END
    IF YM.TYPE.C2 <> "" THEN
        YTRUE.1 = 1
        YM.EVENT.C2 = "C"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.C2 = ""
    YR.REC(39) = YM.EVENT.C2
    YTRUE.1 = 0
    YM.SHED.KEY.INT2 = ID.NEW
    YM1.SHED.KEY.INT2 = YM.SHED.KEY.INT2
    YM.SHED.KEY.INT2 = YM.EVENT.DATE2
    YM.SHED.KEY.INT2 = FMT(YM.SHED.KEY.INT2,"7L"); YM.SHED.KEY.INT2 = YM.SHED.KEY.INT2[1,7]
    YM1.SHED.KEY.INT2 = YM1.SHED.KEY.INT2 : YM.SHED.KEY.INT2
    YM.SHED.KEY.INT2 = YM1.SHED.KEY.INT2
    YM.SHED.KEY2 = YM.SHED.KEY.INT2
    YM1.SHED.KEY2 = YM.SHED.KEY2
    YM.SHED.KEY2 = "00"
    YM1.SHED.KEY2 = YM1.SHED.KEY2 : YM.SHED.KEY2
    YM.SHED.KEY2 = YM1.SHED.KEY2
    YM.TYPE.F2 = YM.SHED.KEY2
    IF YM.TYPE.F2 <> "" THEN
        YCOMP = "LMM.SCHEDULES_12_":YM.TYPE.F2
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.F2 = YFOR.FD
    END
    IF YM.TYPE.F2 <> "" THEN
        YTRUE.1 = 1
        YM.EVENT.F2 = "F"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.F2 = ""
    YR.REC(40) = YM.EVENT.F2
    YTRUE.1 = 0
    YM.SHED.DATES.KEY = YM.CONTRACT.NO
    YM1.SHED.DATES.KEY = YM.SHED.DATES.KEY
    YM.SHED.DATES.KEY = "00"
    YM1.SHED.DATES.KEY = YM1.SHED.DATES.KEY : YM.SHED.DATES.KEY
    YM.SHED.DATES.KEY = YM1.SHED.DATES.KEY
    YM.DATES.KEY.DUMMY3 = YM.SHED.DATES.KEY
    YM.DATES.KEY.PARAM3 = YM.DATES.KEY.DUMMY3
    YM36.GOSUB = YM.DATES.KEY.PARAM3
    YM.EVENT.DATE.DUMMY2 = YM.EVENT.DATE2
    YM.PREVIOUS.DATE3 = YM.EVENT.DATE.DUMMY2
    YM37.GOSUB = YM.PREVIOUS.DATE3
    YM.EVENT.DATE3 = ""
    YM38.GOSUB = YM.EVENT.DATE3
    YM.EVENT.DATE.NO3 = "3"
    YM39.GOSUB = YM.EVENT.DATE.NO3
    CALL @LD.EXTRCT.SUBSEQ.DT (YM36.GOSUB, YM37.GOSUB, YM38.GOSUB, YM39.GOSUB)
    YM.DATES.KEY.PARAM3 = YM36.GOSUB
    YM.PREVIOUS.DATE3 = YM37.GOSUB
    YM.EVENT.DATE3 = YM38.GOSUB
    YM.EVENT.DATE.NO3 = YM39.GOSUB
    IF (YM.EVENT.DATE3 <> "") THEN
        YTRUE.1 = 1
        YM.EVENT.DATE3.LIT = "EVENT DATE 3 : "
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.DATE3.LIT = ""
    YR.REC(41) = YM.EVENT.DATE3.LIT
    YTRUE.1 = 0
    IF (YM.EVENT.DATE3 <> "") THEN
        YTRUE.1 = 1
        YM.DATE.REQD3 = ""
        YM41.GOSUB = YM.DATE.REQD3
        YM.EVENT.DATE.DUMMY3 = YM.EVENT.DATE3
        YM.JUL.EVENT.DATE3 = YM.EVENT.DATE.DUMMY3
        YM42.GOSUB = YM.JUL.EVENT.DATE3
        CALL @JULDATE (YM41.GOSUB, YM42.GOSUB)
        YM.DATE.REQD3 = YM41.GOSUB
        YM.JUL.EVENT.DATE3 = YM42.GOSUB
        YM.DATE.PRINT3 = YM.DATE.REQD3
    END
    IF NOT(YTRUE.1) THEN YM.DATE.PRINT3 = ""
    YR.REC(42) = YM.DATE.PRINT3
    YTRUE.1 = 0
    IF (YM.EVENT.DATE3 <> "") THEN
        YTRUE.1 = 1
        YM.EVENT3.LIT = "EVENT : "
    END
    IF NOT(YTRUE.1) THEN YM.EVENT3.LIT = ""
    YR.REC(43) = YM.EVENT3.LIT
    YTRUE.1 = 0
    YM.SHED.KEY.INT3 = ID.NEW
    YM1.SHED.KEY.INT3 = YM.SHED.KEY.INT3
    YM.SHED.KEY.INT3 = YM.EVENT.DATE3
    YM.SHED.KEY.INT3 = FMT(YM.SHED.KEY.INT3,"7L"); YM.SHED.KEY.INT3 = YM.SHED.KEY.INT3[1,7]
    YM1.SHED.KEY.INT3 = YM1.SHED.KEY.INT3 : YM.SHED.KEY.INT3
    YM.SHED.KEY.INT3 = YM1.SHED.KEY.INT3
    YM.SHED.KEY3 = YM.SHED.KEY.INT3
    YM1.SHED.KEY3 = YM.SHED.KEY3
    YM.SHED.KEY3 = "00"
    YM1.SHED.KEY3 = YM1.SHED.KEY3 : YM.SHED.KEY3
    YM.SHED.KEY3 = YM1.SHED.KEY3
    YM.TYPE.P3 = YM.SHED.KEY3
    IF YM.TYPE.P3 <> "" THEN
        YCOMP = "LMM.SCHEDULES_2_":YM.TYPE.P3
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.P3 = YFOR.FD
    END
    IF YM.TYPE.P3 <> "" THEN
        YTRUE.1 = 1
        YM.EVENT.P3 = "P"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.P3 = ""
    YR.REC(44) = YM.EVENT.P3
    YTRUE.1 = 0
    YM.SHED.KEY.INT3 = ID.NEW
    YM1.SHED.KEY.INT3 = YM.SHED.KEY.INT3
    YM.SHED.KEY.INT3 = YM.EVENT.DATE3
    YM.SHED.KEY.INT3 = FMT(YM.SHED.KEY.INT3,"7L"); YM.SHED.KEY.INT3 = YM.SHED.KEY.INT3[1,7]
    YM1.SHED.KEY.INT3 = YM1.SHED.KEY.INT3 : YM.SHED.KEY.INT3
    YM.SHED.KEY.INT3 = YM1.SHED.KEY.INT3
    YM.SHED.KEY3 = YM.SHED.KEY.INT3
    YM1.SHED.KEY3 = YM.SHED.KEY3
    YM.SHED.KEY3 = "00"
    YM1.SHED.KEY3 = YM1.SHED.KEY3 : YM.SHED.KEY3
    YM.SHED.KEY3 = YM1.SHED.KEY3
    YM.TYPE.I3 = YM.SHED.KEY3
    IF YM.TYPE.I3 <> "" THEN
        YCOMP = "LMM.SCHEDULES_4_":YM.TYPE.I3
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.I3 = YFOR.FD
    END
    IF YM.TYPE.I3 <> "" THEN
        YTRUE.1 = 1
        YM.EVENT.I3 = "I"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.I3 = ""
    YR.REC(45) = YM.EVENT.I3
    YTRUE.1 = 0
    YM.SHED.KEY.INT3 = ID.NEW
    YM1.SHED.KEY.INT3 = YM.SHED.KEY.INT3
    YM.SHED.KEY.INT3 = YM.EVENT.DATE3
    YM.SHED.KEY.INT3 = FMT(YM.SHED.KEY.INT3,"7L"); YM.SHED.KEY.INT3 = YM.SHED.KEY.INT3[1,7]
    YM1.SHED.KEY.INT3 = YM1.SHED.KEY.INT3 : YM.SHED.KEY.INT3
    YM.SHED.KEY.INT3 = YM1.SHED.KEY.INT3
    YM.SHED.KEY3 = YM.SHED.KEY.INT3
    YM1.SHED.KEY3 = YM.SHED.KEY3
    YM.SHED.KEY3 = "00"
    YM1.SHED.KEY3 = YM1.SHED.KEY3 : YM.SHED.KEY3
    YM.SHED.KEY3 = YM1.SHED.KEY3
    YM.TYPE.C3 = YM.SHED.KEY3
    IF YM.TYPE.C3 <> "" THEN
        YCOMP = "LMM.SCHEDULES_8_":YM.TYPE.C3
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.C3 = YFOR.FD
    END
    IF YM.TYPE.C3 <> "" THEN
        YTRUE.1 = 1
        YM.EVENT.C3 = "C"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.C3 = ""
    YR.REC(46) = YM.EVENT.C3
    YTRUE.1 = 0
    YM.SHED.KEY.INT3 = ID.NEW
    YM1.SHED.KEY.INT3 = YM.SHED.KEY.INT3
    YM.SHED.KEY.INT3 = YM.EVENT.DATE3
    YM.SHED.KEY.INT3 = FMT(YM.SHED.KEY.INT3,"7L"); YM.SHED.KEY.INT3 = YM.SHED.KEY.INT3[1,7]
    YM1.SHED.KEY.INT3 = YM1.SHED.KEY.INT3 : YM.SHED.KEY.INT3
    YM.SHED.KEY.INT3 = YM1.SHED.KEY.INT3
    YM.SHED.KEY3 = YM.SHED.KEY.INT3
    YM1.SHED.KEY3 = YM.SHED.KEY3
    YM.SHED.KEY3 = "00"
    YM1.SHED.KEY3 = YM1.SHED.KEY3 : YM.SHED.KEY3
    YM.SHED.KEY3 = YM1.SHED.KEY3
    YM.TYPE.F3 = YM.SHED.KEY3
    IF YM.TYPE.F3 <> "" THEN
        YCOMP = "LMM.SCHEDULES_12_":YM.TYPE.F3
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.F3 = YFOR.FD
    END
    IF YM.TYPE.F3 <> "" THEN
        YTRUE.1 = 1
        YM.EVENT.F3 = "F"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.F3 = ""
    YR.REC(47) = YM.EVENT.F3
    YTRUE.1 = 0
    YM.SHED.DATES.KEY = YM.CONTRACT.NO
    YM1.SHED.DATES.KEY = YM.SHED.DATES.KEY
    YM.SHED.DATES.KEY = "00"
    YM1.SHED.DATES.KEY = YM1.SHED.DATES.KEY : YM.SHED.DATES.KEY
    YM.SHED.DATES.KEY = YM1.SHED.DATES.KEY
    YM.DATES.KEY.DUMMY4 = YM.SHED.DATES.KEY
    YM.DATES.KEY.PARAM4 = YM.DATES.KEY.DUMMY4
    YM44.GOSUB = YM.DATES.KEY.PARAM4
    YM.EVENT.DATE.DUMMY3 = YM.EVENT.DATE3
    YM.PREVIOUS.DATE4 = YM.EVENT.DATE.DUMMY3
    YM45.GOSUB = YM.PREVIOUS.DATE4
    YM.EVENT.DATE4 = ""
    YM46.GOSUB = YM.EVENT.DATE4
    YM.EVENT.DATE.NO4 = "4"
    YM47.GOSUB = YM.EVENT.DATE.NO4
    CALL @LD.EXTRCT.SUBSEQ.DT (YM44.GOSUB, YM45.GOSUB, YM46.GOSUB, YM47.GOSUB)
    YM.DATES.KEY.PARAM4 = YM44.GOSUB
    YM.PREVIOUS.DATE4 = YM45.GOSUB
    YM.EVENT.DATE4 = YM46.GOSUB
    YM.EVENT.DATE.NO4 = YM47.GOSUB
    IF (YM.EVENT.DATE4 <> "") THEN
        YTRUE.1 = 1
        YM.EVENT.DATE4.LIT = "EVENT DATE 4 : "
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.DATE4.LIT = ""
    YR.REC(48) = YM.EVENT.DATE4.LIT
    YTRUE.1 = 0
    IF (YM.EVENT.DATE4 <> "") THEN
        YTRUE.1 = 1
        YM.DATE.REQD4 = ""
        YM49.GOSUB = YM.DATE.REQD4
        YM.EVENT.DATE.DUMMY4 = YM.EVENT.DATE4
        YM.JUL.EVENT.DATE4 = YM.EVENT.DATE.DUMMY4
        YM50.GOSUB = YM.JUL.EVENT.DATE4
        CALL @JULDATE (YM49.GOSUB, YM50.GOSUB)
        YM.DATE.REQD4 = YM49.GOSUB
        YM.JUL.EVENT.DATE4 = YM50.GOSUB
        YM.DATE.PRINT4 = YM.DATE.REQD4
    END
    IF NOT(YTRUE.1) THEN YM.DATE.PRINT4 = ""
    YR.REC(49) = YM.DATE.PRINT4
    YTRUE.1 = 0
    IF (YM.EVENT.DATE4 <> "") THEN
        YTRUE.1 = 1
        YM.EVENT4.LIT = "EVENT : "
    END
    IF NOT(YTRUE.1) THEN YM.EVENT4.LIT = ""
    YR.REC(50) = YM.EVENT4.LIT
    YTRUE.1 = 0
    YM.SHED.KEY.INT4 = ID.NEW
    YM1.SHED.KEY.INT4 = YM.SHED.KEY.INT4
    YM.SHED.KEY.INT4 = YM.EVENT.DATE4
    YM.SHED.KEY.INT4 = FMT(YM.SHED.KEY.INT4,"7L"); YM.SHED.KEY.INT4 = YM.SHED.KEY.INT4[1,7]
    YM1.SHED.KEY.INT4 = YM1.SHED.KEY.INT4 : YM.SHED.KEY.INT4
    YM.SHED.KEY.INT4 = YM1.SHED.KEY.INT4
    YM.SHED.KEY4 = YM.SHED.KEY.INT4
    YM1.SHED.KEY4 = YM.SHED.KEY4
    YM.SHED.KEY4 = "00"
    YM1.SHED.KEY4 = YM1.SHED.KEY4 : YM.SHED.KEY4
    YM.SHED.KEY4 = YM1.SHED.KEY4
    YM.TYPE.P4 = YM.SHED.KEY4
    IF YM.TYPE.P4 <> "" THEN
        YCOMP = "LMM.SCHEDULES_2_":YM.TYPE.P4
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.P4 = YFOR.FD
    END
    IF YM.TYPE.P4 <> "" THEN
        YTRUE.1 = 1
        YM.EVENT.P4 = "P"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.P4 = ""
    YR.REC(51) = YM.EVENT.P4
    YTRUE.1 = 0
    YM.SHED.KEY.INT4 = ID.NEW
    YM1.SHED.KEY.INT4 = YM.SHED.KEY.INT4
    YM.SHED.KEY.INT4 = YM.EVENT.DATE4
    YM.SHED.KEY.INT4 = FMT(YM.SHED.KEY.INT4,"7L"); YM.SHED.KEY.INT4 = YM.SHED.KEY.INT4[1,7]
    YM1.SHED.KEY.INT4 = YM1.SHED.KEY.INT4 : YM.SHED.KEY.INT4
    YM.SHED.KEY.INT4 = YM1.SHED.KEY.INT4
    YM.SHED.KEY4 = YM.SHED.KEY.INT4
    YM1.SHED.KEY4 = YM.SHED.KEY4
    YM.SHED.KEY4 = "00"
    YM1.SHED.KEY4 = YM1.SHED.KEY4 : YM.SHED.KEY4
    YM.SHED.KEY4 = YM1.SHED.KEY4
    YM.TYPE.I4 = YM.SHED.KEY4
    IF YM.TYPE.I4 <> "" THEN
        YCOMP = "LMM.SCHEDULES_4_":YM.TYPE.I4
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.I4 = YFOR.FD
    END
    IF YM.TYPE.I4 <> "" THEN
        YTRUE.1 = 1
        YM.EVENT.I4 = "I"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.I4 = ""
    YR.REC(52) = YM.EVENT.I4
    YTRUE.1 = 0
    YM.SHED.KEY.INT4 = ID.NEW
    YM1.SHED.KEY.INT4 = YM.SHED.KEY.INT4
    YM.SHED.KEY.INT4 = YM.EVENT.DATE4
    YM.SHED.KEY.INT4 = FMT(YM.SHED.KEY.INT4,"7L"); YM.SHED.KEY.INT4 = YM.SHED.KEY.INT4[1,7]
    YM1.SHED.KEY.INT4 = YM1.SHED.KEY.INT4 : YM.SHED.KEY.INT4
    YM.SHED.KEY.INT4 = YM1.SHED.KEY.INT4
    YM.SHED.KEY4 = YM.SHED.KEY.INT4
    YM1.SHED.KEY4 = YM.SHED.KEY4
    YM.SHED.KEY4 = "00"
    YM1.SHED.KEY4 = YM1.SHED.KEY4 : YM.SHED.KEY4
    YM.SHED.KEY4 = YM1.SHED.KEY4
    YM.TYPE.C4 = YM.SHED.KEY4
    IF YM.TYPE.C4 <> "" THEN
        YCOMP = "LMM.SCHEDULES_8_":YM.TYPE.C4
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.C4 = YFOR.FD
    END
    IF YM.TYPE.C4 <> "" THEN
        YTRUE.1 = 1
        YM.EVENT.C4 = "C"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.C4 = ""
    YR.REC(53) = YM.EVENT.C4
    YTRUE.1 = 0
    YM.SHED.KEY.INT4 = ID.NEW
    YM1.SHED.KEY.INT4 = YM.SHED.KEY.INT4
    YM.SHED.KEY.INT4 = YM.EVENT.DATE4
    YM.SHED.KEY.INT4 = FMT(YM.SHED.KEY.INT4,"7L"); YM.SHED.KEY.INT4 = YM.SHED.KEY.INT4[1,7]
    YM1.SHED.KEY.INT4 = YM1.SHED.KEY.INT4 : YM.SHED.KEY.INT4
    YM.SHED.KEY.INT4 = YM1.SHED.KEY.INT4
    YM.SHED.KEY4 = YM.SHED.KEY.INT4
    YM1.SHED.KEY4 = YM.SHED.KEY4
    YM.SHED.KEY4 = "00"
    YM1.SHED.KEY4 = YM1.SHED.KEY4 : YM.SHED.KEY4
    YM.SHED.KEY4 = YM1.SHED.KEY4
    YM.TYPE.F4 = YM.SHED.KEY4
    IF YM.TYPE.F4 <> "" THEN
        YCOMP = "LMM.SCHEDULES_12_":YM.TYPE.F4
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.F4 = YFOR.FD
    END
    IF YM.TYPE.F4 <> "" THEN
        YTRUE.1 = 1
        YM.EVENT.F4 = "F"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.F4 = ""
    YR.REC(54) = YM.EVENT.F4
    YTRUE.1 = 0
    YM.SHED.DATES.KEY = YM.CONTRACT.NO
    YM1.SHED.DATES.KEY = YM.SHED.DATES.KEY
    YM.SHED.DATES.KEY = "00"
    YM1.SHED.DATES.KEY = YM1.SHED.DATES.KEY : YM.SHED.DATES.KEY
    YM.SHED.DATES.KEY = YM1.SHED.DATES.KEY
    YM.DATES.KEY.DUMMY5 = YM.SHED.DATES.KEY
    YM.DATES.KEY.PARAM5 = YM.DATES.KEY.DUMMY5
    YM52.GOSUB = YM.DATES.KEY.PARAM5
    YM.EVENT.DATE.DUMMY4 = YM.EVENT.DATE4
    YM.PREVIOUS.DATE5 = YM.EVENT.DATE.DUMMY4
    YM53.GOSUB = YM.PREVIOUS.DATE5
    YM.EVENT.DATE5 = ""
    YM54.GOSUB = YM.EVENT.DATE5
    YM.EVENT.DATE.NO5 = "5"
    YM55.GOSUB = YM.EVENT.DATE.NO5
    CALL @LD.EXTRCT.SUBSEQ.DT (YM52.GOSUB, YM53.GOSUB, YM54.GOSUB, YM55.GOSUB)
    YM.DATES.KEY.PARAM5 = YM52.GOSUB
    YM.PREVIOUS.DATE5 = YM53.GOSUB
    YM.EVENT.DATE5 = YM54.GOSUB
    YM.EVENT.DATE.NO5 = YM55.GOSUB
    IF (YM.EVENT.DATE5 <> "") THEN
        YTRUE.1 = 1
        YM.EVENT.DATE5.LIT = "EVENT DATE 5 : "
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.DATE5.LIT = ""
    YR.REC(55) = YM.EVENT.DATE5.LIT
    YTRUE.1 = 0
    IF (YM.EVENT.DATE5 <> "") THEN
        YTRUE.1 = 1
        YM.DATE.REQD5 = ""
        YM57.GOSUB = YM.DATE.REQD5
        YM.EVENT.DATE.DUMMY5 = YM.EVENT.DATE5
        YM.JUL.EVENT.DATE5 = YM.EVENT.DATE.DUMMY5
        YM58.GOSUB = YM.JUL.EVENT.DATE5
        CALL @JULDATE (YM57.GOSUB, YM58.GOSUB)
        YM.DATE.REQD5 = YM57.GOSUB
        YM.JUL.EVENT.DATE5 = YM58.GOSUB
        YM.DATE.PRINT5 = YM.DATE.REQD5
    END
    IF NOT(YTRUE.1) THEN YM.DATE.PRINT5 = ""
    YR.REC(56) = YM.DATE.PRINT5
    YTRUE.1 = 0
    IF (YM.EVENT.DATE5 <> "") THEN
        YTRUE.1 = 1
        YM.EVENT5.LIT = "EVENT : "
    END
    IF NOT(YTRUE.1) THEN YM.EVENT5.LIT = ""
    YR.REC(57) = YM.EVENT5.LIT
    YTRUE.1 = 0
    YM.SHED.KEY.INT5 = ID.NEW
    YM1.SHED.KEY.INT5 = YM.SHED.KEY.INT5
    YM.SHED.KEY.INT5 = YM.EVENT.DATE5
    YM.SHED.KEY.INT5 = FMT(YM.SHED.KEY.INT5,"7L"); YM.SHED.KEY.INT5 = YM.SHED.KEY.INT5[1,7]
    YM1.SHED.KEY.INT5 = YM1.SHED.KEY.INT5 : YM.SHED.KEY.INT5
    YM.SHED.KEY.INT5 = YM1.SHED.KEY.INT5
    YM.SHED.KEY5 = YM.SHED.KEY.INT5
    YM1.SHED.KEY5 = YM.SHED.KEY5
    YM.SHED.KEY5 = "00"
    YM1.SHED.KEY5 = YM1.SHED.KEY5 : YM.SHED.KEY5
    YM.SHED.KEY5 = YM1.SHED.KEY5
    YM.TYPE.P5 = YM.SHED.KEY5
    IF YM.TYPE.P5 <> "" THEN
        YCOMP = "LMM.SCHEDULES_2_":YM.TYPE.P5
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.P5 = YFOR.FD
    END
    IF YM.TYPE.P5 <> "" THEN
        YTRUE.1 = 1
        YM.EVENT.P5 = "P"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.P5 = ""
    YR.REC(58) = YM.EVENT.P5
    YTRUE.1 = 0
    YM.SHED.KEY.INT5 = ID.NEW
    YM1.SHED.KEY.INT5 = YM.SHED.KEY.INT5
    YM.SHED.KEY.INT5 = YM.EVENT.DATE5
    YM.SHED.KEY.INT5 = FMT(YM.SHED.KEY.INT5,"7L"); YM.SHED.KEY.INT5 = YM.SHED.KEY.INT5[1,7]
    YM1.SHED.KEY.INT5 = YM1.SHED.KEY.INT5 : YM.SHED.KEY.INT5
    YM.SHED.KEY.INT5 = YM1.SHED.KEY.INT5
    YM.SHED.KEY5 = YM.SHED.KEY.INT5
    YM1.SHED.KEY5 = YM.SHED.KEY5
    YM.SHED.KEY5 = "00"
    YM1.SHED.KEY5 = YM1.SHED.KEY5 : YM.SHED.KEY5
    YM.SHED.KEY5 = YM1.SHED.KEY5
    YM.TYPE.I5 = YM.SHED.KEY5
    IF YM.TYPE.I5 <> "" THEN
        YCOMP = "LMM.SCHEDULES_4_":YM.TYPE.I5
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.I5 = YFOR.FD
    END
    IF YM.TYPE.I5 <> "" THEN
        YTRUE.1 = 1
        YM.EVENT.I5 = "I"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.I5 = ""
    YR.REC(59) = YM.EVENT.I5
    YTRUE.1 = 0
    YM.SHED.KEY.INT5 = ID.NEW
    YM1.SHED.KEY.INT5 = YM.SHED.KEY.INT5
    YM.SHED.KEY.INT5 = YM.EVENT.DATE5
    YM.SHED.KEY.INT5 = FMT(YM.SHED.KEY.INT5,"7L"); YM.SHED.KEY.INT5 = YM.SHED.KEY.INT5[1,7]
    YM1.SHED.KEY.INT5 = YM1.SHED.KEY.INT5 : YM.SHED.KEY.INT5
    YM.SHED.KEY.INT5 = YM1.SHED.KEY.INT5
    YM.SHED.KEY5 = YM.SHED.KEY.INT5
    YM1.SHED.KEY5 = YM.SHED.KEY5
    YM.SHED.KEY5 = "00"
    YM1.SHED.KEY5 = YM1.SHED.KEY5 : YM.SHED.KEY5
    YM.SHED.KEY5 = YM1.SHED.KEY5
    YM.TYPE.C5 = YM.SHED.KEY5
    IF YM.TYPE.C5 <> "" THEN
        YCOMP = "LMM.SCHEDULES_8_":YM.TYPE.C5
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.C5 = YFOR.FD
    END
    IF YM.TYPE.C5 <> "" THEN
        YTRUE.1 = 1
        YM.EVENT.C5 = "C"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.C5 = ""
    YR.REC(60) = YM.EVENT.C5
    YTRUE.1 = 0
    YM.SHED.KEY.INT5 = ID.NEW
    YM1.SHED.KEY.INT5 = YM.SHED.KEY.INT5
    YM.SHED.KEY.INT5 = YM.EVENT.DATE5
    YM.SHED.KEY.INT5 = FMT(YM.SHED.KEY.INT5,"7L"); YM.SHED.KEY.INT5 = YM.SHED.KEY.INT5[1,7]
    YM1.SHED.KEY.INT5 = YM1.SHED.KEY.INT5 : YM.SHED.KEY.INT5
    YM.SHED.KEY.INT5 = YM1.SHED.KEY.INT5
    YM.SHED.KEY5 = YM.SHED.KEY.INT5
    YM1.SHED.KEY5 = YM.SHED.KEY5
    YM.SHED.KEY5 = "00"
    YM1.SHED.KEY5 = YM1.SHED.KEY5 : YM.SHED.KEY5
    YM.SHED.KEY5 = YM1.SHED.KEY5
    YM.TYPE.F5 = YM.SHED.KEY5
    IF YM.TYPE.F5 <> "" THEN
        YCOMP = "LMM.SCHEDULES_12_":YM.TYPE.F5
        YFORFIL = YF.LMM.SCHEDULES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TYPE.F5 = YFOR.FD
    END
    IF YM.TYPE.F5 <> "" THEN
        YTRUE.1 = 1
        YM.EVENT.F5 = "F"
    END
    IF NOT(YTRUE.1) THEN YM.EVENT.F5 = ""
    YR.REC(61) = YM.EVENT.F5
    YM.BLANK.LINE3 = "."
    YR.REC(62) = YM.BLANK.LINE3
    YM.END.REC.LIT1 = "*********************************"
    YR.REC(63) = YM.END.REC.LIT1
    YM.END.REC.LIT2 = "*********************************"
    YR.REC(64) = YM.END.REC.LIT2
    YM.END.REC.LIT3 = "*********************************"
    YR.REC(65) = YM.END.REC.LIT3
    YM.END.REC.LIT4 = "*********************************"
    YR.REC(66) = YM.END.REC.LIT4
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
