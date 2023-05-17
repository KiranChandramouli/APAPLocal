SUBROUTINE REDO.V.VAL.ISSUE.CHECK
*---------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.VAL.ISSUE.CHECK
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION: This routine is validation routine to STATUS field in
* REDO.ADMIN.CHQ.DETAILS,REVOKE.PAY
* REDO.MANAGER.CHQ.DETAILS,REVOKE.PAY



*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.ADMIN.CHQ.DETAILS
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
    Y.STATUS=COMI
    IF Y.STATUS NE 'ISSUED' THEN
        IF APPLICATION EQ 'REDO.ADMIN.CHQ.DETAILS' THEN
            AF=ADMIN.CHQ.DET.STATUS
        END
        IF APPLICATION EQ 'REDO.MANAGER.CHQ.DETAILS' THEN
            AF=MAN.CHQ.DET.STATUS
        END
        ETEXT='EB-ISSUED.ONLY.ALLOW'
        CALL STORE.END.ERROR
    END
RETURN
END
