* @ValidationCode : Mjo4MjcwMDU0Njk6Q3AxMjUyOjE2OTE3NTEzNDg3Mjc6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Aug 2023 16:25:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>87</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.CHK.PAYROLL.ID.RT
*-----------------------------------------------------------------------------------------------------------------
*MODIFICATION HISTORY
* Date                  Who                    Reference                        Description
* ----                  ----                     ----                              ----
* 09-08-2023           Samaran T         R22 Manual Code Conversion     BP is removed from insert file.
*-------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON  ;*R22 MANUAL CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.LAPAP.BULK.PAYROLL ;*R22 MANUAL CODE CONVERSION.END

    GOSUB DO.CHECK
RETURN

DO.CHECK:
*IF NOT(R.NEW(ST.LAP39.INPUTTER)) THEN RETURN  ;* Could be a New Record
    IF R.NEW(ST.LAP39.RECORD.STATUS) THEN RETURN  ;* Could be an unauthorized record


    R.NEW(ST.LAP39.PAYROLL.ID) = ID.NEW
RETURN

END
