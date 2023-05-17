*-----------------------------------------------------------------------------
* <Rating>-84</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.VERIFY.STAFF
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : RAJA SAKTHIVEL K P
* Program Name  : REDO.V.INP.VERIFY.STAFF
*-------------------------------------------------------------------------
* Description: This routine is a INPUT routine attached to
* FT,UNAUTH.STAFF.LOG,DATA.CAPTURE,UNAUTH.STAFF.LOG,TELLER,UNAUTH.STAFF.LOG
*----------------------------------------------------------
* Linked with: VERSION.CONTROL of FT,TELLER,DATA.CAPTURE as validation routine
* In parameter : None
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE    NAME                 Refernce                             DESCRIPTION
* 02-03-10  Raja sakthivel    ODR-2009-10-0532                     Initial Creation
* 01-10-11  Prajeesh           CR.21                               Modify the code
* 25-10-11  Sudharsanan S      CR.18                               Change the condition for AZ.ACCOUNT Process
*------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_F.ACCOUNT
$INSERT I_F.REDO.EMPLOYEE.ACCOUNTS
$INSERT I_F.REDO.UNAUTH.STAFF.LOG
$INSERT I_F.AZ.ACCOUNT

  GOSUB OPENFILES
  GOSUB PROCESS
  GOSUB PROG.END
  RETURN
*------------
OPENFILES:
*------------

  FN.REDO.EMPLOYEE.ACCOUNTS = 'F.REDO.EMPLOYEE.ACCOUNTS'
  F.REDO.EMPLOYEE.ACCOUNTS = ''
  CALL OPF(FN.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.REDO.UNAUTH.STAFF.LOG = 'F.REDO.UNAUTH.STAFF.LOG'
  F.REDO.UNAUTH.STAFF.LOG = ''
  CALL OPF(FN.REDO.UNAUTH.STAFF.LOG,F.REDO.UNAUTH.STAFF.LOG)

  FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
  F.AZ.ACCOUNT=''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  RETURN
*-----------
PROCESS:
*-----------
* Process are carried out for various applications
*---------------------------------

  BEGIN CASE
  CASE APPLICATION EQ "ACCOUNT"
    IF R.NEW(AC.RECORD.STATUS) EQ 'INAU' THEN
      GOSUB AC.PROCESS
    END
  CASE APPLICATION EQ "AZ.ACCOUNT"
    IF R.NEW(AZ.RECORD.STATUS) EQ 'INAU' THEN
      GOSUB AZ.PROCESS
    END
  END CASE

  RETURN
*-----------
AZ.PROCESS:
*-----------
  Y.ACC.NO = ID.NEW
  Y.DBT.AC = R.NEW(AZ.CUSTOMER)
  CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.DBT.AC,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
  CALL F.READ(FN.CUSTOMER,Y.DBT.AC,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)
  GOSUB SEND.ERROR
  Y.CUS.VAL = R.REL.CUSTOMER<EB.CUS.REL.CUSTOMER>
  GOSUB CUST.CHECK
  RETURN
*-----------
AC.PROCESS:
*-----------

  Y.DBT.ACCT.NO=ID.NEW
  Y.DBT.CUS=R.NEW(AC.CUSTOMER)
  Y.CUS.VAL = R.NEW(AC.JOINT.HOLDER)

  CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.CUS.VAL,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
  CALL F.READ(FN.CUSTOMER,Y.CUS.VAL,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)
  GOSUB SEND.ERROR
  GOSUB CUST.CHECK
  CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.DBT.CUS,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
  CALL F.READ(FN.CUSTOMER,Y.DBT.CUS,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)
  GOSUB SEND.ERROR
  Y.CUS.VAL = R.REL.CUSTOMER<EB.CUS.REL.CUSTOMER>
  GOSUB CUST.CHECK
  RETURN
*-----------
SEND.ERROR:
*-----------
* Error message is defined here
*--------------------------------
  Y.USER.ID = R.REDO.EMPLOYEE.ACCOUNTS<REDO.EMP.USER.ID>
  IF Y.USER.ID EQ OPERATOR THEN
    GOSUB UPDATE.LOG
    E = 'Usuario no autorizado - cuenta de empleado'
    GOSUB PROG.END
  END
  RETURN
*------------
CUST.CHECK:
*----------------------------------------------
* Reading the customer table to fetch the data
*------------------------------------------------
  Y.JOINT.CNT = DCOUNT(Y.CUS.VAL,VM)
  Y.VAR=1
  LOOP
  WHILE Y.VAR LE Y.JOINT.CNT
    Y.CUS.ID=Y.CUS.VAL<1,Y.VAR>
    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)
    Y.FAX = R.CUSTOMER<EB.CUS.FAX.1>
    IF Y.FAX EQ OPERATOR THEN
      GOSUB SEND.ERROR
    END
    Y.VAR++
  REPEAT
  RETURN
*-------------
UPDATE.LOG:
*-------------
* Updating the staff log table
*-------------------------------
  CALL ALLOCATE.UNIQUE.TIME(CURRTIME)
  Y.LOG.ID = 'STAFF.':CURRTIME
  R.REDO.UNAUTH.STAFF.LOG = ''
  R.REDO.UNAUTH.STAFF.LOG<REDO.LOG.USER.ID> = OPERATOR
  R.REDO.UNAUTH.STAFF.LOG<REDO.LOG.ACTIVITY.DATE> = TODAY
  R.REDO.UNAUTH.STAFF.LOG<REDO.LOG.ACTIVITY.TIME> = OCONV(TIME(), "MTS")
  R.REDO.UNAUTH.STAFF.LOG<REDO.LOG.APPLICATION> = APPLICATION
  R.REDO.UNAUTH.STAFF.LOG<REDO.LOG.RECORD.ID> = ID.NEW

  WRITE R.REDO.UNAUTH.STAFF.LOG TO F.REDO.UNAUTH.STAFF.LOG,Y.LOG.ID ON ERROR
 
    RETURN
  END

  RETURN
*-------------------------------------------------------------------------------
PROG.END:
*-------------------------------------------------------------------------------
END
