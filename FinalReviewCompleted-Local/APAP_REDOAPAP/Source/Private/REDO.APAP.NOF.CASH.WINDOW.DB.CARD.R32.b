* @ValidationCode : MjotODczODI2NzQ1OkNwMTI1MjoxNjgwNjgwMjE2MTU2OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:06:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DB.CARD.R32(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,R.REDO.H.TELLER.TXN.CODES,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DB.CARD.R32
*--------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.DB.CARD is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.SAV.CUR, this routine is used to fetch the debit card
*                    details
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*                    TELLER.ID      - Holds the teller ID
*                    Y.TT.PARAM.REC - Holds the teller and parameter records
*                    R.REDO.H.TELLER.TXN.CODES - Holds the parameter record
*Out Parameter     : Y.FINAL.ARRAY - THe final Array to be passed out
*                    Y.CCY.LIST    - This variable holds the processed currency list
*                    Y.TT.LIST  - This variable holds the processed TELLER records
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
* 15 jun 2011       Marimuthu S              ODR-2011-04-0007  35         changes made in REDO.APAP.NOF.CASH.WINDOW.DB.CARD
* Date                   who                   Reference              
* 05-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION FM TO @FM VM TO @VM AND F.READ TO CACHE.READ AND REMOVING F.TELLER.TRANSACTION F.TRANSACTION
* 05-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*
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
    TELLER.ID = YTELLER.ID
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

    FN.ACCOUNT.HST = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HST  = ''
    CALL OPF(FN.ACCOUNT.HST,F.ACCOUNT.HST)
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

    YTELLER.ID = ''
    YTELLER.ID = FIELD(TELLER.ID,'_',1)
    Y.CASH.WIT.FLAG = FIELD(TELLER.ID,'_',2)
    Y.CHQ.WIT.FLAG = FIELD(TELLER.ID,'_',3)
    Y.TFR.WIT.FLAG = FIELD(TELLER.ID,'_',4)
    GOSUB FIND.MULTI.LOCAL.REF
    IF NOT(R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.POS.AUTHNM.POS>) THEN
        RETURN
    END
    YTT.MARKER = R.TELLER<TT.TE.DR.CR.MARKER>
    Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
    IF YTT.MARKER EQ 'CREDIT' AND R.TELLER<TT.TE.CURRENCY.1> NE LCCY THEN
        Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
    END
    Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.2>
    IF NOT(Y.TT.AMT) THEN
        IF Y.TT.CCY EQ LCCY THEN
            Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.2,1>
        END ELSE
            Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.2>
        END
    END
    Y.CASH.CATEG    = R.REDO.H.TELLER.TXN.CODES<TT.TXN.CASH.ACC.CATEG>
    CHANGE @VM TO @FM IN Y.CASH.CATEG
    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB CHECK.DEBIT.CARD.TXNS
RETURN
*--------------------------------------------------------------------------------------------------------
**********************
CHECK.DEBIT.CARD.TXNS:
**********************
* In this para of the code, the debit card transactions are being considered

*    Y.TT.CCY  = R.TELLER<TT.TE.CURRENCY.1>
*    IF Y.TT.CCY EQ LCCY THEN
*        Y.TT.AMT  = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
*    END ELSE
*        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
*    END

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
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4> += Y.ADD.AMT

        CASE Y.CHQ.WIT.FLAG
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5> += Y.ADD.AMT

        CASE Y.TFR.WIT.FLAG
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6> += Y.ADD.AMT
    END CASE

    Y.TT.LIST<-1> = YTELLER.ID
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
************************
READ.TELLER.TRANSACTION:
************************
* In this para of the code, file TELLER.TRANSACTION is read
    R.TELLER.TRANSACTION  = '';    TELLER.TRANSACTION.ER = ''
    CALL CACHE.READ(FN.TELLER.TRANSACTION, TELLER.TRANSACTION.ID, R.TELLER.TRANSACTION, TELLER.TRANSACTION.ER) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVING F.TELLER.TRANSACTION 
RETURN
*--------------------------------------------------------------------------------------------------------
*****************
READ.TRANSACTION:
*****************
* In this para of the code, file TRANSACTION is read
    R.TRANSACTION  = ''; TRANSACTION.ER = ''
    CALL CACHE.READ(FN.TRANSACTION, TRANSACTION.ID, R.TRANSACTION, TRANSACTION.ER) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVING F.TRANSACTION
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
