*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.LOCAL.CHECK
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.VAL.LOCAL.CHECK
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION:  This routine is validation routine to STATUS field in
* REDO.ADMIN.CHQ.DETAILS,STOP.PAY, REDO.MANAGER.CHQ.DETAILS, STOP.PAY



*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER
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
$INSERT I_GTS.COMMON

  GOSUB INITIALISE

  IF NOT(OFS.VAL.ONLY) THEN

    IF TAM.V.OVERRIDES EQ '' THEN

      GOSUB PROCESS
    END
  END

  RETURN

*----------------------------------------------------------------------
INITIALISE:

  FN.REDO.ADMIN.CHQ.DETAILS ='F.REDO.ADMIN.CHQ.DETAILS'
  F.REDO.ADMIN.CHQ.DETAILS = ''
  R.REDO.ADMIN.CHQ.DETAILS = ''
  CALL OPF(FN.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS)

  FN.REDO.MANAGER.CHQ.DETAILS = 'F.REDO.MANAGER.CHQ.DETAILS'
  F.REDO.MANAGER.CHQ.DETAILS = ''
  R.REDO.MANAGER.CHQ.DETAILS = ''
  CALL OPF(FN.REDO.MANAGER.CHQ.DETAILS,F.REDO.MANAGER.CHQ.DETAILS)

  TAM.V.OVERRIDES = OFS$OVERRIDES
  TAM.V.OVERRIDES = FIELD(TAM.V.OVERRIDES,FM,2)
  TAM.V.OVERRIDES = TRIM(TAM.V.OVERRIDES)

  RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

  IF APPLICATION EQ 'REDO.ADMIN.CHQ.DETAILS' THEN
    R.NEW(ADMIN.CHQ.DET.STOP.PAID.DATE)=TODAY
    Y.STATUS=R.NEW(ADMIN.CHQ.DET.STATUS)
    IF R.OLD(ADMIN.CHQ.DET.STATUS) NE 'ISSUED' AND Y.STATUS NE 'ISSUED' AND OFS.VAL.ONLY NE '1' AND OFS.VAL.ONLY NE '1' THEN
      IF C$SPARE(100) EQ '' THEN
        CURR.NO=DCOUNT(R.NEW(ADMIN.CHQ.DET.OVERRIDE),VM) + 1
        TEXT='CHQ.STATUS.NOT.ALLOW'
        CALL STORE.OVERRIDE(CURR.NO)
        C$SPARE(100) = 'CHQ.STATUS.NOT.ALLOW'
      END
    END
  END

  IF APPLICATION EQ 'REDO.MANAGER.CHQ.DETAILS' AND OFS.VAL.ONLY NE '1' THEN
    R.NEW(MAN.CHQ.DET.STOP.PAID.DATE)=TODAY
    Y.STATUS=R.NEW(MAN.CHQ.DET.STATUS)
    IF Y.STATUS NE 'ISSUED' THEN
      IF C$SPARE(101) EQ '' THEN
        CURR.NO=DCOUNT(R.NEW(MAN.CHQ.DET.OVERRIDE),VM) + 1
        TEXT='CHQ.STATUS.NOT.ALLOW'
        CALL STORE.OVERRIDE(CURR.NO)
        C$SPARE(101) = 'CHQ.STATUS.NOT.ALLOW'
      END
    END
  END
  RETURN
*----------------------------------------------------------------------
END
