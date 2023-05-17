*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CNV.CUST.NAME
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------
* Modification History
* DATE            ODR           BY              DESCRIPTION
* 25-08-2011      FS-360       Manju.G          For enquiry REDO.CUSTOMER.VIEW
*
*------------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ENQUIRY
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER

  GOSUB INITIALISE
  GOSUB PROCESS
*
  RETURN

INITIALISE:
*************

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  REF.POS = ''
  RETURN

PROCESS:
**********
  CALL MULTI.GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',REF.POS)
  CUSTOMER.ID = O.DATA
  CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
  O.DATA = ''

  IF R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "CLIENTE MENOR" THEN
    O.DATA = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
  END ELSE
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "PERSONA JURIDICA" THEN
      O.DATA = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
    END
  END

  RETURN
END
