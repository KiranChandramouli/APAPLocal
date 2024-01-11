* @ValidationCode : MjoxNzExOTc5NDI0OlVURi04OjE3MDM1MTM3NDkwMDY6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Dec 2023 19:45:49
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.VAL.USER(ENQ.DATA)

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : RAJA SAKTHIVEL K P
* Program Name  : REDO.E.BLD.VAL.USER
*-------------------------------------------------------------------------
* Description: This routine is a build routine attached to all enquiries
* which have customer no as selection field to restrict unauthorised access
*----------------------------------------------------------
* Linked with: All enquiries with Customer no as selection field
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 02-03-10      ODR-2009-10-0532                     Initial Creation
* 01-07-10      HD1018951                            UAT issue
* 14-12-10      ODR-2010-12-0495                     MODIFIED THE REDO.EMPLOYEE.ACCOUNTS
* 14-12-10      pacs00075748                         parameterisation for all enquiries
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion  - VM to @VM , FM to @FM and ++ to +=1
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 26-12-2023         Narmadha V            Manual R22 Conversion   ID variable changed instead of Hardcoding
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
    $INSERT I_F.REDO.UNAUTH.STAFF.LOG
    $INSERT I_F.REDO.EMPLOYEE.ACCOUNTS
    $INSERT I_F.REDO.RESTRICT.ENQ.DATA
    $INSERT I_F.REDO.EMPLOYEE.SUPER.USER

    GOSUB OPENFILES
    GOSUB PROCESS

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


    FN.REDO.RESTRICT.ENQ.DATA='F.REDO.RESTRICT.ENQ.DATA'
    F.REDO.RESTRICT.ENQ.DATA=''
    CALL OPF(FN.REDO.RESTRICT.ENQ.DATA,F.REDO.RESTRICT.ENQ.DATA)

    FN.REDO.EMPLOYEE.SUPER.USER='F.REDO.EMPLOYEE.SUPER.USER'
    F.REDO.EMPLOYEE.SUPER.USER=''

    FN.CUS.LEGAL.ID = 'F.REDO.CUSTOMER.LEGAL.ID'
    F.CUS.LEGAL.ID = ''
    CALL OPF(FN.CUS.LEGAL.ID,F.CUS.LEGAL.ID)

RETURN

*-------
PROCESS:
*-----------------------------------------
* Main enquiry process is carried on here
*-----------------------------------------
    GOSUB GET.DAO.DETAILS
    R.REDO.UNAUTH.STAFF.LOG = ''
    R.REDO.EMPLOYEE.ACCOUNTS = ''
    Y.CUS=''
    Y.ID = "CUSTOMER"
*CALL F.READ(FN.REDO.RESTRICT.ENQ.DATA,'CUSTOMER',R.REDO.RESTRICT.ENQ.DATA,F.REDO.RESTRICT.ENQ.DATA,ERR)
    CALL F.READ(FN.REDO.RESTRICT.ENQ.DATA,Y.ID,R.REDO.RESTRICT.ENQ.DATA,F.REDO.RESTRICT.ENQ.DATA,ERR) ;*Manual R22 Conversion - ID variable Changed Instead of Hardcoding
    Y.PARAMETER.ENQUIRY=R.REDO.RESTRICT.ENQ.DATA<RE.RE.ENQUIRY.NAME>
    Y.FIELD.NAME       =R.REDO.RESTRICT.ENQ.DATA<RE.RE.FIELD.NAME>
    CHANGE @VM TO @FM IN Y.PARAMETER.ENQUIRY

    LOCATE ENQ.DATA<1,1> IN Y.PARAMETER.ENQUIRY SETTING POS.FIELD THEN
        Y.FIELD.NAME.POS=Y.FIELD.NAME<1,POS.FIELD>
        LOCATE Y.FIELD.NAME.POS IN ENQ.DATA<2,1> SETTING POS1 THEN
            Y.CUS=ENQ.DATA<4,POS1>
        END ELSE
            POS1=''
        END
    END

    GOSUB CHECK.PERFORMANCE


    IF ENQ.DATA<1,1> EQ 'REDO.CUST.ACCT.FULL' THEN
        LOCATE 'MB.CUSTOMER.ID' IN ENQ.DATA<2,1> SETTING POS1 THEN
            Y.CUS=ENQ.DATA<4,POS1>
        END ELSE
            POS1=''
        END
*/ODR-2010-12-0495 -S

        LOCATE '@ID' IN ENQ.DATA<2,1> SETTING AC.POS THEN
            Y.ACC.NO=ENQ.DATA<4,AC.POS>
            SEL.CMD='SELECT ':FN.REDO.EMPLOYEE.ACCOUNTS:' WITH ACCOUNT EQ ':Y.ACC.NO
        END ELSE
            AC.POS=''
            SEL.CMD = 'SELECT ':FN.REDO.EMPLOYEE.ACCOUNTS
        END
    END ELSE
        SEL.CMD = 'SELECT ':FN.REDO.EMPLOYEE.ACCOUNTS
    END



    IF ENQ.DATA<1,1> EQ 'REDO.CUST.ACCT.FULL.SCV' THEN
        LOCATE 'MB.CUSTOMER.ID' IN ENQ.DATA<2,1> SETTING POS1 THEN
            Y.CUS=ENQ.DATA<4,POS1>
        END ELSE
            POS1=''
        END
*/ODR-2010-12-0495 -S

        LOCATE '@ID' IN ENQ.DATA<2,1> SETTING AC.POS THEN
            Y.ACC.NO=ENQ.DATA<4,AC.POS>
            SEL.CMD='SELECT ':FN.REDO.EMPLOYEE.ACCOUNTS:' WITH ACCOUNT EQ ':Y.ACC.NO
        END ELSE
            AC.POS=''
            SEL.CMD = 'SELECT ':FN.REDO.EMPLOYEE.ACCOUNTS
        END
    END ELSE
        SEL.CMD = 'SELECT ':FN.REDO.EMPLOYEE.ACCOUNTS
    END


*/ODR-2010-12-0495 -E
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
RETURN
*-------------------
CHECK.PERFORMANCE:
*-------------------

    LOCATE 'CUSTOMER.NO' IN ENQ.DATA<2,1> SETTING CUS.POS THEN
        ENQ.DATA<2,CUS.POS> = "@ID"
    END

    LOCATE 'LEGAL.ID' IN ENQ.DATA<2,1> SETTING LEGAL.POS THEN

        PASSPORT.NUMBER  =  ENQ.DATA<4,LEGAL.POS>

        CALL F.READ(FN.CUS.LEGAL.ID,PASSPORT.NUMBER,R.CUS.LEGAL.ID,F.CUS.LEGAL.ID,CUS.LEGAL.ERR)
        IF R.CUS.LEGAL.ID THEN
            CUS.ID = FIELD(R.CUS.LEGAL.ID,"*",2)
        END ELSE
            CUS.ID = ''
        END

        ENQ.DATA<2,LEGAL.POS> = "@ID"
        ENQ.DATA<4,LEGAL.POS> = CUS.ID

    END

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
*    CALL F.WRITE(FN.REDO.UNAUTH.STAFF.LOG,Y.LOG.ID,R.REDO.UNAUTH.STAFF.LOG)
*    CALL JOURNAL.UPDATE(Y.LOG.ID)
    Y.FLUSH.IT = ''
    CALL LOG.WRITE(FN.REDO.UNAUTH.STAFF.LOG,Y.LOG.ID,R.REDO.UNAUTH.STAFF.LOG,Y.FLUSH.IT)
RETURN
*---------------------------------------
GET.DAO.DETAILS:
*---------------------------------------
    ID.VAR = "SYSTEM"
* CALL CACHE.READ(FN.REDO.EMPLOYEE.SUPER.USER,'SYSTEM',R.SUPER.USER,SUPER.ERR)
    CALL CACHE.READ(FN.REDO.EMPLOYEE.SUPER.USER,ID.VAR,R.SUPER.USER,SUPER.ERR) ;*Manual R22 Conversion - ID variable changed instead of Hardcoding
    Y.DAO = R.SUPER.USER<REDO.SUPER.DAO>
    Y.LOGGED.USER.DAO = R.USER<EB.USE.DEPARTMENT.CODE>
    LOCATE Y.LOGGED.USER.DAO IN Y.DAO<1,1> SETTING POS4 THEN
        Y.HR.OFFICER = 'YES'
    END ELSE
        Y.HR.OFFICER = ''
    END
    IF Y.HR.OFFICER EQ 'YES' THEN
        GOSUB CHECK.PERFORMANCE
        GOSUB END1
    END

RETURN

END1:
END
