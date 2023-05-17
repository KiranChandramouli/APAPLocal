SUBROUTINE DR.REG.RCL.CUS.NAME.INT.TAX.PAY
*-----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
* 01-Aug-2014     V.P.Ashokkumar      PACS00305231 - Added customer relation check
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_DR.REG.INT.TAX.PAYMENT.COMMON
    $INSERT I_DR.REG.INT.TAX.COMMON

    R.CUSTOMER = RCL$INT.TAX(3)
    L.CU.TIPO.CL.VAL = ''; YCUS.NME = ''
    L.CU.TIPO.CL.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS>
    BEGIN CASE
        CASE L.CU.TIPO.CL.VAL EQ 'PERSONA FISICA'
            YCUS.NME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
        CASE L.CU.TIPO.CL.VAL EQ 'CLIENTE MENOR'
            YCUS.NME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
        CASE L.CU.TIPO.CL.VAL EQ 'PERSONA JURIDICA'
            YCUS.NME = R.CUSTOMER<EB.CUS.NAME.1,1>:' ':R.CUSTOMER<EB.CUS.NAME.2,1>
    END CASE
    COMI = YCUS.NME
RETURN
END
