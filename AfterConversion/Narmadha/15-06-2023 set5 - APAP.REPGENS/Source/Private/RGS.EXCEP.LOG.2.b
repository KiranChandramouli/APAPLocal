* @ValidationCode : MjotMTc4Mzk1OTE4NzpVVEYtODoxNjg2ODIzMDc0MTk0OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Jun 2023 15:27:54
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.Repgens

SUBROUTINE RGS.EXCEP.LOG.2
REM "RGS.EXCEP.LOG.2",230614-4
*************************************************************************
* MODIFICATION HISTORY:

* DATE              WHO                REFERENCE                 DESCRIPTION
* 15-JUNE-2023     Narmadha V       Manual R22 conversion        No changes
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
    YT.SMS.FILE = "EXCEPTION.LOG.FILE"
    YT.SMS.FILE<-1> = "COMPANY"
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
    DIM YR.REC(12)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.EXCEP.LOG.2"
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
        CALL FATAL.ERROR ("RGS.EXCEP.LOG.2")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "EXCEPTION.LOG.FILE"
    YT.SMS.FILE<-1> = "COMPANY"
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
    YFILE = "F.COMPANY"; YF.COMPANY = ""
    CALL OPF (YFILE, YF.COMPANY)
*************************************************************************
    YFILE = "EXCEPTION.LOG.FILE"
    FULL.FNAME = "F.EXCEPTION.LOG.FILE"; YF.EXCEPTION.LOG.FILE = ""
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
    CALL OPF (FULL.FNAME, YF.EXCEPTION.LOG.FILE)
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
        MATREAD R.NEW FROM YF.EXCEPTION.LOG.FILE, ID.NEW ELSE ID.NEW = "" ; MAT R.NEW = ""
        IF T.PWD THEN
            CALL CONTROL.USER.PROFILE ("RECORD")
            IF ETEXT THEN ID.NEW = ""
        END
        IF ID.NEW <> "" THEN
*
* Handle Decision Table
            YM.KEY.APPLIC = FMT(R.NEW(8),"14L"); YM.KEY.APPLIC = YM.KEY.APPLIC[1,2]
            YM.START = "00001"
            YM.END = "99999"
            YM.KEY.DATE = FMT(R.NEW(8),"14L"); YM.KEY.DATE = YM.KEY.DATE[3,5]
            YM.KEY.COUNT = FMT(R.NEW(8),"14L"); YM.KEY.COUNT = YM.KEY.COUNT[8,5]
            YM.KEY1.APPLIC = FMT(R.NEW(8),"16L"); YM.KEY1.APPLIC = YM.KEY1.APPLIC[5,2]
            YM.KEY1.DATE = FMT(R.NEW(8),"16L"); YM.KEY1.DATE = YM.KEY1.DATE[7,5]
            YM.KEY1.COUNT = FMT(R.NEW(8),"16L"); YM.KEY1.COUNT = YM.KEY1.COUNT[12,5]
            IF ((YM.KEY.APPLIC < "AA" OR YM.KEY.APPLIC > "ZZ") OR (YM.KEY.DATE < YM.START OR YM.KEY.DATE > YM.END) OR (YM.KEY.COUNT < YM.START OR YM.KEY.COUNT > YM.END)) AND ((YM.KEY1.APPLIC < "AA" OR YM.KEY1.APPLIC > "ZZ") OR (YM.KEY1.DATE < YM.START OR YM.KEY1.DATE > YM.END) OR (YM.KEY1.COUNT < YM.START OR YM.KEY1.COUNT > YM.END)) THEN
                YGROUP = "1"; GOSUB 2000000
            END
1000:
            IF (YM.KEY.APPLIC >= "AA" AND YM.KEY.APPLIC <= "ZZ") AND (YM.KEY.DATE >= YM.START AND YM.KEY.DATE <= YM.END) AND (YM.KEY.COUNT >= YM.START AND YM.KEY.COUNT <= YM.END) THEN
                YGROUP = "2"; GOSUB 2000000
            END
1001:
            IF (YM.KEY1.APPLIC >= "AA" AND YM.KEY1.APPLIC <= "ZZ") AND (YM.KEY1.DATE >= YM.START AND YM.KEY1.DATE <= YM.END) AND (YM.KEY1.COUNT >= YM.START AND YM.KEY1.COUNT <= YM.END) THEN
                YGROUP = "3"; GOSUB 2000000
            END
1002:
        END
*
    REPEAT
    IF YKEYNO THEN
        YR.REC(12)  := @FM
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
    BEGIN CASE
        CASE YGROUP = "1"
            YKEY = "1"; MAT YR.REC = ""
            YM.COMPANY = R.NEW(12)
            IF YM.COMPANY <> "" THEN
                YCOMP = "COMPANY_1_":YM.COMPANY
                YFORFIL = YF.COMPANY
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.COMPANY = YFOR.FD
            END
            YKEYFD = YM.COMPANY

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.COMPANY,"24L")


            IF LEN(YKEYFD) > 24 THEN YKEYFD = YKEYFD[1,23]:"|"
            GOSUB 8000000
            YR.REC(1) = YM.COMPANY
            YM.APPLICATION = R.NEW(2)
            YKEYFD = YM.APPLICATION

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.APPLICATION,"5L")


            IF LEN(YKEYFD) > 5 THEN YKEYFD = YKEYFD[1,4]:"|"
            GOSUB 8000000
            YR.REC(2) = YM.APPLICATION
            YM.KEY = R.NEW(8)
            YKEYFD = YM.KEY

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.KEY,"32L")


            IF LEN(YKEYFD) > 32 THEN YKEYFD = YKEYFD[1,31]:"|"
            GOSUB 8000000
            YM.PRINT.KEY = R.NEW(8)
            YR.REC(3) = YM.PRINT.KEY
            YM.CURR.NO = R.NEW(9)
            YR.REC(4) = YM.CURR.NO
            YM.EOD.ROUTINE = R.NEW(3)
            YR.REC(5) = YM.EOD.ROUTINE
            YM.ERROR = R.NEW(1)
            YR.REC(6) = YM.ERROR
            YM.ERROR.CODE = R.NEW(5)
            YR.REC(7) = YM.ERROR.CODE
            YM.MESSAGE = R.NEW(10)
            YR.REC(8) = YM.MESSAGE
            YM.MODULE = R.NEW(4)
            YR.REC(9) = YM.MODULE
            YM.FILENAME = R.NEW(7)
            YR.REC(10) = YM.FILENAME
            YM.VALUE = R.NEW(6)
            YR.REC(11) = YM.VALUE
            YM.BLANK = " "
            YR.REC(12) = YM.BLANK
*
        CASE YGROUP = "2"
            YKEY = "2"; MAT YR.REC = ""
            YM.COMPANY = R.NEW(12)
            IF YM.COMPANY <> "" THEN
                YCOMP = "COMPANY_1_":YM.COMPANY
                YFORFIL = YF.COMPANY
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.COMPANY = YFOR.FD
            END
            YKEYFD = YM.COMPANY

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.COMPANY,"24L")


            IF LEN(YKEYFD) > 24 THEN YKEYFD = YKEYFD[1,23]:"|"
            GOSUB 8000000
            YR.REC(1) = YM.COMPANY
            YM.APPLICATION = R.NEW(2)
            YKEYFD = YM.APPLICATION

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.APPLICATION,"5L")


            IF LEN(YKEYFD) > 5 THEN YKEYFD = YKEYFD[1,4]:"|"
            GOSUB 8000000
            YR.REC(2) = YM.APPLICATION
            YM.KEY = R.NEW(8)
            YKEYFD = YM.KEY

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.KEY,"32L")


            IF LEN(YKEYFD) > 32 THEN YKEYFD = YKEYFD[1,31]:"|"
            GOSUB 8000000
            YTRUE.1 = 0
            YM.KEY.APPLIC = FMT(R.NEW(8),"14L"); YM.KEY.APPLIC = YM.KEY.APPLIC[1,2]
            YM.START = "00001"
            YM.END = "99999"
            YM.KEY.DATE = FMT(R.NEW(8),"14L"); YM.KEY.DATE = YM.KEY.DATE[3,5]
            YM.START = "00001"
            YM.END = "99999"
            YM.KEY.COUNT = FMT(R.NEW(8),"14L"); YM.KEY.COUNT = YM.KEY.COUNT[8,5]
            IF (YM.KEY.APPLIC >= "AA" AND YM.KEY.APPLIC <= "ZZ") AND (YM.KEY.DATE >= YM.START AND YM.KEY.DATE <= YM.END) AND (YM.KEY.COUNT >= YM.START AND YM.KEY.COUNT <= YM.END) THEN
                YTRUE.1 = 1
                YM.PRINT.KEY1 = R.NEW(8)
            END
            IF NOT(YTRUE.1) THEN YM.PRINT.KEY1 = ""
            YR.REC(3) = YM.PRINT.KEY1
            YM.CURR.NO = R.NEW(9)
            YR.REC(4) = YM.CURR.NO
            YM.EOD.ROUTINE = R.NEW(3)
            YR.REC(5) = YM.EOD.ROUTINE
            YM.ERROR = R.NEW(1)
            YR.REC(6) = YM.ERROR
            YM.ERROR.CODE = R.NEW(5)
            YR.REC(7) = YM.ERROR.CODE
            YM.MESSAGE = R.NEW(10)
            YR.REC(8) = YM.MESSAGE
            YM.MODULE = R.NEW(4)
            YR.REC(9) = YM.MODULE
            YM.FILENAME = R.NEW(7)
            YR.REC(10) = YM.FILENAME
            YM.VALUE = R.NEW(6)
            YR.REC(11) = YM.VALUE
            YM.BLANK = " "
            YR.REC(12) = YM.BLANK
*
        CASE YGROUP = "3"
            YKEY = "3"; MAT YR.REC = ""
            YM.COMPANY = R.NEW(12)
            IF YM.COMPANY <> "" THEN
                YCOMP = "COMPANY_1_":YM.COMPANY
                YFORFIL = YF.COMPANY
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.COMPANY = YFOR.FD
            END
            YKEYFD = YM.COMPANY

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.COMPANY,"24L")


            IF LEN(YKEYFD) > 24 THEN YKEYFD = YKEYFD[1,23]:"|"
            GOSUB 8000000
            YR.REC(1) = YM.COMPANY
            YM.APPLICATION = R.NEW(2)
            YKEYFD = YM.APPLICATION

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.APPLICATION,"5L")


            IF LEN(YKEYFD) > 5 THEN YKEYFD = YKEYFD[1,4]:"|"
            GOSUB 8000000
            YR.REC(2) = YM.APPLICATION
            YM.KEY = R.NEW(8)
            YKEYFD = YM.KEY

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.KEY,"32L")


            IF LEN(YKEYFD) > 32 THEN YKEYFD = YKEYFD[1,31]:"|"
            GOSUB 8000000
            YM.PRINT.KEY2 = R.NEW(8)
            YR.REC(3) = YM.PRINT.KEY2
            YM.CURR.NO = R.NEW(9)
            YR.REC(4) = YM.CURR.NO
            YM.EOD.ROUTINE = R.NEW(3)
            YR.REC(5) = YM.EOD.ROUTINE
            YM.ERROR = R.NEW(1)
            YR.REC(6) = YM.ERROR
            YM.ERROR.CODE = R.NEW(5)
            YR.REC(7) = YM.ERROR.CODE
            YM.MESSAGE = R.NEW(10)
            YR.REC(8) = YM.MESSAGE
            YM.MODULE = R.NEW(4)
            YR.REC(9) = YM.MODULE
            YM.FILENAME = R.NEW(7)
            YR.REC(10) = YM.FILENAME
            YM.VALUE = R.NEW(6)
            YR.REC(11) = YM.VALUE
            YM.BLANK = " "
            YR.REC(12) = YM.BLANK
    END CASE
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
