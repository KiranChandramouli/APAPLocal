$PACKAGE EB.Repgen
  SUBROUTINE RGP.LD0400
REM "RGP.LD0400",230614-4
*************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_RC.COMMON
$INSERT I_SCREEN.VARIABLES
$INSERT I_F.COMPANY
$INSERT I_F.LANGUAGE
$INSERT I_F.USER
*************************************************************************
REPORT.ID = "RG.LD0400"
PRT.UNIT = 0
  IF V$DISPLAY = "D" THEN YPRINTING = 0 ELSE YPRINTING = 1
  IF NOT(YPRINTING) THEN IF NOT(S.COL132.ON) THEN
    TEXT = "TERMINAL CANNOT DISPLAY 132 COLUMS"
    CALL REM; RETURN  ;* end of pgm
  END
*************************************************************************
  YT.SMS.COMP = ID.COMPANY
  YT.SMS.FILE = "LD.LOANS.AND.DEPOSITS"
  YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
  YT.SMS.FILE<-1> = "LMM.ACCOUNT.BALANCES"
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
   F.LANGUAGE=""; CALL OPF("F.LANGUAGE",F.LANGUAGE)
   READV AMOUNT.FORMAT FROM F.LANGUAGE,LNGG,EB.LAN.AMOUNT.FORMAT ELSE AMOUNT.FORMAT=""
  CLEARSELECT
  YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.LD0400"
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
    YT.PAGE = ""; T.CONTROLWORD = C.U:@FM:C.B:@FM:C.F:@FM:C.E:@FM:C.V:@FM:C.W
  END
  YKEY = ""; YTOTFD = ""
  DIM YR.REC(20); MAT YR.REC = ""
  DIM YR.REC.OLD(18); MAT YR.REC.OLD = "_"
  GOSUB 1000000
  YHDR = "WITHOLDING TAX CERTIFICATES REQUIRED REPORT"
  IF YPRINTING THEN
    YHDR = "RGP.LD0400 ":YHDR
    YTYPE = "HEADER":@FM:YHDR
    CALL PST ( YTYPE )
  END ELSE
    YTYPE = YHDR
  END
  YHDR1 = "CONTRACT         CUSTOMER/NUMBER             ACC.   CCY   LIQ.  ALT.      TOTAL RECEIPTS             CURRENT PERIOD"
  YHDR2 = "  NUMBER         MAT. DATE  :START DATE      OFF.                         REQUIRED                   ACCRUAL"
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
  IF YPRINTING THEN
    HEAD.SETTING = YTYPE<1>:YTYPE<2>:YTYPE<3>:YTYPE<4>:YTYPE<5>:YTYPE<6>:YTYPE<7>:YTYPE<8>:YTYPE<9>:YTYPE<10>:YTYPE<11>:YTYPE<12>
  IF HEAD.SETTING = "" THEN
    HEAD.SETTING = " "
  END
  HEADING HEAD.SETTING
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
  MAT YR.REC.OLD = "_"
  YKEYFD = ""; Y1ST.LIN = 1
  LOOP WHILE YKEYFD = "" DO
    YHEADER.DISPLAY = 0; YHEADER.STATUS = ""
    BEGIN CASE
      CASE YR.REC.OLD(1) <> YR.REC(1); YHEADER.STATUS = 1
    END CASE
    IF YHEADER.STATUS THEN
      GOSUB 9000010; Y1ST.LIN = 1
      IF COMI = C.U THEN RETURN  ;* end of pgm
    END
    YFD.OLD = YR.REC.OLD(1); YFD = YR.REC(1)  ;* YM.ACCT.OFFICER.NAME
    IF YHEADER.DISPLAY OR YFD.OLD <> YFD THEN
      YHEADER.DISPLAY = 1
      YFD = FMT(YFD,"25L")
      IF LEN(YFD) > 25 THEN YFD = YFD[1,24]:"|"
      YFD = "ACCOUNT OFFICER :  ":YFD
      YTOTFD := YFD
    END
    IF YHEADER.DISPLAY THEN
      GOSUB 9000010
      IF COMI = C.U THEN RETURN  ;* end of pgm
    END
    YCOUNT.LIN = 1; YCOUNT.AS.LIN = 1
    YCOUNT.TOT2 = 1; YCOUNT.AS.TOT2 = 1
    IF Y1ST.LIN THEN
      Y1ST.LIN = 0; GOSUB 9000010
      IF COMI = C.U THEN RETURN  ;* end of pgm
    END
    YFD = YR.REC(2)  ;* YM.CONTRACT.NO
    IF YFD = "" THEN
      YFD = STR(" ",14)
    END ELSE
      YFD = FMT(YFD,"R##-#####-#####")
    END
    IF LEN(YFD) > 14 THEN YFD = YFD[1,13]:"|"
    YTOTFD := YFD
    YFD = YR.REC(3)  ;* YM.CUST.NAME
    YFD = FMT(YFD,"25L")
    IF LEN(YFD) > 25 THEN YFD = YFD[1,24]:"|"
    YTOTFD := "   ":YFD
    YFD = YR.REC(4)  ;* YM.ACC.OFFICER
    YFD = FMT(YFD,"2L")
    IF LEN(YFD) > 2 THEN YFD = YFD[1,1]:"|"
    YTOTFD := "   ":YFD
    YFD = YR.REC(5)  ;* YM.CCY
    YFD = FMT(YFD,"3L")
    IF LEN(YFD) > 3 THEN YFD = YFD[1,2]:"|"
    YTOTFD := "     ":YFD
    YFD = YR.REC(6)  ;* YM.LIQ.CD.PRINT
    YFD = FMT(YFD,"2L")
    IF LEN(YFD) > 2 THEN YFD = YFD[1,1]:"|"
    YTOTFD := "   ":YFD
    YFD = YR.REC(7)  ;* YM.ALT.PRINT
    YFD = FMT(YFD,"2L")
    IF LEN(YFD) > 2 THEN YFD = YFD[1,1]:"|"
    YTOTFD := "    ":YFD
    YCNT = COUNT(YR.REC(8),@VM)
    IF YCNT >= YCOUNT.LIN THEN YCOUNT.LIN = YCNT+1
    YFD = YR.REC(8)<1,1>  ;* YM.RECEIPTS.REQD
    IF YFD = "" THEN
      YFD = STR(" ",19)
    END ELSE
      YDEC = INDEX(YFD,".",1)
      IF YDEC THEN YDEC = LEN(YFD) - YDEC
      YFD = FMT(YFD,"19R":YDEC:",")
      IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
    END
    IF LEN(YFD) > 19 THEN YFD = YFD[1,18]:"|"
    YTOTFD := "   ":YFD
    YCNT = COUNT(YR.REC(9),@VM)
    IF YCNT >= YCOUNT.LIN THEN YCOUNT.LIN = YCNT+1
    YFD = YR.REC(9)<1,1>  ;* YM.CURR.PER.ACCR
    IF YFD = "" THEN
      YFD = STR(" ",19)
    END ELSE
      YDEC = INDEX(YFD,".",1)
      IF YDEC THEN YDEC = LEN(YFD) - YDEC
      YFD = FMT(YFD,"19R":YDEC:",")
      IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
    END
    IF LEN(YFD) > 19 THEN YFD = YFD[1,18]:"|"
    YTOTFD := "        ":YFD
    YFD = YR.REC(10)  ;* YM.CUST.ID
    YFD = FMT(YFD,"10L")
    IF LEN(YFD) > 10 THEN YFD = YFD[1,9]:"|"
    GOSUB 9000000
    IF COMI = C.U THEN RETURN  ;* end of pgm
    YTOTFD := "                 ":YFD
    YFD = YR.REC(11)  ;* YM.MAT.DATE.PRINT
    BEGIN CASE
       CASE YFD MATCHES "8N"
          YFD=YFD[7,2]:" ":FIELD(T.REMTEXT(19)," ",YFD[5,2]):" ":YFD[1,4]
       CASE YFD MATCHES "6N"
          YFD=YFD[5,2]:" ":FIELD(T.REMTEXT(19)," ",YFD[3,2]):" ":(IF YFD[1,1] LT 5 THEN '20' ELSE '19'):YFD[1,2]
       CASE 1
          YFD=FMT(YFD,"11L")
    END CASE
    IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
    GOSUB 9000000
    IF COMI = C.U THEN RETURN  ;* end of pgm
    YTOTFD := "                 ":YFD
    YFD = YR.REC(12)  ;* YM.PRINT.COLON
    YFD = FMT(YFD,"1L")
    IF LEN(YFD) > 1 THEN YFD = YFD[1,0]:"|"
    YTOTFD := YFD
    YFD = YR.REC(13)  ;* YM.VAL.DATE
    BEGIN CASE
       CASE YFD MATCHES "8N"
          YFD=YFD[7,2]:" ":FIELD(T.REMTEXT(19)," ",YFD[5,2]):" ":YFD[1,4]
       CASE YFD MATCHES "6N"
          YFD=YFD[5,2]:" ":FIELD(T.REMTEXT(19)," ",YFD[3,2]):" ":(IF YFD[1,1] LT 5 THEN '20' ELSE '19'):YFD[1,2]
       CASE 1
          YFD=FMT(YFD,"11L")
    END CASE
    IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
    YTOTFD := YFD
    YFD = YR.REC(14)  ;* YM.BLANK.LINE
    YFD = FMT(YFD,"1L")
    IF LEN(YFD) > 1 THEN YFD = YFD[1,0]:"|"
    GOSUB 9000000
    IF COMI = C.U THEN RETURN  ;* end of pgm
    YTOTFD := "                   ":YFD
    YFD = YR.REC(15)  ;* YM.END.REC.LIT1
    YFD = FMT(YFD,"33L")
    IF LEN(YFD) > 33 THEN YFD = YFD[1,32]:"|"
    GOSUB 9000000
    IF COMI = C.U THEN RETURN  ;* end of pgm
    YTOTFD := YFD
    YFD = YR.REC(16)  ;* YM.END.REC.LIT2
    YFD = FMT(YFD,"33L")
    IF LEN(YFD) > 33 THEN YFD = YFD[1,32]:"|"
    YTOTFD := YFD
    YFD = YR.REC(17)  ;* YM.END.REC.LIT3
    YFD = FMT(YFD,"33L")
    IF LEN(YFD) > 33 THEN YFD = YFD[1,32]:"|"
    YTOTFD := YFD
    YFD = YR.REC(18)  ;* YM.END.REC.LIT4
    YFD = FMT(YFD,"33L")
    IF LEN(YFD) > 33 THEN YFD = YFD[1,32]:"|"
    YTOTFD := YFD
    GOSUB 9000000
    IF COMI = C.U THEN RETURN  ;* end of pgm
*
    FOR YAV = 2 TO YCOUNT.LIN
      YFD = YR.REC(8)<1,YAV>  ;* YM.RECEIPTS.REQD
      IF YFD = "" THEN
        YFD = STR(" ",19)
      END ELSE
        YDEC = INDEX(YFD,".",1)
        IF YDEC THEN YDEC = LEN(YFD) - YDEC
        YFD = FMT(YFD,"19R":YDEC:",")
        IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
      END
      IF LEN(YFD) > 19 THEN YFD = YFD[1,18]:"|"
      YTOTFD := "                                                                     ":YFD
      YFD = YR.REC(9)<1,YAV>  ;* YM.CURR.PER.ACCR
      IF YFD = "" THEN
        YFD = STR(" ",19)
      END ELSE
        YDEC = INDEX(YFD,".",1)
        IF YDEC THEN YDEC = LEN(YFD) - YDEC
        YFD = FMT(YFD,"19R":YDEC:",")
        IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
      END
      IF LEN(YFD) > 19 THEN YFD = YFD[1,18]:"|"
      YTOTFD := "        ":YFD
      GOSUB 9000000
      IF COMI = C.U THEN RETURN  ;* end of pgm
    NEXT YAV
    GOSUB 9000010
    IF COMI = C.U THEN RETURN  ;* end of pgm
    GOSUB 1000000
*
    IF YKEY.OLD[1,28] <> YKEY[1,28] THEN
      IF YKEY.OLD[1,1] = YKEY[1,1] THEN
        YTEXT = "*** END OF GROUP ***"
        IF LNGG <> 1 THEN CALL TXT ( YTEXT )
        IF YPRINTING THEN
          PRINT
        END ELSE
          IF L < 19 THEN
            GOSUB 9000000
            IF COMI = C.U THEN RETURN  ;* end of pgm
          END
        END
        PRINT YTEXT
        IF NOT(YPRINTING) THEN YT.PAGE<P,L> = YTEXT; L += 1; PRINT @(0,L):
        IF NOT(YPRINTING) THEN
          L = 999; GOSUB 9000010
          IF COMI = C.U THEN RETURN  ;* end of pgm
        END
        YHDR = "WITHOLDING TAX CERTIFICATES REQUIRED REPORT"
        IF YPRINTING THEN
          YHDR = "RGP.LD0400 ":YHDR
          YTYPE = "HEADER":@FM:YHDR
          CALL PST ( YTYPE )
        END ELSE
          YTYPE = YHDR
        END
        YHDR1 = "CONTRACT         CUSTOMER/NUMBER             ACC.   CCY   LIQ.  ALT.      TOTAL RECEIPTS             CURRENT PERIOD"
        YHDR2 = "  NUMBER         MAT. DATE  :START DATE      OFF.                         REQUIRED                   ACCRUAL"
        YHDR3 = ""
        YHDR4 = ""
        IF YHDR1 <> "" OR YHDR2 <> "" OR YHDR3 <> "" OR YHDR4 <> "" THEN
          YTYPE<3> = YTYPE<3>:YSTML
          IF YHDR1 <> "" THEN YTYPE<4> = YHDR1:YSTML
          IF YHDR2 <> "" THEN YTYPE<5> = YHDR2:YSTML
          IF YHDR3 <> "" THEN YTYPE<6> = YHDR3:YSTML
          IF YHDR4 <> "" THEN YTYPE<7> = YHDR4:YSTML
        END
  YHDR.GROUP = ""
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
          IF YHDR4 <> "" THEN YTYPE<12> = YHDR4:YSTML
        END
        IF YPRINTING THEN
          HEAD.SETTING = YTYPE<1>:YTYPE<2>:YTYPE<3>:YTYPE<4>:YTYPE<5>:YTYPE<6>:YTYPE<7>:YTYPE<8>:YTYPE<9>:YTYPE<10>:YTYPE<11>:YTYPE<12>
        IF HEAD.SETTING = "" THEN
          HEAD.SETTING = " "
        END
        HEADING HEAD.SETTING
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
      END
    END
  REPEAT
  YTEXT = "*** END OF REPORT ***"
  IF LNGG <> 1 THEN CALL TXT ( YTEXT )
  IF YPRINTING THEN
    PRINT
  END ELSE
    IF L < 19 THEN
      GOSUB 9000000
      IF COMI = C.U THEN RETURN  ;* end of pgm
    END
  END
  PRINT YTEXT
  IF NOT(YPRINTING) THEN YT.PAGE<P,L> = YTEXT; L += 1; PRINT @(0,L):
  IF YPRINTING THEN
    CALL PRINTER.OFF
    IF NOT(PHNO) THEN PRINT @(41,L1ST-3):YBLOCKNO+YWRITNO:
    C$RPT.CUSTOMER.NO = YR.REC(19)
    C$RPT.ACCOUNT.NO = YR.REC(20)
    CALL PRINTER.CLOSE(REPORT.ID,PRT.UNIT,"")
  END ELSE
    TEXT = "END OF REPORT"; YEND = 1; GOSUB 9100000
  END
  RETURN
*************************************************************************
1000000:
*
  YKEY.OLD = YKEY
  MAT YR.REC.OLD = MAT YR.REC
  REMOVE YKEY FROM YID.LIST SETTING YDELIM
  IF NOT(YKEY:YDELIM) THEN
    YKEYFD = "***"; YKEY = STR("*",188); RETURN
  END
  MATREAD YR.REC FROM F.FILE, YKEY ELSE MAT YR.REC = "" ; GOTO 1000000
  YKEY = "C":YKEY
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
    CASE 1
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