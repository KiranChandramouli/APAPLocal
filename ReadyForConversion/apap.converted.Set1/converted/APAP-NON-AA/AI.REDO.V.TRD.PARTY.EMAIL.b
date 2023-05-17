SUBROUTINE AI.REDO.V.TRD.PARTY.EMAIL
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
    $INSERT I_F.REDO.ADD.THIRDPARTY

    GOSUB VALIDA
RETURN

*---------
VALIDA:
*---------

    Y.EMAIL = R.NEW(ARC.TP.EMAIL)

    IF LEN(Y.EMAIL) EQ 0 THEN
        RETURN
    END

    AF = ARC.TP.EMAIL

    CALL AI.REDO.V.EMAIL(Y.EMAIL)

RETURN

END
