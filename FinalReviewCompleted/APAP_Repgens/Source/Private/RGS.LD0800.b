$PACKAGE APAP.Repgens

SUBROUTINE RGS.LD0800
REM "RGS.LD0800",230614-4
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
    JULDATE = "JULDATE"
    LD.ADD.TO.DATE = "LD.ADD.TO.DATE"
*************************************************************************
    YT.SMS.COMP = ID.COMPANY
    YT.SMS.FILE = "LMM.SCHEDULES"
    YT.SMS.FILE<-1> = "LD.LOANS.AND.DEPOSITS"
    YT.SMS.FILE<-1> = "DATES"
    YT.SMS.FILE<-1> = "ACCOUNT"
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
    DIM YR.REC(19)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.LD0800"
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
        CALL FATAL.ERROR ("RGS.LD0800")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "LMM.SCHEDULES"
    YT.SMS.FILE<-1> = "LD.LOANS.AND.DEPOSITS"
    YT.SMS.FILE<-1> = "DATES"
    YT.SMS.FILE<-1> = "ACCOUNT"
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
    YFILE = "F.DATES"; YF.DATES = ""
    CALL OPF (YFILE, YF.DATES)
    YFILE = "F.ACCOUNT"; YF.ACCOUNT = ""
    CALL OPF (YFILE, YF.ACCOUNT)
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
            YTRUE.1 = 0
            YM.SHED.ID = ID.NEW
            YM.CONTRACT.NO = YM.SHED.ID
            YM.CONTRACT.NO = FMT(YM.CONTRACT.NO,"17L"); YM.CONTRACT.NO = YM.CONTRACT.NO[1,12]
            YM.DRAW.ACCT = YM.CONTRACT.NO
            IF YM.DRAW.ACCT <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.DRAW.ACCT = YFOR.FD
            END
            YM.DRAW.ACCT.CCY = YM.DRAW.ACCT
            IF YM.DRAW.ACCT.CCY <> "" THEN
                YCOMP = "ACCOUNT_8_":YM.DRAW.ACCT.CCY
                YFORFIL = YF.ACCOUNT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.DRAW.ACCT.CCY = YFOR.FD
            END
            YM.DRAW.CCY.CHECK = YM.DRAW.ACCT.CCY
            IF YM.DRAW.CCY.CHECK <> "" THEN
                YTRUE.1 = 1
                YM.SHED.ID = ID.NEW
                YM.CONTRACT.NO = YM.SHED.ID
                YM.CONTRACT.NO = FMT(YM.CONTRACT.NO,"17L"); YM.CONTRACT.NO = YM.CONTRACT.NO[1,12]
                YM.DRAW.ACCT = YM.CONTRACT.NO
                IF YM.DRAW.ACCT <> "" THEN
                    YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
                    YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.DRAW.ACCT = YFOR.FD
                END
                YM.DRAW.ACCT.CCY = YM.DRAW.ACCT
                IF YM.DRAW.ACCT.CCY <> "" THEN
                    YCOMP = "ACCOUNT_8_":YM.DRAW.ACCT.CCY
                    YFORFIL = YF.ACCOUNT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.DRAW.ACCT.CCY = YFOR.FD
                END
                YM.DRAW.CCY = YM.DRAW.ACCT.CCY
            END
            IF NOT(YTRUE.1) THEN
                YM.SHED.ID = ID.NEW
                YM.CONTRACT.NO = YM.SHED.ID
                YM.CONTRACT.NO = FMT(YM.CONTRACT.NO,"17L"); YM.CONTRACT.NO = YM.CONTRACT.NO[1,12]
                YM.DRAW.ACCT = YM.CONTRACT.NO
                IF YM.DRAW.ACCT <> "" THEN
                    YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
                    YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.DRAW.ACCT = YFOR.FD
                END
                YM.DRAW.ACCT.CCY = YM.DRAW.ACCT
                IF YM.DRAW.ACCT.CCY <> "" THEN
                    YCOMP = "ACCOUNT_8_":YM.DRAW.ACCT.CCY
                    YFORFIL = YF.ACCOUNT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.DRAW.ACCT.CCY = YFOR.FD
                END
                YM.DRAW.CCY.CHECK = YM.DRAW.ACCT.CCY
                IF YM.DRAW.CCY.CHECK = "" THEN
                    YTRUE.1 = 1
                    YM.SHED.ID = ID.NEW
                    YM.CONTRACT.NO = YM.SHED.ID
                    YM.CONTRACT.NO = FMT(YM.CONTRACT.NO,"17L"); YM.CONTRACT.NO = YM.CONTRACT.NO[1,12]
                    YM.CONTRACT.CCY = YM.CONTRACT.NO
                    IF YM.CONTRACT.CCY <> "" THEN
                        YCOMP = "LD.LOANS.AND.DEPOSITS_2_":YM.CONTRACT.CCY
                        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.CONTRACT.CCY = YFOR.FD
                    END
                    YM.DRAW.CCY = YM.CONTRACT.CCY
                END
            END
            IF NOT(YTRUE.1) THEN YM.DRAW.CCY = ""
            YM.SHED.ID = ID.NEW
            YM.CONTRACT.NO = YM.SHED.ID
            YM.CONTRACT.NO = FMT(YM.CONTRACT.NO,"17L"); YM.CONTRACT.NO = YM.CONTRACT.NO[1,12]
            YM.CONTRACT.CCY = YM.CONTRACT.NO
            IF YM.CONTRACT.CCY <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_2_":YM.CONTRACT.CCY
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.CONTRACT.CCY = YFOR.FD
            END
            YTRUE.1 = 0
            YM.PRINC.ACCT = YM.CONTRACT.NO
            IF YM.PRINC.ACCT <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.PRINC.ACCT = YFOR.FD
            END
            YM.PRINC.ACCT.CCY = YM.PRINC.ACCT
            IF YM.PRINC.ACCT.CCY <> "" THEN
                YCOMP = "ACCOUNT_8_":YM.PRINC.ACCT.CCY
                YFORFIL = YF.ACCOUNT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.PRINC.ACCT.CCY = YFOR.FD
            END
            YM.PRINC.CCY.CHECK = YM.PRINC.ACCT.CCY
            IF YM.PRINC.CCY.CHECK <> "" THEN
                YTRUE.1 = 1
                YM.PRINC.ACCT = YM.CONTRACT.NO
                IF YM.PRINC.ACCT <> "" THEN
                    YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
                    YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.PRINC.ACCT = YFOR.FD
                END
                YM.PRINC.ACCT.CCY = YM.PRINC.ACCT
                IF YM.PRINC.ACCT.CCY <> "" THEN
                    YCOMP = "ACCOUNT_8_":YM.PRINC.ACCT.CCY
                    YFORFIL = YF.ACCOUNT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.PRINC.ACCT.CCY = YFOR.FD
                END
                YM.PRINC.CCY = YM.PRINC.ACCT.CCY
            END
            IF NOT(YTRUE.1) THEN
                YM.PRINC.ACCT = YM.CONTRACT.NO
                IF YM.PRINC.ACCT <> "" THEN
                    YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
                    YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.PRINC.ACCT = YFOR.FD
                END
                YM.PRINC.ACCT.CCY = YM.PRINC.ACCT
                IF YM.PRINC.ACCT.CCY <> "" THEN
                    YCOMP = "ACCOUNT_8_":YM.PRINC.ACCT.CCY
                    YFORFIL = YF.ACCOUNT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.PRINC.ACCT.CCY = YFOR.FD
                END
                YM.PRINC.CCY.CHECK = YM.PRINC.ACCT.CCY
                IF YM.PRINC.CCY.CHECK = "" THEN
                    YTRUE.1 = 1
                    YM.PRINC.CCY = YM.CONTRACT.CCY
                END
            END
            IF NOT(YTRUE.1) THEN YM.PRINC.CCY = ""
            YTRUE.1 = 0
            YM.INT.ACCT = YM.CONTRACT.NO
            IF YM.INT.ACCT <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.INT.ACCT = YFOR.FD
            END
            YM.INT.ACCT.CCY = YM.INT.ACCT
            IF YM.INT.ACCT.CCY <> "" THEN
                YCOMP = "ACCOUNT_8_":YM.INT.ACCT.CCY
                YFORFIL = YF.ACCOUNT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.INT.ACCT.CCY = YFOR.FD
            END
            YM.INT.CCY.CHECK = YM.INT.ACCT.CCY
            IF YM.INT.CCY.CHECK <> "" THEN
                YTRUE.1 = 1
                YM.INT.ACCT = YM.CONTRACT.NO
                IF YM.INT.ACCT <> "" THEN
                    YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
                    YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.INT.ACCT = YFOR.FD
                END
                YM.INT.ACCT.CCY = YM.INT.ACCT
                IF YM.INT.ACCT.CCY <> "" THEN
                    YCOMP = "ACCOUNT_8_":YM.INT.ACCT.CCY
                    YFORFIL = YF.ACCOUNT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.INT.ACCT.CCY = YFOR.FD
                END
                YM.INT.CCY = YM.INT.ACCT.CCY
            END
            IF NOT(YTRUE.1) THEN
                YM.INT.ACCT = YM.CONTRACT.NO
                IF YM.INT.ACCT <> "" THEN
                    YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
                    YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.INT.ACCT = YFOR.FD
                END
                YM.INT.ACCT.CCY = YM.INT.ACCT
                IF YM.INT.ACCT.CCY <> "" THEN
                    YCOMP = "ACCOUNT_8_":YM.INT.ACCT.CCY
                    YFORFIL = YF.ACCOUNT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.INT.ACCT.CCY = YFOR.FD
                END
                YM.INT.CCY.CHECK = YM.INT.ACCT.CCY
                IF YM.INT.CCY.CHECK = "" THEN
                    YTRUE.1 = 1
                    YM.INT.CCY = YM.CONTRACT.CCY
                END
            END
            IF NOT(YTRUE.1) THEN YM.INT.CCY = ""
            YTRUE.1 = 0
            YM.COM.ACCT = YM.CONTRACT.NO
            IF YM.COM.ACCT <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.COM.ACCT = YFOR.FD
            END
            YM.COM.ACCT.CCY = YM.COM.ACCT
            IF YM.COM.ACCT.CCY <> "" THEN
                YCOMP = "ACCOUNT_8_":YM.COM.ACCT.CCY
                YFORFIL = YF.ACCOUNT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.COM.ACCT.CCY = YFOR.FD
            END
            YM.COM.CCY.CHECK = YM.COM.ACCT.CCY
            IF YM.COM.CCY.CHECK <> "" THEN
                YTRUE.1 = 1
                YM.COM.ACCT = YM.CONTRACT.NO
                IF YM.COM.ACCT <> "" THEN
                    YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
                    YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.COM.ACCT = YFOR.FD
                END
                YM.COM.ACCT.CCY = YM.COM.ACCT
                IF YM.COM.ACCT.CCY <> "" THEN
                    YCOMP = "ACCOUNT_8_":YM.COM.ACCT.CCY
                    YFORFIL = YF.ACCOUNT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.COM.ACCT.CCY = YFOR.FD
                END
                YM.COM.CCY = YM.COM.ACCT.CCY
            END
            IF NOT(YTRUE.1) THEN
                YM.COM.ACCT = YM.CONTRACT.NO
                IF YM.COM.ACCT <> "" THEN
                    YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
                    YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.COM.ACCT = YFOR.FD
                END
                YM.COM.ACCT.CCY = YM.COM.ACCT
                IF YM.COM.ACCT.CCY <> "" THEN
                    YCOMP = "ACCOUNT_8_":YM.COM.ACCT.CCY
                    YFORFIL = YF.ACCOUNT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.COM.ACCT.CCY = YFOR.FD
                END
                YM.COM.CCY.CHECK = YM.COM.ACCT.CCY
                IF YM.COM.CCY.CHECK = "" THEN
                    YTRUE.1 = 1
                    YM.COM.CCY = YM.CONTRACT.CCY
                END
            END
            IF NOT(YTRUE.1) THEN YM.COM.CCY = ""
            YTRUE.1 = 0
            YM.FEE.ACCT = YM.CONTRACT.NO
            IF YM.FEE.ACCT <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.FEE.ACCT = YFOR.FD
            END
            YM.FEE.ACCT.CCY = YM.FEE.ACCT
            IF YM.FEE.ACCT.CCY <> "" THEN
                YCOMP = "ACCOUNT_8_":YM.FEE.ACCT.CCY
                YFORFIL = YF.ACCOUNT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.FEE.ACCT.CCY = YFOR.FD
            END
            YM.FEE.CCY.CHECK = YM.FEE.ACCT.CCY
            IF YM.FEE.CCY.CHECK <> "" THEN
                YTRUE.1 = 1
                YM.FEE.ACCT = YM.CONTRACT.NO
                IF YM.FEE.ACCT <> "" THEN
                    YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
                    YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.FEE.ACCT = YFOR.FD
                END
                YM.FEE.ACCT.CCY = YM.FEE.ACCT
                IF YM.FEE.ACCT.CCY <> "" THEN
                    YCOMP = "ACCOUNT_8_":YM.FEE.ACCT.CCY
                    YFORFIL = YF.ACCOUNT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.FEE.ACCT.CCY = YFOR.FD
                END
                YM.FEE.CCY = YM.FEE.ACCT.CCY
            END
            IF NOT(YTRUE.1) THEN
                YM.FEE.ACCT = YM.CONTRACT.NO
                IF YM.FEE.ACCT <> "" THEN
                    YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
                    YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.FEE.ACCT = YFOR.FD
                END
                YM.FEE.ACCT.CCY = YM.FEE.ACCT
                IF YM.FEE.ACCT.CCY <> "" THEN
                    YCOMP = "ACCOUNT_8_":YM.FEE.ACCT.CCY
                    YFORFIL = YF.ACCOUNT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.FEE.ACCT.CCY = YFOR.FD
                END
                YM.FEE.CCY.CHECK = YM.FEE.ACCT.CCY
                IF YM.FEE.CCY.CHECK = "" THEN
                    YTRUE.1 = 1
                    YM.FEE.CCY = YM.CONTRACT.CCY
                END
            END
            IF NOT(YTRUE.1) THEN YM.FEE.CCY = ""
            YM.DATES.FILE.KEY = YM.CONTRACT.NO
            IF YM.DATES.FILE.KEY <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_250_":YM.DATES.FILE.KEY
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.DATES.FILE.KEY = YFOR.FD
            END
            YM.TODAYS.DATE = YM.DATES.FILE.KEY
            IF YM.TODAYS.DATE <> "" THEN
                YCOMP = "DATES_14_":YM.TODAYS.DATE
                YFORFIL = YF.DATES
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.TODAYS.DATE = YFOR.FD
            END
            YM.TODAYS.DATE.PARAM = YM.TODAYS.DATE
            YM17.GOSUB = YM.TODAYS.DATE.PARAM
            YM.ADD.PARAMETER = "7"
            YM18.GOSUB = YM.ADD.PARAMETER
            YM.DATE.TO.CHECK = ""
            YM19.GOSUB = YM.DATE.TO.CHECK
            CALL @LD.ADD.TO.DATE (YM17.GOSUB, YM18.GOSUB, YM19.GOSUB)
            YM.TODAYS.DATE.PARAM = YM17.GOSUB
            YM.ADD.PARAMETER = YM18.GOSUB
            YM.DATE.TO.CHECK = YM19.GOSUB
            YM.DATE.CHECK.YEAR = YM.DATE.TO.CHECK
            YM.DATE.CHECK.YEAR = FMT(YM.DATE.CHECK.YEAR,"7L"); YM.DATE.CHECK.YEAR = YM.DATE.CHECK.YEAR[3,5]
            YM.SHED.ID.YEAR = YM.SHED.ID
            YM.SHED.ID.YEAR = FMT(YM.SHED.ID.YEAR,"19L"); YM.SHED.ID.YEAR = YM.SHED.ID.YEAR[15,5]
            YM.TODAYS.DATE.YEAR = YM.TODAYS.DATE
            YM.TODAYS.DATE.YEAR = FMT(YM.TODAYS.DATE.YEAR,"7L"); YM.TODAYS.DATE.YEAR = YM.TODAYS.DATE.YEAR[3,5]
            YM.TYPE.P = R.NEW(2)
            YM.TYPE.I = R.NEW(4)
            YM.TYPE.C = R.NEW(8)
            YM.TYPE.F = R.NEW(12)
            YM.LD.CHAR = YM.CONTRACT.NO
            YM.LD.CHAR = FMT(YM.LD.CHAR,"12L"); YM.LD.CHAR = YM.LD.CHAR[1,2]
            IF (YM.CONTRACT.CCY <> YM.DRAW.CCY OR YM.CONTRACT.CCY <> YM.PRINC.CCY OR YM.CONTRACT.CCY <> YM.INT.CCY OR YM.CONTRACT.CCY <> YM.COM.CCY OR YM.CONTRACT.CCY <> YM.FEE.CCY) AND (YM.SHED.ID.YEAR <= YM.DATE.CHECK.YEAR AND YM.SHED.ID.YEAR >= YM.TODAYS.DATE.YEAR) AND (YM.TYPE.P <> "" OR YM.TYPE.I <> "" OR YM.TYPE.C <> "" OR YM.TYPE.F <> "") AND (YM.LD.CHAR = "LD") THEN
                GOSUB 2000000
            END
1000:
        END
*
    REPEAT
    IF YKEYNO THEN
        YR.REC(19)  := @FM
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
    YM.EVENT.DATE = ""
    YM4.GOSUB = YM.EVENT.DATE
    YM.EVENT.JULDATE = "19"
    YM1.EVENT.JULDATE = YM.EVENT.JULDATE
    YM.SHED.ID = ID.NEW
    YM.SHED.ID.YEAR = YM.SHED.ID
    YM.SHED.ID.YEAR = FMT(YM.SHED.ID.YEAR,"19L"); YM.SHED.ID.YEAR = YM.SHED.ID.YEAR[15,5]
    YM.EVENT.JULDATE = YM.SHED.ID.YEAR
    YM1.EVENT.JULDATE = YM1.EVENT.JULDATE : YM.EVENT.JULDATE
    YM.EVENT.JULDATE = YM1.EVENT.JULDATE
    YM.EVENT.JULDATE.PARAM = YM.EVENT.JULDATE
    YM5.GOSUB = YM.EVENT.JULDATE.PARAM
    CALL @JULDATE (YM4.GOSUB, YM5.GOSUB)
    YM.EVENT.DATE = YM4.GOSUB
    YM.EVENT.JULDATE.PARAM = YM5.GOSUB
    YM.EVENT.DATE.PRINT = YM.EVENT.DATE
    YKEYFD = YM.EVENT.DATE.PRINT
    YKEYFD = FMT(YM.EVENT.DATE.PRINT,"11L")
    IF LEN(YKEYFD) > 11 THEN YKEYFD = YKEYFD[1,10]:"|"
    GOSUB 8000000
    YR.REC(1) = YM.EVENT.DATE.PRINT
    YM.CONTRACT.NO = YM.SHED.ID
    YM.CONTRACT.NO = FMT(YM.CONTRACT.NO,"17L"); YM.CONTRACT.NO = YM.CONTRACT.NO[1,12]
    YKEYFD = FMT(YM.CONTRACT.NO,"L##/#####/#####")
    IF LEN(YKEYFD) > 14 THEN YKEYFD = YKEYFD[1,13]:"|"
    GOSUB 8000000
    YR.REC(2) = YM.CONTRACT.NO
    YM.CONTRACT.CCY = YM.CONTRACT.NO
    IF YM.CONTRACT.CCY <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_2_":YM.CONTRACT.CCY
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.CONTRACT.CCY = YFOR.FD
    END
    YR.REC(3) = YM.CONTRACT.CCY
    YTRUE.1 = 0
    YM.TYPE.P = R.NEW(2)
    IF YM.TYPE.P = "" THEN
        YTRUE.1 = 1
        YM.PRINC.RATE.CHECK = "NONE DUE TODAY"
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.P = R.NEW(2)
        YM.DRAW.ACCT = YM.CONTRACT.NO
        IF YM.DRAW.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT = YFOR.FD
        END
        YM.DRAW.ACCT.CCY = YM.DRAW.ACCT
        IF YM.DRAW.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.DRAW.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT.CCY = YFOR.FD
        END
        YM.DRAW.ACCT = YM.CONTRACT.NO
        IF YM.DRAW.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT = YFOR.FD
        END
        YM.CONTRACT.STATUS = YM.CONTRACT.NO
        IF YM.CONTRACT.STATUS <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_90_":YM.CONTRACT.STATUS
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.CONTRACT.STATUS = YFOR.FD
        END
        YM.VALUE.DATE = YM.CONTRACT.NO
        IF YM.VALUE.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_6_":YM.VALUE.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.VALUE.DATE = YFOR.FD
        END
        YM.AMT.INCREASE = YM.CONTRACT.NO
        IF YM.AMT.INCREASE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_127_":YM.AMT.INCREASE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.AMT.INCREASE = YFOR.FD
        END
        YM.AMT.INCREASE.DATE = YM.CONTRACT.NO
        IF YM.AMT.INCREASE.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_128_":YM.AMT.INCREASE.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.AMT.INCREASE.DATE = YFOR.FD
        END
        IF (YM.TYPE.P <> "") AND (YM.CONTRACT.CCY = YM.DRAW.ACCT.CCY OR (YM.DRAW.ACCT >= 1 AND YM.DRAW.ACCT <= 9)) AND ((YM.CONTRACT.STATUS = "FWD" AND YM.VALUE.DATE = YM.EVENT.DATE) OR (YM.AMT.INCREASE <> "" AND YM.AMT.INCREASE.DATE = YM.EVENT.DATE)) THEN
            YTRUE.1 = 1
            YM.PRINC.RATE.CHECK = "FX NOT REQUIRED"
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.P = R.NEW(2)
        YM.DRAW.ACCT = YM.CONTRACT.NO
        IF YM.DRAW.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT = YFOR.FD
        END
        YM.DRAW.ACCT.CCY = YM.DRAW.ACCT
        IF YM.DRAW.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.DRAW.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT.CCY = YFOR.FD
        END
        YM.DRAW.ACCT = YM.CONTRACT.NO
        IF YM.DRAW.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT = YFOR.FD
        END
        YM.PRINC.FX.RATE = YM.CONTRACT.NO
        IF YM.PRINC.FX.RATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_54_":YM.PRINC.FX.RATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.FX.RATE = YFOR.FD
        END
        YM.PRINC.RATE.DUMMY = YM.PRINC.FX.RATE
        YM.CONTRACT.STATUS = YM.CONTRACT.NO
        IF YM.CONTRACT.STATUS <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_90_":YM.CONTRACT.STATUS
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.CONTRACT.STATUS = YFOR.FD
        END
        YM.VALUE.DATE = YM.CONTRACT.NO
        IF YM.VALUE.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_6_":YM.VALUE.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.VALUE.DATE = YFOR.FD
        END
        YM.AMT.INCREASE = YM.CONTRACT.NO
        IF YM.AMT.INCREASE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_127_":YM.AMT.INCREASE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.AMT.INCREASE = YFOR.FD
        END
        YM.AMT.INCREASE.DATE = YM.CONTRACT.NO
        IF YM.AMT.INCREASE.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_128_":YM.AMT.INCREASE.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.AMT.INCREASE.DATE = YFOR.FD
        END
        IF (YM.TYPE.P <> "") AND (YM.CONTRACT.CCY <> YM.DRAW.ACCT.CCY) AND ((YM.DRAW.ACCT < 1 OR YM.DRAW.ACCT > 9)) AND (YM.PRINC.RATE.DUMMY = "") AND ((YM.CONTRACT.STATUS = "FWD" AND YM.VALUE.DATE = YM.EVENT.DATE) OR (YM.AMT.INCREASE <> "" AND YM.AMT.INCREASE.DATE = YM.EVENT.DATE)) THEN
            YTRUE.1 = 1
            YM.PRINC.RATE.CHECK = "INPUT MISSING"
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.P = R.NEW(2)
        YM.DRAW.ACCT = YM.CONTRACT.NO
        IF YM.DRAW.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT = YFOR.FD
        END
        YM.DRAW.ACCT.CCY = YM.DRAW.ACCT
        IF YM.DRAW.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.DRAW.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT.CCY = YFOR.FD
        END
        YM.DRAW.ACCT = YM.CONTRACT.NO
        IF YM.DRAW.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT = YFOR.FD
        END
        YM.PRINC.FX.RATE = YM.CONTRACT.NO
        IF YM.PRINC.FX.RATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_54_":YM.PRINC.FX.RATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.FX.RATE = YFOR.FD
        END
        YM.PRINC.RATE.DUMMY = YM.PRINC.FX.RATE
        YM.CONTRACT.STATUS = YM.CONTRACT.NO
        IF YM.CONTRACT.STATUS <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_90_":YM.CONTRACT.STATUS
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.CONTRACT.STATUS = YFOR.FD
        END
        YM.VALUE.DATE = YM.CONTRACT.NO
        IF YM.VALUE.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_6_":YM.VALUE.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.VALUE.DATE = YFOR.FD
        END
        YM.AMT.INCREASE.DATE = YM.CONTRACT.NO
        IF YM.AMT.INCREASE.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_128_":YM.AMT.INCREASE.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.AMT.INCREASE.DATE = YFOR.FD
        END
        YM.AMT.INCREASE = YM.CONTRACT.NO
        IF YM.AMT.INCREASE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_127_":YM.AMT.INCREASE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.AMT.INCREASE = YFOR.FD
        END
        IF (YM.TYPE.P <> "") AND (YM.CONTRACT.CCY <> YM.DRAW.ACCT.CCY) AND ((YM.DRAW.ACCT < 1 OR YM.DRAW.ACCT > 9)) AND (YM.PRINC.RATE.DUMMY <> "") AND ((YM.CONTRACT.STATUS = "FWD" AND YM.VALUE.DATE = YM.EVENT.DATE) OR (YM.AMT.INCREASE.DATE = YM.EVENT.DATE AND YM.AMT.INCREASE <> "")) THEN
            YTRUE.1 = 1
            YM.PRINC.FX.RATE = YM.CONTRACT.NO
            IF YM.PRINC.FX.RATE <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_54_":YM.PRINC.FX.RATE
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.PRINC.FX.RATE = YFOR.FD
            END
            YM.PRINC.RATE.CHECK = YM.PRINC.FX.RATE
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.P = R.NEW(2)
        YM.PRINC.ACCT = YM.CONTRACT.NO
        IF YM.PRINC.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT = YFOR.FD
        END
        YM.PRINC.ACCT.CCY = YM.PRINC.ACCT
        IF YM.PRINC.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.PRINC.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT.CCY = YFOR.FD
        END
        YM.PRINC.ACCT = YM.CONTRACT.NO
        IF YM.PRINC.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT = YFOR.FD
        END
        IF (YM.TYPE.P <> "") AND ((YM.CONTRACT.CCY = YM.PRINC.ACCT.CCY) OR ((YM.PRINC.ACCT >= 1 AND YM.PRINC.ACCT <= 9))) THEN
            YTRUE.1 = 1
            YM.PRINC.RATE.CHECK = "FX NOT REQUIRED"
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.P = R.NEW(2)
        YM.PRINC.ACCT = YM.CONTRACT.NO
        IF YM.PRINC.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT = YFOR.FD
        END
        YM.PRINC.ACCT.CCY = YM.PRINC.ACCT
        IF YM.PRINC.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.PRINC.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT.CCY = YFOR.FD
        END
        YM.PRINC.FX.RATE = YM.CONTRACT.NO
        IF YM.PRINC.FX.RATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_54_":YM.PRINC.FX.RATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.FX.RATE = YFOR.FD
        END
        YM.PRINC.RATE.DUMMY = YM.PRINC.FX.RATE
        YM.PRINC.ACCT = YM.CONTRACT.NO
        IF YM.PRINC.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT = YFOR.FD
        END
        IF (YM.TYPE.P <> "") AND (YM.CONTRACT.CCY <> YM.PRINC.ACCT.CCY) AND (YM.PRINC.RATE.DUMMY = "") AND ((YM.PRINC.ACCT < 1 OR YM.PRINC.ACCT > 9)) THEN
            YTRUE.1 = 1
            YM.PRINC.RATE.CHECK = "INPUT MISSING"
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.P = R.NEW(2)
        YM.PRINC.ACCT = YM.CONTRACT.NO
        IF YM.PRINC.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT = YFOR.FD
        END
        YM.PRINC.ACCT.CCY = YM.PRINC.ACCT
        IF YM.PRINC.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.PRINC.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT.CCY = YFOR.FD
        END
        YM.PRINC.FX.RATE = YM.CONTRACT.NO
        IF YM.PRINC.FX.RATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_54_":YM.PRINC.FX.RATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.FX.RATE = YFOR.FD
        END
        YM.PRINC.RATE.DUMMY = YM.PRINC.FX.RATE
        YM.PRINC.ACCT = YM.CONTRACT.NO
        IF YM.PRINC.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT = YFOR.FD
        END
        IF (YM.TYPE.P <> "") AND (YM.CONTRACT.CCY <> YM.PRINC.ACCT.CCY) AND (YM.PRINC.RATE.DUMMY <> "") AND ((YM.PRINC.ACCT < 1 OR YM.PRINC.ACCT > 9)) THEN
            YTRUE.1 = 1
            YM.PRINC.FX.RATE = YM.CONTRACT.NO
            IF YM.PRINC.FX.RATE <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_54_":YM.PRINC.FX.RATE
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.PRINC.FX.RATE = YFOR.FD
            END
            YM.PRINC.RATE.CHECK = YM.PRINC.FX.RATE
        END
    END
    IF NOT(YTRUE.1) THEN YM.PRINC.RATE.CHECK = ""
    YM.PRINC.RATE.PRINT = YM.PRINC.RATE.CHECK
    YR.REC(4) = YM.PRINC.RATE.PRINT
    YTRUE.1 = 0
    YM.TYPE.I = R.NEW(4)
    IF YM.TYPE.I = "" THEN
        YTRUE.1 = 1
        YM.INT.RATE.CHECK = "NONE DUE TODAY"
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.I = R.NEW(4)
        YM.INT.ACCT = YM.CONTRACT.NO
        IF YM.INT.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.ACCT = YFOR.FD
        END
        YM.INT.ACCT.CCY = YM.INT.ACCT
        IF YM.INT.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.INT.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.ACCT.CCY = YFOR.FD
        END
        YM.INT.ACCT = YM.CONTRACT.NO
        IF YM.INT.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.ACCT = YFOR.FD
        END
        IF (YM.TYPE.I <> "") AND ((YM.CONTRACT.CCY = YM.INT.ACCT.CCY) OR ((YM.INT.ACCT >= 1 AND YM.INT.ACCT <= 9))) THEN
            YTRUE.1 = 1
            YM.INT.RATE.CHECK = "FX NOT REQUIRED"
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.I = R.NEW(4)
        YM.INT.ACCT = YM.CONTRACT.NO
        IF YM.INT.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.ACCT = YFOR.FD
        END
        YM.INT.ACCT.CCY = YM.INT.ACCT
        IF YM.INT.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.INT.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.ACCT.CCY = YFOR.FD
        END
        YM.INT.FX.RATE = YM.CONTRACT.NO
        IF YM.INT.FX.RATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_58.1_":YM.INT.FX.RATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.FX.RATE = YFOR.FD
        END
        YM.INT.RATE.DUMMY = YM.INT.FX.RATE
        YM.INT.ACCT = YM.CONTRACT.NO
        IF YM.INT.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.ACCT = YFOR.FD
        END
        IF (YM.TYPE.I <> "") AND (YM.CONTRACT.CCY <> YM.INT.ACCT.CCY) AND (YM.INT.RATE.DUMMY = "") AND ((YM.INT.ACCT < 1 OR YM.INT.ACCT > 9)) THEN
            YTRUE.1 = 1
            YM.INT.RATE.CHECK = "INPUT MISSING"
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.I = R.NEW(4)
        YM.INT.ACCT = YM.CONTRACT.NO
        IF YM.INT.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.ACCT = YFOR.FD
        END
        YM.INT.ACCT.CCY = YM.INT.ACCT
        IF YM.INT.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.INT.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.ACCT.CCY = YFOR.FD
        END
        YM.INT.FX.RATE = YM.CONTRACT.NO
        IF YM.INT.FX.RATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_58.1_":YM.INT.FX.RATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.FX.RATE = YFOR.FD
        END
        YM.INT.RATE.DUMMY = YM.INT.FX.RATE
        YM.INT.ACCT = YM.CONTRACT.NO
        IF YM.INT.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.ACCT = YFOR.FD
        END
        IF (YM.TYPE.I <> "") AND (YM.INT.ACCT.CCY <> YM.CONTRACT.CCY) AND (YM.INT.RATE.DUMMY <> "") AND ((YM.INT.ACCT < 1 OR YM.INT.ACCT > 9)) THEN
            YTRUE.1 = 1
            YM.INT.FX.RATE = YM.CONTRACT.NO
            IF YM.INT.FX.RATE <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_58.1_":YM.INT.FX.RATE
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.INT.FX.RATE = YFOR.FD
            END
            YM.INT.RATE.CHECK = YM.INT.FX.RATE
        END
    END
    IF NOT(YTRUE.1) THEN YM.INT.RATE.CHECK = ""
    YM.INT.RATE.PRINT = YM.INT.RATE.CHECK
    YR.REC(5) = YM.INT.RATE.PRINT
    YTRUE.1 = 0
    YM.TYPE.C = R.NEW(8)
    IF YM.TYPE.C = "" THEN
        YTRUE.1 = 1
        YM.COM.RATE.CHECK = "NONE DUE TODAY"
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.C = R.NEW(8)
        YM.COM.ACCT = YM.CONTRACT.NO
        IF YM.COM.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.ACCT = YFOR.FD
        END
        YM.COM.ACCT.CCY = YM.COM.ACCT
        IF YM.COM.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.COM.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.ACCT.CCY = YFOR.FD
        END
        YM.COM.ACCT = YM.CONTRACT.NO
        IF YM.COM.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.ACCT = YFOR.FD
        END
        IF (YM.TYPE.C <> "") AND ((YM.CONTRACT.CCY = YM.COM.ACCT.CCY) OR ((YM.COM.ACCT >= 1 AND YM.COM.ACCT <= 9))) THEN
            YTRUE.1 = 1
            YM.COM.RATE.CHECK = "FX NOT REQUIRED"
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.C = R.NEW(8)
        YM.COM.ACCT = YM.CONTRACT.NO
        IF YM.COM.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.ACCT = YFOR.FD
        END
        YM.COM.ACCT.CCY = YM.COM.ACCT
        IF YM.COM.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.COM.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.ACCT.CCY = YFOR.FD
        END
        YM.COM.FX.RATE = YM.CONTRACT.NO
        IF YM.COM.FX.RATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_58.2_":YM.COM.FX.RATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.FX.RATE = YFOR.FD
        END
        YM.COM.RATE.DUMMY = YM.COM.FX.RATE
        YM.COM.ACCT = YM.CONTRACT.NO
        IF YM.COM.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.ACCT = YFOR.FD
        END
        IF (YM.TYPE.C <> "") AND (YM.CONTRACT.CCY <> YM.COM.ACCT.CCY) AND (YM.COM.RATE.DUMMY = "") AND ((YM.COM.ACCT < 1 OR YM.COM.ACCT > 9)) THEN
            YTRUE.1 = 1
            YM.COM.RATE.CHECK = "INPUT MISSING"
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.C = R.NEW(8)
        YM.COM.ACCT = YM.CONTRACT.NO
        IF YM.COM.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.ACCT = YFOR.FD
        END
        YM.COM.ACCT.CCY = YM.COM.ACCT
        IF YM.COM.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.COM.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.ACCT.CCY = YFOR.FD
        END
        YM.COM.FX.RATE = YM.CONTRACT.NO
        IF YM.COM.FX.RATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_58.2_":YM.COM.FX.RATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.FX.RATE = YFOR.FD
        END
        YM.COM.RATE.DUMMY = YM.COM.FX.RATE
        YM.COM.ACCT = YM.CONTRACT.NO
        IF YM.COM.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.ACCT = YFOR.FD
        END
        IF (YM.TYPE.C <> "") AND (YM.CONTRACT.CCY <> YM.COM.ACCT.CCY) AND (YM.COM.RATE.DUMMY <> "") AND ((YM.COM.ACCT < 1 OR YM.COM.ACCT > 9)) THEN
            YTRUE.1 = 1
            YM.COM.FX.RATE = YM.CONTRACT.NO
            IF YM.COM.FX.RATE <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_58.2_":YM.COM.FX.RATE
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.COM.FX.RATE = YFOR.FD
            END
            YM.COM.RATE.CHECK = YM.COM.FX.RATE
        END
    END
    IF NOT(YTRUE.1) THEN YM.COM.RATE.CHECK = ""
    YM.COM.RATE.PRINT = YM.COM.RATE.CHECK
    YR.REC(6) = YM.COM.RATE.PRINT
    YTRUE.1 = 0
    YM.TYPE.F = R.NEW(12)
    IF YM.TYPE.F = "" THEN
        YTRUE.1 = 1
        YM.FEE.RATE.CHECK = "NONE DUE TODAY"
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.F = R.NEW(12)
        YM.FEE.ACCT = YM.CONTRACT.NO
        IF YM.FEE.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.ACCT = YFOR.FD
        END
        YM.FEE.ACCT.CCY = YM.FEE.ACCT
        IF YM.FEE.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.FEE.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.ACCT.CCY = YFOR.FD
        END
        YM.FEE.ACCT = YM.CONTRACT.NO
        IF YM.FEE.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.ACCT = YFOR.FD
        END
        IF (YM.TYPE.F <> "") AND ((YM.CONTRACT.CCY = YM.FEE.ACCT.CCY) OR ((YM.FEE.ACCT >= 1 AND YM.FEE.ACCT <= 9))) THEN
            YTRUE.1 = 1
            YM.FEE.RATE.CHECK = "FX NOT REQUIRED"
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.F = R.NEW(12)
        YM.FEE.ACCT = YM.CONTRACT.NO
        IF YM.FEE.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.ACCT = YFOR.FD
        END
        YM.FEE.ACCT.CCY = YM.FEE.ACCT
        IF YM.FEE.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.FEE.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.ACCT.CCY = YFOR.FD
        END
        YM.FEE.FX.RATE = YM.CONTRACT.NO
        IF YM.FEE.FX.RATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_58.3_":YM.FEE.FX.RATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.FX.RATE = YFOR.FD
        END
        YM.FEE.RATE.DUMMY = YM.FEE.FX.RATE
        YM.FEE.ACCT = YM.CONTRACT.NO
        IF YM.FEE.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.ACCT = YFOR.FD
        END
        IF (YM.TYPE.F <> "") AND (YM.CONTRACT.CCY <> YM.FEE.ACCT.CCY) AND (YM.FEE.RATE.DUMMY = "") AND ((YM.FEE.ACCT < 1 OR YM.FEE.ACCT > 9)) THEN
            YTRUE.1 = 1
            YM.FEE.RATE.CHECK = "INPUT MISSING"
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.F = R.NEW(12)
        YM.FEE.ACCT = YM.CONTRACT.NO
        IF YM.FEE.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.ACCT = YFOR.FD
        END
        YM.FEE.ACCT.CCY = YM.FEE.ACCT
        IF YM.FEE.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.FEE.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.ACCT.CCY = YFOR.FD
        END
        YM.FEE.FX.RATE = YM.CONTRACT.NO
        IF YM.FEE.FX.RATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_58.3_":YM.FEE.FX.RATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.FX.RATE = YFOR.FD
        END
        YM.FEE.RATE.DUMMY = YM.FEE.FX.RATE
        YM.FEE.ACCT = YM.CONTRACT.NO
        IF YM.FEE.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.ACCT = YFOR.FD
        END
        IF (YM.TYPE.F <> "") AND (YM.CONTRACT.CCY <> YM.FEE.ACCT.CCY) AND (YM.FEE.RATE.DUMMY <> "") AND ((YM.FEE.ACCT < 1 OR YM.FEE.ACCT > 9)) THEN
            YTRUE.1 = 1
            YM.FEE.FX.RATE = YM.CONTRACT.NO
            IF YM.FEE.FX.RATE <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_58.3_":YM.FEE.FX.RATE
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.FEE.FX.RATE = YFOR.FD
            END
            YM.FEE.RATE.CHECK = YM.FEE.FX.RATE
        END
    END
    IF NOT(YTRUE.1) THEN YM.FEE.RATE.CHECK = ""
    YM.FEE.RATE.PRINT = YM.FEE.RATE.CHECK
    YR.REC(7) = YM.FEE.RATE.PRINT
    YTRUE.1 = 0
    YM.TYPE.P = R.NEW(2)
    YM.DRAW.ACCT = YM.CONTRACT.NO
    IF YM.DRAW.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.DRAW.ACCT = YFOR.FD
    END
    YM.DRAW.ACCT.CCY = YM.DRAW.ACCT
    IF YM.DRAW.ACCT.CCY <> "" THEN
        YCOMP = "ACCOUNT_8_":YM.DRAW.ACCT.CCY
        YFORFIL = YF.ACCOUNT
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.DRAW.ACCT.CCY = YFOR.FD
    END
    YM.DRAW.ACCT = YM.CONTRACT.NO
    IF YM.DRAW.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.DRAW.ACCT = YFOR.FD
    END
    YM.PRINC.FX.RATE = YM.CONTRACT.NO
    IF YM.PRINC.FX.RATE <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_54_":YM.PRINC.FX.RATE
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.PRINC.FX.RATE = YFOR.FD
    END
    YM.PRINC.RATE.DUMMY = YM.PRINC.FX.RATE
    YM.CONTRACT.STATUS = YM.CONTRACT.NO
    IF YM.CONTRACT.STATUS <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_90_":YM.CONTRACT.STATUS
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.CONTRACT.STATUS = YFOR.FD
    END
    YM.VALUE.DATE = YM.CONTRACT.NO
    IF YM.VALUE.DATE <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_6_":YM.VALUE.DATE
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.VALUE.DATE = YFOR.FD
    END
    YM.AMT.INCREASE.DATE = YM.CONTRACT.NO
    IF YM.AMT.INCREASE.DATE <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_128_":YM.AMT.INCREASE.DATE
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.AMT.INCREASE.DATE = YFOR.FD
    END
    YM.AMT.INCREASE = YM.CONTRACT.NO
    IF YM.AMT.INCREASE <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_127_":YM.AMT.INCREASE
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.AMT.INCREASE = YFOR.FD
    END
    IF (YM.TYPE.P <> "") AND (YM.CONTRACT.CCY <> YM.DRAW.ACCT.CCY) AND ((YM.DRAW.ACCT < 1 OR YM.DRAW.ACCT > 9)) AND (YM.PRINC.RATE.DUMMY <> "") AND ((YM.CONTRACT.STATUS = "FWD" AND YM.VALUE.DATE = YM.EVENT.DATE) OR (YM.AMT.INCREASE.DATE = YM.EVENT.DATE AND YM.AMT.INCREASE <> "")) THEN
        YTRUE.1 = 1
        YM.PRINC.VAL.DATE = YM.CONTRACT.NO
        IF YM.PRINC.VAL.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_55_":YM.PRINC.VAL.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.VAL.DATE = YFOR.FD
        END
        YM.PRINC.DATE.CHECK = YM.PRINC.VAL.DATE
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.P = R.NEW(2)
        YM.DRAW.ACCT = YM.CONTRACT.NO
        IF YM.DRAW.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT = YFOR.FD
        END
        YM.DRAW.ACCT.CCY = YM.DRAW.ACCT
        IF YM.DRAW.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.DRAW.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT.CCY = YFOR.FD
        END
        YM.DRAW.ACCT = YM.CONTRACT.NO
        IF YM.DRAW.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT = YFOR.FD
        END
        YM.PRINC.FX.RATE = YM.CONTRACT.NO
        IF YM.PRINC.FX.RATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_54_":YM.PRINC.FX.RATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.FX.RATE = YFOR.FD
        END
        YM.PRINC.RATE.DUMMY = YM.PRINC.FX.RATE
        YM.CONTRACT.STATUS = YM.CONTRACT.NO
        IF YM.CONTRACT.STATUS <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_90_":YM.CONTRACT.STATUS
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.CONTRACT.STATUS = YFOR.FD
        END
        YM.VALUE.DATE = YM.CONTRACT.NO
        IF YM.VALUE.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_6_":YM.VALUE.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.VALUE.DATE = YFOR.FD
        END
        YM.AMT.INCREASE = YM.CONTRACT.NO
        IF YM.AMT.INCREASE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_127_":YM.AMT.INCREASE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.AMT.INCREASE = YFOR.FD
        END
        YM.AMT.INCREASE.DATE = YM.CONTRACT.NO
        IF YM.AMT.INCREASE.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_128_":YM.AMT.INCREASE.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.AMT.INCREASE.DATE = YFOR.FD
        END
        IF (YM.TYPE.P <> "") AND (YM.CONTRACT.CCY <> YM.DRAW.ACCT.CCY) AND ((YM.DRAW.ACCT < 1 OR YM.DRAW.ACCT > 9)) AND (YM.PRINC.RATE.DUMMY = "") AND ((YM.CONTRACT.STATUS = "FWD" AND YM.VALUE.DATE = YM.EVENT.DATE) OR (YM.AMT.INCREASE <> "" AND YM.AMT.INCREASE.DATE = YM.EVENT.DATE)) THEN
            YTRUE.1 = 1
            YM.PRINC.DATE.CHECK = "USE DEFAULT"
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.P = R.NEW(2)
        YM.PRINC.ACCT = YM.CONTRACT.NO
        IF YM.PRINC.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT = YFOR.FD
        END
        YM.PRINC.ACCT.CCY = YM.PRINC.ACCT
        IF YM.PRINC.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.PRINC.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT.CCY = YFOR.FD
        END
        YM.PRINC.FX.RATE = YM.CONTRACT.NO
        IF YM.PRINC.FX.RATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_54_":YM.PRINC.FX.RATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.FX.RATE = YFOR.FD
        END
        YM.PRINC.RATE.DUMMY = YM.PRINC.FX.RATE
        YM.PRINC.ACCT = YM.CONTRACT.NO
        IF YM.PRINC.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT = YFOR.FD
        END
        IF (YM.TYPE.P <> "") AND (YM.CONTRACT.CCY <> YM.PRINC.ACCT.CCY) AND (YM.PRINC.RATE.DUMMY <> "") AND ((YM.PRINC.ACCT < 1 OR YM.PRINC.ACCT > 9)) THEN
            YTRUE.1 = 1
            YM.PRINC.VAL.DATE = YM.CONTRACT.NO
            IF YM.PRINC.VAL.DATE <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_55_":YM.PRINC.VAL.DATE
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.PRINC.VAL.DATE = YFOR.FD
            END
            YM.PRINC.DATE.CHECK = YM.PRINC.VAL.DATE
        END
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.P = R.NEW(2)
        YM.PRINC.ACCT = YM.CONTRACT.NO
        IF YM.PRINC.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT = YFOR.FD
        END
        YM.PRINC.ACCT.CCY = YM.PRINC.ACCT
        IF YM.PRINC.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.PRINC.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT.CCY = YFOR.FD
        END
        YM.PRINC.FX.RATE = YM.CONTRACT.NO
        IF YM.PRINC.FX.RATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_54_":YM.PRINC.FX.RATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.FX.RATE = YFOR.FD
        END
        YM.PRINC.RATE.DUMMY = YM.PRINC.FX.RATE
        YM.PRINC.ACCT = YM.CONTRACT.NO
        IF YM.PRINC.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT = YFOR.FD
        END
        IF (YM.TYPE.P <> "") AND (YM.CONTRACT.CCY <> YM.PRINC.ACCT.CCY) AND (YM.PRINC.RATE.DUMMY = "") AND ((YM.PRINC.ACCT < 1 OR YM.PRINC.ACCT > 9)) THEN
            YTRUE.1 = 1
            YM.PRINC.DATE.CHECK = "USE DEFAULT"
        END
    END
    IF NOT(YTRUE.1) THEN YM.PRINC.DATE.CHECK = ""
    YM.PRINC.DATE.PRINT = YM.PRINC.DATE.CHECK
    YR.REC(8) = YM.PRINC.DATE.PRINT
    YTRUE.1 = 0
    YM.TYPE.I = R.NEW(4)
    YM.INT.ACCT = YM.CONTRACT.NO
    IF YM.INT.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.ACCT = YFOR.FD
    END
    YM.INT.ACCT.CCY = YM.INT.ACCT
    IF YM.INT.ACCT.CCY <> "" THEN
        YCOMP = "ACCOUNT_8_":YM.INT.ACCT.CCY
        YFORFIL = YF.ACCOUNT
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.ACCT.CCY = YFOR.FD
    END
    YM.INT.FX.RATE = YM.CONTRACT.NO
    IF YM.INT.FX.RATE <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_58.1_":YM.INT.FX.RATE
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.FX.RATE = YFOR.FD
    END
    YM.INT.RATE.DUMMY = YM.INT.FX.RATE
    YM.INT.ACCT = YM.CONTRACT.NO
    IF YM.INT.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.ACCT = YFOR.FD
    END
    IF (YM.TYPE.I <> "") AND (YM.INT.ACCT.CCY <> YM.CONTRACT.CCY) AND (YM.INT.RATE.DUMMY <> "") AND ((YM.INT.ACCT < 1 OR YM.INT.ACCT > 9)) THEN
        YTRUE.1 = 1
        YM.INT.VAL.DATE = YM.CONTRACT.NO
        IF YM.INT.VAL.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_59.1_":YM.INT.VAL.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.VAL.DATE = YFOR.FD
        END
        YM.INT.DATE.CHECK = YM.INT.VAL.DATE
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.I = R.NEW(4)
        YM.INT.ACCT = YM.CONTRACT.NO
        IF YM.INT.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.ACCT = YFOR.FD
        END
        YM.INT.ACCT.CCY = YM.INT.ACCT
        IF YM.INT.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.INT.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.ACCT.CCY = YFOR.FD
        END
        YM.INT.FX.RATE = YM.CONTRACT.NO
        IF YM.INT.FX.RATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_58.1_":YM.INT.FX.RATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.FX.RATE = YFOR.FD
        END
        YM.INT.RATE.DUMMY = YM.INT.FX.RATE
        YM.INT.ACCT = YM.CONTRACT.NO
        IF YM.INT.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.ACCT = YFOR.FD
        END
        IF (YM.TYPE.I <> "") AND (YM.CONTRACT.CCY <> YM.INT.ACCT.CCY) AND (YM.INT.RATE.DUMMY = "") AND ((YM.INT.ACCT < 1 OR YM.INT.ACCT > 9)) THEN
            YTRUE.1 = 1
            YM.INT.DATE.CHECK = "USE DEFAULT"
        END
    END
    IF NOT(YTRUE.1) THEN YM.INT.DATE.CHECK = ""
    YM.INT.DATE.PRINT = YM.INT.DATE.CHECK
    YR.REC(9) = YM.INT.DATE.PRINT
    YTRUE.1 = 0
    YM.TYPE.C = R.NEW(8)
    YM.COM.ACCT = YM.CONTRACT.NO
    IF YM.COM.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.COM.ACCT = YFOR.FD
    END
    YM.COM.ACCT.CCY = YM.COM.ACCT
    IF YM.COM.ACCT.CCY <> "" THEN
        YCOMP = "ACCOUNT_8_":YM.COM.ACCT.CCY
        YFORFIL = YF.ACCOUNT
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.COM.ACCT.CCY = YFOR.FD
    END
    YM.COM.FX.RATE = YM.CONTRACT.NO
    IF YM.COM.FX.RATE <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_58.2_":YM.COM.FX.RATE
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.COM.FX.RATE = YFOR.FD
    END
    YM.COM.RATE.DUMMY = YM.COM.FX.RATE
    YM.COM.ACCT = YM.CONTRACT.NO
    IF YM.COM.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.COM.ACCT = YFOR.FD
    END
    IF (YM.TYPE.C <> "") AND (YM.CONTRACT.CCY <> YM.COM.ACCT.CCY) AND (YM.COM.RATE.DUMMY <> "") AND ((YM.COM.ACCT < 1 OR YM.COM.ACCT > 9)) THEN
        YTRUE.1 = 1
        YM.COM.VAL.DATE = YM.CONTRACT.NO
        IF YM.COM.VAL.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_59.2_":YM.COM.VAL.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.VAL.DATE = YFOR.FD
        END
        YM.COM.DATE.CHECK = YM.COM.VAL.DATE
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.C = R.NEW(8)
        YM.COM.ACCT = YM.CONTRACT.NO
        IF YM.COM.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.ACCT = YFOR.FD
        END
        YM.COM.ACCT.CCY = YM.COM.ACCT
        IF YM.COM.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.COM.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.ACCT.CCY = YFOR.FD
        END
        YM.COM.FX.RATE = YM.CONTRACT.NO
        IF YM.COM.FX.RATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_58.2_":YM.COM.FX.RATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.FX.RATE = YFOR.FD
        END
        YM.COM.RATE.DUMMY = YM.COM.FX.RATE
        YM.COM.ACCT = YM.CONTRACT.NO
        IF YM.COM.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.ACCT = YFOR.FD
        END
        IF (YM.TYPE.C <> "") AND (YM.CONTRACT.CCY <> YM.COM.ACCT.CCY) AND (YM.COM.RATE.DUMMY = "") AND ((YM.COM.ACCT < 1 OR YM.COM.ACCT > 9)) THEN
            YTRUE.1 = 1
            YM.COM.DATE.CHECK = "USE DEFAULT"
        END
    END
    IF NOT(YTRUE.1) THEN YM.COM.DATE.CHECK = ""
    YM.COM.DATE.PRINT = YM.COM.DATE.CHECK
    YR.REC(10) = YM.COM.DATE.PRINT
    YTRUE.1 = 0
    YM.TYPE.F = R.NEW(12)
    YM.FEE.ACCT = YM.CONTRACT.NO
    IF YM.FEE.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.FEE.ACCT = YFOR.FD
    END
    YM.FEE.ACCT.CCY = YM.FEE.ACCT
    IF YM.FEE.ACCT.CCY <> "" THEN
        YCOMP = "ACCOUNT_8_":YM.FEE.ACCT.CCY
        YFORFIL = YF.ACCOUNT
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.FEE.ACCT.CCY = YFOR.FD
    END
    YM.FEE.FX.RATE = YM.CONTRACT.NO
    IF YM.FEE.FX.RATE <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_58.3_":YM.FEE.FX.RATE
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.FEE.FX.RATE = YFOR.FD
    END
    YM.FEE.RATE.DUMMY = YM.FEE.FX.RATE
    YM.FEE.ACCT = YM.CONTRACT.NO
    IF YM.FEE.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.FEE.ACCT = YFOR.FD
    END
    IF (YM.TYPE.F <> "") AND (YM.CONTRACT.CCY <> YM.FEE.ACCT.CCY) AND (YM.FEE.RATE.DUMMY <> "") AND ((YM.FEE.ACCT < 1 OR YM.FEE.ACCT > 9)) THEN
        YTRUE.1 = 1
        YM.FEE.VAL.DATE = YM.CONTRACT.NO
        IF YM.FEE.VAL.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_59.3_":YM.FEE.VAL.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.VAL.DATE = YFOR.FD
        END
        YM.FEE.DATE.CHECK = YM.FEE.VAL.DATE
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.F = R.NEW(12)
        YM.FEE.ACCT = YM.CONTRACT.NO
        IF YM.FEE.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.ACCT = YFOR.FD
        END
        YM.FEE.ACCT.CCY = YM.FEE.ACCT
        IF YM.FEE.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.FEE.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.ACCT.CCY = YFOR.FD
        END
        YM.FEE.FX.RATE = YM.CONTRACT.NO
        IF YM.FEE.FX.RATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_58.3_":YM.FEE.FX.RATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.FX.RATE = YFOR.FD
        END
        YM.FEE.RATE.DUMMY = YM.FEE.FX.RATE
        YM.FEE.ACCT = YM.CONTRACT.NO
        IF YM.FEE.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.ACCT = YFOR.FD
        END
        IF (YM.TYPE.F <> "") AND (YM.CONTRACT.CCY <> YM.FEE.ACCT.CCY) AND (YM.FEE.RATE.DUMMY = "") AND ((YM.FEE.ACCT < 1 OR YM.FEE.ACCT > 9)) THEN
            YTRUE.1 = 1
            YM.FEE.DATE.CHECK = "USE DEFAULT"
        END
    END
    IF NOT(YTRUE.1) THEN YM.FEE.DATE.CHECK = ""
    YM.FEE.DATE.PRINT = YM.FEE.DATE.CHECK
    YR.REC(11) = YM.FEE.DATE.PRINT
    YTRUE.1 = 0
    YM.TYPE.P = R.NEW(2)
    YM.PRINC.ACCT = YM.CONTRACT.NO
    IF YM.PRINC.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.PRINC.ACCT = YFOR.FD
    END
    YM.PRINC.ACCT.CCY = YM.PRINC.ACCT
    IF YM.PRINC.ACCT.CCY <> "" THEN
        YCOMP = "ACCOUNT_8_":YM.PRINC.ACCT.CCY
        YFORFIL = YF.ACCOUNT
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.PRINC.ACCT.CCY = YFOR.FD
    END
    YM.PRINC.ACCT = YM.CONTRACT.NO
    IF YM.PRINC.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.PRINC.ACCT = YFOR.FD
    END
    IF (YM.TYPE.P <> "") AND (YM.CONTRACT.CCY <> YM.PRINC.ACCT.CCY) AND ((YM.PRINC.ACCT < 1 OR YM.PRINC.ACCT > 9)) THEN
        YTRUE.1 = 1
        YM.PRINC.ACCT = YM.CONTRACT.NO
        IF YM.PRINC.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT = YFOR.FD
        END
        YM.PRINC.ACCT.DUMMY = YM.PRINC.ACCT
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.P = R.NEW(2)
        YM.DRAW.ACCT = YM.CONTRACT.NO
        IF YM.DRAW.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT = YFOR.FD
        END
        YM.DRAW.ACCT.CCY = YM.DRAW.ACCT
        IF YM.DRAW.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.DRAW.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT.CCY = YFOR.FD
        END
        YM.DRAW.ACCT = YM.CONTRACT.NO
        IF YM.DRAW.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT = YFOR.FD
        END
        YM.CONTRACT.STATUS = YM.CONTRACT.NO
        IF YM.CONTRACT.STATUS <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_90_":YM.CONTRACT.STATUS
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.CONTRACT.STATUS = YFOR.FD
        END
        YM.VALUE.DATE = YM.CONTRACT.NO
        IF YM.VALUE.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_6_":YM.VALUE.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.VALUE.DATE = YFOR.FD
        END
        YM.AMT.INCREASE = YM.CONTRACT.NO
        IF YM.AMT.INCREASE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_127_":YM.AMT.INCREASE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.AMT.INCREASE = YFOR.FD
        END
        YM.AMT.INCREASE.DATE = YM.CONTRACT.NO
        IF YM.AMT.INCREASE.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_128_":YM.AMT.INCREASE.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.AMT.INCREASE.DATE = YFOR.FD
        END
        IF (YM.TYPE.P <> "") AND (YM.CONTRACT.CCY <> YM.DRAW.ACCT.CCY) AND ((YM.DRAW.ACCT < 1 OR YM.DRAW.ACCT > 9)) AND ((YM.CONTRACT.STATUS = "FWD" AND YM.VALUE.DATE = YM.EVENT.DATE) OR (YM.AMT.INCREASE <> "" AND YM.AMT.INCREASE.DATE = YM.EVENT.DATE)) THEN
            YTRUE.1 = 1
            YM.DRAW.ACCT = YM.CONTRACT.NO
            IF YM.DRAW.ACCT <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.DRAW.ACCT = YFOR.FD
            END
            YM.PRINC.ACCT.DUMMY = YM.DRAW.ACCT
        END
    END
    IF NOT(YTRUE.1) THEN YM.PRINC.ACCT.DUMMY = ""
    YM.PRINC.ACCT.PRINT = YM.PRINC.ACCT.DUMMY
    YR.REC(12) = YM.PRINC.ACCT.PRINT
    YTRUE.1 = 0
    YM.TYPE.I = R.NEW(4)
    YM.INT.ACCT = YM.CONTRACT.NO
    IF YM.INT.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.ACCT = YFOR.FD
    END
    YM.INT.ACCT.CCY = YM.INT.ACCT
    IF YM.INT.ACCT.CCY <> "" THEN
        YCOMP = "ACCOUNT_8_":YM.INT.ACCT.CCY
        YFORFIL = YF.ACCOUNT
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.ACCT.CCY = YFOR.FD
    END
    YM.INT.ACCT = YM.CONTRACT.NO
    IF YM.INT.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.ACCT = YFOR.FD
    END
    IF (YM.TYPE.I <> "") AND (YM.CONTRACT.CCY <> YM.INT.ACCT.CCY) AND ((YM.INT.ACCT < 1 OR YM.INT.ACCT > 9)) THEN
        YTRUE.1 = 1
        YM.INT.ACCT = YM.CONTRACT.NO
        IF YM.INT.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.ACCT = YFOR.FD
        END
        YM.INT.ACCT.PRINT = YM.INT.ACCT
    END
    IF NOT(YTRUE.1) THEN YM.INT.ACCT.PRINT = ""
    YR.REC(13) = YM.INT.ACCT.PRINT
    YTRUE.1 = 0
    YM.TYPE.C = R.NEW(8)
    YM.COM.ACCT = YM.CONTRACT.NO
    IF YM.COM.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.COM.ACCT = YFOR.FD
    END
    YM.COM.ACCT.CCY = YM.COM.ACCT
    IF YM.COM.ACCT.CCY <> "" THEN
        YCOMP = "ACCOUNT_8_":YM.COM.ACCT.CCY
        YFORFIL = YF.ACCOUNT
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.COM.ACCT.CCY = YFOR.FD
    END
    YM.COM.ACCT = YM.CONTRACT.NO
    IF YM.COM.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.COM.ACCT = YFOR.FD
    END
    IF (YM.TYPE.C <> "") AND (YM.CONTRACT.CCY <> YM.COM.ACCT.CCY) AND ((YM.COM.ACCT < 1 OR YM.COM.ACCT > 9)) THEN
        YTRUE.1 = 1
        YM.COM.ACCT = YM.CONTRACT.NO
        IF YM.COM.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.ACCT = YFOR.FD
        END
        YM.COM.ACCT.PRINT = YM.COM.ACCT
    END
    IF NOT(YTRUE.1) THEN YM.COM.ACCT.PRINT = ""
    YR.REC(14) = YM.COM.ACCT.PRINT
    YTRUE.1 = 0
    YM.TYPE.F = R.NEW(12)
    YM.FEE.ACCT = YM.CONTRACT.NO
    IF YM.FEE.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.FEE.ACCT = YFOR.FD
    END
    YM.FEE.ACCT.CCY = YM.FEE.ACCT
    IF YM.FEE.ACCT.CCY <> "" THEN
        YCOMP = "ACCOUNT_8_":YM.FEE.ACCT.CCY
        YFORFIL = YF.ACCOUNT
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.FEE.ACCT.CCY = YFOR.FD
    END
    YM.FEE.ACCT = YM.CONTRACT.NO
    IF YM.FEE.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.FEE.ACCT = YFOR.FD
    END
    IF (YM.TYPE.F <> "") AND (YM.CONTRACT.CCY <> YM.FEE.ACCT.CCY) AND ((YM.FEE.ACCT < 1 OR YM.FEE.ACCT > 9)) THEN
        YTRUE.1 = 1
        YM.FEE.ACCT = YM.CONTRACT.NO
        IF YM.FEE.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.ACCT = YFOR.FD
        END
        YM.FEE.ACCT.PRINT = YM.FEE.ACCT
    END
    IF NOT(YTRUE.1) THEN YM.FEE.ACCT.PRINT = ""
    YR.REC(15) = YM.FEE.ACCT.PRINT
    YTRUE.1 = 0
    YM.TYPE.P = R.NEW(2)
    YM.PRINC.ACCT = YM.CONTRACT.NO
    IF YM.PRINC.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.PRINC.ACCT = YFOR.FD
    END
    YM.PRINC.ACCT.CCY = YM.PRINC.ACCT
    IF YM.PRINC.ACCT.CCY <> "" THEN
        YCOMP = "ACCOUNT_8_":YM.PRINC.ACCT.CCY
        YFORFIL = YF.ACCOUNT
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.PRINC.ACCT.CCY = YFOR.FD
    END
    YM.PRINC.ACCT = YM.CONTRACT.NO
    IF YM.PRINC.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.PRINC.ACCT = YFOR.FD
    END
    IF (YM.TYPE.P <> "") AND (YM.CONTRACT.CCY <> YM.PRINC.ACCT.CCY) AND ((YM.PRINC.ACCT < 1 OR YM.PRINC.ACCT > 9)) THEN
        YTRUE.1 = 1
        YM.PRINC.ACCT = YM.CONTRACT.NO
        IF YM.PRINC.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_67_":YM.PRINC.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT = YFOR.FD
        END
        YM.PRINC.ACCT.CCY = YM.PRINC.ACCT
        IF YM.PRINC.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.PRINC.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.PRINC.ACCT.CCY = YFOR.FD
        END
        YM.PRINC.CCY.DUMMY = YM.PRINC.ACCT.CCY
    END
    IF NOT(YTRUE.1) THEN
        YM.TYPE.P = R.NEW(2)
        YM.DRAW.ACCT = YM.CONTRACT.NO
        IF YM.DRAW.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT = YFOR.FD
        END
        YM.DRAW.ACCT.CCY = YM.DRAW.ACCT
        IF YM.DRAW.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.DRAW.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT.CCY = YFOR.FD
        END
        YM.DRAW.ACCT = YM.CONTRACT.NO
        IF YM.DRAW.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DRAW.ACCT = YFOR.FD
        END
        YM.CONTRACT.STATUS = YM.CONTRACT.NO
        IF YM.CONTRACT.STATUS <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_90_":YM.CONTRACT.STATUS
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.CONTRACT.STATUS = YFOR.FD
        END
        YM.VALUE.DATE = YM.CONTRACT.NO
        IF YM.VALUE.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_6_":YM.VALUE.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.VALUE.DATE = YFOR.FD
        END
        YM.AMT.INCREASE = YM.CONTRACT.NO
        IF YM.AMT.INCREASE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_127_":YM.AMT.INCREASE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.AMT.INCREASE = YFOR.FD
        END
        YM.AMT.INCREASE.DATE = YM.CONTRACT.NO
        IF YM.AMT.INCREASE.DATE <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_128_":YM.AMT.INCREASE.DATE
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.AMT.INCREASE.DATE = YFOR.FD
        END
        IF (YM.TYPE.P <> "") AND (YM.CONTRACT.CCY <> YM.DRAW.ACCT.CCY) AND ((YM.DRAW.ACCT < 1 OR YM.DRAW.ACCT > 9)) AND ((YM.CONTRACT.STATUS = "FWD" AND YM.VALUE.DATE = YM.EVENT.DATE) OR (YM.AMT.INCREASE <> "" AND YM.AMT.INCREASE.DATE = YM.EVENT.DATE)) THEN
            YTRUE.1 = 1
            YM.DRAW.ACCT = YM.CONTRACT.NO
            IF YM.DRAW.ACCT <> "" THEN
                YCOMP = "LD.LOANS.AND.DEPOSITS_12_":YM.DRAW.ACCT
                YFORFIL = YF.LD.LOANS.AND.DEPOSITS
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.DRAW.ACCT = YFOR.FD
            END
            YM.DRAW.ACCT.CCY = YM.DRAW.ACCT
            IF YM.DRAW.ACCT.CCY <> "" THEN
                YCOMP = "ACCOUNT_8_":YM.DRAW.ACCT.CCY
                YFORFIL = YF.ACCOUNT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.DRAW.ACCT.CCY = YFOR.FD
            END
            YM.PRINC.CCY.DUMMY = YM.DRAW.ACCT.CCY
        END
    END
    IF NOT(YTRUE.1) THEN YM.PRINC.CCY.DUMMY = ""
    YM.PRINC.CCY.PRINT = YM.PRINC.CCY.DUMMY
    YR.REC(16) = YM.PRINC.CCY.PRINT
    YTRUE.1 = 0
    YM.TYPE.I = R.NEW(4)
    YM.INT.ACCT = YM.CONTRACT.NO
    IF YM.INT.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.ACCT = YFOR.FD
    END
    YM.INT.ACCT.CCY = YM.INT.ACCT
    IF YM.INT.ACCT.CCY <> "" THEN
        YCOMP = "ACCOUNT_8_":YM.INT.ACCT.CCY
        YFORFIL = YF.ACCOUNT
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.ACCT.CCY = YFOR.FD
    END
    YM.INT.ACCT = YM.CONTRACT.NO
    IF YM.INT.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.INT.ACCT = YFOR.FD
    END
    IF (YM.TYPE.I <> "") AND (YM.CONTRACT.CCY <> YM.INT.ACCT.CCY) AND ((YM.INT.ACCT < 1 OR YM.INT.ACCT > 9)) THEN
        YTRUE.1 = 1
        YM.INT.ACCT = YM.CONTRACT.NO
        IF YM.INT.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_72_":YM.INT.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.ACCT = YFOR.FD
        END
        YM.INT.ACCT.CCY = YM.INT.ACCT
        IF YM.INT.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.INT.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.INT.ACCT.CCY = YFOR.FD
        END
        YM.INT.CCY.PRINT = YM.INT.ACCT.CCY
    END
    IF NOT(YTRUE.1) THEN YM.INT.CCY.PRINT = ""
    YR.REC(17) = YM.INT.CCY.PRINT
    YTRUE.1 = 0
    YM.TYPE.C = R.NEW(8)
    YM.COM.ACCT = YM.CONTRACT.NO
    IF YM.COM.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.COM.ACCT = YFOR.FD
    END
    YM.COM.ACCT.CCY = YM.COM.ACCT
    IF YM.COM.ACCT.CCY <> "" THEN
        YCOMP = "ACCOUNT_8_":YM.COM.ACCT.CCY
        YFORFIL = YF.ACCOUNT
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.COM.ACCT.CCY = YFOR.FD
    END
    YM.COM.ACCT = YM.CONTRACT.NO
    IF YM.COM.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.COM.ACCT = YFOR.FD
    END
    IF (YM.TYPE.C <> "") AND (YM.CONTRACT.CCY <> YM.COM.ACCT.CCY) AND ((YM.COM.ACCT < 1 OR YM.COM.ACCT > 9)) THEN
        YTRUE.1 = 1
        YM.COM.ACCT = YM.CONTRACT.NO
        IF YM.COM.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_77_":YM.COM.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.ACCT = YFOR.FD
        END
        YM.COM.ACCT.CCY = YM.COM.ACCT
        IF YM.COM.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.COM.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.COM.ACCT.CCY = YFOR.FD
        END
        YM.COM.CCY.PRINT = YM.COM.ACCT.CCY
    END
    IF NOT(YTRUE.1) THEN YM.COM.CCY.PRINT = ""
    YR.REC(18) = YM.COM.CCY.PRINT
    YTRUE.1 = 0
    YM.TYPE.F = R.NEW(12)
    YM.FEE.ACCT = YM.CONTRACT.NO
    IF YM.FEE.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.FEE.ACCT = YFOR.FD
    END
    YM.FEE.ACCT.CCY = YM.FEE.ACCT
    IF YM.FEE.ACCT.CCY <> "" THEN
        YCOMP = "ACCOUNT_8_":YM.FEE.ACCT.CCY
        YFORFIL = YF.ACCOUNT
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.FEE.ACCT.CCY = YFOR.FD
    END
    YM.FEE.ACCT = YM.CONTRACT.NO
    IF YM.FEE.ACCT <> "" THEN
        YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
        YFORFIL = YF.LD.LOANS.AND.DEPOSITS
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.FEE.ACCT = YFOR.FD
    END
    IF (YM.TYPE.F <> "") AND (YM.CONTRACT.CCY <> YM.FEE.ACCT.CCY) AND ((YM.FEE.ACCT < 1 OR YM.FEE.ACCT > 9)) THEN
        YTRUE.1 = 1
        YM.FEE.ACCT = YM.CONTRACT.NO
        IF YM.FEE.ACCT <> "" THEN
            YCOMP = "LD.LOANS.AND.DEPOSITS_78_":YM.FEE.ACCT
            YFORFIL = YF.LD.LOANS.AND.DEPOSITS
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.ACCT = YFOR.FD
        END
        YM.FEE.ACCT.CCY = YM.FEE.ACCT
        IF YM.FEE.ACCT.CCY <> "" THEN
            YCOMP = "ACCOUNT_8_":YM.FEE.ACCT.CCY
            YFORFIL = YF.ACCOUNT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.FEE.ACCT.CCY = YFOR.FD
        END
        YM.FEE.CCY.PRINT = YM.FEE.ACCT.CCY
    END
    IF NOT(YTRUE.1) THEN YM.FEE.CCY.PRINT = ""
    YR.REC(19) = YM.FEE.CCY.PRINT
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
