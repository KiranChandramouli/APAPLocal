$PACKAGE EB.Repgen
  SUBROUTINE RGS.VERSION4
REM "RGS.VERSION4",230614-4
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
    CALL FATAL.ERROR ("RGS.VERSION4")
  END
*************************************************************************
  YT.SMS.COMP = ID.COMPANY
  YT.SMS.FILE = "VERSION"
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
  YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.VERSION4"
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
    CALL FATAL.ERROR ("RGS.VERSION4")
  END
*
  YCOM = ID.COMPANY
*
  YT.SMS = ""
  YT.SMS.FILE = "VERSION"
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
  YFILE = "VERSION"
  FULL.FNAME = "F.VERSION"; YF.VERSION = ""
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
  CALL OPF (FULL.FNAME, YF.VERSION)
fldName = '' ; dataType = '' ; errMsg = '' 
CALL FIELD.NUMBERS.TO.NAMES('31',SS.REC,fldName,dataType,errMsg)
  CLEARSELECT
 YSEL.A = ""
 IF C$MULTI.BOOK AND COMP.FOUND THEN
    YSEL.A = " AND CO.CODE EQUAL ":ID.COMPANY
 END
  EXECUTE "HUSH ON"
  EXECUTE 'SELECT ':FULL.FNAME:' WITH ':fldName:' <> ""':YSEL.A
  EXECUTE "HUSH OFF"
  CALL EB.READLIST('', YID.LIST, '', '', '')
  LOOP
    REMOVE ID.NEW FROM YID.LIST SETTING YDELIM
  WHILE ID.NEW:YDELIM
    MATREAD R.OLD FROM YF.VERSION, ID.NEW ELSE ID.NEW = "" ; MAT R.OLD = ""
    IF T.PWD THEN
      MAT R.NEW = MAT R.OLD
      CALL CONTROL.USER.PROFILE ("RECORD")
      IF ETEXT THEN ID.NEW = ""
    END
    IF ID.NEW <> "" THEN
*
* Handle Decision Table
      MAT R.NEW = MAT R.OLD
      YSPLIT.COUNT = COUNT(R.OLD(31),@VM)+1
      IF COUNT(R.OLD(32),@VM) >= YSPLIT.COUNT THEN
        YSPLIT.COUNT = COUNT(R.OLD(32),@VM)+1
      END
      IF COUNT(R.OLD(33),@VM) >= YSPLIT.COUNT THEN
        YSPLIT.COUNT = COUNT(R.OLD(33),@VM)+1
      END
      FOR YAV.SPLIT = 1 TO YSPLIT.COUNT
        YSPLIT.COUNT.AS = COUNT(R.OLD(31)<1,YAV.SPLIT>,@SM)+1
        IF COUNT(R.OLD(32)<1,YAV.SPLIT>,@SM) >= YSPLIT.COUNT.AS THEN
          YSPLIT.COUNT.AS = COUNT(R.OLD(32)<1,YAV.SPLIT>,@SM)+1
        END
        IF COUNT(R.OLD(33)<1,YAV.SPLIT>,@SM) >= YSPLIT.COUNT.AS THEN
          YSPLIT.COUNT.AS = COUNT(R.OLD(33)<1,YAV.SPLIT>,@SM)+1
        END
        FOR YAS.SPLIT = 1 TO YSPLIT.COUNT.AS
          R.NEW(31) = R.OLD(31)<1,YAV.SPLIT,YAS.SPLIT>
          R.NEW(32) = R.OLD(32)<1,YAV.SPLIT,YAS.SPLIT>
          R.NEW(33) = R.OLD(33)<1,YAV.SPLIT,YAS.SPLIT>
          GOSUB 2000000
        NEXT YAS.SPLIT
      NEXT YAV.SPLIT
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
  YKEY = ""; MAT YR.REC = ""
  YM.NAME = ID.NEW
  YKEYFD = YM.NAME

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

  FULL.TXN.ID = ""
  CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

  YKEYFD = FMT(YM.NAME,"32L")


  IF LEN(YKEYFD) > 32 THEN YKEYFD = YKEYFD[1,31]:"|"
  GOSUB 8000000
  YR.REC(1) = YM.NAME
  YM.FIELDNO = R.NEW(31)
  YR.REC(2) = YM.FIELDNO
  YM.OLDVALUE = R.NEW(32)
  YR.REC(3) = YM.OLDVALUE
  YM.NEWVALUE = R.NEW(33)
  YR.REC(4) = YM.NEWVALUE
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
