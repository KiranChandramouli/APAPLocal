* @ValidationCode : Mjo3ODExNjk5Mjg6Q3AxMjUyOjE2ODY5MTg5MDk4NjY6SVRTUzotMTotMTozOTY4NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 Jun 2023 18:05:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 39685
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.Repgens
SUBROUTINE RGS.TRANS.T24INV4
*-----------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                           AUTHOR            Modification                     DESCRIPTION
*15/06/2023                    VIGNESHWARI        MANUAL R22 CODE CONVERSION       No Changes
*-----------------------------------------------------------------------------------------------------------------------
REM "RGS.TRANS.T24INV4",230614-4
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
    RG.GET.CONSOL.TYPE = "RG.GET.CONSOL.TYPE"
    RE.AC.CONTINGENT = "RE.AC.CONTINGENT"
*************************************************************************
    YT.SMS.COMP = ID.COMPANY
    YT.SMS.FILE = "CATEG.ENTRY"
    YT.SMS.FILE<-1> = "STMT.ENTRY"
    YT.SMS.FILE<-1> = "RE.CONSOL.SPEC.ENTRY"
    YT.SMS.FILE<-1> = "COMPANY"
    YT.SMS.FILE<-1> = "CATEGORY"
    YT.SMS.FILE<-1> = "ACCOUNT"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "CATEG.ENT.LWORK.DAY"
    YT.SMS.FILE<-1> = "ACCT.ENT.LWORK.DAY"
    YT.SMS.FILE<-1> = "RE.SPEC.ENT.LWORK.DAY"
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
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.TRANS.T24INV4"
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
        CALL FATAL.ERROR ("RGS.TRANS.T24INV4")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "CATEG.ENTRY"
    YT.SMS.FILE<-1> = "STMT.ENTRY"
    YT.SMS.FILE<-1> = "RE.CONSOL.SPEC.ENTRY"
    YT.SMS.FILE<-1> = "COMPANY"
    YT.SMS.FILE<-1> = "CATEGORY"
    YT.SMS.FILE<-1> = "ACCOUNT"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "CATEG.ENT.LWORK.DAY"
    YT.SMS.FILE<-1> = "ACCT.ENT.LWORK.DAY"
    YT.SMS.FILE<-1> = "RE.SPEC.ENT.LWORK.DAY"
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
    YFILE = "F.CATEGORY"; YF.CATEGORY = ""
    CALL OPF (YFILE, YF.CATEGORY)
    YFILE = "F.ACCOUNT"; YF.ACCOUNT = ""
    CALL OPF (YFILE, YF.ACCOUNT)
    YFILE = "F.CUSTOMER"; YF.CUSTOMER = ""
    CALL OPF (YFILE, YF.CUSTOMER)
*************************************************************************
    YFILE = "CATEG.ENT.LWORK.DAY"
    FULL.FNAME = "F.CATEG.ENT.LWORK.DAY"; YF.CATEG.ENT.LWORK.DAY = ""
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
    CALL OPF (FULL.FNAME, YF.CATEG.ENT.LWORK.DAY)
    CLEARSELECT
    IF C$MULTI.BOOK AND COMP.FOUND THEN
        SEL.ARGS = " WITH CO.CODE EQUAL ":ID.COMPANY
    END ELSE
        SEL.ARGS = ""
    END
    SELECT.CMMD = "SELECT ":FULL.FNAME:SEL.ARGS
    CALL EB.READLIST(SELECT.CMMD,YID.LIST,"","","")
    YFILE = "CATEG.ENTRY"
    FULL.FNAME = "F.CATEG.ENTRY"; YF.CATEG.ENTRY = ""
    LOCATE YFILE IN YT.SMS<1,1> SETTING X ELSE
        X = 0; T.PWD = ""
    END
    IF X THEN
        T.PWD = YT.SMS<2,X>
        CONVERT @SM TO @FM IN T.PWD
    END
    CALL OPF (FULL.FNAME, YF.CATEG.ENTRY)
    LOOP
        REMOVE WR.NEW FROM YID.LIST SETTING YDELIM
    WHILE WR.NEW:YDELIM
        READ YR.KEYS FROM YF.CATEG.ENT.LWORK.DAY, WR.NEW ELSE YR.KEYS = ""
        LOOP UNTIL YR.KEYS = "" DO
            ID.NEW = YR.KEYS<1>; DEL YR.KEYS<1>
            MATREAD R.NEW FROM YF.CATEG.ENTRY, ID.NEW ELSE ID.NEW = "" ; MAT R.NEW = ""
            IF T.PWD THEN
                CALL CONTROL.USER.PROFILE ("RECORD")
                IF ETEXT THEN ID.NEW = ""
            END
            IF ID.NEW <> "" THEN
*
* Handle Decision Table
                YM.OUTPUT.ARG = "NC"
                IF YM.OUTPUT.ARG = "NC" THEN
                    YGROUP = "1"; GOSUB 2000000
                END
                IF YM.OUTPUT.ARG = "C" THEN
                    YGROUP = "2"; GOSUB 2000000
                END
            END
        REPEAT
*
    REPEAT
*************************************************************************
    YFILE = "ACCT.ENT.LWORK.DAY"
    FULL.FNAME = "F.ACCT.ENT.LWORK.DAY"; YF.ACCT.ENT.LWORK.DAY = ""
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
    CALL OPF (FULL.FNAME, YF.ACCT.ENT.LWORK.DAY)
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
        READ YR.KEYS FROM YF.ACCT.ENT.LWORK.DAY, WR.NEW ELSE YR.KEYS = ""
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
                YM.INPUT.ARG = R.NEW(10)
                YM31.GOSUB = YM.INPUT.ARG
                YM.OUTPUT.ARG = ""
                YM32.GOSUB = YM.OUTPUT.ARG
                CALL @RE.AC.CONTINGENT (YM31.GOSUB, YM32.GOSUB)
                YM.INPUT.ARG = YM31.GOSUB
                YM.OUTPUT.ARG = YM32.GOSUB
                IF YM.OUTPUT.ARG = "NC" THEN
                    YGROUP = "1"; GOSUB 2000000
                END
                IF YM.OUTPUT.ARG = "C" THEN
                    YGROUP = "2"; GOSUB 2000000
                END
            END
        REPEAT
*
    REPEAT
*************************************************************************
    YFILE = "RE.SPEC.ENT.LWORK.DAY"
    FULL.FNAME = "F.RE.SPEC.ENT.LWORK.DAY"; YF.RE.SPEC.ENT.LWORK.DAY = ""
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
    CALL OPF (FULL.FNAME, YF.RE.SPEC.ENT.LWORK.DAY)
    CLEARSELECT
    IF C$MULTI.BOOK AND COMP.FOUND THEN
        SEL.ARGS = " WITH CO.CODE EQUAL ":ID.COMPANY
    END ELSE
        SEL.ARGS = ""
    END
    SELECT.CMMD = "SELECT ":FULL.FNAME:SEL.ARGS
    CALL EB.READLIST(SELECT.CMMD,YID.LIST,"","","")
    YFILE = "RE.CONSOL.SPEC.ENTRY"
    FULL.FNAME = "F.RE.CONSOL.SPEC.ENTRY"; YF.RE.CONSOL.SPEC.ENTRY = ""
    LOCATE YFILE IN YT.SMS<1,1> SETTING X ELSE
        X = 0; T.PWD = ""
    END
    IF X THEN
        T.PWD = YT.SMS<2,X>
        CONVERT @SM TO @FM IN T.PWD
    END
    CALL OPF (FULL.FNAME, YF.RE.CONSOL.SPEC.ENTRY)
    LOOP
        REMOVE WR.NEW FROM YID.LIST SETTING YDELIM
    WHILE WR.NEW:YDELIM
        READ YR.KEYS FROM YF.RE.SPEC.ENT.LWORK.DAY, WR.NEW ELSE YR.KEYS = ""
        LOOP UNTIL YR.KEYS = "" DO
            ID.NEW = YR.KEYS<1>; DEL YR.KEYS<1>
            MATREAD R.NEW FROM YF.RE.CONSOL.SPEC.ENTRY, ID.NEW ELSE ID.NEW = "" ; MAT R.NEW = ""
            IF T.PWD THEN
                CALL CONTROL.USER.PROFILE ("RECORD")
                IF ETEXT THEN ID.NEW = ""
            END
            IF ID.NEW <> "" THEN
*
* Handle Decision Table
                YM.INPUT.ARG = R.NEW(5)
                YM31.GOSUB = YM.INPUT.ARG
                YM.OUTPUT.ARG = ""
                YM32.GOSUB = YM.OUTPUT.ARG
                CALL @RG.GET.CONSOL.TYPE (YM31.GOSUB, YM32.GOSUB)
                YM.INPUT.ARG = YM31.GOSUB
                YM.OUTPUT.ARG = YM32.GOSUB
                IF YM.OUTPUT.ARG = "NC" THEN
                    YGROUP = "1"; GOSUB 2000000
                END
                IF YM.OUTPUT.ARG = "C" THEN
                    YGROUP = "2"; GOSUB 2000000
                END
            END
        REPEAT
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
    BEGIN CASE
        CASE YFILE = "CATEG.ENTRY"
            BEGIN CASE
                CASE YGROUP = "1"
                    YKEY = "1"; MAT YR.REC = ""
                    YTRUE.1 = 0
                    YM.SYS.ID.CHECK = R.NEW(24)
                    YM.TRANS.CODE = R.NEW(4)
                    IF INDEX(YM.SYS.ID.CHECK,"IC",1) <> 1 OR (INDEX(YM.SYS.ID.CHECK,"IC",1) = 1 AND YM.TRANS.CODE = "RVL") THEN
                        YTRUE.1 = 1
                        YTRUE.2 = 0
                        YM.SYS.ID.CHECK = R.NEW(24)
                        IF YM.SYS.ID.CHECK >= 1 THEN
                            YTRUE.2 = 1
                            YM.SYS.ID = FMT(R.NEW(24),"2L"); YM.SYS.ID = YM.SYS.ID[1,2]
                        END
                        IF NOT(YTRUE.2) THEN
                            YM.SYS.ID.CHECK = R.NEW(24)
                            IF YM.SYS.ID.CHECK < 1 AND YM.SYS.ID.CHECK THEN
                                YTRUE.2 = 1
                                YM.SYS.ID = "RV"
                            END
                        END
                        IF NOT(YTRUE.2) THEN
                            YM.TRANS.CODE = R.NEW(4)
                            YM.SYS.ID.CHECK = R.NEW(24)
                            IF YM.TRANS.CODE = "CRT" AND YM.SYS.ID.CHECK = "PD" THEN
                                YTRUE.2 = 1
                                YM.SYS.ID = ""
                            END
                        END
                        IF NOT(YTRUE.2) THEN YM.SYS.ID = ""
                        YM.PRT.SYS = YM.SYS.ID
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        YM.TRANS.CODE = R.NEW(4)
                        IF INDEX(YM.SYS.ID.CHECK,"IC",1) = 1 AND YM.TRANS.CODE <> "RVL" THEN
                            YTRUE.1 = 1
                            YM.PRT.SYS = "AC"
                        END
                    END
                    IF NOT(YTRUE.1) THEN YM.PRT.SYS = ""
                    YKEYFD = YM.PRT.SYS

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.PRT.SYS,"4L")


                    IF LEN(YKEYFD) > 4 THEN YKEYFD = YKEYFD[1,3]:"|"
                    GOSUB 8000000
                    YR.REC(1) = YM.PRT.SYS
                    YM.UNDER = "-----------"
                    YR.REC(2) = YM.UNDER
                    YTRUE.1 = 0
                    YM.SYS.ID.CHECK = R.NEW(24)
                    IF (YM.SYS.ID.CHECK <> "DC" AND YM.SYS.ID.CHECK <> "TT" AND INDEX(YM.SYS.ID.CHECK,"IC",1) <> 1) OR YM.SYS.ID.CHECK = "ICSP" THEN
                        YTRUE.1 = 1
                        YM.SORT.REF = R.NEW(17)
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        IF YM.SYS.ID.CHECK = "DC" OR YM.SYS.ID.CHECK = "TT" THEN
                            YTRUE.1 = 1
                            YTRUE.2 = 0
                            YM.SYS.ID.CHECK = R.NEW(24)
                            IF YM.SYS.ID.CHECK = "DC" THEN
                                YTRUE.2 = 1
                                YM.WORK.TR = FMT(R.NEW(23),"7L"); YM.WORK.TR = YM.WORK.TR[1,7]
                            END
                            IF NOT(YTRUE.2) THEN
                                YM.SYS.ID.CHECK = R.NEW(24)
                                IF YM.SYS.ID.CHECK = "TT" THEN
                                    YTRUE.2 = 1
                                    YM.WORK.TR = R.NEW(23)
                                END
                            END
                            IF NOT(YTRUE.2) THEN YM.WORK.TR = ""
                            YM.SORT.REF = YM.WORK.TR
                        END
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        YM.TRANS.CODE = R.NEW(4)
                        IF INDEX(YM.SYS.ID.CHECK,"IC",1) = 1 AND YM.TRANS.CODE <> "RVL" THEN
                            YTRUE.1 = 1
                            YTRUE.2 = 0
                            YM.CCY = R.NEW(12)
                            IF YM.CCY >= 1 THEN
                                YTRUE.2 = 1
                                YM.NEW.CCY = R.NEW(12)
                            END
                            IF NOT(YTRUE.2) THEN
                                YM.CCY = R.NEW(12)
                                IF YM.CCY < 1 AND YM.CCY THEN
                                    YTRUE.2 = 1
                                    YM.LOCAL.CCY = R.NEW(2)
                                    IF YM.LOCAL.CCY <> "" THEN
                                        YCOMP = "COMPANY_16_":YM.LOCAL.CCY
                                        YFORFIL = YF.COMPANY
                                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                                        YM.LOCAL.CCY = YFOR.FD
                                    END
                                    YM.NEW.CCY = YM.LOCAL.CCY
                                END
                            END
                            IF NOT(YTRUE.2) THEN YM.NEW.CCY = ""
                            YM.REP.ONE = YM.NEW.CCY
                            YM1.REP.ONE = YM.REP.ONE
                            YM.PART.ONE = R.NEW(7)
                            YM.REP.ONE = YM.PART.ONE
                            YM1.REP.ONE = YM1.REP.ONE : YM.REP.ONE
                            YM.REP.ONE = YM1.REP.ONE
                            YM.SORT.REF = YM.REP.ONE
                        END
                    END
                    IF NOT(YTRUE.1) THEN YM.SORT.REF = ""
                    YKEYFD = YM.SORT.REF

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.SORT.REF,"18L")


                    IF LEN(YKEYFD) > 18 THEN YKEYFD = YKEYFD[1,17]:"|"
                    GOSUB 8000000
                    YR.REC(3) = YM.SORT.REF
                    YTRUE.1 = 0
                    YM.SYS.ID.CHECK = R.NEW(24)
                    IF YM.SYS.ID.CHECK <> "DC" AND YM.SYS.ID.CHECK <> "TT" THEN
                        YTRUE.1 = 1
                        YM.TRANS.REF = R.NEW(17)
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        IF YM.SYS.ID.CHECK = "DC" OR YM.SYS.ID.CHECK = "TT" THEN
                            YTRUE.1 = 1
                            YM.TRANS.REF = R.NEW(23)
                        END
                    END
                    IF NOT(YTRUE.1) THEN YM.TRANS.REF = ""
                    YKEYFD = YM.TRANS.REF

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.TRANS.REF,"18L")


                    IF LEN(YKEYFD) > 18 THEN YKEYFD = YKEYFD[1,17]:"|"
                    GOSUB 8000000
                    YR.REC(4) = YM.TRANS.REF
                    YM.ACCOUNT = R.NEW(7)
                    YKEYFD = YM.ACCOUNT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.ACCOUNT,"14L")


                    IF LEN(YKEYFD) > 14 THEN YKEYFD = YKEYFD[1,13]:"|"
                    GOSUB 8000000
                    YR.REC(5) = YM.ACCOUNT
                    YM.AMOUNTLCY = R.NEW(3)
                    YR.REC(6) = YM.AMOUNTLCY
                    YM.TOTALNET = R.NEW(3)
                    YR.REC(7) = YM.TOTALNET
                    YTRUE.1 = 0
                    IF YM.AMOUNTLCY > 0 THEN
                        YTRUE.1 = 1
                        YM.AMOUNT.CREDIT = R.NEW(3)
                    END
                    IF NOT(YTRUE.1) THEN YM.AMOUNT.CREDIT = ""
                    YR.REC(8) = YM.AMOUNT.CREDIT
                    YTRUE.1 = 0
                    IF YM.AMOUNTLCY < 0 AND YM.AMOUNTLCY THEN
                        YTRUE.1 = 1
                        YM.AMOUNT.DEBIT = R.NEW(3)
                    END
                    IF NOT(YTRUE.1) THEN YM.AMOUNT.DEBIT = ""
                    YR.REC(9) = YM.AMOUNT.DEBIT
                    YM.RATE = R.NEW(14)
                    YR.REC(10) = YM.RATE
                    YM.CCY = R.NEW(12)
                    YR.REC(11) = YM.CCY
                    YM.FCYAMOUNT = R.NEW(13)
                    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
                    IF YM.FCYAMOUNT <> "" THEN
                        YM.FCYAMOUNT = TRIM(FMT(YM.FCYAMOUNT,"19R":YDEC))
                    END
                    YR.REC(12) = YM.FCYAMOUNT
                    YM.VALUE = R.NEW(11)
                    YR.REC(13) = YM.VALUE
                    YM.TRANS.CODE = R.NEW(4)
                    YR.REC(14) = YM.TRANS.CODE
                    YM.ACCT.OFF = R.NEW(9)
                    YR.REC(15) = YM.ACCT.OFF
                    YM.PRODUCT = R.NEW(10)
                    YR.REC(16) = YM.PRODUCT
                    YM.CUSTOMER = R.NEW(7)
                    IF YM.CUSTOMER <> "" THEN
                        YCOMP = "CATEGORY_2.1_":YM.CUSTOMER
                        YFORFIL = YF.CATEGORY
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                        YM.CUSTOMER = YFOR.FD
                    END
                    YR.REC(17) = YM.CUSTOMER
*
                CASE YGROUP = "2"
                    YKEY = "2"; MAT YR.REC = ""
                    YTRUE.1 = 0
                    YM.SYS.ID.CHECK = R.NEW(24)
                    YM.TRANS.CODE = R.NEW(4)
                    IF INDEX(YM.SYS.ID.CHECK,"IC",1) <> 1 OR (INDEX(YM.SYS.ID.CHECK,"IC",1) = 1 AND YM.TRANS.CODE = "RVL") THEN
                        YTRUE.1 = 1
                        YTRUE.2 = 0
                        YM.SYS.ID.CHECK = R.NEW(24)
                        IF YM.SYS.ID.CHECK >= 1 THEN
                            YTRUE.2 = 1
                            YM.SYS.ID = FMT(R.NEW(24),"2L"); YM.SYS.ID = YM.SYS.ID[1,2]
                        END
                        IF NOT(YTRUE.2) THEN
                            YM.SYS.ID.CHECK = R.NEW(24)
                            IF YM.SYS.ID.CHECK < 1 AND YM.SYS.ID.CHECK THEN
                                YTRUE.2 = 1
                                YM.SYS.ID = "RV"
                            END
                        END
                        IF NOT(YTRUE.2) THEN
                            YM.TRANS.CODE = R.NEW(4)
                            YM.SYS.ID.CHECK = R.NEW(24)
                            IF YM.TRANS.CODE = "CRT" AND YM.SYS.ID.CHECK = "PD" THEN
                                YTRUE.2 = 1
                                YM.SYS.ID = ""
                            END
                        END
                        IF NOT(YTRUE.2) THEN YM.SYS.ID = ""
                        YM.PRT.SYS = YM.SYS.ID
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        YM.TRANS.CODE = R.NEW(4)
                        IF INDEX(YM.SYS.ID.CHECK,"IC",1) = 1 AND YM.TRANS.CODE <> "RVL" THEN
                            YTRUE.1 = 1
                            YM.PRT.SYS = "AC"
                        END
                    END
                    IF NOT(YTRUE.1) THEN YM.PRT.SYS = ""
                    YKEYFD = YM.PRT.SYS

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.PRT.SYS,"4L")


                    IF LEN(YKEYFD) > 4 THEN YKEYFD = YKEYFD[1,3]:"|"
                    GOSUB 8000000
                    YR.REC(1) = YM.PRT.SYS
                    YM.UNDER = "-----------"
                    YR.REC(2) = YM.UNDER
                    YTRUE.1 = 0
                    YM.SYS.ID.CHECK = R.NEW(24)
                    IF (YM.SYS.ID.CHECK <> "DC" AND YM.SYS.ID.CHECK <> "TT" AND INDEX(YM.SYS.ID.CHECK,"IC",1) <> 1) OR YM.SYS.ID.CHECK = "ICSP" THEN
                        YTRUE.1 = 1
                        YM.SORT.REF = R.NEW(17)
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        IF YM.SYS.ID.CHECK = "DC" OR YM.SYS.ID.CHECK = "TT" THEN
                            YTRUE.1 = 1
                            YTRUE.2 = 0
                            YM.SYS.ID.CHECK = R.NEW(24)
                            IF YM.SYS.ID.CHECK = "DC" THEN
                                YTRUE.2 = 1
                                YM.WORK.TR = FMT(R.NEW(23),"7L"); YM.WORK.TR = YM.WORK.TR[1,7]
                            END
                            IF NOT(YTRUE.2) THEN
                                YM.SYS.ID.CHECK = R.NEW(24)
                                IF YM.SYS.ID.CHECK = "TT" THEN
                                    YTRUE.2 = 1
                                    YM.WORK.TR = R.NEW(23)
                                END
                            END
                            IF NOT(YTRUE.2) THEN YM.WORK.TR = ""
                            YM.SORT.REF = YM.WORK.TR
                        END
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        YM.TRANS.CODE = R.NEW(4)
                        IF INDEX(YM.SYS.ID.CHECK,"IC",1) = 1 AND YM.TRANS.CODE <> "RVL" THEN
                            YTRUE.1 = 1
                            YTRUE.2 = 0
                            YM.CCY = R.NEW(12)
                            IF YM.CCY >= 1 THEN
                                YTRUE.2 = 1
                                YM.NEW.CCY = R.NEW(12)
                            END
                            IF NOT(YTRUE.2) THEN
                                YM.CCY = R.NEW(12)
                                IF YM.CCY < 1 AND YM.CCY THEN
                                    YTRUE.2 = 1
                                    YM.LOCAL.CCY = R.NEW(2)
                                    IF YM.LOCAL.CCY <> "" THEN
                                        YCOMP = "COMPANY_16_":YM.LOCAL.CCY
                                        YFORFIL = YF.COMPANY
                                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                                        YM.LOCAL.CCY = YFOR.FD
                                    END
                                    YM.NEW.CCY = YM.LOCAL.CCY
                                END
                            END
                            IF NOT(YTRUE.2) THEN YM.NEW.CCY = ""
                            YM.REP.ONE = YM.NEW.CCY
                            YM1.REP.ONE = YM.REP.ONE
                            YM.PART.ONE = R.NEW(7)
                            YM.REP.ONE = YM.PART.ONE
                            YM1.REP.ONE = YM1.REP.ONE : YM.REP.ONE
                            YM.REP.ONE = YM1.REP.ONE
                            YM.SORT.REF = YM.REP.ONE
                        END
                    END
                    IF NOT(YTRUE.1) THEN YM.SORT.REF = ""
                    YKEYFD = YM.SORT.REF

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.SORT.REF,"18L")


                    IF LEN(YKEYFD) > 18 THEN YKEYFD = YKEYFD[1,17]:"|"
                    GOSUB 8000000
                    YR.REC(3) = YM.SORT.REF
                    YTRUE.1 = 0
                    YM.SYS.ID.CHECK = R.NEW(24)
                    IF YM.SYS.ID.CHECK <> "DC" AND YM.SYS.ID.CHECK <> "TT" THEN
                        YTRUE.1 = 1
                        YM.TRANS.REF = R.NEW(17)
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        IF YM.SYS.ID.CHECK = "DC" OR YM.SYS.ID.CHECK = "TT" THEN
                            YTRUE.1 = 1
                            YM.TRANS.REF = R.NEW(23)
                        END
                    END
                    IF NOT(YTRUE.1) THEN YM.TRANS.REF = ""
                    YKEYFD = YM.TRANS.REF

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.TRANS.REF,"18L")


                    IF LEN(YKEYFD) > 18 THEN YKEYFD = YKEYFD[1,17]:"|"
                    GOSUB 8000000
                    YR.REC(4) = YM.TRANS.REF
                    YM.ACCOUNT = R.NEW(7)
                    YKEYFD = YM.ACCOUNT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.ACCOUNT,"14L")


                    IF LEN(YKEYFD) > 14 THEN YKEYFD = YKEYFD[1,13]:"|"
                    GOSUB 8000000
                    YR.REC(5) = YM.ACCOUNT
                    YM.AMOUNTLCY = R.NEW(3)
                    YR.REC(6) = YM.AMOUNTLCY
                    YM.TOTALNET = R.NEW(3)
                    YR.REC(7) = YM.TOTALNET
                    YTRUE.1 = 0
                    IF YM.AMOUNTLCY > 0 THEN
                        YTRUE.1 = 1
                        YM.AMOUNT.CREDIT = R.NEW(3)
                    END
                    IF NOT(YTRUE.1) THEN YM.AMOUNT.CREDIT = ""
                    YR.REC(8) = YM.AMOUNT.CREDIT
                    YTRUE.1 = 0
                    IF YM.AMOUNTLCY < 0 AND YM.AMOUNTLCY THEN
                        YTRUE.1 = 1
                        YM.AMOUNT.DEBIT = R.NEW(3)
                    END
                    IF NOT(YTRUE.1) THEN YM.AMOUNT.DEBIT = ""
                    YR.REC(9) = YM.AMOUNT.DEBIT
                    YM.RATE = R.NEW(14)
                    YR.REC(10) = YM.RATE
                    YM.CCY = R.NEW(12)
                    YR.REC(11) = YM.CCY
                    YM.FCYAMOUNT = R.NEW(13)
                    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
                    IF YM.FCYAMOUNT <> "" THEN
                        YM.FCYAMOUNT = TRIM(FMT(YM.FCYAMOUNT,"19R":YDEC))
                    END
                    YR.REC(12) = YM.FCYAMOUNT
                    YM.VALUE = R.NEW(11)
                    YR.REC(13) = YM.VALUE
                    YM.TRANS.CODE = R.NEW(4)
                    YR.REC(14) = YM.TRANS.CODE
                    YM.ACCT.OFF = R.NEW(9)
                    YR.REC(15) = YM.ACCT.OFF
                    YM.PRODUCT = R.NEW(10)
                    YR.REC(16) = YM.PRODUCT
                    YM.CUSTOMER = R.NEW(7)
                    IF YM.CUSTOMER <> "" THEN
                        YCOMP = "CATEGORY_2.1_":YM.CUSTOMER
                        YFORFIL = YF.CATEGORY
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                        YM.CUSTOMER = YFOR.FD
                    END
                    YR.REC(17) = YM.CUSTOMER
            END CASE
*------------------------------------------------------------------------
        CASE YFILE = "STMT.ENTRY"
            BEGIN CASE
                CASE YGROUP = "1"
                    YKEY = "1"; MAT YR.REC = ""
                    YTRUE.1 = 0
                    YM.SYS.ID.CHECK = R.NEW(24)
                    YM.TRANS.CODE = R.NEW(4)
                    IF INDEX(YM.SYS.ID.CHECK,"IC",1) <> 1 OR (INDEX(YM.SYS.ID.CHECK,"IC",1) = 1 AND YM.TRANS.CODE = "RVL") THEN
                        YTRUE.1 = 1
                        YM.SYS.ID = FMT(R.NEW(24),"2L"); YM.SYS.ID = YM.SYS.ID[1,2]
                        YM.PRT.SYS = YM.SYS.ID
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        YM.TRANS.CODE = R.NEW(4)
                        IF INDEX(YM.SYS.ID.CHECK,"IC",1) = 1 AND YM.TRANS.CODE <> "RVL" THEN
                            YTRUE.1 = 1
                            YM.PRT.SYS = "AC"
                        END
                    END
                    IF NOT(YTRUE.1) THEN YM.PRT.SYS = ""
                    YKEYFD = YM.PRT.SYS

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.PRT.SYS,"4L")


                    IF LEN(YKEYFD) > 4 THEN YKEYFD = YKEYFD[1,3]:"|"
                    GOSUB 8000000
                    YR.REC(1) = YM.PRT.SYS
                    YM.UNDER = "-----------"
                    YR.REC(2) = YM.UNDER
                    YTRUE.1 = 0
                    YM.SYS.ID.CHECK = R.NEW(24)
                    IF (YM.SYS.ID.CHECK <> "DC" AND YM.SYS.ID.CHECK <> "TT" AND INDEX(YM.SYS.ID.CHECK,"IC",1) <> 1) OR YM.SYS.ID.CHECK = "ICSP" THEN
                        YTRUE.1 = 1
                        YM.SORT.REF = R.NEW(17)
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        IF YM.SYS.ID.CHECK = "DC" OR YM.SYS.ID.CHECK = "TT" THEN
                            YTRUE.1 = 1
                            YTRUE.2 = 0
                            YM.SYS.ID.CHECK = R.NEW(24)
                            IF YM.SYS.ID.CHECK = "DC" THEN
                                YTRUE.2 = 1
                                YM.WORK.TR = FMT(R.NEW(23),"7L"); YM.WORK.TR = YM.WORK.TR[1,7]
                            END
                            IF NOT(YTRUE.2) THEN
                                YM.SYS.ID.CHECK = R.NEW(24)
                                IF YM.SYS.ID.CHECK = "TT" THEN
                                    YTRUE.2 = 1
                                    YM.WORK.TR = R.NEW(23)
                                END
                            END
                            IF NOT(YTRUE.2) THEN YM.WORK.TR = ""
                            YM.SORT.REF = YM.WORK.TR
                        END
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        YM.TRANS.CODE = R.NEW(4)
                        IF INDEX(YM.SYS.ID.CHECK,"IC",1) = 1 AND YM.TRANS.CODE <> "RVL" THEN
                            YTRUE.1 = 1
                            YTRUE.2 = 0
                            YM.CCY = R.NEW(12)
                            IF YM.CCY >= 1 THEN
                                YTRUE.2 = 1
                                YM.NEW.CCY = R.NEW(12)
                            END
                            IF NOT(YTRUE.2) THEN
                                YM.CCY = R.NEW(12)
                                IF YM.CCY < 1 AND YM.CCY THEN
                                    YTRUE.2 = 1
                                    YM.LOCAL.CCY = R.NEW(2)
                                    IF YM.LOCAL.CCY <> "" THEN
                                        YCOMP = "COMPANY_16_":YM.LOCAL.CCY
                                        YFORFIL = YF.COMPANY
                                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                                        YM.LOCAL.CCY = YFOR.FD
                                    END
                                    YM.NEW.CCY = YM.LOCAL.CCY
                                END
                            END
                            IF NOT(YTRUE.2) THEN YM.NEW.CCY = ""
                            YM.REP.ONE = YM.NEW.CCY
                            YM1.REP.ONE = YM.REP.ONE
                            YM.PART.ONE = R.NEW(4)
                            YM.REP.ONE = YM.PART.ONE
                            YM1.REP.ONE = YM1.REP.ONE : YM.REP.ONE
                            YM.REP.ONE = YM1.REP.ONE
                            YM.SORT.REF = YM.REP.ONE
                        END
                    END
                    IF NOT(YTRUE.1) THEN YM.SORT.REF = ""
                    YKEYFD = YM.SORT.REF

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.SORT.REF,"18L")


                    IF LEN(YKEYFD) > 18 THEN YKEYFD = YKEYFD[1,17]:"|"
                    GOSUB 8000000
                    YR.REC(3) = YM.SORT.REF
                    YTRUE.1 = 0
                    YM.SYS.ID.CHECK = R.NEW(24)
                    IF YM.SYS.ID.CHECK <> "DC" AND YM.SYS.ID.CHECK <> "TT" THEN
                        YTRUE.1 = 1
                        YM.TRANS.REF = R.NEW(17)
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        IF YM.SYS.ID.CHECK = "DC" OR YM.SYS.ID.CHECK = "TT" THEN
                            YTRUE.1 = 1
                            YM.TRANS.REF = R.NEW(23)
                        END
                    END
                    IF NOT(YTRUE.1) THEN YM.TRANS.REF = ""
                    YKEYFD = YM.TRANS.REF

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.TRANS.REF,"18L")


                    IF LEN(YKEYFD) > 18 THEN YKEYFD = YKEYFD[1,17]:"|"
                    GOSUB 8000000
                    YR.REC(4) = YM.TRANS.REF
                    YM.ACCOUNT = R.NEW(1)
                    YKEYFD = YM.ACCOUNT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.ACCOUNT,"14L")


                    IF LEN(YKEYFD) > 14 THEN YKEYFD = YKEYFD[1,13]:"|"
                    GOSUB 8000000
                    YR.REC(5) = YM.ACCOUNT
                    YM.AMOUNTLCY = R.NEW(3)
                    YR.REC(6) = YM.AMOUNTLCY
                    YM.TOTALNET = R.NEW(3)
                    YR.REC(7) = YM.TOTALNET
                    YTRUE.1 = 0
                    IF YM.AMOUNTLCY > 0 THEN
                        YTRUE.1 = 1
                        YM.AMOUNT.CREDIT = R.NEW(3)
                    END
                    IF NOT(YTRUE.1) THEN YM.AMOUNT.CREDIT = ""
                    YR.REC(8) = YM.AMOUNT.CREDIT
                    YTRUE.1 = 0
                    IF YM.AMOUNTLCY < 0 AND YM.AMOUNTLCY THEN
                        YTRUE.1 = 1
                        YM.AMOUNT.DEBIT = R.NEW(3)
                    END
                    IF NOT(YTRUE.1) THEN YM.AMOUNT.DEBIT = ""
                    YR.REC(9) = YM.AMOUNT.DEBIT
                    YM.RATE = R.NEW(14)
                    YR.REC(10) = YM.RATE
                    YM.CCY = R.NEW(12)
                    YR.REC(11) = YM.CCY
                    YM.FCYAMOUNT = R.NEW(13)
                    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
                    IF YM.FCYAMOUNT <> "" THEN
                        YM.FCYAMOUNT = TRIM(FMT(YM.FCYAMOUNT,"19R":YDEC))
                    END
                    YR.REC(12) = YM.FCYAMOUNT
                    YM.VALUE = R.NEW(11)
                    YR.REC(13) = YM.VALUE
                    YM.TRANS.CODE = R.NEW(4)
                    YR.REC(14) = YM.TRANS.CODE
                    YM.ACCT.OFF = R.NEW(9)
                    YR.REC(15) = YM.ACCT.OFF
                    YM.PRODUCT = R.NEW(10)
                    YR.REC(16) = YM.PRODUCT
                    YM.CUSTOMER = R.NEW(1)
                    IF YM.CUSTOMER <> "" THEN
                        YCOMP = "ACCOUNT_6_":YM.CUSTOMER
                        YFORFIL = YF.ACCOUNT
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.CUSTOMER = YFOR.FD
                    END
                    YR.REC(17) = YM.CUSTOMER
*
                CASE YGROUP = "2"
                    YKEY = "2"; MAT YR.REC = ""
                    YTRUE.1 = 0
                    YM.SYS.ID.CHECK = R.NEW(24)
                    YM.TRANS.CODE = R.NEW(4)
                    IF INDEX(YM.SYS.ID.CHECK,"IC",1) <> 1 OR (INDEX(YM.SYS.ID.CHECK,"IC",1) = 1 AND YM.TRANS.CODE = "RVL") THEN
                        YTRUE.1 = 1
                        YM.SYS.ID = FMT(R.NEW(24),"2L"); YM.SYS.ID = YM.SYS.ID[1,2]
                        YM.PRT.SYS = YM.SYS.ID
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        YM.TRANS.CODE = R.NEW(4)
                        IF INDEX(YM.SYS.ID.CHECK,"IC",1) = 1 AND YM.TRANS.CODE <> "RVL" THEN
                            YTRUE.1 = 1
                            YM.PRT.SYS = "AC"
                        END
                    END
                    IF NOT(YTRUE.1) THEN YM.PRT.SYS = ""
                    YKEYFD = YM.PRT.SYS

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.PRT.SYS,"4L")


                    IF LEN(YKEYFD) > 4 THEN YKEYFD = YKEYFD[1,3]:"|"
                    GOSUB 8000000
                    YR.REC(1) = YM.PRT.SYS
                    YM.UNDER = "-----------"
                    YR.REC(2) = YM.UNDER
                    YTRUE.1 = 0
                    YM.SYS.ID.CHECK = R.NEW(24)
                    IF (YM.SYS.ID.CHECK <> "DC" AND YM.SYS.ID.CHECK <> "TT" AND INDEX(YM.SYS.ID.CHECK,"IC",1) <> 1) OR YM.SYS.ID.CHECK = "ICSP" THEN
                        YTRUE.1 = 1
                        YM.SORT.REF = R.NEW(17)
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        IF YM.SYS.ID.CHECK = "DC" OR YM.SYS.ID.CHECK = "TT" THEN
                            YTRUE.1 = 1
                            YTRUE.2 = 0
                            YM.SYS.ID.CHECK = R.NEW(24)
                            IF YM.SYS.ID.CHECK = "DC" THEN
                                YTRUE.2 = 1
                                YM.WORK.TR = FMT(R.NEW(23),"7L"); YM.WORK.TR = YM.WORK.TR[1,7]
                            END
                            IF NOT(YTRUE.2) THEN
                                YM.SYS.ID.CHECK = R.NEW(24)
                                IF YM.SYS.ID.CHECK = "TT" THEN
                                    YTRUE.2 = 1
                                    YM.WORK.TR = R.NEW(23)
                                END
                            END
                            IF NOT(YTRUE.2) THEN YM.WORK.TR = ""
                            YM.SORT.REF = YM.WORK.TR
                        END
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        YM.TRANS.CODE = R.NEW(4)
                        IF INDEX(YM.SYS.ID.CHECK,"IC",1) = 1 AND YM.TRANS.CODE <> "RVL" THEN
                            YTRUE.1 = 1
                            YTRUE.2 = 0
                            YM.CCY = R.NEW(12)
                            IF YM.CCY >= 1 THEN
                                YTRUE.2 = 1
                                YM.NEW.CCY = R.NEW(12)
                            END
                            IF NOT(YTRUE.2) THEN
                                YM.CCY = R.NEW(12)
                                IF YM.CCY < 1 AND YM.CCY THEN
                                    YTRUE.2 = 1
                                    YM.LOCAL.CCY = R.NEW(2)
                                    IF YM.LOCAL.CCY <> "" THEN
                                        YCOMP = "COMPANY_16_":YM.LOCAL.CCY
                                        YFORFIL = YF.COMPANY
                                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                                        YM.LOCAL.CCY = YFOR.FD
                                    END
                                    YM.NEW.CCY = YM.LOCAL.CCY
                                END
                            END
                            IF NOT(YTRUE.2) THEN YM.NEW.CCY = ""
                            YM.REP.ONE = YM.NEW.CCY
                            YM1.REP.ONE = YM.REP.ONE
                            YM.PART.ONE = R.NEW(4)
                            YM.REP.ONE = YM.PART.ONE
                            YM1.REP.ONE = YM1.REP.ONE : YM.REP.ONE
                            YM.REP.ONE = YM1.REP.ONE
                            YM.SORT.REF = YM.REP.ONE
                        END
                    END
                    IF NOT(YTRUE.1) THEN YM.SORT.REF = ""
                    YKEYFD = YM.SORT.REF

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.SORT.REF,"18L")


                    IF LEN(YKEYFD) > 18 THEN YKEYFD = YKEYFD[1,17]:"|"
                    GOSUB 8000000
                    YR.REC(3) = YM.SORT.REF
                    YTRUE.1 = 0
                    YM.SYS.ID.CHECK = R.NEW(24)
                    IF YM.SYS.ID.CHECK <> "DC" AND YM.SYS.ID.CHECK <> "TT" THEN
                        YTRUE.1 = 1
                        YM.TRANS.REF = R.NEW(17)
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        IF YM.SYS.ID.CHECK = "DC" OR YM.SYS.ID.CHECK = "TT" THEN
                            YTRUE.1 = 1
                            YM.TRANS.REF = R.NEW(23)
                        END
                    END
                    IF NOT(YTRUE.1) THEN YM.TRANS.REF = ""
                    YKEYFD = YM.TRANS.REF

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.TRANS.REF,"18L")


                    IF LEN(YKEYFD) > 18 THEN YKEYFD = YKEYFD[1,17]:"|"
                    GOSUB 8000000
                    YR.REC(4) = YM.TRANS.REF
                    YM.ACCOUNT = R.NEW(1)
                    YKEYFD = YM.ACCOUNT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.ACCOUNT,"14L")


                    IF LEN(YKEYFD) > 14 THEN YKEYFD = YKEYFD[1,13]:"|"
                    GOSUB 8000000
                    YR.REC(5) = YM.ACCOUNT
                    YM.AMOUNTLCY = R.NEW(3)
                    YR.REC(6) = YM.AMOUNTLCY
                    YM.TOTALNET = R.NEW(3)
                    YR.REC(7) = YM.TOTALNET
                    YTRUE.1 = 0
                    IF YM.AMOUNTLCY > 0 THEN
                        YTRUE.1 = 1
                        YM.AMOUNT.CREDIT = R.NEW(3)
                    END
                    IF NOT(YTRUE.1) THEN YM.AMOUNT.CREDIT = ""
                    YR.REC(8) = YM.AMOUNT.CREDIT
                    YTRUE.1 = 0
                    IF YM.AMOUNTLCY < 0 AND YM.AMOUNTLCY THEN
                        YTRUE.1 = 1
                        YM.AMOUNT.DEBIT = R.NEW(3)
                    END
                    IF NOT(YTRUE.1) THEN YM.AMOUNT.DEBIT = ""
                    YR.REC(9) = YM.AMOUNT.DEBIT
                    YM.RATE = R.NEW(14)
                    YR.REC(10) = YM.RATE
                    YM.CCY = R.NEW(12)
                    YR.REC(11) = YM.CCY
                    YM.FCYAMOUNT = R.NEW(13)
                    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
                    IF YM.FCYAMOUNT <> "" THEN
                        YM.FCYAMOUNT = TRIM(FMT(YM.FCYAMOUNT,"19R":YDEC))
                    END
                    YR.REC(12) = YM.FCYAMOUNT
                    YM.VALUE = R.NEW(11)
                    YR.REC(13) = YM.VALUE
                    YM.TRANS.CODE = R.NEW(4)
                    YR.REC(14) = YM.TRANS.CODE
                    YM.ACCT.OFF = R.NEW(9)
                    YR.REC(15) = YM.ACCT.OFF
                    YM.PRODUCT = R.NEW(10)
                    YR.REC(16) = YM.PRODUCT
                    YM.CUSTOMER = R.NEW(1)
                    IF YM.CUSTOMER <> "" THEN
                        YCOMP = "ACCOUNT_6_":YM.CUSTOMER
                        YFORFIL = YF.ACCOUNT
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.CUSTOMER = YFOR.FD
                    END
                    YR.REC(17) = YM.CUSTOMER
            END CASE
*------------------------------------------------------------------------
        CASE YFILE = "RE.CONSOL.SPEC.ENTRY"
            BEGIN CASE
                CASE YGROUP = "1"
                    YKEY = "1"; MAT YR.REC = ""
                    YTRUE.1 = 0
                    YM.SYS.ID.CHECK = R.NEW(24)
                    YM.TRANS.CODE = R.NEW(4)
                    IF INDEX(YM.SYS.ID.CHECK,"IC",1) <> 1 OR (INDEX(YM.SYS.ID.CHECK,"IC",1) = 1 AND YM.TRANS.CODE = "RVL") THEN
                        YTRUE.1 = 1
                        YTRUE.2 = 0
                        YM.TRANS.CODE = R.NEW(4)
                        YM.SYS.ID.CHECK = R.NEW(24)
                        IF YM.TRANS.CODE = "CRT" AND YM.SYS.ID.CHECK = "PD" THEN
                            YTRUE.2 = 1
                            YM.SYS.ID = FMT(R.NEW(17),"4L"); YM.SYS.ID = YM.SYS.ID[3,2]
                        END
                        IF NOT(YTRUE.2) THEN
                            YM.TRANS.CODE = R.NEW(4)
                            IF YM.TRANS.CODE <> "RVL" THEN
                                YTRUE.2 = 1
                                YM.SYS.ID = FMT(R.NEW(24),"2L"); YM.SYS.ID = YM.SYS.ID[1,2]
                            END
                        END
                        IF NOT(YTRUE.2) THEN
                            YM.TRANS.CODE = R.NEW(4)
                            IF YM.TRANS.CODE = "RVL" THEN
                                YTRUE.2 = 1
                                YM.SYS.ID = "RV"
                            END
                        END
                        IF NOT(YTRUE.2) THEN YM.SYS.ID = ""
                        YM.PRT.SYS = YM.SYS.ID
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        YM.TRANS.CODE = R.NEW(4)
                        IF INDEX(YM.SYS.ID.CHECK,"IC",1) = 1 AND YM.TRANS.CODE <> "RVL" THEN
                            YTRUE.1 = 1
                            YM.PRT.SYS = "AC"
                        END
                    END
                    IF NOT(YTRUE.1) THEN YM.PRT.SYS = ""
                    YKEYFD = YM.PRT.SYS

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.PRT.SYS,"4L")


                    IF LEN(YKEYFD) > 4 THEN YKEYFD = YKEYFD[1,3]:"|"
                    GOSUB 8000000
                    YR.REC(1) = YM.PRT.SYS
                    YM.UNDER = "-----------"
                    YR.REC(2) = YM.UNDER
                    YTRUE.1 = 0
                    YM.TRANS.CODE = R.NEW(4)
                    YM.SYS.ID.CHECK = R.NEW(24)
                    IF (YM.TRANS.CODE <> "ACC" AND YM.TRANS.CODE <> "CAP" AND YM.TRANS.CODE <> "SSS" AND YM.TRANS.CODE <> "SUS") OR YM.SYS.ID.CHECK <> "AC" THEN
                        YTRUE.1 = 1
                        YTRUE.2 = 0
                        YM.TRANS.CODE = R.NEW(4)
                        YM.SYS.ID.CHECK = R.NEW(24)
                        IF YM.TRANS.CODE = "CRT" AND YM.SYS.ID.CHECK = "PD" THEN
                            YTRUE.2 = 1
                            YM.WORK.TR = FMT(R.NEW(17),"14L"); YM.WORK.TR = YM.WORK.TR[3,12]
                        END
                        IF NOT(YTRUE.2) THEN
                            YM.TRANS.CODE = R.NEW(4)
                            IF YM.TRANS.CODE <> "CRT" THEN
                                YTRUE.2 = 1
                                YM.WORK.TR = R.NEW(17)
                            END
                        END
                        IF NOT(YTRUE.2) THEN YM.WORK.TR = ""
                        YM.SORT.REF = YM.WORK.TR
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.TRANS.CODE = R.NEW(4)
                        IF YM.TRANS.CODE = "ACC" OR YM.TRANS.CODE = "SSS" OR YM.TRANS.CODE = "SUS" THEN
                            YTRUE.1 = 1
                            YTRUE.2 = 0
                            YM.CCY = R.NEW(12)
                            IF YM.CCY >= 1 THEN
                                YTRUE.2 = 1
                                YM.NEW.CCY = R.NEW(12)
                            END
                            IF NOT(YTRUE.2) THEN
                                YM.CCY = R.NEW(12)
                                IF YM.CCY < 1 AND YM.CCY THEN
                                    YTRUE.2 = 1
                                    YM.LOCAL.CCY = R.NEW(2)
                                    IF YM.LOCAL.CCY <> "" THEN
                                        YCOMP = "COMPANY_16_":YM.LOCAL.CCY
                                        YFORFIL = YF.COMPANY
                                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                                        YM.LOCAL.CCY = YFOR.FD
                                    END
                                    YM.NEW.CCY = YM.LOCAL.CCY
                                END
                            END
                            IF NOT(YTRUE.2) THEN YM.NEW.CCY = ""
                            YM.REP.TWO = YM.NEW.CCY
                            YM1.REP.TWO = YM.REP.TWO
                            YTRUE.2 = 0
                            YM.TRANS.CODE = R.NEW(4)
                            IF YM.TRANS.CODE = "ACC" THEN
                                YTRUE.2 = 1
                                YM.PART.TWO = FMT(R.NEW(5),"75R"); YM.PART.TWO = YM.PART.TWO[71,5]
                            END
                            IF NOT(YTRUE.2) THEN
                                YM.TRANS.CODE = R.NEW(4)
                                IF YM.TRANS.CODE = "SUS" OR YM.TRANS.CODE = "SSS" THEN
                                    YTRUE.2 = 1
                                    YM.PART.TWO = FMT(R.NEW(5),"75R"); YM.PART.TWO = YM.PART.TWO[69,7]
                                END
                            END
                            IF NOT(YTRUE.2) THEN YM.PART.TWO = ""
                            YM.REP.TWO = YM.PART.TWO
                            YM1.REP.TWO = YM1.REP.TWO : YM.REP.TWO
                            YM.REP.TWO = YM1.REP.TWO
                            YM.SORT.REF = YM.REP.TWO
                        END
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.TRANS.CODE = R.NEW(4)
                        IF YM.TRANS.CODE = "CAP" THEN
                            YTRUE.1 = 1
                            YM.CCY = R.NEW(12)
                            YM.REP.ONE = YM.CCY
                            YM1.REP.ONE = YM.REP.ONE
                            YM.PART.ONE = R.NEW(4)
                            YM.REP.ONE = YM.PART.ONE
                            YM1.REP.ONE = YM1.REP.ONE : YM.REP.ONE
                            YM.REP.ONE = YM1.REP.ONE
                            YM.SORT.REF = YM.REP.ONE
                        END
                    END
                    IF NOT(YTRUE.1) THEN YM.SORT.REF = ""
                    YKEYFD = YM.SORT.REF

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.SORT.REF,"18L")


                    IF LEN(YKEYFD) > 18 THEN YKEYFD = YKEYFD[1,17]:"|"
                    GOSUB 8000000
                    YR.REC(3) = YM.SORT.REF
                    YM.TRANS.REF = R.NEW(17)
                    YKEYFD = YM.TRANS.REF

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.TRANS.REF,"18L")


                    IF LEN(YKEYFD) > 18 THEN YKEYFD = YKEYFD[1,17]:"|"
                    GOSUB 8000000
                    YR.REC(4) = YM.TRANS.REF
                    YM.ACCOUNT = FMT(R.NEW(5),"25L"); YM.ACCOUNT = YM.ACCOUNT[13,12]
                    YKEYFD = YM.ACCOUNT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.ACCOUNT,"14L")


                    IF LEN(YKEYFD) > 14 THEN YKEYFD = YKEYFD[1,13]:"|"
                    GOSUB 8000000
                    YR.REC(5) = YM.ACCOUNT
                    YM.AMOUNTLCY = R.NEW(3)
                    YR.REC(6) = YM.AMOUNTLCY
                    YM.TOTALNET = R.NEW(3)
                    YR.REC(7) = YM.TOTALNET
                    YTRUE.1 = 0
                    IF YM.AMOUNTLCY > 0 THEN
                        YTRUE.1 = 1
                        YM.AMOUNT.CREDIT = R.NEW(3)
                    END
                    IF NOT(YTRUE.1) THEN YM.AMOUNT.CREDIT = ""
                    YR.REC(8) = YM.AMOUNT.CREDIT
                    YTRUE.1 = 0
                    IF YM.AMOUNTLCY < 0 AND YM.AMOUNTLCY THEN
                        YTRUE.1 = 1
                        YM.AMOUNT.DEBIT = R.NEW(3)
                    END
                    IF NOT(YTRUE.1) THEN YM.AMOUNT.DEBIT = ""
                    YR.REC(9) = YM.AMOUNT.DEBIT
                    YM.RATE = R.NEW(14)
                    YR.REC(10) = YM.RATE
                    YM.CCY = R.NEW(12)
                    YR.REC(11) = YM.CCY
                    YM.FCYAMOUNT = R.NEW(13)
                    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
                    IF YM.FCYAMOUNT <> "" THEN
                        YM.FCYAMOUNT = TRIM(FMT(YM.FCYAMOUNT,"19R":YDEC))
                    END
                    YR.REC(12) = YM.FCYAMOUNT
                    YM.VALUE = ""
                    YR.REC(13) = YM.VALUE
                    YM.TRANS.CODE = R.NEW(4)
                    YR.REC(14) = YM.TRANS.CODE
                    YM.ACCT.OFF = R.NEW(9)
                    YR.REC(15) = YM.ACCT.OFF
                    YM.PRODUCT = R.NEW(10)
                    YR.REC(16) = YM.PRODUCT
                    YM.CUSTOMER = R.NEW(8)
                    IF YM.CUSTOMER <> "" THEN
                        YCOMP = "CUSTOMER_1_":YM.CUSTOMER
                        YFORFIL = YF.CUSTOMER
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.CUSTOMER = YFOR.FD
                    END
                    YR.REC(17) = YM.CUSTOMER
*
                CASE YGROUP = "2"
                    YKEY = "2"; MAT YR.REC = ""
                    YTRUE.1 = 0
                    YM.SYS.ID.CHECK = R.NEW(24)
                    YM.TRANS.CODE = R.NEW(4)
                    IF INDEX(YM.SYS.ID.CHECK,"IC",1) <> 1 OR (INDEX(YM.SYS.ID.CHECK,"IC",1) = 1 AND YM.TRANS.CODE = "RVL") THEN
                        YTRUE.1 = 1
                        YTRUE.2 = 0
                        YM.TRANS.CODE = R.NEW(4)
                        YM.SYS.ID.CHECK = R.NEW(24)
                        IF YM.TRANS.CODE = "CRT" AND YM.SYS.ID.CHECK = "PD" THEN
                            YTRUE.2 = 1
                            YM.SYS.ID = FMT(R.NEW(17),"4L"); YM.SYS.ID = YM.SYS.ID[3,2]
                        END
                        IF NOT(YTRUE.2) THEN
                            YM.TRANS.CODE = R.NEW(4)
                            IF YM.TRANS.CODE <> "RVL" THEN
                                YTRUE.2 = 1
                                YM.SYS.ID = FMT(R.NEW(24),"2L"); YM.SYS.ID = YM.SYS.ID[1,2]
                            END
                        END
                        IF NOT(YTRUE.2) THEN
                            YM.TRANS.CODE = R.NEW(4)
                            IF YM.TRANS.CODE = "RVL" THEN
                                YTRUE.2 = 1
                                YM.SYS.ID = "RV"
                            END
                        END
                        IF NOT(YTRUE.2) THEN YM.SYS.ID = ""
                        YM.PRT.SYS = YM.SYS.ID
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.SYS.ID.CHECK = R.NEW(24)
                        YM.TRANS.CODE = R.NEW(4)
                        IF INDEX(YM.SYS.ID.CHECK,"IC",1) = 1 AND YM.TRANS.CODE <> "RVL" THEN
                            YTRUE.1 = 1
                            YM.PRT.SYS = "AC"
                        END
                    END
                    IF NOT(YTRUE.1) THEN YM.PRT.SYS = ""
                    YKEYFD = YM.PRT.SYS

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.PRT.SYS,"4L")


                    IF LEN(YKEYFD) > 4 THEN YKEYFD = YKEYFD[1,3]:"|"
                    GOSUB 8000000
                    YR.REC(1) = YM.PRT.SYS
                    YM.UNDER = "-----------"
                    YR.REC(2) = YM.UNDER
                    YTRUE.1 = 0
                    YM.TRANS.CODE = R.NEW(4)
                    YM.SYS.ID.CHECK = R.NEW(24)
                    IF (YM.TRANS.CODE <> "ACC" AND YM.TRANS.CODE <> "CAP" AND YM.TRANS.CODE <> "SSS" AND YM.TRANS.CODE <> "SUS") OR YM.SYS.ID.CHECK <> "AC" THEN
                        YTRUE.1 = 1
                        YTRUE.2 = 0
                        YM.TRANS.CODE = R.NEW(4)
                        YM.SYS.ID.CHECK = R.NEW(24)
                        IF YM.TRANS.CODE = "CRT" AND YM.SYS.ID.CHECK = "PD" THEN
                            YTRUE.2 = 1
                            YM.WORK.TR = FMT(R.NEW(17),"14L"); YM.WORK.TR = YM.WORK.TR[3,12]
                        END
                        IF NOT(YTRUE.2) THEN
                            YM.TRANS.CODE = R.NEW(4)
                            IF YM.TRANS.CODE <> "CRT" THEN
                                YTRUE.2 = 1
                                YM.WORK.TR = R.NEW(17)
                            END
                        END
                        IF NOT(YTRUE.2) THEN YM.WORK.TR = ""
                        YM.SORT.REF = YM.WORK.TR
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.TRANS.CODE = R.NEW(4)
                        IF YM.TRANS.CODE = "ACC" OR YM.TRANS.CODE = "SSS" OR YM.TRANS.CODE = "SUS" THEN
                            YTRUE.1 = 1
                            YTRUE.2 = 0
                            YM.CCY = R.NEW(12)
                            IF YM.CCY >= 1 THEN
                                YTRUE.2 = 1
                                YM.NEW.CCY = R.NEW(12)
                            END
                            IF NOT(YTRUE.2) THEN
                                YM.CCY = R.NEW(12)
                                IF YM.CCY < 1 AND YM.CCY THEN
                                    YTRUE.2 = 1
                                    YM.LOCAL.CCY = R.NEW(2)
                                    IF YM.LOCAL.CCY <> "" THEN
                                        YCOMP = "COMPANY_16_":YM.LOCAL.CCY
                                        YFORFIL = YF.COMPANY
                                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                                        YM.LOCAL.CCY = YFOR.FD
                                    END
                                    YM.NEW.CCY = YM.LOCAL.CCY
                                END
                            END
                            IF NOT(YTRUE.2) THEN YM.NEW.CCY = ""
                            YM.REP.TWO = YM.NEW.CCY
                            YM1.REP.TWO = YM.REP.TWO
                            YTRUE.2 = 0
                            YM.TRANS.CODE = R.NEW(4)
                            IF YM.TRANS.CODE = "ACC" THEN
                                YTRUE.2 = 1
                                YM.PART.TWO = FMT(R.NEW(5),"75R"); YM.PART.TWO = YM.PART.TWO[71,5]
                            END
                            IF NOT(YTRUE.2) THEN
                                YM.TRANS.CODE = R.NEW(4)
                                IF YM.TRANS.CODE = "SUS" OR YM.TRANS.CODE = "SSS" THEN
                                    YTRUE.2 = 1
                                    YM.PART.TWO = FMT(R.NEW(5),"75R"); YM.PART.TWO = YM.PART.TWO[69,7]
                                END
                            END
                            IF NOT(YTRUE.2) THEN YM.PART.TWO = ""
                            YM.REP.TWO = YM.PART.TWO
                            YM1.REP.TWO = YM1.REP.TWO : YM.REP.TWO
                            YM.REP.TWO = YM1.REP.TWO
                            YM.SORT.REF = YM.REP.TWO
                        END
                    END
                    IF NOT(YTRUE.1) THEN
                        YM.TRANS.CODE = R.NEW(4)
                        IF YM.TRANS.CODE = "CAP" THEN
                            YTRUE.1 = 1
                            YM.CCY = R.NEW(12)
                            YM.REP.ONE = YM.CCY
                            YM1.REP.ONE = YM.REP.ONE
                            YM.PART.ONE = R.NEW(4)
                            YM.REP.ONE = YM.PART.ONE
                            YM1.REP.ONE = YM1.REP.ONE : YM.REP.ONE
                            YM.REP.ONE = YM1.REP.ONE
                            YM.SORT.REF = YM.REP.ONE
                        END
                    END
                    IF NOT(YTRUE.1) THEN YM.SORT.REF = ""
                    YKEYFD = YM.SORT.REF

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.SORT.REF,"18L")


                    IF LEN(YKEYFD) > 18 THEN YKEYFD = YKEYFD[1,17]:"|"
                    GOSUB 8000000
                    YR.REC(3) = YM.SORT.REF
                    YM.TRANS.REF = R.NEW(17)
                    YKEYFD = YM.TRANS.REF

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.TRANS.REF,"18L")


                    IF LEN(YKEYFD) > 18 THEN YKEYFD = YKEYFD[1,17]:"|"
                    GOSUB 8000000
                    YR.REC(4) = YM.TRANS.REF
                    YM.ACCOUNT = FMT(R.NEW(5),"25L"); YM.ACCOUNT = YM.ACCOUNT[13,12]
                    YKEYFD = YM.ACCOUNT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

                    FULL.TXN.ID = ""
                    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

                    YKEYFD = FMT(YM.ACCOUNT,"14L")


                    IF LEN(YKEYFD) > 14 THEN YKEYFD = YKEYFD[1,13]:"|"
                    GOSUB 8000000
                    YR.REC(5) = YM.ACCOUNT
                    YM.AMOUNTLCY = R.NEW(3)
                    YR.REC(6) = YM.AMOUNTLCY
                    YM.TOTALNET = R.NEW(3)
                    YR.REC(7) = YM.TOTALNET
                    YTRUE.1 = 0
                    IF YM.AMOUNTLCY > 0 THEN
                        YTRUE.1 = 1
                        YM.AMOUNT.CREDIT = R.NEW(3)
                    END
                    IF NOT(YTRUE.1) THEN YM.AMOUNT.CREDIT = ""
                    YR.REC(8) = YM.AMOUNT.CREDIT
                    YTRUE.1 = 0
                    IF YM.AMOUNTLCY < 0 AND YM.AMOUNTLCY THEN
                        YTRUE.1 = 1
                        YM.AMOUNT.DEBIT = R.NEW(3)
                    END
                    IF NOT(YTRUE.1) THEN YM.AMOUNT.DEBIT = ""
                    YR.REC(9) = YM.AMOUNT.DEBIT
                    YM.RATE = R.NEW(14)
                    YR.REC(10) = YM.RATE
                    YM.CCY = R.NEW(12)
                    YR.REC(11) = YM.CCY
                    YM.FCYAMOUNT = R.NEW(13)
                    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
                    IF YM.FCYAMOUNT <> "" THEN
                        YM.FCYAMOUNT = TRIM(FMT(YM.FCYAMOUNT,"19R":YDEC))
                    END
                    YR.REC(12) = YM.FCYAMOUNT
                    YM.VALUE = ""
                    YR.REC(13) = YM.VALUE
                    YM.TRANS.CODE = R.NEW(4)
                    YR.REC(14) = YM.TRANS.CODE
                    YM.ACCT.OFF = R.NEW(9)
                    YR.REC(15) = YM.ACCT.OFF
                    YM.PRODUCT = R.NEW(10)
                    YR.REC(16) = YM.PRODUCT
                    YM.CUSTOMER = R.NEW(8)
                    IF YM.CUSTOMER <> "" THEN
                        YCOMP = "CUSTOMER_1_":YM.CUSTOMER
                        YFORFIL = YF.CUSTOMER
                        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                        YM.CUSTOMER = YFOR.FD
                    END
                    YR.REC(17) = YM.CUSTOMER
            END CASE
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
