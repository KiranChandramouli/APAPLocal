*-----------------------------------------------------------------------------
* <Rating>151</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DEP.OTH.INC.R32(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,Y.COMPANY.LIST,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DEP.OTH.INC.R32
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.DEP.OTH.INC is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.DEP.SAV.CUR, this routine is used to fetch the OTHER INCOME
*                    details of DEPOSITS from the TELLER transactions
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DEP
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*                    TELLER.ID      - Holds the teller ID
*                    Y.TT.PARAM.REC - Holds the teller and parameter records
*                    Y.COMPANY.LIST - The variable holds the list of third party payment companies
*Out Parameter     : Y.FINAL.ARRAY  - THe final Array to be passed out
*                    Y.CCY.LIST     - This variable holds the processed currency list
*                    Y.TT.LIST      - This variable holds the processed TELLER records
*Files  Used       : TELLER                           As              I               Mode
*                    ACCOUNT                          As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 15 jun 2011       Marimuthu S              ODR-2011-04-0007 32         Changes made in REDO.APAP.NOF.CASH.WINDOW.DEP.OTH.INC
* 24 Aug 2011       Bharath G                   PACS00104858                Routine modified to check REDO.H.TELLER.TXN.CODES
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.MANAGER.CHQ.PARAM
    $INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
    $INSERT I_F.REDO.H.TELLER.TXN.CODES
    $INSERT I_F.REDO.TT.GROUP.PARAM
    $INSERT I_F.TRANSACTION
    $INSERT I_F.FUNDS.TRANSFER

*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB OPEN.PARA
    GOSUB FIND.MULTI.LOCAL.REF
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

* PACS00104858 - S
    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION = ''
    R.TELLER.TRANSACTION = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    FN.REDO.TT.GROUP.PARAM = 'F.REDO.TT.GROUP.PARAM'
    F.REDO.TT.GROUP.PARAM  = ''
    R.REDO.TT.GROUP.PARAM  = ''
*CALL OPF(FN.REDO.TT.GROUP.PARAM,F.REDO.TT.GROUP.PARAM)
* PACS00104858 - E

    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION  = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)
    YTELLER.ID = ''
    YTELLER.ID = FIELD(TELLER.ID,'_',1)
    Y.CASH.TXN.FLAG = FIELD(TELLER.ID,'_',2)
    Y.CHQ.TXN.FLAG = FIELD(TELLER.ID,'_',3)
    Y.TFR.TXN.FLAG = FIELD(TELLER.ID,'_',4)
    RETURN

*************
PROCESS.PARA:
*************
* This is the main processing para
    Y.OTH.CASH = '' ; Y.OTH.CHQ = '' ; Y.OTH.TFR = ''
    LOCATE YTELLER.ID IN Y.TT.LIST SETTING POS.CK THEN
        RETURN
    END

    R.TELLER                     = FIELD(Y.TT.PARAM.REC,'##',1)
    R.REDO.ADMIN.CHQ.PARAM       = FIELD(Y.TT.PARAM.REC,'##',2)
    R.REDO.MANAGER.CHQ.PARAM     = FIELD(Y.TT.PARAM.REC,'##',3)
    R.CERTIFIED.CHEQUE.PARAMETER = FIELD(Y.TT.PARAM.REC,'##',4)
    R.REDO.H.TELLER.TXN.CODES    = FIELD(Y.TT.PARAM.REC,'##',5)

    IF YTELLER.ID[1,2] EQ 'TT' THEN
        Y.TT.CCY  = R.TELLER<TT.TE.CURRENCY.2>
        YTT.MARKER = R.TELLER<TT.TE.DR.CR.MARKER>
        Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
        IF Y.TT.CCY NE LCCY THEN
            Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.2>
        END
        IF YTT.MARKER EQ 'CREDIT' AND R.TELLER<TT.TE.CURRENCY.1> NE LCCY THEN
            Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
        END
        IF NOT(Y.TT.AMT) THEN
            Y.TT.AMT  = R.TELLER<TT.TE.AMOUNT.LOCAL.2,1>
        END
    END
    IF YTELLER.ID[1,2] EQ 'FT' THEN
        Y.TT.CCY = R.TELLER<FT.CREDIT.CURRENCY>
        IF NOT(Y.TT.CCY) THEN
            Y.TT.CCY = LCCY
        END
        Y.TT.AMT = R.TELLER<FT.AMOUNT.CREDITED>[4,99]
    END
    Y.COMP.COUNT = DCOUNT(Y.COMPANY.LIST,FM)

    IF YTELLER.ID[1,2] EQ 'TT' THEN
        GOSUB READ.TELLER.TRANS.AND.TT.GROUP.PARAM          ;*PACS00104858
    END
    GOSUB CHECK.CASH.TRANS
    GOSUB CHECK.CHQ.TRANS
    GOSUB CHECK.TFR.TRANS
    RETURN
*--------------------------------------------------------------------------------------------------------
*****************
CHECK.CASH.TRANS:
*****************
* In this para of the code, the transaction is checked if its a CASH transaction
*    Y.CASH.CATEG = R.REDO.H.TELLER.TXN.CODES<TT.TXN.CASH.ACC.CATEG>
*    CHANGE VM TO FM IN Y.CASH.CATEG
*    LOCATE R.TELLER<TT.TE.ACCOUNT.1>[4,5] IN Y.CASH.CATEG<1> SETTING Y.CACC.POS ELSE
*        LOCATE R.TELLER<TT.TE.ACCOUNT.2>[4,5] IN Y.CASH.CATEG<1> SETTING Y.CACC.POS ELSE
*            RETURN
*        END
*    END
    IF Y.CASH.TXN.FLAG NE 1 THEN
        RETURN
    END
    GOSUB READ.TRANSACTION
    IF YTELLER.ID[1,2] EQ 'TT' THEN
        IF R.TRANSACTION<AC.TRA.DEBIT.CREDIT.IND> EQ 'DEBIT' THEN
            ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.2>
        END ELSE
            ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.1>
        END
    END ELSE
        ACCOUNT.ID = R.TELLER<FT.IN.DEBIT.ACCT.NO>
    END

* PACS00104858 - S
*    LOCATE R.TELLER<TT.TE.ACCOUNT.1>[3,5] IN Y.CATEGORY.PL<1> SETTING Y.CAT.POS ELSE
*        LOCATE R.TELLER<TT.TE.ACCOUNT.2>[3,5] IN Y.CATEGORY.PL<1> SETTING Y.CAT.POS ELSE
*            RETURN
*        END
*    END
* PACS00104858 - E

    IF Y.TT.CCY NE LCCY THEN
        Y.COMP.COUNT = 0
    END

    Y.OTH.CASH  = 1
    Y.VM.POS    = 20 + Y.COMP.COUNT + 3
    Y.ADD.AMT   = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
    RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.CHQ.TRANS:
****************
* In this para of the code, the transaction is checked if its a CHEQUE transaction
    IF Y.CHQ.TXN.FLAG NE 1 THEN
        RETURN
    END

*    Y.ACCOUNT.LIST     = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT>
*    Y.ACCOUNT.LIST<-1> = R.REDO.MANAGER.CHQ.PARAM<MAN.CHQ.PRM.ACCOUNT>
*    Y.ACCOUNT.LIST<-1> = R.CERTIFIED.CHEQUE.PARAMETER<CERT.CHEQ.ACCOUNT.NO>
*    Y.ACCOUNT.LIST = CHANGE(Y.ACCOUNT.LIST,VM,FM)

*    LOCATE TRANS.1 IN R.REDO.H.TELLER.TXN.CODES<TT.TXN.CHQ.TXN.CODES,1> SETTING Y.CACC.POS ELSE
*        LOCATE TRANS.2 IN R.REDO.H.TELLER.TXN.CODES<TT.TXN.CHQ.TXN.CODES,1> SETTING Y.CACC.POS ELSE
*            RETURN
*        END
*    END


*    LOCATE R.TELLER<TT.TE.ACCOUNT.1>[3,5] IN Y.CATEGORY.PL<1> SETTING Y.CAT.POS ELSE
*        LOCATE R.TELLER<TT.TE.ACCOUNT.2>[3,5] IN Y.CATEGORY.PL<1> SETTING Y.CAT.POS ELSE
*            RETURN
*        END
*    END
    IF Y.TT.CCY NE LCCY THEN
        Y.COMP.COUNT = 0
    END
    Y.OTH.CHQ   = 1
    Y.VM.POS    = 20 + Y.COMP.COUNT + 3
    Y.ADD.AMT   = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
    RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.TFR.TRANS:
****************
* In this para of the code, the transaction is checked if its a TRANSFER transaction
    IF Y.TFR.TXN.FLAG NE 1 THEN
        RETURN
    END
*    IF YTELLER.ID[1,2] EQ 'TT' THEN
*        ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.1>
*    END ELSE
*        ACCOUNT.ID = R.TELLER<FT.IN.DEBIT.ACCT.NO>
*    END
*    GOSUB READ.ACCOUNT
*    IF NOT(R.ACCOUNT<AC.CUSTOMER>) ELSE
*        IF YTELLER.ID[1,2] EQ 'TT' THEN
*            ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.2>
*        END ELSE
*            ACCOUNT.ID = R.TELLER<FT.CREDIT.ACCT.NO>
*        END
*        GOSUB READ.ACCOUNT
*    END
*    IF R.ACCOUNT<AC.CUSTOMER> ELSE
*        RETURN
*    END

* PACS00104858 - S
*    LOCATE R.TELLER<TT.TE.ACCOUNT.1>[3,5] IN Y.CATEGORY.PL<1> SETTING Y.CAT.POS ELSE
*        LOCATE R.TELLER<TT.TE.ACCOUNT.2>[3,5] IN Y.CATEGORY.PL<1> SETTING Y.CAT.POS ELSE
*            RETURN
*        END
*    END
* PACS00104858 - E

    IF Y.TT.CCY NE LCCY THEN
        Y.COMP.COUNT = 0
    END
    Y.OTH.TFR   = 1
    Y.VM.POS    = 20 + Y.COMP.COUNT + 3
    Y.ADD.AMT   = Y.TT.AMT
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

    IF SET.CUR EQ 'YES' AND Y.DUP.CUR NE Y.TT.CCY THEN
        RETURN
    END

* PACS00708935 - S
    Y.CNT.COMPA = ''
    Y.CNT.COMPA = DCOUNT(Y.COMPANY.LIST,FM)
    IF Y.CNT.COMPA GT 0 AND Y.CCY.POS EQ '1' THEN 
	    Y.VM.POS = Y.VM.POS - Y.CNT.COMPA
	END
* PACS00708935 - E

    IF Y.OTH.CASH THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4>  += Y.ADD.AMT
    END

    IF Y.OTH.CHQ THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5>  += Y.ADD.AMT
    END

    IF Y.OTH.TFR THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6>  += Y.ADD.AMT
    END
    Y.TT.LIST<-1> = YTELLER.ID
    RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
* In this para of the code, file ACCOUNT is read
    R.ACCOUNT  = ''
    ACCOUNT.ER = ''
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)
    IF NOT(R.ACCOUNT) THEN
        ACCOUNT.IDH = ACCOUNT.ID; ERR.AC = ''
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HST,ACCOUNT.IDH,R.ACCOUNT,ERR.AC)
    END
    RETURN
*--------------------------------------------------------------------------------------------------------
**************************************
READ.TELLER.TRANS.AND.TT.GROUP.PARAM:
**************************************
*
    TELLER.TRANS.ID = R.TELLER<TT.TE.TRANSACTION.CODE>

    CALL F.READ(FN.TELLER.TRANSACTION,TELLER.TRANS.ID,R.TELLER.TRANSACTION,F.TELLER.TRANSACTION,TELLER.ERR)
    IF R.TELLER.TRANSACTION THEN
        TRANS.1 = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1>
        TRANS.2 = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.2>
    END
    GRP.PARAM.ID = 'SYSTEM'
*  CALL F.READ(FN.REDO.TT.GROUP.PARAM,GRP.PARAM.ID,R.REDO.TT.GROUP.PARAM,F.REDO.TT.GROUP.PARAM,GRP.PARAM.ERR) ;*Tus Start
    CALL CACHE.READ(FN.REDO.TT.GROUP.PARAM,GRP.PARAM.ID,R.REDO.TT.GROUP.PARAM,GRP.PARAM.ERR)        ;* Tus End
    IF R.REDO.TT.GROUP.PARAM THEN
        Y.GROUP    = R.REDO.TT.GROUP.PARAM<TEL.GRO.GROUP>
        Y.CATEGORY = R.REDO.TT.GROUP.PARAM<TEL.GRO.CATEGORY>
        CHANGE VM TO FM IN Y.GROUP
        CHANGE VM TO FM IN Y.CATEGORY
        CHANGE SM TO VM IN Y.CATEGORY
        LOCATE "OTHER.INCOMDE" IN Y.GROUP<1> SETTING GRP.POS THEN
            Y.CATEGORY.OTHER.INCOME = Y.CATEGORY<GRP.POS>
            CHANGE VM TO FM IN Y.CATEGORY.OTHER.INCOME
        END
        LOCATE "LOAN-COM" IN Y.GROUP<1> SETTING GRP.POS THEN
            Y.CATEGORY.LN.COM = Y.CATEGORY<GRP.POS>
            CHANGE VM TO FM IN Y.CATEGORY.LN.COM
        END
        Y.CATEGORY.PL = Y.CATEGORY.OTHER.INCOME:FM:Y.CATEGORY.LN.COM
    END

    RETURN
*--------------------------------------------------------------------------------------------------------
*****************
READ.TRANSACTION:
*****************
* In this para of the code, file TRANSACTION is read
    R.TRANSACTION  = ''
    TRANSACTION.ER = ''
    CALL F.READ(FN.TRANSACTION,TRANSACTION.ID,R.TRANSACTION,F.TRANSACTION,TRANSACTION.ER)
    RETURN

*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'TELLER'
    FLD.ARRAY  = 'L.DEBIT.AMOUNT':VM:'L.CREDIT.AMOUNT'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.DEBIT.AMOUNT.POS = FLD.POS<1,1>
    LOC.L.CREDIT.AMOUNT.POS = FLD.POS<1,2>
    RETURN
END       ;* End of Program
