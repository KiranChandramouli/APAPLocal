* @ValidationCode : MjotNTkwNjc4MTE3OlVURi04OjE3MDMyNTEwODY4NTg6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Dec 2023 18:48:06
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
SUBROUTINE REDO.E.BLD.CHK.CUSTOMER.POS(ENQ.DATA)

*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used as build routine for loan and deposit customer position
*------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 23-08-2011        Prabhu.N         PACS00075748         Initial Creation
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 22-12-2023         Narmadha V            Manual R22 Conversion - Changed ID variable instead of Hardcoding
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.UNAUTH.STAFF.LOG
    $INSERT I_F.REDO.EMPLOYEE.SUPER.USER
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

*---------
OPENFILES:
*---------


    FN.REDO.EMPLOYEE.ACCOUNTS = 'F.REDO.EMPLOYEE.ACCOUNTS'
    F.REDO.EMPLOYEE.ACCOUNTS = ''
    CALL OPF(FN.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS)

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.UNAUTH.STAFF.LOG='F.REDO.UNAUTH.STAFF.LOG'
    F.REDO.UNAUTH.STAFF.LOG=''
    CALL OPF(FN.REDO.UNAUTH.STAFF.LOG,F.REDO.UNAUTH.STAFF.LOG)

    FN.REDO.EMPLOYEE.SUPER.USER='F.REDO.EMPLOYEE.SUPER.USER'
    F.REDO.EMPLOYEE.SUPER.USER=''
*  CALL OPF(FN.REDO.EMPLOYEE.SUPER.USER,F.REDO.EMPLOYEE.SUPER.USER)

RETURN
*-------
PROCESS:
*-----------------------------------------
* Main enquiry process is carried on here
*-----------------------------------------

*---------------------------------------
    LOCATE '@ID' IN ENQ.DATA<2,1> SETTING POS1 THEN
        SEL.FIELD='@ID'
        SEL.VAL  =ENQ.DATA<4,POS1>
    END
    LOCATE 'L.CU.RNC' IN ENQ.DATA<2,1> SETTING POS1 THEN
        SEL.FIELD='L.CU.RNC'
        SEL.VAL  =ENQ.DATA<4,POS1>
    END
    LOCATE 'L.CU.CIDENT' IN ENQ.DATA<2,1> SETTING POS1 THEN
        SEL.FIELD='L.CU.CIDENT'
        SEL.VAL  =ENQ.DATA<4,POS1>
    END
    LOCATE 'L.CU.ACTANAC' IN ENQ.DATA<2,1> SETTING POS1 THEN
        SEL.FIELD='L.CU.ACTANAC'
        SEL.VAL  =ENQ.DATA<4,POS1>
    END

    LOCATE 'L.CU.NOUNICO' IN ENQ.DATA<2,1> SETTING POS1 THEN
        SEL.FIELD='L.CU.NOUNICO'
        SEL.VAL  =ENQ.DATA<4,POS1>
    END

    SEL.CMD="SELECT ":FN.CUSTOMER:" WITH ":SEL.FIELD:" EQ ":SEL.VAL
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    CALL F.READ(FN.CUSTOMER,SEL.LIST,R.CUSTOMER,F.CUSTOMER,ERR)
    Y.FAX=R.CUSTOMER<EB.CUS.FAX.1>
    Y.ID = "SYSTEM"
* CALL CACHE.READ(FN.REDO.EMPLOYEE.SUPER.USER,'SYSTEM',R.SUPER.USER,SUPER.ERR)
    CALL CACHE.READ(FN.REDO.EMPLOYEE.SUPER.USER,Y.ID,R.SUPER.USER,SUPER.ERR) ;*Manual R22 Conversion - Changed ID variable instead of Hardcoding
    Y.DAO = R.SUPER.USER<REDO.SUPER.DAO>
*   Y.PAYROLL.CATEG = R.SUPER.USER<REDO.SUPER.PAYROLL.CATEGORY>
    Y.LOGGED.USER.DAO = R.USER<EB.USE.DEPARTMENT.CODE>
    LOCATE Y.LOGGED.USER.DAO IN Y.DAO<1,1> SETTING POS4 THEN
        Y.HR.OFFICER = 'YES'
    END ELSE
        Y.HR.OFFICER = ''
    END

    IF Y.FAX NE OPERATOR AND Y.FAX AND Y.HR.OFFICER NE 'YES' THEN
        ENQ.ERROR = 'EB-NO.ACCESS.USER'
        CALL STORE.END.ERROR
        CALL ALLOCATE.UNIQUE.TIME(CURRTIME)
        Y.LOG.ID = 'STAFF.':CURRTIME
        R.REDO.UNAUTH.STAFF.LOG<REDO.LOG.USER.ID> = OPERATOR
        R.REDO.UNAUTH.STAFF.LOG<REDO.LOG.ACTIVITY.DATE> = TODAY
        R.REDO.UNAUTH.STAFF.LOG<REDO.LOG.ACTIVITY.TIME> = OCONV(TIME(), "MTS")
        R.REDO.UNAUTH.STAFF.LOG<REDO.LOG.APPLICATION> = APPLICATION
        R.REDO.UNAUTH.STAFF.LOG<REDO.LOG.RECORD.ID> = ID.NEW
        CALL F.WRITE(FN.REDO.UNAUTH.STAFF.LOG,Y.LOG.ID,R.REDO.UNAUTH.STAFF.LOG)
        CALL JOURNAL.UPDATE(Y.LOG.ID)
    END
RETURN
END
