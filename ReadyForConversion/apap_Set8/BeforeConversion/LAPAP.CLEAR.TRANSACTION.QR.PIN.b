*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.CLEAR.TRANSACTION.QR.PIN
***********************************************************
* esvalerio - 05/12/22
* LIMPIAR TABLA ST.LAPAP.TRANSACTION.QR.PIN 
***********************************************************
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_GTS.COMMON
    $INSERT T24.BP I_TSA.COMMON
    $INSERT T24.BP I_BATCH.FILES
    $INSERT BP I_F.ST.LAPAP.TRANSACTION.QR.PIN

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
