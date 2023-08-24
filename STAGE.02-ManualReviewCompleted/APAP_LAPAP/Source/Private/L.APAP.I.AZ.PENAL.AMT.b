$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.I.AZ.PENAL.AMT
*-----------------------------------------------------------------------------
*
* Description : The routine is to throw the override at the time of
*               changing the AZ local field L.AZ.PENAL.AMT.
* Developed By: Ashokkumar
*
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN and VM to @VM
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_GTS.COMMON
    $INSERT I_F.AZ.ACCOUNT


    IF V$FUNCTION EQ 'I' AND OFS$OPERATION EQ 'PROCESS' THEN
        GOSUB INIT
        GOSUB PROCESS
    END
RETURN

INIT:
*****
    LOC.AZ.PENAL.AMT = ''
    CALL GET.LOC.REF('AZ.ACCOUNT','L.AZ.PENAL.AMT',LOC.AZ.PENAL.AMT)
RETURN

PROCESS:
********
    VAR.PENAL.AMT = System.getVariable("CURRENT.PENAL.AMOUNT")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN	;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        VAR.PENAL.AMT = ""
    END
    Y.PENAL.AMT = R.NEW(AZ.LOCAL.REF)<1,LOC.AZ.PENAL.AMT>

    IF Y.PENAL.AMT NE VAR.PENAL.AMT THEN
        TEXT = 'AZ-PENALTY.RATE.CHANGE'
        YCURR.NO =  DCOUNT(R.NEW(AZ.OVERRIDE),@VM)+1
        CALL STORE.OVERRIDE(YCURR.NO)
    END

RETURN
END
