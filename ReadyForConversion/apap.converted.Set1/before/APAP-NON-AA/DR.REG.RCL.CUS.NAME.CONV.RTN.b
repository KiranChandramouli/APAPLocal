*
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.RCL.CUS.NAME.CONV.RTN
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_F.CUSTOMER
$INSERT I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON
$INSERT I_DR.REG.COMM.LOAN.SECTOR.COMMON
*
  L.CU.TIPO.CL.VAL = COMI
  R.CUSTOMER = RCL$COMM.LOAN(2)
*
  BEGIN CASE
  CASE L.CU.TIPO.CL.VAL EQ 'PERSONA FISICA'
    CUSTOMER.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
  CASE L.CU.TIPO.CL.VAL EQ 'CLIENTE MENOR'
    CUSTOMER.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
  CASE L.CU.TIPO.CL.VAL EQ 'PERSONA JURIDICA'
    CUSTOMER.NAME = R.CUSTOMER<EB.CUS.NAME.1>:' ':R.CUSTOMER<EB.CUS.NAME.2>
  END CASE
*
  COMI = CUSTOMER.NAME
*
  RETURN
END
