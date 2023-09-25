* @ValidationCode : MjotMTk4NTExNDkxMzpDcDEyNTI6MTY4ODUzNjg5MzUxMTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jul 2023 11:31:33
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
SUBROUTINE RGP.TRANS.T24INV6
REM "RGP.TRANS.T24INV6",230614-4
*************************************************************************
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 15-JUNE-2023      Harsha                R22 Manual Conversion - GOTO to GOSUB
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_RC.COMMON
    $INSERT I_SCREEN.VARIABLES
    $INSERT I_F.COMPANY
    $INSERT I_F.LANGUAGE
    $INSERT I_F.USER
*************************************************************************
    REPORT.ID = "RG.TRANS.T24INV6"
    PRT.UNIT = 0
    IF V$DISPLAY = "D" THEN YPRINTING = 0 ELSE YPRINTING = 1
    IF NOT(YPRINTING) THEN IF NOT(S.COL132.ON) THEN
        TEXT = "TERMINAL CANNOT DISPLAY 132 COLUMS"
        CALL REM; RETURN  ;* end of pgm
    END
*************************************************************************
    YT.SMS.COMP = ID.COMPANY
    YT.SMS.FILE = "CATEG.ENTRY"
    YT.SMS.FILE<-1> = "STMT.ENTRY"
    YT.SMS.FILE<-1> = "RE.CONSOL.SPEC.ENTRY"
    YT.SMS.FILE<-1> = "COMPANY"
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
    F.LANGUAGE=""; CALL OPF("F.LANGUAGE",F.LANGUAGE)
    READV AMOUNT.FORMAT FROM F.LANGUAGE,LNGG,EB.LAN.AMOUNT.FORMAT ELSE AMOUNT.FORMAT=""
    CLEARSELECT
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.TRANS.T24INV6"
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
    DIM YR.REC(19); MAT YR.REC = ""
    DIM YR.REC.OLD(17); MAT YR.REC.OLD = "_"
    GOSUB 1000000
    YHDR = "INVEST. LIST OF TODAYS ENTRIES WITH EXPANDED CRF INFO"
    IF YPRINTING THEN
        YHDR = "RGP.TRANS.T24INV6 ":YHDR
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
    YHDR.GROUP = "ENTRY LIST EXCLUDING ALL CONTINGENT ENTRIES"
    YHDR1 = "TRANS.REFERENCE  ACCOUNT/CATEG CODE/CRF KEY   ASSET TYPE          LCY AMOUNT EXCH.RATE   CCY          FCY AMOUNT VAL.DAT T/C CUST/MD"
    YHDR2 = "===============  ==========================   ==========          ========== =========   ===          ========== ======= === ======="
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
*------------------------------------------------------------------------
    MAT YR.REC.OLD = "_"
    DIM YR.TOT2(3); MAT YR.TOT2 = ""
    DIM YT.DEC2(3); MAT YT.DEC2 = ""
    Y1ST.LIN = 1
    LOOP WHILE YKEYFD = "1" DO
        YHEADER.DISPLAY = 0; YHEADER.STATUS = ""
        BEGIN CASE
            CASE YR.REC.OLD(1) <> YR.REC(1); YHEADER.STATUS = 1
            CASE YR.REC.OLD(3) <> YR.REC(3); YHEADER.STATUS = 2
            CASE YR.REC.OLD(4) <> YR.REC(4); YHEADER.STATUS = 3
        END CASE
        IF YHEADER.STATUS THEN
            GOSUB 9000010; Y1ST.LIN = 1
            IF COMI = C.U THEN RETURN  ;* end of pgm
        END
        YFD.OLD = YR.REC.OLD(1); YFD = YR.REC(1)  ;* YM.PRT.SYS
        IF YHEADER.DISPLAY OR YFD.OLD <> YFD THEN
            YHEADER.DISPLAY = 1
            YFD = FMT(YFD,"2L")
            IF LEN(YFD) > 2 THEN YFD = YFD[1,1]:"|"
            YFD = "APPLICATION:   ":YFD
            YTOTFD := YFD
        END ELSE
            IF YHEADER.STATUS > 1 THEN
                YFD = "                 "
                YTOTFD := YFD
            END
        END
        YFD.OLD = YR.REC.OLD(3); YFD = YR.REC(3)  ;* YM.UNDER
        IF YHEADER.DISPLAY OR YFD.OLD <> YFD THEN
            YHEADER.DISPLAY = 1
            YFD = FMT(YFD,"11L")
            IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
            GOSUB 9000000
            IF COMI = C.U THEN RETURN  ;* end of pgm
            YTOTFD := YFD
        END ELSE
            IF YHEADER.STATUS > 2 THEN
                YFD = "           "
                GOSUB 9000000
                IF COMI = C.U THEN RETURN  ;* end of pgm
                YTOTFD := YFD
            END
        END
        YFD.OLD = YR.REC.OLD(4); YFD = YR.REC(4)  ;* YM.SORT.REF
        IF YHEADER.DISPLAY OR YFD.OLD <> YFD THEN
            YHEADER.DISPLAY = 1
            YFD = FMT(YFD,"16L")
            IF LEN(YFD) > 16 THEN YFD = YFD[1,15]:"|"
            YFD = "SORT GROUP CODE ":YFD
            YTOTFD := "        ":YFD
        END
        IF YHEADER.DISPLAY THEN
            GOSUB 9000010
            IF COMI = C.U THEN RETURN  ;* end of pgm
        END
        YCOUNT.LIN = 1; YCOUNT.AS.LIN = 1
        YCOUNT.TOT2 = 1; YCOUNT.AS.TOT2 = 1
        YFD = YR.REC(2)  ;* YM.TOT.SYS.PRT
        YR.TOT2(3)<1> = YFD
        IF NUM(YFD) = NUMERIC THEN
            YDEC = INDEX(YFD,".",1)
            IF YDEC THEN YDEC = LEN(YFD) - YDEC
            IF YT.DEC2(2)<1> = "" THEN
                YT.DEC2(2)<1> = YDEC
            END ELSE
                IF YDEC > YT.DEC2(2)<1> THEN
                    YT.DEC2(2)<1> = YDEC
                END
            END
        END
        IF Y1ST.LIN THEN
            Y1ST.LIN = 0; GOSUB 9000010
            IF COMI = C.U THEN RETURN  ;* end of pgm
        END
        YFD = YR.REC(5)  ;* YM.TRANS.REF
        YFD = FMT(YFD,"16L")
        IF LEN(YFD) > 16 THEN YFD = YFD[1,15]:"|"
        YTOTFD := YFD
        YFD = YR.REC(6)  ;* YM.ACCOUNT
        YFD = FMT(YFD,"26L")
        IF LEN(YFD) > 26 THEN YFD = YFD[1,25]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(7)  ;* YM.OUT.ARG2
        IF YFD = "" THEN
            YFD = STR(" ",12)
        END ELSE
            YFD = FMT(YFD,"R############")
        END
        IF LEN(YFD) > 12 THEN YFD = YFD[1,11]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(8)  ;* YM.AMOUNTLCY
        IF YFD = "" THEN
            YFD = STR(" ",19)
        END ELSE
            YFD = FMT(YFD,"19R2,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 19 THEN YFD = YFD[1,18]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(9)  ;* YM.TOTALNET
        IF NUM(YFD) = NUMERIC THEN
            FOR YNO = 1 TO 3
                YR.TOT2(YNO)<2> = YR.TOT2(YNO)<2> + YFD
                YDEC = INDEX(YFD,".",1)
                IF YDEC THEN YDEC = LEN(YFD) - YDEC
                IF YT.DEC2(YNO)<2> = "" THEN
                    YT.DEC2(YNO)<2> = YDEC
                END ELSE
                    IF YDEC > YT.DEC2(YNO)<2> THEN
                        YT.DEC2(YNO)<2> = YDEC
                    END
                END
            NEXT YNO
        END
        YFD = YR.REC(10)  ;* YM.AMOUNT.CREDIT
        IF NUM(YFD) = NUMERIC THEN
            FOR YNO = 1 TO 3
                YR.TOT2(YNO)<3> = YR.TOT2(YNO)<3> + YFD
                YDEC = INDEX(YFD,".",1)
                IF YDEC THEN YDEC = LEN(YFD) - YDEC
                IF YT.DEC2(YNO)<3> = "" THEN
                    YT.DEC2(YNO)<3> = YDEC
                END ELSE
                    IF YDEC > YT.DEC2(YNO)<3> THEN
                        YT.DEC2(YNO)<3> = YDEC
                    END
                END
            NEXT YNO
        END
        YFD = YR.REC(11)  ;* YM.AMOUNT.DEBIT
        IF NUM(YFD) = NUMERIC THEN
            FOR YNO = 1 TO 3
                YR.TOT2(YNO)<4> = YR.TOT2(YNO)<4> + YFD
                YDEC = INDEX(YFD,".",1)
                IF YDEC THEN YDEC = LEN(YFD) - YDEC
                IF YT.DEC2(YNO)<4> = "" THEN
                    YT.DEC2(YNO)<4> = YDEC
                END ELSE
                    IF YDEC > YT.DEC2(YNO)<4> THEN
                        YT.DEC2(YNO)<4> = YDEC
                    END
                END
            NEXT YNO
        END
        YFD = YR.REC(12)  ;* YM.RATE
        YFD = FMT(YFD,"11L")
        IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(13)  ;* YM.CCY
        YFD = FMT(YFD,"3L")
        IF LEN(YFD) > 3 THEN YFD = YFD[1,2]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(14)  ;* YM.FCYAMOUNT
        IF YFD = "" THEN
            YFD = STR(" ",19)
        END ELSE
            YDEC = INDEX(YFD,".",1)
            IF YDEC THEN YDEC = LEN(YFD) - YDEC
            YFD = FMT(YFD,"19R":YDEC:",")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 19 THEN YFD = YFD[1,18]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(15)  ;* YM.VD.FORM
        IF YFD = "" THEN
            YFD = STR(" ",7)
        END ELSE
            YFD = FMT(YFD,"R#######")
        END
        IF LEN(YFD) > 7 THEN YFD = YFD[1,6]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(16)  ;* YM.TRANS.CODE
        IF YFD = "" THEN
            YFD = STR(" ",3)
        END ELSE
            YFD = FMT(YFD,"R###")
        END
        IF LEN(YFD) > 3 THEN YFD = YFD[1,2]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(17)  ;* YM.CUSTOMER
        IF YFD = "" THEN
            YFD = STR(" ",7)
        END ELSE
            YFD = FMT(YFD,"R#######")
        END
        IF LEN(YFD) > 7 THEN YFD = YFD[1,6]:"|"
        YTOTFD := " ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        GOSUB 1000000
*
        IF YKEY.OLD[1,24] <> YKEY[1,24] THEN
            YTOTAL.STATUS = 3
            IF YKEY.OLD[1,6] <> YKEY[1,6] THEN
                YTOTAL.STATUS = 2
                IF YKEY.OLD[1,2] <> YKEY[1,2] THEN
                    YTOTAL.STATUS = 1
                END
            END
            Y1ST.LIN = 1
            FOR YAV.TOT = 3 TO YTOTAL.STATUS STEP -1
                GOSUB 9000010
                IF COMI = C.U THEN RETURN  ;* end of pgm
*
                YCOUNT.TOT2 = 1; YCOUNT.AS.TOT2 = 1
                YFD = YR.TOT2(YAV.TOT)<1>  ;* YM.TOT.SYS.PRT
                YR.TOT2(YAV.TOT)<1> = ""
                YFD = FMT(YFD,"2L")
                IF LEN(YFD) > 2 THEN YFD = YFD[1,1]:"|"
                YTOTFD := "  ":YFD
                YFD = YR.TOT2(YAV.TOT)<2>  ;* YM.TOTALNET
                YR.TOT2(YAV.TOT)<2> = ""
                IF YFD = "" THEN
                    YFD = STR(" ",19)
                END ELSE
                    YFD = FMT(YFD,"19R2,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 19 THEN YFD = YFD[1,18]:"|"
                YFD = "LOCAL CURRENCY TOTAL/NET ":YFD
                YTOTFD := "  ":YFD
                YFD = YR.TOT2(YAV.TOT)<3>  ;* YM.AMOUNT.CREDIT
                YR.TOT2(YAV.TOT)<3> = ""
                IF YFD = "" THEN
                    YFD = STR(" ",19)
                END ELSE
                    YFD = FMT(YFD,"19R2,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 19 THEN YFD = YFD[1,18]:"|"
                YFD = "TOTAL CREDIT ":YFD
                YTOTFD := "       ":YFD
                YFD = YR.TOT2(YAV.TOT)<4>  ;* YM.AMOUNT.DEBIT
                YR.TOT2(YAV.TOT)<4> = ""
                IF YFD = "" THEN
                    YFD = STR(" ",19)
                END ELSE
                    YFD = FMT(YFD,"19R2,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 19 THEN YFD = YFD[1,18]:"|"
                YFD = "TOTAL DEBIT ":YFD
                YTOTFD := "     ":YFD
                GOSUB 9000000
                IF COMI = C.U THEN RETURN  ;* end of pgm
            NEXT YAV.TOT
        END
*
        IF YKEY.OLD[1,6] <> YKEY[1,6] THEN
            IF YKEY.OLD[1,2] = YKEY[1,2] THEN
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
                YHDR = "INVEST. LIST OF TODAYS ENTRIES WITH EXPANDED CRF INFO"
                IF YPRINTING THEN
                    YHDR = "RGP.TRANS.T24INV6 ":YHDR
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
                YHDR.GROUP = "ENTRY LIST EXCLUDING ALL CONTINGENT ENTRIES"
                YHDR1 = "TRANS.REFERENCE  ACCOUNT/CATEG CODE/CRF KEY   ASSET TYPE          LCY AMOUNT EXCH.RATE   CCY          FCY AMOUNT VAL.DAT T/C CUST/MD"
                YHDR2 = "===============  ==========================   ==========          ========== =========   ===          ========== ======= === ======="
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
*
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
    IF YPRINTING THEN
        CALL PRINTER.OFF; CALL PRINTER.CLOSE(REPORT.ID,PRT.UNIT,"")
        CALL PRINTER.ON(REPORT.ID,PRT.UNIT)
    END
    IF NOT(YPRINTING) THEN
        L = 999; GOSUB 9000010
        IF COMI = C.U THEN RETURN  ;* end of pgm
    END
    YHDR = "INVEST. LIST OF TODAYS ENTRIES WITH EXPANDED CRF INFO"
    IF YPRINTING THEN
        YHDR = "RGP.TRANS.T24INV6 ":YHDR
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
    YHDR.GROUP = "CONTINGENT ENTRIES"
    YHDR1 = "TRANS.REFERENCE  ACCOUNT/CATEG CODE/CRF KEY   ASSET TYPE          LCY AMOUNT EXCH.RATE   CCY          FCY AMOUNT VAL.DAT T/C CUST/MD"
    YHDR2 = "===============  ==========================   ==========          ========== =========   ===          ========== ======= === ======="
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
*------------------------------------------------------------------------
    MAT YR.REC.OLD = "_"
    DIM YR.TOT2(3); MAT YR.TOT2 = ""
    DIM YT.DEC2(3); MAT YT.DEC2 = ""
    Y1ST.LIN = 1
    LOOP WHILE YKEYFD = "2" DO
        YHEADER.DISPLAY = 0; YHEADER.STATUS = ""
        BEGIN CASE
            CASE YR.REC.OLD(1) <> YR.REC(1); YHEADER.STATUS = 1
            CASE YR.REC.OLD(3) <> YR.REC(3); YHEADER.STATUS = 2
            CASE YR.REC.OLD(4) <> YR.REC(4); YHEADER.STATUS = 3
        END CASE
        IF YHEADER.STATUS THEN
            GOSUB 9000010; Y1ST.LIN = 1
            IF COMI = C.U THEN RETURN  ;* end of pgm
        END
        YFD.OLD = YR.REC.OLD(1); YFD = YR.REC(1)  ;* YM.PRT.SYS
        IF YHEADER.DISPLAY OR YFD.OLD <> YFD THEN
            YHEADER.DISPLAY = 1
            YFD = FMT(YFD,"2L")
            IF LEN(YFD) > 2 THEN YFD = YFD[1,1]:"|"
            YFD = "APPLICATION:   ":YFD
            YTOTFD := YFD
        END ELSE
            IF YHEADER.STATUS > 1 THEN
                YFD = "                 "
                YTOTFD := YFD
            END
        END
        YFD.OLD = YR.REC.OLD(3); YFD = YR.REC(3)  ;* YM.UNDER
        IF YHEADER.DISPLAY OR YFD.OLD <> YFD THEN
            YHEADER.DISPLAY = 1
            YFD = FMT(YFD,"11L")
            IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
            GOSUB 9000000
            IF COMI = C.U THEN RETURN  ;* end of pgm
            YTOTFD := YFD
        END ELSE
            IF YHEADER.STATUS > 2 THEN
                YFD = "           "
                GOSUB 9000000
                IF COMI = C.U THEN RETURN  ;* end of pgm
                YTOTFD := YFD
            END
        END
        YFD.OLD = YR.REC.OLD(4); YFD = YR.REC(4)  ;* YM.SORT.REF
        IF YHEADER.DISPLAY OR YFD.OLD <> YFD THEN
            YHEADER.DISPLAY = 1
            YFD = FMT(YFD,"16L")
            IF LEN(YFD) > 16 THEN YFD = YFD[1,15]:"|"
            YFD = "SORT GROUP CODE ":YFD
            YTOTFD := "        ":YFD
        END
        IF YHEADER.DISPLAY THEN
            GOSUB 9000010
            IF COMI = C.U THEN RETURN  ;* end of pgm
        END
        YCOUNT.LIN = 1; YCOUNT.AS.LIN = 1
        YCOUNT.TOT2 = 1; YCOUNT.AS.TOT2 = 1
        YFD = YR.REC(2)  ;* YM.TOT.SYS.PRT
        YR.TOT2(3)<1> = YFD
        IF NUM(YFD) = NUMERIC THEN
            YDEC = INDEX(YFD,".",1)
            IF YDEC THEN YDEC = LEN(YFD) - YDEC
            IF YT.DEC2(2)<1> = "" THEN
                YT.DEC2(2)<1> = YDEC
            END ELSE
                IF YDEC > YT.DEC2(2)<1> THEN
                    YT.DEC2(2)<1> = YDEC
                END
            END
        END
        IF Y1ST.LIN THEN
            Y1ST.LIN = 0; GOSUB 9000010
            IF COMI = C.U THEN RETURN  ;* end of pgm
        END
        YFD = YR.REC(5)  ;* YM.TRANS.REF
        YFD = FMT(YFD,"16L")
        IF LEN(YFD) > 16 THEN YFD = YFD[1,15]:"|"
        YTOTFD := YFD
        YFD = YR.REC(6)  ;* YM.ACCOUNT
        YFD = FMT(YFD,"26L")
        IF LEN(YFD) > 26 THEN YFD = YFD[1,25]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(7)  ;* YM.OUT.ARG2
        IF YFD = "" THEN
            YFD = STR(" ",12)
        END ELSE
            YFD = FMT(YFD,"R############")
        END
        IF LEN(YFD) > 12 THEN YFD = YFD[1,11]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(8)  ;* YM.AMOUNTLCY
        IF YFD = "" THEN
            YFD = STR(" ",19)
        END ELSE
            YFD = FMT(YFD,"19R2,")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 19 THEN YFD = YFD[1,18]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(9)  ;* YM.TOTALNET
        IF NUM(YFD) = NUMERIC THEN
            FOR YNO = 1 TO 3
                YR.TOT2(YNO)<2> = YR.TOT2(YNO)<2> + YFD
                YDEC = INDEX(YFD,".",1)
                IF YDEC THEN YDEC = LEN(YFD) - YDEC
                IF YT.DEC2(YNO)<2> = "" THEN
                    YT.DEC2(YNO)<2> = YDEC
                END ELSE
                    IF YDEC > YT.DEC2(YNO)<2> THEN
                        YT.DEC2(YNO)<2> = YDEC
                    END
                END
            NEXT YNO
        END
        YFD = YR.REC(10)  ;* YM.AMOUNT.CREDIT
        IF NUM(YFD) = NUMERIC THEN
            FOR YNO = 1 TO 3
                YR.TOT2(YNO)<3> = YR.TOT2(YNO)<3> + YFD
                YDEC = INDEX(YFD,".",1)
                IF YDEC THEN YDEC = LEN(YFD) - YDEC
                IF YT.DEC2(YNO)<3> = "" THEN
                    YT.DEC2(YNO)<3> = YDEC
                END ELSE
                    IF YDEC > YT.DEC2(YNO)<3> THEN
                        YT.DEC2(YNO)<3> = YDEC
                    END
                END
            NEXT YNO
        END
        YFD = YR.REC(11)  ;* YM.AMOUNT.DEBIT
        IF NUM(YFD) = NUMERIC THEN
            FOR YNO = 1 TO 3
                YR.TOT2(YNO)<4> = YR.TOT2(YNO)<4> + YFD
                YDEC = INDEX(YFD,".",1)
                IF YDEC THEN YDEC = LEN(YFD) - YDEC
                IF YT.DEC2(YNO)<4> = "" THEN
                    YT.DEC2(YNO)<4> = YDEC
                END ELSE
                    IF YDEC > YT.DEC2(YNO)<4> THEN
                        YT.DEC2(YNO)<4> = YDEC
                    END
                END
            NEXT YNO
        END
        YFD = YR.REC(12)  ;* YM.RATE
        YFD = FMT(YFD,"11L")
        IF LEN(YFD) > 11 THEN YFD = YFD[1,10]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(13)  ;* YM.CCY
        YFD = FMT(YFD,"3L")
        IF LEN(YFD) > 3 THEN YFD = YFD[1,2]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(14)  ;* YM.FCYAMOUNT
        IF YFD = "" THEN
            YFD = STR(" ",19)
        END ELSE
            YDEC = INDEX(YFD,".",1)
            IF YDEC THEN YDEC = LEN(YFD) - YDEC
            YFD = FMT(YFD,"19R":YDEC:",")
            IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
        END
        IF LEN(YFD) > 19 THEN YFD = YFD[1,18]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(15)  ;* YM.VD.FORM
        IF YFD = "" THEN
            YFD = STR(" ",7)
        END ELSE
            YFD = FMT(YFD,"R#######")
        END
        IF LEN(YFD) > 7 THEN YFD = YFD[1,6]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(16)  ;* YM.TRANS.CODE
        IF YFD = "" THEN
            YFD = STR(" ",3)
        END ELSE
            YFD = FMT(YFD,"R###")
        END
        IF LEN(YFD) > 3 THEN YFD = YFD[1,2]:"|"
        YTOTFD := " ":YFD
        YFD = YR.REC(17)  ;* YM.CUSTOMER
        IF YFD = "" THEN
            YFD = STR(" ",7)
        END ELSE
            YFD = FMT(YFD,"R#######")
        END
        IF LEN(YFD) > 7 THEN YFD = YFD[1,6]:"|"
        YTOTFD := " ":YFD
        GOSUB 9000000
        IF COMI = C.U THEN RETURN  ;* end of pgm
        GOSUB 1000000
*
        IF YKEY.OLD[1,24] <> YKEY[1,24] THEN
            YTOTAL.STATUS = 3
            IF YKEY.OLD[1,6] <> YKEY[1,6] THEN
                YTOTAL.STATUS = 2
                IF YKEY.OLD[1,2] <> YKEY[1,2] THEN
                    YTOTAL.STATUS = 1
                END
            END
            Y1ST.LIN = 1
            FOR YAV.TOT = 3 TO YTOTAL.STATUS STEP -1
                GOSUB 9000010
                IF COMI = C.U THEN RETURN  ;* end of pgm
*
                YCOUNT.TOT2 = 1; YCOUNT.AS.TOT2 = 1
                YFD = YR.TOT2(YAV.TOT)<1>  ;* YM.TOT.SYS.PRT
                YR.TOT2(YAV.TOT)<1> = ""
                YFD = FMT(YFD,"2L")
                IF LEN(YFD) > 2 THEN YFD = YFD[1,1]:"|"
                YTOTFD := "  ":YFD
                YFD = YR.TOT2(YAV.TOT)<2>  ;* YM.TOTALNET
                YR.TOT2(YAV.TOT)<2> = ""
                IF YFD = "" THEN
                    YFD = STR(" ",19)
                END ELSE
                    YFD = FMT(YFD,"19R2,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 19 THEN YFD = YFD[1,18]:"|"
                YFD = "LOCAL CURRENCY TOTAL/NET ":YFD
                YTOTFD := "  ":YFD
                YFD = YR.TOT2(YAV.TOT)<3>  ;* YM.AMOUNT.CREDIT
                YR.TOT2(YAV.TOT)<3> = ""
                IF YFD = "" THEN
                    YFD = STR(" ",19)
                END ELSE
                    YFD = FMT(YFD,"19R2,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 19 THEN YFD = YFD[1,18]:"|"
                YFD = "TOTAL CREDIT ":YFD
                YTOTFD := "       ":YFD
                YFD = YR.TOT2(YAV.TOT)<4>  ;* YM.AMOUNT.DEBIT
                YR.TOT2(YAV.TOT)<4> = ""
                IF YFD = "" THEN
                    YFD = STR(" ",19)
                END ELSE
                    YFD = FMT(YFD,"19R2,")
                    IF AMOUNT.FORMAT#"" THEN CONVERT ",." TO AMOUNT.FORMAT IN YFD
                END
                IF LEN(YFD) > 19 THEN YFD = YFD[1,18]:"|"
                YFD = "TOTAL DEBIT ":YFD
                YTOTFD := "     ":YFD
                GOSUB 9000000
                IF COMI = C.U THEN RETURN  ;* end of pgm
            NEXT YAV.TOT
        END
*
        IF YKEY.OLD[1,6] <> YKEY[1,6] THEN
            IF YKEY.OLD[1,2] = YKEY[1,2] THEN
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
                YHDR = "INVEST. LIST OF TODAYS ENTRIES WITH EXPANDED CRF INFO"
                IF YPRINTING THEN
                    YHDR = "RGP.TRANS.T24INV6 ":YHDR
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
                YHDR.GROUP = "CONTINGENT ENTRIES"
                YHDR1 = "TRANS.REFERENCE  ACCOUNT/CATEG CODE/CRF KEY   ASSET TYPE          LCY AMOUNT EXCH.RATE   CCY          FCY AMOUNT VAL.DAT T/C CUST/MD"
                YHDR2 = "===============  ==========================   ==========          ========== =========   ===          ========== ======= === ======="
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
        C$RPT.CUSTOMER.NO = YR.REC(18)
        C$RPT.ACCOUNT.NO = YR.REC(19)
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
    MATREAD YR.REC FROM F.FILE, YKEY ELSE MAT YR.REC = "" ; GOSUB 1000000    ;*R22 Manual Conversion - GOTO to GOSUB
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
            NEXTP = P+1; IF NEXTP = LASTP+1 THEN GOSUB 9190000   ;*R22 Manual Conversion - GOTO to GOSUB
        CASE COMI = C.E; NEXTP = LASTP
        CASE COMI = C.V OR COMI = C.W OR COMI = C.U
            PRINT S.COL132.OFF:
            CLEARSELECT; COMI = C.U; RETURN
        CASE COMI = "P"; NEXTP = 1
        CASE COMI[1,1] = "P" AND NUM(COMI[2,99]) = NUMERIC
            NEXTP = COMI[2,99]
            IF NEXTP = LASTP+1 THEN COMI = C.F; GOSUB 9190000    ;*R22 Manual Conversion - GOTO to GOSUB
        CASE 1
            E = ""; L = 22; CALL ERR; GOSUB 9100010  ;*R22 Manual Conversion - GOTO to GOSUB
    END CASE
*
    IF NEXTP < 1 THEN
        NEXTP = 1
    END ELSE
        IF NEXTP > LASTP THEN NEXTP = LASTP
    END
    IF NEXTP = P THEN GOSUB 9100000  ;*R22 Manual Conversion - GOTO to GOSUB
    P = NEXTP
*
    GOSUB 9200000
    FOR LL = L1ST TO 19
        X = YT.PAGE<P,LL>; IF X <> "" THEN PRINT @(0,LL):X:
    NEXT LL; GOSUB 9100000   ;*R22 Manual Conversion - GOTO to GOSUB
*
9190000:
    IF YEND THEN GOSUB 9100000 ELSE P = NEXTP    ;*R22 Manual Conversion - GOTO to GOSUB
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
