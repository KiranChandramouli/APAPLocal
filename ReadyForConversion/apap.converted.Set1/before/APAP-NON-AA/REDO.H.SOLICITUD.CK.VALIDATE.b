*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.H.SOLICITUD.CK.VALIDATE
*------------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.H.SOLICITUD.CK.VALIDATE
* ODR NO      : ODR-2009-12-0275
*----------------------------------------------------------------------
* DESCRIPTION:This routine will be used to validate the flow of the CHEQUE.STATUS
* from one stage to another. If any of the cheque status moving in decreasing orders,
* it should trigger a Error Message
* IN PARAMETER: NONE
* OUT PARAMETER: NONE
* LINKED WITH: Validate routine for REDO.H.SOLICITUD.CK
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*26.02.2010  S SUDHARSANAN    ODR-2009-12-0275  INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.SOLICITUD.CK
  GOSUB PROCESS
  RETURN
*********
PROCESS:
*********
  CHEQ.OLD=R.OLD(REDO.H.SOL.CHEQUE.STATUS)
  CHEQ.NEW=R.NEW(REDO.H.SOL.CHEQUE.STATUS)
  IF CHEQ.NEW LT CHEQ.OLD THEN
    AF = REDO.H.SOL.CHEQUE.STATUS
    ETEXT = "EB-CHEQ.STATUS"
    CALL STORE.END.ERROR
  END
  IF CHEQ.OLD EQ 85 AND CHEQ.NEW EQ 90 THEN
    AF = REDO.H.SOL.CHEQUE.STATUS
    ETEXT = "EB-INVALID.STATUS"
    CALL STORE.END.ERROR
  END
  RETURN

*********************************************************************
END
