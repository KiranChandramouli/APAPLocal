*-----------------------------------------------------------------------------
* <Rating>7492</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE RGP.LC.DISCOUNT
REM "RGP.LC.DISCOUNT",040129-3
*************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_RC.COMMON
$INSERT I_SCREEN.VARIABLES
$INSERT I_F.COMPANY
$INSERT I_F.LANGUAGE
$INSERT I_F.USER
*************************************************************************
REPORT.ID = "RG.LC.DISCOUNT"
PRT.UNIT = 0
  IF V$DISPLAY = "D" THEN YPRINTING = 0 ELSE YPRINTING = 1
  IF NOT(YPRINTING) THEN IF NOT(S.COL132.ON) THEN
    TEXT = "TERMINAL CANNOT DISPLAY 132 COLUMS"
    CALL REM; RETURN  ;* end of pgm
  END
*************************************************************************
  YT.SMS.COMP = ID.COMPANY
  YT.SMS.FILE = "DRAWINGS"
  YT.SMS.FILE<-1> = "LETTER.OF.CREDIT"
  YT.SMS.FILE<-1> = "CUSTOMER"
  YT.SMS.FILE<-1> = "DATES"
  YCOUNT = COUNT(YT.SMS.FILE,FM)+1
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
   F.LANGUAGE=""; CALL OPF("F.LANGUAGE",F.LANGUAGE)
   READV AMOUNT.FORMAT FROM F.LANGUAGE,LNGG,EB.LAN.AMOUNT.FORMAT ELSE AMOUNT.FORMAT=""
  CLEARSELECT
  YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.LC.DISCOUNT"
  EXECUTE "HUSH ON"
  EXECUTE "SSELECT ":YFILE
  EXECUTE "HUSH OFF"
  CALL EB.READLIST('', YID.LIST, '', '', '')
  IF YPRINTING THEN
    CALL PRINTER.ON(REPORT.ID,PRT.UNIT); YBLOCKNO = 0; YWRITNO = 0; COMI = C.F
  END ELSE
    PRINT S.COL132.ON:
    PRINT @(0,L1ST-1):STR("-",132):
    YEND = 0; Y = 1; LASTP = 1; L = L1ST; PRINT @(0,L):
    FOR LL = L TO 19; PRINT S.CLEAR.EOL; NEXT LL
    YTEXT = T.REMTEXT(23)
* T.REMTEXT(23) = "PAGE"
    PRINT @(0,20):STR("-",132):@(63+LEN(YTEXT),21):S.HALF.INTENSITY.OFF:@(63,21):S.HALF.INTENSITY.ON:YTEXT:S.HALF.INTENSITY.OFF:
    YT.PAGE = ""; T.CONTROLWORD = C.U:FM:C.B:FM:C.F:FM:C.E:FM:C.V:FM:C.W
  END
  YKEY = ""; YTOTFD = ""
  DIM YR.REC(13); MAT YR.REC = ""
  GOSUB 1000000
  YHDR = "LETTER.OF.CREDIT DISCOUNTS"
  IF YPRINTING THEN
    YTYPE = ""
  END ELSE
    YTYPE = YHDR
  END
  YHDR1 = "MAT.DATE  LC NUMBER       TYPE   APPLICANT/ISSUING BNK  CCY        DR AMT      INT %   DISC.AMT      SPR %    SPR.AMT       TOT.AMT"
  YHDR2 = ""
  YHDR3 = ""
  YHDR4 = ""
  IF YPRINTING THEN YSTML = "'L'" ELSE YSTML = ""
  IF YHDR1 <> "" OR YHDR2 <> "" OR YHDR3 <> "" OR YHDR4 <> "" THEN
    YTYPE<3> = YTYPE<3>:YSTML
    IF YHDR1 <> "" THEN YTYPE<4> = YHDR1:YSTML
    IF YHDR2 <> "" THEN YTYPE<5> = YHDR2:YSTML
    IF YHDR3 <> "" THEN YTYPE<6> = YHDR3:YSTML
    IF YHDR4 <> "" THEN YTYPE<7> = YHDR4:YSTML
  END
  YHDR.GROUP = "TODAYS DISCOUNTS"
  YHDR1 = ""
  YHDR2 = ""
  YHDR3 = ""
  YHDR4 = ""
  IF YHDR.GROUP <> "" OR YHDR1 <> "" OR YHDR2 <> "" OR YHDR3 <> "" OR YHDR4 <> "" THEN
    YTYPE<7> = YTYPE<7>:YSTML
    IF YHDR.GROUP <> "" THEN YTYPE<8> = YHDR.GROUP:YSTML
    IF YHDR.GROUP <> "" AND (YHDR1 <> "" OR YHDR2 <> "" OR YHDR3 <> "" OR YHDR4 <> "") THEN
      YTYPE<8> = YTYPE<8>:YSTML
    END
    IF YHDR1 <> "" THEN YTYPE<9> = YHDR1:YSTML
    IF YHDR2 <> "" THEN YTYPE<10> = YHDR2:YSTML
    IF YHDR3 <> "" THEN YTYPE<11> = YHDR3:YSTML
    IF YHDR4 <> "" THEN YTYPE<12> = YHDR3:YSTML
  END
  IF YPRINTING THEN
    HEADING YTYPE<1>:YTYPE<2>:YTYPE<3>:YTYPE<4>:YTYPE<5>:YTYPE<6>:YTYPE<7>:YTYPE<8>:YTYPE<9>:YTYPE<10>:YTYPE<11>:YTYPE<12>
  END ELSE
    PRINT @(25+LEN(SCREEN.TITLE)+LEN(PGM.VERSION),L1ST-4):S.CLEAR.EOL:YTYPE<1>:
    IF YTYPE<5> = "" THEN YTYPE<5> = YTYPE<4>; YTYPE<4> = ""
    PRINT @(0,L1ST-3):S.CLEAR.EOL:YTYPE<4>:
    PRINT @(0,L1ST-2):S.CLEAR.EOL:YTYPE<5>:
    L = L1ST; PRINT @(0,L):
    IF YTYPE<6> <> "" THEN
      YT.PAGE<P,L> = YTYPE<6>; L += 2; PRINT YTYPE<6>:@(0,L):
    END
    IF YTYPE<7> <> "" THEN
      YT.PAGE<P,L> = YTYPE<7>; L += 2; PRINT YTYPE<7>:@(0,L):
    END
    IF YTYPE<8> <> "" THEN
      YT.PAGE<P,L> = YTYPE<8>; L += 2; PRINT YTYPE<6>:@(0,L):
    END
    IF YTYPE<9> <> "" OR YTYPE<10> <> "" OR YTYPE<11> <> "" OR YTYPE<12> <> "" THEN
      IF YTYPE<9> <> "" THEN
        YT.PAGE<P,L> = YTYPE<9>; L += 1; PRINT YTYPE<9>:@(0,L):
      END
      IF YTYPE<10> <> "" THEN
        YT.PAGE<P,L> = YTYPE<10>; L += 1; PRINT YTYPE<10>:
      END
      IF YTYPE<11> <> "" THEN
        YT.PAGE<P,L> = YTYPE<11>; L += 1; PRINT YTYPE<11>:
      END
      IF YTYPE<12> <> "" THEN
        YT.PAGE<P,L> = YTYPE<12>; L += 1; PRINT YTYPE<12>:
      END
      L += 1; PRINT @(0,L):
    END
  END
  YTYPE = ""
*------------------------------------------------------------------------
  LOOP WHILE YKEYFD = "1" DO
    YCOUNT.LIN = 1; YCOUNT.AS.LIN = 1
    YCOUNT.TOT2 = 1; YCOUNT.AS.TOT2 = 1
    YFD = YR.REC(1)  ;* YM.MAT.DATE
    BEGIN CASE
       CASE YFD MATCHES "8N"
          YFD=YFD[7,2]:" ":FIELD(T.REMTEXT(19)," ",YFD[5,2]):" ":YFD[3,2]
       CASE YFD MATCHES "6N"
          YFD=YFD[5,2]:" ":FIELD(T.REMTEXT(19)," ",YFD[3,2]):" ":YFD[1,2]
       CASE 1
          YFD=FMT(YFD,"9L")
    END CASE
    IF LEN(YFD) > 9 THEN YFD = YFD[1,8]:"|"
    YTOTFD := YFD
    YFD = YR.REC(2)  ;* YM.LCNUM
    YFD = FMT(YFD,"14L")
    IF LEN(YFD) > 14 THEN YFD = YFD[1,13]:"|"
    YTOTFD := " ":YFD
    YFD = YR.REC(3)  ;* YM.LC.TYPE
    YFD = FMT(YFD,"4L")
    IF LEN(YFD) > 4 THEN YFD = YFD[1,3]:"|"
    YTOTFD := "  ":YFD
    YFD = YR.REC(4)  ;* YM.DISP.ISSUE.BNK
    YFD = FMT(YFD,"20L")
    IF LEN(YFD) > 20 THEN YFD = YFD[1,19]:"|"
    YTOTFD := "   ":YFD
    YFD = YR.REC(5)  ;* YM.CURRENCY
    YFD = FMT(YFD,"3L")
    IF LEN(YFD) > 3 THEN YFD = YFD[1,2]:"|"
    YTOTFD := "   ":YFD
    YFD = YR.REC(6)  ;* YM.DRAW.AMT
    IF YFD = "" THEN
      YFD = STR(" ",16)
    END ELSE
      YFD = FMT(YFD,"16R2,")
      IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
    END
    IF LEN(YFD) > 16 THEN YFD = YFD[1,15]:"|"
    YTOTFD := "  ":YFD
    YFD = YR.REC(7)  ;* YM.INT.RATE
    IF YFD = "" THEN
      YFD = STR(" ",5)
    END ELSE
      YFD = FMT(YFD,"5R3,")
      IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
    END
    IF LEN(YFD) > 5 THEN YFD = YFD[1,4]:"|"
    YTOTFD := "  ":YFD
    YFD = YR.REC(8)  ;* YM.DISC.AMT
    IF YFD = "" THEN
      YFD = STR(" ",10)
    END ELSE
      YFD = FMT(YFD,"10R2,")
      IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
    END
    IF LEN(YFD) > 10 THEN YFD = YFD[1,9]:"|"
    YTOTFD := " ":YFD
    YFD = YR.REC(9)  ;* YM.SPREAD.RATE
    IF YFD = "" THEN
      YFD = STR(" ",5)
    END ELSE
      YFD = FMT(YFD,"5R3,")
      IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
    END
    IF LEN(YFD) > 5 THEN YFD = YFD[1,4]:"|"
    YTOTFD := "      ":YFD
    YFD = YR.REC(10)  ;* YM.SPREAD.AMT
    IF YFD = "" THEN
      YFD = STR(" ",10)
    END ELSE
      YFD = FMT(YFD,"10R2,")
      IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
    END
    IF LEN(YFD) > 10 THEN YFD = YFD[1,9]:"|"
    YTOTFD := " ":YFD
    YFD = YR.REC(11)  ;* YM.TOT.DISC
    IF YFD = "" THEN
      YFD = STR(" ",11)
    END ELSE
      YFD = FMT(YFD,"11R2,")
      IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
    END
    IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
    YTOTFD := "   ":YFD
    GOSUB 9000000
    IF COMI = C.U THEN RETURN  ;* end of pgm
    GOSUB 1000000
  REPEAT
*
  YTEXT = "*** END OF GROUP ***"
  IF NOT(YPRINTING) THEN
    L = 999; GOSUB 9000010
    IF COMI = C.U THEN RETURN  ;* end of pgm
  END
  YHDR = "LETTER.OF.CREDIT DISCOUNTS"
  IF YPRINTING THEN
    YTYPE = ""
  END ELSE
    YTYPE = YHDR
  END
  YHDR1 = "MAT.DATE  LC NUMBER       TYPE   APPLICANT/ISSUING BNK  CCY        DR AMT      INT %   DISC.AMT      SPR %    SPR.AMT       TOT.AMT"
  YHDR2 = ""
  YHDR3 = ""
  YHDR4 = ""
  IF YPRINTING THEN YSTML = "'L'" ELSE YSTML = ""
  IF YHDR1 <> "" OR YHDR2 <> "" OR YHDR3 <> "" OR YHDR4 <> "" THEN
    YTYPE<3> = YTYPE<3>:YSTML
    IF YHDR1 <> "" THEN YTYPE<4> = YHDR1:YSTML
    IF YHDR2 <> "" THEN YTYPE<5> = YHDR2:YSTML
    IF YHDR3 <> "" THEN YTYPE<6> = YHDR3:YSTML
    IF YHDR4 <> "" THEN YTYPE<7> = YHDR4:YSTML
  END
  YHDR.GROUP = "ALL DISCOUNTS"
  YHDR1 = ""
  YHDR2 = ""
  YHDR3 = ""
  YHDR4 = ""
  IF YHDR.GROUP <> "" OR YHDR1 <> "" OR YHDR2 <> "" OR YHDR3 <> "" OR YHDR4 <> "" THEN
    YTYPE<7> = YTYPE<7>:YSTML
    IF YHDR.GROUP <> "" THEN YTYPE<8> = YHDR.GROUP:YSTML
    IF YHDR.GROUP <> "" AND (YHDR1 <> "" OR YHDR2 <> "" OR YHDR3 <> "" OR YHDR4 <> "") THEN
      YTYPE<8> = YTYPE<8>:YSTML
    END
    IF YHDR1 <> "" THEN YTYPE<9> = YHDR1:YSTML
    IF YHDR2 <> "" THEN YTYPE<10> = YHDR2:YSTML
    IF YHDR3 <> "" THEN YTYPE<11> = YHDR3:YSTML
    IF YHDR4 <> "" THEN YTYPE<12> = YHDR3:YSTML
  END
  IF YPRINTING THEN
    HEADING YTYPE<1>:YTYPE<2>:YTYPE<3>:YTYPE<4>:YTYPE<5>:YTYPE<6>:YTYPE<7>:YTYPE<8>:YTYPE<9>:YTYPE<10>:YTYPE<11>:YTYPE<12>
  END ELSE
    PRINT @(25+LEN(SCREEN.TITLE)+LEN(PGM.VERSION),L1ST-4):S.CLEAR.EOL:YTYPE<1>:
    IF YTYPE<5> = "" THEN YTYPE<5> = YTYPE<4>; YTYPE<4> = ""
    PRINT @(0,L1ST-3):S.CLEAR.EOL:YTYPE<4>:
    PRINT @(0,L1ST-2):S.CLEAR.EOL:YTYPE<5>:
    L = L1ST; PRINT @(0,L):
    IF YTYPE<6> <> "" THEN
      YT.PAGE<P,L> = YTYPE<6>; L += 2; PRINT YTYPE<6>:@(0,L):
    END
    IF YTYPE<7> <> "" THEN
      YT.PAGE<P,L> = YTYPE<7>; L += 2; PRINT YTYPE<7>:@(0,L):
    END
    IF YTYPE<8> <> "" THEN
      YT.PAGE<P,L> = YTYPE<8>; L += 2; PRINT YTYPE<6>:@(0,L):
    END
    IF YTYPE<9> <> "" OR YTYPE<10> <> "" OR YTYPE<11> <> "" OR YTYPE<12> <> "" THEN
      IF YTYPE<9> <> "" THEN
        YT.PAGE<P,L> = YTYPE<9>; L += 1; PRINT YTYPE<9>:@(0,L):
      END
      IF YTYPE<10> <> "" THEN
        YT.PAGE<P,L> = YTYPE<10>; L += 1; PRINT YTYPE<10>:
      END
      IF YTYPE<11> <> "" THEN
        YT.PAGE<P,L> = YTYPE<11>; L += 1; PRINT YTYPE<11>:
      END
      IF YTYPE<12> <> "" THEN
        YT.PAGE<P,L> = YTYPE<12>; L += 1; PRINT YTYPE<12>:
      END
      L += 1; PRINT @(0,L):
    END
  END
  YTYPE = ""
*------------------------------------------------------------------------
  LOOP WHILE YKEYFD = "2" DO
    YCOUNT.LIN = 1; YCOUNT.AS.LIN = 1
    YCOUNT.TOT2 = 1; YCOUNT.AS.TOT2 = 1
    YFD = YR.REC(1)  ;* YM.MAT.DATE
    BEGIN CASE
       CASE YFD MATCHES "8N"
          YFD=YFD[7,2]:" ":FIELD(T.REMTEXT(19)," ",YFD[5,2]):" ":YFD[3,2]
       CASE YFD MATCHES "6N"
          YFD=YFD[5,2]:" ":FIELD(T.REMTEXT(19)," ",YFD[3,2]):" ":YFD[1,2]
       CASE 1
          YFD=FMT(YFD,"9L")
    END CASE
    IF LEN(YFD) > 9 THEN YFD = YFD[1,8]:"|"
    YTOTFD := YFD
    YFD = YR.REC(2)  ;* YM.LCNUM
    YFD = FMT(YFD,"14L")
    IF LEN(YFD) > 14 THEN YFD = YFD[1,13]:"|"
    YTOTFD := " ":YFD
    YFD = YR.REC(3)  ;* YM.LC.TYPE
    YFD = FMT(YFD,"4L")
    IF LEN(YFD) > 4 THEN YFD = YFD[1,3]:"|"
    YTOTFD := "  ":YFD
    YFD = YR.REC(4)  ;* YM.DISP.ISSUE.BNK
    YFD = FMT(YFD,"20L")
    IF LEN(YFD) > 20 THEN YFD = YFD[1,19]:"|"
    YTOTFD := "   ":YFD
    YFD = YR.REC(5)  ;* YM.CURRENCY
    YFD = FMT(YFD,"3L")
    IF LEN(YFD) > 3 THEN YFD = YFD[1,2]:"|"
    YTOTFD := "   ":YFD
    YFD = YR.REC(6)  ;* YM.DRAW.AMT
    IF YFD = "" THEN
      YFD = STR(" ",16)
    END ELSE
      YFD = FMT(YFD,"16R2,")
      IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
    END
    IF LEN(YFD) > 16 THEN YFD = YFD[1,15]:"|"
    YTOTFD := "  ":YFD
    YFD = YR.REC(7)  ;* YM.INT.RATE
    IF YFD = "" THEN
      YFD = STR(" ",5)
    END ELSE
      YFD = FMT(YFD,"5R3,")
      IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
    END
    IF LEN(YFD) > 5 THEN YFD = YFD[1,4]:"|"
    YTOTFD := "  ":YFD
    YFD = YR.REC(8)  ;* YM.DISC.AMT
    IF YFD = "" THEN
      YFD = STR(" ",10)
    END ELSE
      YFD = FMT(YFD,"10R2,")
      IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
    END
    IF LEN(YFD) > 10 THEN YFD = YFD[1,9]:"|"
    YTOTFD := " ":YFD
    YFD = YR.REC(9)  ;* YM.SPREAD.RATE
    IF YFD = "" THEN
      YFD = STR(" ",5)
    END ELSE
      YFD = FMT(YFD,"5R3,")
      IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
    END
    IF LEN(YFD) > 5 THEN YFD = YFD[1,4]:"|"
    YTOTFD := "      ":YFD
    YFD = YR.REC(10)  ;* YM.SPREAD.AMT
    IF YFD = "" THEN
      YFD = STR(" ",10)
    END ELSE
      YFD = FMT(YFD,"10R2,")
      IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
    END
    IF LEN(YFD) > 10 THEN YFD = YFD[1,9]:"|"
    YTOTFD := " ":YFD
    YFD = YR.REC(11)  ;* YM.TOT.DISC
    IF YFD = "" THEN
      YFD = STR(" ",11)
    END ELSE
      YFD = FMT(YFD,"11R2,")
      IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
    END
    IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
    YTOTFD := "   ":YFD
    GOSUB 9000000
    IF COMI = C.U THEN RETURN  ;* end of pgm
    GOSUB 1000000
  REPEAT
  YTEXT = "*** END OF REPORT ***"
  IF YPRINTING THEN
    CALL PRINTER.OFF
    IF NOT(PHNO) THEN PRINT @(41,L1ST-3):YBLOCKNO+YWRITNO:
    C$RPT.CUSTOMER.NO = YR.REC(12)
    C$RPT.ACCOUNT.NO = YR.REC(13)
    CALL PRINTER.CLOSE(REPORT.ID,PRT.UNIT,"")
  END ELSE
    TEXT = "END OF REPORT"; YEND = 1; GOSUB 9100000
  END
  RETURN
*************************************************************************
1000000:
*
  YKEY.OLD = YKEY
  REMOVE YKEY FROM YID.LIST SETTING YDELIM
  IF NOT(YKEY:YDELIM) THEN
    YKEYFD = "***"; YKEY = STR("*",188); RETURN
  END
  MATREAD YR.REC FROM F.FILE, YKEY ELSE MAT YR.REC = "" ; GOTO 1000000
  YKEY = "C":YKEY
  YKEYFD = YKEY[2,1]
  IF NOT(PHNO) AND YPRINTING THEN
    IF YWRITNO < 9 THEN
      YWRITNO += 1
    END ELSE
      YWRITNO = 0; YBLOCKNO += 10
      CALL PRINTER.OFF; PRINT @(41,L1ST-3):YBLOCKNO+YWRITNO:; CALL PRINTER.ON(REPORT.ID,PRT.UNIT)
    END
  END
  RETURN
*************************************************************************
9000000:
*
  YTOTFD = TRIMB(YTOTFD)
  IF YTOTFD = "" THEN RETURN
*
9000010:
  IF YPRINTING THEN PRINT YTOTFD; YTOTFD = ""; RETURN
  PRINT YTOTFD:; YT.PAGE<P,L> = YTOTFD; YTOTFD = ""
  IF L < 19 THEN L += 1; PRINT @(0,L):; RETURN
*
9100000:
  PRINT @(13,21):TIMEDATE()[1,8]:@(68,21):S.CLEAR.EOL:P:
*
9100010:
  Y = T.REMTEXT(4)  ;* AWAITING PAGE INSTRUCTIONS
  CALL INP (Y,8,22,5.1,"A")
  BEGIN CASE
    CASE COMI = C.B; NEXTP = P-1
    CASE COMI = C.F
      NEXTP = P+1; IF NEXTP = LASTP+1 THEN GOTO 9190000
    CASE COMI = C.E; NEXTP = LASTP
    CASE COMI = C.V OR COMI = C.W OR COMI = C.U
      PRINT S.COL132.OFF:
      CLEARSELECT; COMI = C.U; RETURN
    CASE COMI = "P"; NEXTP = 1
    CASE COMI[1,1] = "P" AND NUM(COMI[2,99]) = NUMERIC
      NEXTP = COMI[2,99]
      IF NEXTP = LASTP+1 THEN COMI = C.F; GOTO 9190000
    CASE OTHERWISE
      E = ""; L = 22; CALL ERR; GOTO 9100010
  END CASE
*
  IF NEXTP < 1 THEN
    NEXTP = 1
  END ELSE
    IF NEXTP > LASTP THEN NEXTP = LASTP
  END
  IF NEXTP = P THEN GOTO 9100000
  P = NEXTP
*
  GOSUB 9200000
  FOR LL = L1ST TO 19
    X = YT.PAGE<P,LL>; IF X <> "" THEN PRINT @(0,LL):X:
  NEXT LL; GOTO 9100000
*
9190000:
  IF YEND THEN GOTO 9100000 ELSE P = NEXTP
*
9200000:
  L = L1ST; PRINT @(0,L):
  FOR LL = L TO 19; PRINT S.CLEAR.EOL; NEXT LL
  PRINT @(0,L):
  IF P > LASTP THEN LASTP = P
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
