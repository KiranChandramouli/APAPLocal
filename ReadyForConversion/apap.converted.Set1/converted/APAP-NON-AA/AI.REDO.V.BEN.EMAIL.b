SUBROUTINE AI.REDO.V.BEN.EMAIL
*-----------------------------------------------------------------------------
* This subroutine will validate a field containing an e-mail address.
*-----------------------------------------------------------------------------
*       Revision History
*
*       First Release:  February 8th
*       Developed for:  APAP
*       Developed by:   Martin Macias - Temenos - MartinMacias@temenos.com
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY

    GOSUB VALIDA
RETURN

*---------
VALIDA:
*---------

    LOC.REF.APPLICATION="BENEFICIARY"
    LOC.REF.FIELDS='L.BEN.EMAIL':@VM
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.BEN.EMAIL = LOC.REF.POS<1,1>
    Y.EMAIL = R.NEW(ARC.BEN.LOCAL.REF)<1,POS.L.BEN.EMAIL>

    IF LEN(Y.EMAIL) EQ 0 THEN
        RETURN
    END

    AF = ARC.BEN.LOCAL.REF
    AV = LOC.REF.POS<1,1>

    CALL AI.REDO.V.EMAIL(Y.EMAIL)

RETURN

END
