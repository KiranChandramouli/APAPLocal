$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.CASTIGADOS.RUEDA.LOAD
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.DATES
    $INSERT I_LAPAP.CASTIGADOS.RUEDA.COMO

    GOSUB OPEN.FILES

RETURN


OPEN.FILES:
**********

    Y.ARCHIVO.CARGA = "INFILE.CASTIGADO.RUEDA.txt";

    FN.AA.BILL = 'F.AA.BILL.DETAILS';
    F.AA.BILL = '';
    CALL OPF(FN.AA.BILL,F.AA.BILL)

    FN.LAPAP.CASTIGADOS.RUEDA = "F.LAPAP.CASTIGADOS.RUEDA";
    F.LAPAP.CASTIGADOS.RUEDA = "";
    CALL OPF (FN.LAPAP.CASTIGADOS.RUEDA,F.LAPAP.CASTIGADOS.RUEDA)

    FN.CHK.DIR = "&SAVEDLISTS&" ; F.CHK.DIR = "";
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    FN.CHK.DIR1 = "DMFILES";
    F.CHK.DIR1 = "";
    CALL OPF(FN.CHK.DIR1,F.CHK.DIR1)

    Y.TODAY = R.DATES(EB.DAT.TODAY)

RETURN

END
