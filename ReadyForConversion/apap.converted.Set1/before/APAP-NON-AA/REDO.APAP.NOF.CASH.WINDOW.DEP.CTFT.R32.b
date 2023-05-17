*-----------------------------------------------------------------------------
* <Rating>221</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DEP.CTFT.R32(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,Y.COMPANY.LIST,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR,R.REDO.H.TELLER.TXN.CODES)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DEP.CTFT.R32
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.DEP.CTFT is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.DEP.SAV.CUR, this routine is used to fetch the CASH TRANSFERS
*                    FROM TELLERS and FROM OTHER BANKS
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DEP
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*                    TELLER.ID      - Holds the teller ID
*                    Y.TT.PARAM.REC - Holds the teller and parameter records
*                    Y.COMPANY.LIST - The variable holds the list of third party payment companies
*Out Parameter     : Y.FINAL.ARRAY  - THe final Array to be passed out
*                    Y.CCY.LIST     - This variable holds the processed currency list
*                    Y.TT.LIST      - This variable holds the processed TELLER records
*Files  Used       : TELLER                           As              I               Mode
*                    ACCOUNT.CLASS                    As              I               Mode
*                    ACCOUNT                          As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 15 JUN 2011       Marimuthu S                  ODR-2011-04-0007 35         modification made in REDO.APAP.NOF.CASH.WINDOW.DEP.CTFT
*
*********************************************************************************************************
    $INCLUDE I_COMMON
    $INCLUDE I_EQUATE
    $INCLUDE I_ENQUIRY.COMMON
    $INCLUDE I_F.TELLER
    $INCLUDE I_F.ACCOUNT.CLASS
    $INCLUDE I_F.ACCOUNT
    $INCLUDE TAM.BP I_F.REDO.ADMIN.CHQ.PARAM
    $INCLUDE TAM.BP I_F.REDO.MANAGER.CHQ.PARAM
    $INCLUDE TAM.BP I_F.CERTIFIED.CHEQUE.PARAMETER
    $INCLUDE TAM.BP I_F.REDO.H.TELLER.TXN.CODES
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
    TELLER.ID = YTELLER.ID
    RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'TELLER'
    FLD.ARRAY  = 'L.TT.POS.AUTHNM':VM:'T24.FS.REF':VM:'L.DEBIT.AMOUNT':VM:'L.CREDIT.AMOUNT'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TT.POS.AUTHNM.POS  =  FLD.POS<1,1>
    LOC.T24.FS.REF = FLD.POS<1,2>
    LOC.L.DEBIT.AMOUNT.POS = FLD.POS<1,3>
    LOC.L.CREDIT.AMOUNT.POS = FLD.POS<1,4>
    RETURN

**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
    FN.ACCOUNT.CLASS = 'F.ACCOUNT.CLASS'
    F.ACCOUNT.CLASS  = ''
    CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.HST = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HST  = ''
    CALL OPF(FN.ACCOUNT.HST,F.ACCOUNT.HST)
    YTELLER.ID = ''; Y.TELLER.ID = ''; YTT.MARKER = ''; RET.VAL = 0
    YTELLER.ID = FIELD(TELLER.ID,'_',1)
    Y.TELLER.ID = FIELD(TELLER.ID,'_',2)
    Y.CASH.TXN.TYPE = FIELD(TELLER.ID,'_',3)
    Y.CASH.TXN.CODE = FIELD(TELLER.ID,'_',4)
    Y.CHQ.TXN.TYPE = FIELD(TELLER.ID,'_',5)
    Y.CHQ.TXN.CODE = FIELD(TELLER.ID,'_',6)
    Y.TFR.TXN.TYPE = FIELD(TELLER.ID,'_',7)
    Y.TFR.TXN.CODE = FIELD(TELLER.ID,'_',8)
    Y.CASH.CATEG    = R.REDO.H.TELLER.TXN.CODES<TT.TXN.CASH.ACC.CATEG>
    CHANGE VM TO FM IN Y.CASH.CATEG
    RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    LOCATE YTELLER.ID IN Y.TT.LIST SETTING PS.CK THEN
        RETURN
    END

    R.TELLER                     = FIELD(Y.TT.PARAM.REC,'##',1)
    R.REDO.ADMIN.CHQ.PARAM       = FIELD(Y.TT.PARAM.REC,'##',2)
    R.REDO.MANAGER.CHQ.PARAM     = FIELD(Y.TT.PARAM.REC,'##',3)
    R.CERTIFIED.CHEQUE.PARAMETER = FIELD(Y.TT.PARAM.REC,'##',4)
    R.REDO.H.TELLER.TXN.CODES    = FIELD(Y.TT.PARAM.REC,'##',5)

    YTT.MARKER = R.TELLER<TT.TE.DR.CR.MARKER>
    YTELLER.ID1 = R.TELLER<TT.TE.TELLER.ID.1>
    YTELLER.ID2 = R.TELLER<TT.TE.TELLER.ID.2>
    Y.TT.CCY  = R.TELLER<TT.TE.CURRENCY.2>
    IF Y.TT.CCY EQ LCCY THEN
        Y.TT.AMT  = R.TELLER<TT.TE.AMOUNT.LOCAL.2,1>
    END ELSE
        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.2>
    END
    Y.COMP.COUNT = DCOUNT(Y.COMPANY.LIST,FM)
    GOSUB CHECK.TXN.CODE
    GOSUB CASH.TFR.FROM.TELLER
    GOSUB CASH.TFR.FROM.CENTRAL.BANK
    RETURN
*--------------------------------------------------------------------------------------------------------
*********************
CASH.TFR.FROM.TELLER:
*********************
* In this para of the code, the CASH TRANSFER FROM TELLER transactions are processed
    IF YTELLER.ID1 EQ YTELLER.ID2 THEN
        RETURN
    END

    IF YTELLER.ID1 EQ Y.TELLER.ID THEN
        Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>
        Y.CR.ACC = R.TELLER<TT.TE.ACCOUNT.1>
        IF YTT.MARKER EQ 'CREDIT' THEN
            Y.TT.LIST<-1> = YTELLER.ID
            RETURN
        END
        RET.VAL =1
    END

    IF YTELLER.ID2 EQ Y.TELLER.ID THEN
        Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.2>
        Y.CR.ACC = R.TELLER<TT.TE.ACCOUNT.2>
        IF YTT.MARKER EQ 'DEBIT' THEN
            Y.TT.LIST<-1> = YTELLER.ID
            RETURN
        END
        RET.VAL = 1
    END
    IF RET.VAL EQ 0 THEN
        RETURN
    END

    IF Y.TT.CCY NE LCCY THEN
        Y.COMP.COUNT = 0
    END
    Y.VM.POS  = 20 + Y.COMP.COUNT + 5
    Y.ADD.AMT = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
    RETURN
*--------------------------------------------------------------------------------------------------------
***************************
CASH.TFR.FROM.CENTRAL.BANK:
***************************
* In this para of the code, the CASH TRANSFER FROM CENTRAL BANK transactions are processed
    ACCOUNT.CLASS.ID = 'NOSTRO'
    GOSUB READ.ACCOUNT.CLASS

    Y.NOSTRO.CATEG = R.ACCOUNT.CLASS<AC.CLS.CATEGORY>
    CHANGE VM TO FM IN Y.NOSTRO.CATEG

    ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.2>
    GOSUB READ.ACCOUNT
    Y.NOS.POS = ''; Y.NOS.POST = ''
    LOCATE R.ACCOUNT<AC.CATEGORY> IN Y.NOSTRO.CATEG<1> SETTING Y.NOS.POS ELSE
        ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.1>
        GOSUB READ.ACCOUNT
        LOCATE R.ACCOUNT<AC.CATEGORY> IN Y.NOSTRO.CATEG<1> SETTING Y.NOS.POST ELSE
            RETURN
        END
    END

    IF Y.TT.CCY NE LCCY THEN
        Y.COMP.COUNT = 0
    END

    Y.VM.POS  = 20 + Y.COMP.COUNT + 6
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

    BEGIN CASE
    CASE Y.CASH.DEP.FLAG
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4>  += Y.ADD.AMT
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,7>  += Y.ADD.AMT

    CASE Y.CHQ.DEP.FLAG
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5>  += Y.ADD.AMT
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,7>  += Y.ADD.AMT

    CASE Y.TFR.DEP.FLAG
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6>  += Y.ADD.AMT
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,7>  += Y.ADD.AMT
    END CASE

    Y.TT.LIST<-1> = YTELLER.ID
    RETURN
*--------------------------------------------------------------------------------------------------------
*******************
READ.ACCOUNT.CLASS:
*******************
* In this para of the code, file ACCOUNT.CLASS is read
    R.ACCOUNT.CLASS = ''; ACCOUNT.CLASS.ER = ''
    CALL F.READ(FN.ACCOUNT.CLASS,ACCOUNT.CLASS.ID,R.ACCOUNT.CLASS,F.ACCOUNT.CLASS,ACCOUNT.CLASS.ER)
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
***************
CHECK.TXN.CODE:
***************
* In this para of the code, the TXN.CODE is checked with transaction type and payment mode
    Y.CASH.DEP.FLAG = ''; Y.CHQ.DEP.FLAG  = '';  Y.TFR.DEP.FLAG = ''
    Y.TFR.CODE.FLAG = ''; Y.CHQ.CODE.FLAG = ''; Y.CASH.CODE.FLAG = ''

    Y.TT.TXN.CODE = R.TELLER<TT.TE.TRANSACTION.CODE>
    LOCATE Y.TT.TXN.CODE IN Y.CASH.TXN.CODE<1> SETTING Y.TXN.POS THEN
        Y.CASH.CODE.FLAG = 1
        IF Y.CASH.TXN.TYPE<Y.TXN.POS> EQ 'DEPOSITS' THEN
            Y.CASH.DEP.FLAG = 1
        END
        IF Y.CASH.TXN.TYPE<Y.TXN.POS> EQ 'DEPOS.WITHDRW' THEN
            Y.CASH.DEP.FLAG = 1
        END
    END

    LOCATE Y.TT.TXN.CODE IN Y.CHQ.TXN.CODE<1> SETTING Y.TXN.POS THEN
        Y.CHQ.CODE.FLAG = 1
        IF Y.CHQ.TXN.TYPE<Y.TXN.POS> EQ 'DEPOSITS' THEN
            Y.CHQ.DEP.FLAG = 1
        END
        IF Y.CHQ.TXN.TYPE<Y.TXN.POS> EQ 'DEPOS.WITHDRW' THEN
            Y.CHQ.DEP.FLAG = 1
        END
    END

    LOCATE Y.TT.TXN.CODE IN Y.TFR.TXN.CODE<1> SETTING Y.TXN.POS THEN
        Y.TFR.CODE.FLAG = 1
        IF Y.TFR.TXN.TYPE<Y.TXN.POS> EQ 'DEPOSITS' THEN
            Y.TFR.DEP.FLAG = 1
        END
        IF Y.TFR.TXN.TYPE<Y.TXN.POS> EQ 'DEPOS.WITHDRW' THEN
            Y.TFR.DEP.FLAG = 1
        END
    END
    RETURN

END       ;* End of Program
