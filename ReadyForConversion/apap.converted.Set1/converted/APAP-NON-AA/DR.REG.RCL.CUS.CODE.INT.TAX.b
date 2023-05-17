SUBROUTINE DR.REG.RCL.CUS.CODE.INT.TAX
**************************************************************************
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
* 01-Aug-2014     V.P.Ashokkumar      PACS00305231 - Added RELATION file
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_DR.REG.INT.TAX.PAYMENT.COMMON
    $INSERT I_DR.REG.INT.TAX.COMMON

    R.CUSTOMER = RCL$INT.TAX(3)

    FLD4 = ''; YLID.CUSTOMER = ''
    BEGIN CASE
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS> NE ''
            YLID.CUSTOMER = R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS>
            FLD4 = YLID.CUSTOMER[1,3]:'-':YLID.CUSTOMER[4,7]:'-':YLID.CUSTOMER[11,1]
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS> NE ''
            YLID.CUSTOMER = R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS>
            FLD4 = YLID.CUSTOMER[1,1]:'-':YLID.CUSTOMER[2,2]:'-':YLID.CUSTOMER[4,5]:'-':YLID.CUSTOMER[9,1]
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS> NE ''
            FLD4 = R.CUSTOMER<EB.CUS.NATIONALITY>:R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS>
        CASE R.CUSTOMER<EB.CUS.LEGAL.ID> NE ''
            FLD4 = R.CUSTOMER<EB.CUS.NATIONALITY>:R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    END CASE
    COMI = FLD4
RETURN

END
