$PACKAGE APAP.Repgens

SUBROUTINE RGS.LI.CO.EXCESS
REM "RGS.LI.CO.EXCESS",230614-4
*---------------------------------------------------------------------------------------
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
    RG.S.LIMIT.ACCOUNT.OS = "RG.S.LIMIT.ACCOUNT.OS"
*************************************************************************
    YF.VOC = ""
    OPEN "", "VOC" TO YF.VOC ELSE
        TEXT = "CANNOT OPEN VOC-FILE"
        CALL FATAL.ERROR ("RGS.LI.CO.EXCESS")
    END
*************************************************************************
    YT.SMS.COMP = ID.COMPANY
    YT.SMS.FILE = "LIMIT"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
    YT.SMS.FILE<-1> = "LIMIT.REFERENCE"
    YT.SMS.FILE<-1> = "COLLATERAL.RIGHT"
    YT.SMS.FILE<-1> = "COLLATERAL.CODE"
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
    DIM YR.REC(25)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.LI.CO.EXCESS"
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
        CALL FATAL.ERROR ("RGS.LI.CO.EXCESS")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "LIMIT"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
    YT.SMS.FILE<-1> = "LIMIT.REFERENCE"
    YT.SMS.FILE<-1> = "COLLATERAL.RIGHT"
    YT.SMS.FILE<-1> = "COLLATERAL.CODE"
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
    YFILE = "F.DEPT.ACCT.OFFICER"; YF.DEPT.ACCT.OFFICER = ""
    CALL OPF (YFILE, YF.DEPT.ACCT.OFFICER)
    YFILE = "F.LIMIT.REFERENCE"; YF.LIMIT.REFERENCE = ""
    CALL OPF (YFILE, YF.LIMIT.REFERENCE)
    YFILE = "F.COLLATERAL.RIGHT"; YF.COLLATERAL.RIGHT = ""
    CALL OPF (YFILE, YF.COLLATERAL.RIGHT)
    YFILE = "F.COLLATERAL.CODE"; YF.COLLATERAL.CODE = ""
    CALL OPF (YFILE, YF.COLLATERAL.CODE)
*************************************************************************
    YFILE = "LIMIT"
    FULL.FNAME = "F.LIMIT"; YF.LIMIT = ""
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
    CALL OPF (FULL.FNAME, YF.LIMIT)
    fldName = '' ; dataType = '' ; errMsg = ''
    CALL FIELD.NUMBERS.TO.NAMES('17',SS.REC,fldName,dataType,errMsg)
    CLEARSELECT
    YSEL.A = ""
    IF C$MULTI.BOOK AND COMP.FOUND THEN
        YSEL.A = " AND CO.CODE EQUAL ":ID.COMPANY
    END
    EXECUTE "HUSH ON"
    EXECUTE 'SELECT ':FULL.FNAME:' WITH ':fldName:' = "VARIABLE"':YSEL.A
    EXECUTE "HUSH OFF"
    CALL EB.READLIST('', YID.LIST, '', '', '')
    LOOP
        REMOVE ID.NEW FROM YID.LIST SETTING YDELIM
    WHILE ID.NEW:YDELIM
        MATREAD R.NEW FROM YF.LIMIT, ID.NEW ELSE ID.NEW = "" ; MAT R.NEW = ""
        IF T.PWD THEN
            CALL CONTROL.USER.PROFILE ("RECORD")
            IF ETEXT THEN ID.NEW = ""
        END
        IF ID.NEW <> "" THEN
*
* Handle Decision Table
            YM.AVAIL.AMT = R.NEW(37)<1,1>
            YM1.AVAIL.AMT = YM.AVAIL.AMT
            YM.LIMIT.ID = ID.NEW
            YM.ARG1A = YM.LIMIT.ID
            YM16.GOSUB = YM.ARG1A
            YM.ARG2A = ""
            YM17.GOSUB = YM.ARG2A
            CALL @RG.S.LIMIT.ACCOUNT.OS (YM16.GOSUB, YM17.GOSUB)
            YM.ARG1A = YM16.GOSUB
            YM.ARG2A = YM17.GOSUB
            YM.AVAIL.AMT = YM.ARG2A
            IF NUM(YM1.AVAIL.AMT) = NUMERIC THEN IF NUM(YM.AVAIL.AMT) = NUMERIC THEN
                YM1.AVAIL.AMT = YM1.AVAIL.AMT + YM.AVAIL.AMT
                IF YM1.AVAIL.AMT = 0 THEN YM1.AVAIL.AMT = ""
            END
            YM.AVAIL.AMT = YM1.AVAIL.AMT
            IF YM.AVAIL.AMT < 0 AND YM.AVAIL.AMT THEN
                GOSUB 2000000
            END
        END
*
    REPEAT
    IF YKEYNO THEN
        YR.REC(25)  := @FM
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
    YM.CUSTOMER.ID =  FIELD(ID.NEW,".",1)
    YM.DEPT.ACCT.OFFICER = YM.CUSTOMER.ID
    IF YM.DEPT.ACCT.OFFICER <> "" THEN
        YCOMP = "CUSTOMER_11_":YM.DEPT.ACCT.OFFICER
        YFORFIL = YF.CUSTOMER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.DEPT.ACCT.OFFICER = YFOR.FD
    END
    YKEYFD = YM.DEPT.ACCT.OFFICER

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

    FULL.TXN.ID = ""
    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

    YKEYFD = FMT(YM.DEPT.ACCT.OFFICER,"6L")


    IF LEN(YKEYFD) > 6 THEN YKEYFD = YKEYFD[1,5]:"|"
    GOSUB 8000000
    YR.REC(1) = YM.DEPT.ACCT.OFFICER
    YM.AREA = YM.DEPT.ACCT.OFFICER
    IF YM.AREA <> "" THEN
        YCOMP = "DEPT.ACCT.OFFICER_1_":YM.AREA
        YFORFIL = YF.DEPT.ACCT.OFFICER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.AREA = YFOR.FD
    END
    YR.REC(2) = YM.AREA
    YM.NAME = YM.DEPT.ACCT.OFFICER
    IF YM.NAME <> "" THEN
        YCOMP = "DEPT.ACCT.OFFICER_2_":YM.NAME
        YFORFIL = YF.DEPT.ACCT.OFFICER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.NAME = YFOR.FD
    END
    YR.REC(3) = YM.NAME
    YM.DELIVERY.POINT = YM.DEPT.ACCT.OFFICER
    IF YM.DELIVERY.POINT <> "" THEN
        YCOMP = "DEPT.ACCT.OFFICER_3_":YM.DELIVERY.POINT
        YFORFIL = YF.DEPT.ACCT.OFFICER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.DELIVERY.POINT = YFOR.FD
    END
    YR.REC(4) = YM.DELIVERY.POINT
    YM.TELEPHONE.NO = YM.DEPT.ACCT.OFFICER
    IF YM.TELEPHONE.NO <> "" THEN
        YCOMP = "DEPT.ACCT.OFFICER_6_":YM.TELEPHONE.NO
        YFORFIL = YF.DEPT.ACCT.OFFICER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TELEPHONE.NO = YFOR.FD
    END
    YR.REC(5) = YM.TELEPHONE.NO
    YM.LIABILITY.NO = YM.CUSTOMER.ID
    YKEYFD = FMT(YM.LIABILITY.NO,"R######")
    IF LEN(YKEYFD) > 6 THEN YKEYFD = YKEYFD[1,5]:"|"
    GOSUB 8000000
    YR.REC(6) = YM.LIABILITY.NO
    YM.LIMIT.REFERENCE =  FIELD(ID.NEW,".",2)
    YKEYFD = YM.LIMIT.REFERENCE

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

    FULL.TXN.ID = ""
    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

    YKEYFD = FMT(YM.LIMIT.REFERENCE,"9L")


    IF LEN(YKEYFD) > 9 THEN YKEYFD = YKEYFD[1,8]:"|"
    GOSUB 8000000
    YR.REC(7) = YM.LIMIT.REFERENCE
    YM.SERIAL.NO =  FIELD(ID.NEW,".",3)
    YKEYFD = YM.SERIAL.NO

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

    FULL.TXN.ID = ""
    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

    YKEYFD = FMT(YM.SERIAL.NO,"4L")


    IF LEN(YKEYFD) > 4 THEN YKEYFD = YKEYFD[1,3]:"|"
    GOSUB 8000000
    YR.REC(8) = YM.SERIAL.NO
    YM.CUSTOMER.NO =  FIELD(ID.NEW,".",4)
    YKEYFD = FMT(YM.CUSTOMER.NO,"L######")
    IF LEN(YKEYFD) > 6 THEN YKEYFD = YKEYFD[1,5]:"|"
    GOSUB 8000000
    YR.REC(9) = YM.CUSTOMER.NO
    YM.SHORT.NAME = YM.CUSTOMER.ID
    IF YM.SHORT.NAME <> "" THEN
        YCOMP = "CUSTOMER_2_":YM.SHORT.NAME
        YFORFIL = YF.CUSTOMER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.SHORT.NAME = YFOR.FD
    END
    YR.REC(10) = YM.SHORT.NAME
    YM.LIMIT.PRODUCT = R.NEW(96)
    IF YM.LIMIT.PRODUCT <> "" THEN
        YCOMP = "LIMIT.REFERENCE_1.1_":YM.LIMIT.PRODUCT
        YFORFIL = YF.LIMIT.REFERENCE
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
        YM.LIMIT.PRODUCT = YFOR.FD
    END
    YR.REC(11) = YM.LIMIT.PRODUCT
    YM.LIMIT.CURRENCY = R.NEW(1)
    YR.REC(12) = YM.LIMIT.CURRENCY
    YM.MAXIMUM.TOTAL = R.NEW(26)
    YR.REC(13) = YM.MAXIMUM.TOTAL
    YM.TOTAL.OS = R.NEW(36)<1,1>
    YM1.TOTAL.OS = YM.TOTAL.OS
    YM.LIMIT.ID = ID.NEW
    YM.ARG1A = YM.LIMIT.ID
    YM16.GOSUB = YM.ARG1A
    YM.ARG2A = ""
    YM17.GOSUB = YM.ARG2A
    CALL @RG.S.LIMIT.ACCOUNT.OS (YM16.GOSUB, YM17.GOSUB)
    YM.ARG1A = YM16.GOSUB
    YM.ARG2A = YM17.GOSUB
    YM.TOTAL.OS = YM.ARG2A
    IF NUM(YM1.TOTAL.OS) = NUMERIC THEN IF NUM(YM.TOTAL.OS) = NUMERIC THEN
        YM1.TOTAL.OS = YM1.TOTAL.OS + YM.TOTAL.OS
        IF YM1.TOTAL.OS = 0 THEN YM1.TOTAL.OS = ""
    END
    YM.TOTAL.OS = YM1.TOTAL.OS
    YR.REC(14) = YM.TOTAL.OS
    YM.ONLINE.LIMIT = R.NEW(32)<1,1>
    YR.REC(15) = YM.ONLINE.LIMIT
    YM.AVAIL.AMT = R.NEW(37)<1,1>
    YM1.AVAIL.AMT = YM.AVAIL.AMT
    YM.AVAIL.AMT = YM.ARG2A
    IF NUM(YM1.AVAIL.AMT) = NUMERIC THEN IF NUM(YM.AVAIL.AMT) = NUMERIC THEN
        YM1.AVAIL.AMT = YM1.AVAIL.AMT + YM.AVAIL.AMT
        IF YM1.AVAIL.AMT = 0 THEN YM1.AVAIL.AMT = ""
    END
    YM.AVAIL.AMT = YM1.AVAIL.AMT
    YR.REC(16) = YM.AVAIL.AMT
    YM.DATE.OF.EXCESS = R.NEW(46)<1,1>
    YR.REC(17) = YM.DATE.OF.EXCESS
    YM.AMT.LAST.EXCESS = R.NEW(47)<1,1>
    YR.REC(18) = YM.AMT.LAST.EXCESS
    YM.DATE.LAST.MOVED = R.NEW(48)<1,1>
    YR.REC(19) = YM.DATE.LAST.MOVED
    YM.AMT.LAST.MOVED = R.NEW(49)<1,1>
    YR.REC(20) = YM.AMT.LAST.MOVED
    YM.NOTES = R.NEW(14)
    YR.REC(21) = YM.NOTES
    YM.COLLAT.RIGHT = R.NEW(28)
    YR.REC(22) = YM.COLLAT.RIGHT
    YM.COLLATERAL.CODE = YM.COLLAT.RIGHT
    IF YM.COLLATERAL.CODE <> "" THEN
        YCOMP = "COLLATERAL.RIGHT_1_":YM.COLLATERAL.CODE
        YFORFIL = YF.COLLATERAL.RIGHT
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.COLLATERAL.CODE = YFOR.FD
    END
    YR.REC(23) = YM.COLLATERAL.CODE
    YM.DESCRIPTION = YM.COLLATERAL.CODE
    IF YM.DESCRIPTION <> "" THEN
        YCOMP = "COLLATERAL.CODE_1_":YM.DESCRIPTION
        YFORFIL = YF.COLLATERAL.CODE
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.DESCRIPTION = YFOR.FD
    END
    YR.REC(24) = YM.DESCRIPTION
    YM.SECURED.AMT = R.NEW(29)
    YR.REC(25) = YM.SECURED.AMT
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
