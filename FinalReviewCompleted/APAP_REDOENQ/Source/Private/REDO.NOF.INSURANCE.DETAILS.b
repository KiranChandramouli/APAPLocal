<<<<<<< Updated upstream
<<<<<<< Updated upstream
* @ValidationCode : MjoxNjI4MjU5MzUwOkNwMTI1MjoxNjkwMjY1MjE3Mjg1OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:36:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
=======
=======
>>>>>>> Stashed changes
* @ValidationCode : MjotNzAwNDUwNzg1OkNwMTI1MjoxNjg1OTQ5Njg4MTkzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jun 2023 12:51:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
<<<<<<< Updated upstream
<<<<<<< Updated upstream
* @ValidationInfo : Compiler Version  : R22_SP5.0
=======
* @ValidationInfo : Compiler Version  : R21_AMR.0
>>>>>>> Stashed changes
=======
* @ValidationInfo : Compiler Version  : R21_AMR.0
>>>>>>> Stashed changes
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.INSURANCE.DETAILS(Y.FIN.ARR)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.NOF.INSURANCE.DETAILS
* ODR NUMBER    : ODR-2010-03-0174
*----------------------------------------------------------------------------------------------------
* Description   : This is No-file Enquiry routine. It will fetch the field details required for enquiry
*
* In parameter  :
* out parameter : Y.FIN.ARR
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 30-11-2010      MARIMUTHU s    ODR-2010-03-0174    Initial Creation
* 23-05-2023     Conversion Tool        R22 Auto Conversion - FM TO @FM AND VM TO @VM AND SM TO @SM AND VAR1+VAR2 TO + VAR1
* 23-05-2023      ANIL KUMAR B          R22 Manual Conversion - AA.CUS.OWNER changed to AA.CUS.CUSTOMER and AA.CUS.PRIMARY.OWNER changed to AA.CUS.CUSTOMER.

*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_F.CUSTOMER
    $INSERT I_F.COLLATERAL
    $INSERT I_F.AA.ACCOUNT.DETAILS
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    $USING APAP.TAM
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PROGRAM.END
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.REDO.ISSUE.CLAIMS = 'F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS = ''
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

    FN.REDO.ISSUE.CLAIMS = 'F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS = ''
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)

    FN.AA.ARRANGEMENT.DATED.XREF = 'F.AA.ARRANGEMENT.DATED.XREF'
    F.AA.ARRANGEMENT.DATED.XREF = ''
    CALL OPF(FN.AA.ARRANGEMENT.DATED.XREF,F.AA.ARRANGEMENT.DATED.XREF)

    FN.AA.ARR.ACCOUNT = 'F.AA.ARR.ACCOUNT'
    F.AA.ARR.ACCOUNT = ''
    CALL OPF(FN.AA.ARR.ACCOUNT,F.AA.ARR.ACCOUNT)

    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLATERAL = ''
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    FLG.1 = 'SET'
    GOSUB GET.SELECTION.FIELDS
    GOSUB SELECT.ARR.IDS

RETURN
*-----------------------------------------------------------------------------
GET.SELECTION.FIELDS:
*-----------------------------------------------------------------------------
    LOCATE "POL.INTIAL.DATE" IN D.FIELDS SETTING POSITION.ONE THEN
        POL.INTIAL.DATE   = D.RANGE.AND.VALUE<POSITION.ONE>
        FLG.1 = 1
    END

    LOCATE "POL.TYPE" IN D.FIELDS SETTING POSITION.TWO THEN
        POL.TYPE         = D.RANGE.AND.VALUE<POSITION.TWO>
    END ELSE
        ENQ.ERROR = 'POLICY.TYPE Should be mandatory'
        GOSUB PROGRAM.END
    END

    LOCATE "POL.CLASS" IN D.FIELDS SETTING POSITION.THREE THEN
        Y.POL.CLASS = D.RANGE.AND.VALUE<POSITION.THREE>
        IF FLG.1 EQ 1 THEN
            FLG.1 = 2
        END ELSE
            FLG.1 = 3
        END
    END

    LOCATE "CLAIM.STATUS" IN D.FIELDS SETTING POSITION.FOUR THEN
        CLAIM.STATUS     = D.RANGE.AND.VALUE<POSITION.FOUR>
        CHANGE @SM TO ' ' IN CLAIM.STATUS
        CHANGE '"' TO '' IN CLAIM.STATUS
        CHANGE "'" TO '' IN CLAIM.STATUS
        BEGIN CASE
            CASE FLG.1 EQ 1
                FLG.1 = 4     ;* -------> claim status and initial date
            CASE FLG.1 EQ 2
                FLG.1 = 5     ;* ------> Policy class, claim status and initial date
            CASE FLG.1 EQ 3
                FLG.1 = 6     ;* -----> Policy class and claim status
        END CASE

    END

RETURN
*-----------------------------------------------------------------------------
SELECT.ARR.IDS:
*-----------------------------------------------------------------------------
    GOSUB GET.MULTI.LOC.FIELDS

    SEL.CMD = 'SELECT ':FN.AA.ARRANGEMENT:' WITH ARR.STATUS NE UNAUTH'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,ERR.AA)
    BEGIN CASE
        CASE FLG.1 EQ 1 OR FLG.1 EQ 2
            GOSUB PROCESS.INITIAL.DATE.ALONE

        CASE FLG.1 EQ 3
            GOSUB PROCESS.CLASS.NONE

        CASE FLG.1 EQ 4 OR FLG.1 EQ 5
            GOSUB PROCESS.INITIAL.CLAIM.CLAS

        CASE FLG.1 EQ 6
            GOSUB PROCESS.CLAIM.ST

        CASE 1
            GOSUB PROCESS.CLASS.NONE

    END CASE

RETURN
*-----------------------------------------------------------------------------
PROCESS.CLASS.NONE:
*-----------------------------------------------------------------------------
    LOOP
        REMOVE Y.ARR.ID FROM SEL.LIST SETTING POS
    WHILE Y.ARR.ID:POS
        FLAG.CHAR = ''
        GOSUB GET.PROP.ARRAY
        GOSUB PROCESS.CHARGE.PROP
        IF FLAG.CHAR EQ 'PROCESS' THEN
            GOSUB GET.AGENCY
            GOSUB GET.POL.STATUS
            CHG.RTE = CHANGE(CHG.RTE,@VM,'')
            GOSUB FORM.ARRAY
        END
    REPEAT

RETURN
*-----------------------------------------------------------------------------
PROCESS.CLAIM.ST:
*-----------------------------------------------------------------------------
    LOOP
        REMOVE Y.ARR.ID FROM SEL.LIST SETTING POS
    WHILE Y.ARR.ID:POS
        FLAG.CHAR = ''
        GOSUB GET.PROP.ARRAY
        IF Y.POL.STATUS EQ CLAIM.STATUS THEN
            GOSUB PROCESS.CHARGE.PROP
            IF FLAG.CHAR EQ 'PROCESS' THEN
                GOSUB GET.AGENCY
                GOSUB GET.POL.STATUS
                CHG.RTE = CHANGE(CHG.RTE,@VM,'')
                GOSUB FORM.ARRAY
            END
        END
    REPEAT

RETURN
*-----------------------------------------------------------------------------
PROCESS.INITIAL.CLAIM.CLAS:
*-----------------------------------------------------------------------------
    LOOP
        REMOVE Y.ARR.ID FROM SEL.LIST SETTING POS
    WHILE Y.ARR.ID:POS
        FLAG.CHAR = ''
        GOSUB GET.PROP.ARRAY
        IF Y.INITIAL.DATE EQ POL.INTIAL.DATE AND Y.POL.STATUS EQ CLAIM.STATUS THEN
            GOSUB PROCESS.CHARGE.PROP
            IF FLAG.CHAR EQ 'PROCESS' THEN
                GOSUB GET.AGENCY
                GOSUB GET.POL.STATUS
                CHG.RTE = CHANGE(CHG.RTE,@VM,'')
                GOSUB FORM.ARRAY
            END
        END
    REPEAT

RETURN
*-----------------------------------------------------------------------------
PROCESS.INITIAL.DATE.ALONE:
*-----------------------------------------------------------------------------
    LOOP
        REMOVE Y.ARR.ID FROM SEL.LIST SETTING POS
    WHILE Y.ARR.ID:POS
        FLAG.CHAR = ''
        GOSUB GET.PROP.ARRAY
        IF Y.INITIAL.DATE EQ POL.INTIAL.DATE THEN
            GOSUB PROCESS.CHARGE.PROP
            IF FLAG.CHAR EQ 'PROCESS' THEN
                GOSUB GET.AGENCY
                GOSUB GET.POL.STATUS
                GOSUB FORM.ARRAY
            END
        END
    REPEAT

RETURN
*-----------------------------------------------------------------------------
GET.PROP.ARRAY:
*-----------------------------------------------------------------------------
    Y.CLIENT.NAME = ''; Y.COLL = ''; Y.COL.CODE = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARR.ID,'CUSTOMER','','',RET.PROP.CUS,RET.COND.CUS,CUS.AA.ERR)
    RET.COND.CUS = RAISE(RET.COND.CUS)
    Y.INITIAL.DATE = RET.COND.CUS<AA.CUS.LOCAL.REF,POS.DTE>
    Y.EXP.DATE = RET.COND.CUS<AA.CUS.LOCAL.REF,POS.EX.DTE>
    Y.IN.COMP = RET.COND.CUS<AA.CUS.LOCAL.REF,POS.IN.COMP>
*Y.CUSTOMER = RET.COND.CUS<AA.CUS.PRIMARY.OWNER>
    Y.CUSTOMER = RET.COND.CUS<AA.CUS.CUSTOMER>   ;*R22 Manual Conversion
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,CUS.ERRRR)
    Y.CLIENT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>

*Y.OWNER = RET.COND.CUS<AA.CUS.OWNER>
    Y.OWNER = RET.COND.CUS<AA.CUS.CUSTOMER>  ;*R22 Manual Conversion
    Y.OWNER = CHANGE(Y.OWNER,@VM,@FM)

    CNT.OWNER = DCOUNT(Y.OWNER,@FM)
    IF CNT.OWNER EQ 1 THEN
        IF Y.CUSTOMER NE Y.OWNER THEN
            CALL F.READ(FN.CUSTOMER,Y.OWNER,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
            Y.CLIENT.NAME := @VM:R.CUSTOMER<EB.CUS.SHORT.NAME>
        END
    END ELSE
        CNT.ON.CK = 0
        LOOP
        WHILE CNT.OWNER GT 0 DO
            CNT.ON.CK += 1
            Y.CK.OWNER = Y.OWNER<CNT.ON.CK>
            IF Y.CK.OWNER NE Y.CUSTOMER THEN
                CALL F.READ(FN.CUSTOMER,Y.CK.OWNER,R.CUS,F.CUSTOMER,CUS.ERR)
                Y.CLIENT.NAME := @VM:R.CUS<EB.CUS.SHORT.NAME>
            END
            CNT.OWNER -= 1
        REPEAT
    END

    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARR.ID,'ACCOUNT','','',RET.PROP.AC,RET.COND.AC,AC.AA.ERR)
    RET.COND.AC = RAISE(RET.COND.AC)
    Y.POL.STATUS = RET.COND.AC<AA.AC.LOCAL.REF,POS.STATUS>
    Y.AGENCY = RET.COND.AC<AA.AC.LOCAL.REF,POS.AGENCY>
    Y.ALT.ID = RET.COND.AC<AA.AC.ALT.ID>
    Y.ACT.REF = RET.COND.AC<AA.AC.ACCOUNT.REFERENCE>

    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARR.ID,'TERM.AMOUNT','','',RET.PROP.TM,RET.COND.TM,ERR.ATR)
    RET.COND.TM = RAISE(RET.COND.TM)
    Y.TERM = RET.COND.TM<AA.AMT.TERM>
* Y.COL.CODE = RET.COND.TM<AA.AMT.LOCAL.REF,POS.COL.CODE>

    Y.COLL = RET.COND.TM<AA.AMT.LOCAL.REF,POS.COL>
    Y.COLL  = CHANGE(Y.COLL,@SM,@VM)
    Y.COL.CHANGE = CHANGE(Y.COLL,@VM,@FM)
    Y.COL.CNT = DCOUNT(Y.COL.CHANGE,@FM)
    FLG.COL.CNT = ''
    LOOP
    WHILE Y.COL.CNT GT 0 DO
        FLG.COL.CNT += 1
        Y.CLL.COL = Y.COL.CHANGE<FLG.COL.CNT>
        CALL F.READ(FN.COLLATERAL,Y.CLL.COL,R.COLLATERAL,F.COLLATERAL,COLL.ERR)
        Y.COLLL.CODE = R.COLLATERAL<COLL.COLLATERAL.CODE>
        IF Y.COL.CODE EQ '' THEN
            Y.COL.CODE = Y.COLLL.CODE
        END ELSE
            Y.COL.CODE := @VM:Y.COLLL.CODE
        END
        Y.COL.CNT -= 1
    REPEAT
    Y.COL.DES = RET.COND.TM<AA.AMT.LOCAL.REF,POS.COL.DES>
    Y.COL.DES = CHANGE(Y.COL.DES,@SM,@VM)
    Y.INS.AMT = RET.COND.TM<AA.AMT.LOCAL.REF,POS.INS.AMT>
    Y.INS.AMT = CHANGE(Y.INS.AMT,@SM,@VM)

    CALL F.READ(FN.AA.ARRANGEMENT,Y.ARR.ID,R.AA.ARR,F.AA.ARRANGEMENT,AA.ARR.ERR)
    Y.PRODUCT = R.AA.ARR<AA.ARR.PRODUCT>
    Y.CURRENCY = R.AA.ARR<AA.ARR.CURRENCY>

RETURN
*-----------------------------------------------------------------------------
PROCESS.CHARGE.PROP:
*-----------------------------------------------------------------------------
    OUT.PROPERTY = ''
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*   CALL REDO.GET.PROPERTY.NAME(Y.ARR.ID,'CHARGE',R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)
    APAP.TAM.redoGetPropertyName(Y.ARR.ID,'CHARGE',R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)   ;*R22 Manual Code Converison
=======
    CALL REDO.GET.PROPERTY.NAME(Y.ARR.ID,'CHARGE',R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)
>>>>>>> Stashed changes
=======
    CALL REDO.GET.PROPERTY.NAME(Y.ARR.ID,'CHARGE',R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)
>>>>>>> Stashed changes
    CNT.CR.PROP = DCOUNT(OUT.PROPERTY,@FM)
    FLG.CR = 0
    LOOP
    WHILE CNT.CR.PROP GT 0 DO
        FLG.CR += 1
        Y.PROP.CR = OUT.PROPERTY<FLG.CR>
        CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARR.ID,'CHARGE',Y.PROP.CR,'',RET.PROP,RET.COND.CR,CR.ERR)
        IF RET.COND.CR THEN
            RET.COND.CR = RAISE(RET.COND.CR)
            Y.INS.POL.TYPE = RET.COND.CR<AA.CHG.LOCAL.REF,POS.POL.TYPE>
            Y.INS.POL.TYPE = RAISE(Y.INS.POL.TYPE)
            Y.CLASS.POLICY = RET.COND.CR<AA.CHG.LOCAL.REF,POS.CLS.POL>
            Y.CLASS.POLICY = RAISE(Y.CLASS.POLICY)

            IF Y.INS.POL.TYPE THEN
                CK.PRP = 0
                CNT.VM = DCOUNT(Y.INS.POL.TYPE,@VM)
                IF FLG.1 EQ 2 OR FLG.1 EQ 3 OR FLG.1 EQ 5 OR FLG.1 EQ 6 THEN
                    GOSUB PROCESS.POL.TYPE.CLAS
                END ELSE
                    GOSUB PROCESS.POL.TYPE
                END
                IF FLAG EQ 'SET' THEN
                    GOSUB GET.INSUR.DATE
                    IF FIRST.PAY.DATE EQ '' THEN
                        FIRST.PAY.DATE = Y.FIRST.DUE.DATE
                    END ELSE
                        FIRST.PAY.DATE := @VM:Y.FIRST.DUE.DATE
                    END
                    Y.FIRST.DUE.DATE = ''
                    FLAG = ''
                    FLAG.CHAR = 'PROCESS'
                END
            END
        END

        CNT.CR.PROP -= 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------
PROCESS.POL.TYPE:
*-----------------------------------------------------------------------------
    FLG.P.TY = 0
    LOOP
    WHILE CNT.VM GT 0 DO
        FLG.P.TY += 1
        Y.POL.TYPE = Y.INS.POL.TYPE<1,FLG.P.TY>
        Y.CLASS.PICY = Y.CLASS.POLICY<1,FLG.P.TY>

        IF Y.POL.TYPE EQ POL.TYPE THEN
            CK.PRP += 1
            GOSUB FORM.CHARGE.VALUES
            IF Y.DUP.ARR.ID NE Y.ARR.ID THEN
                CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,AA.ACC.ERR)
                SEL.LIST.BILL = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
                SEL.LIST.BILL = CHANGE(SEL.LIST.BILL,@VM,@FM)
                SEL.LIST.BILL = CHANGE(SEL.LIST.BILL,@SM,@FM)
                DUP.SEL.LIST.BILL = SEL.LIST.BILL

                DUE.PROP.AMTS = ''; DUE.DATES = ''; TOT.PAYMENT = ''; DUE.TYPES = ''; DUE.METHODS = ''; DUE.TYPE.AMTS = ''; DUE.PROPS = ''; DUE.OUTS = ''
                CALL AA.SCHEDULE.PROJECTOR(Y.ARR.ID,"", "","", TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS, DUE.TYPE.AMTS,DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
                Y.DUP.ARR.ID = Y.ARR.ID
            END
            IF CK.PRP EQ 1 THEN
                GOSUB PROCESS.BILLS.CR
                Y.COMMIS.AMT += Y.OS.PROP.AMT
                DUP.COMMIS.AMT = Y.OS.PROP.AMT
                Y.OS.PROP.AMT = 0
            END
            IF Y.CLASS.PICY EQ 'ED' AND CK.PRP EQ 1 THEN
                Y.ENDORSE.COMMIS += DUP.COMMIS.AMT
            END
            FLAG = 'SET'
        END
        CNT.VM =- 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------
PROCESS.POL.TYPE.CLAS:
*-----------------------------------------------------------------------------
    FLG.P.TY = 0
    LOOP
    WHILE CNT.VM GT 0 DO
        FLG.P.TY += 1
        Y.POL.TYPE = Y.INS.POL.TYPE<1,FLG.P.TY>
        Y.CLASS.PICY = Y.CLASS.POLICY<1,FLG.P.TY>

        IF Y.POL.TYPE EQ POL.TYPE AND Y.CLASS.PICY EQ Y.POL.CLASS THEN
            CK.PRP += 1
            GOSUB FORM.CHARGE.VALUES
            IF Y.DUP.ARR.ID NE Y.ARR.ID THEN
                CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,AA.ACC.ERR)
                SEL.LIST.BILL = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
                SEL.LIST.BILL = CHANGE(SEL.LIST.BILL,@VM,@FM)
                SEL.LIST.BILL = CHANGE(SEL.LIST.BILL,@SM,@FM)
                DUP.SEL.LIST.BILL = SEL.LIST.BILL

                DUE.PROP.AMTS = ''; DUE.DATES = ''; TOT.PAYMENT = ''; DUE.TYPES = ''; DUE.METHODS = ''; DUE.TYPE.AMTS = ''; DUE.PROPS = ''; DUE.OUTS = ''
                CALL AA.SCHEDULE.PROJECTOR(Y.ARR.ID,"", "","", TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS, DUE.TYPE.AMTS,DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
                Y.DUP.ARR.ID = Y.ARR.ID
            END
            IF CK.PRP EQ 1 THEN
                GOSUB PROCESS.BILLS.CR
                Y.COMMIS.AMT += Y.OS.PROP.AMT
                DUP.COMMIS.AMT = Y.OS.PROP.AMT
                Y.OS.PROP.AMT = 0
            END
            IF Y.CLASS.PICY EQ 'ED' AND CK.PRP EQ 1 THEN
                Y.ENDORSE.COMMIS += DUP.COMMIS.AMT
            END
            FLAG = 'SET'
        END
        CNT.VM =- 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------
FORM.CHARGE.VALUES:
*-----------------------------------------------------------------------------
    IF Y.CLAS.PY EQ '' THEN
        Y.CLAS.PY = Y.CLASS.POLICY<1,FLG.P.TY>
    END ELSE
        Y.CLAS.PY := @VM:Y.CLASS.POLICY<1,FLG.P.TY>
    END
    IF Y.POL.TY EQ '' THEN
        Y.POL.TY = Y.INS.POL.TYPE<1,FLG.P.TY>
    END ELSE
        Y.POL.TY := @VM:Y.INS.POL.TYPE<1,FLG.P.TY>
    END
    Y.POL.NUMBER = RET.COND.CR<AA.CHG.LOCAL.REF,POS.POL.NUM>
    Y.POL.NUMBER = RAISE(Y.POL.NUMBER)

    IF Y.POL.NUM EQ '' THEN
        Y.POL.NUM = Y.POL.NUMBER<1,FLG.P.TY>
    END ELSE
        Y.POL.NUM := @VM:Y.POL.NUMBER<1,FLG.P.TY>
    END

    Y.MON.POL.AMT = RET.COND.CR<AA.CHG.LOCAL.REF,POS.POL.AMT>
    Y.MON.POL.AMT = RAISE(Y.MON.POL.AMT)
    IF Y.MON.AMT EQ '' THEN
        Y.MON.AMT = Y.MON.POL.AMT
    END ELSE
        Y.MON.AMT := @VM:Y.MON.POL.AMT
    END

    Y.MANGMNT.TYPE = RET.COND.CR<AA.CHG.LOCAL.REF,POS.MNGMNT.TY>
    IF Y.MNG.TYPE EQ '' THEN
        Y.MNG.TYPE = Y.MANGMNT.TYPE
    END ELSE
        Y.MNG.TYPE := @VM:Y.MANGMNT.TYPE
    END

    Y.EXTRA.AMT = RET.COND.CR<AA.CHG.LOCAL.REF,POS.EX.AMT>
    IF Y.EX.AMT EQ '' THEN
        Y.EX.AMT = Y.EXTRA.AMT
    END ELSE
        Y.EX.AMT := @VM:Y.EXTRA.AMT
    END

    Y.CHARGE.RATE = RET.COND.CR<AA.CHG.CHARGE.RATE>
    IF CHG.RTE EQ '' THEN
        CHG.RTE = Y.CHARGE.RATE
    END ELSE
        CHG.RTE := @VM:Y.CHARGE.RATE
    END

RETURN
*-----------------------------------------------------------------------------
PROCESS.BILLS.CR:
*-----------------------------------------------------------------------------
    SEL.CMD.LIST.BILL = DUP.SEL.LIST.BILL
    LOOP
        REMOVE Y.BILL.ID FROM SEL.CMD.LIST.BILL SETTING BILL.POS
    WHILE Y.BILL.ID:BILL.POS
        CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.BILL.DETAILS,F.AA.BILL.DETAILS,BIL.A.ERR)
        Y.PROPERTIES = R.BILL.DETAILS<AA.BD.PROPERTY>
        Y.PROPERTIES = CHANGE(Y.PROPERTIES,@VM,@FM)
        LOCATE Y.PROP.CR IN Y.PROPERTIES SETTING POS.PR THEN
            Y.OS.PROP.AMT = Y.OS.PROP.AMT + R.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT,POS.PR>
        END

    REPEAT

RETURN
*-----------------------------------------------------------------------------
GET.INSUR.DATE:
*-----------------------------------------------------------------------------
    Y.PR.CNT.AA = DCOUNT(DUE.PROPS,@FM)
    FLG.PRJ = ''
    LOOP
    WHILE Y.PR.CNT.AA GT 0 DO
        FLG.PRJ += 1
        Y.PR.PROJ = DUE.PROPS<FLG.PRJ>
        Y.PR.PROJ = CHANGE(Y.PR.PROJ,@SM,@FM)
        Y.PR.PROJ = CHANGE(Y.PR.PROJ,@VM,@FM)
        LOCATE Y.PROP.CR IN Y.PR.PROJ SETTING PR.PROJ.POS THEN
            Y.FIRST.DUE.DATE = DUE.DATES<FLG.PRJ>
            BREAK
        END
        Y.PR.CNT.AA -= 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------
GET.POL.STATUS:
*-----------------------------------------------------------------------------
    SEL.CMD.RIC = 'SELECT ':FN.REDO.ISSUE.CLAIMS:' WITH CUSTOMER.CODE EQ ':Y.CUSTOMER:' AND ACCOUNT.ID EQ ':Y.ACT.REF
    CALL EB.READLIST(SEL.CMD.RIC,SEL.LIST.RIC,'',NO.OF.REC.RIC,RIC.ERR)
    Y.RIC.ID = SEL.LIST.RIC<1>
    CALL F.READ(FN.REDO.ISSUE.CLAIMS,Y.RIC.ID,R.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS,RIC.REC.ERR)
    Y.STATUS = R.REDO.ISSUE.CLAIMS<ISS.CL.STATUS>

RETURN
*-----------------------------------------------------------------------------
GET.AGENCY:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.AA.ARRANGEMENT.DATED.XREF,Y.ARR.ID,R.AA.ARRANGEMENT.DA.XR,F.AA.ARRANGEMENT.DATED.XREF,ERR.DTA.XREF)
    Y.RESP.PROPS = RAISE(R.AA.ARRANGEMENT.DA.XR<1>)
    LOCATE 'ACCOUNT' IN Y.RESP.PROPS SETTING POS.AC THEN
        Y.PROP.DATES = RAISE(R.AA.ARRANGEMENT.DA.XR<2>)
        Y.WANT.DATE = Y.PROP.DATES<POS.AC,1>
        Y.AA.ARR.AC.ID = Y.ARR.ID:'-':'ACCOUNT':'-':Y.WANT.DATE
        CALL F.READ(FN.AA.ARR.ACCOUNT,Y.AA.ARR.AC.ID,R.AA.ARR.ACC,F.AA.ARR.ACCOUNT,AA.ARR.ERR)
        Y.AGENCY = R.AA.ARR.ACC<AA.AC.CO.CODE>
        Y.ACT.REF = R.AA.ARR.ACC<AA.AC.ACCOUNT.REFERENCE>
    END

RETURN
*-----------------------------------------------------------------------------
FORM.ARRAY:
*-----------------------------------------------------------------------------

    Y.INITIAL.DATE = ICONV(Y.INITIAL.DATE,"D")
    Y.INITIAL.DATE = OCONV(Y.INITIAL.DATE,"D")

    Y.CNT.PAY.DTE = DCOUNT(FIRST.PAY.DATE,@VM)
    IF Y.CNT.PAY.DTE EQ 1 THEN
        FIRST.PAY.DATE = ICONV(FIRST.PAY.DATE,"D")
        FIRST.PAY.DATE = OCONV(FIRST.PAY.DATE,"D")
    END ELSE
        DUP.FIRST.PAY.DTE = CHANGE(FIRST.PAY.DATE,@VM,@FM)
        FLG.DT.PY = ''
        LOOP
        WHILE Y.CNT.PAY.DTE GT 0 DO
            FLG.DT.PY += 1
            Y.1ST.PY.DTE = DUP.FIRST.PAY.DTE<FLG.DT.PY>
            IF FLG.DT.PY EQ 1 THEN
                Y.1ST.PY.DTE = ICONV(Y.1ST.PY.DTE,"D")
                FIRST.PAY.DATE = OCONV(Y.1ST.PY.DTE,"D")
            END ELSE
                Y.1ST.PY.DTE = ICONV(Y.1ST.PY.DTE,"D")
                Y.1ST.PY.DTE = OCONV(Y.1ST.PY.DTE,"D")
                FIRST.PAY.DATE := @VM:Y.1ST.PY.DTE
            END
            Y.CNT.PAY.DTE -= 1
        REPEAT
    END

    Y.EXP.DATE = ICONV(Y.EXP.DATE,"D")
    Y.EXP.DATE = OCONV(Y.EXP.DATE,"D")

    GOSUB SUB.PROCESS.INS.AMT
    GOSUB SUB.PROCESS.MON.AMT
    GOSUB SUB.PROCESS.EX.AMT

    Y.FIN.ARR<-1> = Y.ARR.ID:'*':Y.ALT.ID:'*':Y.CLIENT.NAME:'*':Y.PRODUCT:'*':Y.POL.TY:'*':Y.POL.NUM:'*':Y.CLAS.PY:'*':Y.IN.COMP:'*':Y.EXP.DATE:'*':Y.TERM:'*'
    Y.FIN.ARR := Y.INITIAL.DATE:'*':FIRST.PAY.DATE:'*':Y.COL.CODE:'*':Y.COLL:'*':Y.COL.DES:'*':Y.INS.AMT:'*':CHG.RTE:'*':Y.MON.AMT:'*':Y.EX.AMT:'*'
    Y.FIN.ARR := Y.MNG.TYPE:'*':Y.COMMIS.AMT:'*':Y.ENDORSE.COMMIS:'*':Y.STATUS:'*':Y.CURRENCY:'*':Y.AGENCY:'*':Y.DU.INSUR.AMT:'*':Y.DU.MONE.AMT:'*':Y.DU.EXP.AMT

    Y.ARR.ID = ''; Y.ALT.ID = ''; Y.CUSTOMER = ''; Y.PRODUCT = ''; Y.POL.TY = ''; Y.POL.NUM = ''; Y.CLAS.PY = '';Y.IN.COMP = ''; Y.EXP.DATE = ''; Y.TERM = ''
    Y.INITIAL.DATE = ''; FIRST.PAY.DATE = ''; Y.COL.CODE = ''; Y.COLL = ''; Y.COL.DES = ''; Y.INS.AMT= ''; CHG.RTE = ''; Y.MON.AMT = ''; Y.EX.AMT = ''
    Y.MNG.TYPE = ''; Y.COMMIS.AMT = ''; Y.ENDORSE.COMMIS = ''; Y.STATUS = ''; Y.CURRENCY = ''; Y.AGENCY = ''; Y.DU.INSUR.AMT = ''; Y.DU.MONE.AMT = ''; Y.DU.EXP.AMT = ''
RETURN

SUB.PROCESS.INS.AMT:

    Y.DU.INSUR.AMT = Y.INS.AMT
    Y.CNT.INS.AMT = DCOUNT(Y.INS.AMT,@VM)
    FL.INS.AMT = ''
    LOOP
    WHILE Y.CNT.INS.AMT GT 0 DO
        FL.INS.AMT += 1
        Y.DUP.INS.AMT = Y.DU.INSUR.AMT<1,FL.INS.AMT>
        IF FL.INS.AMT EQ 1 THEN
            Y.INS.AMT = FMT(Y.DUP.INS.AMT,'R2,#0')
        END ELSE
            Y.INS.AMT := @VM:FMT(Y.DUP.INS.AMT,'R2,#0')
        END
        Y.CNT.INS.AMT -= 1
    REPEAT

RETURN

SUB.PROCESS.MON.AMT:

    Y.DU.MONE.AMT = Y.MON.AMT
    Y.CNT.MON.AMT = DCOUNT(Y.MON.AMT,@VM)
    FL.MON.AMT = ''
    LOOP
    WHILE Y.CNT.MON.AMT GT 0 DO
        FL.MON.AMT += 1
        Y.DUP.MON.AMT = Y.DU.MONE.AMT<1,FL.MON.AMT>
        IF FL.MON.AMT EQ 1 THEN
            Y.MON.AMT = FMT(Y.DUP.MON.AMT,'R2,#0')
        END ELSE
            Y.MON.AMT := @VM:FMT(Y.DUP.MON.AMT,'R2,#0')
        END
        Y.CNT.MON.AMT -= 1
    REPEAT

RETURN

SUB.PROCESS.EX.AMT:

    Y.CNT.EX.AMT = DCOUNT(Y.EX.AMT,@VM)
    Y.DU.EXP.AMT = Y.EX.AMT
    FL.EX.AMT = ''
    LOOP
    WHILE Y.CNT.EX.AMT GT 0 DO
        FL.EX.AMT += 1
        Y.DUP.EX.AMT = Y.DU.EXP.AMT<1,FL.EX.AMT>
        IF FL.EX.AMT EQ 1 THEN
            Y.EX.AMT = FMT(Y.DUP.EX.AMT,'R2,#0')
        END ELSE
            Y.EX.AMT := @VM:FMT(Y.DUP.EX.AMT,'R2,#0')
        END
        Y.CNT.EX.AMT -= 1
    REPEAT

RETURN


*-----------------------------------------------------------------------------
GET.MULTI.LOC.FIELDS:
*-----------------------------------------------------------------------------
    APPLNS = 'AA.PRD.DES.CHARGE':@FM:'AA.PRD.DES.CUSTOMER':@FM:'AA.PRD.DES.ACCOUNT':@FM:'AA.PRD.DES.TERM.AMOUNT'
    FIELDS.VAL = 'CLASS.POLICY':@VM:'INS.POLICY.TYPE':@VM:'POLICY.NUMBER':@VM:'MANAGEMENT.TYPE':@VM:'MON.POL.AMT':@VM:'MON.POL.AMT.DAT':@VM:'EXTRA.AMT'
    FIELDS.VAL := @FM:'POLICY.ORG.DATE':@VM:'POL.EXP.DATE':@VM:'INS.COMPANY':@FM:'POLICY.STATUS':@VM:'L.AA.AGNCY.CODE'
    FIELDS.VAL := @FM:'L.AA.COLL.TYPE':@VM:'L.AA.COL':@VM:'L.AA.COL.DESC':@VM:'INS.AMOUNT'
    CALL MULTI.GET.LOC.REF(APPLNS,FIELDS.VAL,FIELD.POS)

    POS.CLS.POL = FIELD.POS<1,1>
    POS.POL.TYPE = FIELD.POS<1,2>
    POS.POL.NUM = FIELD.POS<1,3>
    POS.MNGMNT.TY = FIELD.POS<1,4>
    POS.POL.AMT = FIELD.POS<1,5>
    POS.POL.AMT.DT = FIELD.POS<1,6>
    POS.EX.AMT = FIELD.POS<1,7>

    POS.DTE = FIELD.POS<2,1>
    POS.EX.DTE = FIELD.POS<2,2>
    POS.IN.COMP = FIELD.POS<2,3>

    POS.STATUS = FIELD.POS<3,1>
    POS.AGENCY = FIELD.POS<3,2>

    POS.COL.CODE = FIELD.POS<4,1>
    POS.COL = FIELD.POS<4,2>
    POS.COL.DES = FIELD.POS<4,3>
    POS.INS.AMT = FIELD.POS<4,4>

RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------
END
