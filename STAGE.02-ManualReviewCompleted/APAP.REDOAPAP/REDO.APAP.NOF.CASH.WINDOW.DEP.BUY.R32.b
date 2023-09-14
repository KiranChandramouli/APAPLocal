* @ValidationCode : MjoyODc2MjYxMzI6Q3AxMjUyOjE2ODEzODI4OTM5MjU6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 16:18:13
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
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DEP.BUY.R32(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,Y.COMPANY.LIST,Y.TT.LIST,Y.FINAL.ARRAY,SET.CUR,Y.DUP.CUR)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DEP.BUY.R32
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.DEP.BUY is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.DEP.SAV.CUR, this routine is used to fetch the BUY currency
*                    details
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DEP
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*                    TELLER.ID      - Holds the teller ID
*                    Y.TT.PARAM.REC - Holds the teller and parameter records
*                    Y.COMPANY.LIST - The variblle holds the list of third party payment companies
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
* 15 Jun 2011       Marimuthu S              ODR-2011-04-0007 35         changes made in REDO.APAP.NOF.CASH.WINDOW.DEP.BUY.R32
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   $INCLUDE to $INSERT , FM to @FM , F.READ to CACHE.READ
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE  ;*R22 AUTO CODE CONVERSION
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.TRANSACTION
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
    Y.CASH.DEP.FLAG = FIELD(TELLER.ID,'_',2)
    Y.CHQ.DEP.FLAG = FIELD(TELLER.ID,'_',3)
    Y.TFR.DEP.FLAG = FIELD(TELLER.ID,'_',4)
    Y.TT.LR.RMET = ''
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
    IF NOT(R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.PAY.METHOD.POS>) THEN
        RETURN
    END
    Y.COMP.COUNT = DCOUNT(Y.COMPANY.LIST,@FM)

    Y.CCY.1.CASH = '' ; Y.CCY.1.CHQ = '' ; Y.CCY.1.TFR = ''; YCURR.2 = ''; YCURR.1 = ''
    TRANSACTION.ID = ''; Y.TT.AMT = ''; Y.TT.CCY = ''; Y.ADD.AMT = ''; YCR.CARD.NO = ''
    YCURR.1 = R.TELLER<TT.TE.CURRENCY.1>
    YCURR.2 = R.TELLER<TT.TE.CURRENCY.2>
    YDR.CR.MARK = R.TELLER<TT.TE.DR.CR.MARKER>
    TELLER.TRANSACTION.ID = R.TELLER<TT.TE.TRANSACTION.CODE>
    GOSUB READ.TELLER.TRANSACTION
    IF YCURR.1 NE LCCY OR YCURR.2 NE LCCY THEN
        GOSUB UPDATE.CURRENCY.1
    END
RETURN

******************
UPDATE.CURRENCY.1:
******************
* In this para of the code, the CURRENCY.1 is checked if its not LOCAL.CURRENCY and processed further
    TRANSACTION.ID = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1>
    GOSUB READ.TRANSACTION

    YTT.MARKER = R.TELLER<TT.TE.DR.CR.MARKER>
    IF YTT.MARKER EQ 'CREDIT' THEN
        IF R.TELLER<TT.TE.CURRENCY.2> EQ LCCY THEN
            Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
            Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.2>
        END
        IF R.TELLER<TT.TE.CURRENCY.1> EQ LCCY THEN
            Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
            Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.2>
        END
    END

* PACS00708935 - S
    IF TELLER.TRANSACTION.ID EQ '427' OR TELLER.TRANSACTION.ID EQ '440' THEN
        GOSUB READ.BUY.OPSIDE
    END
* PACS00708935 - E

    IF YTT.MARKER EQ 'DEBIT' THEN
        IF R.TELLER<TT.TE.CURRENCY.2> EQ LCCY THEN
            Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
            Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>
        END
        IF R.TELLER<TT.TE.CURRENCY.1> EQ LCCY THEN
            Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
            Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.2>
        END
    END

    YCR.CARD.NO = R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.CR.CARD.NO.POS>
    IF YCR.CARD.NO THEN
        Y.TFR.DEP.FLAG = ''
        Y.TT.CCY = LCCY
        IF YTT.MARKER EQ 'CREDIT' THEN
            GOSUB TEMP.CHK.VALUE
        END
        IF YTT.MARKER EQ 'DEBIT' THEN
            GOSUB TEMP.CHK.VALUE.1
        END
    END

    IF SET.CUR EQ 'YES' THEN
        IF Y.DUP.CUR NE Y.TT.CCY THEN
            RETURN
        END
    END

    IF Y.TT.CCY NE LCCY THEN
        Y.COMP.COUNT = 0
    END

    IF Y.CASH.DEP.FLAG THEN
        Y.CCY.1.CASH = 1
        Y.VM.POS     = 20 + Y.COMP.COUNT + 8
        Y.ADD.AMT    = Y.TT.AMT
        GOSUB AMEND.FINAL.ARRAY
    END

* PACS00708935 - S
* Whether is a FCY Buy transactions (TXN 437 or 22) parametrized in CHECK Column but Non-check transactions (according with Teller L.TT.RCEP.MTHD value
* field), the Txn amount in LCY should be displayed in "TRANSFER" column and also Txn amount in FCY should be considered in "TRANSFER" column.
*
    Y.TT.LR.RMET = R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.REC.MET.POS>
    Y.BUYME.NOCHK = 0
    IF Y.TT.LR.RMET NE "CHECK" AND Y.CHQ.DEP.FLAG THEN
        Y.TFR.DEP.FLAG = 1
        Y.CASH.DEP.FLAG = 0
        Y.CHQ.DEP.FLAG = 0
        Y.BUYME.NOCHK = 1
    END
* PACS00708935 - E

    IF Y.CHQ.DEP.FLAG THEN
        Y.CCY.1.CHQ = 1
        Y.VM.POS    = 20 + Y.COMP.COUNT + 8
        Y.ADD.AMT   = Y.TT.AMT
        GOSUB AMEND.FINAL.ARRAY
    END

    IF Y.TFR.DEP.FLAG THEN
        Y.CCY.1.TFR = 1
        Y.VM.POS    = 20 + Y.COMP.COUNT + 8
        Y.ADD.AMT   = Y.TT.AMT
        GOSUB AMEND.FINAL.ARRAY
    END

* PACS00708935 - S
* Returning the original flag value to CHECK Flag once the value its displayed
    IF Y.TT.LR.RMET NE "CHECK" AND Y.BUYME.NOCHK THEN
        Y.TFR.DEP.FLAG = 0
        Y.CASH.DEP.FLAG = 0
        Y.CHQ.DEP.FLAG = 1
    END
* PACS00708935 - E
RETURN


READ.BUY.OPSIDE:
***************
* As per Bank requirement the 12801 Internal accounts are handled as Passive acct. (Opposite "-" sign).
    IF YTT.MARKER EQ 'CREDIT' THEN
        IF R.TELLER<TT.TE.CURRENCY.2> EQ LCCY THEN
            Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
            Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>
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

* PACS00708935 - S
    Y.CNT.COMPA = ''
    Y.CNT.COMPA = DCOUNT(Y.COMPANY.LIST,@FM)
    IF Y.CNT.COMPA GT 0 AND Y.CCY.POS EQ '1' THEN
        Y.VM.POS -= Y.CNT.COMPA
    END
* PACS00708935 - E

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

TEMP.CHK.VALUE:
***************
    IF R.TELLER<TT.TE.CURRENCY.1> EQ LCCY THEN
        Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
        IF NOT(Y.TT.AMT) THEN
            Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
        END
    END ELSE
        Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
        IF NOT(Y.TT.AMT) THEN
            Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.2,1>
        END
    END
RETURN


TEMP.CHK.VALUE.1:
***************
    IF R.TELLER<TT.TE.CURRENCY.1> EQ LCCY THEN
        Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
        IF NOT(Y.TT.AMT) THEN
            Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.2,1>
        END
    END ELSE
        Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
        IF NOT(Y.TT.AMT) THEN
            Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
        END
    END
RETURN
*--------------------------------------------------------------------------------------------------------
************************
READ.TELLER.TRANSACTION:
************************
* In this para of the code, file TELLER.TRANSACTION is read
    R.TELLER.TRANSACTION = ''; TELLER.TRANSACTION.ER = ''
    CALL CACHE.READ(FN.TELLER.TRANSACTION, TELLER.TRANSACTION.ID, R.TELLER.TRANSACTION, TELLER.TRANSACTION.ER)
RETURN
*--------------------------------------------------------------------------------------------------------
*****************
READ.TRANSACTION:
*****************
* In this para of the code, file TRANSACTION is read
    R.TRANSACTION  = ''; TRANSACTION.ER = ''
    CALL CACHE.READ(FN.TRANSACTION, TRANSACTION.ID, R.TRANSACTION, TRANSACTION.ER) ;*R22 AUTO CODE CONVERSION
RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'TELLER'
    FLD.ARRAY  = 'L.TT.PAY.METHOD':@VM:'L.DEBIT.AMOUNT':@VM:'L.CREDIT.AMOUNT':@VM:'L.TT.CR.CARD.NO':@VM:'L.TT.RCEP.MTHD'
    FLD.POS    = ''; LOC.L.TT.CR.CARD.NO.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TT.PAY.METHOD.POS = FLD.POS<1,1>
    LOC.L.DEBIT.AMOUNT.POS = FLD.POS<1,2>
    LOC.L.CREDIT.AMOUNT.POS = FLD.POS<1,3>
    LOC.L.TT.CR.CARD.NO.POS  =  FLD.POS<1,4>
* PACS00708935 - S
    LOC.L.TT.REC.MET.POS = FLD.POS<1,5>
* PACS00708935 - E
RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
