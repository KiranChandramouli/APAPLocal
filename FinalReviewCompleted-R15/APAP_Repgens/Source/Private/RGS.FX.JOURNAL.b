$PACKAGE APAP.Repgens

SUBROUTINE RGS.FX.JOURNAL
REM "RGS.FX.JOURNAL",230614-4
*--------------------------------------------------------------------------------------
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
    YT.SMS.FILE = "STMT.ENTRY"
    YT.SMS.FILE<-1> = "TRANSACTION"
    YT.SMS.FILE<-1> = "ACCOUNT"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "FCCY.TODAY"
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
    DIM YR.REC(11)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.FX.JOURNAL"
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
        CALL FATAL.ERROR ("RGS.FX.JOURNAL")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "STMT.ENTRY"
    YT.SMS.FILE<-1> = "TRANSACTION"
    YT.SMS.FILE<-1> = "ACCOUNT"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "FCCY.TODAY"
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
    YFILE = "F.TRANSACTION"; YF.TRANSACTION = ""
    CALL OPF (YFILE, YF.TRANSACTION)
    YFILE = "F.ACCOUNT"; YF.ACCOUNT = ""
    CALL OPF (YFILE, YF.ACCOUNT)
    YFILE = "F.CUSTOMER"; YF.CUSTOMER = ""
    CALL OPF (YFILE, YF.CUSTOMER)
*************************************************************************
    YFILE = "FCCY.TODAY"
    FULL.FNAME = "F.FCCY.TODAY"; YF.FCCY.TODAY = ""
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
    CALL OPF (FULL.FNAME, YF.FCCY.TODAY)
    CLEARSELECT
    IF C$MULTI.BOOK AND COMP.FOUND THEN
        SEL.ARGS = " WITH CO.CODE EQUAL ":ID.COMPANY
    END ELSE
        SEL.ARGS = ""
    END
    SELECT.CMMD = "SELECT ":FULL.FNAME:SEL.ARGS
    CALL EB.READLIST(SELECT.CMMD,YID.LIST,"","","")
    YFILE = "STMT.ENTRY"
    FULL.FNAME = "F.STMT.ENTRY"; YF.STMT.ENTRY = ""
    LOCATE YFILE IN YT.SMS<1,1> SETTING X ELSE
        X = 0; T.PWD = ""
    END
    IF X THEN
        T.PWD = YT.SMS<2,X>
        CONVERT @SM TO @FM IN T.PWD
    END
    CALL OPF (FULL.FNAME, YF.STMT.ENTRY)
    LOOP
        REMOVE WR.NEW FROM YID.LIST SETTING YDELIM
    WHILE WR.NEW:YDELIM
        READ YR.KEYS FROM YF.FCCY.TODAY, WR.NEW ELSE YR.KEYS = ""
        LOOP UNTIL YR.KEYS = "" DO
            ID.NEW = YR.KEYS<1>; DEL YR.KEYS<1>
            MATREAD R.NEW FROM YF.STMT.ENTRY, ID.NEW ELSE ID.NEW = "" ; MAT R.NEW = ""
            IF T.PWD THEN
                CALL CONTROL.USER.PROFILE ("RECORD")
                IF ETEXT THEN ID.NEW = ""
            END
            IF ID.NEW <> "" THEN
*
* Handle Decision Table
                YM.KURS = R.NEW(14)
                IF YM.KURS <> "" THEN
                    GOSUB 2000000
                END
            END
        REPEAT
*
    REPEAT
    IF YKEYNO THEN
        YR.REC(11)  := @FM
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
    YM.TRANSAKT.NR = R.NEW(23)
    YR.REC(1) = YM.TRANSAKT.NR
    YM.CURRENCY = R.NEW(12)
    YKEYFD = YM.CURRENCY

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

    FULL.TXN.ID = ""
    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

    YKEYFD = FMT(YM.CURRENCY,"5L")


    IF LEN(YKEYFD) > 5 THEN YKEYFD = YKEYFD[1,4]:"|"
    GOSUB 8000000
    YM.TRANSAKT.TEXT = R.NEW(4)
    IF YM.TRANSAKT.TEXT <> "" THEN
        YCOMP = "TRANSACTION_1_":YM.TRANSAKT.TEXT
        YFORFIL = YF.TRANSACTION
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
        YM.TRANSAKT.TEXT = YFOR.FD
    END
    YR.REC(2) = YM.TRANSAKT.TEXT
    YM.ABT = R.NEW(22)
    YKEYFD = YM.ABT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

    FULL.TXN.ID = ""
    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

    YKEYFD = FMT(YM.ABT,"6L")


    IF LEN(YKEYFD) > 6 THEN YKEYFD = YKEYFD[1,5]:"|"
    GOSUB 8000000
    YR.REC(3) = YM.ABT
    YM.FREMD = YM.CURRENCY
    YR.REC(4) = YM.FREMD
    YM.FREMDWHRG.BETRAG = R.NEW(13)
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURRENCY, YDEC)
    IF YM.FREMDWHRG.BETRAG <> "" THEN
        YM.FREMDWHRG.BETRAG = TRIM(FMT(YM.FREMDWHRG.BETRAG,"19R":YDEC))
    END
    YR.REC(5) = YM.FREMDWHRG.BETRAG
    YM.KURS = R.NEW(14)
    YR.REC(6) = YM.KURS
    YM.LOKALWHRG.BTR = R.NEW(3)
    YM.LOCAL.CCY = "CHF"
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.LOCAL.CCY, YDEC)
    IF YM.LOKALWHRG.BTR <> "" THEN
        YM.LOKALWHRG.BTR = TRIM(FMT(YM.LOKALWHRG.BTR,"19R":YDEC))
    END
    YR.REC(7) = YM.LOKALWHRG.BTR
    YM.VALUTA.DATUM = R.NEW(11)
    YR.REC(8) = YM.VALUTA.DATUM
    YM.CUSTOMER.ID = R.NEW(1)
    IF YM.CUSTOMER.ID <> "" THEN
        YCOMP = "ACCOUNT_1_":YM.CUSTOMER.ID
        YFORFIL = YF.ACCOUNT
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.CUSTOMER.ID = YFOR.FD
    END
    YM.KUNDE.BANK = YM.CUSTOMER.ID
    IF YM.KUNDE.BANK <> "" THEN
        YCOMP = "CUSTOMER_2_":YM.KUNDE.BANK
        YFORFIL = YF.CUSTOMER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.KUNDE.BANK = YFOR.FD
    END
    YR.REC(9) = YM.KUNDE.BANK
    YM.TOTAL.FCCY = R.NEW(13)
    YR.REC(10) = YM.TOTAL.FCCY
    YM.TOTAL.LCY = R.NEW(3)
    YR.REC(11) = YM.TOTAL.LCY
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
