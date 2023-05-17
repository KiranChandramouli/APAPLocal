*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE DR.REGN16.GET.CUST.NAME
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
* 31-07-2014        Ashokkumar                PACS00366332- Initial revision
*-----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INCLUDE REGREP.BP I_DR.REG.REGN16.EXTRACT.COMMON

    CUST.ID = COMI
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''; R.CUSTOMER = ''; CUSTOMER.NAME = ''; TIPO.CL.POS = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',TIPO.CL.POS)
    CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    L.CU.TIPO.CL.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS>

    BEGIN CASE
    CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA FISICA' OR R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'CLIENTE MENOR'
        CUSTOMER.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
    CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA JURIDICA'
        CUSTOMER.NAME = R.CUSTOMER<EB.CUS.NAME.1>:' ':R.CUSTOMER<EB.CUS.NAME.2>
    END CASE
    COMI = CUSTOMER.NAME
    RETURN
END
