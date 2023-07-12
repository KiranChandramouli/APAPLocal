SUBROUTINE REDO.S.RTE.TXN.TYPE(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :APAP
*Program   Name    :REDO.S.RTE.TXN.TYPE
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the Transaction Type for RTE form
*
* Date           ref            who                description
* 16-08-2011     New RTE Form   APAP               New RTE Form
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

    GOSUB INIT
    GOSUB PROCESS
RETURN
*********
INIT:
*********
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

    LRF.APP = "TELLER.TRANSACTION":@FM:"FT.TXN.TYPE.CONDITION"

    LRF.FIELD = "L.TT.PAY.TYPE"
    LRF.FIELD<-1> = "L.FTTC.PAY.TYPE"
    LRF.POS = ''
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)

    Y.TT.PAY.TYPE.POS = LRF.POS<1,1>
    POS.L.FTTC.PAY.TYPE = LRF.POS<2,1>
RETURN

**************
PROCESS:
*************

    BEGIN CASE

        CASE ID.NEW[1,2] EQ 'TT'
            CALL F.READ(FN.TELLER,ID.NEW,R.TELLER.REC,F.TELLER,TELLER.ERR)
            Y.TT.TXN.ID = R.TELLER.REC<TT.TE.TRANSACTION.CODE>
            GOSUB CHECK.TT.TRANSACTION

        CASE ID.NEW[1,2] EQ 'FT'
            CALL F.READ(FN.FT,ID.NEW,R.FT.REC,F.FT,FT.ERR)
            Y.FTTC = R.FT.REC<FT.TRANSACTION.TYPE>
            CALL CACHE.READ(FN.FTTC, Y.FTTC, R.FTTC, FTTC.ERR)
            IF R.FTTC THEN
                Y.TT.PAY.TYPE.ID = R.FTTC<FT6.LOCAL.REF,POS.L.FTTC.PAY.TYPE>
                GOSUB TT.PAY.TYPE
            END

        CASE ID.NEW[1,5] EQ 'T24FS'
            CALL F.READ(FN.TFS,ID.NEW,R.TFS.REC,F.TFS,TFS.ERR)
            Y.TRANSACTION.CODE = R.TFS.REC<TFS.TRANSACTION>

            Y.TRANSACTION.CNT = DCOUNT(Y.TRANSACTION.CODE,@VM)
            Y.VAR1=1
            LOOP
            WHILE Y.VAR1 LE Y.TRANSACTION.CNT
                Y.TRANS = Y.TRANSACTION.CODE<1,Y.VAR1>
                IF Y.TRANS EQ 'CASHDEP' OR Y.TRANS EQ 'FCASHDEP' OR Y.TRANS EQ 'CASHDEPD' THEN
                    CALL F.READ(FN.TFS.TRANSACTION,Y.TRANS,R.TFS.TRANSACTION,F.TFS.TRANSACTION,TFS.ERR)
                    Y.TT.TXN.ID = R.TFS.TRANSACTION<TFS.TXN.INTERFACE.AS>
                END
                Y.VAR1 += 1
            REPEAT
            GOSUB CHECK.TT.TRANSACTION

    END CASE

RETURN

**********************
CHECK.TT.TRANSACTION:
***********************
    R.TT.TXN = ''
    CALL CACHE.READ(FN.TELLER.TRANSACTION, Y.TT.TXN.ID, R.TT.TXN, TT.TXN.ERR)
    IF R.TT.TXN THEN
        Y.TT.PAY.TYPE.ID = R.TT.TXN<TT.TR.LOCAL.REF,Y.TT.PAY.TYPE.POS>
        GOSUB TT.PAY.TYPE
    END ELSE
        Y.OUT = ''
    END
RETURN

************
TT.PAY.TYPE:
************

    Y.PAY.TYPE.ID = Y.TT.PAY.TYPE.ID
    R.PAY.TYPE = ''
    CALL F.READ(FN.REDO.PAY.TYPE,Y.PAY.TYPE.ID,R.PAY.TYPE,F.REDO.PAY.TYPE,PAY.ERR)
    IF R.PAY.TYPE THEN
        Y.OUT = R.PAY.TYPE<REDO.PAY.TYPE.DESCRIPTION>
    END ELSE
        Y.OUT = ''
    END
RETURN

*------------------------------------------------------------------------------------
END
