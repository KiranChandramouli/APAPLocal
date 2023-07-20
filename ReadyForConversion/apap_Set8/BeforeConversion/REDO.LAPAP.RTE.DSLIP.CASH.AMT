* -----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>68</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.LAPAP.RTE.DSLIP.CASH.AMT(Y.OUT)
* --------------------------------------------------------------------------------
* Company   Name    :Asociacion Popular de Ahorros y Prestamos
* Developed By      :APAP
* Program   Name    :REDO.LAPAP.RTE.DSLIP.CASH.AMT
* ---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the credit account value
*  ----------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT TAM.BP I_REDO.DEAL.SLIP.COMMON
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT LAPAP.BP I_F.REDO.RTE.CUST.CASHTXN
    $INSERT T24.BP I_F.TELLER
    $INSERT T24.BP I_F.FUNDS.TRANSFER
    $INSERT USPLATFORM.BP I_F.T24.FUND.SERVICES

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    CALL OPF(FN.FT,F.FT)

    FN.TFS = 'F.T24.FUND.SERVICES'
    F.TFS = ''
    CALL OPF(FN.TFS,F.TFS)

    FN.REDO.RTE.CUST.CASHTXN = 'F.REDO.RTE.CUST.CASHTXN'
    F.REDO.RTE.CUST.CASHTXN = ''
    CALL OPF(FN.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN)

    Y.CAL.TODAY = OCONV(DATE(),"DYMD")
    Y.CAL.TODAY = EREPLACE(Y.CAL.TODAY,' ', '')

    GOSUB PROCESS
    RETURN

PROCESS:

    Y.TXN.ACCOUNT = VAR.ACCOUNT

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)
    FN.TELLER.NAU = 'F.TELLER$NAU'
    F.TELLER.NAU = ''
    CALL OPF(FN.TELLER.NAU,F.TELLER.NAU)

    CALL F.READ(FN.TELLER.NAU,ID.NEW,R.REC,F.TELLER.NAU,ERR.APPLICATION)
    IF R.REC EQ '' THEN
        ERR.APPLICATION = ""; R.REC = ""
        CALL F.READ(FN.TELLER,ID.NEW,R.REC,F.TELLER,ERR.APPLICATION)
    END
    IF LEN(Y.TXN.ACCOUNT) EQ 16 THEN
        IF R.REC THEN
            LRF.APP = 'TELLER'
            LRF.FIELD = 'L.TT.CLIENT.COD'
            LRF.POS=''
            CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)
            L.TT.CLIENT.COD.POS = LRF.POS<1,1>
            IF ID.NEW[1,2] EQ 'TT' THEN
                Y.CUST.ID = R.REC<TT.TE.LOCAL.REF><1,L.TT.CLIENT.COD.POS>
            END ELSE
                Y.OUT = FMT(VAR.AMOUNT,"R2,#15")
            END
*            IF Y.CUST.ID NE '' AND Y.CUST.ID NE 'NA' THEN
            IF Y.CUST.ID NE '' THEN
* 20170524 - Fix - To display the FCY amount in the RTE form
                IF R.REC<TT.TE.CURRENCY.1> NE LCCY THEN
                    Y.OUT = FMT(R.REC<TT.TE.AMOUNT.FCY.1>,"R2,#15")
                END ELSE
                    GOSUB GET.CASH.AMOUNT
                END
            END ELSE
                Y.OUT = FMT(VAR.AMOUNT,"R2,#15")
            END
        END ELSE
            Y.OUT = FMT(VAR.AMOUNT,"R2,#15")
        END
    END ELSE
        CALL F.READ(FN.ACCOUNT,Y.TXN.ACCOUNT,R.ACCOUNT,F.ACCOUNT,AC.ERR)
        IF R.ACCOUNT THEN
            Y.CUST.ID = R.ACCOUNT<AC.CUSTOMER>
            GOSUB GET.CASH.AMOUNT
        END ELSE
            Y.OUT = FMT(VAR.AMOUNT,"R2,#15")
        END
    END
    GOSUB CHECK.CCY

    IF Y.RTE.TXN.CCY EQ LCCY THEN
        Y.OUT = ''
    END ELSE
        Y.OUT = FMT(VAR.AMOUNT,"R2,#15")
    END

    RETURN


GET.CASH.AMOUNT:
****************
    Y.RTE.ID = Y.CUST.ID:'.':Y.CAL.TODAY
    CALL F.READ(FN.REDO.RTE.CUST.CASHTXN,Y.RTE.ID,R.RTE.REC,F.REDO.RTE.CUST.CASHTXN,RTE.REC.ERR)
    IF R.RTE.REC THEN
        LOCATE ID.NEW IN R.RTE.REC<RTE.TXN.ID,1> SETTING TXN.POS THEN
            Y.OUT = FMT(R.RTE.REC<RTE.CASH.AMOUNT,TXN.POS>,"R2,#15")
        END ELSE
            Y.OUT = FMT(VAR.AMOUNT,"R2,#15")
        END
    END ELSE
        Y.OUT = FMT(VAR.AMOUNT,"R2,#15")
    END
    RETURN

**********
CHECK.CCY:
************

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
                Y.RTE.TXN.CCY = R.NEW(TFS.CURRENCY)<1,Y.VAR1>
                Y.VAR1 += Y.TRANSACTION.CNT
            END
            Y.VAR1++
        REPEAT

    END CASE

    RETURN

END
