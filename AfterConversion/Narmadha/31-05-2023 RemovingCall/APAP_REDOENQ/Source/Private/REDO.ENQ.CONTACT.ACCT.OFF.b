* @ValidationCode : MjotMTQ0NTQ3NjcxMjpVVEYtODoxNjg1NTMyMTMzNTE2OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 16:52:13
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
SUBROUTINE REDO.ENQ.CONTACT.ACCT.OFF(Y.ENQ.OUT)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is a nofile routine to select the CR.CONTACT.LOG based on the ACCOUNT OFFICER
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 24-AUG-2011     SHANKAR RAJU     ODR-2011-07-0162     Initial Creation
* 12-APRIL-2023      Conversion Tool       R22 Auto Conversion  - F.READ to CACHE.READ , FM to @FM
* 12-APRIL-2023      Harsha                R22 Manual Conversion - Added APAP.REDOENQ
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CR.CONTACT.LOG
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DEPT.ACCT.OFFICER

    GOSUB INITIALSE
    GOSUB PROCESS.SEL
    GOSUB SEL.ACCT.OFF

RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~~

    FN.CR.CONTACT.LOG = 'F.CR.CONTACT.LOG'
    F.CR.CONTACT.LOG  = ''
    CALL OPF(FN.CR.CONTACT.LOG,F.CR.CONTACT.LOG)

    FN.CUSTOMER       = 'F.CUSTOMER'
    F.CUSTOMER        = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.DAO = 'F.DEPT.ACCT.OFFICER'
    F.DAO  = ''
    CALL OPF(FN.DAO,F.DAO)

    VALUE.BK          = D.RANGE.AND.VALUE
    OPERAND.BK        = D.LOGICAL.OPERANDS
    FIELDS.BK         = D.FIELDS

    ACCT.OFF.ENQ      = ''

RETURN
*-------------------------------------------------------------------------
PROCESS.SEL:
*~~~~~~~~~~~

    D.RANGE.AND.VALUE=''
    D.LOGICAL.OPERANDS=''
    D.FIELDS=''

    ARRANGEMENT.APP.FLDS = 'CONTACT.CLIENT':@FM:'CONTACT.DATE':@FM:'CONTACT.STATUS'

    LOOP
        REMOVE ARR.FLD FROM ARRANGEMENT.APP.FLDS SETTING ARR.FLD.POS
    WHILE ARR.FLD:ARR.FLD.POS
        LOCATE ARR.FLD IN FIELDS.BK<1> SETTING POS1 THEN
            Y.ARR.FLAG = 1
            GOSUB UPDATE.COM.VAR
        END
    REPEAT

    IF D.FIELDS NE '' THEN
        FILE.NAME = FN.CR.CONTACT.LOG
        APAP.REDOENQ.redoEFormSelStmt(FILE.NAME, '', '', SEL.CR.CMD)	;*R22 Manual Conversion - Added APAP.REDOENQ
        SEL.CR.CMD = SEL.CR.CMD:" AND WITH (CONTACT.STATUS EQ 'NEW' OR CONTACT.STATUS EQ 'NO.COMUNICADO') BY CONTACT.CLIENT"
        CALL EB.READLIST(SEL.CR.CMD,CR.ID.LST,'',NO.OF.REC.ARR,SEL.ERR)
    END ELSE
        SEL.CR.CMD = "SELECT ":FN.CR.CONTACT.LOG:" WITH (CONTACT.STATUS EQ 'NEW' OR CONTACT.STATUS EQ 'NO.COMUNICADO') BY CONTACT.CLIENT"
        CALL EB.READLIST(SEL.CR.CMD,CR.ID.LST,'',NO.OF.REC.ARR,SEL.ERR)
    END

RETURN
*-------------------------------------------------------------------------
UPDATE.COM.VAR:
*--------------

    D.RANGE.AND.VALUE<-1>=VALUE.BK<POS1>
    D.LOGICAL.OPERANDS<-1>=OPERAND.BK<POS1>
    D.FIELDS<-1>=FIELDS.BK<POS1>

RETURN
*-------------------------------------------------------------------------
SEL.ACCT.OFF:
*------------

    LOCATE 'ACCOUNT.OFFICER' IN FIELDS.BK<1> SETTING ACCT.OFF.POS THEN
        ACCT.OFF.ENQ = VALUE.BK<ACCT.OFF.POS>
        ACCT.OFF.OP  = OPERAND.BK<ACCT.OFF.POS>
        ACCT.OFF.OP  = OPERAND.LIST<ACCT.OFF.OP>
    END


    IF ACCT.OFF.ENQ THEN

        LOOP
            REMOVE Y.CR.ID FROM CR.ID.LST SETTING ARR.FLD.POS
        WHILE Y.CR.ID:ARR.FLD.POS

            R.CR.CONTACT.LOG = ''

            CALL F.READ(FN.CR.CONTACT.LOG,Y.CR.ID,R.CR.CONTACT.LOG,F.CR.CONTACT.LOG,ERR.CR)

            Y.CUS.ID = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.CLIENT>

            R.CUSTOMER = ''

            CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,ERR.CUS)

            Y.ACCT.OFFICER = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>

            IF Y.ACCT.OFFICER EQ ACCT.OFF.ENQ THEN

                GOSUB ASSIGN.VALUES
                GOSUB FORM.ARRAY
            END

        REPEAT

    END ELSE
        LOOP
            REMOVE Y.CR.ID FROM CR.ID.LST SETTING ARR.FLD.POS
        WHILE Y.CR.ID:ARR.FLD.POS

            R.CR.CONTACT.LOG = ''

            CALL F.READ(FN.CR.CONTACT.LOG,Y.CR.ID,R.CR.CONTACT.LOG,F.CR.CONTACT.LOG,ERR.CR)

            Y.CUS.ID = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.CLIENT>

            GOSUB ASSIGN.VALUES
            GOSUB FORM.ARRAY

        REPEAT

    END

RETURN
*-------------------------------------------------------------------------
ASSIGN.VALUES:
*-------------

    Y.LOG.ID = Y.CR.ID          ;***************************************************** 1ST FIELD VALUE
*   Y.CUS.ID                  ;***************************************************** 2ND FIELD VALUE
    IF R.CUSTOMER ELSE
        R.CUSTOMER = ''

        CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,ERR.CUS)

        Y.ACCT.OFFICER = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
    END

    R.DAO = ''

    CALL CACHE.READ(FN.DAO, Y.ACCT.OFFICER, R.DAO, ERR.DAO)	;*R22 Auto Conversion  - F.READ to CACHE.READ

    IF R.DAO THEN
        Y.DAO.NAME       = R.DAO<EB.DAO.NAME>         ;********************************* 3RD FIELD VALUE
    END

    Y.CONTACT.DATE   = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.DATE>       ;************* 4TH FIELD VALUE
    Y.CONTACT.TYPE   = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.TYPE>       ;************* 5TH FIELD VALUE
    Y.CONTACT.STATUS = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.STATUS>     ;************* 6TH FIELD VALUE
    Y.CONTACT.DESC   = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.DESC>       ;************* 7TH FIELD VALUE

RETURN
*-------------------------------------------------------------------------
FORM.ARRAY:
*----------
    IF Y.ENQ.OUT EQ '' THEN

*VALUE NO :             1            2            3                 4                  5                   6                 7

        Y.ENQ.OUT = Y.LOG.ID:"*":Y.CUS.ID:"*":Y.DAO.NAME:"*":Y.CONTACT.DATE:"*":Y.CONTACT.TYPE:"*":Y.CONTACT.STATUS:"*":Y.CONTACT.DESC

    END ELSE

*VALUE NO :                 1            2             3                4                 5                   6                   7

        Y.ENQ.OUT<-1> = Y.LOG.ID:"*":Y.CUS.ID:"*":Y.DAO.NAME:"*":Y.CONTACT.DATE:"*":Y.CONTACT.TYPE:"*":Y.CONTACT.STATUS:"*":Y.CONTACT.DESC

    END

RETURN
*-------------------------------------------------------------------------
END
