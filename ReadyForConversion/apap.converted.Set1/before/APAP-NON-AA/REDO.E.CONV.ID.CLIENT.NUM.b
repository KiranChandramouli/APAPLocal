*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CONV.ID.CLIENT.NUM
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Pradeep M
* Program Name : REDO.E.CUSTOMER.NAU
*-----------------------------------------------------------------------------
* Description :Built routine to assign value to set variable
* Linked with :
* In Parameter :
* Out Parameter :
*
**DATE          DEVELOPER           ODR              VERSION
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_ENQUIRY.COMMON

  CUS.ID = O.DATA
  O.DATA = ""

  GOSUB OPEN.PROCESS
  GOSUB PROCESS

  RETURN
*-----------
OPEN.PROCESS:
*-----------

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  LREF.APP ='CUSTOMER'
  LREF.FIELDS  = "L.CU.CIDENT":VM:"L.CU.RNC":VM:"L.CU.FOREIGN":VM:"L.CU.TIPO.CL"
  LOCAL.REF.POS=''
  CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LOCAL.REF.POS)

  POS.L.CU.CIDENT  = LOCAL.REF.POS<1,1>
  POS.L.CU.RNC     = LOCAL.REF.POS<1,2>
  POS.L.CU.FOREIGN = LOCAL.REF.POS<1,3>
  POS.L.CU.TIPO.CL = LOCAL.REF.POS<1,4>

  RETURN

PROCESS:
*=======

  CALL F.READ(FN.CUSTOMER, CUS.ID, R.CUSTOMER, F.CUSTOMER, CUS.ERR)

  Y.TIPO.CL    = R.CUSTOMER<EB.CUS.LOCAL.REF, POS.L.CU.TIPO.CL>
  Y.CU.CIDENT  = R.CUSTOMER<EB.CUS.LOCAL.REF, POS.L.CU.CIDENT>
  Y.CU.RNC     = R.CUSTOMER<EB.CUS.LOCAL.REF, POS.L.CU.RNC>
  Y.CU.FOREIGN = R.CUSTOMER<EB.CUS.LOCAL.REF, POS.L.CU.FOREIGN>

  BEGIN CASE
  CASE Y.TIPO.CL = "PERSONA FISICA"
    O.DATA = Y.CU.CIDENT
  CASE Y.TIPO.CL = "PERSONA JURIDICA"
    O.DATA = Y.CU.RNC
  CASE (Y.CU.CIDENT EQ "") AND (Y.CU.RNC EQ "")
    O.DATA = Y.CU.FOREIGN
  END CASE

  RETURN
END
