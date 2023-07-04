* @ValidationCode : MjoxNjA4NTEwODcyOkNwMTI1MjoxNjg0ODM2MDQ0MTg1OklUU1M6LTE6LTE6MzA4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 308
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DEP.CCARD.PAY.R32(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,R.REDO.H.TELLER.TXN.CODES,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DEP.CCARD.PAY.R32
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
* 15 Jun 2011       Marimuthu S               ODR-2011-04-0007 32         Modification made in REDO.APAP.NOF.CASH.WINDOW.DEP.CCARD.PAY
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   $INCLUDE to $INSERT , TAM.BP REMOVE , F.READ to CACHE.READ , FM to @FM , VM to @VM
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON   ;*R22 AUTO CODE CONVERSION
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.H.TELLER.TXN.CODES ;*R22 AUTO CODE CONVERSION
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER.TRANSACTION

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
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.HST = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HST  = ''
    CALL OPF(FN.ACCOUNT.HST,F.ACCOUNT.HST)

    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION  = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    YTELLER.ID = ''
    YTELLER.ID = FIELD(TELLER.ID,'_',1)
    Y.CASH.TXN.TYPE = FIELD(TELLER.ID,'_',2)
    Y.CASH.TXN.CODE = FIELD(TELLER.ID,'_',3)
    Y.CHQ.TXN.TYPE = FIELD(TELLER.ID,'_',4)
    Y.CHQ.TXN.CODE = FIELD(TELLER.ID,'_',5)
    Y.TFR.TXN.TYPE = FIELD(TELLER.ID,'_',6)
    Y.TFR.TXN.CODE = FIELD(TELLER.ID,'_',7)
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

    GOSUB FIND.MULTI.LOCAL.REF
    Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.2>
    YTT.MARKER = R.TELLER<TT.TE.DR.CR.MARKER>
    Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
    IF Y.TT.CCY NE LCCY THEN
        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.2>
    END
    IF YTT.MARKER EQ 'CREDIT' AND R.TELLER<TT.TE.CURRENCY.1> NE LCCY THEN
        Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
    END
    IF NOT(Y.TT.AMT) THEN
        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.2,1>
    END

    YCR.CARD.NO = ''; Y.CARD.TYPE = ''
    YCR.CARD.NO = R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.CR.CARD.NO.POS>
    IF NOT(YCR.CARD.NO) THEN
        RETURN
    END

    IF YCR.CARD.NO[1,1] EQ 4'' THEN
        Y.CARD.TYPE = 'VISA'
    END
    IF YCR.CARD.NO[1,1] EQ '5' THEN
        Y.CARD.TYPE = 'MASTERCARD'
    END

    Y.CASH.CATEG    = R.REDO.H.TELLER.TXN.CODES<TT.TXN.CASH.ACC.CATEG>
    CHANGE @VM TO @FM IN Y.CASH.CATEG

    Y.INT.ACC.CARD  = R.REDO.H.TELLER.TXN.CODES<TT.TXN.INT.ACC.CREDIT>
    CHANGE @VM TO @FM IN Y.INT.ACC.CARD
    YT.INT.ACC.CARD = Y.INT.ACC.CARD<1>

    Y.CHQ.TXN.CODES = R.REDO.H.TELLER.TXN.CODES<TT.TXN.CHQ.TXN.CODES>
    CHANGE @VM TO @FM IN Y.CHQ.TXN.CODES

    Y.TXN.CODE.LN = R.TELLER<TT.TE.TRANSACTION.CODE>
    GOSUB GET.CARD.DETAILS
RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.CARD.DETAILS:
*****************
* In this para of the code, the VISA card details are being fetched
    Y.VISA.CASH       = '' ; Y.VISA.CHQ       = '' ; Y.VISA.TFR       = ''; YGRP.FLG = 0
    Y.MASTERCARD.CASH = '' ; Y.MASTERCARD.CHQ = '' ; Y.MASTERCARD.TFR = ''
    Y.OTHER.CASH      = '' ; Y.OTHER.CHQ      = '' ; Y.OTHER.TFR      = ''
    LOCATE R.TELLER<TT.TE.ACCOUNT.2>[4,5] IN YT.INT.ACC.CARD[4,5] SETTING Y.IACC.POS ELSE
        LOCATE R.TELLER<TT.TE.ACCOUNT.1>[4,5] IN YT.INT.ACC.CARD[4,5] SETTING Y.IACCH.POS ELSE
            RETURN
        END
    END

    IF R.TELLER<TT.TE.CURRENCY.1> NE R.TELLER<TT.TE.CURRENCY.2> THEN
* PACS00666029 - S
*        Y.CASH.TXN.CODE = ''; Y.CHQ.TXN.CODE = ''
        YGRP.FLG = 1
* PACS00666029 - E
        IF YTT.MARKER EQ 'CREDIT' THEN
            GOSUB TEMP.CHK.VALUE
        END
        IF YTT.MARKER EQ 'DEBIT' THEN
            GOSUB TEMP.CHK.VALUE.1
        END
    END

    GOSUB CARD.DETAIL.VAL

    LOCATE Y.TXN.CODE.LN IN Y.CHQ.TXN.CODE<1> SETTING POS.CQ THEN
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
    END
RETURN
*--------------------------------------------------------------------------------------------------------
CARD.DETAIL.VAL:
****************
    POS.TRNS=''
    LOCATE Y.TXN.CODE.LN IN Y.TFR.TXN.CODE<1> SETTING POS.TRNS THEN
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
    END
    IF NOT(POS.TRNS) THEN
        LOCATE Y.TXN.CODE.LN IN Y.CASH.TXN.CODE<1> SETTING POS.CASH THEN
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
        END
    END
RETURN

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
    IF YGRP.FLG EQ 0 THEN
        Y.TT.LIST<-1> = YTELLER.ID
    END
RETURN

TEMP.CHK.VALUE:
***************
    IF R.TELLER<TT.TE.CURRENCY.1> NE LCCY THEN
        Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
        IF NOT(Y.TT.AMT) THEN
            Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
        END
    END ELSE
        Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
        IF NOT(Y.TT.AMT) THEN
            Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.2>
        END
    END
RETURN


TEMP.CHK.VALUE.1:
***************
    IF R.TELLER<TT.TE.CURRENCY.2> NE LCCY THEN
        Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
        IF NOT(Y.TT.AMT) THEN
            Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.2>
        END
    END ELSE
        Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
        IF NOT(Y.TT.AMT) THEN
            Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
        END
    END
RETURN

*************
READ.ACCOUNT:
*************
* In this para of the code, file ACCOUNT is read
    R.ACCOUNT  = ''; ACCOUNT.ER = ''
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
    R.TELLER.TRANSACTION  = ''; TELLER.TRANSACTION.ER = ''
    CALL CACHE.READ(FN.TELLER.TRANSACTION, TELLER.TRANSACTION.ID, R.TELLER.TRANSACTION, TELLER.TRANSACTION.ER) ;*R22 AUTO CODE CONVERSION
RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'TELLER'
    FLD.ARRAY  = 'L.TT.CR.CARD.NO':@VM:'L.TT.CR.ACCT.NO':@VM:'L.DEBIT.AMOUNT':@VM:'L.CREDIT.AMOUNT'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TT.CR.CARD.NO.POS  =  FLD.POS<1,1>
    LOC.L.TT.CR.ACCT.NO.POS  =  FLD.POS<1,2>
    LOC.L.DEBIT.AMOUNT.POS = FLD.POS<1,3>
    LOC.L.CREDIT.AMOUNT.POS = FLD.POS<1,4>
RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
