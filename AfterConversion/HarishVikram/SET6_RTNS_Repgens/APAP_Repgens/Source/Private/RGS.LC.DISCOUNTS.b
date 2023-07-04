* @ValidationCode : MjozODgwMjM3OTM6Q3AxMjUyOjE2ODg0NjYyMjgzNTc6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Jul 2023 15:53:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.Repgens
*-----------------------------------------------------------------------------
* <Rating>3239</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-07-2023      Harishvikram C   Manual R22 conversion      FM TO @FM, VM to @VM, SM to @SM
*-----------------------------------------------------------------------------------------------
SUBROUTINE RGS.LC.DISCOUNTS
REM "RGS.LC.DISCOUNTS",040129-3
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
    YF.VOC = ""
    OPEN "", "VOC" TO YF.VOC ELSE
        TEXT = "CANNOT OPEN VOC-FILE"
        CALL FATAL.ERROR ("RGS.LC.DISCOUNTS")
    END
*************************************************************************
    YT.SMS.COMP = ID.COMPANY
    YT.SMS.FILE = "DRAWINGS"
    YT.SMS.FILE<-1> = "LETTER.OF.CREDIT"
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
    DIM YR.REC(9)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.LC.DISCOUNTS"
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
        CALL FATAL.ERROR ("RGS.LC.DISCOUNTS")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "DRAWINGS"
    YT.SMS.FILE<-1> = "LETTER.OF.CREDIT"
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
    YR.VOC = "D"; YR.VOC<2> = 14
    YR.VOC<5> = "19R"
    YR.VOC<6> = 1
    WRITE YR.VOC TO YF.VOC, "FLD.":TNO
    YR.VOC = "D"; YR.VOC<2> = 16
    YR.VOC<5> = "19R"
    YR.VOC<6> = 1
    WRITE YR.VOC TO YF.VOC, "FLD2.":TNO
    CLEARSELECT
    EXECUTE "HUSH ON"
    EXECUTE 'SELECT ':FULL.FNAME:' WITH FLD.':TNO:' > "0.00" OR WITH FLD2.':TNO:' > "0.00"'
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
        YR.REC(9)  := @FM
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
    YKEY = "C"; MAT YR.REC = ""
    YM.TXN.REF = ID.NEW
    YR.REC(1) = YM.TXN.REF
    YM.DR.OLD.TXN.REF = FMT(ID.NEW,"12L"); YM.DR.OLD.TXN.REF = YM.DR.OLD.TXN.REF[1,12]
    YCOUNT.RPL = COUNT(YM.DR.OLD.TXN.REF,@VM)+1
    FOR YAV.RPL = 1 TO YCOUNT.RPL
        IF YM.DR.OLD.TXN.REF<1,YAV.RPL> <> "" THEN
            YCOMP = "LETTER.OF.CREDIT_105_":YM.DR.OLD.TXN.REF<1,YAV.RPL>
            YFORFIL = YF.LETTER.OF.CREDIT
            YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
            YM.DR.OLD.TXN.REF<1,YAV.RPL> = YFOR.FD
        END
    NEXT YAV.RPL
    YR.REC(2) = YM.DR.OLD.TXN.REF
    YM.DR.CCY = R.NEW(2)
    YR.REC(3) = YM.DR.CCY
    YM.DR.AMT = R.NEW(3)
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.DR.CCY, YDEC)
    IF YM.DR.AMT <> "" THEN
        YM.DR.AMT = TRIM(FMT(YM.DR.AMT,"19R":YDEC))
    END
    YR.REC(4) = YM.DR.AMT
    YM.PAYMENT.AMOUNT = R.NEW(20)
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.DR.CCY, YDEC)
    IF YM.PAYMENT.AMOUNT <> "" THEN
        YM.PAYMENT.AMOUNT = TRIM(FMT(YM.PAYMENT.AMOUNT,"19R":YDEC))
    END
    YR.REC(5) = YM.PAYMENT.AMOUNT
    YM.REIMBURSE.AMOUNT = R.NEW(21)
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.DR.CCY, YDEC)
    IF YM.REIMBURSE.AMOUNT <> "" THEN
        YM.REIMBURSE.AMOUNT = TRIM(FMT(YM.REIMBURSE.AMOUNT,"19R":YDEC))
    END
    YR.REC(6) = YM.REIMBURSE.AMOUNT
    YM.VALUE.DATE = R.NEW(11)
    YKEYFD = YM.VALUE.DATE
    YKEYFD = FMT(YM.VALUE.DATE,"11L")
    IF LEN(YKEYFD) > 11 THEN YKEYFD = YKEYFD[1,10]:"|"
    GOSUB 8000000
    YR.REC(7) = YM.VALUE.DATE
    YM.MATURITY.REVIEW = R.NEW(7)
    YKEYFD = YM.MATURITY.REVIEW
    YKEYFD = FMT(YM.MATURITY.REVIEW,"11L")
    IF LEN(YKEYFD) > 11 THEN YKEYFD = YKEYFD[1,10]:"|"
    GOSUB 8000000
    YR.REC(8) = YM.MATURITY.REVIEW
    YM.TOTAL.DIS = R.NEW(16)
    YM1.TOTAL.DIS = YM.TOTAL.DIS
    YM.TOTAL.DIS = R.NEW(14)
    IF NUM(YM1.TOTAL.DIS) = NUMERIC THEN IF NUM(YM.TOTAL.DIS) = NUMERIC THEN
        YM1.TOTAL.DIS = YM1.TOTAL.DIS + YM.TOTAL.DIS
        IF YM1.TOTAL.DIS = 0 THEN YM1.TOTAL.DIS = ""
    END
    YM.TOTAL.DIS = YM1.TOTAL.DIS
    YM.TOTAL.DISCOUNT = YM.TOTAL.DIS
    YDEC = "NO.OF.DECIMALS"; CALL UPD.CCY (YM.DR.CCY, YDEC)
    IF YM.TOTAL.DISCOUNT <> "" THEN
        YM.TOTAL.DISCOUNT = TRIM(FMT(YM.TOTAL.DISCOUNT,"19R":YDEC))
    END
    YR.REC(9) = YM.TOTAL.DISCOUNT
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
