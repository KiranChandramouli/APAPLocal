*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.MGR.CHKSTATUS
*-----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.VAL.MGR.CHKSTATUS
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION: This routine is validation routine to CREDIT.THEIR.REF or NARRATIVE field for
* TELLER & FT in following versions
* FT,MGR.REVERSE.CHQ
* TELLER,MGR.CASH.CHQ
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
$INSERT I_F.REDO.MANAGER.CHQ.DETAILS

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
  FN.REDO.MANAGER.CHQ.DETAILS='F.REDO.MANAGER.CHQ.DETAILS'
  F.REDO.MANAGER.CHQ.DETAILS=''
  RETURN

*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
  CALL OPF(FN.REDO.MANAGER.CHQ.DETAILS,F.REDO.MANAGER.CHQ.DETAILS)
  RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

  IF APPLICATION EQ 'TELLER' THEN
    Y.REDO.MANAGER.CHQ.DETAILS.ID=COMI
  END

  IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
    Y.REDO.MANAGER.CHQ.DETAILS.ID=COMI
  END

  CALL F.READ(FN.REDO.MANAGER.CHQ.DETAILS,Y.REDO.MANAGER.CHQ.DETAILS.ID,R.REDO.MANAGER.CHQ.DETAILS,F.REDO.MANAGER.CHQ.DETAILS,MAN.CHQ.ERR)
  IF R.REDO.MANAGER.CHQ.DETAILS EQ '' THEN
    RETURN
  END

  Y.STATUS=R.REDO.MANAGER.CHQ.DETAILS<MAN.CHQ.DET.STATUS>
  IF Y.STATUS NE 'ISSUED' AND Y.STATUS NE 'STOP.PAID.CNFRM' AND Y.STATUS NE 'STOP.PAID.NON.CNFRM' AND Y.STATUS NE '' THEN
    GOSUB THROUGH.ERROR
  END
  RETURN
*----------------------------------------------------------------------
THROUGH.ERROR:
*----------------------------------------------------------------------
  IF PGM.VERSION EQ ',MGR.REVERSE.CHQ' OR PGM.VERSION EQ ',MGR.CASH.CHQ' THEN
    ETEXT='EB-INVALID.CHQ.STATUS'
    CALL STORE.END.ERROR
  END
  IF PGM.VERSION EQ ',REINSTATE' THEN
    ETEXT='EB-INVALID.REINST.STATUS'
    CALL STORE.END.ERROR
  END
  RETURN
END
