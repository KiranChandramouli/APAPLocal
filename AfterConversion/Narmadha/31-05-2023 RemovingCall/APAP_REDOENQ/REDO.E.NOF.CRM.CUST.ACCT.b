* @ValidationCode : MjotMTc2OTQ5MDgyMjpVVEYtODoxNjg1NTMxODI5MjA5OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 16:47:09
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
SUBROUTINE REDO.E.NOF.CRM.CUST.ACCT(Y.FINAL.ARR)
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This nofile routine is used to select all the products related to the custoimer
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Pradeep S
* PROGRAM NAME : REDO.E.NOF.CRM.CUST.ACCT
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 19.05.2011      Pradeep S           PACS00060849      INITIAL CREATION
* 12-APRIL-2023      Harsha                R22 Auto Conversion  - FM to @FM and VM to @VM
* 12-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn formate modified
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.RELATION.CUSTOMER
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_F.REDO.ISSUE.COMPLAINTS
    $INSERT I_F.REDO.ISSUE.REQUESTS
    $INSERT I_F.REDO.CLAIM.STATUS.MAP
    $INSERT I_F.REDO.U.CRM.PRODUCT.TYPE
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
    $USING APAP.TAM
    $USING APAP.REDOSRTN

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
******
    FN.REDO.PDT.TYPE = 'F.REDO.U.CRM.PRODUCT.TYPE'
    F.REDO.PDT.TYPE = ''
    CALL OPF(FN.REDO.PDT.TYPE,F.REDO.PDT.TYPE)

    FN.CUS.ACCT = 'F.CUSTOMER.ACCOUNT'
    F.CUS.ACCT = ''
    CALL OPF(FN.CUS.ACCT,F.CUS.ACCT)

    FN.CUS = 'F.CUSTOMER'
    F.CUS = ''
    CALL OPF(FN.CUS,F.CUS)

    FN.REL.CUS = 'F.RELATION.CUSTOMER'
    F.REL.CUS = ''
    CALL OPF(FN.REL.CUS,F.REL.CUS)

    FN.ACCT = 'F.ACCOUNT'
    F.ACCT = ''
    CALL OPF(FN.ACCT,F.ACCT)

    FN.AZ.CUS = 'F.AZ.CUSTOMER'
    F.AZ.CUS = ''
    CALL OPF(FN.AZ.CUS,F.AZ.CUS)

    FN.AA.CUS = 'F.REDO.CUSTOMER.ARRANGEMENT'
    F.AA.CUS = ''
    CALL OPF(FN.AA.CUS,F.AA.CUS)

    FN.JOINT.CONTRACTS.XREF = 'F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF = ''
    CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

    Y.FINAL.ARR = ''

RETURN

PROCESS:
*********

    LOCATE "CUST.ID" IN D.FIELDS SETTING CUS.POS THEN
        Y.CUST.ID = D.RANGE.AND.VALUE<CUS.POS>
        CUST.ID = Y.CUST.ID
        CUST.NO = ''
        CUST.ERR = ''
        APAP.REDOSRTN.redoSCustIdVal(CUST.ID,CUST.NO,CUST.ERR);*R22 Manual Conversion
        Y.CUST.ID = CUST.NO
    END

    Y.PRODUCT.TYPE = R.NEW(ISS.REQ.PRODUCT.TYPE)
* Y.CUST.ID = R.NEW(ISS.REQ.CUSTOMER.CODE)

    R.CUS = ""
    CALL F.READ(FN.CUS,Y.CUST.ID,R.CUS,F.CUS,ERR.CUS)
    Y.REV.REL.CODE = R.CUS<EB.CUS.REVERS.REL.CODE>

    GOSUB READ.PRDT.TYPE

    IF R.PRDT.TYPE AND Y.CUST.ID THEN

        BEGIN CASE

            CASE Y.PRODUCT.TYPE MATCHES 'CUENTA.DE.AHORROS':@VM:'CUENTA.CORRIENTE'
                GOSUB SAVINGS.CURRENT.ACCOUNT

            CASE Y.PRODUCT.TYPE EQ 'CERTIFICADOS'
                GOSUB AZ.DEPOSITS

            CASE Y.PRODUCT.TYPE EQ 'PRESTAMOS'
                GOSUB AA.LOANS

        END CASE

    END

RETURN

READ.PRDT.TYPE:
***************
    R.PRDT.TYPE = ''
    CALL F.READ(FN.REDO.PDT.TYPE,Y.PRODUCT.TYPE,R.PRDT.TYPE,F.REDO.PDT.TYPE,ERR.PRDT)

    Y.FROM.CATEG = R.PRDT.TYPE<PRD.TYPE.PRD.CATEG.FROM>
    Y.TO.CATEG = R.PRDT.TYPE<PRD.TYPE.PRD.CATEG.TO>
    Y.FROM.REL = R.PRDT.TYPE<PRD.TYPE.REL.CODE.FROM>
    Y.TO.REL = R.PRDT.TYPE<PRD.TYPE.REL.CODE.TO>
    Y.LOAN.ROLES = R.PRDT.TYPE<PRD.TYPE.REL.CODE.TO>

RETURN

READ.DEPO.PRDT.TYPE:
*********************

    Y.PRODUCT.TYPE = "CERTIFICADOS"
    R.DEPO.PRDT.TYPE = ''
    CALL F.READ(FN.REDO.PDT.TYPE,Y.PRODUCT.TYPE,R.PRDT.TYPE,F.REDO.PDT.TYPE,ERR.PRDT)

    Y.DEPO.FROM.CATEG = R.PRDT.TYPE<PRD.TYPE.PRD.CATEG.FROM>
    Y.DEPO.TO.CATEG = R.PRDT.TYPE<PRD.TYPE.PRD.CATEG.TO>

RETURN

SAVINGS.CURRENT.ACCOUNT:
*************************

    GOSUB READ.DEPO.PRDT.TYPE

    R.CUST.ACC = ''
    CALL F.READ(FN.CUS.ACCT,Y.CUST.ID,R.CUST.ACC,F.CUS.ACCT,ERR.CUST.ACCT)
    Y.ACCT.LIST = R.CUST.ACC

    GOSUB CHECK.ACCT.CATEG

    R.JOIN.CUS = ''
    CALL F.READ(FN.JOINT.CONTRACTS.XREF,Y.CUST.ID,R.JOIN.CUS,F.JOINT.CONTRACTS.XREF,ERR.JOIN)

    GOSUB CHECK.REL.CUS

RETURN

CHECK.ACCT.CATEG:
******************
    Y.AC.CNT = DCOUNT(Y.ACCT.LIST,@FM)
    LOOP
        REMOVE Y.AC.ID FROM Y.ACCT.LIST SETTING Y.AC.POS
    WHILE Y.AC.ID:Y.AC.POS
        GOSUB READ.ACCT
    REPEAT

RETURN

READ.ACCT:
***********

    R.ACCT = ''
    CALL F.READ(FN.ACCT,Y.AC.ID,R.ACCT,F.ACCT,AC.ERR)
    IF R.ACCT THEN
        Y.AC.CATEG = R.ACCT<AC.CATEGORY>
        IF (Y.AC.CATEG GE Y.FROM.CATEG AND Y.AC.CATEG LE Y.TO.CATEG) AND (Y.AC.CATEG LT Y.DEPO.FROM.CATEG OR Y.AC.CATEG GT Y.DEPO.TO.CATEG) THEN
            Y.FINAL.ARR<-1> = Y.AC.ID
        END
    END

RETURN

CHECK.REL.CUS:
***************

    Y.JOIN.CUS = DCOUNT(R.JOIN.CUS,@FM)
    LOOP
        REMOVE Y.JOINT.ACC FROM R.JOIN.CUS SETTING JOIN.POS
    WHILE Y.JOINT.ACC:JOIN.POS
        R.ACCT = ''
        CALL F.READ(FN.ACCT,Y.JOINT.ACC,R.ACCT,F.ACCT,AC.ERR)
        IF R.ACCT THEN
            Y.AC.CATEG = R.ACCT<AC.CATEGORY>
            Y.REL.CUS = R.ACCT<AC.JOINT.HOLDER>
            Y.REL.CODE = R.ACCT<AC.RELATION.CODE>
            GOSUB CHECK.CATEG.REL
        END
    REPEAT

RETURN

CHECK.CATEG.REL:
*****************

    LOCATE Y.CUST.ID IN Y.REL.CUS<1,1> SETTING REL.POS THEN
        Y.REV.REL.CODE = Y.REL.CODE<1,REL.POS>
        IF Y.REV.REL.CODE GE Y.FROM.REL AND Y.REV.REL.CODE LE Y.TO.REL THEN
            IF (Y.AC.CATEG GE Y.FROM.CATEG AND Y.AC.CATEG LE Y.TO.CATEG) AND (Y.AC.CATEG LT Y.DEPO.FROM.CATEG OR Y.AC.CATEG GT Y.DEPO.TO.CATEG) THEN
                Y.FINAL.ARR<-1> = Y.JOINT.ACC
            END

        END
    END

RETURN

AZ.DEPOSITS:
*************

    R.AZ.ACCT = ''
    CALL F.READ(FN.AZ.CUS,Y.CUST.ID,R.AZ.ACCT,F.AZ.CUS,ERR.AZ.CUS)
    Y.ACCT.LIST = R.AZ.ACCT
    GOSUB CHECK.ACCT.CATEG

RETURN

AA.LOANS:
**********

    R.AA.CUS = ''
    CALL F.READ(FN.AA.CUS,Y.CUST.ID,R.AA.CUS,F.AA.CUS,ERR.AA)
    IF R.AA.CUS THEN
        Y.OWN.LOAN = R.AA.CUS<CUS.ARR.OWNER>
        CHANGE @VM TO @FM IN Y.OWN.LOAN
        Y.AA.OWN.LIST = Y.OWN.LOAN

        Y.REL.LOAN = R.AA.CUS<CUS.ARR.OTHER.PARTY>
        CHANGE @VM TO @FM IN Y.REL.LOAN

        Y.AA.OWN.LIST = Y.AA.OWN.LIST:@FM:Y.REL.LOAN

        GOSUB CHECK.OWN.LOAN

    END

RETURN

CHECK.OWN.LOAN:
****************

    LOOP
        REMOVE Y.AA.ID FROM Y.AA.OWN.LIST SETTING AA.POS
    WHILE Y.AA.ID:AA.POS

        GOSUB CHECK.AA.CATEG

    REPEAT

RETURN

CHECK.AA.CATEG:
*****************

    Y.ARR.ID = Y.AA.ID
    EFF.DATE = ''
    PROP.CLASS='ACCOUNT'
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
    APAP.TAM.redoCrrGetConditions(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG);*R22 Manual Conversion

    Y.AA.CATEG = R.CONDITION<AA.AC.CATEGORY>

    Y.FINAL.ARR<-1> = R.CONDITION<AA.AC.ACCOUNT.REFERENCE>

RETURN

END
