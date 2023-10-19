$PACKAGE APAP.Repgens
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*15-06-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE RGS.PROF2
REM "RGS.PROF2",230614-4
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
    YT.SMS.FILE = "CATEG.ENTRY"
    YT.SMS.FILE<-1> = "CATEGORY"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
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
    DIM YR.REC(9)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.PROF2"
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
        CALL FATAL.ERROR ("RGS.PROF2")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "CATEG.ENTRY"
    YT.SMS.FILE<-1> = "CATEGORY"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
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
    YFILE = "F.CATEGORY"; YF.CATEGORY = ""
    CALL OPF (YFILE, YF.CATEGORY)
    YFILE = "F.CUSTOMER"; YF.CUSTOMER = ""
    CALL OPF (YFILE, YF.CUSTOMER)
    YFILE = "F.DEPT.ACCT.OFFICER"; YF.DEPT.ACCT.OFFICER = ""
    CALL OPF (YFILE, YF.DEPT.ACCT.OFFICER)
*************************************************************************
    YFILE = "CATEG.ENTRY"
    FULL.FNAME = "F.CATEG.ENTRY"; YF.CATEG.ENTRY = ""
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
    CALL OPF (FULL.FNAME, YF.CATEG.ENTRY)
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
        MATREAD R.NEW FROM YF.CATEG.ENTRY, ID.NEW ELSE ID.NEW = "" ; MAT R.NEW = ""
        IF T.PWD THEN
            CALL CONTROL.USER.PROFILE ("RECORD")
            IF ETEXT THEN ID.NEW = ""
        END
        IF ID.NEW <> "" THEN
*
* Handle Decision Table
            YM.PLCATEG = R.NEW(7)
            IF YM.PLCATEG >= 50000 AND YM.PLCATEG < 60000 AND YM.PLCATEG THEN
                YGROUP = "1"; GOSUB 2000000
            END
1000:
            IF YM.PLCATEG >= 60000 AND YM.PLCATEG < 70000 AND YM.PLCATEG THEN
                YGROUP = "2"; GOSUB 2000000
            END
1001:
        END
*
    REPEAT
    IF YKEYNO THEN
        YR.REC(9)  := @FM
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
            YM.PLCATEG = R.NEW(7)
            YKEYFD = YM.PLCATEG

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.PLCATEG,"8L")


            IF LEN(YKEYFD) > 8 THEN YKEYFD = YKEYFD[1,7]:"|"
            GOSUB 8000000
            YR.REC(1) = YM.PLCATEG
            YM.CATEGNAME = R.NEW(7)
            IF YM.CATEGNAME <> "" THEN
                YCOMP = "CATEGORY_2_":YM.CATEGNAME
                YFORFIL = YF.CATEGORY
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.CATEGNAME = YFOR.FD
            END
            YR.REC(2) = YM.CATEGNAME
            YM.MONTH = FMT(R.NEW(25),"8L"); YM.MONTH = YM.MONTH[5,2]
            YKEYFD = YM.MONTH

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.MONTH,"4L")


            IF LEN(YKEYFD) > 4 THEN YKEYFD = YKEYFD[1,3]:"|"
            GOSUB 8000000
            YTRUE.1 = 0
            IF YM.PLCATEG >= 50000 AND YM.PLCATEG < 60000 AND YM.PLCATEG THEN
                YTRUE.1 = 1
                YTRUE.2 = 0
                IF YM.MONTH = 01 THEN
                    YTRUE.2 = 1
                    YM.MONTHNAME = "JANUARY"
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 02 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "FEBRUARY"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 03 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "MARCH"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 04 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "APRIL"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 05 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "MAY"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 06 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "JUNE"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 07 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "JULY"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 08 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "AUGUST"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 09 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "SEPTEMBER"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 10 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "OCTOBER"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 11 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "NOVEMBER"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 12 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "DECEMBER"
                    END
                END
                IF NOT(YTRUE.2) THEN YM.MONTHNAME = ""
                YM.MONTHIMP = YM.MONTHNAME
            END
            IF NOT(YTRUE.1) THEN YM.MONTHIMP = ""
            YKEYFD = YM.MONTHIMP

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.MONTHIMP,"12L")


            IF LEN(YKEYFD) > 12 THEN YKEYFD = YKEYFD[1,11]:"|"
            GOSUB 8000000
            YR.REC(3) = YM.MONTHIMP
            YTRUE.1 = 0
            IF YM.PLCATEG >= 50000 AND YM.PLCATEG < 60000 AND YM.PLCATEG THEN
                YTRUE.1 = 1
                YM.PRODUCT = FMT(R.NEW(24),"4L"); YM.PRODUCT = YM.PRODUCT[1,2]
            END
            IF NOT(YTRUE.1) THEN YM.PRODUCT = ""
            YKEYFD = YM.PRODUCT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.PRODUCT,"4L")


            IF LEN(YKEYFD) > 4 THEN YKEYFD = YKEYFD[1,3]:"|"
            GOSUB 8000000
            YR.REC(4) = YM.PRODUCT
            YTRUE.1 = 0
            IF YM.PLCATEG >= 50000 AND YM.PLCATEG < 60000 AND YM.PLCATEG THEN
                YTRUE.1 = 1
                YM.PRDCATEG = R.NEW(10)
            END
            IF NOT(YTRUE.1) THEN YM.PRDCATEG = ""
            YKEYFD = YM.PRDCATEG

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.PRDCATEG,"8L")


            IF LEN(YKEYFD) > 8 THEN YKEYFD = YKEYFD[1,7]:"|"
            GOSUB 8000000
            YR.REC(5) = YM.PRDCATEG
            YTRUE.1 = 0
            IF YM.PLCATEG >= 50000 AND YM.PLCATEG < 60000 AND YM.PLCATEG THEN
                YTRUE.1 = 1
                YM.SECTOR = R.NEW(8)
                IF YM.SECTOR <> "" THEN
                    YCOMP = "CUSTOMER_10_":YM.SECTOR
                    YFORFIL = YF.CUSTOMER
                    YPART.S = 1; YPART.L = 1; YFD.LEN = "4L"; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.SECTOR = YFOR.FD
                END
                YM.SECTORX = YM.SECTOR
            END
            IF NOT(YTRUE.1) THEN YM.SECTORX = ""
            YKEYFD = YM.SECTORX

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.SECTORX,"3L")


            IF LEN(YKEYFD) > 3 THEN YKEYFD = YKEYFD[1,2]:"|"
            GOSUB 8000000
            YTRUE.1 = 0
            IF YM.PLCATEG >= 50000 AND YM.PLCATEG < 60000 AND YM.PLCATEG THEN
                YTRUE.1 = 1
                YTRUE.2 = 0
                IF YM.SECTORX <> 3 THEN
                    YTRUE.2 = 1
                    YM.WSECTOR = "CUSTOMERS"
                END
                IF NOT(YTRUE.2) THEN
                    YM.SECTOR = R.NEW(8)
                    IF YM.SECTOR <> "" THEN
                        YCOMP = "CUSTOMER_10_":YM.SECTOR
                        YFORFIL = YF.CUSTOMER
                        YPART.S = 1; YPART.L = 1; YFD.LEN = "4L"; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.SECTOR = YFOR.FD
                    END
                    IF YM.SECTOR = 3 THEN
                        YTRUE.2 = 1
                        YM.WSECTOR = "BANKS"
                    END
                END
                IF NOT(YTRUE.2) THEN YM.WSECTOR = ""
                YM.SECTORIMP = YM.WSECTOR
            END
            IF NOT(YTRUE.1) THEN YM.SECTORIMP = ""
            YR.REC(6) = YM.SECTORIMP
            YM.CCY = R.NEW(12)
            YKEYFD = YM.CCY

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.CCY,"5L")


            IF LEN(YKEYFD) > 5 THEN YKEYFD = YKEYFD[1,4]:"|"
            GOSUB 8000000
            YR.REC(7) = YM.CCY
            YTRUE.1 = 0
            IF YM.PLCATEG >= 50000 AND YM.PLCATEG < 60000 AND YM.PLCATEG THEN
                YTRUE.1 = 1
                YM.KEY1 = YM.MONTH
                YM1.KEY1 = YM.KEY1
                YM.KEY1 = YM.PRODUCT
                YM1.KEY1 = YM1.KEY1 : YM.KEY1
                YM.KEY1 = YM1.KEY1
                YM.KEY2 = YM.KEY1
                YM1.KEY2 = YM.KEY2
                YM.KEY2 = YM.PRDCATEG
                YM1.KEY2 = YM1.KEY2 : YM.KEY2
                YM.KEY2 = YM1.KEY2
                YM.KEY3 = YM.KEY2
                YM1.KEY3 = YM.KEY3
                YM.SECTOR = R.NEW(8)
                IF YM.SECTOR <> "" THEN
                    YCOMP = "CUSTOMER_10_":YM.SECTOR
                    YFORFIL = YF.CUSTOMER
                    YPART.S = 1; YPART.L = 1; YFD.LEN = "4L"; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.SECTOR = YFOR.FD
                END
                YM.KEY3 = YM.SECTOR
                YM1.KEY3 = YM1.KEY3 : YM.KEY3
                YM.KEY3 = YM1.KEY3
                YM.KEY4 = YM.KEY3
                YM1.KEY4 = YM.KEY4
                YM.KEY4 = YM.CCY
                YM1.KEY4 = YM1.KEY4 : YM.KEY4
                YM.KEY4 = YM1.KEY4
                YM.KEY4X = YM.KEY4
            END
            IF NOT(YTRUE.1) THEN YM.KEY4X = ""
            YKEYFD = YM.KEY4X

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.KEY4X,"15L")


            IF LEN(YKEYFD) > 15 THEN YKEYFD = YKEYFD[1,14]:"|"
            GOSUB 8000000
            YTRUE.1 = 0
            IF YM.CCY = "CHF" THEN
                YTRUE.1 = 1
                YM.AMOUNT.ME = ""
            END
            IF NOT(YTRUE.1) THEN
                IF YM.CCY <> "CHF" THEN
                    YTRUE.1 = 1
                    YM.AMOUNT.ME = R.NEW(13)
                END
            END
            IF NOT(YTRUE.1) THEN YM.AMOUNT.ME = ""
            YM.AMOUNT.ME.IMP = YM.AMOUNT.ME
            YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
            IF YM.AMOUNT.ME.IMP <> "" THEN
                YM.AMOUNT.ME.IMP = TRIM(FMT(YM.AMOUNT.ME.IMP,"19R":YDEC))
            END
            YR.REC(8) = YM.AMOUNT.ME.IMP
            YM.AMOUNT.ML = R.NEW(3)
            YR.REC(9) = YM.AMOUNT.ML
*
        CASE YGROUP = "2"
            YKEY = "2"; MAT YR.REC = ""
            YM.PLCATEG = R.NEW(7)
            YKEYFD = YM.PLCATEG

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.PLCATEG,"8L")


            IF LEN(YKEYFD) > 8 THEN YKEYFD = YKEYFD[1,7]:"|"
            GOSUB 8000000
            YR.REC(1) = YM.PLCATEG
            YM.CATEGNAME = R.NEW(7)
            IF YM.CATEGNAME <> "" THEN
                YCOMP = "CATEGORY_2_":YM.CATEGNAME
                YFORFIL = YF.CATEGORY
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.CATEGNAME = YFOR.FD
            END
            YR.REC(2) = YM.CATEGNAME
            YM.MONTH = FMT(R.NEW(25),"8L"); YM.MONTH = YM.MONTH[5,2]
            YKEYFD = YM.MONTH

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.MONTH,"4L")


            IF LEN(YKEYFD) > 4 THEN YKEYFD = YKEYFD[1,3]:"|"
            GOSUB 8000000
            YTRUE.1 = 0
            IF YM.PLCATEG >= 50000 AND YM.PLCATEG < 60000 AND YM.PLCATEG THEN
                YTRUE.1 = 1
                YTRUE.2 = 0
                IF YM.MONTH = 01 THEN
                    YTRUE.2 = 1
                    YM.MONTHNAME = "JANUARY"
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 02 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "FEBRUARY"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 03 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "MARCH"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 04 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "APRIL"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 05 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "MAY"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 06 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "JUNE"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 07 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "JULY"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 08 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "AUGUST"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 09 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "SEPTEMBER"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 10 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "OCTOBER"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 11 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "NOVEMBER"
                    END
                END
                IF NOT(YTRUE.2) THEN
                    IF YM.MONTH = 12 THEN
                        YTRUE.2 = 1
                        YM.MONTHNAME = "DECEMBER"
                    END
                END
                IF NOT(YTRUE.2) THEN YM.MONTHNAME = ""
                YM.MONTHIMP = YM.MONTHNAME
            END
            IF NOT(YTRUE.1) THEN YM.MONTHIMP = ""
            YKEYFD = YM.MONTHIMP

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.MONTHIMP,"12L")


            IF LEN(YKEYFD) > 12 THEN YKEYFD = YKEYFD[1,11]:"|"
            GOSUB 8000000
            YR.REC(3) = YM.MONTHIMP
            YTRUE.1 = 0
            IF YM.PLCATEG >= 60000 AND YM.PLCATEG < 70000 AND YM.PLCATEG THEN
                YTRUE.1 = 1
                YM.ACCTOFF = R.NEW(9)
            END
            IF NOT(YTRUE.1) THEN YM.ACCTOFF = ""
            YKEYFD = YM.ACCTOFF

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.ACCTOFF,"6L")


            IF LEN(YKEYFD) > 6 THEN YKEYFD = YKEYFD[1,5]:"|"
            GOSUB 8000000
            YR.REC(4) = YM.ACCTOFF
            YM.ACCTOFF.NAME = YM.ACCTOFF
            IF YM.ACCTOFF.NAME <> "" THEN
                YCOMP = "DEPT.ACCT.OFFICER_1_":YM.ACCTOFF.NAME
                YFORFIL = YF.DEPT.ACCT.OFFICER
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.ACCTOFF.NAME = YFOR.FD
            END
            YR.REC(5) = YM.ACCTOFF.NAME
            YM.CCY = R.NEW(12)
            YKEYFD = YM.CCY

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.CCY,"5L")


            IF LEN(YKEYFD) > 5 THEN YKEYFD = YKEYFD[1,4]:"|"
            GOSUB 8000000
            YR.REC(6) = YM.CCY
            YTRUE.1 = 0
            IF YM.PLCATEG >= 60000 AND YM.PLCATEG < 70000 AND YM.PLCATEG THEN
                YTRUE.1 = 1
                YM.KEYA = YM.MONTH
                YM1.KEYA = YM.KEYA
                YM.KEYA = YM.ACCTOFF
                YM1.KEYA = YM1.KEYA : YM.KEYA
                YM.KEYA = YM1.KEYA
                YM.KEYB = YM.KEYA
                YM1.KEYB = YM.KEYB
                YM.KEYB = YM.CCY
                YM1.KEYB = YM1.KEYB : YM.KEYB
                YM.KEYB = YM1.KEYB
                YM.KEYY = YM.KEYB
            END
            IF NOT(YTRUE.1) THEN YM.KEYY = ""
            YKEYFD = YM.KEYY

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.KEYY,"12L")


            IF LEN(YKEYFD) > 12 THEN YKEYFD = YKEYFD[1,11]:"|"
            GOSUB 8000000
            YTRUE.1 = 0
            IF YM.CCY = "CHF" THEN
                YTRUE.1 = 1
                YM.AMOUNT.ME = ""
            END
            IF NOT(YTRUE.1) THEN
                IF YM.CCY <> "CHF" THEN
                    YTRUE.1 = 1
                    YM.AMOUNT.ME = R.NEW(13)
                END
            END
            IF NOT(YTRUE.1) THEN YM.AMOUNT.ME = ""
            YM.AMOUNT.ME.IMP = YM.AMOUNT.ME
            YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
            IF YM.AMOUNT.ME.IMP <> "" THEN
                YM.AMOUNT.ME.IMP = TRIM(FMT(YM.AMOUNT.ME.IMP,"19R":YDEC))
            END
            YR.REC(7) = YM.AMOUNT.ME.IMP
            YM.AMOUNT.ML = R.NEW(3)
            YR.REC(8) = YM.AMOUNT.ML
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
