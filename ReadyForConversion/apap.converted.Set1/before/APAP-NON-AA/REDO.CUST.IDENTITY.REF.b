*-----------------------------------------------------------------------------
* <Rating>-60</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CUST.IDENTITY.REF(CUST.ID,CUST.ALTER.ID,CUST.NAME)
*******************************************************************************************************************

*Company   Name    : Asociacion Popular De Ahorros Y Pristamos Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CUST.IDENTITY.REF
*------------------------------------------------------------------------------------------------------------------

*Description       : This call routine is used to get the alternate ID for particular customer and also get the name based on customer type.

*In  Parameter     : CUST.ID
*Out Parameter     : CUST.ALTER.ID,CUST.NAME
*------------------------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER

  GOSUB INITIALISE
  GOSUB PROCESS

  RETURN
*------------
INITIALISE:
*------------
  Y.NAME = ''
  ID_CARD= ''

  FN.CUSTOMER='F.CUSTOMER'
  F.CUSTOMER=''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FLAG.ID = '' ; CIDENT.VALUE = '' ; LEGALID.VALUE = '' ; ACTANAC.VALUE = '' ;  NOUNICO.VALUE = ''


  LREF.APPL = 'CUSTOMER'
  LREF.FIELDS = 'L.CU.CIDENT':VM:'L.CU.TIPO.CL':VM:'L.CU.RNC':VM:'L.CU.ACTANAC':VM:'L.CU.NOUNICO'
  LREF.POS = ''
  CALL MULTI.GET.LOC.REF(LREF.APPL,LREF.FIELDS,LREF.POS)
  CIDENT.POS = LREF.POS<1,1>
  TIPO.CL.POS = LREF.POS<1,2>
  RNC.POS = LREF.POS<1,3>
  ACTANAC.POS = LREF.POS<1,4>
  NOUNICO.POS = LREF.POS<1,5>

  RETURN
*-----------
PROCESS:
*-----------

  VAR.CUS.ID = CUST.ID

  CALL F.READ(FN.CUSTOMER,VAR.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR1)

  VAR.TIPO.CL = R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS>

  BEGIN CASE
  CASE VAR.TIPO.CL EQ 'PERSONA FISICA'
    GOSUB FIS.TYPE
  CASE VAR.TIPO.CL EQ 'PERSONA JURIDICA'
    GOSUB JUR.TYPE
  CASE VAR.TIPO.CL EQ 'CLIENTE MENOR'
    GOSUB MENOR.TYPE
  END CASE

  CUST.ALTER.ID = ID_CARD
  CUST.NAME     = Y.NAME

  RETURN
*------------------------------------------------------------------------------------------
FIS.TYPE:
*------------------------------------------------------------------------------------------
  VAR.GIV.NAM  =  R.CUSTOMER<EB.CUS.GIVEN.NAMES>
  VAR.FAM.NAM = R.CUSTOMER<EB.CUS.FAMILY.NAME>
  Y.NAME = VAR.GIV.NAM:" ":VAR.FAM.NAM
  CIDENT.VALUE = R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS>
  IF CIDENT.VALUE THEN
    ID_CARD = CIDENT.VALUE
  END ELSE
    ID_CARD = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
  END
  RETURN
*------------------------------------------------------------------------------------------
JUR.TYPE:
*------------------------------------------------------------------------------------------
  VAR.NAME1=R.CUSTOMER<EB.CUS.NAME.1>
  VAR.NAME2=R.CUSTOMER<EB.CUS.NAME.2>
  Y.NAME = VAR.NAME1:VAR.NAME2
  ID_CARD = R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS>
  RETURN
*------------------------------------------------------------------------------------------
MENOR.TYPE:
*------------------------------------------------------------------------------------------
  VAR.GIV.NAM  =  R.CUSTOMER<EB.CUS.GIVEN.NAMES>
  VAR.FAM.NAM = R.CUSTOMER<EB.CUS.FAMILY.NAME>
  Y.NAME = VAR.GIV.NAM:" ":VAR.FAM.NAM
  CIDENT.VALUE  =  R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS>
  IF CIDENT.VALUE THEN
    ID_CARD = CIDENT.VALUE
    FLAG.ID = 1
  END
  IF NOT(FLAG.ID) THEN
    LEGALID.VALUE = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    IF LEGALID.VALUE THEN
      ID_CARD = LEGALID.VALUE
      FLAG.ID = 1
    END
  END
  IF NOT(FLAG.ID) THEN
    ACTANAC.VALUE = R.CUSTOMER<EB.CUS.LOCAL.REF,ACTANAC.POS>
    IF ACTANAC.VALUE THEN
      ID_CARD = ACTANAC.VALUE
      FLAG.ID = 1
    END
  END
  IF NOT(FLAG.ID) THEN
    NOUNICO.VALUE = R.CUSTOMER<EB.CUS.LOCAL.REF,NOUNICO.POS>
    IF NOUNICO.VALUE THEN
      ID_CARD = NOUNICO.VALUE
      FLAG.ID = 1
    END
  END
  RETURN
*------------------------------------------------------------------------------------------
END
