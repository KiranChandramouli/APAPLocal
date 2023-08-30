$PACKAGE APAP.LAPAP
SUBROUTINE DR.REGN16.GET.CUST.CODE
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
    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    R.CUSTOMER = ''; CUSTOMER.ERR = ''
    CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    CALL DR.REG.GET.CUST.TYPE(R.CUSTOMER,OUT.ARR)
    COMI = OUT.ARR<2>
RETURN

END
