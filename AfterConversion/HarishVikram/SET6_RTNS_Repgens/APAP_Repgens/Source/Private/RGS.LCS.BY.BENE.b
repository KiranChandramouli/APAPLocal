* @ValidationCode : MjoyMDI0MDI2OTk2OkNwMTI1MjoxNjg4NDY3MjkyNjU4OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Jul 2023 16:11:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.Repgens
*-----------------------------------------------------------------------------
* <Rating>4424</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-07-2023      Harishvikram C   Manual R22 conversion      FM TO @FM, VM to @VM, SM to @SM
*-----------------------------------------------------------------------------------------------
SUBROUTINE RGS.LCS.BY.BENE
REM "RGS.LCS.BY.BENE",040129-3
*************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_RC.COMMON
    $INSERT I_SCREEN.VARIABLES
    $INSERT I_F.COMPANY
    $INSERT I_F.USER
    $INSERT I_F.STANDARD.SELECTION
    SAVE.ID.COMPANY = ID.COMPANY
*************************************************************************
    MIDDLE.RATE.CONV.CHECK = "MIDDLE.RATE.CONV.CHECK"
*************************************************************************
    YT.SMS.COMP = ID.COMPANY
    YT.SMS.FILE = "LETTER.OF.CREDIT"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "DATES"
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
    DIM YR.REC(8)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.LCS.BY.BENE"
    YOLDFILE = 1
    OPEN "", YFILE TO F.FILE ELSE YOLDFILE = 0
    IF NOT(PHNO) THEN PRINT @(0,10):
    IF YOLDFILE THEN
        CLEARFILE F.FILE
        PRINT "FILE ":YFILE:"  CLEARED"
    END ELSE
        ERROR.MESSAGE = ""
        Y.OUT.FILE = FIELD(YFILE,".",2,99)
        CALL EBS.CREATE.FILE(Y.OUT.FILE,"",ERROR.MESSAGE)
    END
    OPEN "", YFILE TO F.FILE ELSE
        TEXT = "CANNOT OPEN ":YFILE
        CALL FATAL.ERROR ("RGS.LCS.BY.BENE")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "LETTER.OF.CREDIT"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "DATES"
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
    YFILE = "F.CUSTOMER"; YF.CUSTOMER = ""
    CALL OPF (YFILE, YF.CUSTOMER)
    YFILE = "F.DATES"; YF.DATES = ""
    CALL OPF (YFILE, YF.DATES)
*************************************************************************
    YFILE = "LETTER.OF.CREDIT"
    FULL.FNAME = "F.LETTER.OF.CREDIT"; YF.LETTER.OF.CREDIT = ""
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
    CALL OPF (FULL.FNAME, YF.LETTER.OF.CREDIT)
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
        MATREAD R.NEW FROM YF.LETTER.OF.CREDIT, ID.NEW ELSE ID.NEW = "" ; MAT R.NEW = ""
        IF T.PWD THEN
            CALL CONTROL.USER.PROFILE ("RECORD")
            IF ETEXT THEN ID.NEW = ""
        END
        IF ID.NEW <> "" THEN
*
* Handle Decision Table
            YM.SYS.DATE = R.NEW(137)
            IF YM.SYS.DATE <> "" THEN
                YCOMP = "DATES_1_":YM.SYS.DATE
                YFORFIL = YF.DATES
                YPART.S = 3; YPART.L = 6; YFD.LEN = "9L"; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.SYS.DATE = YFOR.FD
            END
            YM.TIME.DATE = FMT(R.NEW(135),"7L"); YM.TIME.DATE = YM.TIME.DATE[1,6]
            IF YM.TIME.DATE = YM.SYS.DATE THEN
                YGROUP = "1"; GOSUB 2000000
            END
            IF YM.TIME.DATE = "" THEN
                YGROUP = "2"; GOSUB 2000000
            END
        END
*
    REPEAT
    IF YKEYNO THEN
        YR.REC(8)  := @FM
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
            YM.ISSUE.BNK = R.NEW(6)
            IF YM.ISSUE.BNK <> "" THEN
                YCOMP = "CUSTOMER_2_":YM.ISSUE.BNK
                YFORFIL = YF.CUSTOMER
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.ISSUE.BNK = YFOR.FD
            END
            YM.DISP.ISSUE.BNK = YM.ISSUE.BNK
            YM1.DISP.ISSUE.BNK = YM.DISP.ISSUE.BNK
            YM.APPLICANT = R.NEW(9)
            IF YM.APPLICANT <> "" THEN
                YCOMP = "CUSTOMER_2_":YM.APPLICANT
                YFORFIL = YF.CUSTOMER
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.APPLICANT = YFOR.FD
            END
            YM.DISP.ISSUE.BNK = YM.APPLICANT
            YM1.DISP.ISSUE.BNK = YM1.DISP.ISSUE.BNK : YM.DISP.ISSUE.BNK
            YM.DISP.ISSUE.BNK = YM1.DISP.ISSUE.BNK
            YKEYFD = YM.DISP.ISSUE.BNK

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.DISP.ISSUE.BNK,"37L")


            IF LEN(YKEYFD) > 37 THEN YKEYFD = YKEYFD[1,36]:"|"
            GOSUB 8000000
            YR.REC(1) = YM.DISP.ISSUE.BNK
            YM.LC.NUM = ID.NEW
            YR.REC(2) = YM.LC.NUM
            YM.LC.TYPE = R.NEW(2)
            YKEYFD = YM.LC.TYPE

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.LC.TYPE,"6L")


            IF LEN(YKEYFD) > 6 THEN YKEYFD = YKEYFD[1,5]:"|"
            GOSUB 8000000
            YR.REC(3) = YM.LC.TYPE
            YM.CURRENCY = R.NEW(20)
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
            YR.REC(4) = YM.CURRENCY
            YM.LC.AMOUNT = R.NEW(21)
            YR.REC(5) = YM.LC.AMOUNT
            YM.AMOUNT = R.NEW(21)
            YM11.GOSUB = YM.AMOUNT
            YM.CCY = R.NEW(20)
            YM12.GOSUB = YM.CCY
            YM.MARKET = R.NEW(24)
            YM13.GOSUB = YM.MARKET
            YM.LCCY = ""
            YM14.GOSUB = YM.LCCY
            CALL @MIDDLE.RATE.CONV.CHECK (YM11.GOSUB, YM12.GOSUB, "", YM13.GOSUB, YM14.GOSUB, "", "")
            YM.AMOUNT = YM11.GOSUB
            YM.CCY = YM12.GOSUB
            YM.MARKET = YM13.GOSUB
            YM.LCCY = YM14.GOSUB
            YM.DISP.LCCY.AMT = YM.LCCY
            YM1.DISP.LCCY.AMT = YM.DISP.LCCY.AMT
            YTRUE.1 = 0
            IF YM.CURRENCY = "NLG" THEN
                YTRUE.1 = 1
                YM.NLGAMT = R.NEW(21)
            END
            IF NOT(YTRUE.1) THEN YM.NLGAMT = ""
            YM.DISP.LCCY.AMT = YM.NLGAMT
            IF NUM(YM1.DISP.LCCY.AMT) = NUMERIC THEN IF NUM(YM.DISP.LCCY.AMT) = NUMERIC THEN
                YM1.DISP.LCCY.AMT = YM1.DISP.LCCY.AMT + YM.DISP.LCCY.AMT
                IF YM1.DISP.LCCY.AMT = 0 THEN YM1.DISP.LCCY.AMT = ""
            END
            YM.DISP.LCCY.AMT = YM1.DISP.LCCY.AMT
            YR.REC(6) = YM.DISP.LCCY.AMT
            YM.ISSUE.DATE = R.NEW(27)
            YR.REC(7) = YM.ISSUE.DATE
            YM.EXPIRY.DATE = R.NEW(28)
            YR.REC(8) = YM.EXPIRY.DATE
*
        CASE YGROUP = "2"
            YKEY = "2"; MAT YR.REC = ""
            YM.ISSUE.BNK = R.NEW(6)
            IF YM.ISSUE.BNK <> "" THEN
                YCOMP = "CUSTOMER_2_":YM.ISSUE.BNK
                YFORFIL = YF.CUSTOMER
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.ISSUE.BNK = YFOR.FD
            END
            YM.DISP.ISSUE.BNK = YM.ISSUE.BNK
            YM1.DISP.ISSUE.BNK = YM.DISP.ISSUE.BNK
            YM.APPLICANT = R.NEW(9)
            IF YM.APPLICANT <> "" THEN
                YCOMP = "CUSTOMER_2_":YM.APPLICANT
                YFORFIL = YF.CUSTOMER
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.APPLICANT = YFOR.FD
            END
            YM.DISP.ISSUE.BNK = YM.APPLICANT
            YM1.DISP.ISSUE.BNK = YM1.DISP.ISSUE.BNK : YM.DISP.ISSUE.BNK
            YM.DISP.ISSUE.BNK = YM1.DISP.ISSUE.BNK
            YKEYFD = YM.DISP.ISSUE.BNK

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.DISP.ISSUE.BNK,"37L")


            IF LEN(YKEYFD) > 37 THEN YKEYFD = YKEYFD[1,36]:"|"
            GOSUB 8000000
            YR.REC(1) = YM.DISP.ISSUE.BNK
            YM.LC.NUM = ID.NEW
            YR.REC(2) = YM.LC.NUM
            YM.LC.TYPE = R.NEW(2)
            YKEYFD = YM.LC.TYPE

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.LC.TYPE,"6L")


            IF LEN(YKEYFD) > 6 THEN YKEYFD = YKEYFD[1,5]:"|"
            GOSUB 8000000
            YR.REC(3) = YM.LC.TYPE
            YM.CURRENCY = R.NEW(20)
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
            YR.REC(4) = YM.CURRENCY
            YM.LC.AMOUNT = R.NEW(21)
            YR.REC(5) = YM.LC.AMOUNT
            YM.AMOUNT = R.NEW(21)
            YM11.GOSUB = YM.AMOUNT
            YM.CCY = R.NEW(20)
            YM12.GOSUB = YM.CCY
            YM.MARKET = R.NEW(24)
            YM13.GOSUB = YM.MARKET
            YM.LCCY = ""
            YM14.GOSUB = YM.LCCY
            CALL @MIDDLE.RATE.CONV.CHECK (YM11.GOSUB, YM12.GOSUB, "", YM13.GOSUB, YM14.GOSUB, "", "")
            YM.AMOUNT = YM11.GOSUB
            YM.CCY = YM12.GOSUB
            YM.MARKET = YM13.GOSUB
            YM.LCCY = YM14.GOSUB
            YM.DISP.LCCY.AMT = YM.LCCY
            YM1.DISP.LCCY.AMT = YM.DISP.LCCY.AMT
            YTRUE.1 = 0
            IF YM.CURRENCY = "NLG" THEN
                YTRUE.1 = 1
                YM.NLGAMT = R.NEW(21)
            END
            IF NOT(YTRUE.1) THEN YM.NLGAMT = ""
            YM.DISP.LCCY.AMT = YM.NLGAMT
            IF NUM(YM1.DISP.LCCY.AMT) = NUMERIC THEN IF NUM(YM.DISP.LCCY.AMT) = NUMERIC THEN
                YM1.DISP.LCCY.AMT = YM1.DISP.LCCY.AMT + YM.DISP.LCCY.AMT
                IF YM1.DISP.LCCY.AMT = 0 THEN YM1.DISP.LCCY.AMT = ""
            END
            YM.DISP.LCCY.AMT = YM1.DISP.LCCY.AMT
            YR.REC(6) = YM.DISP.LCCY.AMT
            YM.ISSUE.DATE = R.NEW(27)
            YR.REC(7) = YM.ISSUE.DATE
            YM.EXPIRY.DATE = R.NEW(28)
            YR.REC(8) = YM.EXPIRY.DATE
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
        IF YKEY.CHR < "A" THEN
            IF YKEY.CHR >= 0 AND YKEY.CHR <= 9 THEN
                YKEY = YKEY : YKEY.CHR
            END ELSE
                IF INDEX(".$",YKEY.CHR,1) THEN
                    YKEY = YKEY : YKEY.CHR
                END ELSE
                    YKEY = YKEY : "&"
                END
            END
        END ELSE
            IF YKEY.CHR < "[" THEN
                YKEY = YKEY : YKEY.CHR
            END ELSE
                IF YKEY.CHR >= "a" AND YKEY.CHR <= "z" THEN
                    YKEY = YKEY : YKEY.CHR
                END ELSE
                    YKEY = YKEY : "&"
                END
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
            READV YFOR.FD FROM YFORFIL, YFOR.ID, YFOR.AF ELSE YFOR.FD = ""
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
