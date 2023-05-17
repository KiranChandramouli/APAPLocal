SUBROUTINE REDO.AC.TUTOR
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AC.TUTOR
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
* 09.12.2010           Manju G            ODR-2010-12-0495           Initial Creation
* 05-02-2010           Prabhu N            N106 HD Issue             Routine modified to support when there is no relation
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_GTS.COMMON

    GOSUB INIT
    GOSUB PROCESS
RETURN
INIT:
********
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    APPL = ''; FIELD.NAMES = '';FIELD.POS = '' ;Y.SET.ERROR = 1 ; Y.REL.CT = 1
    APPL = 'CUSTOMER'
    FIELD.NAMES = 'L.CU.AGE'
    CALL MULTI.GET.LOC.REF(APPL,FIELD.NAMES,FIELD.POS)
    L.CU.AGE.POS = FIELD.POS<1,1>
RETURN
************
PROCESS:
*************
    IF APPLICATION EQ 'ACCOUNT' THEN
        Y.AC.CUSTOMER = R.NEW(AC.CUSTOMER)
        CALL F.READ(FN.CUSTOMER,Y.AC.CUSTOMER,R.CUSTOMER,F.CUSTOMER,ERR.CUST)
    END

    IF APPLICATION EQ 'AZ.ACCOUNT' THEN
        Y.AZ.CUSTOMER = R.NEW(AZ.CUSTOMER)
        CALL F.READ(FN.CUSTOMER,Y.AZ.CUSTOMER,R.CUSTOMER,F.CUSTOMER,ERR.CUST)
    END

    Y.L.CU.AGE = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.AGE.POS>
    IF Y.L.CU.AGE NE '' THEN
        IF Y.L.CU.AGE LT '14' THEN
            Y.RELATION.CODE = R.NEW(AC.RELATION.CODE)
            Y.RELATION.COUNT = DCOUNT(Y.RELATION.CODE,@VM)
            GOSUB CHECK.REL.CODE
            IF Y.SET.ERROR EQ 1 THEN
                GOSUB RISE.ERROR
            END
        END
    END
RETURN
***************
CHECK.REL.CODE:
***************
    IF Y.RELATION.COUNT THEN
        Y.REL.CT = 0
        LOOP
        WHILE Y.REL.CT LE Y.RELATION.COUNT
            Y.RELATION.CO = Y.RELATION.CODE<1,Y.REL.CT>
            IF Y.RELATION.CO GE '510' AND Y.RELATION.CO LE '529' THEN
                Y.REL.CT=Y.RELATION.COUNT
                Y.SET.ERROR=''
            END ELSE
                Y.SET.ERROR=1
            END
            Y.REL.CT += 1
        REPEAT
    END
RETURN
************
RISE.ERROR:
**************
    AF = AC.RELATION.CODE
    AV = Y.REL.CT
    ETEXT = 'EB-REDO.AC.TUTOR'
    CALL STORE.END.ERROR
RETURN
END
