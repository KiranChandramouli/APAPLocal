* @ValidationCode : MjotMjIyNTk1MDc1OkNwMTI1MjoxNjg5MjQyMDI4Mzg3OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Jul 2023 15:23:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion            F.READ TO CACHE.READ, FM TO @FM, VM TO @VM, SM TO @SM
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.APAP.INP.AML.TFS.CHECK
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.INP.AML.TFS.CHECK
*--------------------------------------------------------------------------------------------------------
*Description       : This is an INPUT routine, the routine checks if the total customer amount is greater
*                    than the threshold amount defined in the local parameter table REDO.AML.PARAM then
*                    throws override and generates the deal slip
*Linked With       : Version T24.FUND.SERVICES,REDO.MULTI.TXN
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : T24.FUND.SERVICES                   As          I       Mode
*                    ACCOUNT                             As          I       Mode
*                    CUSTOMER                            As          I       Mode
*                    TFS.TRANSACTION                     As          I       Mode
*                    FT.TXN.TYPE.CONDITION               As          I       Mode
*                    TRANSACTION                         As          I       Mode
*                    TELLER.TRANSACTION                  As          I       Mode
*                    CURRENCY                            As          I       Mode
*                    CUSTOMER.ACCOUNT                    As          I       Mode
*                    ACCT.ENT.TODAY                      As          I       Mode
*                    STMT.ENTRY                          As          I       Mode
*                    STMT.ENTRY.DETAIL                   As          I       Mode
*                    REDO.AML.PARAM                      As          I       Mode
*                    OVERRIDE                            As          I       Mode
*----------------------------------------------------------------------------------------------------------------------
* Modification Details:
* =====================
* Date            Who                 Reference                     Description
* ------          -----               -------------                 -------------
* 22 Jul 2010     Shiva Prasad Y      ODR-2009-10-0318 B.126        Initial Creation
* 08 Oct 2013     Vignesh Kumaar R    PACS00306796                  Commented the RTE forms
* 16 Dec 2014     Vignesh Kumaar R    PACS00392651                  AA OVERPAYMENT THROUGH CASH/CHEQUE
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.TFS.TRANSACTION
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.TRANSACTION
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.TELLER.PARAMETER
    $INSERT I_F.CURRENCY
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.REDO.AML.PARAM
    $INSERT I_F.OVERRIDE
    $INSERT I_GTS.COMMON
    $INSERT I_RC.COMMON
    $INSERT I_F.REDO.AA.OVERPAYMENT ;*

*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    IF OFS$OPERATION EQ 'PROCESS' THEN
        GOSUB OPEN.PARA
        GOSUB PROCESS.PARA
    END
RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.TFS.TRANSACTION = 'F.TFS.TRANSACTION'
    F.TFS.TRANSACTION  = ''
    CALL OPF(FN.TFS.TRANSACTION,F.TFS.TRANSACTION)

    FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.CONDITION  = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION  = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION  = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    FN.CURR = 'F.CURRENCY'
    F.CURR  = ''
    CALL OPF(FN.CURR,F.CURR)

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT  = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.ACCT.ENT.TODAY = 'F.ACCT.ENT.TODAY'
    F.ACCT.ENT.TODAY  = ''
    CALL OPF(FN.ACCT.ENT.TODAY,F.ACCT.ENT.TODAY)

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY  = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.STMT.ENTRY.DETAIL = 'F.STMT.ENTRY.DETAIL'
    F.STMT.ENTRY.DETAIL  = ''
    CALL OPF(FN.STMT.ENTRY.DETAIL,F.STMT.ENTRY.DETAIL)

    FN.REDO.AML.PARAM = 'F.REDO.AML.PARAM'
    F.REDO.AML.PARAM  = ''
    CALL OPF(FN.REDO.AML.PARAM,F.REDO.AML.PARAM)

    FN.OVERRIDE = 'F.OVERRIDE'
    F.OVERRIDE  = ''
    CALL OPF(FN.OVERRIDE,F.OVERRIDE)

    FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
    F.TELLER.PARAMETER = ''

    FN.T24.FUND.SERVICES = 'F.T24.FUND.SERVICES'
    F.T24.FUND.SERVICES = ''
    CALL OPF(FN.T24.FUND.SERVICES,F.T24.FUND.SERVICES)

* Fix for PACS00392651 [AA OVERPAYMENT THROUGH CASH/CHEQUE]

    FN.REDO.AA.OVERPAYMENT = 'F.REDO.AA.OVERPAYMENT'
    F.REDO.AA.OVERPAYMENT = ''
    CALL OPF(FN.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT)

* End of Fix

    PROCESS.GOAHEAD = ''
    REDO.AML.PARAM.ID = 'SYSTEM'
    Y.AMT.FLAG = ''
    Y.TFS.LIST = ''

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB READ.REDO.AML.PARAM
    GOSUB CHECK.TFS.TXN.CODE

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
CHECK.TFS.TXN.CODE:
*******************

    Y.TXN.CODES = R.NEW(TFS.TRANSACTION)
    Y.FLAG  = ''

    Y.TXN.COUNT = DCOUNT(Y.TXN.CODES,@VM)
    Y.COUNT = 1

    LOOP
    WHILE Y.COUNT LE Y.TXN.COUNT
        PROCESS.GOAHEAD = ''
        TFS.TRANSACTION.ID = Y.TXN.CODES<1,Y.COUNT>
        GOSUB READ.TFS.TRANSACTION
        IF R.TFS.TRANSACTION<TFS.TXN.INTERFACE.TO> NE 'TT' AND R.TFS.TRANSACTION<TFS.TXN.INTERFACE.TO> NE 'FT' THEN
            Y.COUNT += 1
        END ELSE
            Y.TXN.TYPE = R.TFS.TRANSACTION<TFS.TXN.INTERFACE.TO>
            GOSUB GET.DETAILS
            Y.COUNT += 1
        END
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
************
GET.DETAILS:
************
    IF Y.TXN.TYPE EQ 'TT' THEN
        TRANSACTION.ID = R.TFS.TRANSACTION<TFS.TXN.INTERFACE.AS>
    END ELSE
        FT.TXN.TYPE.CONDITION.ID = R.TFS.TRANSACTION<TFS.TXN.INTERFACE.AS>
        GOSUB READ.FT.TXN.TYPE.CONDITION
        TRANSACTION.ID = R.FT.TXN.TYPE.CONDITION<FT6.TXN.CODE.DR>
    END
    TELLER.TRANSACTION.ID = TRANSACTION.ID
    GOSUB READ.TELLER.TRANSACTION
    Y.TT.TRANS.ID.1 = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1>
    Y.TT.TRANS.ID.2 = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.2>
    GOSUB CONFIRM.AML.CHECK
    IF PROCESS.GOAHEAD THEN
        GOSUB CHECK.TT.TRANS.CCY
    END

RETURN
*----------------------------------------------------------------------------------------------------------
CONFIRM.AML.CHECK:
*-----------------------------------------------------------------------------------------------------------
    CALL CACHE.READ(FN.TRANSACTION, Y.TT.TRANS.ID.1, R.TRANSACTION, TRANS.ERR) ;*R22 Auto Conversion
    WTR.AML.CHECK = R.TRANSACTION<AC.TRA.LOCAL.REF><1,LOC.L.TR.AML.CHECK.POS>
    IF WTR.AML.CHECK EQ 'Y' THEN
        PROCESS.GOAHEAD = "1"
    END ELSE
        CALL CACHE.READ(FN.TRANSACTION, Y.TT.TRANS.ID.2, R.TRANSACTION, TRANS.ERR) ;*R22 Auto Conversion
        WTR.AML.CHECK = R.TRANSACTION<AC.TRA.LOCAL.REF><1,LOC.L.TR.AML.CHECK.POS>
        IF WTR.AML.CHECK EQ 'Y' THEN
            PROCESS.GOAHEAD = "1"
        END
    END
RETURN
*--------------------------------------------------------------------------------------------------------
*******************
CHECK.TT.TRANS.CCY:
*******************

    Y.TOT.TXN.AMT = R.NEW(TFS.AMOUNT)<1,Y.COUNT>
    Y.VAR.CCY.CHECK = R.NEW(TFS.CURRENCY)<1,Y.COUNT>
    IF Y.VAR.CCY.CHECK NE LCCY THEN
        Y.VAR.CCY.CHECK = R.NEW(TFS.CURRENCY)<1,Y.COUNT>
        GOSUB READ.CURRENCY
        Y.AML.BUY.RATE = R.CURR<EB.CUR.LOCAL.REF,LOC.L.CU.AMLBUY.RT.POS>
        Y.TOT.TXN.AMT = Y.TOT.TXN.AMT * Y.AML.BUY.RATE
    END
    IF NOT(Y.AMT.FLAG) THEN
        GOSUB CHECK.CUS.ACCOUNT
        GOSUB CHECK.AML.AMOUNT
    END
RETURN
*------------------*
GET.OVERPYMT.AMOUNT:
*------------------*
* Fix for PACS00392651 [AA OVERPAYMENT THROUGH CASH/CHEQUE]

    Y.GET.OVER.PAY.AMT = 0
    SEL.CMD.OVER = ''
    SEL.LIST.OVER = ''

    SEL.CMD.OVER = 'SELECT ':FN.REDO.AA.OVERPAYMENT:' WITH @ID LIKE ':CUSTOMER.ID:'.':TODAY:'... AND PAYMENT.METHOD EQ CASH AND STATUS NE REVERSADO'
    CALL EB.READLIST(SEL.CMD.OVER,SEL.LIST.OVER,'','',SEL.ERR)
    LOOP
        REMOVE OVER.ID FROM SEL.LIST.OVER SETTING OVER.POS
    WHILE OVER.ID:OVER.POS
        CALL F.READ(FN.REDO.AA.OVERPAYMENT,OVER.ID,R.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT,REDO.AA.OVERPAYMENT.ERR)
        Y.GET.OVER.PAY.AMT += R.REDO.AA.OVERPAYMENT<REDO.OVER.AMOUNT>

    REPEAT
RETURN

*--------------------------------------------------------------------------------------------------------
******************
CHECK.CUS.ACCOUNT:
******************
    ACCOUNT.ID = R.NEW(TFS.SURROGATE.AC)<1,Y.COUNT>
    GOSUB READ.ACCOUNT
    CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
    IF CUSTOMER.ID THEN
        GOSUB GET.CUST.ACCT.TODAY.TXN.AMOUNT
    END ELSE
        GOSUB GET.INT.ACC.TODAY.TXN.AMOUNT
    END
    GOSUB GET.OVERPYMT.AMOUNT
    Y.TOT.TODAY.AMT += Y.GET.OVER.PAY.AMT
RETURN
*--------------------------------------------------------------------------------------------------------
********************************
GET.CUST.ACCT.TODAY.TXN.AMOUNT:
********************************

    CUSTOMER.ACCOUNT.ID = CUSTOMER.ID
    GOSUB READ.CUSTOMER.ACCOUNT
    LOOP
        REMOVE ACCT.ENT.TODAY.ID FROM R.CUSTOMER.ACCOUNT SETTING Y.ACC.POS
    WHILE ACCT.ENT.TODAY.ID : Y.ACC.POS

        GOSUB LOOP.STMT.ENTRY.DETAILS
    REPEAT

    IF NOT(Y.AMT.FLAG) THEN
        Y.AMT.FLAG = 1
        Y.TOT.TODAY.AMT  = ABS(Y.TOT.TODAY.AMT)
        Y.TOT.TODAY.AMT += Y.TOT.TXN.AMT
        Y.AMM <-1> = ID.NEW:'***':Y.TOT.TXN.AMT
    END

RETURN
*--------------------------------------------------------------------------------------------------------
************************
LOOP.STMT.ENTRY.DETAILS:
************************

    GOSUB READ.ACCT.ENT.TODAY
    CALL F.READ(FN.ACCOUNT,ACCT.ENT.TODAY.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    WACCT.CCY = R.ACCOUNT<AC.CURRENCY>
    IF WACCT.CCY NE LCCY THEN
        GOSUB GET.AMLBUY.RATE
    END
    LOOP
        REMOVE STMT.ENTRY.ID FROM R.ACCT.ENT.TODAY SETTING Y.ENT.POS
    WHILE STMT.ENTRY.ID : Y.ENT.POS
        GOSUB READ.STMT.ENTRY
        IF NOT(R.STMT.ENTRY) THEN
            STMT.ENTRY.DETAIL.ID = STMT.ENTRY.ID
            GOSUB READ.STMT.ENTRY.DETAIL
        END
        Y.STMT.TXN.CODE = R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
        Y.STMT.VAL.DATE = R.STMT.ENTRY<AC.STE.VALUE.DATE>
        IF Y.STMT.VAL.DATE EQ TODAY THEN
            R.TRANSACTION = ''; TRANS.ERR = '' ; WTR.AML.CHECK = ''
            GOSUB GET.TOTAL.AMOUNT
        END
    REPEAT
RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.TOTAL.AMOUNT:
*****************

    CALL CACHE.READ(FN.TRANSACTION, Y.STMT.TXN.CODE, R.TRANSACTION, TRANS.ERR) ;*R22 Auto Conversion
    WTR.AML.CHECK = R.TRANSACTION<AC.TRA.LOCAL.REF><1,LOC.L.TR.AML.CHECK.POS>
    IF WTR.AML.CHECK EQ 'Y' THEN
        IF Y.VAR.CCY.CHECK EQ LCCY THEN
            Y.TOT.TODAY.AMT += R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
        END ELSE
            Y.TOT.TODAY.AMT += R.STMT.ENTRY<AC.STE.AMOUNT.FCY> * CUR.AMLBUY.RATE
        END
    END ELSE
        GET.TFS.ID = R.STMT.ENTRY<AC.STE.THEIR.REFERENCE>
        GOSUB GET.TFS.TOTAL
    END
RETURN

*-----------------------------------------------------------------------------------------------------------------------
GET.TFS.TOTAL:
*-----------------------------------------------------------------------------------------------------------------------

    IF GET.TFS.ID[1,5] EQ 'T24FS' THEN
        CALL F.READ(FN.T24.FUND.SERVICES,GET.TFS.ID,R.T24.FUND.SERVICES,F.T24.FUND.SERVICES,TFS.ERR)

        LOCATE GET.TFS.ID IN Y.TFS.LIST SETTING POS THEN
            RETURN
        END
        Y.TFS.LIST <-1> = GET.TFS.ID
        Y.TFS.TXN.CODES = R.T24.FUND.SERVICES<TFS.TRANSACTION>
        Y.TFS.TXN.COUNT = DCOUNT(Y.TFS.TXN.CODES,@VM)
        Y.TFS.COUNT = 1

        LOOP
        WHILE Y.TFS.COUNT LE Y.TFS.TXN.COUNT
            TFS.TRANSACTION.ID = Y.TFS.TXN.CODES<1,Y.TFS.COUNT>

            IF TFS.TRANSACTION.ID EQ 'CASHDEPD' THEN

                Y.TOT.TODAY.AMT += R.T24.FUND.SERVICES<TFS.AMOUNT,Y.TFS.COUNT>
                Y.AMM<-1> = GET.TFS.ID:'***':R.T24.FUND.SERVICES<TFS.AMOUNT,Y.TFS.COUNT>

            END
            Y.TFS.COUNT += 1 ;*R22 Auto Conversion
        REPEAT
    END
RETURN

*-------------------------------------------------------------------------------------------------------------
GET.AMLBUY.RATE:
*-------------------------------------------------------------------------------------------------------------
    CALL CACHE.READ(FN.CURR, WACCT.CCY, R.CURR, CURR.ERR) ;*R22 Auto Conversion
    CUR.AMLBUY.RATE = R.CURR<EB.CUR.LOCAL.REF,LOC.L.CU.AMLBUY.RT.POS>
RETURN
*--------------------------------------------------------------------------------------------------------
* ===========================
GET.INT.ACC.TODAY.TXN.AMOUNT:
* ===========================
*
    VAR.CATEGORY = ACCOUNT.ID[4,5]
    VAR.ID.COMPANY = ID.COMPANY
    CALL CACHE.READ(FN.TELLER.PARAMETER,VAR.ID.COMPANY,R.TELLER.PARAMETER,TELL.PARA.ERR)
    VAR.TRAN.CAT = R.TELLER.PARAMETER<TT.PAR.TRAN.CATEGORY>
    CHANGE @VM TO @FM IN VAR.TRAN.CAT
    LOCATE VAR.CATEGORY IN VAR.TRAN.CAT SETTING POS.CAT THEN
        Y.TOT.TODAY.AMT = Y.TOT.TXN.AMT
    END ELSE
        VAR.CATEGORY1 = R.NEW(TFS.ACCOUNT.DR)<1,Y.COUNT>
        VAR.CATEGORY1 = VAR.CATEGORY1[4,5]
        LOCATE VAR.CATEGORY1 IN VAR.TRAN.CAT SETTING POS.CAT1 THEN
            Y.TOT.TODAY.AMT = Y.TOT.TXN.AMT
        END
    END
RETURN
*-----------------------------------------------------------------------------------------------------------
CHECK.AML.AMOUNT:
******************
    IF Y.TOT.TODAY.AMT GE R.REDO.AML.PARAM<AML.PARAM.AMT.LIMIT.LCY> THEN

*GOSUB ANALISE.OVERRIDE.MESSAGE

        CURR.NO = DCOUNT(R.NEW(TFS.OVERRIDE),@VM)+1
        TEXT='AML.TXN.AMT.EXCEED'
        CALL STORE.OVERRIDE(CURR.NO)
        IF R.NEW(TFS.LOCAL.REF)<1,LOC.L.RTE.FORM.POS> EQ 'YES' THEN
*IF VAR.RTE.CHK EQ 'YES' THEN
            Y.OVER.LIST = OFS$OVERRIDES

* Commented as RTE form will be produced in the REDO.GET.SPOOL enquiry itself
*
*            IF Y.OVER.LIST THEN
*                IF Y.OVER.LIST<2,1> EQ 'YES' THEN
*                    LOCATE 'NOANSWER' IN OFS$WARNINGS<2,1> SETTING POS ELSE
*                        OFS$DEAL.SLIP.PRINTING = 1
*                        CALL PRODUCE.DEAL.SLIP('AML.TFS.RTE.FOR')
*                        Y.HID = C$LAST.HOLD.ID
*                        CALL REDO.V.AUT.RTE.REPRINT(Y.HID)
*                        PRT.ADVICED.PRODUCED = ""
*                    END
*                END
*            END ELSE
*                LOCATE 'NOANSWER' IN OFS$WARNINGS<2,1> SETTING POS ELSE
*                    OFS$DEAL.SLIP.PRINTING = 1
*                    CALL PRODUCE.DEAL.SLIP('AML.TFS.RTE.FOR')
*                    Y.HID = C$LAST.HOLD.ID
*                    CALL REDO.V.AUT.RTE.REPRINT(Y.HID)
*                    PRT.ADVICED.PRODUCED = ""
*                END
*
*            END
*        END
*
* End of Fix
        END
    END
RETURN
*------------------------------------------------------------------------------------------------------------
***************************
ANALISE.OVERRIDE.MESSAGE:
***************************
    V$FUNCTION = 'I'
    OVERRIDE.ID='AML.TXN.AMT.EXCEED'
    GOSUB READ.OVERRIDE

* Getting the Override Message
*
    VAR.MESSAGE1 = R.OVERRIDE<EB.OR.MESSAGE,1,2>
    VAR.MESSAGE2 = 'YES'
*
*  Getting the Override Message Values
*
    VAR.OFS.OVERRIDE1 = OFS$OVERRIDES<1>
    VAR.OFS.OVERRIDE2 = OFS$OVERRIDES<2>
*
*  Converting to FM for locate Purpose
*
    CHANGE @VM TO @FM IN VAR.OFS.OVERRIDE1
    CHANGE @VM TO @FM IN VAR.OFS.OVERRIDE2
*
*  Checking FOR the override MESSAGE
*
    VAR.RTE.CHK = ""
*
    LOCATE VAR.MESSAGE1 IN VAR.OFS.OVERRIDE1 SETTING POS1 THEN
        R.NEW(TFS.LOCAL.REF)<1,LOC.L.RTE.FORM.POS> = 'YES'
    END ELSE
        POS1 = ''
    END
*
    LOCATE VAR.MESSAGE2 IN VAR.OFS.OVERRIDE2 SETTING POS2 THEN
        VAR.RTE.CHK = R.NEW(TFS.LOCAL.REF)<1,LOC.L.RTE.FORM.POS>
    END
*
RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
* In this para of the code, file ACCOUNT is read
    R.ACCOUNT  = ''
    ACCOUNT.ER = ''
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
READ.TFS.TRANSACTION:
*********************
* In this para of the code, file TFS.TRANSACTION is read
    R.TFS.TRANSACTION  = ''
    TFS.TRANSACTION.ER = ''
    CALL F.READ(FN.TFS.TRANSACTION,TFS.TRANSACTION.ID,R.TFS.TRANSACTION,F.TFS.TRANSACTION,TFS.TRANSACTION.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
***************************
READ.FT.TXN.TYPE.CONDITION:
***************************
* In this para of the code, file FT.TXN.TYPE.CONDITION is read
    R.FT.TXN.TYPE.CONDITION  = ''
    FT.TXN.TYPE.CONDITION.ER = ''
    CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION, FT.TXN.TYPE.CONDITION.ID, R.FT.TXN.TYPE.CONDITION, FT.TXN.TYPE.CONDITION.ER) ;*R22 Auto Conversion

RETURN
*--------------------------------------------------------------------------------------------------------
************************
READ.TELLER.TRANSACTION:
************************
* In this para of the code, file TELLER.TRANSACTION is read
    R.TELLER.TRANSACTION  = ''
    TELLER.TRANSACTION.ER = ''
    CALL CACHE.READ(FN.TELLER.TRANSACTION, TELLER.TRANSACTION.ID, R.TELLER.TRANSACTION, TELLER.TRANSACTION.ER) ;*R22 Auto Conversion

RETURN
*--------------------------------------------------------------------------------------------------------
**************
READ.CURRENCY:
**************
* In this para of the code, file CURRENCY is read
    R.CURR  = ''
    CURRENCY.ER = ''
    CALL CACHE.READ(FN.CURR, Y.VAR.CCY.CHECK, R.CURR, CURRENCY.ER) ;*R22 Auto Conversion

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
READ.CUSTOMER.ACCOUNT:
**********************
* In this para of the code, file CUSTOMER.ACCOUNT is read
    R.CUSTOMER.ACCOUNT  = ''
    CUSTOMER.ACCOUNT.ER = ''
    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUSTOMER.ACCOUNT.ID,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,CUSTOMER.ACCOUNT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
********************
READ.ACCT.ENT.TODAY:
********************
* In this para of the code, file ACCT.ENT.TODAY is read
    R.ACCT.ENT.TODAY  = ''
    ACCT.ENT.TODAY.ER = ''
    CALL F.READ(FN.ACCT.ENT.TODAY,ACCT.ENT.TODAY.ID,R.ACCT.ENT.TODAY,F.ACCT.ENT.TODAY,ACCT.ENT.TODAY.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
****************
READ.STMT.ENTRY:
****************
* In this para of the code, file STMT.ENTRY is read
    R.STMT.ENTRY  = ''
    STMT.ENTRY.ER = ''
    CALL F.READ(FN.STMT.ENTRY,STMT.ENTRY.ID,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENTRY.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
***********************
READ.STMT.ENTRY.DETAIL:
***********************
* In this para of the code, file STMT.ENTRY.DETAIL is read
    R.STMT.ENTRY = ''
    STMT.ENTRY.DETAIL.ER = ''
    CALL F.READ(FN.STMT.ENTRY.DETAIL,STMT.ENTRY.DETAIL.ID,R.STMT.ENTRY,F.STMT.ENTRY.DETAIL,STMT.ENTRY.DETAIL.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
********************
READ.REDO.AML.PARAM:
********************
* In this para of the code, file REDO.AML.PARAM is read
    R.REDO.AML.PARAM  = ''
    REDO.AML.PARAM.ER = ''
    CALL CACHE.READ(FN.REDO.AML.PARAM,REDO.AML.PARAM.ID,R.REDO.AML.PARAM,REDO.AML.PARAM.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
**************
READ.OVERRIDE:
**************
* In this para of the code, file OVERRIDE is read
    R.OVERRIDE  = ''
    OVERRIDE.ER = ''
    CALL CACHE.READ(FN.OVERRIDE, OVERRIDE.ID, R.OVERRIDE, OVERRIDE.ER) ;*R22 Auto Conversion

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'TRANSACTION':@FM:'CURRENCY':@FM:'T24.FUND.SERVICES'
    FLD.ARRAY  = 'L.TR.AML.CHECK':@FM:'L.CU.AMLBUY.RT':@FM:'L.RTE.FORM'
    FLD.POS    = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.TR.AML.CHECK.POS = FLD.POS<1,1>
    LOC.L.CU.AMLBUY.RT.POS = FLD.POS<2,1>
    LOC.L.RTE.FORM.POS     = FLD.POS<3,1>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
