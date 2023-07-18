*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.S.RTE.FCY.EXG.RATE(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :APAP
*Program   Name    :REDO.S.RTE.FCY.EXG.RATE
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the Exchange Rate for RTE form
*
* Date           ref            who                description
* 16-08-2011     New RTE Form   APAP               New RTE Form
* ----------------------------------------------------------------------------------

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.TELLER
    $INSERT T24.BP I_F.FUNDS.TRANSFER
    $INSERT T24.BP I_F.TELLER.TRANSACTION
    $INSERT T24.BP I_F.FT.TXN.TYPE.CONDITION
    $INSERT USPLATFORM.BP I_F.T24.FUND.SERVICES
    $INSERT USPLATFORM.BP I_F.TFS.TRANSACTION
    $INSERT TAM.BP I_REDO.DEAL.SLIP.COMMON

    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.CURRENCY
    $INSERT LAPAP.BP I_F.REDO.RTE.CUST.CASHTXN

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

    FN.TFS.TRANSACTION = 'F.TFS.TRANSACTION'
    F.TFS.TRANSACTION  = ''
    CALL OPF(FN.TFS.TRANSACTION,F.TFS.TRANSACTION)

    FN.REDO.RTE.CUST.CASHTXN = 'F.REDO.RTE.CUST.CASHTXN'
    F.REDO.RTE.CUST.CASHTXN = ''
    CALL OPF(FN.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN)

    LRF.APP = "CURRENCY"
    LRF.FIELD = "L.CU.AMLBUY.RT"
    LRF.POS=''
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)
    L.CU.AMLBUY.RT.POS = LRF.POS<1,1>

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

        Y.TRANSACTION.CNT = DCOUNT(Y.TRANSACTION.CODE,VM)
        Y.VAR1=1
        LOOP
        WHILE Y.VAR1 LE Y.TRANSACTION.CNT
            Y.TRANS = Y.TRANSACTION.CODE<1,Y.VAR1>
            IF Y.TRANS EQ 'CASHDEP' OR Y.TRANS EQ 'FCASHDEP' OR Y.TRANS EQ 'CASHDEPD' THEN
                Y.RTE.TXN.CCY = R.TFS.REC<TFS.CURRENCY><1,Y.VAR1>
                Y.VAR1 += Y.TRANSACTION.CNT
            END
            Y.VAR1++
        REPEAT

    END CASE
    IF Y.RTE.TXN.CCY NE 'DOP' THEN
        R.CURRENCY = ''
        CCY.ERR = ''
        CALL F.READ(FN.CURRENCY,Y.RTE.TXN.CCY,R.CURRENCY,F.CURRENCY,CCY.ERR)
        IF R.CURRENCY THEN
            Y.OUT = R.CURRENCY<EB.CUR.LOCAL.REF,L.CU.AMLBUY.RT.POS>
        END ELSE
            Y.OUT = ''
        END
    END ELSE
        Y.OUT = ''
    END

    RETURN
*------------------------------------------------------------------------------------
END
