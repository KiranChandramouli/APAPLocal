* @ValidationCode : MjoxMDgxMzkxMTk3OkNwMTI1MjoxNjg5NzQ0NTcxMDUwOklUU1M6LTE6LTE6MTU3MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Jul 2023 10:59:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1570
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.S.RTE.ORIGINAL.AMT(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :APAP
*Program   Name    :REDO.S.RTE.USD.AMT
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the AMOUNT for RTE form
*
* Date           ref            who                description
* 16-08-2011     New RTE Form   APAP               New RTE Form
*13/07/2023      Conversion tool            R22 Auto Conversion             Nochange
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.TFS.TRANSACTION
    $INSERT I_REDO.DEAL.SLIP.COMMON
    $INSERT I_F.REDO.PAY.TYPE
    $INSERT I_F.REDO.RTE.CATEG.POSITION
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CURRENCY
    $INSERT I_F.REDO.RTE.CUST.CASHTXN
 
    GOSUB INIT

    GOSUB PROCESS
RETURN
*********
INIT:
*********

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY  = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    CALL OPF(FN.FT,F.FT)

    FN.TFS = 'F.T24.FUND.SERVICES'
    F.TFS = ''
    CALL OPF(FN.TFS,F.TFS)

    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    FN.REDO.PAY.TYPE = 'F.REDO.PAY.TYPE'
    F.REDO.PAY.TYPE = ''
    CALL OPF(FN.REDO.PAY.TYPE,F.REDO.PAY.TYPE)

    FN.REDO.RTE.CATEG.POS = 'F.REDO.RTE.CATEG.POSITION'
    F.REDO.RTE.CATEG.POS = ''
    CALL OPF(FN.REDO.RTE.CATEG.POS,F.REDO.RTE.CATEG.POS)

    FN.TFS.TRANSACTION = 'F.TFS.TRANSACTION'
    F.TFS.TRANSACTION  = ''
    CALL OPF(FN.TFS.TRANSACTION,F.TFS.TRANSACTION)

    FN.FTTC = 'F.FT.TXN.TYPE.CONDITION'
    F.FTTC  = ''
    CALL OPF(FN.FTTC,F.FTTC)

    FN.REDO.RTE.CUST.CASHTXN = 'F.REDO.RTE.CUST.CASHTXN'
    F.REDO.RTE.CUST.CASHTXN = ''
    CALL OPF(FN.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN)

    LRF.APP = "CURRENCY":@FM:"TELLER"

    LRF.FIELD = "L.CU.AMLBUY.RT":@FM:'L.TT.CLIENT.COD':@VM:'L.TT.LEGAL.ID'
    LRF.POS = ''
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)
    POS.L.CU.AMLBUY.RT = LRF.POS<1,1>
    POS.CUSTOMER.CODE = LRF.POS<2,1>
    POS.TT.LEGAL.ID = LRF.POS<2,2>

    Y.CAL.TODAY = OCONV(DATE(),"DYMD")
    Y.CAL.TODAY = EREPLACE(Y.CAL.TODAY,' ', '')


RETURN

**************
PROCESS:
*************

    BEGIN CASE

        CASE ID.NEW[1,2] EQ 'TT'
            CALL F.READ(FN.TELLER,ID.NEW,R.TELLER.REC,F.TELLER,TELLER.ERR)
            Y.RTE.TXN.CCY = R.TELLER.REC<TT.TE.CURRENCY.1>

        CASE ID.NEW[1,2] EQ 'FT'
            CALL F.READ(FN.FT,ID.NEW,R.FT.REC,F.FT,FT.ERR)
            Y.RTE.TXN.CCY = R.FT.REC<FT.CREDIT.CURRENCY>

        CASE ID.NEW[1,5] EQ 'T24FS'
            CALL F.READ(FN.TFS,ID.NEW,R.TFS.REC,F.TFS,TFS.ERR)
            Y.TRANSACTION.CODE = R.TFS.REC<TFS.TRANSACTION>

            Y.TRANSACTION.CNT = DCOUNT(Y.TRANSACTION.CODE,@VM)
            Y.VAR1=1
            LOOP
            WHILE Y.VAR1 LE Y.TRANSACTION.CNT
                Y.TRANS = Y.TRANSACTION.CODE<1,Y.VAR1>
                IF Y.TRANS EQ 'CASHDEP' OR Y.TRANS EQ 'FCASHDEP' OR Y.TRANS EQ 'CASHDEPD' THEN
                    Y.RTE.TXN.CCY = R.NEW(TFS.CURRENCY)<1,Y.VAR1>
                    Y.VAR1 += Y.TRANSACTION.CNT
                END
                Y.VAR1 += 1
            REPEAT

    END CASE

    GOSUB GET.CASH.AMOUNT

*    GOSUB ORIGINAL.CCY.AMOUNT

RETURN

**********************
GET.CASH.AMOUNT:
***********************
    Y.RTE.ACCT = VAR.ACCOUNT
    CALL F.READ(FN.ACCOUNT,Y.RTE.ACCT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    Y.CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
    IF Y.CUSTOMER.ID THEN
        Y.RTE.CUSTOMER = Y.CUSTOMER.ID
    END ELSE
        Y.CUSTOMER.CODE = R.TELLER.REC<TT.TE.LOCAL.REF,POS.CUSTOMER.CODE>
        IF NUM(Y.CUSTOMER.CODE[1,2]) AND Y.CUSTOMER.CODE NE '' THEN
            Y.RTE.CUSTOMER = Y.CUSTOMER.CODE
        END
    END
    IF Y.RTE.CUSTOMER EQ '' OR Y.RTE.CUSTOMER EQ 'NA' THEN
        YLEG.TT.VAL = R.TELLER.REC<TT.TE.LOCAL.REF,POS.TT.LEGAL.ID>
        IF YLEG.TT.VAL THEN
            Y.RTE.CUSTOMER = FIELD(YLEG.TT.VAL,'.',1):'.':FIELD(YLEG.TT.VAL,'.',2)
        END
    END
    Y.RTE.ID = Y.RTE.CUSTOMER:'.':Y.CAL.TODAY
    CALL F.READ(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.RTE.REC,F.REDO.RTE.CUST.CASHTXN,RTE.REC.ERR)
    IF R.RTE.REC THEN
        LOCATE ID.NEW IN R.RTE.REC<RTE.TXN.ID,1> SETTING TXN.POS THEN
            Y.CASH.AMOUNT = R.RTE.REC<RTE.CASH.AMOUNT,TXN.POS>
        END ELSE
            Y.CASH.AMOUNT = VAR.AMOUNT
        END
    END ELSE
        Y.CASH.AMOUNT = VAR.AMOUNT
    END
    Y.OUT = FMT(Y.CASH.AMOUNT,"R2,#15")
RETURN

********************
ORIGINAL.CCY.AMOUNT:
********************
    IF Y.RTE.TXN.CCY NE LCCY THEN
        CALL CACHE.READ(FN.CURRENCY,Y.RTE.TXN.CCY,R.CURRENCY,CURR.ERR)
        CUR.AMLBUY.RATE = R.CURRENCY<EB.CUR.LOCAL.REF,POS.L.CU.AMLBUY.RT>
        Y.ORIG.AMT = Y.CASH.AMOUNT*CUR.AMLBUY.RATE
        Y.OUT = FMT(Y.ORIG.AMT,"R2,#15")
    END ELSE
        Y.OUT = Y.CASH.AMOUNT
    END
RETURN

*------------------------------------------------------------------------------------
END
