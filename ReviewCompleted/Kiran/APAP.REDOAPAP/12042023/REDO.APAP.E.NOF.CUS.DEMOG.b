* @ValidationCode : MjotMjAxNDA3ODM0ODpDcDEyNTI6MTY4MTMwMDg2OTM4MDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 17:31:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.E.NOF.CUS.DEMOG(DATA.RETURN)
*-----------------------------------------------------------------------------
*   R o u t i n e   D e s c r i p t i o n :
*   ---------------------------------------
*
*   This is a nofile routine to report the demographic changes that had
*   happened in the ACCOUNT & CUSTOMER files
*
*   Below are the selection criteria for the enquiry
*   (1) Date (Range)
*   (2) Agency (Entity)
*   (3) Account Type (Category)
*
*-----------------------------------------------------------------------------
*   M o d i f i c a t i o n  H i s t o r y :
*   ----------------------------------------
*   Done By        : Indumathi Saravanan, Thesys Tech, sindumathi@thesys.co.in
*   Date of Coding : 24 Nov 2010
*
*   Modified By    : Rajesh L
*   Date Modified  : 03 Dec 2010
*                    Coding standards - Avoided inner loops
*
*   Modified By    : Renugadevi B
*   Date Modified  : 20 Dec 2010
*                    Changes done as per the requirement
*
*   Modified By    : Arundev KR
*   Date Modified  : 20 Jun 2013
*                    PACS00293038 - Performance Tuning
*                    SELECT on a local concat table REDO.APAP.ACCOUNT.ACT instead of ACCOUNT records
*                    REDO.APAP.ACCOUNT.ACT contains the account records Ids updated daily by a cob job picking records from core table ACCOUNT.ACT
*
*   Modified By    : Arundev KR
*   Date Modified  : 02 JuL 2013
*                    PACS00293038 - Code Review Issues
*
*   Date        Author             Modification Description
* 12-Feb-2014   V.P.Ashokkumar     PACS00309822 - Report is rewritten based on BRD
* 23-Feb-2015   V.P.Ashokkumar     PACS00309822 - Changed the override format
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM tO @FM , VM to @VM , SM to @SM , F.READ to CACHE.READ , ++ to += , -- to -=
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------





*-----------------------------------------------------------------------------
*   Insert files that are used within the routine

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CATEGORY
*   $INSERT I_F.CUSTOMER
    $INSERT I_F.LATAM.CARD.CUSTOMER
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.REDO.APAP.ACCOUNT.ACT  ;*PACS00293038
    $INSERT I_F.RELATION
    $INSERT I_F.LOCAL.REF.TABLE
    $INSERT I_F.LOCAL.TABLE
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.USER
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.REDO.H.REPORTS.PARAM

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB SELECT.PROCESS
    GOSUB MAIN.SELECT
RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------------------
INITIALIZE:
*---------------------------------------------------------------------------------------------------------------------------------------------------------
* File Variable Initialization <STARTS>
* File Names: ACCOUNT/ACCOUNT$HIS,ACCOUNT,CUSTOMER,CATEGORY,LATAM.CARD.CUSTOMER

    Y.APP.LIST='CUSTOMER':@FM:'ACCOUNT'
    Y.FLD.LIST='L.CU.CIDENT':@VM:'L.CU.TIPO.CL':@VM:'L.CU.RES.SECTOR':@VM:'L.CU.URB.ENS.RE':@VM:'L.CU.TEL.TYPE':@VM:'L.CU.TEL.AREA':@VM:'L.CU.TEL.NO':@FM:'L.AC.STATUS2':@VM:'L.AC.NOTIFY.1':@VM:'L.AC.NOTIFY.2'
    CALL MULTI.GET.LOC.REF(Y.APP.LIST,Y.FLD.LIST,Y.POS.LIST)
    Y.CED.POS=Y.POS.LIST<1,1>
    Y.CLT.POS=Y.POS.LIST<1,2>
    Y.SEC.POS=Y.POS.LIST<1,3>
    Y.URB.POS=Y.POS.LIST<1,4>
    Y.TTY.POS=Y.POS.LIST<1,5>
    Y.TAR.POS=Y.POS.LIST<1,6>
    Y.TEL.POS=Y.POS.LIST<1,7>
    Y.AC.ST2.POS=Y.POS.LIST<2,1>
    Y.AC.NT1.POS=Y.POS.LIST<2,2>
    Y.AC.NT2.POS=Y.POS.LIST<2,3>

    FN.ACCOUNT                = 'F.ACCOUNT'
    F.ACCOUNT                 = ''
    FN.ACCOUNT.HIS            = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HIS             = ''
    FN.CUSTOMER               = 'F.CUSTOMER'
    F.CUSTOMER                = ''
    FN.CUSTOMER.HIS           = 'F.CUSTOMER$HIS'
    F.CUSTOMER.HIS            = ''
    FN.CATEGORY               = 'F.CATEGORY'
    F.CATEGORY                = ''
    FN.CARD.ISSUE.ACCOUNT     = 'F.CARD.ISSUE.ACCOUNT'
    F.CARD.ISSUE.ACCOUNT      = ''
    FN.LATAM.CARD.CUSTOMER    = 'F.LATAM.CARD.CUSTOMER'
    F.LATAM.CARD.CUSTOMER     = ''
    FN.REDO.CUS.DEM.CH.DATE='F.REDO.CUS.DEM.CH.DATE'; F.REDO.CUS.DEM.CH.DATE=''
    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'; F.CUSTOMER.ACCOUNT =''
    FN.RELATION = 'F.RELATION'; F.RELATION = ''
    FN.LOCAL.REF.T = 'F.LOCAL.REF.TABLE'; F.LOCAL.REF.T = ''
    FN.LOCAL.TABLE = 'F.LOCAL.TABLE'; F.LOCAL.TABLE = ''
    FN.REDO.APAP.ACCOUNT.ACT = 'F.REDO.APAP.ACCOUNT.ACT'; F.REDO.APAP.ACCOUNT.ACT = ''
    FN.EB.LOOKUP = 'F.EB.LOOKUP'; F.EB.LOOKUP = ''
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"; F.REDO.H.REPORTS.PARAM  = ""
    FN.ACCOUNT.CLASS = 'F.ACCOUNT.CLASS'; F.ACCOUNT.CLASS = ''
    DATA.RETURN = '' ; Y.READ.ERR = '' ; Y.SEL.VALUE = '' ; Y.DATE.RG = '' ; Y.AGENCY = ''
    Y.CATEGORY = '' ; Y.CARD.NO   = '' ; FLAG.VAR = ''; Y.SEL.CAT = ''; VAR.USER.LANG = ''
RETURN

OPEN.FILES:
***********
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.CUSTOMER.HIS,F.CUSTOMER.HIS)
    CALL OPF(FN.CATEGORY,F.CATEGORY)
    CALL OPF(FN.REDO.CUS.DEM.CH.DATE,F.REDO.CUS.DEM.CH.DATE)
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    CALL OPF(FN.LATAM.CARD.CUSTOMER,F.LATAM.CARD.CUSTOMER)
    CALL OPF(FN.RELATION,F.RELATION)
    CALL OPF(FN.LOCAL.REF.T,LOCAL.REF.T)
    CALL OPF(FN.LOCAL.TABLE,F.LOCAL.TABLE)
    CALL OPF(FN.REDO.APAP.ACCOUNT.ACT,F.REDO.APAP.ACCOUNT.ACT)
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)
RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT.PROCESS:
*----------------------------------------------------------------------------------------------------------------------------------------------------------
* Fetching the selection criteria values here

    LOCATE "DATE" IN D.FIELDS<1> SETTING FIELD1.POS THEN
        Y.DATE.RG = D.RANGE.AND.VALUE<FIELD1.POS>
    END
    LOCATE "ACCOUNT.TYPE" IN D.FIELDS<1> SETTING FIELD2.POS THEN
        Y.SEL.CAT = D.RANGE.AND.VALUE<FIELD2.POS>
        CHANGE @SM TO @FM IN Y.SEL.CAT
        CHANGE @VM TO @FM IN Y.SEL.CAT
    END ELSE
        GOSUB GET.CATEG.LIST
    END

    Y.TXNTYE.VAL.ARR = ''; Y.FIELD.NME.ARR = ''; Y.FIELD.VAL.ARR = ''; TXNCF.POS = 0
    TXNLF.POS = 0; Y.TXNLF.VAL.ARR = ''; Y.TXNCF.VAL.ARR = ''

    Y.REPORT.PARAM.ID = "REDO.REPORT84"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.REPORT.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
    END

    LOCATE "CORE.FIELD" IN Y.FIELD.NME.ARR<1,1> SETTING TXNCF.POS THEN
        Y.TXNCF.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNCF.POS>
        Y.TXNCF.VAL.ARR = CHANGE(Y.TXNCF.VAL.ARR,@SM,@VM)
    END

    LOCATE "LOCAL.FIELD" IN Y.FIELD.NME.ARR<1,1> SETTING TXNLF.POS THEN
        Y.TXNLF.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNLF.POS>
        Y.TXNLF.VAL.ARR = CHANGE(Y.TXNLF.VAL.ARR,@SM,@VM)
    END

    VAR.USER.LANG = R.USER<EB.USE.LANGUAGE>
    Y.FROM.DATE = ''; Y.FROM.DATE = FIELD(Y.DATE.RG,@SM,1,1)
    Y.TO.DATE   = ''; Y.TO.DATE   = FIELD(Y.DATE.RG,@SM,2,1)
    IF NOT(NUM(Y.FROM.DATE)) OR LEN(Y.FROM.DATE) NE '8' OR NOT(NUM(Y.TO.DATE)) OR LEN(Y.TO.DATE) NE '8' THEN
        ENQ.ERROR = 'EB-REDO.DATE.RANGE'
    END ELSE
        IF Y.FROM.DATE[5,2] GT '12' OR Y.TO.DATE[5,2] GT '12' OR Y.FROM.DATE[7,2] GT '31' OR Y.TO.DATE[7,2] GT '31' OR Y.TO.DATE GT TODAY OR Y.FROM.DATE GT TODAY OR Y.FROM.DATE GT Y.TO.DATE THEN
            ENQ.ERROR = 'EB-REDO.DATE.RANGE'
        END
    END
RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------------
DATE.CHECK:
*----------------------------------------------------------------------------------------------------------------------------------------------------------
    Y.F.DATE = Y.FROM.DATE[3,6]:"0000"
    Y.T.DATE = Y.TO.DATE[3,6]:"2359"
RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------------
MAIN.SELECT:
*----------------------------------------------------------------------------------------------------------------------------------------------------------
    SEL.CMD = '' ; SEL.LIST = '' ; NOR = '' ; RC = ''
    SEL.CMD = 'SSELECT ':FN.REDO.APAP.ACCOUNT.ACT:' WITH @ID GE ':Y.FROM.DATE:' AND LE ':Y.TO.DATE
    IF NOT(Y.TO.DATE) THEN
        SEL.CMD = 'SELECT ':FN.REDO.APAP.ACCOUNT.ACT:' WITH @ID EQ ':Y.TO.DATE
    END
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,RC)
    IF NOT(SEL.LIST) THEN
        RETURN
    END
******
    ACCOUNT.LIST = ''
    LOOP
        REMOVE REDO.APAP.ACCOUNT.ACT.ID FROM SEL.LIST SETTING ID.POS
    WHILE REDO.APAP.ACCOUNT.ACT.ID:ID.POS
        R.REDO.APAP.ACCOUNT.ACT = ''; APAP.ERR = ''
        CALL F.READ(FN.REDO.APAP.ACCOUNT.ACT,REDO.APAP.ACCOUNT.ACT.ID,R.REDO.APAP.ACCOUNT.ACT,F.REDO.APAP.ACCOUNT.ACT,APAP.ERR)
        IF R.REDO.APAP.ACCOUNT.ACT THEN
            ACCOUNT.NOS = R.REDO.APAP.ACCOUNT.ACT<REDO.ACC.ACT.ACCT.DATE.CURR>
            CHANGE @VM TO @FM IN ACCOUNT.NOS
            ACCOUNT.LIST<-1> = ACCOUNT.NOS
        END
    REPEAT

    GOSUB ACCT.SORTING.VAL
    GOSUB GET.ACCT.STAND.SEL
    GOSUB SUB.SELECT.DET
RETURN

SUB.SELECT.DET:
***************
    YGRP.CNT = DCOUNT(YACCT.NEW,@FM)
    ACCOUNT.ARR = ''; YN.CNT = 0
    LOOP
        REMOVE YAC.ID FROM YACCT.NEW SETTING ID.POS
    WHILE YAC.ID:ID.POS
        YN.CNT += 1 ;*R22 AUTO CODE CONVERSION
        Y.AC.ID = FIELD(YAC.ID,'*','1')
        YT.AC.ID = FIELD(Y.AC.ID,';','1')
        GOSUB READ.ACCOUNT.HIST
        YCATEG = ''
        YCATEG = R.ACCOUNT<AC.CATEGORY>
        IF Y.SEL.CAT THEN
            LOCATE YCATEG IN Y.SEL.CAT<1> SETTING YCAT.POSN THEN
            END ELSE
                CONTINUE
            END
        END

        R.ACCOUNT.NEW = R.ACCOUNT
        GOSUB GET.DEFAULT.VAL
        YAC.ID = YACCT.OLD<YN.CNT>
        Y.AC.ID = FIELD(YAC.ID,'*','1')
        GOSUB READ.ACCOUNT.HIST
        R.ACCOUNT.OLD = R.ACCOUNT
        YFNME.CNT = 0; YREC.CNT = 0
        GOSUB SUB.SELECT.ACCT
    REPEAT
RETURN

SUB.SELECT.ACCT:
***************
    FD.POS = 0; FIELD.VALU = ''; TEMP.USR.FIELD.VALUE = USR.FIELD.VALUE; TEMP.USR.FIELD.NME = USR.FIELD.NME
    LOOP
        REMOVE FIELD.VALU FROM TEMP.USR.FIELD.VALUE SETTING FD.POS
    WHILE FIELD.VALU:FD.POS
        YFNME.CNT += 1
        YVAL.USR.FIELD.NME = ''; CURR.ACCT.OLD = ''; CURR.ACCT.NEW = ''
        CURR.ACCT.OLD = R.ACCOUNT.OLD<FIELD.VALU>
        CURR.ACCT.NEW = R.ACCOUNT.NEW<FIELD.VALU>
        YVAL.USR.FIELD.NME = USR.FIELD.NME<YFNME.CNT>
        GOSUB VAL.CHECK.VM.MARK

        IF CURR.ACCT.OLD EQ CURR.ACCT.NEW OR YFLG.VAL EQ 1 THEN
            CONTINUE
        END
        GOSUB SING.OVERRIDE
        YREC.CNT += 1
        IF YREC.CNT EQ 1 THEN
            DATA.RETURN<-1> = Y.DATE.TIME:'#':Y.CH.TYPE:'#':YT.AC.ID:'#':Y.CARD.NO:'#':Y.CUST.VAL:'#':Y.RET.ID:'#':Y.AC.OFFICER:'#':Y.COM.CODE:'#':YVAL.USR.FIELD.NME:'#':CURR.ACCT.OLD:'#':CURR.ACCT.NEW:'#':Y.INPUTTER:'#':Y.AUTHORISER:'#':Y.OVERRIDE
        END ELSE
            DATA.RETURN<-1> = '########':YVAL.USR.FIELD.NME:'#':CURR.ACCT.OLD:'#':CURR.ACCT.NEW:'###'
        END
        YOVERRIDE = ''; Y.OVERRIDE = ''
    REPEAT
RETURN

SING.OVERRIDE:
*************
    IF YVAL.USR.FIELD.NME EQ 'OVERRIDE' THEN
        YOVERRIDE = ''; Y.OVERRIDE = ''
        YOVERRIDE = CURR.ACCT.OLD
        GOSUB GET.OVERRIDE
        CURR.ACCT.OLD = Y.OVERRIDE
        YOVERRIDE = ''; Y.OVERRIDE = ''
        YOVERRIDE = CURR.ACCT.NEW
        GOSUB GET.OVERRIDE
        CURR.ACCT.NEW = Y.OVERRIDE
    END
RETURN

ACCT.SORTING.VAL:
*****************
    YACCT.OLD = ''; YACCT.NEW = ''; YCNT = 0
    SEL.LIST = SORT(ACCOUNT.LIST)
    TOT.ACCT.CNT = DCOUNT(SEL.LIST,@FM) + 1
    LOOP
        REMOVE ACC.ID FROM SEL.LIST SETTING AC.POSN
    UNTIL YCNT EQ TOT.ACCT.CNT
        Y.AC.ID = FIELD(ACC.ID,'*','1')
        Y.AC.CURR = FIELD(ACC.ID,'*','3')
        YCNT += 1
        IF YCNT EQ 1 THEN
            YACCT.OLD = Y.AC.ID:';':Y.AC.CURR
            Y.AC.OLD.ID = Y.AC.ID
            Y.AC.CURR.OLD = Y.AC.CURR
            CONTINUE
        END

        IF Y.AC.ID NE Y.AC.OLD.ID THEN
            YAC.CURR.OLD = Y.AC.CURR.OLD + 1
            IF TOT.ACCT.CNT NE YCNT THEN
                YACCT.OLD<-1> = Y.AC.ID:';':Y.AC.CURR
            END
            YACCT.NEW<-1> = Y.AC.OLD.ID:';':YAC.CURR.OLD
        END

        Y.AC.OLD.ID = Y.AC.ID
        Y.AC.CURR.OLD = Y.AC.CURR
    REPEAT
RETURN

VAL.CHECK.VM.MARK:
******************
    YFLG.VAL = 0; YGROUP.CNT = ''; ACCT.OLD.VM.CNT = 0
    YFIN.CNT = 0; ACCT.NEW.VM.CNT = 0

    IF YVAL.USR.FIELD.NME EQ 'LOCAL.REF' THEN
        GOSUB GET.SS.LOCAL.REF
        ACCT.OLD.VM.CNT = DCOUNT(CURR.ACCT.OLD,@VM)
        ACCT.NEW.VM.CNT = DCOUNT(CURR.ACCT.NEW,@VM)
    END ELSE
        CHANGE @VM TO @FM IN CURR.ACCT.NEW
        CHANGE @VM TO @FM IN CURR.ACCT.OLD
        IF YVAL.USR.FIELD.NME NE 'OVERRIDE' THEN
            CHANGE @SM TO @FM IN CURR.ACCT.NEW
            CHANGE @SM TO @FM IN CURR.ACCT.OLD
        END
        ACCT.OLD.VM.CNT = DCOUNT(CURR.ACCT.OLD,@FM)
        ACCT.NEW.VM.CNT = DCOUNT(CURR.ACCT.NEW,@FM)
        IF ACCT.OLD.VM.CNT LE 1 AND ACCT.NEW.VM.CNT LE 1 THEN
            RETURN
        END
    END

    IF ACCT.OLD.VM.CNT GT ACCT.NEW.VM.CNT THEN
        YGROUP.CNT = CURR.ACCT.OLD
        YFIN.CNT = ACCT.OLD.VM.CNT
    END ELSE
        YGROUP.CNT = CURR.ACCT.NEW
        YFIN.CNT = ACCT.NEW.VM.CNT
    END
    GOSUB VAL.CHECK.VM.MARK.1
RETURN

VAL.CHECK.VM.MARK.1:
********************
    YT.FINCNT = ''; YT.FINCNT = YFIN.CNT; YTVM.CNT = 0
    YFLG.VAL = 1; YVM.CNT = 0; YVIRTUAL.TABLE = ''
    FOR Y.LOOP = 1 TO YFIN.CNT
        YVM.CNT += 1
        ACCT.NEW.VM.VALUE = CURR.ACCT.NEW<YVM.CNT>
        VM.OLD.VAL = CURR.ACCT.OLD<YVM.CNT>
        IF YVAL.USR.FIELD.NME EQ 'OVERRIDE' THEN
            VM.OLD.VAL = ''
            VM.OLD.VAL = CURR.ACCT.OLD<YT.FINCNT>
            YT.FINCNT -= 1 ;*R22 AUTO CODE CONVERSION
        END
        Y.VAL.USR.FIELD.NME = YVAL.USR.FIELD.NME
        GOSUB USER.FIELD.LOC
        IF YLOC.FLAG EQ 2 THEN
            CONTINUE
        END

        GOSUB OVERRIDE.GET.VAL
        IF VM.OLD.VAL EQ ACCT.NEW.VM.VALUE THEN
            CONTINUE
        END
        GOSUB VIRTUAL.VM.VAL
        YREC.CNT += 1
        IF YREC.CNT EQ 1 THEN
            DATA.RETURN<-1> = Y.DATE.TIME:'#':Y.CH.TYPE:'#':YT.AC.ID:'#':Y.CARD.NO:'#':Y.CUST.VAL:'#':Y.RET.ID:'#':Y.AC.OFFICER:'#':Y.COM.CODE:'#':Y.VAL.USR.FIELD.NME:'#':VM.OLD.VAL:'#':ACCT.NEW.VM.VALUE:'#':Y.INPUTTER:'#':Y.AUTHORISER:'#':Y.OVERRIDE
        END ELSE
            DATA.RETURN<-1> = '########':Y.VAL.USR.FIELD.NME:'#':VM.OLD.VAL:'#':ACCT.NEW.VM.VALUE:'###'
        END
        YOVERRIDE = ''; Y.OVERRIDE = ''
    NEXT Y.LOOP
RETURN

USER.FIELD.LOC:
***************
    YLOC.FLAG = 0
    IF YVAL.USR.FIELD.NME EQ 'LOCAL.REF' THEN
        ACCT.NEW.VM.VALUE = ''; VM.OLD.VAL = ''; TABLE.NO = ''
        ACCT.NEW.SM.CNT = ''; ACCT.OLD.SM.CNT = ''
        ACCT.NEW.VM.VALUE = CURR.ACCT.NEW<1,YVM.CNT>
        VM.OLD.VAL = CURR.ACCT.OLD<1,YVM.CNT>
        ACCT.NEW.SM.CNT = DCOUNT(ACCT.NEW.VM.VALUE,@SM)
        ACCT.OLD.SM.CNT = DCOUNT(VM.OLD.VAL,@SM)
        TABLE.NO = R.LOCAL.REF.T<EB.LRT.LOCAL.TABLE.NO,YVM.CNT>
        GOSUB GET.LOCAL.TABLE

        LOCATE Y.VAL.USR.FIELD.NME IN Y.TXNLF.VAL.ARR<1,1> SETTING TXNYLF.POS THEN
            YLOC.FLAG = 2
            RETURN
        END

        IF ACCT.OLD.SM.CNT GT 1 OR ACCT.NEW.SM.CNT GT 1 THEN
            GOSUB PROCESS.VAL.SM
            YLOC.FLAG = 2
        END
    END
RETURN

OVERRIDE.GET.VAL:
*****************
    IF YVAL.USR.FIELD.NME EQ 'OVERRIDE' THEN
        YOVERRIDE = ''; Y.OVERRIDE = ''
        YOVERRIDE = VM.OLD.VAL
        GOSUB GET.OVERRIDE
        VM.OLD.VAL = Y.OVERRIDE
        YOVERRIDE = ''; Y.OVERRIDE = ''
        YOVERRIDE = ACCT.NEW.VM.VALUE
        GOSUB GET.OVERRIDE
        ACCT.NEW.VM.VALUE = Y.OVERRIDE
    END
RETURN

PROCESS.VAL.SM:
***************
    IF ACCT.OLD.SM.CNT GT ACCT.NEW.SM.CNT THEN
        YGROUP.CNT1 = VM.OLD.VAL
    END ELSE
        YGROUP.CNT1 = ACCT.NEW.VM.VALUE
    END
    YVM.CNT1 = 0
    LOOP
        REMOVE V.OLD.VAL1 FROM YGROUP.CNT1 SETTING VM.POSN1
    WHILE V.OLD.VAL1:VM.POSN1
        YVM.CNT1 += 1
        SM.OLD.VAL = ''; ACCT.NEW.SM.VALUE = ''
        ACCT.NEW.SM.VALUE = ACCT.NEW.VM.VALUE<1,1,YVM.CNT1>
        SM.OLD.VAL = VM.OLD.VAL<1,1,YVM.CNT1>

        IF SM.OLD.VAL EQ ACCT.NEW.SM.VALUE THEN
            CONTINUE
        END
        GOSUB VIRTUAL.SM.VAL
        YREC.CNT += 1
        IF YREC.CNT EQ 1 THEN
            DATA.RETURN<-1> = Y.DATE.TIME:'#':Y.CH.TYPE:'#':YT.AC.ID:'#':Y.CARD.NO:'#':Y.CUST.VAL:'#':Y.RET.ID:'#':Y.AC.OFFICER:'#':Y.COM.CODE:'#':Y.VAL.USR.FIELD.NME:'#':SM.OLD.VAL:'#':ACCT.NEW.SM.VALUE:'#':Y.INPUTTER:'#':Y.AUTHORISER:'#':Y.OVERRIDE
        END ELSE
            DATA.RETURN<-1> = '########':Y.VAL.USR.FIELD.NME:'#':SM.OLD.VAL:'#':ACCT.NEW.SM.VALUE:'###'
        END
    REPEAT
RETURN

VIRTUAL.SM.VAL:
***************
    IF YVIRTUAL.TABLE AND SM.OLD.VAL THEN
        LOOK.ID = Y.VAL.USR.FIELD.NME:"*":SM.OLD.VAL
        GOSUB GET.EB.LOOKUP
        IF YEB.DESCP THEN
            SM.OLD.VAL = YEB.DESCP
        END
        LOOK.ID = ''
    END

    IF YVIRTUAL.TABLE AND ACCT.NEW.SM.VALUE THEN
        LOOK.ID = Y.VAL.USR.FIELD.NME:"*":ACCT.NEW.SM.VALUE
        GOSUB GET.EB.LOOKUP
        IF YEB.DESCP THEN
            ACCT.NEW.SM.VALUE = YEB.DESCP
        END
        LOOK.ID = ''
    END
RETURN

VIRTUAL.VM.VAL:
****************
    IF YVIRTUAL.TABLE AND VM.OLD.VAL THEN
        LOOK.ID = Y.VAL.USR.FIELD.NME:"*":VM.OLD.VAL
        GOSUB GET.EB.LOOKUP
        IF YEB.DESCP THEN
            VM.OLD.VAL = YEB.DESCP
        END
        LOOK.ID = ''
    END

    IF YVIRTUAL.TABLE AND ACCT.NEW.VM.VALUE THEN
        LOOK.ID = Y.VAL.USR.FIELD.NME:"*":ACCT.NEW.VM.VALUE
        GOSUB GET.EB.LOOKUP
        IF YEB.DESCP THEN
            ACCT.NEW.VM.VALUE = YEB.DESCP
        END
        LOOK.ID = ''
    END
RETURN

GET.SS.LOCAL.REF:
*****************
    LRT.ERR = ''; R.LOCAL.REF.T = ''
    CALL CACHE.READ(FN.LOCAL.REF.T, "ACCOUNT", R.LOCAL.REF.T, LRT.ERR)
RETURN

GET.LOCAL.TABLE:
****************
    ERR.LT = ''; R.LOCAL.TABLE = ''; Y.VAL.USR.FIELD.NME = ''
    YCHAR.TPE = ''; YVIRTUAL.TABLE = ''
    CALL CACHE.READ(FN.LOCAL.TABLE, TABLE.NO, R.LOCAL.TABLE, ERR.LT)
    Y.VAL.USR.FIELD.NME = R.LOCAL.TABLE<EB.LTA.SHORT.NAME,1>
    YCHAR.TPE = R.LOCAL.TABLE<EB.LTA.CHAR.TYPE>
    YVIRTUAL.TABLE = R.LOCAL.TABLE<EB.LTA.VIRTUAL.TABLE>
RETURN

GET.EB.LOOKUP:
**************
    ERR.LOOKUP = ''; R.LOOKUP = ''; YEB.DESCP = ''
    CALL F.READ(FN.EB.LOOKUP,LOOK.ID,R.LOOKUP,F.LOOKUP,ERR.LOOKUP)
    YEB.DESCP = R.LOOKUP<EB.LU.DESCRIPTION,VAR.USER.LANG>
    IF NOT(YEB.DESCP) THEN
        YEB.DESCP = R.LOOKUP<EB.LU.DESCRIPTION,1>
    END
RETURN

GET.ACCT.STAND.SEL:
*******************
    YGRP.CNT = 0; USR.FIELD.VALUE = ''; USR.FIELD.NME = ''
    CALL GET.STANDARD.SELECTION.DETS("ACCOUNT",R.ACCOUNT.SS)
    USR.SYS.TYPE = R.ACCOUNT.SS<SSL.SYS.TYPE>
    LOOP
        REMOVE FIELD.TYP FROM USR.SYS.TYPE SETTING FD.POSN
    WHILE FIELD.TYP:FD.POSN
        YGRP.CNT += 1
        USR.VAL.PROG = ''; USR.FIELD.NAME = ''
        USR.FIELD.NAME = R.ACCOUNT.SS<SSL.SYS.FIELD.NAME,YGRP.CNT>
        USR.VAL.PROG = R.ACCOUNT.SS<SSL.SYS.VAL.PROG,YGRP.CNT>
        IF FIELD.TYP NE 'D' THEN
            CONTINUE
        END
        LOCATE USR.FIELD.NAME IN Y.TXNCF.VAL.ARR<1,1> SETTING TXNYCF.POS THEN
            CONTINUE
        END
        IF USR.FIELD.NAME EQ 'OVERRIDE' THEN
            USR.FIELD.NME<-1> = R.ACCOUNT.SS<SSL.SYS.FIELD.NAME,YGRP.CNT>
            USR.FIELD.VALUE<-1> = R.ACCOUNT.SS<SSL.SYS.FIELD.NO,YGRP.CNT>
            CONTINUE
        END
        FINDSTR 'EXTERN' IN USR.VAL.PROG<1,1> SETTING FM.POS,VM.POS,SM.POS THEN
            CONTINUE
        END
        FINDSTR 'NOINPUT' IN USR.VAL.PROG<1,1> SETTING FM.POS1,VM.POS1,SM.POS1 THEN
            CONTINUE
        END
        USR.FIELD.NME<-1> = R.ACCOUNT.SS<SSL.SYS.FIELD.NAME,YGRP.CNT>
        USR.FIELD.VALUE<-1> = R.ACCOUNT.SS<SSL.SYS.FIELD.NO,YGRP.CNT>
    REPEAT
RETURN

READ.ACCOUNT.HIST:
******************
    R.ACCOUNT = ''; Y.READ.ERR = ''
    CALL F.READ(FN.ACCOUNT.HIS,Y.AC.ID,R.ACCOUNT,F.ACCOUNT.HIS,Y.READ.ERR)
    IF NOT(R.ACCOUNT) THEN
        Y.AC.NID = FIELD(Y.AC.ID,';','1')
        Y.AC.ERR = ''
        CALL F.READ(FN.ACCOUNT,Y.AC.NID,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
    END
RETURN

GET.DEFAULT.VAL:
****************
    Y.AC.CATEG.NEW = ''; Y.CH.TYPE = ''; Y.CUST.NO = ''; Y.COM.CODE = ''; Y.INPUTTER = ''; YACCT.TILE = ''
    Y.AUTHORISER = ''; YOVERRIDE = ''; Y.DATE.TIME = ''; Y.JH.ACCT.NEW = ''; Y.AC.OFFICER = ''; OVER.CNT = ''
    Y.OVERRIDE = ''
    Y.AC.CATEG.NEW = R.ACCOUNT.NEW<AC.CATEGORY>
    CALL CACHE.READ(FN.CATEGORY, Y.AC.CATEG.NEW, R.CATEGORY, CATEG.ERR)
    Y.CH.TYPE      = R.CATEGORY<EB.CAT.DESCRIPTION><1,1>
    YACCT.TILE     = R.ACCOUNT.NEW<AC.ACCOUNT.TITLE.1>
    Y.CUST.NO      = R.ACCOUNT.NEW<AC.CUSTOMER>
    Y.COM.CODE     = R.ACCOUNT.NEW<AC.CO.CODE>
    Y.INPUTTER     = R.ACCOUNT.NEW<AC.INPUTTER>
    Y.AUTHORISER   = R.ACCOUNT.NEW<AC.AUTHORISER>
    YOVERRIDE     = R.ACCOUNT.NEW<AC.OVERRIDE,1>
    Y.DATE.TIME    = R.ACCOUNT.NEW<AC.DATE.TIME>
    Y.JH.ACCT.NEW  = R.ACCOUNT.NEW<AC.JOINT.HOLDER>
    Y.AC.OFFICER   = R.ACCOUNT.NEW<AC.ACCOUNT.OFFICER>
    GOSUB GET.OVERRIDE

    IF Y.DATE.TIME THEN
        DATE.VAL = Y.DATE.TIME[1,6]
        TIME.VAL = Y.DATE.TIME[7,5]
        Y.IN.TIME = 20:DATE.VAL
        CALL EB.DATE.FORMAT.DISPLAY(Y.IN.TIME,Y.OUT.TIME,'','')
        Y.DATE.TIME = Y.OUT.TIME:" ":TIME.VAL[1,2]:':':TIME.VAL[2]
    END
    Y.INPUTTER=FIELD(Y.INPUTTER,'_',2,1)
    IF NUM(Y.INPUTTER[1,1]) THEN
        Y.INPUTTER=FIELD(Y.INPUTTER,'__',2,1)
    END
    Y.AUTHORISER=FIELD(Y.AUTHORISER,'_',2,1)
    IF NUM(Y.INPUTTER[1,1]) THEN
        Y.AUTHORISER=FIELD(Y.AUTHORISER,'__',2,1)
    END
    CALL F.READ(FN.LATAM.CARD.CUSTOMER,Y.CUST.NO,R.LATAM.CARD.CUSTOMER,F.LATAM.CARD.CUSTOMER,CARD.ERR)
    Y.CARD.NO = R.LATAM.CARD.CUSTOMER<APAP.DC.CARD.NO,1>

    GOSUB GET.RELATION.DETAILS
RETURN

GET.OVERRIDE:
*************
    Y.OVERRIDE = ''
    IF YOVERRIDE THEN
        YOVERRIDE = FIELD(YOVERRIDE,@SM,1)
        CHANGE @VM TO @FM IN YOVERRIDE
        OVER.CNT = DCOUNT(YOVERRIDE,@FM)
        Y.OVERRIDE = YOVERRIDE<OVER.CNT>
        Y.OVERRIDE = FIELDS(Y.OVERRIDE,'}',2,99)
        CHANGE '{' TO ' ' IN Y.OVERRIDE
        CHANGE '}' TO ' ' IN Y.OVERRIDE
        CHANGE '& ' TO '' IN Y.OVERRIDE
        CHANGE '~' TO '' IN Y.OVERRIDE
        CHANGE '\' TO '*' IN Y.OVERRIDE
        CHANGE @SM TO '' IN Y.OVERRIDE
    END
RETURN

GET.CATEG.LIST:
***************
    FINAL.CATEG.LIST = ''; Y.SEL.CAT = ''
    SEL.CMD = "SELECT F.CATEGORY WITH @ID GE 1000 AND LE 1999"
    CALL EB.READLIST(SEL.CMD,SEL.LIST," ",NO.OF.RECS,SEL.ERR)

    Y.ACC.CLASS.ID = 'SAVINGS'
    CALL CACHE.READ(FN.ACCOUNT.CLASS, Y.ACC.CLASS.ID, R.ACCT.CLASS, ACCT.CLASS.ERR) ;*R22 AUTO CODE CONVERSION
    Y.SAVINGS.CATEG = R.ACCT.CLASS<AC.CLS.CATEGORY>
    CATEGORY.LIST = SEL.LIST:@FM:Y.SAVINGS.CATEG
    LOOP
        REMOVE CATEGORY.ID FROM CATEGORY.LIST SETTING CATEG.POS
    WHILE CATEGORY.ID:CATEG.POS
        IF CATEGORY.ID GE 6013 AND CATEGORY.ID LE 6020 ELSE
            Y.SEL.CAT<-1> = CATEGORY.ID
        END
    REPEAT
    CHANGE @VM TO @FM IN Y.SEL.CAT
RETURN
*-----------------------------------------------------------------------------
GET.RELATION.DETAILS:
*********************
    Y.CUS.NAMES = ''; Y.CUSID = ''; Y.CUST.VAL = ''; Y.RET.ID = ''
    Y.RELATION.COUNT = DCOUNT(R.ACCOUNT.NEW<AC.RELATION.CODE>,@VM)
    Y.COUNT = 1
    CUSTOMER.ID = Y.CUST.NO
    GOSUB READ.CUSTOMER
    GOSUB GET.CUS.NAMES
    MAIN.NAMES = Y.CUS.NAME
    CUSTOMER.ID = ''; Y.CUS.NAME = ''
    LOOP
    WHILE Y.COUNT LE Y.RELATION.COUNT
        Y.REL.DESC = ''; Y.CUS.NAME = ''
        RELATION.ID = R.ACCOUNT.NEW<AC.RELATION.CODE,Y.COUNT>
        IF RELATION.ID GE 500 AND RELATION.ID LE 529 THEN
            GOSUB GET.VALUES
        END
        Y.COUNT += 1
        Y.CUS.NAMES<1,-1> = Y.CUS.NAME
        Y.CUSID<1,-1> = CUSTOMER.ID
        CHANGE @FM TO ' ' IN Y.CUS.NAMES
        CHANGE @FM TO ' ' IN Y.CUSID
    REPEAT
    IF Y.CUS.NAMES THEN
        Y.CUST.VAL = CHANGE(Y.CUS.NAMES, @VM, '; ')
        Y.RET.ID = CHANGE(Y.CUSID, @VM, '; ')
        Y.CUST.VAL = YACCT.TILE:';':Y.CUST.VAL
        Y.RET.ID = Y.CUST.NO:';':Y.RET.ID
    END ELSE
        Y.CUST.VAL = YACCT.TILE
        Y.RET.ID = Y.CUST.NO
    END
RETURN

***********
GET.VALUES:
***********
    GOSUB READ.RELATION
    Y.REL.DESC  = R.RELATION<EB.REL.DESCRIPTION>
    CUSTOMER.ID = R.ACCOUNT.NEW<AC.JOINT.HOLDER,Y.COUNT>
    GOSUB READ.CUSTOMER
    GOSUB GET.CUS.NAMES
RETURN

GET.CUS.NAMES:
**************
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLT.POS> EQ 'PERSONA FISICA' OR R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLT.POS> EQ 'CLIENTE MENOR' THEN
        Y.CUS.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLT.POS> EQ 'PERSONA JURIDICA' THEN
        Y.CUS.NAME = R.CUSTOMER<EB.CUS.NAME.1,VAR.USER.LANG>:' ':R.CUSTOMER<EB.CUS.NAME.2,VAR.USER.LANG>
    END
RETURN

**************
READ.CUSTOMER:
**************
    R.CUSTOMER  = ''; CUSTOMER.ER = ''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ER)
RETURN
**************
READ.RELATION:
**************
    R.RELATION  = ''; RELATION.ER = ''
    CALL F.READ(FN.RELATION,RELATION.ID,R.RELATION,F.RELATION,RELATION.ER)
RETURN
END
