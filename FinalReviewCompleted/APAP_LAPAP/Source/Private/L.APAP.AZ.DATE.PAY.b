$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.AZ.DATE.PAY
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT


    VAR.VALUE.DATE = R.NEW(AZ.VALUE.DATE)[7,2]

    CALL GET.LOC.REF("AZ.ACCOUNT","PAYMENT.DATE",ACC.POS)

    R.NEW(AZ.LOCAL.REF)<1,ACC.POS> = VAR.VALUE.DATE

END
