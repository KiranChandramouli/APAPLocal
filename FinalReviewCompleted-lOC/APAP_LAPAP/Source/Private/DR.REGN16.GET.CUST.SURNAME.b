$PACKAGE APAP.LAPAP
SUBROUTINE DR.REGN16.GET.CUST.SURNAME
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT 
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    CUST.ID = COMI
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',TIPO.CL.POS)
    R.CUSTOMER = ''
    CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    CUSTOMER.SURNAME = ''

    BEGIN CASE
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA FISICA' OR R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'CLIENTE MENOR'
            CUSTOMER.SURNAME = R.CUSTOMER<EB.CUS.FAMILY.NAME>
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA JURIDICA'
            CUSTOMER.SURNAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
    END CASE

    COMI = CUSTOMER.SURNAME

RETURN
END
