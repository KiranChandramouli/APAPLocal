SUBROUTINE REDO.VAL.LETTER.WAIVE
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.VAL.LETTER.WAIVE
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is the Validation Routine for REDO.LETTER.ISSUE to
*CHECK THE CUSTOMER WAIVE CHARGE

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*24.06.2011    RIYAS          PACS00072842   INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.LETTER.ISSUE
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB LOCAL.REF
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN
*----------------------------------------------------------------------
LOCAL.REF:
*----------------------------------------------------------------------
    LOC.REF.APPLICATION="ACCOUNT"
    LOC.REF.FIELDS='L.AC.STATUS1'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------


    Y.WAIVE=R.NEW(REDO.LET.ISS.WAIVE.CHARGES)
    IF Y.WAIVE EQ 'YES' THEN
        R.NEW(REDO.LET.ISS.CHARGE.LIQ.ACT)=''
        T(REDO.LET.ISS.CHARGE.LIQ.ACT)<3> = 'NOINPUT'
        R.NEW(REDO.LET.ISS.CHARGE.AMT) = ''
        T(REDO.LET.ISS.CHARGE.AMT)<3> = 'NOINPUT'
    END

RETURN
END
