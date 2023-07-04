* @ValidationCode : MjotMTk2MzU4Njg2OTpDcDEyNTI6MTY4MTcxOTc0MDc2Nzphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Apr 2023 13:52:20
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
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.WIT.SELL.R32(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.WIT.SELL.R32
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.WIT.SELL is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.WIT.SAV.CUR, this routine is used to fetch the SELL currency
*                    details
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.WIT
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*                    TELLER.ID      - Holds the teller ID
*                    Y.TT.PARAM.REC - Holds the teller and parameter records
*Out Parameter     : Y.FINAL.ARRAY  - THe final Array to be passed out
*                    Y.CCY.LIST     - This variable holds the processed currency list
*Files  Used       : TELLER                           As              I               Mode
*                    TELLER.TRANSACTION               As              I               Mode
*                    TRANSACTION                      As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 15 JUN 2011       Marimuthu S              ODR-2011-04-0007   35         Changes made in REDO.APAP.NOF.CASH.WINDOW.WIT.SELL
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FMto@FM,VMto@VM,F.READtoCACHE.READ,$INCLUDEto$INSERT
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*********************************************************************************************************
    $INSERT I_COMMON ;*R22 AUTO CODE CONVERISON
    $INSERT I_EQUATE ;*R22 AUTO CODE CONVERISON
    $INSERT I_ENQUIRY.COMMON ;*R22 AUTO CODE CONVERISON
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.TRANSACTION ;*R22 AUTO CODE CONVERISON
    $INSERT I_F.TRANSACTION ;*R22 AUTO CODE CONVERISON
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
    YTELLER.ID = ''
    YTELLER.ID = FIELD(TELLER.ID,'_',1)
    Y.CASH.WIT.FLAG = FIELD(TELLER.ID,'_',2)
    Y.CHQ.WIT.FLAG = FIELD(TELLER.ID,'_',3)
    Y.TFR.WIT.FLAG = FIELD(TELLER.ID,'_',4)
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
    GOSUB FIND.MULTI.LOCAL.REF
    YCURR.1 = ''; YCURR.2 = ''; Y.CCY.1.CASH = '' ; Y.CCY.1.CHQ = '' ; Y.CCY.1.TFR = ''
    YCURR.1 = R.TELLER<TT.TE.CURRENCY.1>
    YCURR.2 = R.TELLER<TT.TE.CURRENCY.2>
    IF YCURR.1 EQ YCURR.2 THEN
        RETURN
    END
    IF NOT(R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.PAY.METHOD.POS>) THEN
        RETURN
    END
    TELLER.TRANSACTION.ID = R.TELLER<TT.TE.TRANSACTION.CODE>
    GOSUB READ.TELLER.TRANSACTION
    YDR.CR.MARK = R.TELLER<TT.TE.DR.CR.MARKER>
    IF YCURR.1 NE LCCY OR YCURR.2 NE LCCY THEN
        GOSUB UPDATE.CURRENCY.1
    END
RETURN
*--------------------------------------------------------------------------------------------------------
******************
UPDATE.CURRENCY.1:
******************
* In this para of the code, the CURRENCY.1 is checked if its not LOCAL.CURRENCY and processed further
    TRANSACTION.ID = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1>
    GOSUB READ.TRANSACTION

    YTT.MARKER = R.TELLER<TT.TE.DR.CR.MARKER>
    IF YTT.MARKER EQ 'CREDIT' THEN
        IF R.TELLER<TT.TE.CURRENCY.1> EQ LCCY THEN
            Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
            Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>
        END
        IF R.TELLER<TT.TE.CURRENCY.2> EQ LCCY THEN
            Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
            Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>
        END
    END

* PACS00708935 - S
    IF TELLER.TRANSACTION.ID EQ '427' OR TELLER.TRANSACTION.ID EQ '440' THEN
        GOSUB READ.SELL.OPSIDE
    END
* PACS00708935 - E

    IF YTT.MARKER EQ 'DEBIT' THEN
        IF R.TELLER<TT.TE.CURRENCY.2> EQ LCCY THEN
            Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
            Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.2>
        END
        IF R.TELLER<TT.TE.CURRENCY.1> EQ LCCY THEN
            Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
* PACS00666029 - S
*Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>
            Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.2>
* PACS00666029 - E
        END
    END
    IF SET.CUR EQ 'YES' THEN
        IF Y.DUP.CUR NE Y.TT.CCY THEN
            RETURN
        END
    END

*   IF R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.PAY.METHOD.POS> EQ 'CASH' THEN
    IF Y.CASH.WIT.FLAG THEN
        Y.CCY.1.CASH = 1
        Y.VM.POS     = 30
        Y.ADD.AMT    = Y.TT.AMT
        GOSUB AMEND.FINAL.ARRAY
    END

*  IF R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.PAY.METHOD.POS> EQ 'CHECK' THEN
    IF Y.CHQ.WIT.FLAG THEN
        Y.CCY.1.CHQ = 1
        Y.VM.POS    = 30
        Y.ADD.AMT   = Y.TT.AMT
        GOSUB AMEND.FINAL.ARRAY
    END

*   IF R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.PAY.METHOD.POS> EQ 'BANK.TRANSFER' THEN
    IF Y.TFR.WIT.FLAG THEN
        Y.CCY.1.TFR = 1
        Y.VM.POS    = 30
        Y.ADD.AMT   = Y.TT.AMT
        GOSUB AMEND.FINAL.ARRAY
    END
RETURN

READ.SELL.OPSIDE:
***************
* As per Bank requirement the 12801 Internal accounts are handled as Passive acct. (Opposite "-" sign) than Active instead.
    IF YTT.MARKER EQ 'CREDIT' THEN
        IF R.TELLER<TT.TE.CURRENCY.2> EQ LCCY THEN
            Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
            Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.2>
        END
    END
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

    IF SET.CUR EQ 'YES' AND Y.DUP.CUR NE Y.TT.CCY THEN
        RETURN
    END

    IF Y.CCY.1.CASH THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4> += Y.ADD.AMT
    END
    IF Y.CCY.1.CHQ THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5> += Y.ADD.AMT
    END

    IF Y.CCY.1.TFR THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6> += Y.ADD.AMT
    END

    Y.TT.LIST<-1> = YTELLER.ID
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
*****************
READ.TRANSACTION:
*****************
* In this para of the code, file TRANSACTION is read
    R.TRANSACTION  = ''
    TRANSACTION.ER = ''
    CALL CACHE.READ(FN.TRANSACTION, TRANSACTION.ID, R.TRANSACTION, TRANSACTION.ER) ;*R22 AUTO CODE CONVERSION
RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'TELLER'
    FLD.ARRAY  = 'L.TT.PAY.METHOD':@VM:'L.DEBIT.AMOUNT':@VM:'L.CREDIT.AMOUNT'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TT.PAY.METHOD.POS = FLD.POS<1,1>
    LOC.L.DEBIT.AMOUNT.POS = FLD.POS<1,2>
    LOC.L.CREDIT.AMOUNT.POS = FLD.POS<1,3>
RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
