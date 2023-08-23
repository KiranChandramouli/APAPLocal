<<<<<<< Updated upstream
<<<<<<< Updated upstream
* @ValidationCode : MjotMTQ3NzQ4ODE0MDpDcDEyNTI6MTY4ODUzNjkwMzY2MTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jul 2023 11:31:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
=======
=======
>>>>>>> Stashed changes
* @ValidationCode : MjotMTQ3NzQ4ODE0MDpDcDEyNTI6MTY4NjkxODczMzQxMDpJVFNTMTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Jun 2023 18:02:13
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

SUBROUTINE RGS.OVERDRAFT.LIST
REM "RGS.OVERDRAFT.LIST",230614-4
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
    YT.SMS.COMP = ID.COMPANY
    YT.SMS.FILE = "ACCOUNT.OVERDRAWN"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
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
    DIM YR.REC(12)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.OVERDRAFT.LIST"
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
        CALL FATAL.ERROR ("RGS.OVERDRAFT.LIST")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "ACCOUNT.OVERDRAWN"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
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
    YFILE = "F.CUSTOMER"; YF.CUSTOMER = ""
    CALL OPF (YFILE, YF.CUSTOMER)
*************************************************************************
    YFILE = "ACCOUNT.OVERDRAWN"
    FULL.FNAME = "F.ACCOUNT.OVERDRAWN"; YF.ACCOUNT.OVERDRAWN = ""
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
    CALL OPF (FULL.FNAME, YF.ACCOUNT.OVERDRAWN)
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
        MATREAD R.OLD FROM YF.ACCOUNT.OVERDRAWN, ID.NEW ELSE ID.NEW = "" ; MAT R.OLD = ""
        IF T.PWD THEN
            MAT R.NEW = MAT R.OLD
            CALL CONTROL.USER.PROFILE ("RECORD")
            IF ETEXT THEN ID.NEW = ""
        END
        IF ID.NEW <> "" THEN
*
* Handle Decision Table
            MAT R.NEW = MAT R.OLD
            YSPLIT.COUNT = COUNT(R.OLD(1),@VM)+1
            IF COUNT(R.OLD(3),@VM) >= YSPLIT.COUNT THEN
                YSPLIT.COUNT = COUNT(R.OLD(3),@VM)+1
            END
            IF COUNT(R.OLD(4),@VM) >= YSPLIT.COUNT THEN
                YSPLIT.COUNT = COUNT(R.OLD(4),@VM)+1
            END
            IF COUNT(R.OLD(5),@VM) >= YSPLIT.COUNT THEN
                YSPLIT.COUNT = COUNT(R.OLD(5),@VM)+1
            END
            IF COUNT(R.OLD(6),@VM) >= YSPLIT.COUNT THEN
                YSPLIT.COUNT = COUNT(R.OLD(6),@VM)+1
            END
            IF COUNT(R.OLD(7),@VM) >= YSPLIT.COUNT THEN
                YSPLIT.COUNT = COUNT(R.OLD(7),@VM)+1
            END
            IF COUNT(R.OLD(10),@VM) >= YSPLIT.COUNT THEN
                YSPLIT.COUNT = COUNT(R.OLD(10),@VM)+1
            END
            FOR YAV.SPLIT = 1 TO YSPLIT.COUNT
                YSPLIT.COUNT.AS = COUNT(R.OLD(1)<1,YAV.SPLIT>,@SM)+1
                IF COUNT(R.OLD(3)<1,YAV.SPLIT>,@SM) >= YSPLIT.COUNT.AS THEN
                    YSPLIT.COUNT.AS = COUNT(R.OLD(3)<1,YAV.SPLIT>,@SM)+1
                END
                IF COUNT(R.OLD(4)<1,YAV.SPLIT>,@SM) >= YSPLIT.COUNT.AS THEN
                    YSPLIT.COUNT.AS = COUNT(R.OLD(4)<1,YAV.SPLIT>,@SM)+1
                END
                IF COUNT(R.OLD(5)<1,YAV.SPLIT>,@SM) >= YSPLIT.COUNT.AS THEN
                    YSPLIT.COUNT.AS = COUNT(R.OLD(5)<1,YAV.SPLIT>,@SM)+1
                END
                IF COUNT(R.OLD(6)<1,YAV.SPLIT>,@SM) >= YSPLIT.COUNT.AS THEN
                    YSPLIT.COUNT.AS = COUNT(R.OLD(6)<1,YAV.SPLIT>,@SM)+1
                END
                IF COUNT(R.OLD(7)<1,YAV.SPLIT>,@SM) >= YSPLIT.COUNT.AS THEN
                    YSPLIT.COUNT.AS = COUNT(R.OLD(7)<1,YAV.SPLIT>,@SM)+1
                END
                IF COUNT(R.OLD(10)<1,YAV.SPLIT>,@SM) >= YSPLIT.COUNT.AS THEN
                    YSPLIT.COUNT.AS = COUNT(R.OLD(10)<1,YAV.SPLIT>,@SM)+1
                END
                FOR YAS.SPLIT = 1 TO YSPLIT.COUNT.AS
                    R.NEW(1) = R.OLD(1)<1,YAV.SPLIT,YAS.SPLIT>
                    R.NEW(3) = R.OLD(3)<1,YAV.SPLIT,YAS.SPLIT>
                    R.NEW(4) = R.OLD(4)<1,YAV.SPLIT,YAS.SPLIT>
                    R.NEW(5) = R.OLD(5)<1,YAV.SPLIT,YAS.SPLIT>
                    R.NEW(6) = R.OLD(6)<1,YAV.SPLIT,YAS.SPLIT>
                    R.NEW(7) = R.OLD(7)<1,YAV.SPLIT,YAS.SPLIT>
                    R.NEW(10) = R.OLD(10)<1,YAV.SPLIT,YAS.SPLIT>
                    GOSUB 2000000
                NEXT YAS.SPLIT
            NEXT YAV.SPLIT
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
    YKEY = ""; MAT YR.REC = ""
    YM.ACCOUNT.OFFICER = R.NEW(2)<1,1>
    IF YM.ACCOUNT.OFFICER <> "" THEN
        YCOMP = "DEPT.ACCT.OFFICER_2_":YM.ACCOUNT.OFFICER
        YFORFIL = YF.DEPT.ACCT.OFFICER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.ACCOUNT.OFFICER = YFOR.FD
    END
    YR.REC(1) = YM.ACCOUNT.OFFICER
    YM.ACCT.OFF.NUM = R.NEW(2)<1,1>
    YKEYFD = YM.ACCT.OFF.NUM

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

    FULL.TXN.ID = ""
    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

    YKEYFD = FMT(YM.ACCT.OFF.NUM,"6L")


    IF LEN(YKEYFD) > 6 THEN YKEYFD = YKEYFD[1,5]:"|"
    GOSUB 8000000
    YR.REC(2) = YM.ACCT.OFF.NUM
    YM.UNDERLINE = ""
    YR.REC(3) = YM.UNDERLINE
    YM.ACCOUNT.NUMBER = ID.NEW
    YKEYFD = YM.ACCOUNT.NUMBER

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

    FULL.TXN.ID = ""
    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

    YKEYFD = FMT(YM.ACCOUNT.NUMBER,"26L")


    IF LEN(YKEYFD) > 26 THEN YKEYFD = YKEYFD[1,25]:"|"
    GOSUB 8000000
    YR.REC(4) = YM.ACCOUNT.NUMBER
    YM.LIMIT.DESC. = R.NEW(1)
    YR.REC(5) = YM.LIMIT.DESC.
    YM.CUSTOMER = R.NEW(3)
    IF YM.CUSTOMER <> "" THEN
        YCOMP = "CUSTOMER_2_":YM.CUSTOMER
        YFORFIL = YF.CUSTOMER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.CUSTOMER = YFOR.FD
    END
    YR.REC(6) = YM.CUSTOMER
    YM.CCY = R.NEW(4)
    YR.REC(7) = YM.CCY
    YM.LIMIT.2 = R.NEW(5)
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
    IF YM.LIMIT.2 <> "" THEN
        YM.LIMIT.2 = TRIM(FMT(YM.LIMIT.2,"19R":YDEC))
    END
    YR.REC(8) = YM.LIMIT.2
    YM.OUTST.BAL. = R.NEW(6)
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
    IF YM.OUTST.BAL. <> "" THEN
        YM.OUTST.BAL. = TRIM(FMT(YM.OUTST.BAL.,"19R":YDEC))
    END
    YR.REC(9) = YM.OUTST.BAL.
    YTRUE.1 = 0
    YM.STATUS = R.NEW(10)
    IF YM.STATUS <> "EXPIRED" THEN
        YTRUE.1 = 1
        YM.OVERDRAFT.2 = YM.LIMIT.2
        YM1.OVERDRAFT.2 = YM.OVERDRAFT.2
        YTRUE.2 = 0
        YTRUE.3 = 0
        YM.ACCT.FOR.KEY.TYPE =  FIELD(ID.NEW,".",2)
        IF YM.ACCT.FOR.KEY.TYPE <> "" THEN
            YTRUE.3 = 1
            YM.KEY.TYPE = "L"
        END
        IF NOT(YTRUE.3) THEN YM.KEY.TYPE = ""
        IF YM.KEY.TYPE = "L" THEN
            YTRUE.2 = 1
            YM.OUTST.BAL.TO.ADD = R.NEW(6)
        END
        IF NOT(YTRUE.2) THEN YM.OUTST.BAL.TO.ADD = ""
        YM.OVERDRAFT.2 = YM.OUTST.BAL.TO.ADD
        IF NUM(YM1.OVERDRAFT.2) = NUMERIC THEN IF NUM(YM.OVERDRAFT.2) = NUMERIC THEN
            YM1.OVERDRAFT.2 = YM1.OVERDRAFT.2 + YM.OVERDRAFT.2
            IF YM1.OVERDRAFT.2 = 0 THEN YM1.OVERDRAFT.2 = ""
        END
        YM.OVERDRAFT.2 = YM1.OVERDRAFT.2
        YM.OVERPRINT = YM.OVERDRAFT.2
    END
    IF NOT(YTRUE.1) THEN
        YM.STATUS = R.NEW(10)
        IF YM.STATUS = "EXPIRED" THEN
            YTRUE.1 = 1
            YM.OVERPRINT = R.NEW(6)
        END
    END
    IF NOT(YTRUE.1) THEN YM.OVERPRINT = ""
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
    IF YM.OVERPRINT <> "" THEN
        YM.OVERPRINT = TRIM(FMT(YM.OVERPRINT,"19R":YDEC))
    END
    YR.REC(10) = YM.OVERPRINT
    YM.DATE = R.NEW(7)
    YR.REC(11) = YM.DATE
    YM.STATUS = R.NEW(10)
    YR.REC(12) = YM.STATUS
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
