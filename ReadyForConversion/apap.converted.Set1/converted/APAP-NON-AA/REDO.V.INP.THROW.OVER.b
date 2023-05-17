SUBROUTINE REDO.V.INP.THROW.OVER
*---------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.INP.THROW.OVER
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION: This routine is Input routine attached to REDO.ADMIN.CHQ.DETAILS,REVOKE.PAY
* To throw Override




*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.ADMIN.CHQ.DETAILS & REDO.MANAGER.CHQ.DETAILS
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*19.02.2010  H GANESH     ODR-2009-12-0285  INITIAL CREATION
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS
    $INSERT I_F.REDO.MANAGER.CHQ.DETAILS

    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    IF APPLICATION EQ 'REDO.ADMIN.CHQ.DETAILS' THEN
        CURR.NO=DCOUNT(R.NEW(ADMIN.CHQ.DET.OVERRIDE),@VM) + 1
    END
    IF APPLICATION EQ 'REDO.MANAGER.CHQ.DETAILS' THEN

        CURR.NO=DCOUNT(R.NEW(MAN.CHQ.DET.OVERRIDE),@VM) + 1
    END
    IF C$SPARE(110) EQ '' THEN
        TEXT='REVOKE.STOP.PAYMENT'
        CALL STORE.OVERRIDE(CURR.NO)
        C$SPARE(110) = 'REVOKE.STOP.PAYMENT'
    END
RETURN

END
