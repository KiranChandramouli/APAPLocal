$PACKAGE EB.Repgen
  SUBROUTINE RGS.PTF.SUMMARIES
REM "RGS.PTF.SUMMARIES",230614-3
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
  YT.SMS.FILE = "SEC.ACC.MASTER"
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
  DIM YR.REC(4)
  YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.PTF.SUMMARIES"
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
    CALL FATAL.ERROR ("RGS.PTF.SUMMARIES")
  END
*
  YCOM = ID.COMPANY
*
  YT.SMS = ""
  YT.SMS.FILE = "SEC.ACC.MASTER"
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
  YFILE = "SEC.ACC.MASTER"
  FULL.FNAME = "F.SEC.ACC.MASTER"; YF.SEC.ACC.MASTER = ""
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
  CALL OPF (FULL.FNAME, YF.SEC.ACC.MASTER)
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
    MATREAD R.NEW FROM YF.SEC.ACC.MASTER, ID.NEW ELSE ID.NEW = "" ; MAT R.NEW = ""
    IF T.PWD THEN
      CALL CONTROL.USER.PROFILE ("RECORD")
      IF ETEXT THEN ID.NEW = ""
    END
    IF ID.NEW <> "" THEN
*
* Handle Decision Table
      YM.MANAGED = R.NEW(9)
      IF (YM.MANAGED >= 1 AND YM.MANAGED <= 8) THEN
        YGROUP = "1"; GOSUB 2000000
      END
      IF YM.MANAGED = 9 THEN
        YGROUP = "2"; GOSUB 2000000
      END
    END
*
  REPEAT
  IF YKEYNO THEN
  YR.REC(4)  := @FM
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
      YM.NAME = ID.NEW
      YKEYFD = YM.NAME

    * check ID to see if it matches keys with contract no. in the format
    * xxyydddnnnnn. if it does, extend the year (yy) component of the key
    * to yyyy and use this as the id to the REPGEN work file. all the
    * aforementioned processing is done in ENQ.BUILD.TXN and is part of
    * Year 2000 compliance

      FULL.TXN.ID = ""
      CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

      YKEYFD = FMT(YM.NAME,"16L")


      IF LEN(YKEYFD) > 16 THEN YKEYFD = YKEYFD[1,15]:"|"
      GOSUB 8000000
      YR.REC(1) = YM.NAME
      YM.CCY = R.NEW(2)
      YR.REC(2) = YM.CCY
      YM.VALUE = R.NEW(23)
      YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
      IF YM.VALUE <> "" THEN
        YM.VALUE = TRIM(FMT(YM.VALUE,"19R":YDEC))
      END
      YR.REC(3) = YM.VALUE
      YM.VALUE1 = R.NEW(23)
      YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
      IF YM.VALUE1 <> "" THEN
        YM.VALUE1 = TRIM(FMT(YM.VALUE1,"19R":YDEC))
      END
      YR.REC(4) = YM.VALUE1
*
    CASE YGROUP = "2"
      YKEY = "2"; MAT YR.REC = ""
      YM.NAME = ID.NEW
      YKEYFD = YM.NAME

    * check ID to see if it matches keys with contract no. in the format
    * xxyydddnnnnn. if it does, extend the year (yy) component of the key
    * to yyyy and use this as the id to the REPGEN work file. all the
    * aforementioned processing is done in ENQ.BUILD.TXN and is part of
    * Year 2000 compliance

      FULL.TXN.ID = ""
      CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

      YKEYFD = FMT(YM.NAME,"16L")


      IF LEN(YKEYFD) > 16 THEN YKEYFD = YKEYFD[1,15]:"|"
      GOSUB 8000000
      YR.REC(1) = YM.NAME
      YM.CCY = R.NEW(2)
      YR.REC(2) = YM.CCY
      YM.VALUE = R.NEW(23)
      YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
      IF YM.VALUE <> "" THEN
        YM.VALUE = TRIM(FMT(YM.VALUE,"19R":YDEC))
      END
      YR.REC(3) = YM.VALUE
      YM.VALUE1 = R.NEW(23)
      YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.CCY, YDEC)
      IF YM.VALUE1 <> "" THEN
        YM.VALUE1 = TRIM(FMT(YM.VALUE1,"19R":YDEC))
      END
      YR.REC(4) = YM.VALUE1
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
