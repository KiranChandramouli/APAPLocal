* @ValidationCode : Mjo4OTA5NzEyODc6VVRGLTg6MTY4MzYxNjA5NjczNTpJVFNTOi0xOi0xOjg4MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 May 2023 12:38:16
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 880
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.LB.GENERATE.AMNTS(COMP.TYPE,DATA.IN,DATA.OUT)

******************************************************************************
* Subroutine Type : Subroutine
* Attached to     : REDO.FI.LB.GENERATE.DATA  multithreading routine
* Attached as     : Subroutine
* Primary Purpose : Gets AMOUNTS for APAP-Planillas
*
* Incoming:
* ---------
* DATA.IN - Arrangement ID
*
* Outgoing:
* ---------
*
* DATA.OUT - data returned
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos ODR-2010-03-0025
* Development by  : Adriana Velasco - TAM Latin America
* Date            : Nov. 22, 2010

*  DATE             WHO                   REFERENCE
* 05-APRIL-2023      Harsha                R22 Auto Conversion  - VM to @VM , FM to @FM and ++ to +=1
* 05-APRIL-2023      Harsha                R22 Manual Conversion - call routine format modified
*----------------------------------------------------------------------------
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.OVERDUE
*   $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.PROPERTY

    $INSERT I_REDO.FI.VAR.LOAN.BILL.COMMON
    $INSERT I_REDO.FI.LB.GENERATE.DATA.COMMON
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
    $USING APAP.TAM

*************************************************************************
*
    GOSUB INITIALISE
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
    ARR.STATUS      = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>
    Y.PRODUCT.GROUP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
*
    Y.WRITE = 'N'
*

    PROP.CLASS = 'OVERDUE'
    PROPERTY = ''
    R.Condition = ''
    ERR.MSG = ''
    EFF.DATE = ''
*  CALL APAP.TAM.REDO.CRR.GET.CONDITIONS(DATA.IN,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
    CALL APAP.TAM.redoCrrGetConditions(DATA.IN,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG) ;*R22 Manual Conversion
    LOAN.COND = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.COND.POS>
    LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.STATUS.POS>
    CHANGE @SM TO @VM IN LOAN.COND
    CHANGE @SM TO @VM IN LOAN.STATUS

    GOSUB CHECK.LOAN.STATUS
    IF NOT(Y.LOOP.CONTINUE) THEN
        Y.WRITE     = 'S'
        GOSUB B200.GET.AA.DATA
    END
RETURN
*
* ========================
CHECK.LOAN.STATUS:
* ========================

    Y.STATUS.CNT = 1
    Y.TOTAL.STATUS.CNT  = DCOUNT(Y.PARAM.LOAN.STATUS,@FM)
    LOOP
    WHILE Y.STATUS.CNT LE Y.TOTAL.STATUS.CNT
        Y.PARAM.STATUS = Y.PARAM.LOAN.STATUS<Y.STATUS.CNT>
        IF (Y.PARAM.STATUS MATCHES LOAN.COND) OR (Y.PARAM.STATUS MATCHES LOAN.STATUS) THEN
            Y.LOOP.CONTINUE=1
            Y.WRITE = 'N'
        END
        Y.STATUS.CNT += 1
    REPEAT

RETURN
* ========================
B200.GET.AA.DATA:
* ========================
*
    WPARAM.POS1 = 1

    L.CUST.NAME = ""
    L.COD.EMPL  = ""
    Y.TOT.BILL.AMT  = 0
    Y.TOT.BILL.CNT  = 0
    Y.PRINCIPAL.AMT = 0
    Y.INTEREST.AMT  = 0
    Y.CHARGE.AMT    = 0
    Y.PENALTY.AMT   = 0

    L.CUST.ID   = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    Y.LINK      = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL>
    Y.LINK.ID   = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    L.LINK      = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
*
    LOCATE Y.ACCOUNT IN Y.LINK<WPARAM.POS1> SETTING PARAM.POS1 THEN
        Y.CTA = Y.LINK.ID<WPARAM.POS>
    END
*
    GOSUB B400.GET.NAME
    GOSUB B500.GET.ACC.DETAILS
    GOSUB B600.GET.PROP.DETS
    GOSUB B510.BILL.GET.DETS
*
    DATA.OUT<-1> = L.CUST.ID
    DATA.OUT<-1> = L.CUST.NAME
    DATA.OUT<-1> = L.COD.EMPL
    DATA.OUT<-1> = Y.TOT.BILL.AMT
    DATA.OUT<-1> = Y.TOT.BILL.CNT
    DATA.OUT<-1> = Y.INTEREST.AMT
    DATA.OUT<-1> = ''
    DATA.OUT<-1> = Y.PENALTY.AMT
    DATA.OUT<-1> = Y.WRITE
    DATA.OUT<-1> = Y.LOAN.CATEG
    DATA.OUT<-1> = Y.PRINCIPAL.AMT
    DATA.OUT<-1> = Y.CHARGE.AMT



RETURN
*
* ========================
B400.GET.NAME:
* ========================
*
    CALL F.READ(FN.CUSTOMER, L.CUST.ID, R.CUSTOMER, F.CUSTOMER, Y.ERR4)
    IF Y.ERR4 THEN
        L.CUST.NAME = "NO NAME REGISTRED"
        WERROR.MSG = "FI.PARAMETER.MISSING-&":@FM:L.CUST.ID
        CALL TXT(WERROR.MSG)
    END ELSE
        L.CUST.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
        L.COD.EMPL  = FIELD(R.CUSTOMER<EB.CUS.FAX.1>,'.',2)
    END

    IF COMP.TYPE EQ 'APAP-EMPLEADOS' OR COMP.TYPE EQ 'APAP-EXEC-EMPLEADOS' THEN
        IF NOT(L.COD.EMPL) THEN
            Y.WRITE = 'N'
        END
    END
*
RETURN
*
* ==================
B500.GET.ACC.DETAILS:
* ==================
*

    IN.ACCT.ID     = Y.CTA
    IN.BAL.TYPE    = ""
    OUT.BAL.ARR    = ""
    CALL F.READ(FN.ACCOUNT,IN.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    Y.LOAN.CATEG = R.ACCOUNT<AC.CATEGORY>


RETURN

* ================
B510.BILL.GET.DETS:
* ================
*

*
    CALL F.READ(FN.AA.ACCOUNT.DETAILS, ARR.ID, R.AA.ACCOUNT.DETAILS, F.AA.ACCOUNT.DETAILS, Y.ERR7)
    IF Y.ERR7 THEN
        WERROR.MSG = "ACCOUNT.DETAILS MISSING-&":@FM:ARR.ID
        CALL TXT(WERROR.MSG)
    END ELSE
        BILL.ID.LIST     = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
        BILL.STATUS.LIST = R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
        CHANGE @VM TO @FM IN BILL.ID.LIST
        CHANGE @VM TO @FM IN BILL.STATUS.LIST
        TOT.BILL.CNT = DCOUNT(BILL.ID.LIST,@FM)
        BILL.CNT = 1
        LOOP
        WHILE BILL.CNT LE TOT.BILL.CNT
            EACH.BILL.ID     = BILL.ID.LIST<BILL.CNT>
            EACH.BILL.STATUS = BILL.STATUS.LIST<BILL.CNT>
            IF EACH.BILL.STATUS EQ 'UNPAID' THEN
                R.BILL.DET = ''
                CALL F.READ(FN.AA.BILL.DETAILS,EACH.BILL.ID,R.BILL.DET,F.AA.BILL.DETAILS,BILL.DET.ERR)
                IF R.BILL.DET THEN
                    CALL OCOMO("Processing Arrangement id  ":ARR.ID:"->Bill id ":EACH.BILL.ID)
                    GOSUB B510.BILL.GET.AMT
                    Y.TOT.BILL.CNT + = 1
                END
            END
            BILL.CNT += 1
        REPEAT
    END

    IF Y.TOT.BILL.CNT EQ 0 THEN
        Y.WRITE = 'N'
    END

RETURN
*

* ================
B510.BILL.GET.AMT:
* ================

    Y.PROPERTY.LIST = R.BILL.DET<AA.BD.PROPERTY>
    CHANGE @VM TO @FM IN Y.PROPERTY.LIST
    CHANGE @SM TO @FM IN Y.PROPERTY.LIST
    Y.TOT.PROP.CNT = DCOUNT(Y.PROPERTY.LIST,@FM)
    Y.PROP.CNT = 1
    LOOP
    WHILE Y.PROP.CNT LE Y.TOT.PROP.CNT
        Y.PROP = Y.PROPERTY.LIST<Y.PROP.CNT>
        CALL F.READ(FN.AA.PROPERTY,Y.PROP,R.PROP.REC,F.AA.PROPERTY,PP.ERR)
        Y.PROP.CLASS = R.PROP.REC<AA.PROP.PROPERTY.CLASS>
        BEGIN CASE
            CASE Y.PROP EQ Y.PRINCIPAL.PROP
                Y.PRINCIPAL.AMT += R.BILL.DET<AA.BD.OS.PROP.AMOUNT,Y.PROP.CNT>
            CASE Y.PROP MATCHES Y.INTEREST.PROPERTY
                Y.INTEREST.AMT  += R.BILL.DET<AA.BD.OS.PROP.AMOUNT,Y.PROP.CNT>
            CASE Y.PROP EQ Y.PENALTY.CHARGE.PROP
                Y.PENALTY.AMT   += R.BILL.DET<AA.BD.OS.PROP.AMOUNT,Y.PROP.CNT>
            CASE Y.PROP NE Y.PENALTY.CHARGE.PROP AND Y.PROP.CLASS EQ 'CHARGE'
                Y.CHARGE.AMT    += R.BILL.DET<AA.BD.OS.PROP.AMOUNT,Y.PROP.CNT>
        END CASE

        CALL OCOMO("Processing Arrangement id  ":ARR.ID:"->Bill id ":EACH.BILL.ID:"->Property name & amount ":Y.PROP:" : ":R.BILL.DET<AA.BD.OS.PROP.AMOUNT,Y.PROP.CNT>)

        Y.TOT.BILL.AMT + = R.BILL.DET<AA.BD.OS.PROP.AMOUNT,Y.PROP.CNT>
        Y.PROP.CNT += 1
    REPEAT
RETURN
* ================
B600.GET.PROP.DETS:
* ================
    GOSUB GET.PRINCIPAL.PROP
    GOSUB GET.INTEREST.PROP
    GOSUB GET.PENALTY.PROP
RETURN

*-----------------------------------------
GET.PRINCIPAL.PROP:
*-----------------------------------------
    IN.PROPERTY.CLASS = 'ACCOUNT'
    OUT.PROPERTY      = ''
    CALL APAP.TAM.redoGetPropertyName(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)
    Y.PRINCIPAL.PROP = OUT.PROPERTY

RETURN
*-----------------------------------------
GET.INTEREST.PROP:
*-----------------------------------------
    ARR.INFO    = ''
    ARR.INFO<1> = ARR.ID
    R.ARRANGEMENT = ''
    Y.EFF.DATE = TODAY
    CALL AA.GET.ARRANGEMENT.PROPERTIES(ARR.INFO, Y.EFF.DATE, R.ARRANGEMENT, PROP.LIST)

    CLASS.LIST = ''
    CALL AA.GET.PROPERTY.CLASS(PROP.LIST, CLASS.LIST)         ;* Find their Property classes

    CLASS.LIST = RAISE(CLASS.LIST)
    PROP.LIST = RAISE(PROP.LIST)
    CLASS.CTR = ''
    Y.INTEREST.PROPERTY = ''

    LOOP
        REMOVE Y.CLASS FROM CLASS.LIST SETTING CLASS.POS
        CLASS.CTR +=1
    WHILE Y.CLASS:CLASS.POS
        IF Y.CLASS EQ "INTEREST" THEN
            Y.INTEREST.PROPERTY<1,-1> = PROP.LIST<CLASS.CTR>      ;*Get the interest property
        END
    REPEAT

RETURN

*-----------------------------------------
GET.PENALTY.PROP:
*-----------------------------------------

    CALL F.READ(FN.REDO.APAP.PROPERTY.PARAM,Y.PRODUCT.GROUP,R.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM,PAR.ERR)
    Y.PENALTY.CHARGE.PROP = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PENALTY.ARREAR>

RETURN
* =========
INITIALISE:
* =========
*
    LOOP.CNT                  = 1
    MAX.LOOPS                 = 1
    WPARAM.POS                = 1
    DATA.OUT                  = ""
*

    ARR.ID                  = DATA.IN     ;*  Arrangement Id
    CALL OCOMO("Processing Arrangement id ":ARR.ID)


*   CONSTANTS

    Y.ACCOUNT =  "ACCOUNT"
*
RETURN
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*

    CALL F.READ(FN.AA.ARRANGEMENT, ARR.ID, R.AA.ARRANGEMENT, F.AA.ARRANGEMENT, Y.ERR3)
    IF Y.ERR3 THEN
        PROCESS.GOAHEAD = 0
        WERROR.MSG = "FI.PARAMETER.MISSING-&":@FM:ARR.ID
        CALL TXT(WERROR.MSG)
    END
RETURN
*
END
