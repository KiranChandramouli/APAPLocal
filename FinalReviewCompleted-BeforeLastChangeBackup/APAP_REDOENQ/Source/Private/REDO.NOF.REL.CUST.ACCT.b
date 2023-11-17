$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.REL.CUST.ACCT(Y.ENQ.OUT)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.NOF.REL.CUST.ACCT
*--------------------------------------------------------------------------------------------------------
*Description       :
*
*Linked With       : ACCOUNT VERSION
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : ACCOUNT
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*  Date                 Who                  Reference                 Description
*  ------               -----               -------------              -------------
* 09.12.2010           Manju G          ODR-2010-12-0495          Initial Creation
* 12.12.2010           Janani           ODR-2010-12-0495           Initial Creation
* 01-06-2011           Jeeva T          ODR-2010-12-0495           Fix for PACS00078875
* 08-11-2012           Marimuthu S      PACS00232596
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM 
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ALTERNATE.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------------*
INIT:
********
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.CUST.ACCT = 'F.CUSTOMER.ACCOUNT'
    F.CUST.ACCT = ''
    CALL OPF(FN.CUST.ACCT,F.CUST.ACCT)

    FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'
    F.ALTERNATE.ACCOUNT = ''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

    APPL = ''; FIELD.NAMES = '';FIELD.POS = ''
    APPL = 'CUSTOMER'
    FIELD.NAMES = 'L.CU.TIPO.CL'
    CALL MULTI.GET.LOC.REF(APPL,FIELD.NAMES,FIELD.POS)
    L.CU.TIPO.POS = FIELD.POS<1,1>

RETURN
*------------------------------------------------------------------------------------*
PROCESS:
*************


    LOCATE "CUSTOMER" IN D.FIELDS<1> SETTING CUS.POS THEN
        Y.CUS.ID = D.RANGE.AND.VALUE<CUS.POS>
        Y.CUS = 'Y'
    END

    LOCATE "ACCOUNT.NO" IN D.FIELDS<1> SETTING ACCT.POS THEN
        Y.AC = D.RANGE.AND.VALUE<ACCT.POS>
        CALL F.READ(FN.ACCOUNT,Y.AC,R.ACCOUNT,F.ACCOUNT,AC.ERRR)
        IF NOT(R.ACCOUNT) THEN
            CALL F.READ(FN.ALTERNATE.ACCOUNT,Y.AC,R.ALT.AC,F.ALTERNATE.ACCOUNT,ALT.ERR)
            IF R.ALT.AC THEN
                Y.AC = R.ALT.AC<AAC.GLOBUS.ACCT.NUMBER>
            END
        END
        Y.AC.SET = 'Y'
    END

    BEGIN CASE

        CASE Y.CUS EQ 'Y' AND Y.AC.SET EQ 'Y'
            CALL F.READ(FN.CUST.ACCT,Y.CUS.ID,R.CUST.ACCT,F.CUST.ACCT,CUS.AC.ERR)
            GOSUB CUS.AC.Y

        CASE Y.CUS EQ 'Y' AND Y.AC.SET EQ ''
            CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
            GOSUB CHECK.TUTOR
            IF Y.TUT EQ 'Y' THEN
                GOSUB GET.CUS.DET
                Y.DISP.CU.NAME.DUP = Y.DISP.CU.NAME
                GOSUB GET.REL.CUST.DET
                CALL F.READ(FN.CUST.ACCT,Y.CUS.ID,R.CUST.ACCT,F.CUST.ACCT,CU.AC.ERR)
                GOSUB GET.CUST.ACCTS

            END

        CASE Y.CUS EQ '' AND Y.AC.SET EQ 'Y'
            CALL F.READ(FN.ACCOUNT,Y.AC,R.ACC,F.ACCOUNT,AC.ERR)
            IF R.ACC THEN
                GOSUB CUS.AC.N
            END ELSE
                ENQ.ERROR = 'EB-ACCOUNT.NOT.EXIST'
            END

        CASE Y.CUS EQ '' AND Y.AC.SET EQ ''
            ENQ.ERROR = 'EB-CUST.OR.ACCT.INPUT'

    END CASE

RETURN

CUS.AC.Y:

    LOCATE Y.AC IN R.CUST.ACCT SETTING POS.AC THEN
        R.CUSTOMER = ''
        CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
        GOSUB CHECK.TUTOR
        IF Y.TUT EQ 'Y' THEN
            GOSUB GET.CUS.DET
            Y.DISP.CU.NAME.DUP = Y.DISP.CU.NAME
            GOSUB GET.REL.CUST.DET
            GOSUB GET.ACCTS
        END
    END ELSE
        ENQ.ERROR = 'EB-AC.NOT.BELONG.TO.CUST'
    END

RETURN

CUS.AC.N:

    Y.CUS.ID = R.ACC<AC.CUSTOMER>
    R.CUSTOMER = ''
    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    GOSUB CHECK.TUTOR
    IF Y.TUT EQ 'Y' THEN
        GOSUB GET.CUS.DET
        Y.DISP.CU.NAME.DUP = Y.DISP.CU.NAME
        GOSUB GET.REL.CUST.DET
        Y.AC.ID = Y.AC
        GOSUB GET.ACCTS
    END

RETURN

CHECK.TUTOR:

    Y.REL.CODES = R.CUSTOMER<EB.CUS.RELATION.CODE> ; Y.REL.CUSS = ''
    Y.REL.CNT = DCOUNT(Y.REL.CODES,@VM)
    FLG = ''
    LOOP
    WHILE Y.REL.CNT GT 0 DO
        FLG += 1
        Y.REL.CDE = Y.REL.CODES<1,FLG>
        IF ((Y.REL.CDE GE 510 AND Y.REL.CDE LE 529) OR Y.REL.CDE EQ 13 ) THEN
            Y.TUT = 'Y'
            Y.REL.CUSS<-1> = R.CUSTOMER<EB.CUS.REL.CUSTOMER,FLG>
        END
        Y.REL.CNT -= 1
    REPEAT

RETURN

GET.CUS.DET:

    Y.DISP.CU.NAME = ''
    Y.CUST.FISICA = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.POS>
    IF Y.CUST.FISICA EQ "PERSONA FISICA" OR Y.CUST.FISICA EQ 'CLIENTE MENOR' THEN
        Y.DISP.CU.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END ELSE
        IF Y.CUST.FISICA EQ "PERSONA JURIDICA" THEN
            Y.DISP.CU.NAME  = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
        END
    END

RETURN

GET.REL.CUST.DET:

    Y.REL.CUS.CNT = DCOUNT(Y.REL.CUSS,@FM)
    FLG.RR = ''
    LOOP
    WHILE Y.REL.CUS.CNT GT 0 DO
        FLG.RR += 1
        Y.REL.CSS = Y.REL.CUSS<FLG.RR>
        R.CUSTOMER = ''
        CALL F.READ(FN.CUSTOMER,Y.REL.CSS,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
        GOSUB GET.CUS.DET
        Y.REL.CUSTOMER<1,-1> = Y.REL.CSS
        Y.CUST.REL.NAME<1,-1> = Y.DISP.CU.NAME
        Y.REL.CUS.CNT -= 1
    REPEAT

RETURN

GET.CUST.ACCTS:

    Y.CU.AC.CNT = DCOUNT(R.CUST.ACCT,@FM) ; FLG.AC.C = ''
    LOOP
    WHILE Y.CU.AC.CNT GT 0 DO
        FLG.AC.C += 1
        Y.AC.ID = R.CUST.ACCT<FLG.AC.C>
        GOSUB GET.ACCTS
        Y.CU.AC.CNT -= 1
    REPEAT

RETURN

GET.ACCTS:

    R.ACC = ''
    CALL F.READ(FN.ACCOUNT,Y.AC.ID,R.ACC,F.ACCOUNT,ACC.ERR)

    Y.RELA.CODE = R.ACC<AC.RELATION.CODE>
    Y.RELA.CODE = CHANGE(Y.RELA.CODE,@SM,@VM)
    Y.REL.CNT = DCOUNT(Y.RELA.CODE,@VM)
    FLG = '' ; FLG.SET = ''
    LOOP
    WHILE Y.REL.CNT GT 0 DO
        FLG += 1
        Y.REALA.CODE = Y.RELA.CODE<1,FLG>
        IF Y.REALA.CODE GE 510 AND Y.REALA.CODE LE 529 THEN
            FLG.SET = 1
            Y.REL.CNT = 0
        END
    REPEAT

    IF FLG.SET EQ 1 THEN
        GOSUB GET.ACCT.JOINT

        Y.ENQ.OUT<-1> = Y.CUS.ID:'*':Y.DISP.CU.NAME.DUP:'*':Y.REL.CUSTOMER:'*':Y.CUST.REL.NAME:'*'
        Y.ENQ.OUT:= Y.AC.ID:'*':Y.JOINT:'*':Y.DISP.JOINT.NAME
        Y.CUST = '' ; Y.CUST.NAME = ''; Y.REL.CUSTOMER = '' ; Y.CUST.REL.NAME = ''
    END

RETURN

GET.ACCT.JOINT:

    Y.JOINT = '' ; Y.DISP.JOINT.NAME = ''
    Y.JOINT.HOLDERS = R.ACC<AC.JOINT.HOLDER>
    Y.RELATION.CODES =  R.ACC<AC.RELATION.CODE>
    Y.REL.CT = DCOUNT(Y.RELATION.CODES,@VM)
    Y.CT.RELATION = 1

    LOOP
    WHILE Y.CT.RELATION LE Y.REL.CT
        Y.REL.CODE = Y.RELATION.CODES<1,Y.CT.RELATION>
        IF Y.REL.CODE GE 510 AND Y.REL.CODE LE 529 THEN
            Y.JOINT.AC = Y.JOINT.HOLDERS<1,Y.CT.RELATION>
            Y.DISP.JOINT.NAME = ''
            GOSUB JOINT.NAMES
        END
        Y.CT.RELATION += 1
    REPEAT

RETURN

JOINT.NAMES:

    CALL F.READ(FN.CUSTOMER,Y.JOINT.AC,R.CUST.JOINT,F.CUSTOMER,CUSTOMER.ERR)
    Y.JOINT<1,-1> = Y.JOINT.AC

    IF R.CUST.JOINT<EB.CUS.LOCAL.REF,L.CU.TIPO.POS> EQ "PERSONA FISICA" OR R.CUST.JOINT<EB.CUS.LOCAL.REF,L.CU.TIPO.POS> EQ 'CLIENTE MENOR' THEN
        Y.DISP.JOINT.NAME<1,-1> = R.CUST.JOINT<EB.CUS.GIVEN.NAMES>:" ":R.CUST.JOINT<EB.CUS.FAMILY.NAME>
    END ELSE
        IF R.CUST.JOINT<EB.CUS.LOCAL.REF,L.CU.TIPO.POS> EQ "PERSONA JURIDICA" THEN
            Y.DISP.JOINT.NAME<1,-1>  = R.CUST.JOINT<EB.CUS.NAME.1,1>:" ":R.CUST.JOINT<EB.CUS.NAME.2,1>
        END
    END

RETURN
*******
END
