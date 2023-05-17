*-------------------------------------------------------------------------
* <Rating>-30</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.CUST.DOC.ID
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* display the field description of CUSTOMER instead of the ID.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 16-SEP-2011         RIYAS      ODR-2011-07-0162     Initial Creation
*-------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.CUSTOMER

  GOSUB INITIALSE
  GOSUB PROCESS

  RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~~
  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER  = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  LOC.REF.APPLICATION="CUSTOMER"
  LOC.REF.FIELDS='L.CU.CIDENT':VM:'L.CU.NOUNICO':VM:'L.CU.ACTANAC':VM:'L.CU.RNC'
  LOC.REF.POS=''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  POS.L.CU.CIDENT=LOC.REF.POS<1,1>
  POS.L.CU.NOUNICO = LOC.REF.POS<1,2>
  POS.L.CU.ACTANAC = LOC.REF.POS<1,3>
  POS.L.CU.RNC = LOC.REF.POS<1,4>

  RETURN
*----------------------------------------------------------------------------
PROCESS:
*~~~~~~~~~~

  Y.REC.DATA = O.DATA
  CALL F.READ(FN.CUSTOMER,Y.REC.DATA,R.CUSTOMER,F.CUSTOMER,LOOKUP.ERR)
  Y.CIDENT = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.CIDENT>
  Y.NOUNICO = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.NOUNICO>
  Y.ACTANAC =   R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.ACTANAC>
  Y.RNC = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.RNC>
  Y.LEGAL.ID = R.CUSTOMER<EB.CUS.LEGAL.ID>
  BEGIN CASE
  CASE Y.CIDENT NE ''
    O.DATA = Y.CIDENT
  CASE Y.NOUNICO NE ''
    O.DATA = Y.NOUNICO
  CASE Y.ACTANAC NE ''
    O.DATA = Y.NOUNICO
  CASE Y.RNC NE ''
    O.DATA = Y.RNC
  CASE Y.LEGAL.ID NE ''
    O.DATA = Y.LEGAL.ID
  CASE 1
    O.DATA = ''
    RETURN
  END CASE

  RETURN
*-------------------------------------------------------------------------
END
