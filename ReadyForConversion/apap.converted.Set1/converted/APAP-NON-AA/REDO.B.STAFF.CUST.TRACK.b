SUBROUTINE REDO.B.STAFF.CUST.TRACK(CUST.ID)

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : RAJA SAKTHIVEL K P
* Program Name  : REDO.B.STAFF.CUST.TRACK
*-------------------------------------------------------------------------
* DESCRIPTION : This routine is the main routine to update the REDO.EMPLOYEE.ACCOUNTS
* local table with the staff details
*----------------------------------------------------------
* Linked with: COB process a multi threaded batch routine
* In parameter : CUST.ID
* out parameter : Nil
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 03-03-10      ODR-2009-10-0532                     Initial Creation
*28-05-2010     CR013                                Line 68 Added
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_REDO.B.STAFF.CUST.TRACK.COMMON
    $INSERT I_F.REDO.EMPLOYEE.ACCOUNTS

    GOSUB INITIALISE

    GOSUB PROCESS

RETURN

*---------------
INITIALISE:
*-------------------------------------------
* Used to initialise all the local variables
*-------------------------------------------
    Y.CUSTOMER.ID = ''
    Y.ACCOUNT = ''
    Y.ACC.CNT = ''
    Y.REDO.EMP.ID = ''
    Y.ACC.CONTRACT = ''
    Y.ACC.CONTRACT.CNT = ''
    Y.ACC.VAL = ''
    Y.ACC.XREF.ID = ''
    Y.CHK.ACC = ''
    Y.CHK.ACC.CNT = ''

RETURN
*----------
PROCESS:
*-------------------------------------
* main processing is carried on here
*-------------------------------------
    Y.CUSTOMER.ID = CUST.ID

    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)
    Y.REL.CUSTOMER = R.CUSTOMER<EB.CUS.REL.CUSTOMER>
    Y.FAX = R.CUSTOMER<EB.CUS.FAX.1>

    CALL F.READ(FN.CUST.ACCOUNT,Y.CUSTOMER.ID,R.CUST.ACCOUNT,F.CUST.ACCOUNT,ERR.CUST.ACCOUNT)
    CHANGE @FM TO @VM IN R.CUST.ACCOUNT
    Y.ACCOUNT = R.CUST.ACCOUNT
    Y.ACC.CNT = DCOUNT(Y.ACCOUNT,@VM)

*---------------------------------
* Local table values are checked here
*-------------------------------------

    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.CUSTOMER.ID,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    R.REDO.EMPLOYEE.ACCOUNTS<REDO.EMP.ACCOUNT>=''

    CUS.ACC.POS = 1
    LOOP
    WHILE CUS.ACC.POS LE Y.ACC.CNT
*-----------------------------------
* Local table is being updated here
*-----------------------------------
        Y.REDO.EMP.ID = CUST.ID

        Y.ACC.VALUE = FIELD(Y.ACCOUNT,@VM,CUS.ACC.POS)

        R.REDO.EMPLOYEE.ACCOUNTS<REDO.EMP.ACCOUNT,-1> = Y.ACC.VALUE
        R.REDO.EMPLOYEE.ACCOUNTS<REDO.EMP.USER.ID> = Y.FAX
        R.REDO.EMPLOYEE.ACCOUNTS<REDO.EMP.REL.CUSTOMER> = Y.REL.CUSTOMER

        CALL F.WRITE(FN.REDO.EMPLOYEE.ACCOUNTS,Y.REDO.EMP.ID,R.REDO.EMPLOYEE.ACCOUNTS)

        CUS.ACC.POS += 1

    REPEAT

    GOSUB XREF.CHECK

RETURN

*-------------
XREF.CHECK:
*--------------------------------------------
* JOINT.CONTRACTS.XREF table is checked here
*--------------------------------------------
    XREF.POS = 1
    CALL F.READ(FN.JOINT.CONTRACTS.XREF,Y.CUSTOMER.ID,R.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF,ERR.JOINT.CONTRACTS.XREF)

    Y.ACC.CONTRACT = R.JOINT.CONTRACTS.XREF
    Y.ACC.CONTRACT.CNT = DCOUNT(Y.ACC.CONTRACT,@FM)
    LOOP
    WHILE XREF.POS LE Y.ACC.CONTRACT.CNT
        Y.ACC.VAL = FIELD(Y.ACC.CONTRACT,@FM,XREF.POS)

        CALL F.READ(FN.ACCOUNT,Y.ACC.VAL,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
        IF R.ACCOUNT THEN
            GOSUB UPDATE.ACC.XREF
        END

        XREF.POS += 1
    REPEAT

RETURN

*-------------------
UPDATE.ACC.XREF:
*----------------------------------------------------
* Local table is updated based on the account record
*----------------------------------------------------

    Y.ACC.XREF.ID = CUST.ID

    R.REDO.EMPLOYEE.ACCOUNTS<REDO.EMP.ACCOUNT,-1> = Y.ACC.VAL
    R.REDO.EMPLOYEE.ACCOUNTS<REDO.EMP.USER.ID> = Y.FAX

    CALL F.WRITE(FN.REDO.EMPLOYEE.ACCOUNTS,Y.ACC.XREF.ID,R.REDO.EMPLOYEE.ACCOUNTS)

RETURN

*----------------------------------------------------------------------
END
