* @ValidationCode : MjoxMzg0ODE3NTc6Q3AxMjUyOjE2ODE3MTc2OTAyNzU6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 13:18:10
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
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.WIT.DB.CARD(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,R.REDO.H.TELLER.TXN.CODES,Y.FINAL.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.WIT.DB.CARD
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.WIT.DB.CARD is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.WIT.SAV.CUR, this routine is used to fetch the debit card
*                    details for WITHDRAWALS
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.WIT
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*                    TELLER.ID      - Holds the teller ID
*                    Y.TT.PARAM.REC - Holds the teller and parameter records
*                    R.REDO.H.TELLER.TXN.CODES - Holds the parameter record
*Out Parameter     : Y.FINAL.ARRAY - THe final Array to be passed out
*                    Y.CCY.LIST    - This variable holds the processed currency list
*Files  Used       : TELLER                           As              I               Mode
*                    REDO.ADMIN.CHQ.PARAM             As              I               Mode
*                    REDO.MANAGER.CHQ.PARAM           As              I               Mode
*                    CERTIFIED.CHEQUE.PARAMETER       As              I               Mode
*                    REDO.H.TELLER.TXN.CODES          As              I               Mode
*                    TELLER.TRANSACTION               As              I               Mode
*                    TRANSACTION                      As              I               Mode
*                    ACCOUNT                          As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 11 Mar 2011       Shiva Prasad Y              ODR-2010-03-0086 35         Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FMto@FM, VMto@VM,F.READ to CACHE.READ
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.H.TELLER.TXN.CODES
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.MANAGER.CHQ.PARAM
    $INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.TRANSACTION
    $INSERT I_F.ACCOUNT
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB OPEN.PARA
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

    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION  = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

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

    Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>
    GOSUB FIND.MULTI.LOCAL.REF

    YTT.MARKER = R.TELLER<TT.TE.DR.CR.MARKER>
    Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
    IF YTT.MARKER EQ 'CREDIT' AND R.TELLER<TT.TE.CURRENCY.1> NE LCCY THEN
        Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
    END

    IF Y.TT.CCY EQ LCCY THEN
        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
    END ELSE
        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
    END
    GOSUB GET.TXN.CODE.DETAILS
    GOSUB CHECK.DEBIT.CARD.TXNS

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
        CHANGE @SM TO @FM IN Y.CASH.TXN.TYPE
        CHANGE @SM TO @FM IN Y.CASH.TXN.CODE
    END

    LOCATE 'CHEQUE' IN Y.TT.TXN.CODES<1,1> SETTING Y.CHQ.POS THEN
        Y.CHQ.TXN.TYPE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.TYPE,Y.CHQ.POS>
        Y.CHQ.TXN.CODE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.CODE,Y.CHQ.POS>
        CHANGE @SM TO @FM IN Y.CHQ.TXN.TYPE
        CHANGE @SM TO @FM IN Y.CHQ.TXN.CODE
    END

    LOCATE 'TRANSFER' IN Y.TT.TXN.CODES<1,1> SETTING Y.TFR.POS THEN
        Y.TFR.TXN.TYPE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.TYPE,Y.TFR.POS>
        Y.TFR.TXN.CODE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.CODE,Y.TFR.POS>
        CHANGE @SM TO @FM IN Y.TFR.TXN.TYPE
        CHANGE @SM TO @FM IN Y.TFR.TXN.CODE
    END

    Y.CASH.CATEG    = R.REDO.H.TELLER.TXN.CODES<TT.TXN.CASH.ACC.CATEG>
    CHANGE @VM TO @FM IN Y.CASH.CATEG

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
CHECK.DEBIT.CARD.TXNS:
**********************
* In this para of the code, the debit card transactions are being considered

    IF NOT(R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.POS.AUTHNM.POS>) THEN
        RETURN
    END

    Y.TT.CCY  = R.TELLER<TT.TE.CURRENCY.1>

    IF Y.TT.CCY EQ LCCY THEN
        Y.TT.AMT  = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
    END ELSE
        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
    END

    GOSUB CHECK.TXN.CODE
    IF Y.CASH.WIT.FLAG OR Y.CHQ.WIT.FLAG OR Y.TFR.WIT.FLAG ELSE
        RETURN
    END

    GOSUB GET.CR.DR.ACCOUNT

    IF Y.CASH.WIT.FLAG THEN
        GOSUB CHECK.DC.CASH
    END

    IF Y.CHQ.WIT.FLAG THEN
        GOSUB CHECK.DC.CHQ
    END

    IF Y.TFR.WIT.FLAG THEN
        GOSUB CHECK.DC.TFR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
***************
CHECK.TXN.CODE:
***************
* In this para of the code, the TXN.CODE is checked with transaction type and payment mode
* In this para of the code, the TXN.CODE is checked with transaction type and payment mode
    Y.CASH.WIT.FLAG = '' ; Y.CHQ.EIT.FLAG  = ''  ;  Y.TFR.WIT.FLAG = ''

    Y.TT.TXN.CODE = R.TELLER<TT.TE.TRANSACTION.CODE>

    LOCATE Y.TT.TXN.CODE IN Y.CASH.TXN.CODE<1> SETTING Y.TXN.POS THEN
        IF Y.CASH.TXN.TYPE<Y.TXN.POS> EQ 'WITHDRAWALS' THEN
            Y.CASH.WIT.FLAG = 1
        END
        IF Y.CASH.TXN.TYPE<Y.TXN.POS> EQ 'DEPOS.WITHDRW' THEN
            Y.CASH.WIT.FLAG = 1
        END
    END

    LOCATE Y.TT.TXN.CODE IN Y.CHQ.TXN.CODE<1> SETTING Y.TXN.POS THEN
        IF Y.CHQ.TXN.TYPE<Y.TXN.POS> EQ 'WITHDRAWALS' THEN
            Y.CHQ.WIT.FLAG = 1
        END
        IF Y.CHQ.TXN.TYPE<Y.TXN.POS> EQ 'DEPOS.WITHDRW' THEN
            Y.CHQ.WIT.FLAG = 1
        END
    END

    LOCATE Y.TT.TXN.CODE IN Y.TFR.TXN.CODE<1> SETTING Y.TXN.POS THEN
        IF Y.TFR.TXN.TYPE<Y.TXN.POS> EQ 'WITHDRAWALS' THEN
            Y.TFR.WIT.FLAG = 1
        END
        IF Y.TFR.TXN.TYPE<Y.TXN.POS> EQ 'DEPOS.WITHDRW' THEN
            Y.TFR.WIT.FLAG = 1
        END
    END
RETURN
*--------------------------------------------------------------------------------------------------------
******************
GET.CR.DR.ACCOUNT:
******************
    TELLER.TRANSACTION.ID = R.TELLER<TT.TE.TRANSACTION.CODE>
    GOSUB READ.TELLER.TRANSACTION
    IF NOT(R.TELLER.TRANSACTION) THEN
        RETURN
    END

    TRANSACTION.ID = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1>
    GOSUB READ.TRANSACTION

    IF R.TRANSACTION<AC.TRA.DEBIT.CREDIT.IND> EQ 'CREDIT' THEN
        Y.CR.ACCOUNT = R.TELLER<TT.TE.ACCOUNT.1>
    END ELSE
        Y.CR.ACCOUNT = R.TELLER<TT.TE.ACCOUNT.2>
    END

RETURN
*--------------------------------------------------------------------------------------------------------
**************
CHECK.DC.CASH:
**************
* In this para of the code, the debit card CASH transactions are processed
    LOCATE Y.CR.ACCOUNT[4,5] IN Y.CASH.CATEG<1> SETTING Y.CACC.POS ELSE
        RETURN
    END

    Y.VM.POS  = 4
    Y.ADD.AMT = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY

RETURN
*--------------------------------------------------------------------------------------------------------
*************
CHECK.DC.CHQ:
*************
* In this para of the code, the debit card CHEQUE transactions are processed
    Y.UPDATED.FLAG = ''
    Y.ACCOUNT.LIST = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT>

    GOSUB UPDATE.DC.CHQ
    IF Y.UPDATED.FLAG THEN
        RETURN
    END

    Y.ACCOUNT.LIST = R.REDO.MANAGER.CHQ.PARAM<MAN.CHQ.PRM.ACCOUNT>

    GOSUB UPDATE.DC.CHQ
    IF Y.UPDATED.FLAG THEN
        RETURN
    END

    Y.ACCOUNT.LIST = R.CERTIFIED.CHEQUE.PARAMETER<CERT.CHEQ.ACCOUNT.NO>
    GOSUB UPDATE.DC.CHQ

RETURN
*--------------------------------------------------------------------------------------------------------
**************
UPDATE.DC.CHQ:
**************
* In this para of the code, the debit card CHEQUE transactions details are updated
    CHANGE @VM TO @FM IN Y.ACCOUNT.LIST
    LOCATE Y.CR.ACCOUNT IN Y.ACCOUNT.LIST<1> SETTING Y.ACC.POS THEN
        Y.UPDATED.FLAG = 1
        Y.VM.POS  = 4
        Y.ADD.AMT = Y.TT.AMT
        GOSUB AMEND.FINAL.ARRAY
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*************
CHECK.DC.TFR:
*************
* In this para of the code, the debit card TRANSFER transactions are processed
    ACCOUNT.ID = Y.CR.ACCOUNT
    GOSUB READ.ACCOUNT
    IF NOT(R.ACCOUNT<AC.CUSTOMER>) THEN
        RETURN
    END

    Y.VM.POS  = 4
    Y.ADD.AMT = Y.TT.AMT
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
        Y.CCY.POS = DCOUNT(Y.CCY.LIST,@FM)
    END

    BEGIN CASE
        CASE Y.CASH.WIT.FLAG
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4> += Y.ADD.AMT

        CASE Y.CHQ.WIT.FLAG
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5> += Y.ADD.AMT

        CASE Y.TFR.WIT.FLAG
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6> += Y.ADD.AMT
    END CASE

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
************************
READ.TELLER.TRANSACTION:
************************
* In this para of the code, file TELLER.TRANSACTION is read
    R.TELLER.TRANSACTION  = ''
    TELLER.TRANSACTION.ER = ''
    CALL CACHE.READ(FN.TELLER.TRANSACTION, TELLER.TRANSACTION.ID, R.TELLER.TRANSACTION, TELLER.TRANSACTION.ER);*R22 AUTO CODE CONVERSION

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
READ.TRANSACTION:
*****************
* In this para of the code, file TRANSACTION is read
    R.TRANSACTION  = ''
    TRANSACTION.ER = ''
    CALL CACHE.READ(FN.TRANSACTION, TRANSACTION.ID, R.TRANSACTION, TRANSACTION.ER) ;*R22 AUTO CODE COONVERSION

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'TELLER'
    FLD.ARRAY  = 'L.TT.POS.AUTHNM':@VM:'L.DEBIT.AMOUNT':@VM:'L.CREDIT.AMOUNT'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TT.POS.AUTHNM.POS  =  FLD.POS<1,1>
    LOC.L.DEBIT.AMOUNT.POS = FLD.POS<1,2>
    LOC.L.CREDIT.AMOUNT.POS = FLD.POS<1,3>
RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
