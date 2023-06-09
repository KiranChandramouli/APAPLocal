SUBROUTINE LAPAP.VAL.TXN.REVERSED

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_GTS.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ST.L.REVERSE.TXN.JUSTIFY
    $INSERT I_F.T24.FUND.SERVICES


**Tables Loading

    FN.ST.L.REVERSE.TXN.JUSTIFY = 'F.ST.L.REVERSE.TXN.JUSTIFY'
    F.ST.L.REVERSE.TXN.JUSTIFY  = ''
    CALL OPF(FN.ST.L.REVERSE.TXN.JUSTIFY, F.ST.L.REVERSE.TXN.JUSTIFY)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER  = ''
    CALL OPF(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)

    FN.TELLER = 'F.TELLER$HIS'
    F.TELLER  = ''
    CALL OPF(FN.TELLER, F.TELLER)

    FN.T24.FUND.SERVICES = 'F.T24.FUND.SERVICES$HIS'
    F.T24.FUND.SERVICES  = ''
    CALL OPF(FN.T24.FUND.SERVICES, F.T24.FUND.SERVICES)


**Getting initial variables

    Y.ID.TXN=ID.NEW.LAST
    Y.ID.EXTRACT= LEFT(Y.ID.TXN,5)


**Modules Evaluation

    BEGIN CASE

        CASE INDEX(LEFT(Y.ID.EXTRACT,5),"TT",1)
            CALL F.READ.HISTORY(FN.TELLER,Y.ID.TXN,HIST.REC,F.TELLER, SEL.ERR)
            Y.STATUS=HIST.REC<TT.TE.RECORD.STATUS>

        CASE INDEX(Y.ID.EXTRACT,"FT",1)
            CALL F.READ.HISTORY(FN.FUNDS.TRANSFER,Y.ID.TXN,HIST.REC,F.FUNDS.TRANSFER, SEL.ERR)
            Y.STATUS=HIST.REC<FT.RECORD.STATUS>

        CASE INDEX(Y.ID.EXTRACT,"T24FS",1)
            CALL F.READ.HISTORY(FN.T24.FUND.SERVICES,Y.ID.TXN,HIST.REC,F.T24.FUND.SERVICES, SEL.ERR)
            Y.STATUS=HIST.REC<TFS.RECORD.STATUS>

    END CASE

    GOSUB STATUS.EVALUATION

RETURN


*********************
STATUS.EVALUATION:
*********************

    IF Y.STATUS EQ "REVE"
    THEN
        ETEXT='NO PUEDE MODIFICAR RECORD EN ESTATUS REVERSADO'
        CALL STORE.END.ERROR
    END

RETURN
END
