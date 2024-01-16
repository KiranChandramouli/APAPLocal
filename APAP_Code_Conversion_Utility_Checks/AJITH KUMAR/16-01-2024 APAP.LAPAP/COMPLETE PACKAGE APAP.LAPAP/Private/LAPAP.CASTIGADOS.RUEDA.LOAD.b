* @ValidationCode : MjoxMTUzMzg3MTA3OkNwMTI1MjoxNzAyMzgzMzk2MjgyOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Dec 2023 17:46:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.CASTIGADOS.RUEDA.LOAD
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts
* 08-12-2023         Suresh                Manual R22 conversion - OPF TO OPEN
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
*   CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    OPEN FN.CHK.DIR TO F.CHK.DIR ELSE   ;*R22 Manual Conversion
    END  ;*R22 Manual Conversion

    FN.CHK.DIR1 = "DMFILES";
    F.CHK.DIR1 = "";
    CALL OPF(FN.CHK.DIR1,F.CHK.DIR1)

    Y.TODAY = R.DATES(EB.DAT.TODAY)

RETURN

END
