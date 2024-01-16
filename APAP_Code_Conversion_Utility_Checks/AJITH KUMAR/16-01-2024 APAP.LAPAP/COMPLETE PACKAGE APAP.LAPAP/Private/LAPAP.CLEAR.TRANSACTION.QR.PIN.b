* @ValidationCode : MjotMTU2MzY3MjU3NjpDcDEyNTI6MTcwNDgwNDg4Mjg3NDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jan 2024 18:24:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
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
    *$INSERT I_TSA.COMMON
    *$INSERT I_BATCH.FILES
    $INSERT I_F.ST.LAPAP.TRANSACTION.QR.PIN
   $USING EB.Service

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
*    CALL EB.CLEAR.FILE(FN.TRANSACTION.QR.PIN, F.TRANSACTION.QR.PIN)
EB.Service.ClearFile(FN.TRANSACTION.QR.PIN, F.TRANSACTION.QR.PIN);* R22 UTILITY AUTO CONVERSION
*    CALL EB.CLEAR.FILE(FN.TRANSACTION.QR.PIN.HIS, F.TRANSACTION.QR.PIN.HIS)
EB.Service.ClearFile(FN.TRANSACTION.QR.PIN.HIS, F.TRANSACTION.QR.PIN.HIS);* R22 UTILITY AUTO CONVERSION
RETURN
END
