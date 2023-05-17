SUBROUTINE REDO.UNAUTH.FX.OVRIDE
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed at check Record Routine for TELLER VERSIONS
*------------------------------------------------------------------------------------------
*
* COMPANY NAME : APAP
* DEVELOPED BY : VICTOR NAVA
* PROGRAM NAME : REDO.UNAUTH.FX.OVRIDE
*
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*       DATE             WHO                REFERENCE         DESCRIPTION
*
* -----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_REDO.FX.OVR.COMMON
*
    $INSERT I_F.FOREX

*


    R.NEW(FX.OVERRIDE) = Y.FX.OVERRIDE.DET

*
RETURN

END
