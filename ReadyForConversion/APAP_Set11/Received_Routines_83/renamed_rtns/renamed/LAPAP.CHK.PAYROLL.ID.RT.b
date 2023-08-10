*-----------------------------------------------------------------------------
* <Rating>87</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.CHK.PAYROLL.ID.RT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT BP I_F.LAPAP.BULK.PAYROLL

    GOSUB DO.CHECK
    RETURN

DO.CHECK:
*IF NOT(R.NEW(ST.LAP39.INPUTTER)) THEN RETURN  ;* Could be a New Record
    IF R.NEW(ST.LAP39.RECORD.STATUS) THEN RETURN  ;* Could be an unauthorized record


    R.NEW(ST.LAP39.PAYROLL.ID) = ID.NEW
    RETURN

END
