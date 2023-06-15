* @ValidationCode : MjotMTQzMDY0MTI3MjpDcDEyNTI6MTY4NjgyNDA2MzQzMjpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Jun 2023 15:44:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.Repgens
SUBROUTINE RGS.ACCOUNT.LIST
REM "RGS.ACCOUNT.LIST",230614-5
*************************************************************************
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 15-JUNE-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------
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
    YT.SMS.FILE = "ACCOUNT"
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
    DIM YR.REC(8)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.ACCOUNT.LIST"
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
        CALL FATAL.ERROR ("RGS.ACCOUNT.LIST")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "ACCOUNT"
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
        MATREAD R.NEW FROM YF.ACCOUNT, ID.NEW ELSE ID.NEW = "" ; MAT R.NEW = ""
        IF T.PWD THEN
            CALL CONTROL.USER.PROFILE ("RECORD")
            IF ETEXT THEN ID.NEW = ""
        END
        IF ID.NEW <> "" THEN
*
* Handle Decision Table
            YM.CUS.NUM = R.NEW(1)
            IF YM.CUS.NUM <> "" THEN
                YGROUP = "1"; GOSUB 2000000
            END
            IF YM.CUS.NUM = "" THEN
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
            YM.ACC.NUM = ID.NEW
            YR.REC(1) = YM.ACC.NUM
            YM.CUS.NUM = R.NEW(1)
            YKEYFD = FMT(YM.CUS.NUM,"R######")
            IF LEN(YKEYFD) > 6 THEN YKEYFD = YKEYFD[1,5]:"|"
            GOSUB 8000000
            YR.REC(2) = YM.CUS.NUM
            YM.CUS.NAME = R.NEW(3)
            YR.REC(3) = YM.CUS.NAME
            YM.ACCT.BALANCE = R.NEW(27)
            YM.CURR = R.NEW(8)
            YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
            IF YM.ACCT.BALANCE <> "" THEN
                YM.ACCT.BALANCE = TRIM(FMT(YM.ACCT.BALANCE,"19R":YDEC))
            END
            YR.REC(4) = YM.ACCT.BALANCE
            YKEYFD = YM.CURR

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.CURR,"5L")


            IF LEN(YKEYFD) > 5 THEN YKEYFD = YKEYFD[1,4]:"|"
            GOSUB 8000000
            YR.REC(5) = YM.CURR
            YM.CURR.FTR = R.NEW(8)
            YR.REC(6) = YM.CURR.FTR
            YM.WBAL = R.NEW(27)
            YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
            IF YM.WBAL <> "" THEN
                YM.WBAL = TRIM(FMT(YM.WBAL,"19R":YDEC))
            END
            YR.REC(7) = YM.WBAL
            YTRUE.1 = 0
            YM.POSTR = R.NEW(13)
            IF YM.POSTR <> "" THEN
                YTRUE.1 = 1
                YM.DISP.YES = "YES"
            END
            IF NOT(YTRUE.1) THEN YM.DISP.YES = ""
            YR.REC(8) = YM.DISP.YES
*
        CASE YGROUP = "2"
            YKEY = "2"; MAT YR.REC = ""
            YM.ACC.NUM = ID.NEW
            YR.REC(1) = YM.ACC.NUM
            YM.CUS.NUM = R.NEW(1)
            YKEYFD = FMT(YM.CUS.NUM,"R######")
            IF LEN(YKEYFD) > 6 THEN YKEYFD = YKEYFD[1,5]:"|"
            GOSUB 8000000
            YR.REC(2) = YM.CUS.NUM
            YM.CUS.NAME = R.NEW(3)
            YR.REC(3) = YM.CUS.NAME
            YM.ACCT.BALANCE = R.NEW(27)
            YM.CURR = R.NEW(8)
            YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
            IF YM.ACCT.BALANCE <> "" THEN
                YM.ACCT.BALANCE = TRIM(FMT(YM.ACCT.BALANCE,"19R":YDEC))
            END
            YR.REC(4) = YM.ACCT.BALANCE
            YKEYFD = YM.CURR

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.CURR,"5L")


            IF LEN(YKEYFD) > 5 THEN YKEYFD = YKEYFD[1,4]:"|"
            GOSUB 8000000
            YR.REC(5) = YM.CURR
            YM.CURR.FTR = R.NEW(8)
            YR.REC(6) = YM.CURR.FTR
            YM.WBAL = R.NEW(27)
            YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
            IF YM.WBAL <> "" THEN
                YM.WBAL = TRIM(FMT(YM.WBAL,"19R":YDEC))
            END
            YR.REC(7) = YM.WBAL
            YTRUE.1 = 0
            YM.POSTR = R.NEW(13)
            IF YM.POSTR <> "" THEN
                YTRUE.1 = 1
                YM.DISP.YES = "YES"
            END
            IF NOT(YTRUE.1) THEN YM.DISP.YES = ""
            YR.REC(8) = YM.DISP.YES
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
* Ask for valid file password in connection with Company code
9300000:
*
    IF X THEN IF R.USER<EB.USE.COMPANY.RESTR,X> THEN
        IF R.USER<EB.USE.COMPANY.RESTR,X> <> YID.COMP THEN X = 0
    END
RETURN
*************************************************************************
END
