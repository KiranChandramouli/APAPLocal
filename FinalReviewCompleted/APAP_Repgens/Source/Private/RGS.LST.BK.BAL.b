<<<<<<< Updated upstream
<<<<<<< Updated upstream
* @ValidationCode : Mjo3NTM3ODEzNjU6Q3AxMjUyOjE2ODg1MzY4OTk5OTk6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jul 2023 11:31:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
=======
=======
>>>>>>> Stashed changes
* @ValidationCode : Mjo3NTM3ODEzNjU6Q3AxMjUyOjE2ODY5MTgxNjQ5OTM6SVRTUzE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 Jun 2023 17:52:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
<<<<<<< Updated upstream
<<<<<<< Updated upstream
* @ValidationInfo : Strict flag       : true
=======
* @ValidationInfo : Strict flag       : N/A
>>>>>>> Stashed changes
=======
* @ValidationInfo : Strict flag       : N/A
>>>>>>> Stashed changes
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.Repgens
SUBROUTINE RGS.LST.BK.BAL
REM "RGS.LST.BK.BAL",230614-4
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
    YF.VOC = ""
    OPEN "", "VOC" TO YF.VOC ELSE
        TEXT = "CANNOT OPEN VOC-FILE"
        CALL FATAL.ERROR ("RGS.LST.BK.BAL")
    END
*************************************************************************
    YT.SMS.COMP = ID.COMPANY
    YT.SMS.FILE = "ACCOUNT"
    YT.SMS.FILE<-1> = "CURRENCY"
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
    DIM YR.REC(17)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.LST.BK.BAL"
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
        CALL FATAL.ERROR ("RGS.LST.BK.BAL")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "ACCOUNT"
    YT.SMS.FILE<-1> = "CURRENCY"
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
    YFILE = "F.CURRENCY"; YF.CURRENCY = ""
    CALL OPF (YFILE, YF.CURRENCY)
*************************************************************************
    YFILE = "ACCOUNT"
    FULL.FNAME = "F.ACCOUNT"; YF.ACCOUNT = ""
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
    CALL OPF (FULL.FNAME, YF.ACCOUNT)
    fldName = '' ; dataType = '' ; errMsg = ''
    CALL FIELD.NUMBERS.TO.NAMES('2',SS.REC,fldName,dataType,errMsg)
    fldName2 = '' ; dataType2 = '' ; errMsg2 = ''
    CALL FIELD.NUMBERS.TO.NAMES('23',SS.REC,fldName2,dataType2,errMsg2)
    CLEARSELECT
    YSEL.A = ""
    IF C$MULTI.BOOK AND COMP.FOUND THEN
        YSEL.A = " AND CO.CODE EQUAL ":ID.COMPANY
    END
    EXECUTE "HUSH ON"
    EXECUTE 'SELECT ':FULL.FNAME:' WITH ':fldName:' >= "05000" AND ':fldName:' <= "05200" AND ':fldName2:' <> ""':YSEL.A
    EXECUTE "HUSH OFF"
    CALL EB.READLIST('', YID.LIST, '', '', '')
    LOOP
        REMOVE ID.NEW FROM YID.LIST SETTING YDELIM
    WHILE ID.NEW:YDELIM
        MATREAD R.NEW FROM YF.ACCOUNT, ID.NEW ELSE ID.NEW = "" ; MAT R.NEW = ""
        IF T.PWD THEN
            CALL CONTROL.USER.PROFILE ("RECORD")
            IF ETEXT THEN ID.NEW = ""
        END
        IF ID.NEW <> "" THEN
*
* Handle Decision Table
            GOSUB 2000000
        END
*
    REPEAT
    IF YKEYNO THEN
        YR.REC(17)  := @FM
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
    YM.CCYSORT = R.NEW(8)
    YKEYFD = YM.CCYSORT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

    FULL.TXN.ID = ""
    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

    YKEYFD = FMT(YM.CCYSORT,"5L")


    IF LEN(YKEYFD) > 5 THEN YKEYFD = YKEYFD[1,4]:"|"
    GOSUB 8000000
    YM.CATEGSORT = R.NEW(2)
    YKEYFD = YM.CATEGSORT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

    FULL.TXN.ID = ""
    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

    YKEYFD = FMT(YM.CATEGSORT,"8L")


    IF LEN(YKEYFD) > 8 THEN YKEYFD = YKEYFD[1,7]:"|"
    GOSUB 8000000
    YM.ACCTSORT = R.NEW(6)
    YKEYFD = YM.ACCTSORT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

    FULL.TXN.ID = ""
    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

    YKEYFD = FMT(YM.ACCTSORT,"12L")


    IF LEN(YKEYFD) > 12 THEN YKEYFD = YKEYFD[1,11]:"|"
    GOSUB 8000000
    YM.TOT1 = R.NEW(2)
    YR.REC(1) = YM.TOT1
    YM.TOT2 = R.NEW(8)
    YR.REC(2) = YM.TOT2
    YM.ACCTNO = R.NEW(6)
    YR.REC(3) = YM.ACCTNO
    YM.CATEG = R.NEW(2)
    YR.REC(4) = YM.CATEG
    YM.CCY = R.NEW(8)
    YR.REC(5) = YM.CCY
    YTRUE.1 = 0
    YM.CCYBAL = R.NEW(23)
    IF YM.CCYBAL < 0 AND YM.CCYBAL THEN
        YTRUE.1 = 1
        YM.DRCCYBAL = R.NEW(23)
    END
    IF NOT(YTRUE.1) THEN YM.DRCCYBAL = ""
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCYSORT, YDEC)
    IF YM.DRCCYBAL <> "" THEN
        YM.DRCCYBAL = TRIM(FMT(YM.DRCCYBAL,"19R":YDEC))
    END
    YR.REC(6) = YM.DRCCYBAL
    YM.DRTOTCCY = YM.DRCCYBAL
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCYSORT, YDEC)
    IF YM.DRTOTCCY <> "" THEN
        YM.DRTOTCCY = TRIM(FMT(YM.DRTOTCCY,"19R":YDEC))
    END
    YR.REC(7) = YM.DRTOTCCY
    YTRUE.1 = 0
    YM.CCYBAL = R.NEW(23)
    IF YM.CCYBAL < 0 AND YM.CCYBAL THEN
        YTRUE.1 = 1
        YTRUE.2 = 0
        IF YM.CCY = "CHF" THEN
            YTRUE.2 = 1
            YM.RATE = "1.00"
        END
        IF NOT(YTRUE.2) THEN
            IF YM.CCY <> "CHF" THEN
                YTRUE.2 = 1
                YM.RATEWRK = R.NEW(8)
                IF YM.RATEWRK <> "" THEN
                    YCOMP = "CURRENCY_14.1_":YM.RATEWRK
                    YFORFIL = YF.CURRENCY
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.RATEWRK = YFOR.FD
                END
                YM.RATE = YM.RATEWRK
            END
        END
        IF NOT(YTRUE.2) THEN YM.RATE = ""
        YM.DRRATE = YM.RATE
    END
    IF NOT(YTRUE.1) THEN YM.DRRATE = ""
    YR.REC(8) = YM.DRRATE
    YTRUE.1 = 0
    IF YM.CCY = "CHF" THEN
        YTRUE.1 = 1
        YM.RATE = "1.00"
    END
    IF NOT(YTRUE.1) THEN
        IF YM.CCY <> "CHF" THEN
            YTRUE.1 = 1
            YM.RATEWRK = R.NEW(8)
            IF YM.RATEWRK <> "" THEN
                YCOMP = "CURRENCY_14.1_":YM.RATEWRK
                YFORFIL = YF.CURRENCY
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.RATEWRK = YFOR.FD
            END
            YM.RATE = YM.RATEWRK
        END
    END
    IF NOT(YTRUE.1) THEN YM.RATE = ""
    YM.DRTOTRATE = YM.RATE
    YR.REC(9) = YM.DRTOTRATE
    YTRUE.1 = 0
    YM.CCYBAL = R.NEW(23)
    IF YM.CCYBAL < 0 AND YM.CCYBAL THEN
        YTRUE.1 = 1
        YM.LCYBAL = R.NEW(23)
        YM1.LCYBAL = YM.LCYBAL
        YM.LCYBAL = YM.RATE
        IF NUM(YM1.LCYBAL) = NUMERIC THEN IF NUM(YM.LCYBAL) = NUMERIC THEN
            PRECISION 6; YFD = YM1.LCYBAL * YM.LCYBAL
            YM1.LCYBAL = OCONV(ICONV(YFD,'MD9'),'MD9'); PRECISION 6
            IF YM1.LCYBAL = 0 THEN YM1.LCYBAL = ""
        END
        YM.LCYBAL = YM1.LCYBAL
        YM.DRLCYBAL = YM.LCYBAL
    END
    IF NOT(YTRUE.1) THEN YM.DRLCYBAL = ""
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCYSORT, YDEC)
    IF YM.DRLCYBAL <> "" THEN
        YM.DRLCYBAL = TRIM(FMT(YM.DRLCYBAL,"19R":YDEC))
    END
    YR.REC(10) = YM.DRLCYBAL
    YM.DRLCYTOT = YM.DRLCYBAL
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCYSORT, YDEC)
    IF YM.DRLCYTOT <> "" THEN
        YM.DRLCYTOT = TRIM(FMT(YM.DRLCYTOT,"19R":YDEC))
    END
    YR.REC(11) = YM.DRLCYTOT
    YTRUE.1 = 0
    YM.CCYBAL = R.NEW(23)
    IF YM.CCYBAL > 0 THEN
        YTRUE.1 = 1
        YM.CRCCYBAL = R.NEW(23)
    END
    IF NOT(YTRUE.1) THEN YM.CRCCYBAL = ""
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCYSORT, YDEC)
    IF YM.CRCCYBAL <> "" THEN
        YM.CRCCYBAL = TRIM(FMT(YM.CRCCYBAL,"19R":YDEC))
    END
    YR.REC(12) = YM.CRCCYBAL
    YM.CRCCYTOT = YM.CRCCYBAL
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCYSORT, YDEC)
    IF YM.CRCCYTOT <> "" THEN
        YM.CRCCYTOT = TRIM(FMT(YM.CRCCYTOT,"19R":YDEC))
    END
    YR.REC(13) = YM.CRCCYTOT
    YTRUE.1 = 0
    YM.CCYBAL = R.NEW(23)
    IF YM.CCYBAL > 0 THEN
        YTRUE.1 = 1
        YM.CRRATE = YM.RATE
    END
    IF NOT(YTRUE.1) THEN YM.CRRATE = ""
    YR.REC(14) = YM.CRRATE
    YM.CRTOTRATE = YM.RATE
    YR.REC(15) = YM.CRTOTRATE
    YTRUE.1 = 0
    YM.CCYBAL = R.NEW(23)
    IF YM.CCYBAL > 0 THEN
        YTRUE.1 = 1
        YM.LCYBAL = R.NEW(23)
        YM1.LCYBAL = YM.LCYBAL
        YM.LCYBAL = YM.RATE
        IF NUM(YM1.LCYBAL) = NUMERIC THEN IF NUM(YM.LCYBAL) = NUMERIC THEN
            PRECISION 6; YFD = YM1.LCYBAL * YM.LCYBAL
            YM1.LCYBAL = OCONV(ICONV(YFD,'MD9'),'MD9'); PRECISION 6
            IF YM1.LCYBAL = 0 THEN YM1.LCYBAL = ""
        END
        YM.LCYBAL = YM1.LCYBAL
        YM.CRLCYBAL = YM.LCYBAL
    END
    IF NOT(YTRUE.1) THEN YM.CRLCYBAL = ""
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCYSORT, YDEC)
    IF YM.CRLCYBAL <> "" THEN
        YM.CRLCYBAL = TRIM(FMT(YM.CRLCYBAL,"19R":YDEC))
    END
    YR.REC(16) = YM.CRLCYBAL
    YM.CRLCYTOT = YM.CRLCYBAL
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCYSORT, YDEC)
    IF YM.CRLCYTOT <> "" THEN
        YM.CRLCYTOT = TRIM(FMT(YM.CRLCYTOT,"19R":YDEC))
    END
    YR.REC(17) = YM.CRLCYTOT
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
