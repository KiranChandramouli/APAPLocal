*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.ORD.RECIEPT
*-----------------------------------------------------------------------------
* Description:
* This routine will be attached to the version REDO.ORDER.DETAIL,ORDER.RECEPTION as
* a validation routine
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.V.VAL.ORD.RECIEPT
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 12.04.2010  MARIMUTHU S     ODR-2009-11-0200  INITIAL CREATION
* -----------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.ORDER.DETAILS
*-----------------------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------------------

  GOSUB OPENFILES
  GOSUB PROCESS
  GOSUB PROGRAM.END
*-----------------------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------------------
  FN.REDO.H.ORDER.DETAILS = 'F.REDO.H.ORDER.DETAILS'
  F.REDO.H.ORDER.DETAILS = ''
  CALL OPF(FN.REDO.H.ORDER.DETAILS,F.REDO.H.ORDER.DETAILS)

  RETURN
*-----------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------
  IF R.NEW(RE.ORD.REJECTED.ORDER) EQ 'YES' THEN
    R.NEW(RE.ORD.ORDER.STATUS) = 'Orden Rechazada'
  END
  IF PGM.VERSION EQ ',ORDER.RECEPTION' THEN
    R.NEW(RE.ORD.ORDER.STATUS) = 'Orden Recibida'
  END

  IF (R.NEW(RE.ORD.REJECTED.ORDER) EQ 'YES' AND R.NEW(RE.ORD.REASON.REJECT) EQ '') THEN
    AF = RE.ORD.REASON.REJECT
    ETEXT = 'EB-REASON.REJ.NOT.BLANK'
    CALL STORE.END.ERROR
  END


  RETURN
*-----------------------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------------------
END
