SUBROUTINE REDO.E.CONV.GET.ACCT.NAME
******************************************************************************************
*Modification Details:
*=====================
*      Date            Who                   Reference                           Description
*     ------           -----                -------------                        -------------
* 23 SEP 2010         MD Preethi           ODR-2010-03-131 REPORT16                    Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.RELATION
*
    GOSUB OPENFILES
    GOSUB GET.LOCAL.REF
    GOSUB PROCESS
RETURN
***********************************************************************************************************
* DESCRIPTION: In the conversion routine the Account holder name has to be fetched based on the relation code
************************************************************************************************************
**********
OPENFILES:
**********
    Y.ACCOUNT.NAME = ''
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    FN.RELATION ='F.RELATION'
    F.RELATION=''
    Y.CUS.NAME=''
    Y.AC.ID=''
    Y.CUS.NAMES=''

    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.RELATION,F.RELATION)
RETURN
**************
GET.LOCAL.REF:
**************
    APPL.ARRAY = 'CUSTOMER'
    FLD.ARRAY = 'L.CU.TIPO.CL'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CU.TIPO.CL.POS =  FLD.POS<1,1>

RETURN
*********
PROCESS:
*********

    Y.AC.ID = O.DATA
    CALL F.READ(FN.ACCOUNT,Y.AC.ID,R.ACCOUNT,F.ACCOUNT,Y.ERR)
    Y.CUSTOMER.ID   = R.ACCOUNT<AC.CUSTOMER>
    Y.RELATION.CODE  = R.ACCOUNT<AC.RELATION.CODE>
    Y.RELATION.COUNT = DCOUNT(Y.RELATION.CODE,@VM)

    IF Y.RELATION.CODE EQ '' THEN
        CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
            Y.ACCOUNT.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
        END
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
            Y.ACCOUNT.NAME = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
        END
        IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
            Y.ACCOUNT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
        END
        O.DATA = Y.ACCOUNT.NAME
    END

    Y.COUNT = 1
    LOOP
    WHILE Y.COUNT LE Y.RELATION.COUNT

        Y.RELATION.ID = R.ACCOUNT<AC.RELATION.CODE,Y.COUNT>

        IF Y.RELATION.ID GE 500 AND Y.RELATION.ID LE 529 THEN
            CALL F.READ(FN.RELATION,Y.RELATION.ID,R.RELATION,F.RELATION,Y.REL.ERR)
            Y.REL.DESC = R.RELATION<EB.REL.DESCRIPTION,1>
            Y.JOINT.CUSTOMER.ID = R.ACCOUNT<AC.JOINT.HOLDER,Y.COUNT>
            CALL F.READ(FN.CUSTOMER,Y.JOINT.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
            Y.JOINTHOLDER.NAME= R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>

            IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
                Y.JOINT.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
            END
            IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
                Y.JOINT.NAME = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
            END
            IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
                Y.JOINT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
            END
            Y.ACCOUNT.NAME<-1> = Y.REL.DESC:' ':Y.JOINT.NAME
            O.DATA = Y.ACCOUNT.NAME
        END
        Y.COUNT += 1

    REPEAT

RETURN
END
