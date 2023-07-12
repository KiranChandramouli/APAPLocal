SUBROUTINE LAPAP.DESM.RUEDA.LOAD

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.DATES
    $INSERT I_LAPAP.DESM.RUEDA.COMO

    GOSUB OPEN.FILES

RETURN


OPEN.FILES:
**********

    Y.ARCHIVO.CARGA = "INFILE.DESMONTE.RUEDA.txt";

    FN.AA.BILL = 'F.AA.BILL.DETAILS';
    F.AA.BILL = '';
    CALL OPF(FN.AA.BILL,F.AA.BILL)

    FN.AA.INTEREST.ACCRUALS = 'F.AA.INTEREST.ACCRUALS';
    F.AA.INTEREST.ACCRUALS = '';
    CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)

    FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'; F.AA.ARR.TERM.AMOUNT = '';
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)

    FN.LAPAP.DESM.RUEDA = "F.LAPAP.DESM.RUEDA";
    F.LAPAP.DESM.RUEDA = "";
    CALL OPF (FN.LAPAP.DESM.RUEDA,F.LAPAP.DESM.RUEDA)

    FN.CHK.DIR = "&SAVEDLISTS&" ; F.CHK.DIR = "";
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    FN.CHK.DIR1 = "DMFILES";
    F.CHK.DIR1 = "";
    CALL OPF(FN.CHK.DIR1,F.CHK.DIR1)

    FN.APAP.H.INSURANCE.DETAILS = 'F.APAP.H.INSURANCE.DETAILS';    F.APAP.H.INSURANCE.DETAILS = '';
    CALL OPF(FN.APAP.H.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS)

    Y.TODAY = R.DATES(EB.DAT.TODAY)

RETURN

END
