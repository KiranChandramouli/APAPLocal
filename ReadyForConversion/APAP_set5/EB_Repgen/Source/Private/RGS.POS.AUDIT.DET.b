$PACKAGE EB.Repgen
  SUBROUTINE RGS.POS.AUDIT.DET
REM "RGS.POS.AUDIT.DET",230614-4
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
  MIDDLE.RATE.CONV.CHECK = "MIDDLE.RATE.CONV.CHECK"
*************************************************************************
  YT.SMS.COMP = ID.COMPANY
  YT.SMS.FILE = "POSITION.LWORK.DAY"
  YT.SMS.FILE<-1> = "STMT.ENTRY"
  YT.SMS.FILE<-1> = "RE.CONSOL.SPEC.ENTRY"
  YT.SMS.FILE<-1> = "FOREX"
  YT.SMS.FILE<-1> = "DATES"
  YT.SMS.FILE<-1> = "DEALER.DESK"
  YT.SMS.FILE<-1> = "CURRENCY"
  YT.SMS.FILE<-1> = "ACCT.ENT.TODAY"
  YT.SMS.FILE<-1> = "RE.SPEC.ENT.TODAY"
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
  DIM YR.REC(23)
  YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.POS.AUDIT.DET"
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
    CALL FATAL.ERROR ("RGS.POS.AUDIT.DET")
  END
*
  YCOM = ID.COMPANY
*
  YT.SMS = ""
  YT.SMS.FILE = "POSITION.LWORK.DAY"
  YT.SMS.FILE<-1> = "STMT.ENTRY"
  YT.SMS.FILE<-1> = "RE.CONSOL.SPEC.ENTRY"
  YT.SMS.FILE<-1> = "FOREX"
  YT.SMS.FILE<-1> = "DATES"
  YT.SMS.FILE<-1> = "DEALER.DESK"
  YT.SMS.FILE<-1> = "CURRENCY"
  YT.SMS.FILE<-1> = "ACCT.ENT.TODAY"
  YT.SMS.FILE<-1> = "RE.SPEC.ENT.TODAY"
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
  YFILE = "F.FOREX"; YF.FOREX = ""
  CALL OPF (YFILE, YF.FOREX)
  YFILE = "F.DATES"; YF.DATES = ""
  CALL OPF (YFILE, YF.DATES)
  YFILE = "F.DEALER.DESK"; YF.DEALER.DESK = ""
  CALL OPF (YFILE, YF.DEALER.DESK)
  YFILE = "F.CURRENCY"; YF.CURRENCY = ""
  CALL OPF (YFILE, YF.CURRENCY)
*************************************************************************
  YFILE = "POSITION.LWORK.DAY"
  FULL.FNAME = "F.POSITION.LWORK.DAY"; YF.POSITION.LWORK.DAY = ""
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
  CALL OPF (FULL.FNAME, YF.POSITION.LWORK.DAY)
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
    MATREAD R.NEW FROM YF.POSITION.LWORK.DAY, ID.NEW ELSE ID.NEW = "" ; MAT R.NEW = ""
    IF T.PWD THEN
      CALL CONTROL.USER.PROFILE ("RECORD")
      IF ETEXT THEN ID.NEW = ""
    END
    IF ID.NEW <> "" THEN
*
* Handle Decision Table
      YM.CURRENCY = FMT(ID.NEW,"28L"); YM.CURRENCY = YM.CURRENCY[15,3]
      YM.OUTPUT.ARG = "NC"
      YTRUE.1 = 0
      YM.RUN.DATE = "GB0010001"
      IF YM.RUN.DATE <> "" THEN
        YCOMP = "DATES_1_":YM.RUN.DATE
        YFORFIL = YF.DATES
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.RUN.DATE = YFOR.FD
      END
      YM.KEY.DATE = FMT(ID.NEW,"28L"); YM.KEY.DATE = YM.KEY.DATE[21,8]
      IF YM.KEY.DATE <= YM.RUN.DATE THEN
        YTRUE.1 = 1
        YM.POS.TRANS = "XXX"
      END
      IF NOT(YTRUE.1) THEN
        YM.RUN.DATE = "GB0010001"
        IF YM.RUN.DATE <> "" THEN
          YCOMP = "DATES_1_":YM.RUN.DATE
          YFORFIL = YF.DATES
          YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
          YM.RUN.DATE = YFOR.FD
        END
        YM.KEY.DATE = FMT(ID.NEW,"28L"); YM.KEY.DATE = YM.KEY.DATE[21,8]
        IF YM.KEY.DATE > YM.RUN.DATE THEN
          YTRUE.1 = 1
          YM.POS.TRANS = "RVL"
        END
      END
      IF NOT(YTRUE.1) THEN YM.POS.TRANS = ""
      YM.TRANS.CODE = YM.POS.TRANS
      IF YM.CURRENCY <> "GBP" AND YM.CURRENCY <> "" AND YM.OUTPUT.ARG = "NC" AND YM.TRANS.CODE <> "RVL" THEN
        GOSUB 2000000
      END
    END
*
  REPEAT
*************************************************************************
  YFILE = "ACCT.ENT.TODAY"
  FULL.FNAME = "F.ACCT.ENT.TODAY"; YF.ACCT.ENT.TODAY = ""
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
  CALL OPF (FULL.FNAME, YF.ACCT.ENT.TODAY)
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
    READ YR.KEYS FROM YF.ACCT.ENT.TODAY, WR.NEW ELSE YR.KEYS = ""
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
          YM.CURRENCY = R.NEW(12)
          YM.OUTPUT.ARG = "NC"
          YM.TRANS.CODE = R.NEW(4)
          IF YM.CURRENCY <> "GBP" AND YM.CURRENCY <> "" AND YM.OUTPUT.ARG = "NC" AND YM.TRANS.CODE <> "RVL" THEN
            GOSUB 2000000
          END
        END
      REPEAT
*
  REPEAT
*************************************************************************
  YFILE = "RE.SPEC.ENT.TODAY"
  FULL.FNAME = "F.RE.SPEC.ENT.TODAY"; YF.RE.SPEC.ENT.TODAY = ""
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
  CALL OPF (FULL.FNAME, YF.RE.SPEC.ENT.TODAY)
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
    READ YR.KEYS FROM YF.RE.SPEC.ENT.TODAY, WR.NEW ELSE YR.KEYS = ""
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
          YM.CURRENCY = R.NEW(12)
          YM.INPUT.ARG = R.NEW(5)
          YM4.GOSUB = YM.INPUT.ARG
          YM.OUTPUT.ARG = ""
          YM5.GOSUB = YM.OUTPUT.ARG
          CALL @RG.GET.CONSOL.TYPE (YM4.GOSUB, YM5.GOSUB)
          YM.INPUT.ARG = YM4.GOSUB
          YM.OUTPUT.ARG = YM5.GOSUB
          YM.TRANS.CODE = R.NEW(4)
          IF YM.CURRENCY <> "GBP" AND YM.CURRENCY <> "" AND YM.OUTPUT.ARG = "NC" AND YM.TRANS.CODE <> "RVL" THEN
            GOSUB 2000000
          END
        END
      REPEAT
*
  REPEAT
  IF YKEYNO THEN
  YR.REC(23)  := @FM
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
    CASE YFILE = "POSITION.LWORK.DAY"
      YKEY = ""; MAT YR.REC = ""
      YM.CURRENCY = FMT(ID.NEW,"28L"); YM.CURRENCY = YM.CURRENCY[15,3]
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
      YR.REC(1) = YM.CURRENCY
      YM.DEPT.ACCT = FMT(ID.NEW,"28L"); YM.DEPT.ACCT = YM.DEPT.ACCT[13,2]
      IF YM.DEPT.ACCT <> "" THEN
        YCOMP = "DEALER.DESK_2_":YM.DEPT.ACCT
        YFORFIL = YF.DEALER.DESK
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.DEPT.ACCT = YFOR.FD
      END
      YKEYFD = FMT(YM.DEPT.ACCT,"R####")
      IF LEN(YKEYFD) > 4 THEN YKEYFD = YKEYFD[1,3]:"|"
      GOSUB 8000000
      YR.REC(2) = YM.DEPT.ACCT
      YM.DEAL.DESK = FMT(ID.NEW,"28L"); YM.DEAL.DESK = YM.DEAL.DESK[13,2]
      YR.REC(3) = YM.DEAL.DESK
      YTRUE.1 = 0
      YM.DEPT.LOOK = FMT(ID.NEW,"28L"); YM.DEPT.LOOK = YM.DEPT.LOOK[13,2]
      IF YM.DEPT.LOOK <> 00 THEN
        YTRUE.1 = 1
        YM.SORT.DESK = YM.DEAL.DESK
      END
      IF NOT(YTRUE.1) THEN
        YM.DEPT.LOOK = FMT(ID.NEW,"28L"); YM.DEPT.LOOK = YM.DEPT.LOOK[13,2]
        IF YM.DEPT.LOOK = 00 THEN
          YTRUE.1 = 1
          YM.SORT.DESK = "99"
        END
      END
      IF NOT(YTRUE.1) THEN YM.SORT.DESK = ""
      YKEYFD = YM.SORT.DESK

    * check ID to see if it matches keys with contract no. in the format
    * xxyydddnnnnn. if it does, extend the year (yy) component of the key
    * to yyyy and use this as the id to the REPGEN work file. all the
    * aforementioned processing is done in ENQ.BUILD.TXN and is part of
    * Year 2000 compliance

      FULL.TXN.ID = ""
      CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

      YKEYFD = FMT(YM.SORT.DESK,"4L")


      IF LEN(YKEYFD) > 4 THEN YKEYFD = YKEYFD[1,3]:"|"
      GOSUB 8000000
      YM.REF3 = FMT(ID.NEW,"28L"); YM.REF3 = YM.REF3[10,8]
      YKEYFD = YM.REF3

    * check ID to see if it matches keys with contract no. in the format
    * xxyydddnnnnn. if it does, extend the year (yy) component of the key
    * to yyyy and use this as the id to the REPGEN work file. all the
    * aforementioned processing is done in ENQ.BUILD.TXN and is part of
    * Year 2000 compliance

      FULL.TXN.ID = ""
      CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

      YKEYFD = FMT(YM.REF3,"10L")


      IF LEN(YKEYFD) > 10 THEN YKEYFD = YKEYFD[1,9]:"|"
      GOSUB 8000000
      YR.REC(4) = YM.REF3
      YM.MID.RATE = YM.CURRENCY
      IF YM.MID.RATE <> "" THEN
        YCOMP = "CURRENCY_14.1_":YM.MID.RATE
        YFORFIL = YF.CURRENCY
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.MID.RATE = YFOR.FD
      END
      YR.REC(5) = YM.MID.RATE
      YM.TYPE = "1"
      YKEYFD = YM.TYPE

    * check ID to see if it matches keys with contract no. in the format
    * xxyydddnnnnn. if it does, extend the year (yy) component of the key
    * to yyyy and use this as the id to the REPGEN work file. all the
    * aforementioned processing is done in ENQ.BUILD.TXN and is part of
    * Year 2000 compliance

      FULL.TXN.ID = ""
      CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

      YKEYFD = FMT(YM.TYPE,"3L")


      IF LEN(YKEYFD) > 3 THEN YKEYFD = YKEYFD[1,2]:"|"
      GOSUB 8000000
      YM.FOOT.ONE = "-------------------"
      YR.REC(6) = YM.FOOT.ONE
      YM.FOOT.TWO = "-------------------"
      YR.REC(7) = YM.FOOT.TWO
      YM.FOOT.THREE = "-------------------"
      YR.REC(8) = YM.FOOT.THREE
      YM.FOOT.FOUR = "---------------------"
      YR.REC(9) = YM.FOOT.FOUR
      YM.FOOT.FIVE = "---------------------"
      YR.REC(10) = YM.FOOT.FIVE
      YM.FOOT.TEXT = "POSITION"
      YR.REC(11) = YM.FOOT.TEXT
      YM.SORT.REF = FMT(ID.NEW,"28L"); YM.SORT.REF = YM.SORT.REF[21,8]
      YKEYFD = YM.SORT.REF

    * check ID to see if it matches keys with contract no. in the format
    * xxyydddnnnnn. if it does, extend the year (yy) component of the key
    * to yyyy and use this as the id to the REPGEN work file. all the
    * aforementioned processing is done in ENQ.BUILD.TXN and is part of
    * Year 2000 compliance

      FULL.TXN.ID = ""
      CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

      YKEYFD = FMT(YM.SORT.REF,"10L")


      IF LEN(YKEYFD) > 10 THEN YKEYFD = YKEYFD[1,9]:"|"
      GOSUB 8000000
      YM.REFERENCE = FMT(ID.NEW,"28L"); YM.REFERENCE = YM.REFERENCE[10,19]
      YR.REC(12) = YM.REFERENCE
      YM.OPEN.COM = "OPENING"
      YR.REC(13) = YM.OPEN.COM
      YM.CCY.OPEN.POS = R.NEW(1)
      YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURRENCY, YDEC)
      IF YM.CCY.OPEN.POS <> "" THEN
        YM.CCY.OPEN.POS = TRIM(FMT(YM.CCY.OPEN.POS,"19R":YDEC))
      END
      YR.REC(14) = YM.CCY.OPEN.POS
      YM.LCY.OPEN.POS = R.NEW(3)
      YR.REC(15) = YM.LCY.OPEN.POS
      YM.CCY.ENTRY.TOT = ""
      YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURRENCY, YDEC)
      IF YM.CCY.ENTRY.TOT <> "" THEN
        YM.CCY.ENTRY.TOT = TRIM(FMT(YM.CCY.ENTRY.TOT,"19R":YDEC))
      END
      YR.REC(16) = YM.CCY.ENTRY.TOT
      YM.LCY.ENTRY.TOT = ""
      YR.REC(17) = YM.LCY.ENTRY.TOT
      YM.CCY.CLOSE.POS = R.NEW(1)
      YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURRENCY, YDEC)
      IF YM.CCY.CLOSE.POS <> "" THEN
        YM.CCY.CLOSE.POS = TRIM(FMT(YM.CCY.CLOSE.POS,"19R":YDEC))
      END
      YR.REC(18) = YM.CCY.CLOSE.POS
      YM.LCY.CCY.AMT = R.NEW(1)
      YM39.GOSUB = YM.LCY.CCY.AMT
      YM.LCC.CCY = YM.CURRENCY
      YM40.GOSUB = YM.LCC.CCY
      YM.LCY.MKT = FMT(ID.NEW,"28L"); YM.LCY.MKT = YM.LCY.MKT[10,1]
      YM41.GOSUB = YM.LCY.MKT
      YM.LCY.ANS = ""
      YM42.GOSUB = YM.LCY.ANS
      CALL @MIDDLE.RATE.CONV.CHECK (YM39.GOSUB, YM40.GOSUB, "", YM41.GOSUB, YM42.GOSUB, "", "")
      YM.LCY.CCY.AMT = YM39.GOSUB
      YM.LCC.CCY = YM40.GOSUB
      YM.LCY.MKT = YM41.GOSUB
      YM.LCY.ANS = YM42.GOSUB
      YM.LCY.CLOSE.POS = YM.LCY.ANS
      YR.REC(19) = YM.LCY.CLOSE.POS
      YM.LCY.PANDL = YM.LCY.OPEN.POS
      YM1.LCY.PANDL = YM.LCY.PANDL
      YM.LCY.PANDL = YM.LCY.CLOSE.POS
      IF NUM(YM1.LCY.PANDL) = NUMERIC THEN IF NUM(YM.LCY.PANDL) = NUMERIC THEN
        YM1.LCY.PANDL = YM1.LCY.PANDL - YM.LCY.PANDL
        IF YM1.LCY.PANDL = 0 THEN YM1.LCY.PANDL = ""
      END
      YM.LCY.PANDL = YM1.LCY.PANDL
      YR.REC(20) = YM.LCY.PANDL
      YM.CCY.CLOSE.TOT = YM.CCY.CLOSE.POS
      YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURRENCY, YDEC)
      IF YM.CCY.CLOSE.TOT <> "" THEN
        YM.CCY.CLOSE.TOT = TRIM(FMT(YM.CCY.CLOSE.TOT,"19R":YDEC))
      END
      YR.REC(21) = YM.CCY.CLOSE.TOT
      YM.LCY.CLOSE.TOT = YM.LCY.CLOSE.POS
      YR.REC(22) = YM.LCY.CLOSE.TOT
      YM.LCY.PANDL.TOT = YM.LCY.PANDL
      YR.REC(23) = YM.LCY.PANDL.TOT
*------------------------------------------------------------------------
    CASE YFILE = "STMT.ENTRY"
      YKEY = ""; MAT YR.REC = ""
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
      YR.REC(1) = YM.CURRENCY
      YTRUE.1 = 0
      YM.OUR.REF.SY = FMT(R.NEW(17),"2L"); YM.OUR.REF.SY = YM.OUR.REF.SY[1,2]
      IF YM.OUR.REF.SY = "FX" THEN
        YTRUE.1 = 1
        YM.DEPT.FIND = R.NEW(17)
        IF YM.DEPT.FIND <> "" THEN
          YCOMP = "FOREX_4_":YM.DEPT.FIND
          YFORFIL = YF.FOREX
          YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
          YM.DEPT.FIND = YFOR.FD
        END
        YM.DEPT.LOOK = YM.DEPT.FIND
      END
      IF NOT(YTRUE.1) THEN
        YM.OUR.REF.SY = FMT(R.NEW(17),"2L"); YM.OUR.REF.SY = YM.OUR.REF.SY[1,2]
        IF YM.OUR.REF.SY <> "FX" THEN
          YTRUE.1 = 1
          YM.DEPT.LOOK = "00"
        END
      END
      IF NOT(YTRUE.1) THEN YM.DEPT.LOOK = ""
      YM.DEPT.ACCT = YM.DEPT.LOOK
      IF YM.DEPT.ACCT <> "" THEN
        YCOMP = "DEALER.DESK_2_":YM.DEPT.ACCT
        YFORFIL = YF.DEALER.DESK
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.DEPT.ACCT = YFOR.FD
      END
      YKEYFD = FMT(YM.DEPT.ACCT,"R####")
      IF LEN(YKEYFD) > 4 THEN YKEYFD = YKEYFD[1,3]:"|"
      GOSUB 8000000
      YR.REC(2) = YM.DEPT.ACCT
      YM.DEAL.DESK = YM.DEPT.LOOK
      YR.REC(3) = YM.DEAL.DESK
      YTRUE.1 = 0
      IF YM.DEPT.LOOK <> 00 THEN
        YTRUE.1 = 1
        YM.SORT.DESK = YM.DEAL.DESK
      END
      IF NOT(YTRUE.1) THEN
        IF YM.DEPT.LOOK = 00 THEN
          YTRUE.1 = 1
          YM.SORT.DESK = "99"
        END
      END
      IF NOT(YTRUE.1) THEN YM.SORT.DESK = ""
      YKEYFD = YM.SORT.DESK

    * check ID to see if it matches keys with contract no. in the format
    * xxyydddnnnnn. if it does, extend the year (yy) component of the key
    * to yyyy and use this as the id to the REPGEN work file. all the
    * aforementioned processing is done in ENQ.BUILD.TXN and is part of
    * Year 2000 compliance

      FULL.TXN.ID = ""
      CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

      YKEYFD = FMT(YM.SORT.DESK,"4L")


      IF LEN(YKEYFD) > 4 THEN YKEYFD = YKEYFD[1,3]:"|"
      GOSUB 8000000
      YM.REF1 = "1TR"
      YM.REF2 = YM.REF1
      YM1.REF2 = YM.REF2
      YM.REF2 = YM.DEAL.DESK
      YM1.REF2 = YM1.REF2 : YM.REF2
      YM.REF2 = YM1.REF2
      YM.REF3 = YM.REF2
      YM1.REF3 = YM.REF3
      YM.REF3 = YM.CURRENCY
      YM1.REF3 = YM1.REF3 : YM.REF3
      YM.REF3 = YM1.REF3
      YKEYFD = YM.REF3

    * check ID to see if it matches keys with contract no. in the format
    * xxyydddnnnnn. if it does, extend the year (yy) component of the key
    * to yyyy and use this as the id to the REPGEN work file. all the
    * aforementioned processing is done in ENQ.BUILD.TXN and is part of
    * Year 2000 compliance

      FULL.TXN.ID = ""
      CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

      YKEYFD = FMT(YM.REF3,"10L")


      IF LEN(YKEYFD) > 10 THEN YKEYFD = YKEYFD[1,9]:"|"
      GOSUB 8000000
      YR.REC(4) = YM.REF3
      YM.MID.RATE = YM.CURRENCY
      IF YM.MID.RATE <> "" THEN
        YCOMP = "CURRENCY_14.1_":YM.MID.RATE
        YFORFIL = YF.CURRENCY
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.MID.RATE = YFOR.FD
      END
      YR.REC(5) = YM.MID.RATE
      YM.TYPE = "2"
      YKEYFD = YM.TYPE

    * check ID to see if it matches keys with contract no. in the format
    * xxyydddnnnnn. if it does, extend the year (yy) component of the key
    * to yyyy and use this as the id to the REPGEN work file. all the
    * aforementioned processing is done in ENQ.BUILD.TXN and is part of
    * Year 2000 compliance

      FULL.TXN.ID = ""
      CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

      YKEYFD = FMT(YM.TYPE,"3L")


      IF LEN(YKEYFD) > 3 THEN YKEYFD = YKEYFD[1,2]:"|"
      GOSUB 8000000
      YM.FOOT.ONE = "-------------------"
      YR.REC(6) = YM.FOOT.ONE
      YM.FOOT.TWO = "-------------------"
      YR.REC(7) = YM.FOOT.TWO
      YM.FOOT.THREE = "-------------------"
      YR.REC(8) = YM.FOOT.THREE
      YM.FOOT.FOUR = "---------------------"
      YR.REC(9) = YM.FOOT.FOUR
      YM.FOOT.FIVE = "---------------------"
      YR.REC(10) = YM.FOOT.FIVE
      YM.FOOT.TEXT = "POSITION"
      YR.REC(11) = YM.FOOT.TEXT
      YTRUE.1 = 0
      YM.CHECK.REF = R.NEW(17)
      IF YM.CHECK.REF <> "" THEN
        YTRUE.1 = 1
        YM.ENT.REF = R.NEW(17)
      END
      IF NOT(YTRUE.1) THEN
        YM.CHECK.REF = R.NEW(17)
        IF YM.CHECK.REF = "" THEN
          YTRUE.1 = 1
          YM.ENT.REF = R.NEW(23)
        END
      END
      IF NOT(YTRUE.1) THEN YM.ENT.REF = ""
      YM.SORT.REF = YM.ENT.REF
      YKEYFD = YM.SORT.REF

    * check ID to see if it matches keys with contract no. in the format
    * xxyydddnnnnn. if it does, extend the year (yy) component of the key
    * to yyyy and use this as the id to the REPGEN work file. all the
    * aforementioned processing is done in ENQ.BUILD.TXN and is part of
    * Year 2000 compliance

      FULL.TXN.ID = ""
      CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

      YKEYFD = FMT(YM.SORT.REF,"10L")


      IF LEN(YKEYFD) > 10 THEN YKEYFD = YKEYFD[1,9]:"|"
      GOSUB 8000000
      YM.REFERENCE = YM.ENT.REF
      YR.REC(12) = YM.REFERENCE
      YM.OPEN.COM = ""
      YR.REC(13) = YM.OPEN.COM
      YM.CCY.OPEN.POS = R.NEW(13)
      YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURRENCY, YDEC)
      IF YM.CCY.OPEN.POS <> "" THEN
        YM.CCY.OPEN.POS = TRIM(FMT(YM.CCY.OPEN.POS,"19R":YDEC))
      END
      YR.REC(14) = YM.CCY.OPEN.POS
      YM.LCY.OPEN.POS = R.NEW(3)
      YR.REC(15) = YM.LCY.OPEN.POS
      YM.CCY.ENTRY.TOT = R.NEW(13)
      YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURRENCY, YDEC)
      IF YM.CCY.ENTRY.TOT <> "" THEN
        YM.CCY.ENTRY.TOT = TRIM(FMT(YM.CCY.ENTRY.TOT,"19R":YDEC))
      END
      YR.REC(16) = YM.CCY.ENTRY.TOT
      YM.LCY.ENTRY.TOT = R.NEW(3)
      YR.REC(17) = YM.LCY.ENTRY.TOT
      YM.CCY.CLOSE.POS = R.NEW(13)
      YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURRENCY, YDEC)
      IF YM.CCY.CLOSE.POS <> "" THEN
        YM.CCY.CLOSE.POS = TRIM(FMT(YM.CCY.CLOSE.POS,"19R":YDEC))
      END
      YR.REC(18) = YM.CCY.CLOSE.POS
      YM.LCY.CCY.AMT = R.NEW(13)
      YM39.GOSUB = YM.LCY.CCY.AMT
      YM.LCC.CCY = YM.CURRENCY
      YM40.GOSUB = YM.LCC.CCY
      YM.LCY.MKT = R.NEW(20)
      YM41.GOSUB = YM.LCY.MKT
      YM.LCY.ANS = ""
      YM42.GOSUB = YM.LCY.ANS
      CALL @MIDDLE.RATE.CONV.CHECK (YM39.GOSUB, YM40.GOSUB, "", YM41.GOSUB, YM42.GOSUB, "", "")
      YM.LCY.CCY.AMT = YM39.GOSUB
      YM.LCC.CCY = YM40.GOSUB
      YM.LCY.MKT = YM41.GOSUB
      YM.LCY.ANS = YM42.GOSUB
      YM.LCY.CLOSE.POS = YM.LCY.ANS
      YR.REC(19) = YM.LCY.CLOSE.POS
      YM.LCY.PANDL = YM.LCY.OPEN.POS
      YM1.LCY.PANDL = YM.LCY.PANDL
      YM.LCY.PANDL = YM.LCY.CLOSE.POS
      IF NUM(YM1.LCY.PANDL) = NUMERIC THEN IF NUM(YM.LCY.PANDL) = NUMERIC THEN
        YM1.LCY.PANDL = YM1.LCY.PANDL - YM.LCY.PANDL
        IF YM1.LCY.PANDL = 0 THEN YM1.LCY.PANDL = ""
      END
      YM.LCY.PANDL = YM1.LCY.PANDL
      YR.REC(20) = YM.LCY.PANDL
      YM.CCY.CLOSE.TOT = YM.CCY.CLOSE.POS
      YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURRENCY, YDEC)
      IF YM.CCY.CLOSE.TOT <> "" THEN
        YM.CCY.CLOSE.TOT = TRIM(FMT(YM.CCY.CLOSE.TOT,"19R":YDEC))
      END
      YR.REC(21) = YM.CCY.CLOSE.TOT
      YM.LCY.CLOSE.TOT = YM.LCY.CLOSE.POS
      YR.REC(22) = YM.LCY.CLOSE.TOT
      YM.LCY.PANDL.TOT = YM.LCY.PANDL
      YR.REC(23) = YM.LCY.PANDL.TOT
*------------------------------------------------------------------------
    CASE YFILE = "RE.CONSOL.SPEC.ENTRY"
      YKEY = ""; MAT YR.REC = ""
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
      YR.REC(1) = YM.CURRENCY
      YTRUE.1 = 0
      YM.OUR.REF.SY = FMT(R.NEW(17),"2L"); YM.OUR.REF.SY = YM.OUR.REF.SY[1,2]
      IF YM.OUR.REF.SY = "FX" THEN
        YTRUE.1 = 1
        YM.DEPT.FIND = R.NEW(17)
        IF YM.DEPT.FIND <> "" THEN
          YCOMP = "FOREX_4_":YM.DEPT.FIND
          YFORFIL = YF.FOREX
          YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
          YM.DEPT.FIND = YFOR.FD
        END
        YM.DEPT.LOOK = YM.DEPT.FIND
      END
      IF NOT(YTRUE.1) THEN
        YM.OUR.REF.SY = FMT(R.NEW(17),"2L"); YM.OUR.REF.SY = YM.OUR.REF.SY[1,2]
        IF YM.OUR.REF.SY <> "FX" THEN
          YTRUE.1 = 1
          YM.DEPT.LOOK = "00"
        END
      END
      IF NOT(YTRUE.1) THEN YM.DEPT.LOOK = ""
      YM.DEPT.ACCT = YM.DEPT.LOOK
      IF YM.DEPT.ACCT <> "" THEN
        YCOMP = "DEALER.DESK_2_":YM.DEPT.ACCT
        YFORFIL = YF.DEALER.DESK
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.DEPT.ACCT = YFOR.FD
      END
      YKEYFD = FMT(YM.DEPT.ACCT,"R####")
      IF LEN(YKEYFD) > 4 THEN YKEYFD = YKEYFD[1,3]:"|"
      GOSUB 8000000
      YR.REC(2) = YM.DEPT.ACCT
      YM.DEAL.DESK = YM.DEPT.LOOK
      YR.REC(3) = YM.DEAL.DESK
      YTRUE.1 = 0
      IF YM.DEPT.LOOK <> 00 THEN
        YTRUE.1 = 1
        YM.SORT.DESK = YM.DEAL.DESK
      END
      IF NOT(YTRUE.1) THEN
        IF YM.DEPT.LOOK = 00 THEN
          YTRUE.1 = 1
          YM.SORT.DESK = "99"
        END
      END
      IF NOT(YTRUE.1) THEN YM.SORT.DESK = ""
      YKEYFD = YM.SORT.DESK

    * check ID to see if it matches keys with contract no. in the format
    * xxyydddnnnnn. if it does, extend the year (yy) component of the key
    * to yyyy and use this as the id to the REPGEN work file. all the
    * aforementioned processing is done in ENQ.BUILD.TXN and is part of
    * Year 2000 compliance

      FULL.TXN.ID = ""
      CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

      YKEYFD = FMT(YM.SORT.DESK,"4L")


      IF LEN(YKEYFD) > 4 THEN YKEYFD = YKEYFD[1,3]:"|"
      GOSUB 8000000
      YM.REF1 = "1TR"
      YM.REF2 = YM.REF1
      YM1.REF2 = YM.REF2
      YM.REF2 = YM.DEAL.DESK
      YM1.REF2 = YM1.REF2 : YM.REF2
      YM.REF2 = YM1.REF2
      YM.REF3 = YM.REF2
      YM1.REF3 = YM.REF3
      YM.REF3 = YM.CURRENCY
      YM1.REF3 = YM1.REF3 : YM.REF3
      YM.REF3 = YM1.REF3
      YKEYFD = YM.REF3

    * check ID to see if it matches keys with contract no. in the format
    * xxyydddnnnnn. if it does, extend the year (yy) component of the key
    * to yyyy and use this as the id to the REPGEN work file. all the
    * aforementioned processing is done in ENQ.BUILD.TXN and is part of
    * Year 2000 compliance

      FULL.TXN.ID = ""
      CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

      YKEYFD = FMT(YM.REF3,"10L")


      IF LEN(YKEYFD) > 10 THEN YKEYFD = YKEYFD[1,9]:"|"
      GOSUB 8000000
      YR.REC(4) = YM.REF3
      YM.MID.RATE = YM.CURRENCY
      IF YM.MID.RATE <> "" THEN
        YCOMP = "CURRENCY_14.1_":YM.MID.RATE
        YFORFIL = YF.CURRENCY
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.MID.RATE = YFOR.FD
      END
      YR.REC(5) = YM.MID.RATE
      YM.TYPE = "2"
      YKEYFD = YM.TYPE

    * check ID to see if it matches keys with contract no. in the format
    * xxyydddnnnnn. if it does, extend the year (yy) component of the key
    * to yyyy and use this as the id to the REPGEN work file. all the
    * aforementioned processing is done in ENQ.BUILD.TXN and is part of
    * Year 2000 compliance

      FULL.TXN.ID = ""
      CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

      YKEYFD = FMT(YM.TYPE,"3L")


      IF LEN(YKEYFD) > 3 THEN YKEYFD = YKEYFD[1,2]:"|"
      GOSUB 8000000
      YM.FOOT.ONE = "-------------------"
      YR.REC(6) = YM.FOOT.ONE
      YM.FOOT.TWO = "-------------------"
      YR.REC(7) = YM.FOOT.TWO
      YM.FOOT.THREE = "-------------------"
      YR.REC(8) = YM.FOOT.THREE
      YM.FOOT.FOUR = "---------------------"
      YR.REC(9) = YM.FOOT.FOUR
      YM.FOOT.FIVE = "---------------------"
      YR.REC(10) = YM.FOOT.FIVE
      YM.FOOT.TEXT = "POSITION"
      YR.REC(11) = YM.FOOT.TEXT
      YTRUE.1 = 0
      YM.CHECK.REF = R.NEW(17)
      IF YM.CHECK.REF <> "" THEN
        YTRUE.1 = 1
        YM.ENT.REF = R.NEW(17)
      END
      IF NOT(YTRUE.1) THEN
        YM.CHECK.REF = R.NEW(17)
        IF YM.CHECK.REF = "" THEN
          YTRUE.1 = 1
          YM.ENT.REF = R.NEW(23)
        END
      END
      IF NOT(YTRUE.1) THEN YM.ENT.REF = ""
      YM.SORT.REF = YM.ENT.REF
      YKEYFD = YM.SORT.REF

    * check ID to see if it matches keys with contract no. in the format
    * xxyydddnnnnn. if it does, extend the year (yy) component of the key
    * to yyyy and use this as the id to the REPGEN work file. all the
    * aforementioned processing is done in ENQ.BUILD.TXN and is part of
    * Year 2000 compliance

      FULL.TXN.ID = ""
      CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

      YKEYFD = FMT(YM.SORT.REF,"10L")


      IF LEN(YKEYFD) > 10 THEN YKEYFD = YKEYFD[1,9]:"|"
      GOSUB 8000000
      YM.REFERENCE = YM.ENT.REF
      YR.REC(12) = YM.REFERENCE
      YM.OPEN.COM = ""
      YR.REC(13) = YM.OPEN.COM
      YM.CCY.OPEN.POS = R.NEW(13)
      YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURRENCY, YDEC)
      IF YM.CCY.OPEN.POS <> "" THEN
        YM.CCY.OPEN.POS = TRIM(FMT(YM.CCY.OPEN.POS,"19R":YDEC))
      END
      YR.REC(14) = YM.CCY.OPEN.POS
      YM.LCY.OPEN.POS = R.NEW(3)
      YR.REC(15) = YM.LCY.OPEN.POS
      YM.CCY.ENTRY.TOT = R.NEW(13)
      YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURRENCY, YDEC)
      IF YM.CCY.ENTRY.TOT <> "" THEN
        YM.CCY.ENTRY.TOT = TRIM(FMT(YM.CCY.ENTRY.TOT,"19R":YDEC))
      END
      YR.REC(16) = YM.CCY.ENTRY.TOT
      YM.LCY.ENTRY.TOT = R.NEW(3)
      YR.REC(17) = YM.LCY.ENTRY.TOT
      YM.CCY.CLOSE.POS = R.NEW(13)
      YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURRENCY, YDEC)
      IF YM.CCY.CLOSE.POS <> "" THEN
        YM.CCY.CLOSE.POS = TRIM(FMT(YM.CCY.CLOSE.POS,"19R":YDEC))
      END
      YR.REC(18) = YM.CCY.CLOSE.POS
      YM.LCY.CCY.AMT = R.NEW(13)
      YM39.GOSUB = YM.LCY.CCY.AMT
      YM.LCC.CCY = YM.CURRENCY
      YM40.GOSUB = YM.LCC.CCY
      YM.LCY.MKT = R.NEW(20)
      YM41.GOSUB = YM.LCY.MKT
      YM.LCY.ANS = ""
      YM42.GOSUB = YM.LCY.ANS
      CALL @MIDDLE.RATE.CONV.CHECK (YM39.GOSUB, YM40.GOSUB, "", YM41.GOSUB, YM42.GOSUB, "", "")
      YM.LCY.CCY.AMT = YM39.GOSUB
      YM.LCC.CCY = YM40.GOSUB
      YM.LCY.MKT = YM41.GOSUB
      YM.LCY.ANS = YM42.GOSUB
      YM.LCY.CLOSE.POS = YM.LCY.ANS
      YR.REC(19) = YM.LCY.CLOSE.POS
      YM.LCY.PANDL = YM.LCY.OPEN.POS
      YM1.LCY.PANDL = YM.LCY.PANDL
      YM.LCY.PANDL = YM.LCY.CLOSE.POS
      IF NUM(YM1.LCY.PANDL) = NUMERIC THEN IF NUM(YM.LCY.PANDL) = NUMERIC THEN
        YM1.LCY.PANDL = YM1.LCY.PANDL - YM.LCY.PANDL
        IF YM1.LCY.PANDL = 0 THEN YM1.LCY.PANDL = ""
      END
      YM.LCY.PANDL = YM1.LCY.PANDL
      YR.REC(20) = YM.LCY.PANDL
      YM.CCY.CLOSE.TOT = YM.CCY.CLOSE.POS
      YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CURRENCY, YDEC)
      IF YM.CCY.CLOSE.TOT <> "" THEN
        YM.CCY.CLOSE.TOT = TRIM(FMT(YM.CCY.CLOSE.TOT,"19R":YDEC))
      END
      YR.REC(21) = YM.CCY.CLOSE.TOT
      YM.LCY.CLOSE.TOT = YM.LCY.CLOSE.POS
      YR.REC(22) = YM.LCY.CLOSE.TOT
      YM.LCY.PANDL.TOT = YM.LCY.PANDL
      YR.REC(23) = YM.LCY.PANDL.TOT
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
