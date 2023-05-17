SUBROUTINE REDO.V.VAL.CHEQ.STATUS
*------------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.V.VAL.CHEQ.STATUS
* ODR NO      : ODR-2009-12-0275
*----------------------------------------------------------------------
* DESCRIPTION: This routine will be used to raise an error message ,
* whenever user selects the CHEQ.STATUS EQ 85
* IN PARAMETER: NONE
* OUT PARAMETER: NONE
* LINKED WITH: Validate routine for REDO.H.SOLICITUD.CK,GRAL
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
    CHEQ.NEW=R.NEW(REDO.H.SOL.CHEQUE.STATUS)
    IF CHEQ.NEW EQ 85 THEN
        AF = REDO.H.SOL.CHEQUE.STATUS
        ETEXT = "EB-INVALID.STATUS"
        CALL STORE.END.ERROR
    END
RETURN
*-----------------------------------------------------------------------
END
