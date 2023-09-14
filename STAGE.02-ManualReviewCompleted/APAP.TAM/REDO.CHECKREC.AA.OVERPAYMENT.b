$PACKAGE APAP.TAM
SUBROUTINE REDO.CHECKREC.AA.OVERPAYMENT
*-------------------------------------------------
*Description: This routine is to throw the validation error messages.
** 21-04-2023 R22 Auto Conversion no changes
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*-------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AA.OVERPAYMENT


    IF V$FUNCTION EQ 'I' THEN
        GOSUB PROCESS
    END

RETURN
*-------------------------------------------------
PROCESS:
*-------------------------------------------------


    IF R.NEW(REDO.OVER.STATUS) NE 'PENDIENTE' THEN
        E     = 'EB-REDO.NOT.ALLOWED'
    END ELSE
        R.NEW(REDO.OVER.STATUS) = "REVERSADO"
    END

RETURN

END
