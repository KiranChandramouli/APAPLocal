*-------------------------------------------------------------------------
* <Rating>-74</Rating>
*-------------------------------------------------------------------------
    SUBROUTINE REDO.NOFILE.CUST.JHOLDER(Y.OUT.ARRAY)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* display the field description of CUSTOMER instead of the ID
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 16-SEP-2011         RIYAS      ODR-2011-07-0162     Initial Creation
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RELATION
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY

    GOSUB INITIALSE
    GOSUB PROCESS

    RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~~
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HIS = ''
    CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)

    FN.RELATION = 'F.RELATION'
    F.RELATION  = ''
    CALL OPF(FN.RELATION,F.RELATION)

    FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'
    F.ALTERNATE.ACCOUNT = ''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

    FN.CATEGORY = "F.CATEGORY"
    F.CATEGORY = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    LOC.REF.APPLICATION="CUSTOMER":FM:"ACCOUNT"
    LOC.REF.FIELDS='L.CU.CIDENT':VM:'L.CU.NOUNICO':VM:'L.CU.ACTANAC':VM:'L.CU.RNC':FM:'L.SERIES.ID'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.CU.CIDENT=LOC.REF.POS<1,1>
    POS.L.CU.NOUNICO = LOC.REF.POS<1,2>
    POS.L.CU.ACTANAC = LOC.REF.POS<1,3>
    POS.L.CU.RNC = LOC.REF.POS<1,4>
    POS.L.AC.SERIES  = LOC.REF.POS<2,1> ;* PACS00238508 S/E

    RETURN
*----------------------------------------------------------------------------
PROCESS:
*~~~~~~~~~~
    Y.ACCOUNT      =  ''
    Y.CUSTOMER     =  ''
    Y.CEDULA       =  ''
    Y.INIT         =  ''
    Y.RELATION     =  ''
    Y.REL.CUST.ID  =  ''
    Y.CIDENT       =  ''
    Y.NOUNICO      =  ''
    Y.AC.OFF       =  ''

    LOCATE '@ID' IN D.FIELDS<1> SETTING Y.AC.POS THEN
        Y.ACCT.ID = D.RANGE.AND.VALUE<Y.AC.POS>
    END
    IF NOT(Y.ACCT.ID) THEN
        Y.OUT.ARRAY = ''
        RETURN
    END
    CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    IF NOT(R.ACCOUNT) THEN
        Y.ACCT.ID.HIS = Y.ACCT.ID
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HIS,Y.ACCT.ID.HIS,R.ACCOUNT,ERR.ACCT.HIS)
    END

    IF R.ACCOUNT THEN
        Y.CUS.ID     = R.ACCOUNT<AC.CUSTOMER>
        Y.AC.OFF     = R.ACCOUNT<AC.ACCOUNT.OFFICER>
        Y.SERIES     = R.ACCOUNT<AC.LOCAL.REF><1,POS.L.AC.SERIES>     ;* PACS00238508 - S
        Y.CAT.ID     = R.ACCOUNT<AC.CATEGORY>
        GOSUB GET.CATEG.DETS  ;* PACS00238508 - E
    END ELSE
        CALL F.READ(FN.ALTERNATE.ACCOUNT,Y.ACCT.ID,R.ALT.AC,F.ALTERNATE.ACCOUNT,ALT.ERR)
        IF R.ALT.AC THEN
            Y.ACCT.ID = R.ALT.AC
            CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
            Y.CUS.ID     = R.ACCOUNT<AC.CUSTOMER>
            Y.AC.OFF     = R.ACCOUNT<AC.ACCOUNT.OFFICER>
            Y.SERIES     = R.ACCOUNT<AC.LOCAL.REF><1,POS.L.AC.SERIES>
            Y.CAT.ID     = R.ACCOUNT<AC.CATEGORY>
            GOSUB GET.CATEG.DETS
        END ELSE
            Y.OUT.ARRAY = ''
            RETURN
        END
    END
    GOSUB READ.CUSTOMER
    Y.REL.CUST.ID  = Y.CUS.ID
    Y.RELATION     = ''
    Y.MAIN.FLAG = 1
    GOSUB GET.DETAILS
    Y.REL.CUS.LIST = R.ACCOUNT<AC.JOINT.HOLDER>
    Y.REL.LIST.CNT = DCOUNT(Y.REL.CUS.LIST,VM) + 1
    Y.INIT         = 2
    LOOP
        REMOVE Y.CUS.ID FROM Y.REL.CUS.LIST SETTING CUS.POS
    WHILE Y.INIT LE Y.REL.LIST.CNT
        Y.MAIN.FLAG = ''
        GOSUB GET.DETAILS
        Y.INIT++
    REPEAT
    Y.OUT.ARRAY = Y.ACCT.ID:'*':Y.REL.CUST.ID:'*':Y.CUST.DOC:'*':Y.CUSTOMER.NAME:'*':Y.RELATION:'*':Y.AC.OFF:'*':Y.SERIES:'*':Y.CAT.DESC
    RETURN

GET.DETAILS:
    IF NOT(Y.MAIN.FLAG) THEN
        Y.RELATION.ID              = R.ACCOUNT<AC.RELATION.CODE,(Y.INIT-1)>
        GOSUB READ.RELATION
        Y.RELATION<1,Y.INIT>       = Y.REL.NAME
        Y.REL.CUST.ID<1,Y.INIT>    = R.ACCOUNT<AC.JOINT.HOLDER,(Y.INIT-1)>
        GOSUB READ.CUSTOMER
    END
    Y.CIDENT         = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.CIDENT>
    Y.NOUNICO        = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.NOUNICO>
    Y.ACTANAC        = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.ACTANAC>
    Y.RNC            = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.RNC>
    Y.LEGAL.ID       = R.CUSTOMER<EB.CUS.LEGAL.ID>
    GOSUB CASE.DOCUMENT
    Y.CUST.DOC<1,Y.INIT>       = Y.CUS.ID
    Y.CUSTOMER.NAME<1,Y.INIT>  = R.CUSTOMER<EB.CUS.NAME.1>

    RETURN
*-------------------------------------------------------------------------
GET.CATEG.DETS:
*-------------------------------------------------------------------------
    R.CATEG = "" ; CATEG.ERR = ""
    CALL F.READ(FN.CATEGORY,Y.CAT.ID,R.CATEG,F.CATEGORY,CATEG.ERR)
    Y.CAT.DESC=R.CATEG<EB.CAT.DESCRIPTION>
    RETURN
*-------------------------------------------------------------------------
CASE.DOCUMENT:
*-------------------------------------------------------------------------
    BEGIN CASE
    CASE Y.CIDENT NE ''
        Y.CUS.ID = Y.CIDENT
    CASE Y.NOUNICO NE ''
        Y.CUS.ID = Y.NOUNICO
    CASE Y.ACTANAC NE ''
        Y.CUS.ID = Y.ACTANAC
    CASE Y.RNC NE ''
        Y.CUS.ID = Y.RNC
    CASE Y.LEGAL.ID NE ''
        Y.CUS.ID = Y.LEGAL.ID
    CASE 1
        Y.CUS.ID = ''
    END CASE
    RETURN
*-------------------------------------------------------------------------
READ.CUSTOMER:
    R.CUSTOMER = ''
    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,LOOKUP.ERR)
    RETURN
*-------------------------------------------------------------------------
READ.RELATION:
    R.RELATION  = ''
    CALL F.READ(FN.RELATION,Y.RELATION.ID,R.RELATION,F.RELATION,REL.ERR)
    Y.REL.NAME = R.RELATION<EB.REL.DESCRIPTION>
    RETURN
END
