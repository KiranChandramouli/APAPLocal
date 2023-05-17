*-----------------------------------------------------------------------------
* <Rating>22</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DEP.LOOP.MTS.R32(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,R.REDO.H.TELLER.TXN.CODES,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DEP.LOOP.MTS.R32
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.DEP.LOOP.MTS is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.DEP, this routine is used to fetch the term instrument openings
*                    and LOAN payment details
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DEP
*In  Parameter     : R.REDO.H.TELLER.TXN.CODES - The record of REDO.H.TELLER.TXN.CODES
*                    Y.CCY.LIST - This variable holds the processed currency list
*Out Parameter     : Y.FINAL.ARRAY - THe final Array to be passed out
*                    Y.CCY.LIST - This variable holds the processed currency list
*Files  Used       : MULTI.TRANSACTION.SERVICE             As              I               Mode
*                    AA.ARRANGEMENT                        As              I               Mode
*                    TELLER                                As              I               Mode
*                    FUNDS.TRANSFER                        As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 15 Jun 2011       Marimuthu S                 ODR-2011-04-0007 32         Modification made in REDO.APAP.NOF.CASH.WINDOW.DEP.LOOP.MTS
* 24 Aug 2011       Pradeep S                   PACS00106559                More product group considered as per setup
* 25 AUG 2011       jeeva t                     PACS00106559
*********************************************************************************************************
    $INCLUDE I_COMMON
    $INCLUDE I_EQUATE
    $INCLUDE I_ENQUIRY.COMMON
* $INCLUDE TAM.BP I_F.MULTI.TRANSACTION.SERVICE
    $INCLUDE I_F.AA.ARRANGEMENT
    $INCLUDE I_F.TELLER
    $INCLUDE I_F.FUNDS.TRANSFER
    $INCLUDE I_F.ACCOUNT
    $INCLUDE I_F.AA.PRODUCT.GROUP
    $INCLUDE TAM.BP I_F.REDO.H.TELLER.TXN.CODES
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
*  FN.MULTI.TRANSACTION.SERVICE = 'F.MULTI.TRANSACTION.SERVICE'
*  F.MULTI.TRANSACTION.SERVICE  = ''
*  CALL OPF(FN.MULTI.TRANSACTION.SERVICE,F.MULTI.TRANSACTION.SERVICE)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.TELLER = 'F.TELLER'
    F.TELLER  = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.HST = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HST = ''
    CALL OPF(FN.ACCOUNT.HST,F.ACCOUNT.HST)

    FN.AA.PRD.GRP = 'F.AA.PRODUCT.GROUP'
    F.AA.PRD.GRP = ''
    CALL OPF(FN.AA.PRD.GRP,F.AA.PRD.GRP)

    YTELLER.ID = ''; Y.TELLER.ID = ''
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
    Y.FUNDS.TXN.ID = ''; Y.TXN.CODE.LN = '';  YAA.FLG = 0; Y.ADD.AMT = 0
    Y.FUNDS.TXN.ID = ''; Y.SET.LOAN = ''
    R.TELLER                     = FIELD(Y.TT.PARAM.REC,'##',1)
    R.REDO.H.TELLER.TXN.CODES    = FIELD(Y.TT.PARAM.REC,'##',5)
    IF YTELLER.ID[1,2] EQ 'TT' THEN
        Y.TXN.CODE.LN = R.TELLER<TT.TE.TRANSACTION.CODE>
        Y.FUNDS.TXN.ID = R.TELLER<TT.TE.LOCAL.REF,L.INITIAL.ID.POS>
    END

    IF YTELLER.ID[1,2] EQ 'FT' THEN
        Y.TXN.CODE.LN = R.TELLER<FT.TRANSACTION.TYPE>
    END
    Y.LOAN.PRD.GRP.LIST = R.REDO.H.TELLER.TXN.CODES<TT.TXN.LOAN.PRD.GRP>        ;* PACS00106559 - S/E
    Y.SET.LOAN = ''; CASH.SET = ''; CHQ.SET = ''; TRANS.SET = ''
    LOCATE Y.TXN.CODE.LN IN Y.CASH.TXN.CODE<1> SETTING POS.CASH THEN
        Y.SET.LOAN = 'Y'
        CASH.SET = 'Y'
    END
    LOCATE Y.TXN.CODE.LN IN Y.CHQ.TXN.CODE<1> SETTING POS.CQ THEN
        Y.SET.LOAN = 'Y'
        CHQ.SET = 'Y'
    END
    LOCATE Y.TXN.CODE.LN IN Y.TFR.TXN.CODE<1> SETTING POS.TRNS THEN
        Y.SET.LOAN = 'Y'
        TRANS.SET = 'Y'
    END
    IF Y.SET.LOAN NE 'Y' THEN
        RETURN
    END
    IF TELLER.ID[1,2] EQ 'FT' THEN
        GOSUB CHECK.FUNDS.TRANS
    END ELSE
        GOSUB CHECK.TELLER
    END

    IF YAA.FLG EQ 1 THEN
        RETURN
    END

    GOSUB CHECK.ARR.PRODUCT.GROUP
    GOSUB GET.AMOUNT
    RETURN

CHECK.TELLER:
*------------
    YNARR.VAL = ''
    YNARR.VAL = R.TELLER<TT.TE.NARRATIVE.1>
    Y.DR.CR.MARK = R.TELLER<TT.TE.DR.CR.MARKER>
    IF Y.DR.CR.MARK EQ 'DEBIT' THEN
        Y.TT.CCY  = R.TELLER<TT.TE.CURRENCY.2>
        Y.CRED.AC = R.TELLER<TT.TE.ACCOUNT.2>
        IF NOT(NUM(Y.CRED.AC)) THEN
            Y.CRED.AC = YNARR.VAL
        END
        GOSUB READ.ACCOUNT
        GOSUB READ.AA.ARRANGEMENT
        IF NOT(R.AA.ARRANGEMENT) THEN
            YAA.FLG = 1
        END ELSE
            Y.ADD.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
            IF NOT(Y.ADD.AMT) THEN
                IF R.TELLER<TT.TE.CURRENCY.2> EQ LCCY THEN
                    Y.ADD.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.2,1>
                END ELSE
                    Y.ADD.AMT = R.TELLER<TT.TE.AMOUNT.FCY.2>
                END
            END
        END
    END
    GOSUB CHECK.TELLER.1
    RETURN

CHECK.TELLER.1:
**************
    IF Y.DR.CR.MARK EQ 'CREDIT' THEN
        Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>
        Y.CRED.AC = R.TELLER<TT.TE.ACCOUNT.1>
        IF NOT(NUM(Y.CRED.AC)) THEN
            Y.CRED.AC = YNARR.VAL
        END
        GOSUB READ.ACCOUNT
        GOSUB READ.AA.ARRANGEMENT
        IF NOT(R.AA.ARRANGEMENT) THEN
            YAA.FLG = 1
        END ELSE
            Y.ADD.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
            IF NOT(Y.ADD.AMT) THEN
                IF R.TELLER<TT.TE.CURRENCY.1> EQ LCCY THEN
                    Y.ADD.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
                END ELSE
                    Y.ADD.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
                END
            END
        END
    END
    RETURN

CHECK.FUNDS.TRANS:
******************
    Y.CRED.AC = R.TELLER<FT.CREDIT.ACCT.NO>
    GOSUB READ.ACCOUNT
    Y.TT.CCY = R.TELLER<FT.CREDIT.CURRENCY>
    IF NOT(Y.TT.CCY) THEN
        Y.TT.CCY = LCCY
    END
    IF NOT(AA.ARRANGEMENT.ID) THEN
        YAA.FLG = 1
    END
    GOSUB READ.AA.ARRANGEMENT
    IF NOT(R.AA.ARRANGEMENT) THEN
        YAA.FLG = 1
    END
    Y.ADD.AMT = R.TELLER<FT.AMOUNT.CREDITED>[4,99]
    RETURN

************************
CHECK.ARR.PRODUCT.GROUP:
************************
* In this para of the code, the ARRANGEMENT record is read and checkd for PRODUCT.GROUP
    Y.MORTGAGE = '' ; Y.COMERCIAL = '' ; Y.CONSUMO = ''
    LOCATE R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP> IN Y.LOAN.PRD.GRP.LIST<1,1> SETTING GRP.POS THEN
        GOSUB GET.GRP.DESP
        YAA.PROD = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
        BEGIN CASE
        CASE R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP> EQ 'HIPOTECARIO'
            Y.MORTGAGE = 1

        CASE R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP> EQ 'COMERCIAL'
            Y.COMERCIAL = 1

        CASE R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP> EQ 'CONSUMO'
            Y.CONSUMO = 1
        CASE R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP> EQ 'LINEAS.DE.CREDITO'
            PFM = '';PVM = ''; PSM = ''
            FINDSTR 'COM' IN YAA.PROD SETTING PFM,PVM,PSM THEN
                Y.COMERCIAL = 1
            END
            PFM = '';PVM = ''; PSM = ''
            FINDSTR 'CONS' IN YAA.PROD SETTING PFM,PVM,PSM THEN
                Y.CONSUMO = 1
            END
        CASE 1
            Y.OTHER = 1
        END CASE
    END
    RETURN

***************
GET.GRP.DESP:
***************
    Y.AA.PRD.GRP.ID = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    R.AA.PRD.GRP = ''; ERR.GRP = ''
    CALL F.READ(FN.AA.PRD.GRP,Y.AA.PRD.GRP.ID,R.AA.PRD.GRP,F.AA.PRD.GRP,ERR.GRP)
    Y.PRD.GRP.DESP = R.AA.PRD.GRP<AA.PG.DESCRIPTION,2>
    IF NOT(Y.PRD.GRP.DESP) THEN
        Y.PRD.GRP.DESP = R.AA.PRD.GRP<AA.PG.DESCRIPTION,1>
    END
    RETURN

***********
GET.AMOUNT:
***********
* In this para of the code, the TT and FT records are read and the amounts are fetched
    Y.MORTGAGE.CASH = '' ; Y.MORTGAGE.CHQ = '' ; Y.MORTGAGE.TFR = ''

    IF CASH.SET EQ 'Y' THEN
        IF Y.MORTGAGE THEN
            Y.MORTGAGE.CASH = 1
            Y.VM.POS        = 11
            GOSUB AMEND.FINAL.ARRAY
        END

        IF Y.COMERCIAL THEN
            Y.COMERCIAL.CASH = 1
            Y.VM.POS         = 12
            GOSUB AMEND.FINAL.ARRAY
        END

        IF Y.CONSUMO THEN
            Y.CONSUMO.CASH = 1
            Y.VM.POS       = 13
            GOSUB AMEND.FINAL.ARRAY
        END

        IF Y.OTHER THEN
            Y.OTHER.CASH   = 1
            Y.OTR.LOAN     = FIELD(Y.FINAL.ARRAY,VM,41,99)
            Y.OTR.LOAN.CNT = DCOUNT(Y.OTR.LOAN,VM)
            IF Y.OTR.LOAN THEN
                Y.VM.POS       = 40 + Y.OTR.LOAN.CNT
            END ELSE
                Y.VM.POS       = 40 + Y.OTR.LOAN.CNT + 1
            END
*           Y.VM.POS       = 40 + Y.OTR.LOAN.CNT + 1
            GOSUB AMEND.FINAL.ARRAY
        END
    END
    GOSUB GET.AMOUNT.CHQ
    RETURN

GET.AMOUNT.CHQ:
***************
    IF CHQ.SET EQ 'Y' THEN
        IF Y.MORTGAGE THEN
            Y.MORTGAGE.CHQ = 1
            Y.VM.POS        = 11
            GOSUB AMEND.FINAL.ARRAY
        END

        IF Y.COMERCIAL THEN
            Y.COMERCIAL.CHQ = 1
            Y.VM.POS        = 12
            GOSUB AMEND.FINAL.ARRAY
        END

        IF Y.CONSUMO THEN
            Y.CONSUMO.CHQ = 1
            Y.VM.POS      = 13
            GOSUB AMEND.FINAL.ARRAY
        END

        IF Y.OTHER THEN
            Y.OTHER.CHQ = 1
            Y.OTR.LOAN     = FIELD(Y.FINAL.ARRAY,VM,41,99)
            Y.OTR.LOAN.CNT = DCOUNT(Y.OTR.LOAN,VM)
            IF Y.OTR.LOAN THEN
                Y.VM.POS       = 40 + Y.OTR.LOAN.CNT
            END ELSE
                Y.VM.POS       = 40 + Y.OTR.LOAN.CNT + 1
            END
*           Y.VM.POS       = 40 + Y.OTR.LOAN.CNT + 1
            GOSUB AMEND.FINAL.ARRAY
        END
    END
    GOSUB GET.AMOUNT.TRANS
    RETURN

GET.AMOUNT.TRANS:
*****************
    IF TRANS.SET EQ 'Y' THEN
        IF Y.MORTGAGE THEN
            Y.MORTGAGE.TFR = 1
            Y.VM.POS        = 11
            GOSUB AMEND.FINAL.ARRAY
        END

        IF Y.COMERCIAL THEN
            Y.COMERCIAL.TFR = 1
            Y.VM.POS        = 12
            GOSUB AMEND.FINAL.ARRAY
        END

        IF Y.CONSUMO THEN
            Y.CONSUMO.TFR = 1
            Y.VM.POS      = 13
            GOSUB AMEND.FINAL.ARRAY
        END

        IF Y.OTHER THEN
            Y.OTHER.TFR = 1
            Y.OTR.LOAN     = FIELD(Y.FINAL.ARRAY,VM,41,99)
            Y.OTR.LOAN.CNT = DCOUNT(Y.OTR.LOAN,VM)
            IF Y.OTR.LOAN THEN
                Y.VM.POS       = 40 + Y.OTR.LOAN.CNT
            END ELSE
                Y.VM.POS       = 40 + Y.OTR.LOAN.CNT + 1
            END
*            Y.VM.POS       = 40 + Y.OTR.LOAN.CNT + 1
            GOSUB AMEND.FINAL.ARRAY
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
        Y.CCY.POS = DCOUNT(Y.CCY.LIST,FM)
    END

    IF Y.MORTGAGE.CASH OR Y.COMERCIAL.CASH OR Y.CONSUMO.CASH OR Y.OTHER.CASH THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4> += Y.ADD.AMT
    END
    IF Y.MORTGAGE.CHQ OR Y.COMERCIAL.CHQ OR Y.CONSUMO.CHQ OR Y.OTHER.CHQ THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5> += Y.ADD.AMT
    END

    IF Y.MORTGAGE.TFR OR Y.COMERCIAL.TFR OR Y.CONSUMO.TFR OR Y.OTHER.TFR THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6> += Y.ADD.AMT
    END

    IF Y.OTHER THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,2> = Y.PRD.GRP.DESP
    END

    Y.TT.LIST<-1> = YTELLER.ID
    RETURN
*--------------------------------------------------------------------------------------------------------
*******************************
READ.MULTI.TRANSACTION.SERVICE:
*******************************
* In this para of the code, file MULTI.TRANSACTION.SERVICE is read
    R.MULTI.TRANSACTION.SERVICE  = ''
    MULTI.TRANSACTION.SERVICE.ER = ''
    CALL F.READ(FN.MULTI.TRANSACTION.SERVICE,MULTI.TRANSACTION.SERVICE.ID,R.MULTI.TRANSACTION.SERVICE,F.MULTI.TRANSACTION.SERVICE,MULTI.TRANSACTION.SERVICE.ER)
    RETURN

********************
READ.AA.ARRANGEMENT:
********************
* In this para of the code, file AA.ARRANGEMENT is read
    R.AA.ARRANGEMENT  = '';    AA.ARRANGEMENT.ER = ''
    CALL F.READ(FN.AA.ARRANGEMENT,AA.ARRANGEMENT.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ER)
    RETURN

READ.ACCOUNT:
*************
    AC.ERR = ''; R.ACCOUNT = ''; AA.ARRANGEMENT.ID = ''
    CALL F.READ(FN.ACCOUNT,Y.CRED.AC,R.ACCOUNT,F.ACCOUNT,AC.ERR)
    IF NOT(R.ACCOUNT) THEN
        ACCOUNT.IDH = Y.CRED.AC; ERR.AC = ''
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HST,ACCOUNT.IDH,R.ACCOUNT,ERR.AC)
    END
    AA.ARRANGEMENT.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
    RETURN

*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'TELLER'
    FLD.ARRAY  = 'L.TT.POS.AUTHNM':VM:'T24.FS.REF':VM:'L.DEBIT.AMOUNT':VM:'L.CREDIT.AMOUNT':VM:'L.INITIAL.ID'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TT.POS.AUTHNM.POS  =  FLD.POS<1,1>
    LOC.T24.FS.REF = FLD.POS<1,2>
    LOC.L.DEBIT.AMOUNT.POS = FLD.POS<1,3>
    LOC.L.CREDIT.AMOUNT.POS = FLD.POS<1,4>
    L.INITIAL.ID.POS = FLD.POS<1,5>
    RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
