<<<<<<< Updated upstream
* @ValidationCode : MjotMjAxMDUwMDU1MTpDcDEyNTI6MTY4ODUzNjg5NDA2MjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jul 2023 11:31:34
=======
* @ValidationCode : MjotMjAxMDUwMDU1MTpDcDEyNTI6MTY4NjgyMzg2NjAwNzpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Jun 2023 15:41:06
>>>>>>> Stashed changes
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
<<<<<<< Updated upstream
* @ValidationInfo : Strict flag       : true
=======
* @ValidationInfo : Strict flag       : N/A
>>>>>>> Stashed changes
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.Repgens
SUBROUTINE RGS.CO.COVER
REM "RGS.CO.COVER",230614-4
*************************************************************************
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 15-JUNE-2023      Harsha                R22 Manual Conversion - SELECT to SSELECT
*------------------------------------------------------------------------
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
    RG.S.CONCAT.IDS = "RG.S.CONCAT.IDS"
*************************************************************************
    YF.VOC = ""
    OPEN "", "VOC" TO YF.VOC ELSE
        TEXT = "CANNOT OPEN VOC-FILE"
        CALL FATAL.ERROR ("RGS.CO.COVER")
    END
*************************************************************************
    YT.SMS.COMP = ID.COMPANY
    YT.SMS.FILE = "COLLATERAL.RIGHT"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
    YT.SMS.FILE<-1> = "COLLATERAL.CODE"
    YT.SMS.FILE<-1> = "COLLATERAL"
    YT.SMS.FILE<-1> = "COLLATERAL.TYPE"
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
    DIM YR.REC(25)
    YFILE = "F":R.COMPANY(EB.COM.MNEMONIC):".RGS.CO.COVER"
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
        CALL FATAL.ERROR ("RGS.CO.COVER")
    END
*
    YCOM = ID.COMPANY
*
    YT.SMS = ""
    YT.SMS.FILE = "COLLATERAL.RIGHT"
    YT.SMS.FILE<-1> = "CUSTOMER"
    YT.SMS.FILE<-1> = "DEPT.ACCT.OFFICER"
    YT.SMS.FILE<-1> = "COLLATERAL.CODE"
    YT.SMS.FILE<-1> = "COLLATERAL"
    YT.SMS.FILE<-1> = "COLLATERAL.TYPE"
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
    YFILE = "F.CUSTOMER"; YF.CUSTOMER = ""
    CALL OPF (YFILE, YF.CUSTOMER)
    YFILE = "F.DEPT.ACCT.OFFICER"; YF.DEPT.ACCT.OFFICER = ""
    CALL OPF (YFILE, YF.DEPT.ACCT.OFFICER)
    YFILE = "F.COLLATERAL.CODE"; YF.COLLATERAL.CODE = ""
    CALL OPF (YFILE, YF.COLLATERAL.CODE)
    YFILE = "F.COLLATERAL"; YF.COLLATERAL = ""
    CALL OPF (YFILE, YF.COLLATERAL)
    YFILE = "F.COLLATERAL.TYPE"; YF.COLLATERAL.TYPE = ""
    CALL OPF (YFILE, YF.COLLATERAL.TYPE)
*************************************************************************
    YFILE = "COLLATERAL.RIGHT"
    FULL.FNAME = "F.COLLATERAL.RIGHT"; YF.COLLATERAL.RIGHT = ""
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
    CALL OPF (FULL.FNAME, YF.COLLATERAL.RIGHT)
    fldName = '' ; dataType = '' ; errMsg = ''
    CALL FIELD.NUMBERS.TO.NAMES('11',SS.REC,fldName,dataType,errMsg)
    fldName2 = '' ; dataType2 = '' ; errMsg2 = ''
    CALL FIELD.NUMBERS.TO.NAMES('11',SS.REC,fldName2,dataType2,errMsg2)
    fldName3 = '' ; dataType3 = '' ; errMsg3 = ''
    CALL FIELD.NUMBERS.TO.NAMES('19',SS.REC,fldName3,dataType3,errMsg3)
    CLEARSELECT
    YSEL.A = ""
    IF C$MULTI.BOOK AND COMP.FOUND THEN
        YSEL.A = " AND CO.CODE EQUAL ":ID.COMPANY
    END
    EXECUTE "HUSH ON"
    EXECUTE 'SSELECT ':FULL.FNAME:' WITH ':fldName:' >= "90" AND ':fldName2:' <= "100" AND ':fldName3:' = "CUR"':YSEL.A      ;*R22 Manual Conversion - SELECT to SSELECT
    EXECUTE "HUSH OFF"
    CALL EB.READLIST('', YID.LIST, '', '', '')
    LOOP
        REMOVE ID.NEW FROM YID.LIST SETTING YDELIM
    WHILE ID.NEW:YDELIM
        MATREAD R.NEW FROM YF.COLLATERAL.RIGHT, ID.NEW ELSE ID.NEW = "" ; MAT R.NEW = ""
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
        YR.REC(25)  := @FM
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
    YM.CUSTOMER.ID =  FIELD(ID.NEW,".",1)
    YM.DEPT.ACCT.OFFICER = YM.CUSTOMER.ID
    IF YM.DEPT.ACCT.OFFICER <> "" THEN
        YCOMP = "CUSTOMER_24_":YM.DEPT.ACCT.OFFICER
        YFORFIL = YF.CUSTOMER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.DEPT.ACCT.OFFICER = YFOR.FD
    END
    YKEYFD = YM.DEPT.ACCT.OFFICER

* check ID to see if it matches keys with contract no. in the format
* xxyydddnnnnn. if it does, extend the year (yy) component of the key
* to yyyy and use this as the id to the REPGEN work file. all the
* aforementioned processing is done in ENQ.BUILD.TXN and is part of
* Year 2000 compliance

    FULL.TXN.ID = ""
    CALL ENQ.BUILD.TXN(FULL.TXN.ID,YKEYFD)

    YKEYFD = FMT(YM.DEPT.ACCT.OFFICER,"6L")


    IF LEN(YKEYFD) > 6 THEN YKEYFD = YKEYFD[1,5]:"|"
    GOSUB 8000000
    YR.REC(1) = YM.DEPT.ACCT.OFFICER
    YM.AREA = YM.DEPT.ACCT.OFFICER
    IF YM.AREA <> "" THEN
        YCOMP = "DEPT.ACCT.OFFICER_1_":YM.AREA
        YFORFIL = YF.DEPT.ACCT.OFFICER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.AREA = YFOR.FD
    END
    YR.REC(2) = YM.AREA
    YM.NAME = YM.DEPT.ACCT.OFFICER
    IF YM.NAME <> "" THEN
        YCOMP = "DEPT.ACCT.OFFICER_2_":YM.NAME
        YFORFIL = YF.DEPT.ACCT.OFFICER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.NAME = YFOR.FD
    END
    YR.REC(3) = YM.NAME
    YM.DELIVERY.POINT = YM.DEPT.ACCT.OFFICER
    IF YM.DELIVERY.POINT <> "" THEN
        YCOMP = "DEPT.ACCT.OFFICER_3_":YM.DELIVERY.POINT
        YFORFIL = YF.DEPT.ACCT.OFFICER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.DELIVERY.POINT = YFOR.FD
    END
    YR.REC(4) = YM.DELIVERY.POINT
    YM.TELEPHONE.NO = YM.DEPT.ACCT.OFFICER
    IF YM.TELEPHONE.NO <> "" THEN
        YCOMP = "DEPT.ACCT.OFFICER_6_":YM.TELEPHONE.NO
        YFORFIL = YF.DEPT.ACCT.OFFICER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.TELEPHONE.NO = YFOR.FD
    END
    YR.REC(5) = YM.TELEPHONE.NO
    YM.CUSTOMER.NO = YM.CUSTOMER.ID
    YKEYFD = FMT(YM.CUSTOMER.NO,"R######")
    IF LEN(YKEYFD) > 6 THEN YKEYFD = YKEYFD[1,5]:"|"
    GOSUB 8000000
    YR.REC(6) = YM.CUSTOMER.NO
    YM.COLLATERAL.RIGHT.SEQ =  FIELD(ID.NEW,".",2)
    YKEYFD = FMT(YM.COLLATERAL.RIGHT.SEQ,"R##")
    IF LEN(YKEYFD) > 2 THEN YKEYFD = YKEYFD[1,1]:"|"
    GOSUB 8000000
    YR.REC(7) = YM.COLLATERAL.RIGHT.SEQ
    YM.SHORT.NAME = YM.CUSTOMER.ID
    IF YM.SHORT.NAME <> "" THEN
        YCOMP = "CUSTOMER_2_":YM.SHORT.NAME
        YFORFIL = YF.CUSTOMER
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.SHORT.NAME = YFOR.FD
    END
    YR.REC(8) = YM.SHORT.NAME
    YM.COLLATERAL.CODE = R.NEW(1)
    YR.REC(9) = YM.COLLATERAL.CODE
    YM.DESCRIPTION = YM.COLLATERAL.CODE
    IF YM.DESCRIPTION <> "" THEN
        YCOMP = "COLLATERAL.CODE_1_":YM.DESCRIPTION
        YFORFIL = YF.COLLATERAL.CODE
        YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
        YM.DESCRIPTION = YFOR.FD
    END
    YR.REC(10) = YM.DESCRIPTION
    YM.VALIDITY.DATE = R.NEW(12)
    YR.REC(11) = YM.VALIDITY.DATE
    YM.REVIEW.DATE = R.NEW(13)
    YR.REC(12) = YM.REVIEW.DATE
    YM.EXPIRY.DATE = R.NEW(14)
    YR.REC(13) = YM.EXPIRY.DATE
    YM.PERCENTAGE.COVER = R.NEW(11)
    YM1.PERCENTAGE.COVER = YM.PERCENTAGE.COVER
    YM.PERCENTAGE.COVER = "%"
    YM1.PERCENTAGE.COVER = YM1.PERCENTAGE.COVER : YM.PERCENTAGE.COVER
    YM.PERCENTAGE.COVER = YM1.PERCENTAGE.COVER
    YR.REC(14) = YM.PERCENTAGE.COVER
    YM.NOTES = R.NEW(16)
    YR.REC(15) = YM.NOTES
    YM.COLLATERAL.RIGHT.ID = ID.NEW
    YM.ARG1A = YM.COLLATERAL.RIGHT.ID
    YM18.GOSUB = YM.ARG1A
    YM.ARG2A = "RIGHT.COLLATERAL"
    YM19.GOSUB = YM.ARG2A
    YM.ARG3A = ""
    YM20.GOSUB = YM.ARG3A
    CALL @RG.S.CONCAT.IDS (YM18.GOSUB, YM19.GOSUB, YM20.GOSUB)
    YM.ARG1A = YM18.GOSUB
    YM.ARG2A = YM19.GOSUB
    YM.ARG3A = YM20.GOSUB
    YM.COLLATERAL.ID = YM.ARG3A
    YR.REC(16) = YM.COLLATERAL.ID
    YM.COLLATERAL.TYPE = YM.COLLATERAL.ID
    YCOUNT.RPL = COUNT(YM.COLLATERAL.TYPE,@VM)+1
    FOR YAV.RPL = 1 TO YCOUNT.RPL
        YCOUNT.AS.RPL = COUNT(YM.COLLATERAL.TYPE<1,YAV.RPL>,@SM)+1
        FOR YAS.RPL = 1 TO YCOUNT.AS.RPL
            IF YM.COLLATERAL.TYPE<1,YAV.RPL,YAS.RPL> <> "" THEN
                YCOMP = "COLLATERAL_1_":YM.COLLATERAL.TYPE<1,YAV.RPL,YAS.RPL>
                YFORFIL = YF.COLLATERAL
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.COLLATERAL.TYPE<1,YAV.RPL,YAS.RPL> = YFOR.FD
            END
        NEXT YAS.RPL
    NEXT YAV.RPL
    YR.REC(17) = YM.COLLATERAL.TYPE
    YM.DESCRIPTION2 = YM.COLLATERAL.TYPE
    YCOUNT.RPL = COUNT(YM.DESCRIPTION2,@VM)+1
    FOR YAV.RPL = 1 TO YCOUNT.RPL
        YCOUNT.AS.RPL = COUNT(YM.DESCRIPTION2<1,YAV.RPL>,@SM)+1
        FOR YAS.RPL = 1 TO YCOUNT.AS.RPL
            IF YM.DESCRIPTION2<1,YAV.RPL,YAS.RPL> <> "" THEN
                YCOMP = "COLLATERAL.TYPE_1_":YM.DESCRIPTION2<1,YAV.RPL,YAS.RPL>
                YFORFIL = YF.COLLATERAL.TYPE
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 1; GOSUB 9000000
                YM.DESCRIPTION2<1,YAV.RPL,YAS.RPL> = YFOR.FD
            END
        NEXT YAS.RPL
    NEXT YAV.RPL
    YR.REC(18) = YM.DESCRIPTION2
    YM.DESCRIPTION3 = YM.COLLATERAL.ID
    YCOUNT.RPL = COUNT(YM.DESCRIPTION3,@VM)+1
    FOR YAV.RPL = 1 TO YCOUNT.RPL
        YCOUNT.AS.RPL = COUNT(YM.DESCRIPTION3<1,YAV.RPL>,@SM)+1
        FOR YAS.RPL = 1 TO YCOUNT.AS.RPL
            IF YM.DESCRIPTION3<1,YAV.RPL,YAS.RPL> <> "" THEN
                YCOMP = "COLLATERAL_2_":YM.DESCRIPTION3<1,YAV.RPL,YAS.RPL>
                YFORFIL = YF.COLLATERAL
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.DESCRIPTION3<1,YAV.RPL,YAS.RPL> = YFOR.FD
            END
        NEXT YAS.RPL
    NEXT YAV.RPL
    YR.REC(19) = YM.DESCRIPTION3
    YM.APPLICATION.ID = YM.COLLATERAL.ID
    YCOUNT.RPL = COUNT(YM.APPLICATION.ID,@VM)+1
    FOR YAV.RPL = 1 TO YCOUNT.RPL
        YCOUNT.AS.RPL = COUNT(YM.APPLICATION.ID<1,YAV.RPL>,@SM)+1
        FOR YAS.RPL = 1 TO YCOUNT.AS.RPL
            IF YM.APPLICATION.ID<1,YAV.RPL,YAS.RPL> <> "" THEN
                YCOMP = "COLLATERAL_4_":YM.APPLICATION.ID<1,YAV.RPL,YAS.RPL>
                YFORFIL = YF.COLLATERAL
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.APPLICATION.ID<1,YAV.RPL,YAS.RPL> = YFOR.FD
            END
        NEXT YAS.RPL
    NEXT YAV.RPL
    YR.REC(20) = YM.APPLICATION.ID
    YM.CURRENCY = YM.COLLATERAL.ID
    YCOUNT.RPL = COUNT(YM.CURRENCY,@VM)+1
    FOR YAV.RPL = 1 TO YCOUNT.RPL
        YCOUNT.AS.RPL = COUNT(YM.CURRENCY<1,YAV.RPL>,@SM)+1
        FOR YAS.RPL = 1 TO YCOUNT.AS.RPL
            IF YM.CURRENCY<1,YAV.RPL,YAS.RPL> <> "" THEN
                YCOMP = "COLLATERAL_7_":YM.CURRENCY<1,YAV.RPL,YAS.RPL>
                YFORFIL = YF.COLLATERAL
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.CURRENCY<1,YAV.RPL,YAS.RPL> = YFOR.FD
            END
        NEXT YAS.RPL
    NEXT YAV.RPL
    YR.REC(21) = YM.CURRENCY
    YM.NOMINAL.VALUE = YM.COLLATERAL.ID
    YCOUNT.RPL = COUNT(YM.NOMINAL.VALUE,@VM)+1
    FOR YAV.RPL = 1 TO YCOUNT.RPL
        YCOUNT.AS.RPL = COUNT(YM.NOMINAL.VALUE<1,YAV.RPL>,@SM)+1
        FOR YAS.RPL = 1 TO YCOUNT.AS.RPL
            IF YM.NOMINAL.VALUE<1,YAV.RPL,YAS.RPL> <> "" THEN
                YCOMP = "COLLATERAL_9_":YM.NOMINAL.VALUE<1,YAV.RPL,YAS.RPL>
                YFORFIL = YF.COLLATERAL
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.NOMINAL.VALUE<1,YAV.RPL,YAS.RPL> = YFOR.FD
            END
        NEXT YAS.RPL
    NEXT YAV.RPL
    YR.REC(22) = YM.NOMINAL.VALUE
    YM.EXECUTION.VALUE = YM.COLLATERAL.ID
    YCOUNT.RPL = COUNT(YM.EXECUTION.VALUE,@VM)+1
    FOR YAV.RPL = 1 TO YCOUNT.RPL
        YCOUNT.AS.RPL = COUNT(YM.EXECUTION.VALUE<1,YAV.RPL>,@SM)+1
        FOR YAS.RPL = 1 TO YCOUNT.AS.RPL
            IF YM.EXECUTION.VALUE<1,YAV.RPL,YAS.RPL> <> "" THEN
                YCOMP = "COLLATERAL_11_":YM.EXECUTION.VALUE<1,YAV.RPL,YAS.RPL>
                YFORFIL = YF.COLLATERAL
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.EXECUTION.VALUE<1,YAV.RPL,YAS.RPL> = YFOR.FD
            END
        NEXT YAS.RPL
    NEXT YAV.RPL
    YR.REC(23) = YM.EXECUTION.VALUE
    YM.THIRD.PARTY.VALUE = YM.COLLATERAL.ID
    YCOUNT.RPL = COUNT(YM.THIRD.PARTY.VALUE,@VM)+1
    FOR YAV.RPL = 1 TO YCOUNT.RPL
        YCOUNT.AS.RPL = COUNT(YM.THIRD.PARTY.VALUE<1,YAV.RPL>,@SM)+1
        FOR YAS.RPL = 1 TO YCOUNT.AS.RPL
            IF YM.THIRD.PARTY.VALUE<1,YAV.RPL,YAS.RPL> <> "" THEN
                YCOMP = "COLLATERAL_12_":YM.THIRD.PARTY.VALUE<1,YAV.RPL,YAS.RPL>
                YFORFIL = YF.COLLATERAL
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.THIRD.PARTY.VALUE<1,YAV.RPL,YAS.RPL> = YFOR.FD
            END
        NEXT YAS.RPL
    NEXT YAV.RPL
    YR.REC(24) = YM.THIRD.PARTY.VALUE
    YM.STATUS = YM.COLLATERAL.ID
    YCOUNT.RPL = COUNT(YM.STATUS,@VM)+1
    FOR YAV.RPL = 1 TO YCOUNT.RPL
        YCOUNT.AS.RPL = COUNT(YM.STATUS<1,YAV.RPL>,@SM)+1
        FOR YAS.RPL = 1 TO YCOUNT.AS.RPL
            IF YM.STATUS<1,YAV.RPL,YAS.RPL> <> "" THEN
                YCOMP = "COLLATERAL_34_":YM.STATUS<1,YAV.RPL,YAS.RPL>
                YFORFIL = YF.COLLATERAL
                YPART.S = ""; YFD.LEN = ""; YHANDLE.LNGG = 0; GOSUB 9000000
                YM.STATUS<1,YAV.RPL,YAS.RPL> = YFOR.FD
            END
        NEXT YAS.RPL
    NEXT YAV.RPL
    YR.REC(25) = YM.STATUS
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
