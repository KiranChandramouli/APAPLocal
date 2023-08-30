* @ValidationCode : MjotNjE4MTUwNTg6Q3AxMjUyOjE2ODE3MTAwMjI5MjU6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Apr 2023 11:10:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BLD.CONTACT.CUS(ENQ.DATA)
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------
* Modification History
* DATE            ODR           BY              DESCRIPTION
* 25-08-2011      FS-360       Manju.G          For enquiry REDO.SCV.CONTACT.CURR.SCV
* Date                   who                   Reference              
* 17-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND SM TO @SM 
* 17-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*
*------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.USER
    $INSERT I_F.REDO.UNAUTH.STAFF.LOG
    $INSERT I_F.REDO.EMPLOYEE.SUPER.USER

    GOSUB INITIALISE
    GOSUB PROCESS
    GOSUB PGM.END
*
RETURN

INITIALISE:
*************

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.CR.CONTACT = 'F.CR.CONTACT.LOG'
    F.CR.CONTACT = ''
    CALL OPF(FN.CR.CONTACT,F.CR.CONTACT)

    FN.REDO.UNAUTH.STAFF.LOG='F.REDO.UNAUTH.STAFF.LOG'
    F.REDO.UNAUTH.STAFF.LOG=''
    CALL OPF(FN.REDO.UNAUTH.STAFF.LOG,F.REDO.UNAUTH.STAFF.LOG)

    FN.REDO.EMPLOYEE.SUPER.USER='F.REDO.EMPLOYEE.SUPER.USER'
    F.REDO.EMPLOYEE.SUPER.USER=''
    CALL OPF(FN.REDO.EMPLOYEE.SUPER.USER,F.REDO.EMPLOYEE.SUPER.USER)

    FN.REDO.EMPLOYEE.ACCOUNTS = 'F.REDO.EMPLOYEE.ACCOUNTS'
    F.REDO.EMPLOYEE.ACCOUNTS = ''
    CALL OPF(FN.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS)

RETURN

PROCESS:
**********
    Y.CR.CONTACT.ID = ENQ.DATA<1,1>
    Y.CR = ENQ.DATA<2,1>
    Y.CONT = ENQ.DATA<3,1>
    Y.ID = ENQ.DATA<4,1>
*PACS00321243 - START
    CALL F.READ(FN.CUSTOMER,Y.ID,R.CUSTOMER,F.CUSTOMER,ERR)
    Y.FAX=R.CUSTOMER<EB.CUS.FAX.1,1>

    CALL CACHE.READ(FN.REDO.EMPLOYEE.SUPER.USER,'SYSTEM',R.SUPER.USER,SUPER.ERR)
    Y.DAO = R.SUPER.USER<REDO.SUPER.DAO>
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
        Y.FLUSH.IT = ''
        CALL LOG.WRITE(FN.REDO.UNAUTH.STAFF.LOG,Y.LOG.ID,R.REDO.UNAUTH.STAFF.LOG,Y.FLUSH.IT)
        GOSUB PGM.END
    END
*PACS00321243 - END
    SEL.CMD = "SELECT ":FN.CR.CONTACT:" WITH CONTACT.CLIENT EQ ":Y.ID:" AND WITH ( CONTRACT.ID LIKE FT... OR CONTRACT.ID LIKE TT... ) BY-DSND DATE.TIME"
    CALL EB.READLIST(SEL.CMD,SEL.LIST1,'',SEL.NOR1,SEL.RET1)


    Y.SEL.CUS = '1'
    Y.MAX = 20
    LOOP
    WHILE Y.SEL.CUS LE SEL.NOR1
        Y.SEL.ID<-1> = SEL.LIST1<Y.SEL.CUS>
        Y.SEL.CUS += 1
        IF Y.SEL.CUS GT Y.MAX THEN
            Y.SEL.CUS +=SEL.NOR1
        END
    REPEAT

    CHANGE @FM TO @SM IN Y.SEL.ID
    ENQ.DATA<2,1> = "@ID"
    ENQ.DATA<3,1> = "EQ"
    ENQ.DATA<4,1> = Y.SEL.ID
RETURN
*----------------------------------------------------------
PGM.END:
*----------------------------------------------------------
END
