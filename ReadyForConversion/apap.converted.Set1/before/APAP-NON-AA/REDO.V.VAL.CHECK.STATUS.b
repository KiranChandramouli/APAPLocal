*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
  SUBROUTINE REDO.V.VAL.CHECK.STATUS
*-----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.VAL.CHECK.STATUS
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION: This routine is validation routine to CREDIT.THEIR.REF
*  or NARRATIVE field in TELLER & FT
* FT,REVERSE.CHQ
* TELLER,CASH.CHQ
* FUNDS.TRANSFER,REINSTATE
* TELLER,REINSTATE



*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER & FT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*19.02.2010  H GANESH     ODR-2009-12-0285  INITIAL CREATION
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.REDO.ADMIN.CHQ.DETAILS
  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
  FN.REDO.ADMIN.CHQ.DETAILS='F.REDO.ADMIN.CHQ.DETAILS'
  F.REDO.ADMIN.CHQ.DETAILS=''
  RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
  CALL OPF(FN.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS)
  RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
  IF APPLICATION EQ 'TELLER' THEN
*Y.REDO.ADMIN.CHQ.DETAILS.ID=R.NEW(TT.TE.NARRATIVE.1)<1,1>
    Y.REDO.ADMIN.CHQ.DETAILS.ID=COMI
  END
  IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
*Y.REDO.ADMIN.CHQ.DETAILS.ID=R.NEW(FT.CREDIT.THEIR.REF)<1,1>
    Y.REDO.ADMIN.CHQ.DETAILS.ID=COMI
  END
  CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,Y.REDO.ADMIN.CHQ.DETAILS.ID,R.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,ADMIN.CHQ)
  Y.STATUS=R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS>
  IF V$FUNCTION EQ 'I' THEN
    IF Y.STATUS NE 'ISSUED' AND Y.STATUS NE 'STOP.PAID.CNFRM' AND Y.STATUS NE 'STOP.PAID.NON.CNFRM' AND Y.STATUS NE '' THEN
      GOSUB THROUGH.ERROR
    END
  END
  IF V$FUNCTION EQ 'R' THEN
    IF Y.STATUS NE 'ISSUED' AND Y.STATUS NE '' THEN
      ETEXT='EB-INVALID.CHQ.STATUS'
      CALL STORE.END.ERROR
    END
  END
  RETURN
*----------------------------------------------------------------------
THROUGH.ERROR:
*----------------------------------------------------------------------
* To through the Error Message

  IF PGM.VERSION EQ ',REVERSE.CHQ' OR PGM.VERSION EQ ',CASH.CHQ' THEN
    ETEXT='EB-INVALID.CHQ.STATUS'
    CALL STORE.END.ERROR
  END
  IF PGM.VERSION EQ ',REINSTATE' THEN
    ETEXT='EB-INVALID.REINST.STATUS'
    CALL STORE.END.ERROR
  END
  RETURN
END
