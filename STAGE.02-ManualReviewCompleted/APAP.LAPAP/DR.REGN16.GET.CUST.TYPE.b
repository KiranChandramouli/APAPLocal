$PACKAGE APAP.LAPAP
SUBROUTINE DR.REGN16.GET.CUST.TYPE
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
* 21/08/2014          Ashokkumar            PACS00366332- Corrected the Industry value
*Modification
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INSER TAM.BP TO $INSERT 
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.INDUSTRY
    $INSERT I_F.REDO.CATEGORY.CIUU

    CUST.ID = COMI
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    R.CUSTOMER = ''; CUSTOMER.ERR = ''
    CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    CALL DR.REG.GET.CUST.TYPE(R.CUSTOMER,OUT.ARR)
    COMI = OUT.ARR<1>
RETURN
END
