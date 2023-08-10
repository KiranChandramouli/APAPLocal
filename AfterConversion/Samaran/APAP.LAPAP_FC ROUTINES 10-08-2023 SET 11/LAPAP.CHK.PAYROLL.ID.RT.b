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
    $INSERT  I_COMMON  ;*R22 MANUAL CODE CONVERSION.START
    $INSERT  I_EQUATE
    $INSERT I_F.LAPAP.BULK.PAYROLL ;*R22 MANUAL CODE CONVERSION.END

    GOSUB DO.CHECK
RETURN

DO.CHECK:
*IF NOT(R.NEW(ST.LAP39.INPUTTER)) THEN RETURN  ;* Could be a New Record
    IF R.NEW(ST.LAP39.RECORD.STATUS) THEN RETURN  ;* Could be an unauthorized record


    R.NEW(ST.LAP39.PAYROLL.ID) = ID.NEW
RETURN

END
