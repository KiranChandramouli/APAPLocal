SUBROUTINE REDO.E.CNV.DS.BENF.NAMES(Y.ACCOUNT.NO)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CNV.DS.BENF.NAMES
*--------------------------------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display Owner and Beneficiary(joint holder) customer names of deposit
*Linked With  :
*In Parameter : NA
*Out Parameter: Y.ACCOUNT.NO

*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference             Description
*   ------         ------               -------------           -------------
* 25 Aug 2010    Mohammed Anies K       ODR-2009-10-0346        Initial Creation
* 10 NOV 2011    Sudharsanan S          CR.18                   Modify the code to display customer id number.
* 18 FEB 2014    Vignesh Kumaar R       PACS00261598            Removed the blank spaces
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.RELATION

*--------------------------------------------------------------------------------------------------------
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN
*--------------------------------------------------------------------------------------------------------
*********
OPEN.PARA:
*********
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.RELATION = 'F.RELATION'
    F.RELATION = ''
    CALL OPF(FN.RELATION,F.RELATION)

RETURN
*--------------------------------------------------------------------------------------------------------
************
PROCESS.PARA:
************

    GOSUB FIND.MULTI.LOCAL.REF
    Y.ACCOUNT.ID = ID.NEW
    GOSUB READ.ACCOUNT
    Y.CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
    GOSUB READ.CUSTOMER
    GOSUB CHECK.L.CU.TIPO.CL

    Y.REL.COUNT = DCOUNT(Y.REL.CODE,@VM)
    Y.REL.NO = 1
    LOOP
    WHILE Y.REL.NO LE Y.REL.COUNT
        Y.RELATION.CODE = R.ACCOUNT<AC.RELATION.CODE,Y.REL.NO>
        IF Y.RELATION.CODE GE 500 AND Y.RELATION.CODE LE 529 THEN
            Y.CUSTOMER.ID = R.ACCOUNT<AC.JOINT.HOLDER,Y.REL.NO>
            GOSUB READ.CUSTOMER
            GOSUB READ.RELATION
            Y.REL = R.RELATION<EB.REL.DESCRIPTION,1>
            Y.REL.DESC = FMT(Y.REL,"L#25")
            GOSUB CHECK.L.CU.TIPO.CL.FOR.JOINT.HOLDERS
        END
        Y.REL.NO +=1
    REPEAT
*    CHANGE FM TO VM IN Y.CUS.NAMES
*    VM.COUNT = DCOUNT(Y.CUS.NAMES,VM)
*    Y.ACCOUNT.NO = Y.CUS.NAMES<VC>

    IF Y.ACCOUNT.NO EQ 'DEP.NAME.1' THEN
        Y.ACCOUNT.NO = Y.CUS.NAMES<1>
    END

    IF Y.ACCOUNT.NO EQ 'DEP.NAME.2' THEN
        Y.ACCOUNT.NO = Y.CUS.NAMES<2>
    END

    IF Y.ACCOUNT.NO EQ 'DEP.NAME.3' THEN
        Y.ACCOUNT.NO = Y.CUS.NAMES<3>
    END


RETURN
*--------------------------------------------------------------------------------------------------------
******************
CHECK.L.CU.TIPO.CL:
******************
    Y.CUSTOMER = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL>
    VAR.NAME.FIS = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    VAR.NAME.JUR =  R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
    IF Y.CUSTOMER EQ "PERSONA FISICA" THEN
        GOSUB FIS.TYPE.ID
        Y.CUS.NAMES = FMT(VAR.NAME.FIS,"L#45"):FMT(ID_CARD,"L#25")
        RETURN
    END
    IF Y.CUSTOMER EQ "CLIENTE MENOR" THEN
        GOSUB CL.MENOR.TYPE.ID
        Y.CUS.NAMES = FMT(VAR.NAME.FIS,"L#45"):FMT(ID_CARD,"L#25")
        RETURN
    END
    IF Y.CUSTOMER EQ "PERSONA JURIDICA" THEN
        GOSUB JUR.TYPE.ID
        Y.CUS.NAMES = FMT(VAR.NAME.JUR,"L#45"):FMT(ID_CARD,"L#25")
        RETURN
    END
RETURN
*--------------------------------------------------------------------------------------------------------
***********************************
CHECK.L.CU.TIPO.CL.FOR.JOINT.HOLDERS:
***********************************
    Y.CUSTOMER= R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL>
    VAR.NAME.FIS.REL  = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    VAR.NAME.JUR.REL = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
    IF Y.CUSTOMER EQ "PERSONA FISICA" THEN
        GOSUB FIS.TYPE.ID
        Y.CUS.NAMES :=" ":Y.REL.DESC        ;* Fix for PACS00261598 [removed the blank spaces]
        Y.CUS.NAMES<-1> :=FMT(VAR.NAME.FIS.REL,"L#45"):FMT(ID_CARD,"L#25")
        RETURN
    END
    IF Y.CUSTOMER EQ "CLIENTE MENOR" THEN
        GOSUB CL.MENOR.TYPE.ID
        Y.CUS.NAMES :=" ":Y.REL.DESC        ;* Fix for PACS00261598 [removed the blank spaces]
        Y.CUS.NAMES<-1> :=FMT(VAR.NAME.FIS.REL,"L#45"):FMT(ID_CARD,"L#25")
        RETURN
    END
    IF Y.CUSTOMER EQ "PERSONA JURIDICA" THEN
        GOSUB JUR.TYPE.ID
        Y.CUS.NAMES :=" ":Y.REL.DESC        ;* Fix for PACS00261598 [removed the blank spaces]
        Y.CUS.NAMES<-1> := FMT(VAR.NAME.JUR.REL,"L#45"):FMT(ID_CARD,"L#25")
        RETURN
    END
RETURN
*--------------------------------------------------------------------------------------------------------
********************
FIND.MULTI.LOCAL.REF:
********************
    APPL.ARRAY = 'CUSTOMER'
    FLD.ARRAY = 'L.CU.TIPO.CL':@VM:'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.ACTANAC':@VM:'L.CU.NOUNICO'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CU.TIPO.CL = FLD.POS<1,1>
    CIDENT.POS = FLD.POS<1,2>
    RNC.POS = FLD.POS<1,3>
    ACTANAC.POS = FLD.POS<1,4>
    NOUNICO.POS = FLD.POS<1,5>

RETURN
*--------------------------------------------------------------------------------------------------------
************
READ.ACCOUNT:
************
    R.ACCOUNT = ''
    ACCOUNT.ERR = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    Y.REL.CODE = R.ACCOUNT<AC.RELATION.CODE>

RETURN
*--------------------------------------------------------------------------------------------------------
************
READ.CUSTOMER:
************
    R.CUSTOMER = ''
    CUSTOMER.ERR =''
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)

RETURN
*--------------------------------------------------------------------------------------------------------
************
READ.RELATION:
************
    R.RELATION =''
    RELATION.ERR = ''
    CALL F.READ(FN.RELATION,Y.RELATION.CODE,R.RELATION,F.RELATION,RELATION.ERR)

RETURN
*--------------------------------------------------------------------------------------------------------
FIS.TYPE.ID:
*--------------------------------------------------------------------------------------------------------
    CIDENT.VALUE = R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS>
    IF CIDENT.VALUE THEN
        ID_CARD = CIDENT.VALUE
    END ELSE
        ID_CARD = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    END
RETURN
*--------------------------------------------------------------------------------------------------------
CL.MENOR.TYPE.ID:
*--------------------------------------------------------------------------------------------------------
    CIDENT.VALUE  =  R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS>
    IF CIDENT.VALUE THEN
        ID_CARD = CIDENT.VALUE
        FLAG.ID = 1
    END
    IF NOT(FLAG.ID) THEN
        LEGALID.VALUE = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
        IF LEGALID.VALUE THEN
            ID_CARD = LEGALID.VALUE
            FLAG.ID = 1
        END
    END
    IF NOT(FLAG.ID) THEN
        ACTANAC.VALUE = R.CUSTOMER<EB.CUS.LOCAL.REF,ACTANAC.POS>
        IF ACTANAC.VALUE THEN
            ID_CARD = ACTANAC.VALUE
            FLAG.ID = 1
        END
    END
    IF NOT(FLAG.ID) THEN
        NOUNICO.VALUE = R.CUSTOMER<EB.CUS.LOCAL.REF,NOUNICO.POS>
        IF NOUNICO.VALUE THEN
            ID_CARD = NOUNICO.VALUE
            FLAG.ID = 1
        END
    END
RETURN
*--------------------------------------------------------------------------------------------------------
JUR.TYPE.ID:
*--------------------------------------------------------------------------------------------------------
    ID_CARD = R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS>
RETURN
*---------------------------------------------------------------------------------------------------------
END
