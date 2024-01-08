* @ValidationCode : MjozMDk2Mzg0MTI6Q3AxMjUyOjE2ODU1NDMxMjE3Mjg6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 19:55:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOFILE.LOAN.PAYMENTS(Y.OUT.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.NOFILE.LOAN.PAYMENTS
*--------------------------------------------------------------------------------------------------------
*Description       : This is a NO-FILE enquiry routine, the routine based on the selection criteria selects
*                    the records from AA.ARRANGEMENT and displays the processed records
*Linked With       : Enquiry REDO.LOAN.PAYMNET
*In  Parameter     : N/A
*Out Parameter     : Y.OUT.ARRAY
*Files  Used       : AA.ARRANGEMENT
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                        Reference                   Description
*     ------               -----                      -------------                -------------
* 25 Nov 2010            Arulprakasam P               ODR-2010-03-0142- 166              Initial Creation
* 21 Jan 2013            Shekar                       Performance
*                        pass effective date to redo.get.pre
*                        read aa.activity.history only when selection is passed
*                        read aa.bill.details only if he aa.account.details>bill.status is settled
*  DATE             WHO                   REFERENCE
* 12-APRIL-2023      Conversion Tool       R22 Auto Conversion  - F.READ to CACHE.READ , FM to @FM , SM to @SM , ++ to += , = to EQ and VM to @VM
* 12-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AA.PROPERTY

    $INSERT I_F.AA.ACTIVITY
    $INSERT I_F.USER
    $USING APAP.AA
    $USING APAP.TAM

*-------------------------------------------------------------------------------------------------------
MAIN.PARA:
*--------------------------------------------------------------------------------------------------------
* This is the para from where the execution of the code starts

    GOSUB OPEN.PARA
    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB CHECK.SELECTION
    GOSUB PROCESS.PARA

RETURN

*--------------------------------------------------------------------------------------------------------
OPEN.PARA:
*--------------------------------------------------------------------------------------------------------

* In this para of the code, file variables are initialised and opened

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AA.ARR.ACCOUNT = 'F.AA.ARR.ACCOUNT'
    F.AA.ARR.ACCOUNT = ''
    CALL OPF(FN.AA.ARR.ACCOUNT,F.AA.ARR.ACCOUNT)

    FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'
    F.AA.ARR.TERM.AMOUNT = ''
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.TELLER.HIS = 'F.TELLER$HIS'
    F.TELLER.HIS = ''
    CALL OPF(FN.TELLER.HIS,F.TELLER.HIS)

    FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIS = ''
    CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.AA.PROPERTY = 'F.AA.PROPERTY'
    F.AA.PROPERTY = ''
    CALL OPF(FN.AA.PROPERTY,F.AA.PROPERTY)

    FN.AA.ACTIVITY = 'F.AA.ACTIVITY'
    F.AA.ACTIVITY = ''
    CALL OPF(FN.AA.ACTIVITY,F.AA.ACTIVITY)

    Y.LANG = R.USER<EB.USE.LANGUAGE>

    Y.MAIN.TYPE = ''
    JS.BILL.STATUS = ''
    JS.BILL.STATUS.1 = ''
    ADJ.VAUE = ''
    Y.PREV.COND = ''
    Y.CURR.COND = ''
    Y.DESC.LIST = ''
RETURN

*--------------------------------------------------------------------------------------------------------
FIND.MULTI.LOCAL.REF:
*--------------------------------------------------------------------------------------------------------

    APPL.ARRAY = 'AA.PRD.DES.OVERDUE'
    FLD.ARRAY  = 'L.LOAN.STATUS.1'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.LOAN.STATUS.1.POS = FLD.POS<1,1>

RETURN

*--------------------------------------------------------------------------------------------------------
CHECK.SELECTION:
*--------------------------------------------------------------------------------------------------------

    Y.PROD.GROUP = ''; Y.USER.ID = ''; Y.AUTH.ID = '' ;  Y.CO.CODE = '' ; Y.FROM.DATE = '' ; Y.TO.DATE = '' ;

    SelectionPassed = 0
    LOCATE 'PORTFOLIO.TYPE' IN D.FIELDS<1> SETTING Y.PROD.TYPE.POS THEN
        Y.PROD.GROUP = D.RANGE.AND.VALUE<Y.PROD.TYPE.POS>
    END

    LOCATE 'USER.ID' IN D.FIELDS<1> SETTING USER.ID.POS THEN
        Y.USER.ID = D.RANGE.AND.VALUE<USER.ID.POS>
        SelectionPassed = 1
    END

    LOCATE 'AUTHORISER.ID' IN D.FIELDS<1> SETTING AUTHORISER.ID.POS THEN
        Y.AUTH.ID = D.RANGE.AND.VALUE<AUTHORISER.ID.POS>
        SelectionPassed = 1
    END

    LOCATE 'CO.CODE' IN D.FIELDS<1> SETTING CO.CODE.POS THEN
        Y.CO.CODE = D.RANGE.AND.VALUE<CO.CODE.POS>
        SelectionPassed = 1
    END

    LOCATE 'FROM.DATE' IN D.FIELDS<1> SETTING FROM.DATE.POS THEN
* PACS00313082 - 2015MAY01 - Cristina's email - S
        Y.TMP.LNPAY.DATES = D.RANGE.AND.VALUE<FROM.DATE.POS>
        Y.FROM.DATE       = Y.TMP.LNPAY.DATES
        CHANGE @SM TO ' ' IN Y.TMP.LNPAY.DATES
        Y.NO.DATES = DCOUNT(Y.TMP.LNPAY.DATES,' ')
        IF Y.NO.DATES GT 1 THEN
            Y.FROM.DATE = FIELD(Y.TMP.LNPAY.DATES,' ',1)
            Y.TO.DATE   = FIELD(Y.TMP.LNPAY.DATES,' ',2)
        END
    END
*    LOCATE 'TO.DATE' IN D.FIELDS<1> SETTING TO.DATE.POS THEN
*        Y.TO.DATE = D.RANGE.AND.VALUE<TO.DATE.POS>
*    END
* PACS00313082 - 2015MAY01 - Cristina's email - E

    SEL.CMD.ACC.HIS = 'SELECT ':FN.AA.ACTIVITY.HISTORY

    IF Y.FROM.DATE AND Y.TO.DATE THEN
        SEL.CMD.ACC.HIS : = ' WITH SYSTEM.DATE GT ':Y.FROM.DATE: ' AND SYSTEM.DATE LE ' : Y.TO.DATE
    END

    CALL EB.READLIST(SEL.CMD.ACC.HIS,SEL.LIST.ACC.HIS,'',NO.OF.REC.ARR,SEL.ERR.HIS)

RETURN

*--------------------------------------------------------------------------------------------------------
PROCESS.PARA:
*--------------------------------------------------------------------------------------------------------

    Y.ERR.FLAG = ''
    Y.MAIN.LIST = 'LENDING-RENEGOTIATE-ARRANGEMENT':@FM:'LENDING-RESET-ARRANGEMENT':@FM:'LENDING-CHANGE.PRODUCT-ARRANGEMENT':@FM:'LENDING-ROLLOVER-ARRANGEMENT'

    LOOP
        Y.ERR.FLAG = ''
        REMOVE AA.ARRANGEMENT.ID FROM SEL.LIST.ACC.HIS SETTING Y.AA.HIS.POS
    WHILE AA.ARRANGEMENT.ID : Y.AA.HIS.POS
        GOSUB CHECK.AA.ARRANGEMENT
        IF Y.ERR.FLAG THEN
            CONTINUE
        END
        GOSUB GET.DETAILS
    REPEAT

RETURN

*--------------------------------------------------------------------------------------------------------
CHECK.AA.ARRANGEMENT:
*--------------------------------------------------------------------------------------------------------

    R.AA.ARRANGEMENT = ''
    AA.ARRANGEMENT.ER = ''
    CALL F.READ(FN.AA.ARRANGEMENT,AA.ARRANGEMENT.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ER)

    EffectiveDate = ''
    EffectiveDate = R.AA.ARRANGEMENT<AA.ARR.PROD.EFF.DATE>    ;*Shek
    IF Y.PROD.GROUP AND Y.PROD.GROUP NE R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>  THEN
        Y.ERR.FLAG = 1
        RETURN
    END

    AA.ACTIVITY.HISTORY.ID = AA.ARRANGEMENT.ID
    IF SelectionPassed THEN     ;* Shek
        R.AA.ACTIVITY.HISTORY = ''
        AA.ACTIVITY.HISTORY.ER = ''
        CALL F.READ(FN.AA.ACTIVITY.HISTORY,AA.ACTIVITY.HISTORY.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,AA.ACTIVITY.HISTORY.ER)
        IF R.AA.ACTIVITY.HISTORY NE '' THEN
            GOSUB CHECK.AA.ARRANGEMENT.SEL.PASSED
        END
    END

RETURN

*--------------------------------------------------------------------------------------------------------
CHECK.AA.ARRANGEMENT.SEL.PASSED:
*--------------------------------------------------------------------------------------------------------

    AA.ARRANGEMENT.ACTIVITY.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF,1,1>
    R.AA.ARRANGEMENT.ACTIVITY = ''
    AA.ARRANGEMENT.ACTIVITY.ER = ''
    CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,AA.ARRANGEMENT.ACTIVITY.ID,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,AA.ARRANGEMENT.ACTIVITY.ER)
    IF R.AA.ARRANGEMENT.ACTIVITY NE '' THEN
        Y.AA.INP.ID = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.INPUTTER>
        Y.AA.INP.ID = FIELD(Y.AA.INP.ID,'_',2)

        IF Y.USER.ID AND Y.USER.ID NE Y.AA.INP.ID THEN
            Y.ERR.FLAG = 1
            RETURN
        END

        Y.AA.AUT.ID = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.AUTHORISER>
        Y.AA.AUT.ID = FIELD(Y.AA.AUT.ID,'_',2)

        IF Y.AUTH.ID AND Y.AUTH.ID NE Y.AA.AUT.ID THEN
            Y.ERR.FLAG = 1
            RETURN
        END

        Y.AA.CO.CODE = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.CO.CODE>

        IF Y.CO.CODE AND Y.CO.CODE NE Y.AA.CO.CODE THEN
            Y.ERR.FLAG = 1
        END
    END

RETURN

*--------------------------------------------------------------------------------------------------------
GET.DETAILS:
*--------------------------------------------------------------------------------------------------------

    GOSUB GET.MAIN.TYPE
    Y.LOAN.NO = AA.ARRANGEMENT.ID
    GOSUB GET.AA.ARRANGEMENT.DETAILS
    CHANGE @FM TO @VM IN Y.PREV.COND
    CHANGE @FM TO @VM IN Y.CURR.COND
* PACS00313082 - 2015MAY01 - Cristina's email - S
    VIRTUAL.TAB.ID = 'AA.ARR.STATUS' ; Y.DES = '' ; Y.VAL = Y.AA.STATUS
    GOSUB GET.LOOK.LSTAT
    Y.AA.STATUS    = Y.DES
    VIRTUAL.TAB.ID = 'L.LOAN.STATUS.1' ; Y.DES = '' ; Y.VAL = Y.LOAN.STATUS1
    GOSUB GET.LOOK.LSTAT
    Y.LOAN.STATUS1 = Y.DES
    GOSUB GET.AA.ACCT
* PACS00313082 - 2015MAY01 - Cristina's email - E
    Y.OUT.ARRAY<-1> = Y.MAIN.TYPE:'*':Y.LOAN.NO:'*':Y.PRE.LOAN.NO:'*':Y.LOAN.PORT.TYPE:'*':Y.LOAN.TYPE:'*':Y.VALUE.DATE:'*':Y.VALUE.DATE:'*':
    Y.OUT.ARRAY :=  Y.INPUTTER:'*':Y.AUTHORISER:'*':Y.ORIGIN.AGENCY:'*':Y.AGENCY:'*':ADJ.VAUE:'*':Y.PREV.COND:'*':Y.CURR.COND:'*':Y.LOAN.STATUS1:'*':Y.AA.STATUS:'*':

RETURN

*--------------------------------------------------------------------------------------------------------
GET.MAIN.TYPE:
*--------------------------------------------------------------------------------------------------------

    Y.AA.ACTIVITY.IDS = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY>
    Y.VM.COUNT = DCOUNT(Y.AA.ACTIVITY.IDS,@VM)
    Y.VM.START = 1

    LOOP
    WHILE Y.VM.START LE Y.VM.COUNT
        Y.VM.VALUE = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY,Y.VM.START>
        Y.SM.COUNT = DCOUNT(Y.VM.VALUE,@SM)
        Y.SM.START = 1
        GOSUB LOOP.GET.MAIN.TYPE
        Y.VM.START += 1
    REPEAT

    IF Y.MAIN.TYPE THEN
        CHANGE @FM TO @VM IN Y.MAIN.TYPE
    END

RETURN

*--------------------------------------------------------------------------------------------------------
LOOP.GET.MAIN.TYPE:
*--------------------------------------------------------------------------------------------------------

    LOOP
    WHILE Y.SM.START LE Y.SM.COUNT
        Y.ACT = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY,Y.VM.START,Y.SM.START>
        GOSUB GET.ACT.DESC        ;* 2015MAY01 - Cristina's email - S/E
        LOCATE Y.ACT IN Y.MAIN.LIST SETTING Y.AA.MAIN.POS THEN
            Y.AA.ARR.ACTIVITY = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF,Y.VM.START,Y.SM.START>
            Y.MAIN.TYPE = FIELD(Y.ACT,'-',3)
            Y.AA.ARR.ACTIVITY<2> = EffectiveDate        ;* Shek  pass effective date
            APAP.AA.redoGetPre(Y.AA.ARR.ACTIVITY,Y.PRE,Y.CURENT);* R22 Manual conversion
       
            Y.PREV.COND = Y.PRE
            Y.CURR.COND = Y.CURENT
            ADJ.VAUE= '1'
        END
        Y.SM.START += 1
    REPEAT

RETURN

*--------------------------------------------------------------------------------------------------------
GET.ACT.DESC:
*--------------------------------------------------------------------------------------------------------

    R.AA.ACTIVITY = '' ; Y.AA.ACT.ER = ''
    CALL CACHE.READ(FN.AA.ACTIVITY, Y.ACT, R.AA.ACTIVITY, Y.AA.ACT.ER)	  ;*R22 Auto Conversion  - F.READ to CACHE.READ
    Y.MAIN.TYPE = R.AA.ACTIVITY<AA.ACT.DESCRIPTION,Y.LANG>
    IF Y.MAIN.TYPE EQ "" THEN
        Y.MAIN.TYPE = Y.ACT
    END

RETURN

*--------------------------------------------------------------------------------------------------------
GET.AA.ARRANGEMENT.DETAILS:
*--------------------------------------------------------------------------------------------------------

    ARR.ID      = AA.ARRANGEMENT.ID
    EFF.DATE    = TODAY
    PROP.CLASS  = 'ACCOUNT'
    PROPERTY    = ''
    R.CONDITION = ''
    ERR.MSG     = ''

    APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.AA.ARR.ACCOUNT,ERR.MSG)
    IF R.AA.ARR.ACCOUNT<AA.AC.ALT.ID> THEN
        Y.PRE.LOAN.NO = R.AA.ARR.ACCOUNT<AA.AC.ALT.ID>
    END

*-Shek    GOSUB READ.AA.ARRANGEMENT   ;* already read in CHECK.AA.ARRANGEMENT para
    IF R.AA.ARRANGEMENT NE '' THEN
        Y.LOAN.PORT.TYPE = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
        Y.LOAN.TYPE = R.AA.ARRANGEMENT<AA.ARR.PRODUCT,1>
        Y.AA.STATUS    = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>
    END

    GOSUB READ.AA.ARRANGEMENT.ACTIVITY

    R.AA.ACCOUNT.DETAILS = ''
    Y.AA.ERR = ''
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,AA.ARRANGEMENT.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.AA.ERR)
    IF R.AA.ACCOUNT.DETAILS NE '' THEN
        Y.BILL.ID = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
        JS.BILL.STATUS = RAISE(R.AA.ACCOUNT.DETAILS<AA.AD.BILL.STATUS>)   ;*Shek
        Y.ARR.AGE.STATUS = R.AA.ACCOUNT.DETAILS<AA.AD.ARR.AGE.STATUS>
        Y.VALUE.DATE = ''
        IF Y.BILL.ID NE '' THEN
            Y.BILL.ID = RAISE(Y.BILL.ID)
            JS.BILL.STATUS = RAISE(JS.BILL.STATUS)
            INIT1 = 1
            CHANGE @VM TO @FM IN Y.BILL.ID
* CHANGE FM TO '*' IN Y.BILL.ID
            Y.COUNT.TRANS1 = DCOUNT(Y.BILL.ID,@FM)       ;* Shek
            LOOP
            WHILE INIT1 LE Y.COUNT.TRANS1
                GOSUB GET.VALUE.DATE
            REPEAT
        END
    END

    GOSUB GET.ARR.OVERDUE.DETAILS

RETURN

*--------------------------------------------------------------------------------------------------------
GET.VALUE.DATE:
*--------------------------------------------------------------------------------------------------------

    Y.BILL.ID.1 = FIELD(Y.BILL.ID,'*',INIT1)        ;*Shek. avoid field()
    Y.BILL.ID.1 = Y.BILL.ID<INIT1>        ;*Shek
    JS.BILL.STATUS.1 =  JS.BILL.STATUS<INIT1>       ;*

    IF JS.BILL.STATUS.1 EQ 'SETTLED' THEN  ;* Shek
        GOSUB READ.AA.BILL.DETAILS
        Y.STATUS = R.AA.BILL.DETAILS<AA.BD.BILL.STATUS>
        LOCATE 'SETTLED' IN Y.STATUS<1,1> SETTING STATUS.POS THEN
            Y.VALUE.DATE = R.AA.BILL.DETAILS<AA.BD.AGING.ST.CHG.DT,STATUS.POS>
        END
    END
    INIT1 += 1

RETURN

*--------------------------------------------------------------------------------------------------------
GET.ARR.OVERDUE.DETAILS:
*--------------------------------------------------------------------------------------------------------

    ARR.ID      = AA.ARRANGEMENT.ID
    EFF.DATE    = TODAY
    PROP.CLASS  = 'OVERDUE'
    PROPERTY    = ''
    R.CONDITION = ''
    ERR.MSG     = ''

    APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)

    Y.LOAN.STATUS1 = R.CONDITION<AA.OD.LOCAL.REF,LOC.L.LOAN.STATUS.1.POS>

    CHANGE @SM TO @VM IN Y.LOAN.STATUS1
RETURN

*--------------------------------------------------------------------------------------------------------
READ.AA.ARRANGEMENT:
*--------------------------------------------------------------------------------------------------------

* In this para of the code, file AA.ARRANGEMENT is read
    R.AA.ARRANGEMENT  = ''
    AA.ARRANGEMENT.ER = ''
    CALL F.READ(FN.AA.ARRANGEMENT,AA.ARRANGEMENT.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ER)

RETURN

*--------------------------------------------------------------------------------------------------------
READ.AA.BILL.DETAILS:
*--------------------------------------------------------------------------------------------------------

* In this para of the code, file AA.BILL.DETAILS is read
    R.AA.BILL.DETAILS  = ''
    AA.BILL.DETAILS.ER = ''
    CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID.1,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,AA.BILL.DETAILS.ER)

RETURN

*--------------------------------------------------------------------------------------------------------
READ.AA.ARRANGEMENT.ACTIVITY:
*--------------------------------------------------------------------------------------------------------

    Y.AGENCY = ''
    R.AA.ACTIVITY.HISTORY = ''
    HIST.ERR = ''
    CALL F.READ(FN.AA.ACTIVITY.HISTORY,AA.ARRANGEMENT.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,HIST.ERR)
    IF R.AA.ACTIVITY.HISTORY NE '' THEN
        Y.AA.ACTIVITY.REF = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF,1,1>
    END

    R.AA.ARRANGEMENT.ACTIVITY = ''
    ACTIVITY.ERR = ''
    CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.AA.ACTIVITY.REF,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,ACTIVITY.ERR)
    IF R.AA.ARRANGEMENT.ACTIVITY NE '' THEN
        Y.TXN.CONTRACT.ID = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.CONTRACT.ID>
        Y.INPUTTER        = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.INPUTTER>
        Y.INPUTTER = FIELD(Y.INPUTTER,'_',2)
        Y.AUTHORISER      = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.AUTHORISER>
        Y.AUTHORISER = FIELD(Y.AUTHORISER,'_',2)
        Y.ORIGIN.AGENCY   = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.CO.CODE>
    END

    APAP.REDOENQ.redoENofArrangmentProcess(AA.ARRANGEMENT.ID,Y.AGENCY,Y.DISBURSED.AMOUNT);* PACS00313082 - 2015MAY01 - Cristina's email - S/E

RETURN  ;* Shek. ft/tt are in history. no need for these codes

IF Y.TXN.CONTRACT.ID THEN
    Y.TXN.APP = Y.TXN.CONTRACT.ID[1,2]
    IF Y.TXN.APP EQ 'TT' THEN
        R.TELLER = ''
        TELLER.ERR = ''
        CALL F.READ(FN.TELLER,Y.TXN.CONTRACT.ID,R.TELLER,F.TELLER,TELLER.ERR)
        IF R.TELLER NE '' THEN
            Y.AGENCY = R.TELLER<TT.TE.CO.CODE>
        END ELSE
            R.HIS.TELLER = ''
            HIS.TELLER.ERR = ''
            CALL EB.READ.HISTORY.REC(F.TELLER.HIS,Y.TXN.CONTRACT.ID,R.TELLER.HIS,HIS.TELLER.ERR)
            Y.AGENCY = R.HIS.TELLER<TT.TE.CO.CODE>
        END
    END
    IF Y.TXN.APP EQ 'FT' THEN
        R.FUNDS.TRANSFER = ''
        FUNDS.TRANSFER.ERR = ''
        CALL F.READ(FN.FUNDS.TRANSFER,Y.TXN.CONTRACT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.TRANSFER.ERR)
        IF R.FUNDS.TRANSFER NE '' THEN
            Y.AGENCY = R.FUNDS.TRANSFER<FT.CO.CODE>
        END ELSE
            R.FUNDS.TRANSFER.H = ''
            HIS.FT.ERR = ''
            CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,Y.TXN.CONTRACT.ID,R.FUNDS.TRANSFER.H,HIS.FT.ERR)
            Y.AGENCY = R.FUNDS.TRANSFER.H<FT.CO.CODE>
        END
    END
END

RETURN

*--------------------------------------------------------------------------------------------------------
GET.LOOK.LSTAT:
*--------------------------------------------------------------------------------------------------------

    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
    Y.LOOKUP.LIST = VIRTUAL.TAB.ID<2>
    Y.LOOKUP.LIST = CHANGE(Y.LOOKUP.LIST,'_',@FM )
*
    Y.DESC.LIST = VIRTUAL.TAB.ID<11>
    Y.DESC.LIST = CHANGE(Y.DESC.LIST,'_',@FM)
*
    W.FLG = '' ; W.POS = ''
    W.CNT = DCOUNT(Y.DESC.LIST,@FM)
    LOOP
    WHILE W.CNT GT 0 DO
        W.FLG += 1
        LOCATE Y.VAL IN Y.LOOKUP.LIST SETTING W.POS THEN
            Y.DES = Y.DESC.LIST<W.POS,LNGG>
            RETURN
        END
        W.CNT -= 1
    REPEAT
RETURN

*--------------------------------------------------------------------------------------------------------
GET.AA.ACCT:
*--------------------------------------------------------------------------------------------------------

    IN.ACC.ID = ''
    ERR.TEXT = ''
    OUT.ID = ''
    APAP.TAM.redoConvertAccount(IN.ACC.ID,Y.LOAN.NO,OUT.ID,ERR.TEXT)
    Y.LOAN.NO = OUT.ID

RETURN
*--------------------------------------------------------------------------------------------------------
END
