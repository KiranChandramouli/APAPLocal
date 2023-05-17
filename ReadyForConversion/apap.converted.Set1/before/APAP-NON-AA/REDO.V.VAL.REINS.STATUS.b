*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
  SUBROUTINE REDO.V.VAL.REINS.STATUS
*-----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.VAL.REINS.STATUS
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION: This routine is validation routine to reinstate check for TELLER
* TELLER,REDO.REINSTATE
*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*07.04.2013     H GANESH     ODR-2009-12-0285  INITIAL CREATION
*----------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.REDO.ADMIN.CHQ.DETAILS

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
  FN.REDO.ADMIN.CHQ.DETAILS   = 'F.REDO.ADMIN.CHQ.DETAILS'
  F.REDO.ADMIN.CHQ.DETAILS    = ''
*
  Y.REDO.ADMIN.CHQ.DETAILS.ID = R.NEW(TT.TE.CHEQUE.NUMBER)
  R.REDO.ADMIN.CHQ.DETAILS    = ''
  Y.ADMIN.CHQ.ERR             = ''
*
  RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
  CALL OPF(FN.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS)
  RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
*
  CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,Y.REDO.ADMIN.CHQ.DETAILS.ID,R.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,Y.ADMIN.CHQ.ERR)
  IF R.REDO.ADMIN.CHQ.DETAILS NE "" THEN
*
    Y.STATUS = R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS>
    IF V$FUNCTION EQ 'I' THEN
      IF Y.STATUS NE 'ISSUED' AND Y.STATUS NE 'STOP.PAID.CNFRM' AND Y.STATUS NE 'STOP.PAID.NON.CNFRM' AND Y.STATUS NE '' THEN
        GOSUB THROUGH.ERROR
      END
    END
*
    IF V$FUNCTION EQ 'R' THEN
      IF Y.STATUS NE 'ISSUED' AND Y.STATUS NE '' THEN
        AF    = TT.TE.CHEQUE.NUMBER
        ETEXT = 'EB-INVALID.CHQ.STATUS'
        CALL STORE.END.ERROR
      END
    END
*
  END
*
  RETURN
*
*----------------------------------------------------------------------
THROUGH.ERROR:
*----------------------------------------------------------------------
* To through the Error Message
  AF    = TT.TE.CHEQUE.NUMBER
  ETEXT = 'EB-INVALID.REINST.STATUS'
  CALL STORE.END.ERROR
*
  RETURN
END
