*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CNV.GET.CUS.ID
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to get the Customer Legal id from Customer table.
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Ganesh R
* PROGRAM NAME : REDO.E.CNV.GET.CUS.ID
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 02-08-2012   GANESH R              ODR-2010-03-0141   INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.ISSUE.CLAIMS
$INSERT I_F.CUSTOMER
$INSERT I_F.REDO.SLA.PARAM

  GOSUB INIT
  GOSUB OPENFILE
  GOSUB PROCESS
  RETURN
INIT:
  LOC.APPLICATION = 'CUSTOMER'
  LOC.FIELDS      = 'L.CU.CIDENT':VM:'L.CU.RNC':VM:'L.CU.NOUNICO':VM:'L.CU.ACTANAC'
  LOC.POS         = ''
  CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS)
  RETURN

OPENFILE:

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER  = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  RETURN

PROCESS:
  Y.CUS.ID = O.DATA
  O.DATA = ''
  CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
  Y.L.CU.CIDENT  = LOC.POS<1,1>
  Y.L.CU.RNC     = LOC.POS<1,2>
  Y.L.CU.NOUNICO = LOC.POS<1,3>
  Y.L.CU.ACTANAC = LOC.POS<1,4>

  Y.L.CU.CIDENT.VAL  = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.CIDENT>
  Y.LEGAL.ID.VAL     = R.NEW(EB.CUS.LEGAL.ID)
  Y.L.CU.RNC.VAL     = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.RNC>
  Y.L.CU.NOUNICO.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.NOUNICO>
  Y.L.CU.ACTANA.VAL  = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.ACTANAC>

  IF Y.L.CU.CIDENT.VAL THEN
    O.DATA = Y.L.CU.CIDENT.VAL
  END
  IF Y.LEGAL.ID.VAL THEN
    O.DATA = Y.LEGAL.ID.VAL
  END
  IF Y.L.CU.RNC.VAL THEN
    O.DATA = Y.L.CU.RNC.VAL
  END
  IF Y.L.CU.NOUNICO.VAL THEN
    O.DATA = Y.L.CU.NOUNICO.VAL
  END
  IF Y.L.CU.ACTANA.VAL THEN
    O.DATA = Y.L.CU.ACTANA.VAL
  END

  RETURN
END
