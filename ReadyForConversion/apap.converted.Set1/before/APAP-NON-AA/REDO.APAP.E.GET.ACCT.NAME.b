*-----------------------------------------------------------------------------
* <Rating>-98</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.E.GET.ACCT.NAME
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.E.GET.ACCT.NAME
*--------------------------------------------------------------------------------------------------------
*Description       : This is a Conversion routine to get the names of the Customer
*
*Linked With       : Enquiry REDO.APAP.PROX.ACCT
*In  Parameter     : O.DATA
*Out Parameter     : O.DATA
*Files  Used       : ACCOUNT                    As              I               Mode
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*     20.10.2010          Ganesh R              ODR-2010-03-0182            Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER
$INSERT I_F.RELATION
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
  GOSUB OPEN.PARA

  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'
  F.ACCOUNT.HIS  = ''
  CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.RELATION = 'F.RELATION'
  F.RELATION = ''
  CALL OPF(FN.RELATION,F.RELATION)

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
  Y.CUS.NAMES = ''
  GOSUB FIND.MULTI.LOCAL.REF
  Y.AC.ID = O.DATA
  O.DATA = ''
  GOSUB READ.ACCOUNT
  Y.RELATION.COUNT = DCOUNT(R.ACCOUNT<AC.RELATION.CODE>,VM)
  Y.COUNT = 1
  CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
  GOSUB READ.CUSTOMER
  GOSUB GET.CUS.NAMES
  MAIN.NAMES = Y.CUS.NAME
  CUSTOMER.ID = ''
  Y.CUS.NAME = ''
  LOOP
  WHILE Y.COUNT LE Y.RELATION.COUNT
    Y.REL.DESC = ''
    Y.CUS.NAME = ''
    RELATION.ID = R.ACCOUNT<AC.RELATION.CODE,Y.COUNT>
    IF RELATION.ID GE 500 AND RELATION.ID LE 529 THEN
      GOSUB GET.VALUES
    END
    Y.COUNT += 1
    Y.CUS.NAMES< 1, -1> = Y.CUS.NAME
*        CHANGE FM TO ' ' IN Y.CUS.NAMES
  REPEAT

  Y.RET.VAL = MAIN.NAMES:VM:Y.CUS.NAMES

  IF Y.CUS.NAMES THEN
    Y.RET.VAL = CHANGE(Y.RET.VAL, VM, '; ')
  END

  VM.COUNT = 1
  SM.COUNT = 1

  O.DATA =  Y.RET.VAL

  RETURN
***********
GET.VALUES:
***********
  GOSUB READ.RELATION
  Y.REL.DESC  = R.RELATION<EB.REL.DESCRIPTION>
  CUSTOMER.ID = R.ACCOUNT<AC.JOINT.HOLDER,Y.COUNT>
  GOSUB READ.CUSTOMER
  GOSUB GET.CUS.NAMES
  RETURN

GET.CUS.NAMES:
**************
  IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ 'PERSONA FISICA' OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ 'CLIENTE MENOR' THEN
    Y.CUS.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
  END

  IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ 'PERSONA JURIDICA' THEN
    Y.CUS.NAME = R.CUSTOMER<EB.CUS.NAME.1,1>:' ':R.CUSTOMER<EB.CUS.NAME.2,1>
  END

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
* In this para of the code, file ACCOUNT is read
  R.ACCOUNT  = ''
  ACCOUNT.ER = ''
  CALL F.READ(FN.ACCOUNT,Y.AC.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)
  IF R.ACCOUNT EQ '' THEN
    CALL EB.READ.HISTORY.REC(F.ACCOUNT.HIS,Y.AC.ID,R.ACCOUNT,AC.ERR)
  END
  RETURN
*--------------------------------------------------------------------------------------------------------
**************
READ.CUSTOMER:
**************
* In this para of the code, file CUSTOMER is read
  R.CUSTOMER  = ''
  CUSTOMER.ER = ''
  CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
**************
READ.RELATION:
**************
* In this para of the code, file RELATION is read
  R.RELATION  = ''
  RELATION.ER = ''
  CALL F.READ(FN.RELATION,RELATION.ID,R.RELATION,F.RELATION,RELATION.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------

*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
  APPL.ARRAY = 'CUSTOMER'
  FLD.ARRAY  = 'L.CU.TIPO.CL'
  FLD.POS    = ''

  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

  LOC.L.CU.TIPO.CL.POS    = FLD.POS<1,1>

  RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Prgram
