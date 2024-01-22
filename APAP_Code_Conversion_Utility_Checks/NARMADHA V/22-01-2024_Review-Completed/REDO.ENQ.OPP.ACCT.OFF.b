* @ValidationCode : MjotMTIyMDE2MTM3NDpVVEYtODoxNzA1OTE3NDA2NjI2OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 22 Jan 2024 15:26:46
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
SUBROUTINE REDO.ENQ.OPP.ACCT.OFF(Y.ENQ.OUT)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is a nofile routine to select the OPPORTUNITY based on the ACCOUNT OFFICER
*-------------------------------------------------------------------------
* HISTORY:
*---------
* Date who Reference Description

* 24-AUG-2011 SHANKAR RAJU ODR-2011-07-0162 Initial Creation

* 13-APR-2023     Conversion tool    R22 Auto conversion       F.READ to CACHE.READ
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* 19-01-2024         Narmadha V     R22 Utility Changes,Manual R22 Conversion -  CALL OPF ADDED
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CR.OPPORTUNITY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DEPT.ACCT.OFFICER
    $INSERT I_F.CR.OPPORTUNITY.STATUS
    $USING EB.LocalReferences ;*Manual R22 Conversion

    GOSUB INITIALSE
    GOSUB PROCESS.SEL
    GOSUB SEL.ACCT.OFF

RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~~

    FN.CR.OPPORTUNITY = 'F.CR.OPPORTUNITY'
    F.CR.OPPORTUNITY = ''
    CALL OPF(FN.CR.OPPORTUNITY,F.CR.OPPORTUNITY)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    R.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.DAO = 'F.DEPT.ACCT.OFFICER'
    F.DAO = ''
    CALL OPF(FN.DAO,F.DAO)

    ACCT.OFF.ENQ = ''

    FN.CR.OPPORTUNITY.STATUS = 'F.CR.OPPORTUNITY.STATUS'
    F.CR.OPPORTUNITY.STATUS = ''
    CALL OPF(FN.CR.OPPORTUNITY.STATUS,F.CR.OPPORTUNITY.STATUS)

    LREF.APP = 'CUSTOMER'
    LREF.FIELDS = 'L.CU.SEGMENTO'
    LREF.POS = ''
*CALL GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    EB.LocalReferences.GetLocRef(LREF.APP,LREF.FIELDS,LREF.POS);* R22 Utility Changes

    L.CU.SEGMENTO.POS = LREF.POS<1,1>

RETURN
*-------------------------------------------------------------------------
PROCESS.SEL:
*~~~~~~~~~~~

    SEL.CR.CMD = "SELECT ":FN.CR.OPPORTUNITY:" WITH OPPOR.STATUS EQ NOT.COMMUNICATED.YET"
    CALL EB.READLIST(SEL.CR.CMD,CR.ID.LST,'',NO.OF.REC.ARR,SEL.ERR)

RETURN
*-------------------------------------------------------------------------
SEL.ACCT.OFF:
*------------

    LOCATE 'ACCOUNT.OFFICER' IN D.FIELDS<1> SETTING ACCT.OFF.POS THEN
        ACCT.OFF.ENQ = D.RANGE.AND.VALUE<ACCT.OFF.POS>
        ACCT.OFF.OP = D.LOGICAL.OPERANDS<ACCT.OFF.POS>
        ACCT.OFF.OP = D.FIELDS<ACCT.OFF.OP>
    END


    IF ACCT.OFF.ENQ THEN

        LOOP
            REMOVE Y.OPP.ID FROM CR.ID.LST SETTING ARR.FLD.POS
        WHILE Y.OPP.ID:ARR.FLD.POS

            R.CR.OPPORTUNITY = ''

            CALL F.READ(FN.CR.OPPORTUNITY,Y.OPP.ID,R.CR.OPPORTUNITY,F.CR.OPPORTUNITY,ERR.CR)

            Y.CUS.ID = R.CR.OPPORTUNITY<CR.OP.CUSTOMER>

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
            REMOVE Y.OPP.ID FROM CR.ID.LST SETTING ARR.FLD.POS
        WHILE Y.OPP.ID:ARR.FLD.POS

            R.CR.OPPORTUNITY = ''

            CALL F.READ(FN.CR.OPPORTUNITY,Y.OPP.ID,R.CR.OPPORTUNITY,F.CR.OPPORTUNITY,ERR.CR)

            Y.CUS.ID = R.CR.OPPORTUNITY<CR.OP.CUSTOMER>

            R.CUSTOMER = ''

            GOSUB ASSIGN.VALUES
            GOSUB FORM.ARRAY

        REPEAT

    END

RETURN
*-------------------------------------------------------------------------
ASSIGN.VALUES:
*-------------
    Y.LOG.ID = ''; Y.OPP.PRODUCT = ''; Y.DAO.NAME = ''; Y.SEGMENT = ''; Y.DIRECTION = ''; Y.START.DATE = ''; Y.ENQ.DATE = ''
    Y.DIRECTION = ''; Y.OPP.STATUS = ''

    Y.LOG.ID = Y.OPP.ID ;***************************************************** 1ST FIELD VALUE
* Y.CUS.ID ;***************************************************** 2ND FIELD VALUE

    IF R.CUSTOMER ELSE
        R.CUSTOMER = ''

        CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,ERR.CUS)

        Y.ACCT.OFFICER = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
    END

    Y.OPP.PRODUCT = R.CR.OPPORTUNITY<CR.OP.PRODUCT> ;*********************** 3RD FIELD VALUE

    R.DAO = ''

    CALL CACHE.READ(FN.DAO, Y.ACCT.OFFICER, R.DAO, ERR.DAO) ;*R22 Auto conversion

    IF R.DAO THEN
        Y.DAO.NAME = R.DAO<EB.DAO.NAME> ;********************************* 4TH FIELD VALUE
    END

    Y.SEGMENT = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.SEGMENTO.POS> ;************* 5TH FIELD VALUE
    Y.DIRECTION = R.CR.OPPORTUNITY<CR.OP.DIRECTION> ;*********************** 6TH FIELD VALUE
    Y.START.DATE = R.CR.OPPORTUNITY<CR.OP.START.DATE> ;*********************** 7TH FIELD VALUE
    Y.ENQ.DATE = R.CR.OPPORTUNITY<CR.OP.END.DATE> ;*********************** 8TH FIELD VALUE
    Y.DIRECTION = R.CR.OPPORTUNITY<CR.OP.DIRECTION> ;*********************** 9TH FIELD VALUE
    Y.OPP.STATUS = R.CR.OPPORTUNITY<CR.OP.OPPOR.STATUS>

    CALL F.READ(FN.CR.OPPORTUNITY.STATUS,Y.OPP.STATUS,R.CR.OPPORTUNITY.STATUS,F.CR.OPPORTUNITY.STATUS,ERR.OPP.STA)

    IF R.CR.OPPORTUNITY.STATUS<CR.OPS.DESC,2> EQ '' THEN
        Y.OPP.STATUS = R.CR.OPPORTUNITY.STATUS<CR.OPS.DESC,1> ;*********************** 10TH FIELD VALUE
    END ELSE
        Y.OPP.STATUS = R.CR.OPPORTUNITY.STATUS<CR.OPS.DESC,2> ;*********************** 10TH FIELD VALUE
    END

RETURN
*-------------------------------------------------------------------------
FORM.ARRAY:
*----------
    IF Y.ENQ.OUT EQ '' THEN

*VALUE NO : 1 2 3 4 5 6 7 8 9 10

        Y.ENQ.OUT = Y.LOG.ID:"*":Y.CUS.ID:"*":Y.OPP.PRODUCT:"*":Y.DAO.NAME:"*":Y.SEGMENT:"*":Y.DIRECTION:"*":Y.START.DATE:"*":Y.ENQ.DATE:"*":Y.DIRECTION:"*":Y.OPP.STATUS

    END ELSE

*VALUE NO : 1 2 3 4 5 6 7 8 9 10

        Y.ENQ.OUT<-1> = Y.LOG.ID:"*":Y.CUS.ID:"*":Y.OPP.PRODUCT:"*":Y.DAO.NAME:"*":Y.SEGMENT:"*":Y.DIRECTION:"*":Y.START.DATE:"*":Y.ENQ.DATE:"*":Y.DIRECTION:"*":Y.OPP.STATUS

    END

RETURN
*-------------------------------------------------------------------------
END
