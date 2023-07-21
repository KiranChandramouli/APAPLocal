* @ValidationCode : MjotNDE4NjExNzk5OkNwMTI1MjoxNjg4NTQ1NzUyMzg1OklUU1M6LTE6LTE6MTM0NTE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jul 2023 13:59:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 13451
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.Repgens
*-----------------------------------------------------------------------------
* <Rating>5997</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-07-2023      Harishvikram C   Manual R22 conversion      FM TO @FM, VM to @VM, SM to @SM
*-----------------------------------------------------------------------------------------------
SUBROUTINE RGS.LC.OUT.RSKPTY
REM "RGS.LC.OUT.RSKPTY",040129-3
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
    YF.VOC = ""
    OPEN "", "VOC" TO YF.VOC ELSE
        TEXT = "CANNOT OPEN VOC-FILE"
        CALL FATAL.ERROR ("RGS.LC.OUT.RSKPTY")
    END
*************************************************************************
    YT.SMS.COMP = ID.COMPANY
    YT.SMS.FILE = "LETTER.OF.CREDIT"
    YT.SMS.FILE<-1> = "DRAWINGS"
    YT.SMS.FILE<-1> = "CUSTOMER"
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
    DIM YR.REC(18)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.LC.OUT.RSKPTY"
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
        CALL FATAL.ERROR ("RGS.LC.OUT.RSKPTY")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "LETTER.OF.CREDIT"
    YT.SMS.FILE<-1> = "DRAWINGS"
    YT.SMS.FILE<-1> = "CUSTOMER"
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
    YFILE = "F.LETTER.OF.CREDIT"; YF.LETTER.OF.CREDIT = ""
    CALL OPF (YFILE, YF.LETTER.OF.CREDIT)
    YFILE = "F.CUSTOMER"; YF.CUSTOMER = ""
    CALL OPF (YFILE, YF.CUSTOMER)
    YFILE = "F.COMPANY"; YF.COMPANY = ""
    CALL OPF (YFILE, YF.COMPANY)
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
            GOSUB 2000000
        END
*
    REPEAT
*************************************************************************
    YFILE = "DRAWINGS"
    FULL.FNAME = "F.DRAWINGS"; YF.DRAWINGS = ""
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
    CALL OPF (FULL.FNAME, YF.DRAWINGS)
    YR.VOC = "D"; YR.VOC<2> = 1
    YR.VOC<5> = "2L"
    YR.VOC<6> = 1
    WRITE YR.VOC TO YF.VOC, "FLD.":TNO
    CLEARSELECT
    EXECUTE "HUSH ON"
    EXECUTE 'SSELECT ':FULL.FNAME:' WITH FLD.':TNO:' = "AC" OR WITH FLD.':TNO:' = "DP"' ;* R22 Manual conversion - SELECT changed to SSELECT
    EXECUTE "HUSH OFF"
    CALL EB.READLIST('', YID.LIST, '', '', '')
    LOOP
        REMOVE ID.NEW FROM YID.LIST SETTING YDELIM
    WHILE ID.NEW:YDELIM
        MATREAD R.NEW FROM YF.DRAWINGS, ID.NEW ELSE ID.NEW = "" ; MAT R.NEW = ""
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
        YR.REC(18)  := @FM
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
        CASE YFILE = "LETTER.OF.CREDIT"
            YKEY = ""; MAT YR.REC = ""
            YM.LIAB.NO = R.NEW(18)
            IF YM.LIAB.NO <> "" THEN
                YCOMP = "CUSTOMER_25_":YM.LIAB.NO
                YFORFIL = YF.CUSTOMER
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LIAB.NO = YFOR.FD
            END
            YKEYFD = YM.LIAB.NO

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.LIAB.NO,"12L")


            IF LEN(YKEYFD) > 12 THEN YKEYFD = YKEYFD[1,11]:"|"
            GOSUB 8000000
            YM.TOT.BY.CHANGE = YM.LIAB.NO
            YKEYFD = YM.TOT.BY.CHANGE

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.TOT.BY.CHANGE,"18L")


            IF LEN(YKEYFD) > 18 THEN YKEYFD = YKEYFD[1,17]:"|"
            GOSUB 8000000
            YM.FOT.TEXT1 = "---------------------------------"
            YR.REC(1) = YM.FOT.TEXT1
            YM.FOT.TEXT2 = "---------------------------------"
            YR.REC(2) = YM.FOT.TEXT2
            YM.FOT.TEXT3 = "---------------------------------"
            YR.REC(3) = YM.FOT.TEXT3
            YM.FOT.TEXT4 = "---------------------------------"
            YR.REC(4) = YM.FOT.TEXT4
            YM.ISS.DATE.SORT = R.NEW(27)
            YKEYFD = YM.ISS.DATE.SORT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.ISS.DATE.SORT,"13L")


            IF LEN(YKEYFD) > 13 THEN YKEYFD = YKEYFD[1,12]:"|"
            GOSUB 8000000
            YM.EXP.DATE.SORT = R.NEW(28)
            YKEYFD = YM.EXP.DATE.SORT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.EXP.DATE.SORT,"13L")


            IF LEN(YKEYFD) > 13 THEN YKEYFD = YKEYFD[1,12]:"|"
            GOSUB 8000000
            YM.ID.SEQ.CONT = ID.NEW
            YKEYFD = YM.ID.SEQ.CONT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.ID.SEQ.CONT,"18L")


            IF LEN(YKEYFD) > 18 THEN YKEYFD = YKEYFD[1,17]:"|"
            GOSUB 8000000
            YM.LC.ID.PRINT = ID.NEW
            YR.REC(5) = YM.LC.ID.PRINT
            YM.OLD.LC.NUM = R.NEW(105)
            YR.REC(6) = YM.OLD.LC.NUM
            YM.ISSUE.DATE = R.NEW(27)
            YR.REC(7) = YM.ISSUE.DATE
            YM.ISSUE.REF = YM.LIAB.NO
            IF YM.ISSUE.REF <> "" THEN
                YCOMP = "CUSTOMER_2_":YM.ISSUE.REF
                YFORFIL = YF.CUSTOMER
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.ISSUE.REF = YFOR.FD
            END
            YR.REC(8) = YM.ISSUE.REF
            YM.CURR = R.NEW(20)
            YR.REC(9) = YM.CURR
            YM.LC.AMT = R.NEW(21)
            YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
            IF YM.LC.AMT <> "" THEN
                YM.LC.AMT = TRIM(FMT(YM.LC.AMT,"19R":YDEC))
            END
            YR.REC(10) = YM.LC.AMT
            YM.LIAB.AMT = R.NEW(117)
            YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
            YCOUNT.RPL = COUNT(YM.LIAB.AMT,@VM)+1
            FOR YAV.RPL = 1 TO YCOUNT.RPL
                IF YM.LIAB.AMT<1,YAV.RPL> <> "" THEN
                    YM.LIAB.AMT<1,YAV.RPL> = TRIM(FMT(YM.LIAB.AMT<1,YAV.RPL>,"19R":YDEC))
                END
            NEXT YAV.RPL
            YR.REC(11) = YM.LIAB.AMT
            YM.EXPIRY.DATE = R.NEW(28)
            YR.REC(12) = YM.EXPIRY.DATE
            YTRUE.1 = 0
            YM.LOCAL.CURRENCY = R.NEW(137)
            IF YM.LOCAL.CURRENCY <> "" THEN
                YCOMP = "COMPANY_16_":YM.LOCAL.CURRENCY
                YFORFIL = YF.COMPANY
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LOCAL.CURRENCY = YFOR.FD
            END
            IF YM.CURR <> YM.LOCAL.CURRENCY THEN
                YTRUE.1 = 1
                YM.ARG.AMT = R.NEW(117)
                YM25.GOSUB = YM.ARG.AMT
                YM.ARG.CCY = R.NEW(20)
                YM26.GOSUB = YM.ARG.CCY
                YM.ARG.MKT = R.NEW(24)
                YM27.GOSUB = YM.ARG.MKT
                YM.LOCAL.LC.OS = ""
                YM28.GOSUB = YM.LOCAL.LC.OS
                CALL @MIDDLE.RATE.CONV.CHECK (YM25.GOSUB, YM26.GOSUB, "", YM27.GOSUB, YM28.GOSUB, "", "")
                YM.ARG.AMT = YM25.GOSUB
                YM.ARG.CCY = YM26.GOSUB
                YM.ARG.MKT = YM27.GOSUB
                YM.LOCAL.LC.OS = YM28.GOSUB
                YM.OS.LC.AMT = YM.LOCAL.LC.OS
            END
            IF NOT(YTRUE.1) THEN
                YM.LOCAL.CURRENCY = R.NEW(137)
                IF YM.LOCAL.CURRENCY <> "" THEN
                    YCOMP = "COMPANY_16_":YM.LOCAL.CURRENCY
                    YFORFIL = YF.COMPANY
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.LOCAL.CURRENCY = YFOR.FD
                END
                IF YM.CURR = YM.LOCAL.CURRENCY THEN
                    YTRUE.1 = 1
                    YM.OS.LC.AMT = R.NEW(117)
                END
            END
            IF NOT(YTRUE.1) THEN YM.OS.LC.AMT = ""
            YM.TOT.OS.AMT = YM.OS.LC.AMT
            YR.REC(13) = YM.TOT.OS.AMT
            YM.ID.DRAW.PRINT = ""
            YR.REC(14) = YM.ID.DRAW.PRINT
            YM.DRAW.AMT.LINE = ""
            YM.DR.CURR = ""
            YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.DR.CURR, YDEC)
            IF YM.DRAW.AMT.LINE <> "" THEN
                YM.DRAW.AMT.LINE = TRIM(FMT(YM.DRAW.AMT.LINE,"19R":YDEC))
            END
            YR.REC(15) = YM.DRAW.AMT.LINE
            YM.MAT.DATE = ""
            YR.REC(16) = YM.MAT.DATE
            YM.TOTAL.DR.OS = ""
            YR.REC(17) = YM.TOTAL.DR.OS
            YM.TOTAL.OS.AMT = YM.OS.LC.AMT
            YR.REC(18) = YM.TOTAL.OS.AMT
*------------------------------------------------------------------------
        CASE YFILE = "DRAWINGS"
            YKEY = ""; MAT YR.REC = ""
            YM.DRAWINGS.CUST = FMT(ID.NEW,"12L"); YM.DRAWINGS.CUST = YM.DRAWINGS.CUST[1,12]
            IF YM.DRAWINGS.CUST <> "" THEN
                YCOMP = "LETTER.OF.CREDIT_18_":YM.DRAWINGS.CUST
                YFORFIL = YF.LETTER.OF.CREDIT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.DRAWINGS.CUST = YFOR.FD
            END
            YM.LIAB.NO = YM.DRAWINGS.CUST
            IF YM.LIAB.NO <> "" THEN
                YCOMP = "CUSTOMER_25_":YM.LIAB.NO
                YFORFIL = YF.CUSTOMER
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LIAB.NO = YFOR.FD
            END
            YKEYFD = YM.LIAB.NO

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.LIAB.NO,"12L")


            IF LEN(YKEYFD) > 12 THEN YKEYFD = YKEYFD[1,11]:"|"
            GOSUB 8000000
            YM.TOT.BY.CHANGE = YM.LIAB.NO
            YKEYFD = YM.TOT.BY.CHANGE

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.TOT.BY.CHANGE,"18L")


            IF LEN(YKEYFD) > 18 THEN YKEYFD = YKEYFD[1,17]:"|"
            GOSUB 8000000
            YM.FOT.TEXT1 = "---------------------------------"
            YR.REC(1) = YM.FOT.TEXT1
            YM.FOT.TEXT2 = "---------------------------------"
            YR.REC(2) = YM.FOT.TEXT2
            YM.FOT.TEXT3 = "---------------------------------"
            YR.REC(3) = YM.FOT.TEXT3
            YM.FOT.TEXT4 = "---------------------------------"
            YR.REC(4) = YM.FOT.TEXT4
            YM.ISS.DATE.SORT = FMT(ID.NEW,"12L"); YM.ISS.DATE.SORT = YM.ISS.DATE.SORT[1,12]
            IF YM.ISS.DATE.SORT <> "" THEN
                YCOMP = "LETTER.OF.CREDIT_27_":YM.ISS.DATE.SORT
                YFORFIL = YF.LETTER.OF.CREDIT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.ISS.DATE.SORT = YFOR.FD
            END
            YKEYFD = YM.ISS.DATE.SORT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.ISS.DATE.SORT,"13L")


            IF LEN(YKEYFD) > 13 THEN YKEYFD = YKEYFD[1,12]:"|"
            GOSUB 8000000
            YM.EXP.DATE.SORT = FMT(ID.NEW,"12L"); YM.EXP.DATE.SORT = YM.EXP.DATE.SORT[1,12]
            IF YM.EXP.DATE.SORT <> "" THEN
                YCOMP = "LETTER.OF.CREDIT_28_":YM.EXP.DATE.SORT
                YFORFIL = YF.LETTER.OF.CREDIT
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.EXP.DATE.SORT = YFOR.FD
            END
            YKEYFD = YM.EXP.DATE.SORT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.EXP.DATE.SORT,"13L")


            IF LEN(YKEYFD) > 13 THEN YKEYFD = YKEYFD[1,12]:"|"
            GOSUB 8000000
            YM.ID.SEQ.CONT = ID.NEW
            YKEYFD = YM.ID.SEQ.CONT

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

            FULL.TXN.ID = ""
            CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

            YKEYFD = FMT(YM.ID.SEQ.CONT,"18L")


            IF LEN(YKEYFD) > 18 THEN YKEYFD = YKEYFD[1,17]:"|"
            GOSUB 8000000
            YM.LC.ID.PRINT = ""
            YR.REC(5) = YM.LC.ID.PRINT
            YM.OLD.LC.NUM = ""
            YR.REC(6) = YM.OLD.LC.NUM
            YM.ISSUE.DATE = ""
            YR.REC(7) = YM.ISSUE.DATE
            YM.ISSUE.REF = YM.LIAB.NO
            IF YM.ISSUE.REF <> "" THEN
                YCOMP = "CUSTOMER_2_":YM.ISSUE.REF
                YFORFIL = YF.CUSTOMER
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.ISSUE.REF = YFOR.FD
            END
            YR.REC(8) = YM.ISSUE.REF
            YM.CURR = ""
            YR.REC(9) = YM.CURR
            YM.LC.AMT = ""
            YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
            IF YM.LC.AMT <> "" THEN
                YM.LC.AMT = TRIM(FMT(YM.LC.AMT,"19R":YDEC))
            END
            YR.REC(10) = YM.LC.AMT
            YM.LIAB.AMT = ""
            YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURR, YDEC)
            YCOUNT.RPL = COUNT(YM.LIAB.AMT,@VM)+1
            FOR YAV.RPL = 1 TO YCOUNT.RPL
                IF YM.LIAB.AMT<1,YAV.RPL> <> "" THEN
                    YM.LIAB.AMT<1,YAV.RPL> = TRIM(FMT(YM.LIAB.AMT<1,YAV.RPL>,"19R":YDEC))
                END
            NEXT YAV.RPL
            YR.REC(11) = YM.LIAB.AMT
            YM.EXPIRY.DATE = ""
            YR.REC(12) = YM.EXPIRY.DATE
            YM.TOT.OS.AMT = ""
            YR.REC(13) = YM.TOT.OS.AMT
            YM.ID.DRAW.PRINT = ID.NEW
            YR.REC(14) = YM.ID.DRAW.PRINT
            YM.DRAW.AMT.LINE = R.NEW(3)
            YM.DR.CURR = R.NEW(2)
            YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.DR.CURR, YDEC)
            IF YM.DRAW.AMT.LINE <> "" THEN
                YM.DRAW.AMT.LINE = TRIM(FMT(YM.DRAW.AMT.LINE,"19R":YDEC))
            END
            YR.REC(15) = YM.DRAW.AMT.LINE
            YM.MAT.DATE = R.NEW(7)
            YR.REC(16) = YM.MAT.DATE
            YTRUE.1 = 0
            YM.LOCAL.CURRENCY = R.NEW(103)
            IF YM.LOCAL.CURRENCY <> "" THEN
                YCOMP = "COMPANY_16_":YM.LOCAL.CURRENCY
                YFORFIL = YF.COMPANY
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.LOCAL.CURRENCY = YFOR.FD
            END
            IF YM.DR.CURR <> YM.LOCAL.CURRENCY THEN
                YTRUE.1 = 1
                YM.DR.ARG.AMT = R.NEW(3)
                YM29.GOSUB = YM.DR.ARG.AMT
                YM.DR.ARG.CCY = YM.DR.CURR
                YM30.GOSUB = YM.DR.ARG.CCY
                YM.DR.MKT = FMT(ID.NEW,"12L"); YM.DR.MKT = YM.DR.MKT[1,12]
                IF YM.DR.MKT <> "" THEN
                    YCOMP = "LETTER.OF.CREDIT_24_":YM.DR.MKT
                    YFORFIL = YF.LETTER.OF.CREDIT
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.DR.MKT = YFOR.FD
                END
                YM.DR.ARG.MKT = YM.DR.MKT
                YM31.GOSUB = YM.DR.ARG.MKT
                YM.DR.AMT.OS = ""
                YM32.GOSUB = YM.DR.AMT.OS
                CALL @MIDDLE.RATE.CONV.CHECK (YM29.GOSUB, YM30.GOSUB, "", YM31.GOSUB, YM32.GOSUB, "", "")
                YM.DR.ARG.AMT = YM29.GOSUB
                YM.DR.ARG.CCY = YM30.GOSUB
                YM.DR.ARG.MKT = YM31.GOSUB
                YM.DR.AMT.OS = YM32.GOSUB
                YM.OS.DR.AMT = YM.DR.AMT.OS
            END
            IF NOT(YTRUE.1) THEN
                YM.LOCAL.CURRENCY = R.NEW(103)
                IF YM.LOCAL.CURRENCY <> "" THEN
                    YCOMP = "COMPANY_16_":YM.LOCAL.CURRENCY
                    YFORFIL = YF.COMPANY
                    YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                    YM.LOCAL.CURRENCY = YFOR.FD
                END
                IF YM.DR.CURR = YM.LOCAL.CURRENCY THEN
                    YTRUE.1 = 1
                    YM.OS.DR.AMT = R.NEW(3)
                END
            END
            IF NOT(YTRUE.1) THEN YM.OS.DR.AMT = ""
            YM.TOTAL.DR.OS = YM.OS.DR.AMT
            YR.REC(17) = YM.TOTAL.DR.OS
            YM.TOTAL.OS.AMT = YM.OS.DR.AMT
            YR.REC(18) = YM.TOTAL.OS.AMT
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
