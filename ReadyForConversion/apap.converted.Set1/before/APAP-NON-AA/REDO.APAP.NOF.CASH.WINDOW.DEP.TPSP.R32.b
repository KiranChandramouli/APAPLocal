*-----------------------------------------------------------------------------
* <Rating>-139</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DEP.TPSP.R32(Y.CCY.LIST,Y.TT.IDS,Y.TT.PARAM.REC,Y.COMPANY.LIST,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DEP.TPSP.R32
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.DEP.TPSP is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.DEP.SAV.CUR, this routine is used to fetch THIRD PARTY
*                    PAYMENTS details
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DEP
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*                    Y.TT.IDS       - This variable holds the teller ids
*                    Y.TT.PARAM.REC - Holds the teller and parameter records
*Out Parameter     : Y.FINAL.ARRAY  - THe final Array to be passed out
*                    Y.CCY.LIST     - This variable holds the processed currency list
*                    Y.TT.LIST      - This variable holds the processed TELLER records
*                    Y.COMPANY.LIST - This variable holds the list of companies processed
*Files  Used       : TELLER                           As              I               Mode
*                    ACCOUNT                          As              I               Mode
*                    REDO.H.TELLER.TXN.CODES          As              I               Mode
*                    TELLER.TRANSACTION               As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 15 Jun 2011       Marimuthu S                ODR-2011-04-0007 32         Changes made in REDO.APAP.NOF.CASH.WINDOW.DEP.TPSP
*
*********************************************************************************************************
    $INCLUDE I_COMMON
    $INCLUDE I_EQUATE
    $INCLUDE I_ENQUIRY.COMMON
    $INCLUDE I_F.TELLER
    $INCLUDE TAM.BP I_F.REDO.H.TELLER.TXN.CODES
    $INCLUDE I_F.TELLER.TRANSACTION
    $INCLUDE I_F.ACCOUNT
    $INCLUDE I_F.FUNDS.TRANSFER

**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB OPEN.PARA
    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB PROCESS.PARA
    RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION  = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.HST = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HST  = ''
    CALL OPF(FN.ACCOUNT.HST,F.ACCOUNT.HST)

    FN.TELLER = 'F.TELLER'
    F.TELLER  = ''
    CALL OPF(FN.TELLER,F.TELLER)
    RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    R.TELLER                     = FIELD(Y.TT.PARAM.REC,'##',1)
    R.REDO.ADMIN.CHQ.PARAM       = FIELD(Y.TT.PARAM.REC,'##',2)
    R.REDO.MANAGER.CHQ.PARAM     = FIELD(Y.TT.PARAM.REC,'##',3)
    R.CERTIFIED.CHEQUE.PARAMETER = FIELD(Y.TT.PARAM.REC,'##',4)
    R.REDO.H.TELLER.TXN.CODES    = FIELD(Y.TT.PARAM.REC,'##',5)
    GOSUB GET.TXN.CODE.DETAILS

    Y.CACC.POS = '';   YTT.COMP.NME = ''; YTT.MET.PAY = ''; YTT.PARTY.NME = ''
    LOCATE R.TELLER<TT.TE.ACCOUNT.1>[4,5] IN Y.THRD.PARTY<1> SETTING Y.CACC.POS ELSE
        LOCATE R.TELLER<TT.TE.ACCOUNT.2>[4,5] IN Y.THRD.PARTY<1> SETTING Y.CACC.POS ELSE
            RETURN
        END
    END

    Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>
    YTT.MARKER = R.TELLER<TT.TE.DR.CR.MARKER>
    Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
    IF YTT.MARKER EQ 'CREDIT' AND R.TELLER<TT.TE.CURRENCY.1> NE LCCY THEN
        Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
    END
    IF NOT(Y.TT.AMT) THEN
        IF Y.TT.CCY EQ LCCY THEN
            Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
        END ELSE
            Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
        END
    END

    YTT.COMP.NME = R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.CMPNY.NAME.POS>
    YTT.MET.PAY = R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.MET.OF.PAY.POS>
    YTT.PARTY.NME = R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.PARTY.NAME.POS>
    IF NOT(YTT.COMP.NME) AND YTT.PARTY.NME THEN
* PACS00708935 - S
*        YTT.COMP.NME = "OTHRA TERCEROS"
        YTT.COMP.NME = "EPAYIT"
* PACS00708935 - E
    END

    Y.START.POS    = 20; Y.CASH.FLAG = ''; Y.CHQ.FLAG = '' ; Y.TFR.FLAG = ''
    LOCATE YTT.COMP.NME IN Y.COMPANY.LIST<1> SETTING Y.COMP.POS THEN
        Y.VM.POS =  Y.COMP.POS + Y.START.POS
    END ELSE
        Y.COMPANY.LIST<-1> = YTT.COMP.NME
        Y.VM.POS           = DCOUNT(Y.COMPANY.LIST,FM) + Y.START.POS
    END

    IF YTT.MET.PAY EQ 'CASH' OR YTT.MET.PAY EQ 'EFECTIVO' THEN
        GOSUB GET.CASH.DETAILS
        RETURN
    END

    IF YTT.MET.PAY EQ 'CHEQUE' THEN
        GOSUB GET.CHEQUE.DETAILS
        RETURN
    END
    GOSUB GET.TRANSFER.DETAILS

    RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.CASH.DETAILS:
*****************
* In this para of the code, the THIRD PARTY PAYMENTS done through CASH are fetched and the details are extracated for display
    Y.CASH.FLAG = 1
    Y.ADD.AMT   = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
    RETURN
*--------------------------------------------------------------------------------------------------------
*******************
GET.CHEQUE.DETAILS:
*******************
* In this para of the code, the THIRD PARTY PAYMENTS done through CHEQUE are fetched and the details are extracated for display
    IF NOT(R.TELLER<TT.TE.CHEQUE.NUMBER>) THEN
        RETURN
    END

*    TELLER.TRANSACTION.ID = R.TELLER<TT.TE.TRANSACTION.CODE>
*    LOCATE TELLER.TRANSACTION.ID IN Y.CHQ.TXN.CODES<1> SETTING Y.CHQ.POS ELSE
*        RETURN
*    END

    Y.CHQ.FLAG = 1
    Y.ADD.AMT  = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
    RETURN
*--------------------------------------------------------------------------------------------------------
*********************
GET.TRANSFER.DETAILS:
*********************
* In this para of the code, the THIRD PARTY PAYMENTS done through TRANSFER are fetched and the details are extracated for display

    IF YTT.MET.PAY NE 'TRANSFER' AND YTT.MET.PAY NE 'TRANSFERENCIA' THEN
        RETURN
    END

    IF R.TELLER<TT.TE.DR.CR.MARKER> EQ 'DEBIT' THEN
        ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.2>
    END ELSE
        ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.1>
    END

    GOSUB READ.ACCOUNT
    IF NOT(R.ACCOUNT<AC.CUSTOMER>) THEN
        RETURN
    END

    Y.TFR.FLAG = 1
    Y.ADD.AMT  = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
    RETURN
*--------------------------------------------------------------------------------------------------------
******************
AMEND.FINAL.ARRAY:
******************
* In this para of the code, the Y.FINAL.ARRAY is amended with increment in the total number of transactions
** and the amount is added up

    LOCATE Y.TT.CCY IN Y.CCY.LIST<1> SETTING Y.CCY.POS ELSE
        Y.CCY.LIST<-1> = Y.TT.CCY
        Y.CCY.POS = DCOUNT(Y.CCY.LIST,FM)
    END

    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,2> = YTT.COMP.NME

    IF Y.CASH.FLAG THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4> += Y.ADD.AMT
    END

    IF Y.CHQ.FLAG THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5> += Y.ADD.AMT
    END

    IF Y.TFR.FLAG THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6> += Y.ADD.AMT
    END

    Y.TT.LIST<-1> = Y.TT.IDS
    RETURN
*--------------------------------------------------------------------------------------------------------
*********************
GET.TXN.CODE.DETAILS:
*********************
* In this para of the code, the TXN.CODES for the payment type and transaction type are segregated
    Y.TT.TXN.CODES = R.REDO.H.TELLER.TXN.CODES<TT.TXN.PAYMENT.MODE>
    LOCATE 'CASH' IN Y.TT.TXN.CODES<1,1> SETTING Y.CASH.POS THEN
        Y.CASH.TXN.TYPE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.TYPE,Y.CASH.POS>
        Y.CASH.TXN.CODE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.CODE,Y.CASH.POS>
        CHANGE SM TO FM IN Y.CASH.TXN.TYPE
        CHANGE SM TO FM IN Y.CASH.TXN.CODE
    END

    LOCATE 'CHEQUE' IN Y.TT.TXN.CODES<1,1> SETTING Y.CHQ.POS THEN
        Y.CHQ.TXN.TYPE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.TYPE,Y.CHQ.POS>
        Y.CHQ.TXN.CODE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.CODE,Y.CHQ.POS>
        CHANGE SM TO FM IN Y.CHQ.TXN.TYPE
        CHANGE SM TO FM IN Y.CHQ.TXN.CODE
    END

    LOCATE 'TRANSFER' IN Y.TT.TXN.CODES<1,1> SETTING Y.TFR.POS THEN
        Y.TFR.TXN.TYPE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.TYPE,Y.TFR.POS>
        Y.TFR.TXN.CODE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.CODE,Y.TFR.POS>
        CHANGE SM TO FM IN Y.TFR.TXN.TYPE
        CHANGE SM TO FM IN Y.TFR.TXN.CODE
    END

    Y.THRD.PARTY    = R.REDO.H.TELLER.TXN.CODES<TT.TXN.AC.THIRD.PARTY>
    CHANGE VM TO FM IN Y.THRD.PARTY
    RETURN

************
READ.TELLER:
************
* In this para of the code, file TELLER is read
    R.TELLER  = ''; TELLER.ER = ''
    CALL F.READ(FN.TELLER,TELLER.ID,R.TELLER,F.TELLER,TELLER.ER)
    RETURN
*--------------------------------------------------------------------------------------------------------
************************
READ.TELLER.TRANSACTION:
************************
* In this para of the code, file TELLER.TRANSACTION is read
    R.TELLER.TRANSACTION  = '';    TELLER.TRANSACTION.ER = ''
    CALL F.READ(FN.TELLER.TRANSACTION,TELLER.TRANSACTION.ID,R.TELLER.TRANSACTION,F.TELLER.TRANSACTION,TELLER.TRANSACTION.ER)
    RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
* In this para of the code, file ACCOUNT is read
    R.ACCOUNT  = '';    ACCOUNT.ER = ''
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)
    IF NOT(R.ACCOUNT) THEN
        ACCOUNT.IDH = ACCOUNT.ID; ERR.AC = ''
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HST,ACCOUNT.IDH,R.ACCOUNT,ERR.AC)
    END
    RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'TELLER':FM:'FUNDS.TRANSFER'
    FLD.ARRAY  = 'L.TT.CMPNY.NAME':VM:'L.TT.MET.OF.PAY':VM:'L.TT.BILL.COND':VM:'L.DEBIT.AMOUNT':VM:'L.CREDIT.AMOUNT':VM:'L.TT.PARTY.NAME':FM:'CERT.CHEQUE.NO'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TT.CMPNY.NAME.POS = FLD.POS<1,1>
    LOC.L.TT.MET.OF.PAY.POS = FLD.POS<1,2>
    LOC.L.TT.BILL.COND.POS = FLD.POS<1,3>
    LOC.L.DEBIT.AMOUNT.POS = FLD.POS<1,4>
    LOC.L.CREDIT.AMOUNT.POS = FLD.POS<1,5>
    LOC.L.TT.PARTY.NAME.POS = FLD.POS<1,6>
    LOC.CERT.CHEQUE.NO.POS = FLD.POS<2,1>
    RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
