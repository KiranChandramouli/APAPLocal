$PACKAGE APAP.Repgens

SUBROUTINE RGS.LD0400
REM "RGS.LD0400",230614-4
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
    YT.SMS.COMP = ID.COMPANY
    YT.SMS.FILE = "LD.LOANS.AND.DEPOSITS"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
    YT.SMS.FILE<-1> = "LMM.ACCOUNT.BALANCES"
    YT.SMS.FILE<-1> = "CUSTOMER"
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
    DIM YR.REC(18)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.LD0400"
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
        CALL FATAL.ERROR ("RGS.LD0400")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "LD.LOANS.AND.DEPOSITS"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
    YT.SMS.FILE<-1> = "LMM.ACCOUNT.BALANCES"
    YT.SMS.FILE<-1> = "CUSTOMER"
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
    YFILE = "F.CUSTOMER"; YF.CUSTOMER = ""
    CALL OPF (YFILE, YF.CUSTOMER)
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
            YM.CONTRACT.NO = ID.NEW
            YM.ACCBAL.KEY = YM.CONTRACT.NO
            YM1.ACCBAL.KEY = YM.ACCBAL.KEY
            YM.ACCBAL.KEY = "00"
            YM1.ACCBAL.KEY = YM1.ACCBAL.KEY : YM.ACCBAL.KEY
            YM.ACCBAL.KEY = YM1.ACCBAL.KEY
            YM.WHT.CERT.AMT.EXP = YM.ACCBAL.KEY
            YCOUNT.RPL = COUNT(YM.WHT.CERT.AMT.EXP,@VM)+1
            FOR YAV.RPL = 1 TO YCOUNT.RPL
                IF YM.WHT.CERT.AMT.EXP<1,YAV.RPL> <> "" THEN
                    YCOMP = "LMM.ACCOUNT.BALANCES_70_":YM.WHT.CERT.AMT.EXP<1,YAV.RPL>
                    YFORFIL = YF.LMM.ACCOUNT.BALANCES
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.WHT.CERT.AMT.EXP<1,YAV.RPL> = YFOR.FD
                END
            NEXT YAV.RPL
            IF (YM.WHT.CERT.AMT.EXP <> 0) AND (YM.WHT.CERT.AMT.EXP <> "") THEN
                GOSUB 2000000
            END
        END
*
    REPEAT
    IF YKEYNO THEN
        YR.REC(18)  := @FM
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
    YM.CUST.NAME = R.NEW(1)
    IF YM.CUST.NAME <> "" THEN
        YCOMP = "CUSTOMER_2_":YM.CUST.NAME
        YFORFIL = YF.CUSTOMER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.CUST.NAME = YFOR.FD
    END
    YR.REC(3) = YM.CUST.NAME
    YM.ACC.OFFICER = R.NEW(79)
    YR.REC(4) = YM.ACC.OFFICER
    YM.CCY = R.NEW(2)
    YR.REC(5) = YM.CCY
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
    YR.REC(6) = YM.LIQ.CD.PRINT
    YM.ALT.PRINT = R.NEW(31)
    YR.REC(7) = YM.ALT.PRINT
    YM.ACCBAL.KEY = YM.CONTRACT.NO
    YM1.ACCBAL.KEY = YM.ACCBAL.KEY
    YM.ACCBAL.KEY = "00"
    YM1.ACCBAL.KEY = YM1.ACCBAL.KEY : YM.ACCBAL.KEY
    YM.ACCBAL.KEY = YM1.ACCBAL.KEY
    YM.RECEIPTS.REQD = YM.ACCBAL.KEY
    YCOUNT.RPL = COUNT(YM.RECEIPTS.REQD,@VM)+1
    FOR YAV.RPL = 1 TO YCOUNT.RPL
        IF YM.RECEIPTS.REQD<1,YAV.RPL> <> "" THEN
            YCOMP = "LMM.ACCOUNT.BALANCES_70_":YM.RECEIPTS.REQD<1,YAV.RPL>
            YFORFIL = YF.LMM.ACCOUNT.BALANCES
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.RECEIPTS.REQD<1,YAV.RPL> = YFOR.FD
        END
    NEXT YAV.RPL
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
    YCOUNT.RPL = COUNT(YM.RECEIPTS.REQD,@VM)+1
    FOR YAV.RPL = 1 TO YCOUNT.RPL
        IF YM.RECEIPTS.REQD<1,YAV.RPL> <> "" THEN
            YM.RECEIPTS.REQD<1,YAV.RPL> = TRIM(FMT(YM.RECEIPTS.REQD<1,YAV.RPL>,"19R":YDEC))
        END
    NEXT YAV.RPL
    YR.REC(8) = YM.RECEIPTS.REQD
    YM.CURR.PER.ACCR = YM.ACCBAL.KEY
    YCOUNT.RPL = COUNT(YM.CURR.PER.ACCR,@VM)+1
    FOR YAV.RPL = 1 TO YCOUNT.RPL
        IF YM.CURR.PER.ACCR<1,YAV.RPL> <> "" THEN
            YCOMP = "LMM.ACCOUNT.BALANCES_69_":YM.CURR.PER.ACCR<1,YAV.RPL>
            YFORFIL = YF.LMM.ACCOUNT.BALANCES
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.CURR.PER.ACCR<1,YAV.RPL> = YFOR.FD
        END
    NEXT YAV.RPL
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
    YCOUNT.RPL = COUNT(YM.CURR.PER.ACCR,@VM)+1
    FOR YAV.RPL = 1 TO YCOUNT.RPL
        IF YM.CURR.PER.ACCR<1,YAV.RPL> <> "" THEN
            YM.CURR.PER.ACCR<1,YAV.RPL> = TRIM(FMT(YM.CURR.PER.ACCR<1,YAV.RPL>,"19R":YDEC))
        END
    NEXT YAV.RPL
    YR.REC(9) = YM.CURR.PER.ACCR
    YM.CUST.ID = R.NEW(1)
    YR.REC(10) = YM.CUST.ID
    YTRUE.1 = 0
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
    IF NOT(YTRUE.1) THEN
        YM.MAT.DATE = R.NEW(7)
        YM.MAT.DATE.CHECK = YM.MAT.DATE
        IF YM.MAT.DATE.CHECK > 999 THEN
            YTRUE.1 = 1
            YM.MAT.DATE = R.NEW(7)
            YM.MAT.DATE.DUMMY = YM.MAT.DATE
        END
    END
    IF NOT(YTRUE.1) THEN YM.MAT.DATE.DUMMY = ""
    YM.MAT.DATE.PRINT = YM.MAT.DATE.DUMMY
    YR.REC(11) = YM.MAT.DATE.PRINT
    YM.PRINT.COLON = ":"
    YR.REC(12) = YM.PRINT.COLON
    YM.VAL.DATE = R.NEW(6)
    YR.REC(13) = YM.VAL.DATE
    YM.BLANK.LINE = " "
    YR.REC(14) = YM.BLANK.LINE
    YM.END.REC.LIT1 = "*********************************"
    YR.REC(15) = YM.END.REC.LIT1
    YM.END.REC.LIT2 = "*********************************"
    YR.REC(16) = YM.END.REC.LIT2
    YM.END.REC.LIT3 = "*********************************"
    YR.REC(17) = YM.END.REC.LIT3
    YM.END.REC.LIT4 = "*********************************"
    YR.REC(18) = YM.END.REC.LIT4
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
