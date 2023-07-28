* @ValidationCode : MjoxNzM0NDg4NzA5OkNwMTI1MjoxNjgyNDEyMzY2MjkwOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.VERIFY.STAFF
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : RAJA SAKTHIVEL K P
* Program Name  : REDO.V.INP.VERIFY.STAFF
*-------------------------------------------------------------------------
* Description: This routine is a validation routine attached to
*  FT,UNAUTH.STAFF.LOG,TELLER,UNAUTH.STAFF.LOG,DATA.CAPTURE,UNAUTH.STAFF.LOG to restrict transaction input for signed on USER
*----------------------------------------------------------
* Linked with: VERSION.CONTROL of FT,TELLER,DATA.CAPTURE as validation routine
* In parameter : None
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 02-03-10      ODR-2009-10-0532                     Initial Creation
*------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*17-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*17-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*---------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.DATA.CAPTURE
    $INSERT I_F.REDO.EMPLOYEE.ACCOUNTS
    $INSERT I_F.REDO.UNAUTH.STAFF.LOG


    IF COMI EQ '' THEN
        RETURN
    END

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

    FN.REDO.UNAUTH.STAFF.LOG = 'F.REDO.UNAUTH.STAFF.LOG'
    F.REDO.UNAUTH.STAFF.LOG = ''
    CALL OPF(FN.REDO.UNAUTH.STAFF.LOG,F.REDO.UNAUTH.STAFF.LOG)

RETURN
*-----------
PROCESS:
*-----------
* Process are carried out for various applications
*---------------------------------

    IF APPLICATION EQ "TELLER" THEN
        GOSUB TELLER.PROCESS
    END

    IF APPLICATION EQ "FUNDS.TRANSFER" THEN
        GOSUB FT.PROCESS
    END

    IF APPLICATION EQ "DATA.CAPTURE" THEN
        GOSUB DC.PROCESS
    END

RETURN

*---------------
TELLER.PROCESS:
*---------------
* Teller process is carried on here
*-------------------------------------
    Y.ACCOUNT1 = COMI
    IF AF EQ TT.TE.ACCOUNT.1 THEN

        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT1,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
        Y.AC.CUSTOMER1 = R.ACCOUNT<AC.CUSTOMER>

        IF Y.AC.CUSTOMER1 NE '' THEN
            CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.AC.CUSTOMER1,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
            CALL F.READ(FN.CUSTOMER,Y.AC.CUSTOMER1,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)
            GOSUB SEND.ERROR
        END
    END
    IF AF EQ TT.TE.ACCOUNT.2 THEN

        Y.ACCOUNT2 = COMI
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT2,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
        Y.AC.CUSTOMER2 = R.ACCOUNT<AC.CUSTOMER>

        IF Y.AC.CUSTOMER2 NE '' THEN

            CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.AC.CUSTOMER2,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
            CALL F.READ(FN.CUSTOMER,Y.AC.CUSTOMER2,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)
*-----------------------------
* Comparing the user ID with the Operator
*--------------------------------
            GOSUB SEND.ERROR

        END
    END
RETURN
*-------------
FT.PROCESS:
*-------------------------------
* FT process is carried on here
*-------------------------------
    Y.DBT.ACCT.NO = COMI
    Y.CRT.ACCT.NO = COMI
*---------------------
* Debit account is checked
*---------------------
    IF AF EQ FT.DEBIT.ACCT.NO THEN
        CALL F.READ(FN.ACCOUNT,Y.DBT.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
        Y.DBT.CUS = R.ACCOUNT<AC.CUSTOMER>
        IF Y.DBT.CUS NE '' THEN
            CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.DBT.CUS,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
            CALL F.READ(FN.CUSTOMER,Y.DBT.CUS,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)
            GOSUB SEND.ERROR
        END
    END
*-------------------------
* Credit account is checked
*---------------------------
    IF AF EQ FT.CREDIT.ACCT.NO THEN
        CALL F.READ(FN.ACCOUNT,Y.CRT.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
        Y.CRT.CUS = R.ACCOUNT<AC.CUSTOMER>
        IF Y.CRT.CUS NE '' THEN
            CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.CRT.CUS,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
            CALL F.READ(FN.CUSTOMER,Y.CRT.CUS,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)

            GOSUB SEND.ERROR
        END
    END

RETURN
*------------
DC.PROCESS:
*------------------------------
* Data Capture is checked here
*------------------------------

    Y.ACC.DC = COMI
    CALL F.READ(FN.ACCOUNT,Y.ACC.DC,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    Y.CUS.DC = R.ACCOUNT<AC.CUSTOMER>
    IF Y.CUS.DC NE '' THEN
        CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.CUS.DC,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
        CALL F.READ(FN.CUSTOMER,Y.CUS.DC,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)
        GOSUB SEND.ERROR
    END

RETURN

*-----------
SEND.ERROR:
*-----------
* Error message is defined here
*--------------------------------
    Y.USER.ID = R.REDO.EMPLOYEE.ACCOUNTS<REDO.EMP.USER.ID>
    IF Y.USER.ID EQ OPERATOR THEN
        GOSUB UPDATE.LOG
        ETEXT = 'EB-USER.NOT.ALLOW'
        CALL STORE.END.ERROR
    END

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
END
