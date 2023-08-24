$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.CLEAR.TRANSACTION.QR.PIN
***********************************************************
* esvalerio - 05/12/22
* LIMPIAR TABLA ST.LAPAP.TRANSACTION.QR.PIN
***********************************************************
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_TSA.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.ST.LAPAP.TRANSACTION.QR.PIN

    GOSUB LOAD.VARIABLES
    GOSUB PROCESS
RETURN

LOAD.VARIABLES:
***************
    FN.TRANSACTION.QR.PIN = 'F.ST.LAPAP.TRANSACTION.QR.PIN'
    F.TRANSACTION.QR.PIN = ''
    CALL OPF(FN.TRANSACTION.QR.PIN,F.TRANSACTION.QR.PIN)

    FN.TRANSACTION.QR.PIN.HIS = 'F.ST.LAPAP.TRANSACTION.QR.PIN$HIS'
    F.TRANSACTION.QR.PIN.HIS = ''
    CALL OPF(FN.TRANSACTION.QR.PIN.HIS,F.TRANSACTION.QR.PIN.HIS)

RETURN

************************
PROCESS:
************************
    CALL EB.CLEAR.FILE(FN.TRANSACTION.QR.PIN, F.TRANSACTION.QR.PIN)
    CALL EB.CLEAR.FILE(FN.TRANSACTION.QR.PIN.HIS, F.TRANSACTION.QR.PIN.HIS)
RETURN
END
