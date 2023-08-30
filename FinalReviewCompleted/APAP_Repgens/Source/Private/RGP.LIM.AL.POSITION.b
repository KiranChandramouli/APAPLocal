* @ValidationCode : MjotNjUxMjMyODQ2OkNwMTI1MjoxNjg4NTM2ODkxMTg2OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jul 2023 11:31:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.Repgens
SUBROUTINE RGP.LIM.AL.POSITION
REM "RGP.LIM.AL.POSITION",230614-4
*************************************************************************
*----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date       Author              Modification Description
* 15-06-2023   Ghayathri T          R22 Manual Conversion - changed GOTO TO GOSUB
*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_RC.COMMON
    $INSERT I_SCREEN.VARIABLES
    $INSERT I_F.COMPANY
    $INSERT I_F.LANGUAGE
    $INSERT I_F.USER
*************************************************************************
    REPORT.ID = "RG.LIM.AL.POSITION"
    PRT.UNIT = 0
    IF V$DISPLAY = "D" THEN YPRINTING = 0 ELSE YPRINTING = 1
    IF NOT(YPRINTING) THEN IF NOT(S.COL132.ON) THEN
        TEXT = "TERMINAL CANNOT DISPLAY 132 COLUMS"
        CALL REM; RETURN  ;* end of pgm
    END
*************************************************************************
    YT.SMS.COMP = ID.COMPANY
    YT.SMS.FILE = "CUSTOMER"
    YT.SMS.FILE<-1> = "REPGEN.SORT"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
    YT.SMS.FILE<-1> = "LIMIT"
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
    F.LANGUAGE=""; CALL OPF("F.LANGUAGE",F.LANGUAGE)
    READV AMOUNT.FORMAT FROM F.LANGUAGE,LNGG,EB.LAN.AMOUNT.FORMAT ELSE AMOUNT.FORMAT=""
    CLEARSELECT
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.LIM.AL.POSITION"
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
    DIM YR.REC(136); MAT YR.REC = ""
    GOSUB 1000000
    YHDR = "ASSET & LIABILITY OVERVIEW"
    IF YPRINTING THEN
        YHDR = "RGP.LIM.AL.POSITION ":YHDR
        YTYPE = "HEADER":@FM:YHDR
        CALL PST ( YTYPE )
    END ELSE
        YTYPE = YHDR
    END
    YHDR1 = ""
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
    DIM YR.TOT2(1); MAT YR.TOT2 = ""
    DIM YT.DEC2(1); MAT YT.DEC2 = ""
    YKEYFD = ""
    LOOP WHILE YKEYFD = "" DO
        YCOUNT.LIN = 1; YCOUNT.AS.LIN = 1
        YCOUNT.TOT2 = 1; YCOUNT.AS.TOT2 = 1
        YFD = YR.REC(1)  ;* YM.DEPT.ACCT.OFFICER
        IF YFD = "" THEN
            YFD = STR(" ",4)
        END ELSE
            YFD = FMT(YFD,"R####")
        END
        IF LEN(YFD) > 4 THEN YFD = YFD[1,3]:"|"
        YFD = "Account officer: ":YFD
        YTOTFD := YFD
        YFD = YR.REC(2)  ;* YM.NAME
        YFD = FMT(YFD,"35L")
        IF LEN(YFD) > 35 THEN YFD = YFD[1,34]:"|"
        YTOTFD := "  ":YFD
        YFD = YR.REC(3)  ;* YM.CUSTOMER.NO
        IF YFD = "" THEN
            YFD = STR(" ",6)
        END ELSE
            YFD = FMT(YFD,"R######")
        END
        IF LEN(YFD) > 6 THEN YFD = YFD[1,5]:"|"
        YFD = "Liability number: ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(4)  ;* YM.NAME.1
        YFD = FMT(YFD,"35L")
        IF LEN(YFD) > 35 THEN YFD = YFD[1,34]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(5)  ;* YM.CURRENCY
        YFD = FMT(YFD,"3L")
        IF LEN(YFD) > 3 THEN YFD = YFD[1,2]:"|"
        YFD = "Currency: ":YFD
        YTOTFD := " ":YFD
        YFD = YR.REC(6)  ;* YM.LIABILITY.GROUP
        YFD = FMT(YFD,"65L")
        IF LEN(YFD) > 65 THEN YFD = YFD[1,64]:"|"
        YFD = "Liability group: ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(7)  ;* YM.TEXT.1
        YFD = FMT(YFD,"1L")
        IF LEN(YFD) > 1 THEN YFD = YFD[1,0]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(8)  ;* YM.TEXT.2
        YFD = FMT(YFD,"17L")
        IF LEN(YFD) > 17 THEN YFD = YFD[1,16]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(9)  ;* YM.TEXT.3
        YFD = FMT(YFD,"9L")
        IF LEN(YFD) > 9 THEN YFD = YFD[1,8]:"|"
        YTOTFD := "                                ":YFD
        YFD = YR.REC(10)  ;* YM.TEXT.4
        YFD = FMT(YFD,"4L")
        IF LEN(YFD) > 4 THEN YFD = YFD[1,3]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(11)  ;* YM.TEXT.5
        YFD = FMT(YFD,"6L")
        IF LEN(YFD) > 6 THEN YFD = YFD[1,5]:"|"
        YTOTFD := "                             ":YFD
        YFD = YR.REC(12)  ;* YM.TEXT.6
        YFD = FMT(YFD,"4L")
        IF LEN(YFD) > 4 THEN YFD = YFD[1,3]:"|"
        YTOTFD := "          ":YFD
        YFD = YR.REC(13)  ;* YM.TEXT.7
        YFD = FMT(YFD,"6L")
        IF LEN(YFD) > 6 THEN YFD = YFD[1,5]:"|"
        YTOTFD := "                             ":YFD
        YFD = YR.REC(14)  ;* YM.TEXT.8
        YFD = FMT(YFD,"6L")
        IF LEN(YFD) > 6 THEN YFD = YFD[1,5]:"|"
        YTOTFD := "                ":YFD
        YFD = YR.REC(15)  ;* YM.TEXT.9
        YFD = FMT(YFD,"6L")
        IF LEN(YFD) > 6 THEN YFD = YFD[1,5]:"|"
        YTOTFD := "                ":YFD
        YFD = YR.REC(16)  ;* YM.TEXT.11
        YFD = FMT(YFD,"5L")
        IF LEN(YFD) > 5 THEN YFD = YFD[1,4]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := "                                  ":YFD
        YFD = YR.REC(17)  ;* YM.TEXT.12
        YFD = FMT(YFD,"5L")
        IF LEN(YFD) > 5 THEN YFD = YFD[1,4]:"|"
        YTOTFD := "                                            ":YFD
        YFD = YR.REC(18)  ;* YM.TEXT.13
        YFD = FMT(YFD,"5L")
        IF LEN(YFD) > 5 THEN YFD = YFD[1,4]:"|"
        YTOTFD := "                 ":YFD
        YFD = YR.REC(19)  ;* YM.TEXT.14
        YFD = FMT(YFD,"5L")
        IF LEN(YFD) > 5 THEN YFD = YFD[1,4]:"|"
        YTOTFD := "                 ":YFD
        YFD = YR.REC(20)  ;* YM.TEXT.16
        YFD = FMT(YFD,"9L")
        IF LEN(YFD) > 9 THEN YFD = YFD[1,8]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := "                                                                                                     ":YFD
        YFD = YR.REC(21)  ;* YM.TEXT.17
        YFD = FMT(YFD,"7L")
        IF LEN(YFD) > 7 THEN YFD = YFD[1,6]:"|"
        YTOTFD := "               ":YFD
        YFD = YR.REC(22)  ;* YM.TEXT.18
        YFD = FMT(YFD,"1L")
        IF LEN(YFD) > 1 THEN YFD = YFD[1,0]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(23)  ;* YM.TEXT.19
        YFD = FMT(YFD,"16L")
        IF LEN(YFD) > 16 THEN YFD = YFD[1,15]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(24)  ;* YM.TEXT.20
        YFD = FMT(YFD,"11L")
        IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
        YTOTFD := "                                 ":YFD
        YFD = YR.REC(25)  ;* YM.OVERDRAFT
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Overdraft               ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(26)  ;* YM.CASH.BALANCE
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Cash account            ":YFD
        YTOTFD := "          ":YFD
        YFD = YR.REC(27)  ;* YM.CASH.UNPLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(28)  ;* YM.CASH.PLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(29)  ;* YM.SHORT.METAL
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Metal account           ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(30)  ;* YM.METAL.BALANCE
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Metal account           ":YFD
        YTOTFD := "          ":YFD
        YFD = YR.REC(31)  ;* YM.METAL.UNPLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(32)  ;* YM.METAL.PLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(33)  ;* YM.LOAN.BALANCE
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Loan                    ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(34)  ;* YM.DEPOSIT.BALANCE
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Deposit                 ":YFD
        YTOTFD := "          ":YFD
        YFD = YR.REC(35)  ;* YM.DEPOSIT.UNPLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(36)  ;* YM.DEPOSIT.PLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(37)  ;* YM.FIDUCIARY.BALANCE
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Fiduciary deposit       ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := "                                                 ":YFD
        YFD = YR.REC(38)  ;* YM.FIDUCIARY.UNPLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(39)  ;* YM.FIDUCIARY.PLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(40)  ;* YM.DEBT.DIFF.PAYM
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Debt.diff.paym.         ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(41)  ;* YM.CRED.DIFF.PAYM
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Cred.diff.paym.         ":YFD
        YTOTFD := "          ":YFD
        YFD = YR.REC(42)  ;* YM.CRED.DIFF.UNPLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(43)  ;* YM.CRED.DIFF.PLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(44)  ;* YM.TOTAL.CASH.DR
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Total CASH              ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(45)  ;* YM.TOTAL.CASH.CR
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Total CASH              ":YFD
        YTOTFD := "          ":YFD
        YFD = YR.REC(46)  ;* YM.TOTAL.CASH.UNP
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(47)  ;* YM.TOTAL.CASH.PLG
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(48)  ;* YM.TEXT.21
        YFD = FMT(YFD,"1L")
        IF LEN(YFD) > 1 THEN YFD = YFD[1,0]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(49)  ;* YM.TEXT.22
        YFD = FMT(YFD,"1L")
        IF LEN(YFD) > 1 THEN YFD = YFD[1,0]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(50)  ;* YM.SECURITIES.BALANCE
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "SECURITIES              ":YFD
        YTOTFD := "                                                ":YFD
        YFD = YR.REC(51)  ;* YM.SECURITIES.UNPLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(52)  ;* YM.SECURITIES.PLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(53)  ;* YM.TEXT.23
        YFD = FMT(YFD,"1L")
        IF LEN(YFD) > 1 THEN YFD = YFD[1,0]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(54)  ;* YM.TEXT.24
        YFD = FMT(YFD,"22L")
        IF LEN(YFD) > 22 THEN YFD = YFD[1,21]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(55)  ;* YM.TEXT.25
        YFD = FMT(YFD,"17L")
        IF LEN(YFD) > 17 THEN YFD = YFD[1,16]:"|"
        YTOTFD := "                           ":YFD
        YFD = YR.REC(56)  ;* YM.LC.BALANCE.DR
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Letter of credit        ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(57)  ;* YM.LC.BALANCE.CR
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Letter of credit        ":YFD
        YTOTFD := "          ":YFD
        YFD = YR.REC(58)  ;* YM.LC.UNPLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(59)  ;* YM.LC.PLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(60)  ;* YM.GUARANTEES.GIVEN
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Guarantees given        ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(61)  ;* YM.GUARANTEES.RECEIVED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Guarantees received     ":YFD
        YTOTFD := "          ":YFD
        YFD = YR.REC(62)  ;* YM.GUARANTEES.UNPLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(63)  ;* YM.GUARANTEES.PLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(64)  ;* YM.CONTINGENT.OTHERS.DR
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Others                  ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(65)  ;* YM.CONTINGENT.OTHERS.CR
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Others                  ":YFD
        YTOTFD := "          ":YFD
        YFD = YR.REC(66)  ;* YM.CONTINGENT.UNPLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(67)  ;* YM.CONTINGENT.PLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(68)  ;* YM.TEXT.26
        YFD = FMT(YFD,"1L")
        IF LEN(YFD) > 1 THEN YFD = YFD[1,0]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(69)  ;* YM.TEXT.27
        YFD = FMT(YFD,"1L")
        IF LEN(YFD) > 1 THEN YFD = YFD[1,0]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(70)  ;* YM.TEXT.28
        YFD = FMT(YFD,"6L")
        IF LEN(YFD) > 6 THEN YFD = YFD[1,5]:"|"
        YTOTFD := "                                                ":YFD
        YFD = YR.REC(71)  ;* YM.OTHER.OTHERS
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Others                  ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := "                                                 ":YFD
        YFD = YR.REC(72)  ;* YM.OTHERS.UNPLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(73)  ;* YM.OTHERS.PLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(74)  ;* YM.COLLAT.REC.PLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",59)
        END ELSE
            YFD = FMT(YFD,"59R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 59 THEN YFD = YFD[1,58]:"|"
        YFD = "Collateral received     ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := "                                                 ":YFD
        YFD = YR.REC(75)  ;* YM.COLLAT.GIVEN.PLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",59)
        END ELSE
            YFD = FMT(YFD,"59R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 59 THEN YFD = YFD[1,58]:"|"
        YFD = "Collateral given        ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := "                                                 ":YFD
        YFD = YR.REC(76)  ;* YM.TEXT.29
        YFD = FMT(YFD,"1L")
        IF LEN(YFD) > 1 THEN YFD = YFD[1,0]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(77)  ;* YM.TOTAL.LIABILITIES
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "TOTAL                   ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(78)  ;* YM.TOTAL.ASSETS
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "TOTAL                   ":YFD
        YTOTFD := "          ":YFD
        YFD = YR.REC(79)  ;* YM.TOTAL.UNPLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(80)  ;* YM.TOTAL.PLEDGED
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(81)  ;* YM.TEXT.30
        YFD = FMT(YFD,"1L")
        IF LEN(YFD) > 1 THEN YFD = YFD[1,0]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(82)  ;* YM.TEXT.31
        YFD = FMT(YFD,"19L")
        IF LEN(YFD) > 19 THEN YFD = YFD[1,18]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(83)  ;* YM.TEXT.32
        YFD = FMT(YFD,"14L")
        IF LEN(YFD) > 14 THEN YFD = YFD[1,13]:"|"
        YTOTFD := "                              ":YFD
        YFD = YR.REC(84)  ;* YM.FOREX.LIABILITIES
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Forex                   ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(85)  ;* YM.FOREX.ASSETS
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Forex                   ":YFD
        YTOTFD := "          ":YFD
        YFD = YR.REC(86)  ;* YM.IRS.LIABILITIES
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "IRS                     ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(87)  ;* YM.IRS.ASSETS
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "IRS                     ":YFD
        YTOTFD := "          ":YFD
        YFD = YR.REC(88)  ;* YM.FRA.LIABILITIES
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Loss on FRA             ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(89)  ;* YM.FRA.ASSETS
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Profit on FRA           ":YFD
        YTOTFD := "          ":YFD
        YFD = YR.REC(90)  ;* YM.TEXT.33
        YFD = FMT(YFD,"1L")
        IF LEN(YFD) > 1 THEN YFD = YFD[1,0]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(91)  ;* YM.TEXT.34
        YFD = FMT(YFD,"22L")
        IF LEN(YFD) > 22 THEN YFD = YFD[1,21]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(92)  ;* YM.TEXT.35
        YFD = FMT(YFD,"17L")
        IF LEN(YFD) > 17 THEN YFD = YFD[1,16]:"|"
        YTOTFD := "                           ":YFD
        YFD = YR.REC(93)  ;* YM.DISCOUNTED.BILLS.L
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Discounted bills        ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(94)  ;* YM.DISCOUNTED.BILLS.A
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Discounted bills        ":YFD
        YTOTFD := "          ":YFD
        YFD = YR.REC(95)  ;* YM.DOCUMENTS.L
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Documents               ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(96)  ;* YM.DOCUMENTS.A
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Documents               ":YFD
        YTOTFD := "          ":YFD
        YFD = YR.REC(97)  ;* YM.GOODS.L
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Goods                   ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(98)  ;* YM.GOODS.A
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YFD = "Goods                   ":YFD
        YTOTFD := "          ":YFD
        YFD = YR.REC(99)  ;* YM.TEXT.36
        YFD = FMT(YFD,"1L")
        IF LEN(YFD) > 1 THEN YFD = YFD[1,0]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(100)  ;* YM.TEXT.37
        YFD = FMT(YFD,"9L")
        IF LEN(YFD) > 9 THEN YFD = YFD[1,8]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(101)  ;* YM.TEXT.38
        YFD = FMT(YFD,"19L")
        IF LEN(YFD) > 19 THEN YFD = YFD[1,18]:"|"
        YTOTFD := "                                                                                           ":YFD
        YFD = YR.REC(102)  ;* YM.TEXT.39
        YFD = FMT(YFD,"4L")
        IF LEN(YFD) > 4 THEN YFD = YFD[1,3]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YFD = YR.REC(103)  ;* YM.TEXT.40
        YFD = FMT(YFD,"7L")
        IF LEN(YFD) > 7 THEN YFD = YFD[1,6]:"|"
        YTOTFD := "                         ":YFD
        YFD = YR.REC(104)  ;* YM.TEXT.41
        YFD = FMT(YFD,"7L")
        IF LEN(YFD) > 7 THEN YFD = YFD[1,6]:"|"
        YTOTFD := "         ":YFD
        YFD = YR.REC(105)  ;* YM.TEXT.42
        YFD = FMT(YFD,"4L")
        IF LEN(YFD) > 4 THEN YFD = YFD[1,3]:"|"
        YTOTFD := "            ":YFD
        YFD = YR.REC(106)  ;* YM.TEXT.43
        YFD = FMT(YFD,"9L")
        IF LEN(YFD) > 9 THEN YFD = YFD[1,8]:"|"
        YTOTFD := "       ":YFD
        YFD = YR.REC(107)  ;* YM.TEXT.44
        YFD = FMT(YFD,"9L")
        IF LEN(YFD) > 9 THEN YFD = YFD[1,8]:"|"
        YTOTFD := "   ":YFD
        YFD = YR.REC(108)  ;* YM.TEXT.45
        YFD = FMT(YFD,"10L")
        IF LEN(YFD) > 10 THEN YFD = YFD[1,9]:"|"
        YTOTFD := "    ":YFD
        YFD = YR.REC(109)  ;* YM.TEXT.46
        YFD = FMT(YFD,"4L")
        IF LEN(YFD) > 4 THEN YFD = YFD[1,3]:"|"
        YTOTFD := "                  ":YFD
        YFD = YR.REC(110)  ;* YM.TEXT.47
        YFD = FMT(YFD,"5L")
        IF LEN(YFD) > 5 THEN YFD = YFD[1,4]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := "                               ":YFD
        YFD = YR.REC(111)  ;* YM.TEXT.48
        YFD = FMT(YFD,"5L")
        IF LEN(YFD) > 5 THEN YFD = YFD[1,4]:"|"
        YTOTFD := "           ":YFD
        YFD = YR.REC(112)  ;* YM.TEXT.49
        YFD = FMT(YFD,"6L")
        IF LEN(YFD) > 6 THEN YFD = YFD[1,5]:"|"
        YTOTFD := "          ":YFD
        YFD = YR.REC(113)  ;* YM.TEXT.50
        YFD = FMT(YFD,"6L")
        IF LEN(YFD) > 6 THEN YFD = YFD[1,5]:"|"
        YTOTFD := "          ":YFD
        YFD = YR.REC(114)  ;* YM.TEXT.51
        YFD = FMT(YFD,"6L")
        IF LEN(YFD) > 6 THEN YFD = YFD[1,5]:"|"
        YTOTFD := "      ":YFD
        YFD = YR.REC(115)  ;* YM.TEXT.52
        YFD = FMT(YFD,"4L")
        IF LEN(YFD) > 4 THEN YFD = YFD[1,3]:"|"
        YTOTFD := "    ":YFD
        YFD = YR.REC(116)  ;* YM.TEXT.53
        YFD = FMT(YFD,"6L")
        IF LEN(YFD) > 6 THEN YFD = YFD[1,5]:"|"
        YTOTFD := "                      ":YFD
        YFD = YR.REC(117)  ;* YM.TEXT.54
        YFD = FMT(YFD,"1L")
        IF LEN(YFD) > 1 THEN YFD = YFD[1,0]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YCNT = COUNT(YR.REC(118),@VM)
        IF YCNT >= YCOUNT.LIN THEN YCOUNT.LIN = YCNT+1
        YCNT = COUNT(YR.REC(118)<1,1>,@SM)
        IF YCNT >= YCOUNT.AS.LIN THEN YCOUNT.AS.LIN = YCNT+1
        YFD = YR.REC(118)<1,1,1>  ;* YM.LIMIT.REFERENCE
        YFD = FMT(YFD,"20L")
        IF LEN(YFD) > 20 THEN YFD = YFD[1,19]:"|"
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YTOTFD := YFD
        YCNT = COUNT(YR.REC(119),@VM)
        IF YCNT >= YCOUNT.LIN THEN YCOUNT.LIN = YCNT+1
        YCNT = COUNT(YR.REC(119)<1,1>,@SM)
        IF YCNT >= YCOUNT.AS.LIN THEN YCOUNT.AS.LIN = YCNT+1
        YFD = YR.REC(119)<1,1,1>  ;* YM.MAXIMUM.TOTAL
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := " ":YFD
        YCNT = COUNT(YR.REC(120),@VM)
        IF YCNT >= YCOUNT.LIN THEN YCOUNT.LIN = YCNT+1
        YCNT = COUNT(YR.REC(120)<1,1>,@SM)
        IF YCNT >= YCOUNT.AS.LIN THEN YCOUNT.AS.LIN = YCNT+1
        YFD = YR.REC(120)<1,1,1>  ;* YM.ONLINE.LIMIT
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := " ":YFD
        YCNT = COUNT(YR.REC(121),@VM)
        IF YCNT >= YCOUNT.LIN THEN YCOUNT.LIN = YCNT+1
        YCNT = COUNT(YR.REC(121)<1,1>,@SM)
        IF YCNT >= YCOUNT.AS.LIN THEN YCOUNT.AS.LIN = YCNT+1
        YFD = YR.REC(121)<1,1,1>  ;* YM.TOTAL.OS
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := " ":YFD
        YCNT = COUNT(YR.REC(122),@VM)
        IF YCNT >= YCOUNT.LIN THEN YCOUNT.LIN = YCNT+1
        YCNT = COUNT(YR.REC(122)<1,1>,@SM)
        IF YCNT >= YCOUNT.AS.LIN THEN YCOUNT.AS.LIN = YCNT+1
        YFD = YR.REC(122)<1,1,1>  ;* YM.AVAIL.AMT
        IF YFD = "" THEN
            YFD = STR(" ",15)
        END ELSE
            YFD = FMT(YFD,"15R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
        YTOTFD := " ":YFD
        YCNT = COUNT(YR.REC(123),@VM)
        IF YCNT >= YCOUNT.LIN THEN YCOUNT.LIN = YCNT+1
        YCNT = COUNT(YR.REC(123)<1,1>,@SM)
        IF YCNT >= YCOUNT.AS.LIN THEN YCOUNT.AS.LIN = YCNT+1
        YFD = YR.REC(123)<1,1,1>  ;* YM.UNSECURED.AMOUNT
        IF YFD = "" THEN
            YFD = STR(" ",11)
        END ELSE
            YFD = FMT(YFD,"11R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
        YTOTFD := " ":YFD
        YCNT = COUNT(YR.REC(124),@VM)
        IF YCNT >= YCOUNT.LIN THEN YCOUNT.LIN = YCNT+1
        YCNT = COUNT(YR.REC(124)<1,1>,@SM)
        IF YCNT >= YCOUNT.AS.LIN THEN YCOUNT.AS.LIN = YCNT+1
        YFD = YR.REC(124)<1,1,1>  ;* YM.COLLATERAL.DESC
        YFD = FMT(YFD,"20L")
        IF LEN(YFD) > 20 THEN YFD = YFD[1,19]:"|"
        YTOTFD := "    ":YFD
        YCNT = COUNT(YR.REC(125),@VM)
        IF YCNT >= YCOUNT.LIN THEN YCOUNT.LIN = YCNT+1
        YCNT = COUNT(YR.REC(125)<1,1>,@SM)
        IF YCNT >= YCOUNT.AS.LIN THEN YCOUNT.AS.LIN = YCNT+1
        YFD = YR.REC(125)<1,1,1>  ;* YM.SECURED.AMT
        IF YFD = "" THEN
            YFD = STR(" ",11)
        END ELSE
            YFD = FMT(YFD,"11R0,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(126)  ;* YM.TOTAL.1
        IF NUM(YFD) = NUMERIC THEN
            YR.TOT2(1)<1> = YR.TOT2(1)<1> + YFD
            YDEC = INDEX(YFD,".",1)
            IF YDEC THEN YDEC = LEN(YFD) - YDEC
            IF YT.DEC2(1)<1> = "" THEN
                YT.DEC2(1)<1> = YDEC
            END ELSE
                IF YDEC > YT.DEC2(1)<1> THEN
                    YT.DEC2(1)<1> = YDEC
                END
            END
        END
        YFD = YR.REC(127)  ;* YM.TOTAL.2
        IF NUM(YFD) = NUMERIC THEN
            YR.TOT2(1)<2> = YR.TOT2(1)<2> + YFD
            YDEC = INDEX(YFD,".",1)
            IF YDEC THEN YDEC = LEN(YFD) - YDEC
            IF YT.DEC2(1)<2> = "" THEN
                YT.DEC2(1)<2> = YDEC
            END ELSE
                IF YDEC > YT.DEC2(1)<2> THEN
                    YT.DEC2(1)<2> = YDEC
                END
            END
        END
        YFD = YR.REC(128)  ;* YM.TOTAL.3
        IF NUM(YFD) = NUMERIC THEN
            YR.TOT2(1)<3> = YR.TOT2(1)<3> + YFD
            YDEC = INDEX(YFD,".",1)
            IF YDEC THEN YDEC = LEN(YFD) - YDEC
            IF YT.DEC2(1)<3> = "" THEN
                YT.DEC2(1)<3> = YDEC
            END ELSE
                IF YDEC > YT.DEC2(1)<3> THEN
                    YT.DEC2(1)<3> = YDEC
                END
            END
        END
        YFD = YR.REC(129)  ;* YM.TOTAL.4
        IF NUM(YFD) = NUMERIC THEN
            YR.TOT2(1)<4> = YR.TOT2(1)<4> + YFD
            YDEC = INDEX(YFD,".",1)
            IF YDEC THEN YDEC = LEN(YFD) - YDEC
            IF YT.DEC2(1)<4> = "" THEN
                YT.DEC2(1)<4> = YDEC
            END ELSE
                IF YDEC > YT.DEC2(1)<4> THEN
                    YT.DEC2(1)<4> = YDEC
                END
            END
        END
        YFD = YR.REC(130)  ;* YM.TOTAL.5
        IF NUM(YFD) = NUMERIC THEN
            YR.TOT2(1)<5> = YR.TOT2(1)<5> + YFD
            YDEC = INDEX(YFD,".",1)
            IF YDEC THEN YDEC = LEN(YFD) - YDEC
            IF YT.DEC2(1)<5> = "" THEN
                YT.DEC2(1)<5> = YDEC
            END ELSE
                IF YDEC > YT.DEC2(1)<5> THEN
                    YT.DEC2(1)<5> = YDEC
                END
            END
        END
        YFD = YR.REC(131)  ;* YM.TOTAL.6B
        IF NUM(YFD) = NUMERIC THEN
            YR.TOT2(1)<6> = YR.TOT2(1)<6> + YFD
            YDEC = INDEX(YFD,".",1)
            IF YDEC THEN YDEC = LEN(YFD) - YDEC
            IF YT.DEC2(1)<6> = "" THEN
                YT.DEC2(1)<6> = YDEC
            END ELSE
                IF YDEC > YT.DEC2(1)<6> THEN
                    YT.DEC2(1)<6> = YDEC
                END
            END
        END
        YFD = YR.REC(132)  ;* YM.CALC.1
        IF NUM(YFD) = NUMERIC THEN
            YR.TOT2(1)<7> = YR.TOT2(1)<7> + YFD
            YDEC = INDEX(YFD,".",1)
            IF YDEC THEN YDEC = LEN(YFD) - YDEC
            IF YT.DEC2(1)<7> = "" THEN
                YT.DEC2(1)<7> = YDEC
            END ELSE
                IF YDEC > YT.DEC2(1)<7> THEN
                    YT.DEC2(1)<7> = YDEC
                END
            END
        END
        YFD = YR.REC(133)  ;* YM.CALC.2
        IF NUM(YFD) = NUMERIC THEN
            YR.TOT2(1)<8> = YR.TOT2(1)<8> + YFD
            YDEC = INDEX(YFD,".",1)
            IF YDEC THEN YDEC = LEN(YFD) - YDEC
            IF YT.DEC2(1)<8> = "" THEN
                YT.DEC2(1)<8> = YDEC
            END ELSE
                IF YDEC > YT.DEC2(1)<8> THEN
                    YT.DEC2(1)<8> = YDEC
                END
            END
        END
        YFD = YR.REC(134)  ;* YM.CALC.3
        IF NUM(YFD) = NUMERIC THEN
            YR.TOT2(1)<9> = YR.TOT2(1)<9> + YFD
            YDEC = INDEX(YFD,".",1)
            IF YDEC THEN YDEC = LEN(YFD) - YDEC
            IF YT.DEC2(1)<9> = "" THEN
                YT.DEC2(1)<9> = YDEC
            END ELSE
                IF YDEC > YT.DEC2(1)<9> THEN
                    YT.DEC2(1)<9> = YDEC
                END
            END
        END
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        YAV = 1
*
        FOR YAS = 2 TO YCOUNT.AS.LIN
            YFD = YR.REC(118)<1,YAV,YAS>  ;* YM.LIMIT.REFERENCE
            YFD = FMT(YFD,"20L")
            IF LEN(YFD) > 20 THEN YFD = YFD[1,19]:"|"
            YTOTFD := YFD
            YFD = YR.REC(119)<1,YAV,YAS>  ;* YM.MAXIMUM.TOTAL
            IF YFD = "" THEN
                YFD = STR(" ",15)
            END ELSE
                YFD = FMT(YFD,"15R0,")
                IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
            END
            IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
            YTOTFD := " ":YFD
            YFD = YR.REC(120)<1,YAV,YAS>  ;* YM.ONLINE.LIMIT
            IF YFD = "" THEN
                YFD = STR(" ",15)
            END ELSE
                YFD = FMT(YFD,"15R0,")
                IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
            END
            IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
            YTOTFD := " ":YFD
            YFD = YR.REC(121)<1,YAV,YAS>  ;* YM.TOTAL.OS
            IF YFD = "" THEN
                YFD = STR(" ",15)
            END ELSE
                YFD = FMT(YFD,"15R0,")
                IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
            END
            IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
            YTOTFD := " ":YFD
            YFD = YR.REC(122)<1,YAV,YAS>  ;* YM.AVAIL.AMT
            IF YFD = "" THEN
                YFD = STR(" ",15)
            END ELSE
                YFD = FMT(YFD,"15R0,")
                IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
            END
            IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
            YTOTFD := " ":YFD
            YFD = YR.REC(123)<1,YAV,YAS>  ;* YM.UNSECURED.AMOUNT
            IF YFD = "" THEN
                YFD = STR(" ",11)
            END ELSE
                YFD = FMT(YFD,"11R0,")
                IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
            END
            IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
            YTOTFD := " ":YFD
            YFD = YR.REC(124)<1,YAV,YAS>  ;* YM.COLLATERAL.DESC
            YFD = FMT(YFD,"20L")
            IF LEN(YFD) > 20 THEN YFD = YFD[1,19]:"|"
            YTOTFD := "    ":YFD
            YFD = YR.REC(125)<1,YAV,YAS>  ;* YM.SECURED.AMT
            IF YFD = "" THEN
                YFD = STR(" ",11)
            END ELSE
                YFD = FMT(YFD,"11R0,")
                IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
            END
            IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
            YTOTFD := " ":YFD
            GOSUB 9000000
            IF COMI = C.U THEN RETURN  ;* end of pgm
        NEXT YAS
*
        FOR YAV = 2 TO YCOUNT.LIN
            YCOUNT.AS.LIN = 1
            YCNT = COUNT(YR.REC(118)<1,YAV>,@SM)
            IF YCNT >= YCOUNT.AS.LIN THEN YCOUNT.AS.LIN = YCNT+1
            YFD = YR.REC(118)<1,YAV,1>  ;* YM.LIMIT.REFERENCE
            YFD = FMT(YFD,"20L")
            IF LEN(YFD) > 20 THEN YFD = YFD[1,19]:"|"
            YTOTFD := YFD
            YCNT = COUNT(YR.REC(119)<1,YAV>,@SM)
            IF YCNT >= YCOUNT.AS.LIN THEN YCOUNT.AS.LIN = YCNT+1
            YFD = YR.REC(119)<1,YAV,1>  ;* YM.MAXIMUM.TOTAL
            IF YFD = "" THEN
                YFD = STR(" ",15)
            END ELSE
                YFD = FMT(YFD,"15R0,")
                IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
            END
            IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
            YTOTFD := " ":YFD
            YCNT = COUNT(YR.REC(120)<1,YAV>,@SM)
            IF YCNT >= YCOUNT.AS.LIN THEN YCOUNT.AS.LIN = YCNT+1
            YFD = YR.REC(120)<1,YAV,1>  ;* YM.ONLINE.LIMIT
            IF YFD = "" THEN
                YFD = STR(" ",15)
            END ELSE
                YFD = FMT(YFD,"15R0,")
                IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
            END
            IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
            YTOTFD := " ":YFD
            YCNT = COUNT(YR.REC(121)<1,YAV>,@SM)
            IF YCNT >= YCOUNT.AS.LIN THEN YCOUNT.AS.LIN = YCNT+1
            YFD = YR.REC(121)<1,YAV,1>  ;* YM.TOTAL.OS
            IF YFD = "" THEN
                YFD = STR(" ",15)
            END ELSE
                YFD = FMT(YFD,"15R0,")
                IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
            END
            IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
            YTOTFD := " ":YFD
            YCNT = COUNT(YR.REC(122)<1,YAV>,@SM)
            IF YCNT >= YCOUNT.AS.LIN THEN YCOUNT.AS.LIN = YCNT+1
            YFD = YR.REC(122)<1,YAV,1>  ;* YM.AVAIL.AMT
            IF YFD = "" THEN
                YFD = STR(" ",15)
            END ELSE
                YFD = FMT(YFD,"15R0,")
                IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
            END
            IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
            YTOTFD := " ":YFD
            YCNT = COUNT(YR.REC(123)<1,YAV>,@SM)
            IF YCNT >= YCOUNT.AS.LIN THEN YCOUNT.AS.LIN = YCNT+1
            YFD = YR.REC(123)<1,YAV,1>  ;* YM.UNSECURED.AMOUNT
            IF YFD = "" THEN
                YFD = STR(" ",11)
            END ELSE
                YFD = FMT(YFD,"11R0,")
                IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
            END
            IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
            YTOTFD := " ":YFD
            YCNT = COUNT(YR.REC(124)<1,YAV>,@SM)
            IF YCNT >= YCOUNT.AS.LIN THEN YCOUNT.AS.LIN = YCNT+1
            YFD = YR.REC(124)<1,YAV,1>  ;* YM.COLLATERAL.DESC
            YFD = FMT(YFD,"20L")
            IF LEN(YFD) > 20 THEN YFD = YFD[1,19]:"|"
            YTOTFD := "    ":YFD
            YCNT = COUNT(YR.REC(125)<1,YAV>,@SM)
            IF YCNT >= YCOUNT.AS.LIN THEN YCOUNT.AS.LIN = YCNT+1
            YFD = YR.REC(125)<1,YAV,1>  ;* YM.SECURED.AMT
            IF YFD = "" THEN
                YFD = STR(" ",11)
            END ELSE
                YFD = FMT(YFD,"11R0,")
                IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
            END
            IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
            YTOTFD := " ":YFD
            GOSUB 9000000
            IF COMI = C.U THEN RETURN  ;* end of pgm
*
            FOR YAS = 2 TO YCOUNT.AS.LIN
                YFD = YR.REC(118)<1,YAV,YAS>  ;* YM.LIMIT.REFERENCE
                YFD = FMT(YFD,"20L")
                IF LEN(YFD) > 20 THEN YFD = YFD[1,19]:"|"
                YTOTFD := YFD
                YFD = YR.REC(119)<1,YAV,YAS>  ;* YM.MAXIMUM.TOTAL
                IF YFD = "" THEN
                    YFD = STR(" ",15)
                END ELSE
                    YFD = FMT(YFD,"15R0,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
                YTOTFD := " ":YFD
                YFD = YR.REC(120)<1,YAV,YAS>  ;* YM.ONLINE.LIMIT
                IF YFD = "" THEN
                    YFD = STR(" ",15)
                END ELSE
                    YFD = FMT(YFD,"15R0,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
                YTOTFD := " ":YFD
                YFD = YR.REC(121)<1,YAV,YAS>  ;* YM.TOTAL.OS
                IF YFD = "" THEN
                    YFD = STR(" ",15)
                END ELSE
                    YFD = FMT(YFD,"15R0,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
                YTOTFD := " ":YFD
                YFD = YR.REC(122)<1,YAV,YAS>  ;* YM.AVAIL.AMT
                IF YFD = "" THEN
                    YFD = STR(" ",15)
                END ELSE
                    YFD = FMT(YFD,"15R0,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
                YTOTFD := " ":YFD
                YFD = YR.REC(123)<1,YAV,YAS>  ;* YM.UNSECURED.AMOUNT
                IF YFD = "" THEN
                    YFD = STR(" ",11)
                END ELSE
                    YFD = FMT(YFD,"11R0,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
                YTOTFD := " ":YFD
                YFD = YR.REC(124)<1,YAV,YAS>  ;* YM.COLLATERAL.DESC
                YFD = FMT(YFD,"20L")
                IF LEN(YFD) > 20 THEN YFD = YFD[1,19]:"|"
                YTOTFD := "    ":YFD
                YFD = YR.REC(125)<1,YAV,YAS>  ;* YM.SECURED.AMT
                IF YFD = "" THEN
                    YFD = STR(" ",11)
                END ELSE
                    YFD = FMT(YFD,"11R0,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
                YTOTFD := " ":YFD
                GOSUB 9000000
                IF COMI = C.U THEN RETURN  ;* end of pgm
            NEXT YAS
        NEXT YAV
        GOSUB 1000000
*
        IF YKEY.OLD[1,1] <> YKEY[1,1] THEN
            YTOTAL.STATUS = 1
            Y1ST.LIN = 1
            FOR YAV.TOT = 1 TO YTOTAL.STATUS STEP -1
                GOSUB 9000010
                IF COMI = C.U THEN RETURN  ;* end of pgm
*
                YCOUNT.TOT2 = 1; YCOUNT.AS.TOT2 = 1
                YFD = YR.TOT2(YAV.TOT)<1>  ;* YM.TOTAL.1
                YR.TOT2(YAV.TOT)<1> = ""
                IF YFD = "" THEN
                    YFD = STR(" ",15)
                END ELSE
                    YFD = FMT(YFD,"15R0,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
                YFD = "TOTAL                ":YFD
                YTOTFD := YFD
                YFD = YR.TOT2(YAV.TOT)<2>  ;* YM.TOTAL.2
                YR.TOT2(YAV.TOT)<2> = ""
                IF YFD = "" THEN
                    YFD = STR(" ",15)
                END ELSE
                    YFD = FMT(YFD,"15R0,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
                YTOTFD := " ":YFD
                YFD = YR.TOT2(YAV.TOT)<3>  ;* YM.TOTAL.3
                YR.TOT2(YAV.TOT)<3> = ""
                IF YFD = "" THEN
                    YFD = STR(" ",15)
                END ELSE
                    YFD = FMT(YFD,"15R0,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
                YTOTFD := " ":YFD
                YFD = YR.TOT2(YAV.TOT)<4>  ;* YM.TOTAL.4
                YR.TOT2(YAV.TOT)<4> = ""
                IF YFD = "" THEN
                    YFD = STR(" ",15)
                END ELSE
                    YFD = FMT(YFD,"15R0,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
                YTOTFD := " ":YFD
                YFD = YR.TOT2(YAV.TOT)<5>  ;* YM.TOTAL.5
                YR.TOT2(YAV.TOT)<5> = ""
                IF YFD = "" THEN
                    YFD = STR(" ",11)
                END ELSE
                    YFD = FMT(YFD,"11R0,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
                YTOTFD := " ":YFD
                YFD = YR.TOT2(YAV.TOT)<6>  ;* YM.TOTAL.6B
                YR.TOT2(YAV.TOT)<6> = ""
                IF YFD = "" THEN
                    YFD = STR(" ",11)
                END ELSE
                    YFD = FMT(YFD,"11R0,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
                YTOTFD := "                         ":YFD
                YFD = YR.TOT2(YAV.TOT)<7>  ;* YM.CALC.1
                YR.TOT2(YAV.TOT)<7> = ""
                IF YFD = "" THEN
                    YFD = STR(" ",15)
                END ELSE
                    YFD = FMT(YFD,"15R0,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
                YFD = "THEORIQUE DISPONT    ":YFD
                GOSUB 9000000
                IF COMI = C.U THEN RETURN  ;* end of pgm
                YTOTFD := YFD
                YFD = YR.TOT2(YAV.TOT)<8>  ;* YM.CALC.2
                YR.TOT2(YAV.TOT)<8> = ""
                IF YFD = "" THEN
                    YFD = STR(" ",15)
                END ELSE
                    YFD = FMT(YFD,"15R0,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
                YTOTFD := " ":YFD
                YFD = YR.TOT2(YAV.TOT)<9>  ;* YM.CALC.3
                YR.TOT2(YAV.TOT)<9> = ""
                IF YFD = "" THEN
                    YFD = STR(" ",15)
                END ELSE
                    YFD = FMT(YFD,"15R0,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 15 THEN YFD = YFD[1,14]:"|"
                YTOTFD := " ":YFD
                GOSUB 9000000
                IF COMI = C.U THEN RETURN  ;* end of pgm
            NEXT YAV.TOT
        END
*
        IF YKEY.OLD[1,11] <> YKEY[1,11] THEN
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
                YHDR = "ASSET & LIABILITY OVERVIEW"
                IF YPRINTING THEN
                    YHDR = "RGP.LIM.AL.POSITION ":YHDR
                    YTYPE = "HEADER":@FM:YHDR
                    CALL PST ( YTYPE )
                END ELSE
                    YTYPE = YHDR
                END
                YHDR1 = ""
                YHDR2 = ""
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
        C$RPT.CUSTOMER.NO = YR.REC(135)
        C$RPT.ACCOUNT.NO = YR.REC(136)
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
    MATREAD YR.REC FROM F.FILE, YKEY ELSE MAT YR.REC = "" ; GOSUB 1000000;* R22 Manual Conversion changed GOTO TO GOSUB
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
            NEXTP = P+1; IF NEXTP = LASTP+1 THEN GOSUB 9190000;* R22 Manual Conversion changed GOTO TO GOSUB
        CASE COMI = C.E; NEXTP = LASTP
        CASE COMI = C.V OR COMI = C.W OR COMI = C.U
            PRINT S.COL132.OFF:
            CLEARSELECT; COMI = C.U; RETURN
        CASE COMI = "P"; NEXTP = 1
        CASE COMI[1,1] = "P" AND NUM(COMI[2,99]) = NUMERIC
            NEXTP = COMI[2,99]
            IF NEXTP = LASTP+1 THEN COMI = C.F; GOSUB 9190000;* R22 Manual Conversion changed GOTO TO GOSUB
        CASE 1
            E = ""; L = 22; CALL ERR; GOSUB 9100010;* R22 Manual Conversion changed GOTO TO GOSUB
    END CASE
*
    IF NEXTP < 1 THEN
        NEXTP = 1
    END ELSE
        IF NEXTP > LASTP THEN NEXTP = LASTP
    END
    IF NEXTP = P THEN GOSUB 9100000 ;* R22 Manual Conversion changed GOTO TO GOSUB
    P = NEXTP
*
    GOSUB 9200000
    FOR LL = L1ST TO 19
        X = YT.PAGE<P,LL>; IF X <> "" THEN PRINT @(0,LL):X:
    NEXT LL; GOSUB 9100000;* R22 Manual Conversion changed GOTO TO GOSUB
*
9190000:
    IF YEND THEN GOSUB 9100000 ELSE P = NEXTP ;* R22 Manual Conversion changed GOTO TO GOSUB
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
