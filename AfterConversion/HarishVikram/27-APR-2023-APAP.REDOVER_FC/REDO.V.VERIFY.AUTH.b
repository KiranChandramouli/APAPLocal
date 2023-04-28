* @ValidationCode : MjotMTUwNDE1NzY4MTpDcDEyNTI6MTY4MjQxMjM2NjQ0ODpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VERIFY.AUTH

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
*   DATE              ODR                             DESCRIPTION
* 02-03-10      ODR-2009-10-0532                     Initial Creation
*Modification history
*Date                Who               Reference                  Description
*20-04-2023      conversion tool     R22 Auto code conversion     VM TO @VM,++ TO +=1
*20-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.DATA.CAPTURE
    $INSERT I_F.REDO.EMPLOYEE.ACCOUNTS
    $INSERT I_F.REDO.UNAUTH.STAFF.LOG
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCT.CAPITALISATION
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.ACCOUNT.DEBIT.INT
    $INSERT I_F.ACCOUNT.STATEMENT
    $INSERT I_F.AC.CHARGE.REQUEST
    $INSERT I_F.IC.CHARGE




    GOSUB OPENFILES
    GOSUB PROCESS




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

    FN.ACCT.CAPITALISATION='F.ACCT.CAPITALISATION'
    F.ACCT.CAPITALISATION=''
    CALL OPF(FN.ACCT.CAPITALISATION,F.ACCT.CAPITALISATION)

    FN.REDO.UNAUTH.STAFF.LOG = 'F.REDO.UNAUTH.STAFF.LOG'
    F.REDO.UNAUTH.STAFF.LOG = ''
    CALL OPF(FN.REDO.UNAUTH.STAFF.LOG,F.REDO.UNAUTH.STAFF.LOG)

    FN.ACCOUNT.CLOSURE = 'F.ACCOUNT.CLOSURE'
    F.ACCOUNT.CLOSURE = ''
    CALL OPF(FN.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE)


    FN.AC.LOCKED.EVENTS='F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS=''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    FN.ACCOUNT.CREDIT.INT = 'F.ACCOUNT.CREDIT.INT'
    F.ACCOUNT.CREDIT.INT  = ''
    CALL OPF(FN.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT)

    FN.ACCOUNT.DEBIT.INT = 'F.ACCOUNT.DEBIT.INT'
    F.ACCOUNT.DEBIT.INT  = ''
    CALL OPF(FN.ACCOUNT.DEBIT.INT ,F.ACCOUNT.DEBIT.INT)

    FN.AC.CHARGE.REQUEST  = 'F.AC.CHARGE.REQUEST'
    F.AC.CHARGE.REQUEST   = ''
    CALL OPF(FN.AC.CHARGE.REQUEST,F.AC.CHARGE.REQUEST)

    FN.IC.CHARGE = 'F.IC.CHARGE'
    F.IC.CHARGE  = ''
    CALL OPF(FN.IC.CHARGE,F.IC.CHARGE)


RETURN
*-----------
PROCESS:
*-----------
* Process are carried out for various applications
*---------------------------------

    GOSUB GET.LOGGEDIN.CUSTOMER
    BEGIN CASE

        CASE APPLICATION EQ "ACCOUNT"
            GOSUB AC.PROCESS
        CASE APPLICATION EQ "ACCOUNT.CLOSURE"
            GOSUB ACC.CLOSURE.PROCESS
        CASE APPLICATION EQ "ACCT.CAPITALISATION"
            GOSUB ACCT.CAPITALISATION.PROCESS
        CASE APPLICATION EQ "AC.LOCKED.EVENTS"
            GOSUB AC.LOCKED.EVENTS.PROCESS
        CASE APPLICATION EQ "ACCOUNT.CREDIT.INT"
            GOSUB ACCOUNT.CREDIT.INT.PROCESS
        CASE APPLICATION EQ "ACCOUNT.DEBIT.INT"
            GOSUB ACCOUNT.DEBIT.INT.PROCESS
        CASE APPLICATION EQ "AC.CHARGE.REQUEST"
            GOSUB AC.CHARGE.REQUEST.PROCESS
        CASE APPLICATION EQ "IC.CHARGE"
            GOSUB IC.CHARGE.PROCESS
    END CASE

RETURN

*----------------------------
ACCT.CAPITALISATION.PROCESS:
*------------------------------
    Y.ACCT.NO = ID.NEW
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    Y.DBT.CUS = R.ACCOUNT<AC.CUSTOMER>
    Y.CUS.VAL = R.ACCOUNT<AC.JOINT.HOLDER>
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.DBT.CUS,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    CALL F.READ(FN.CUSTOMER,Y.DBT.CUS,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)
    AF = '' ; AV = '' ; AS = '' ;
    GOSUB SEND.ERROR
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.CUS.VAL,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    AF = '' ; AV = '' ; AS = '' ;
    GOSUB SEND.ERROR
RETURN

*------------------------------
ACCOUNT.CREDIT.INT.PROCESS:
*------------------------------
    Y.ACCT.NO = FIELDS(ID.NEW,'-',1)
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    Y.DBT.CUS = R.ACCOUNT<AC.CUSTOMER>
    Y.CUS.VAL = R.ACCOUNT<AC.JOINT.HOLDER>
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.DBT.CUS,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    CALL F.READ(FN.CUSTOMER,Y.DBT.CUS,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)
    AF = '' ; AV = '' ; AS = ''  ;
    GOSUB SEND.ERROR
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.CUS.VAL,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    AF = '' ; AV = '' ; AS = ''
    GOSUB SEND.ERROR
RETURN

*--------------------------
ACCOUNT.DEBIT.INT.PROCESS:
*--------------------------
    Y.ACCT.NO = FIELDS(ID.NEW,'-',1)
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    Y.DBT.CUS = R.ACCOUNT<AC.CUSTOMER>
    Y.CUS.VAL = R.ACCOUNT<AC.JOINT.HOLDER>
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.DBT.CUS,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    CALL F.READ(FN.CUSTOMER,Y.DBT.CUS,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)
    AF = '' ; AV = '' ; AS = ''   ;
    GOSUB SEND.ERROR
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.CUS.VAL,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    AF = '' ; AV = '' ; AS = ''
    GOSUB SEND.ERROR
RETURN
*--------------------------
AC.CHARGE.REQUEST.PROCESS:
*-------------------------

    Y.ACCT.NO = R.NEW(CHG.DEBIT.ACCOUNT)
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    Y.DBT.CUS = R.ACCOUNT<AC.CUSTOMER>
    Y.CUS.VAL = R.ACCOUNT<AC.JOINT.HOLDER>
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.DBT.CUS,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    CALL F.READ(FN.CUSTOMER,Y.DBT.CUS,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)
    AF = CHG.DEBIT.ACCOUNT
    GOSUB SEND.ERROR
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.CUS.VAL,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    AF = CHG.DEBIT.ACCOUNT
    GOSUB SEND.ERROR

RETURN


*-------------------
IC.CHARGE.PROCESS:
*-------------------

    Y.ACCT.NO =FIELDS(ID.NEW,'-',2)
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    Y.DBT.CUS = R.ACCOUNT<AC.CUSTOMER>
    Y.CUS.VAL = R.ACCOUNT<AC.JOINT.HOLDER>
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.DBT.CUS,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    CALL F.READ(FN.CUSTOMER,Y.DBT.CUS,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)
    AF = '' ; AV = '' ; AS = '' ;****
    GOSUB SEND.ERROR
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.CUS.VAL,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    AF = '' ; AV = '' ; AS = ''
    GOSUB SEND.ERROR
RETURN
*------------------------
AC.LOCKED.EVENTS.PROCESS:
*------------------------
    Y.ACCT.NO=R.NEW(AC.LCK.ACCOUNT.NUMBER)
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    Y.DBT.CUS = R.ACCOUNT<AC.CUSTOMER>
    Y.CUS.VAL = R.ACCOUNT<AC.JOINT.HOLDER>
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.DBT.CUS,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    CALL F.READ(FN.CUSTOMER,Y.DBT.CUS,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)
    AF = AC.LCK.ACCOUNT.NUMBER
    GOSUB SEND.ERROR
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.CUS.VAL,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    AF = AC.LCK.ACCOUNT.NUMBER
    GOSUB SEND.ERROR
RETURN

*-----------
AC.PROCESS:
*-----------

    Y.DBT.ACCT.NO=ID.NEW
    CALL F.READ(FN.ACCOUNT,Y.DBT.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    Y.DBT.CUS=R.NEW(AC.CUSTOMER)
    Y.CUS.VAL = R.NEW(AC.JOINT.HOLDER)
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.DBT.CUS,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    CALL F.READ(FN.CUSTOMER,Y.DBT.CUS,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)
    AF = '' ; AV = '' ; AS = ''
    GOSUB SEND.ERROR
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.CUS.VAL,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    AF = '' ; AV = '' ; AS = ''
    GOSUB SEND.ERROR
RETURN


*-------------------
ACC.CLOSURE.PROCESS:
*-------------------
*Account Closure is processed here
*----------------------------------
    Y.AC.ACL.NO = ID.NEW
    CALL F.READ(FN.ACCOUNT,Y.AC.ACL.NO,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    Y.AC.ACL.CUS = R.ACCOUNT<AC.CUSTOMER>
    Y.CUS.VAL = R.ACCOUNT<AC.JOINT.HOLDER>
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.CUS.VAL,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    AF = '' ; AV = '' ; AS = ''
    GOSUB SEND.ERROR



******************************************
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.AC.ACL.CUS,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    CALL F.READ(FN.CUSTOMER,Y.AC.ACL.CUS,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)
    AF = '' ; AV = '' ; AS = ''
    GOSUB SEND.ERROR
    CALL F.READ(FN.ACCOUNT,Y.AC.ACL.NO,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    Y.CUS.VAL = R.ACCOUNT<AC.JOINT.HOLDER>
    OVERRIDE.FIELD.VALUE = R.NEW(AC.ACL.OVERRIDE)
    GOSUB CUST.CHECK
    Y.CUS.VAL = R.REL.CUSTOMER<EB.CUS.REL.CUSTOMER>
    OVERRIDE.FIELD.VALUE = R.NEW(AC.ACL.OVERRIDE)
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
        ETEXT='EB-USER.NOT.ALLOW'
        CALL STORE.END.ERROR
    END
RETURN
*------------
CUST.CHECK:
*----------------------------------------------
* Reading the customer table to fetch the data
*------------------------------------------------
    Y.JOINT.CNT = DCOUNT(Y.CUS.VAL,@VM)
    Y.VAR=1
    LOOP
    WHILE Y.VAR LE Y.JOINT.CNT
        Y.CUS.ID=Y.CUS.VAL<1,Y.VAR>
        CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)
        Y.FAX = R.CUSTOMER<EB.CUS.FAX.1>
        IF Y.FAX EQ OPERATOR THEN
            GOSUB SEND.ERROR
*           CURR.NO = DCOUNT(OVERRIDE.FIELD.VALUE,VM) + 1
*           TEXT = 'USER.REL.TO.EMP'
*           CALL STORE.OVERRIDE(CURR.NO)
        END

        LOCATE Y.CUS.ID IN Y.EMP.REL.CUS<1,1> SETTING REL.POS THEN
            IF NOT(Y.FLAG) THEN
                CURR.NO = DCOUNT(OVERRIDE.FIELD.VALUE,@VM) + 1
                TEXT = 'USER.REL.TO.EMP'
                CALL STORE.OVERRIDE(CURR.NO)
            END
        END

        Y.VAR += 1
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
*-------------------------------
GET.LOGGEDIN.CUSTOMER:
*-------------------------------
    SEL.CMD = 'SELECT ':FN.REDO.EMPLOYEE.ACCOUNTS:' WITH USER.ID EQ ':OPERATOR
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    Y.EMP.CUS.ID = SEL.LIST<1>  ;* There will be only one record for each employee
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.EMP.CUS.ID,R.EMPLOYEE.RECORD,F.REDO.EMPLOYEE.ACCOUNTS,EMP.ERR)
    Y.EMP.REL.CUS = R.EMPLOYEE.RECORD<REDO.EMP.REL.CUSTOMER>
    Y.EMP.ACCOUNT = R.EMPLOYEE.RECORD<REDO.EMP.ACCOUNT>
RETURN
END
