SUBROUTINE REDO.CHK.AZ.DEPOSIT.PRINT
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This routine will be executed at check Record Routine for the deposit versions.
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN : -NA-
* OUT : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.CHK.AZ.DEPOSIT.PRINT
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE WHO REFERENCE DESCRIPTION
* 08-11-2011 Sudharsanan S CR.18 Initial Creation.
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT

    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------
    LOC.REF = 'AZ.ACCOUNT'
    LOC.FIELD = 'L.AC.OTH.REASON'
    LOC.POS = ''
    CALL GET.LOC.REF(LOC.REF,LOC.FIELD,LOC.POS)
    POS.L.AC.OTH.REASON = LOC.POS
    CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
    Y.UNIQ.TIME = FIELD(UNIQUE.TIME,'.',1) + 1
    R.NEW(AZ.LOCAL.REF)<1,POS.L.AC.OTH.REASON> = Y.UNIQ.TIME
RETURN
*---------------------------------------------------------------------------------------------------------------
END