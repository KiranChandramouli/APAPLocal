$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.VAL.ACCOUNT1(ENQ.DATA)

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : H GANESH
* Program Name  : REDO.E.BLD.VAL.ACCOUNT1
*-------------------------------------------------------------------------
* Description: This routine is a build routine attached to all enquiries
* which have account no as selection field to restrict unauthorised access
*----------------------------------------------------------
* Linked with: All enquiries with Customer no as selection field
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 01-07-10          HD1018951                            UAT issue
* 09-09-11          PACS00075748                         MODIFIED WITH PARAMETER
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion  - VM to @VM , FM to @FM and ++ to +=1
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
    $INSERT I_F.ENQUIRY
    $INSERT I_F.REDO.UNAUTH.STAFF.LOG
    $INSERT I_F.REDO.EMPLOYEE.ACCOUNTS
    $INSERT I_F.REDO.RESTRICT.ENQ.DATA
    $INSERT I_F.REDO.EMPLOYEE.SUPER.USER

    GOSUB OPENFILES
    GOSUB PROCESS

    Y.ENQ.NAME = ENQ.DATA<1>
    IF Y.ENQ.NAME EQ "REDO.ACCOUNT.STATEMENT.SCRN" THEN
        CALL E.AC.STMT.SCRN.BUILD(ENQ.DATA)
    END
RETURN

*---------
OPENFILES:
*---------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.EMPLOYEE.ACCOUNTS = 'F.REDO.EMPLOYEE.ACCOUNTS'
    F.REDO.EMPLOYEE.ACCOUNTS = ''
    CALL OPF(FN.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS)

    FN.REDO.UNAUTH.STAFF.LOG = 'F.REDO.UNAUTH.STAFF.LOG'
    F.REDO.UNAUTH.STAFF.LOG = ''
    CALL OPF(FN.REDO.UNAUTH.STAFF.LOG,F.REDO.UNAUTH.STAFF.LOG)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT=''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.REDO.RESTRICT.ENQ.DATA='F.REDO.RESTRICT.ENQ.DATA'
    F.REDO.RESTRICT.ENQ.DATA=''
    CALL OPF(FN.REDO.RESTRICT.ENQ.DATA,F.REDO.RESTRICT.ENQ.DATA)

    FN.REDO.EMPLOYEE.SUPER.USER='F.REDO.EMPLOYEE.SUPER.USER'
    F.REDO.EMPLOYEE.SUPER.USER=''
RETURN

*-------
PROCESS:
*-----------------------------------------
* Main enquiry process is carried on here
*-----------------------------------------
    Y.CHANGE=0
    GOSUB GET.DAO.DETAILS
    R.REDO.UNAUTH.STAFF.LOG = ''
    R.REDO.EMPLOYEE.ACCOUNTS = ''
    Y.CUS=''
    CALL F.READ(FN.REDO.RESTRICT.ENQ.DATA,'ACCOUNT',R.REDO.RESTRICT.ENQ.DATA,F.REDO.RESTRICT.ENQ.DATA,ERR)
    Y.PARAMETER.ENQUIRY=R.REDO.RESTRICT.ENQ.DATA<RE.RE.ENQUIRY.NAME>
    Y.FIELD.NAME       =R.REDO.RESTRICT.ENQ.DATA<RE.RE.FIELD.NAME>
    CHANGE @VM TO @FM IN Y.PARAMETER.ENQUIRY
    LOCATE ENQ.DATA<1,1> IN Y.PARAMETER.ENQUIRY SETTING POS.FIELD THEN
        Y.ACCOUNT.FIELD=Y.FIELD.NAME<1,POS.FIELD>
        LOCATE Y.ACCOUNT.FIELD IN ENQ.DATA<2,1> SETTING POS1 THEN
            Y.ACCOUNT=ENQ.DATA<4,POS1>
        END ELSE
            POS1=''
        END
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    END
*    GOSUB CHECK.PERFORMANCE

    Y.CUS=R.ACCOUNT<AC.CUSTOMER>
    IF Y.CUS NE '' THEN
        CALL F.READ(FN.CUSTOMER,Y.CUS,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)
        IF R.CUSTOMER THEN
            FAX.COUNT= DCOUNT(R.CUSTOMER<EB.CUS.FAX.1>,@VM)
            VAR3=1
            LOOP
            WHILE VAR3 LE FAX.COUNT
                Y.FAX = R.CUSTOMER<EB.CUS.FAX.1,VAR3>
                GOSUB CHECK.TABLE
                VAR3 += 1
            REPEAT
        END
    END

    Y.JOIN.LIST=R.ACCOUNT<AC.JOINT.HOLDER>
    IF Y.JOIN.LIST THEN
        Y.JOIN.LIST.CNT=DCOUNT(Y.JOIN.LIST,@VM)
        Y.CNT.JL=1
        LOOP
        WHILE Y.CNT.JL LE Y.JOIN.LIST.CNT
            Y.CUS=Y.JOIN.LIST<1,Y.CNT.JL>
            IF Y.CUS NE '' THEN
                CALL F.READ(FN.CUSTOMER,Y.CUS,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)
                IF R.CUSTOMER THEN
                    FAX.COUNT= DCOUNT(R.CUSTOMER<EB.CUS.FAX.1>,@VM)
                    VAR3=1
                    LOOP
                    WHILE VAR3 LE FAX.COUNT
                        Y.FAX = R.CUSTOMER<EB.CUS.FAX.1,VAR3>
                        GOSUB CHECK.TABLE
                        VAR3 += 1
                    REPEAT
                END
            END
            Y.CNT.JL += 1
        REPEAT
    END
RETURN
*---------------------
CHECK.PERFORMANCE:
*-------------------------

********START*****THIS PART IS USED TO FIX THE PERFOMANCE ISSUE
    Y.FILE.NAME = R.ENQ<ENQ.FILE.NAME>
    VAR.APPLICATION = FIELD(Y.FILE.NAME,'$',1)
    IF (VAR.APPLICATION EQ 'ACCOUNT') OR (VAR.APPLICATION EQ 'AZ.ACCOUNT') THEN
        LOCATE 'ACCOUNT.NUMBER' IN ENQ.DATA<2,1> SETTING ACCT.POS THEN
            ENQ.DATA<2,ACCT.POS> = "@ID"
            Y.CHANGE=1
        END
    END
********STOP********
RETURN
*-----------
CHECK.TABLE:
*--------------------------------------
* Employee table is being checked here
*--------------------------------------
    CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.CUS,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,ERR.REDO.EMPLOYEE.ACCOUNTS)
    IF R.REDO.EMPLOYEE.ACCOUNTS THEN
        Y.USER.ID = R.REDO.EMPLOYEE.ACCOUNTS<REDO.EMP.USER.ID>
        IF Y.USER.ID NE OPERATOR THEN
            ENQ.ERROR = 'EB-NO.ACCESS.USER'
            CALL STORE.END.ERROR
            GOSUB UPDATE.LOG
            GOSUB END1
        END
    END
RETURN
*----------
UPDATE.LOG:
*---------------------------------------
* The log Table is being updated here
*---------------------------------------
    CALL ALLOCATE.UNIQUE.TIME(CURRTIME)
    Y.LOG.ID = 'STAFF.':CURRTIME
    R.REDO.UNAUTH.STAFF.LOG<REDO.LOG.USER.ID> = OPERATOR
    R.REDO.UNAUTH.STAFF.LOG<REDO.LOG.ACTIVITY.DATE> = TODAY
    R.REDO.UNAUTH.STAFF.LOG<REDO.LOG.ACTIVITY.TIME> = OCONV(TIME(), "MTS")
    R.REDO.UNAUTH.STAFF.LOG<REDO.LOG.APPLICATION> = APPLICATION
    R.REDO.UNAUTH.STAFF.LOG<REDO.LOG.RECORD.ID> = ID.NEW
* CALL F.WRITE(FN.REDO.UNAUTH.STAFF.LOG,Y.LOG.ID,R.REDO.UNAUTH.STAFF.LOG)
* CALL JOURNAL.UPDATE(Y.LOG.ID)
    Y.FLUSH.IT = ''
    CALL LOG.WRITE(FN.REDO.UNAUTH.STAFF.LOG,Y.LOG.ID,R.REDO.UNAUTH.STAFF.LOG,Y.FLUSH.IT)
RETURN
*---------------------------------------
GET.DAO.DETAILS:
*---------------------------------------

    CALL CACHE.READ(FN.REDO.EMPLOYEE.SUPER.USER,'SYSTEM',R.SUPER.USER,SUPER.ERR)
    Y.DAO = R.SUPER.USER<REDO.SUPER.DAO>
    Y.LOGGED.USER.DAO = R.USER<EB.USE.DEPARTMENT.CODE>
    LOCATE Y.LOGGED.USER.DAO IN Y.DAO<1,1> SETTING POS4 THEN
        Y.HR.OFFICER = 'YES'
    END ELSE
        Y.HR.OFFICER = ''
    END
    IF Y.HR.OFFICER EQ 'YES' THEN
*        GOSUB CHECK.PERFORMANCE
        GOSUB END1
    END
RETURN

END1:
END
