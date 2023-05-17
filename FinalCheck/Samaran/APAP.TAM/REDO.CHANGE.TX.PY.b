$PACKAGE APAP.TAM
SUBROUTINE REDO.CHANGE.TX.PY

* Developed By : TAM (Marimuthu S)
* Reference :
* Description : This is conversion routine used to change the payoff bill descriptions to spanish

** 21-04-2023 R22 Auto Conversion no changes
** 21-04-2023 Skanda R22 Manual Conversion - No changes

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    BEGIN CASE

        CASE O.DATA EQ 'CURRENT'
            O.DATA = 'SALDOS VIGENTE'
        CASE O.DATA EQ 'DUE'
            O.DATA = 'VENCIDO'
        CASE O.DATA EQ 'OVERDUE'
            O.DATA = 'VENCIDO + 30 DIAS'
        CASE O.DATA EQ 'CHARGE'
            O.DATA = 'CARGOS'
    END CASE

RETURN

END
