*-----------------------------------------------------------------------------
* <Rating>-34</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BLD.CEDULE.FOTO(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Pradeep M
* Program Name : REDO.E.BLD.CEDULE.FOTO
*-----------------------------------------------------------------------------
* Description :Enquiry routine to retreive image of padrones
* Linked with :
* In Parameter :
* Out Parameter :
*
**DATE           ODR                   DEVELOPER               VERSION
* 08-11-2011    ODR2011080055          PRADEEP                 Initial Creation
* 18-04-2012    PACS00190839           Pradeep S               Fix for migration issue
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.CUSTOMER

  GOSUB OPEN.PROCESS
  GOSUB PROCESS

  RETURN

OPEN.PROCESS:
*-----------

  FN.CUSTOMER='F.CUSTOMER'
  F.CUSTOMER=''

  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

*PACS00190839 - S

  FN.CUSTOMER.L.CU.CIDENT = "F.CUSTOMER.L.CU.CIDENT"
  F.CUSTOMER.L.CU.CIDENT  = ''
  CALL OPF(FN.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT)

*PACS00190839 - E

  RETURN

PROCESS:
*-------

  Y.IDENTI.NO=ENQ.DATA<4>

  GOSUB CHECK.IDENTIFICATION

  RETURN

CHECK.IDENTIFICATION:
*--------------------

  Y.CUS.IDNT='CIDENT'

  R.CUS.IDENTIFICATION=''
  ERR.REDO=''

*PACS00190839 - S
  CALL F.READ(FN.CUSTOMER.L.CU.CIDENT,Y.IDENTI.NO,R.CUS.CIDENT,F.CUSTOMER.L.CU.CIDENT,ERR.REDO)

  IF R.CUS.CIDENT THEN
    Y.CONCAT.CUS = FIELD(R.CUS.CIDENT,"*",2)
    CALL System.setVariable("CURRENT.CUSTOMER",Y.CONCAT.CUS)
  END

*PACS00190839 - E

  RETURN

END
