* @ValidationCode : MjoxNzY5MjA5ODQ2OkNwMTI1MjoxNjg0ODM2MDQ0MzAwOklUU1M6LTE6LTE6NDE5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 419
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DEP.CCARD.PAY(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,R.REDO.H.TELLER.TXN.CODES,Y.FINAL.ARRAY,Y.TT.LIST)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DEP.CCARD.PAY
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.DEP.CCARD.PAY is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.DEP.SAV.CUR, this routine is used to fetch CREDIT CARD
*                    PAYMENTS details
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DEP
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*                    TELLER.ID      - Holds the teller ID
*                    Y.TT.PARAM.REC - Holds the teller and parameter records
*                    R.REDO.H.TELLER.TXN.CODES - The teller transaction code details record
*Out Parameter     : Y.FINAL.ARRAY  - THe final Array to be passed out
*                    Y.CCY.LIST     - This variable holds the processed currency list
*                    Y.TT.LIST      - This variable holds the processed TELLER records
*Files  Used       : TELLER                           As              I               Mode
*                    ACCOUNT                          As              I               Mode
*                    REDO.H.TELLER.TXN.CODES          As              I               Mode
*                    TELLER.TRANSACTION               As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 24 Mar 2011       Shiva Prasad Y              ODR-2010-03-0086 35         Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   F.READ to CACHE.READ , FM to@FM ,VM to @vm
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.H.TELLER.TXN.CODES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.REDO.SUNNEL.CARD.DETAILS
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
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION  = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    FN.SUNNEL.DETAILS = 'F.REDO.SUNNEL.CARD.DETAILS'
    F.SUNNEL.DETAILS  = ''
    CALL OPF(FN.SUNNEL.DETAILS,F.SUNNEL.DETAILS)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    R.TELLER                     = FIELD(Y.TT.PARAM.REC,'$',1)
    R.REDO.ADMIN.CHQ.PARAM       = FIELD(Y.TT.PARAM.REC,'$',2)
    R.REDO.MANAGER.CHQ.PARAM     = FIELD(Y.TT.PARAM.REC,'$',3)
    R.CERTIFIED.CHEQUE.PARAMETER = FIELD(Y.TT.PARAM.REC,'$',4)

    Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>

    IF Y.TT.CCY EQ LCCY THEN
        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
    END ELSE
        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
    END

    GOSUB FIND.MULTI.LOCAL.REF

    IF NOT(R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.CR.ACCT.NO.POS>) THEN
        RETURN
    END

    GOSUB GET.CARD.TYPE
    IF NOT(Y.CARD.TYPE) THEN
        RETURN
    END
    Y.CASH.CATEG    = R.REDO.H.TELLER.TXN.CODES<TT.TXN.CASH.ACC.CATEG>
    CHANGE @VM TO @FM IN Y.CASH.CATEG

    Y.INT.ACC.CARD  = R.REDO.H.TELLER.TXN.CODES<TT.TXN.INT.ACC.CREDIT>
    CHANGE @VM TO @FM IN Y.INT.ACC.CARD

    Y.CHQ.TXN.CODES = R.REDO.H.TELLER.TXN.CODES<TT.TXN.CHQ.TXN.CODES>
    CHANGE @VM TO @FM IN Y.CHQ.TXN.CODES

    GOSUB GET.CARD.DETAILS

RETURN
*--------------------------------------------------------------------------------------------------------
**************
GET.CARD.TYPE:
**************
* In this para of the code, based on the CREDIT CARD number the CREDIT CARD type is fetched

    VAR.CC.ACCT.NO = R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.CR.ACCT.NO.POS>
    CALL F.READ(FN.SUNNEL.DETAILS,VAR.CC.ACCT.NO,R.SUNNEL.DETAILS,F.SUNNEL.DETAILS,SUNNEL.ERR)
    IF R.SUNNEL.DETAILS THEN
        Y.CARD.TYPE = R.SUNNEL.DETAILS<SUN.CARD.TYPE>
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.CARD.DETAILS:
*****************
* In this para of the code, the VISA card details are being fetched
    Y.VISA.CASH       = '' ; Y.VISA.CHQ       = '' ; Y.VISA.TFR       = ''
    Y.MASTERCARD.CASH = '' ; Y.MASTERCARD.CHQ = '' ; Y.MASTERCARD.TFR = ''
    Y.OTHER.CASH      = '' ; Y.OTHER.CHQ      = '' ; Y.OTHER.TFR      = ''

    LOCATE R.TELLER<TT.TE.ACCOUNT.2> IN Y.INT.ACC.CARD<1> SETTING Y.IACC.POS ELSE
        RETURN
    END

    LOCATE R.TELLER<TT.TE.ACCOUNT.1>[4,5] IN Y.CASH.CATEG<1> SETTING Y.CACC.POS THEN
        IF Y.CARD.TYPE EQ 'VISA' THEN
            Y.VISA.CASH = 1
            Y.VM.POS    = 16
        END
        IF Y.CARD.TYPE EQ 'MASTERCARD' THEN
            Y.MASTERCARD.CASH = 1
            Y.VM.POS          = 17
        END
        IF Y.CARD.TYPE NE 'VISA' AND Y.CARD.TYPE NE 'MASTERCARD' THEN
            Y.OTHER.CASH = 1
            Y.VM.POS     = 18
        END
        GOSUB AMEND.FINAL.ARRAY
        RETURN
    END

    ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.1>
    GOSUB READ.ACCOUNT
    IF R.ACCOUNT<AC.CUSTOMER> THEN
        IF Y.CARD.TYPE EQ 'VISA' THEN
            Y.VISA.TFR  = 1
            Y.VM.POS    = 16
        END
        IF Y.CARD.TYPE EQ 'MASTERCARD' THEN
            Y.MASTERCARD.TFR = 1
            Y.VM.POS         = 17
        END
        IF Y.CARD.TYPE NE 'VISA' AND Y.CARD.TYPE NE 'MASTERCARD' THEN
            Y.OTHER.TFR = 1
            Y.VM.POS    = 18
        END
        GOSUB AMEND.FINAL.ARRAY
        RETURN
    END

    TELLER.TRANSACTION.ID = R.TELLER<TT.TE.TRANSACTION.CODE>
    GOSUB READ.TELLER.TRANSACTION
    IF NOT(R.TELLER.TRANSACTION) THEN
        RETURN
    END

    LOCATE R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1> IN Y.CHQ.TXN.CODES<1> SETTING Y.CHQ.POS ELSE
        LOCATE R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.2> IN Y.CHQ.TXN.CODES<1> SETTING Y.CHQ.POS ELSE
            RETURN
        END
    END

    IF Y.CARD.TYPE EQ 'VISA' THEN
        Y.VISA.CHQ = 1
        Y.VM.POS   = 16
    END
    IF Y.CARD.TYPE EQ 'MASTERCARD' THEN
        Y.MASTERCARD.CHQ = 1
        Y.VM.POS         = 17
    END
    IF Y.CARD.TYPE NE 'VISA' AND Y.CARD.TYPE NE 'MASTERCARD' THEN
        Y.OTHER.CHQ = 1
        Y.VM.POS    = 18
    END
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
    Y.ADD.AMT = Y.TT.AMT
    IF Y.VISA.CASH OR Y.MASTERCARD.CASH OR Y.OTHER.CASH THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4>  += Y.ADD.AMT
    END

    IF Y.VISA.CHQ OR Y.MASTERCARD.CHQ OR Y.OTHER.CHQ THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5>  += Y.ADD.AMT
    END

    IF Y.VISA.TFR OR Y.MASTERCARD.TFR OR Y.OTHER.TFR THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6>  += Y.ADD.AMT
    END

    Y.TT.LIST<-1> = TELLER.ID

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
    CALL CACHE.READ(FN.TELLER.TRANSACTION, TELLER.TRANSACTION.ID, R.TELLER.TRANSACTION, TELLER.TRANSACTION.ER) ;*R22 AUTO CODE CONVERSION

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'TELLER'
    FLD.ARRAY  = 'L.TT.CR.CARD.NO':@VM:'L.TT.CR.ACCT.NO'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TT.CR.CARD.NO.POS  =  FLD.POS<1,1>
    LOC.L.TT.CR.ACCT.NO.POS  =  FLD.POS<1,2>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
