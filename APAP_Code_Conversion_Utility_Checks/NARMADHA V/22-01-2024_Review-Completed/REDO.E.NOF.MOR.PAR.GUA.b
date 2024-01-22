* @ValidationCode : MjotMTI4ODI0Mzg4MjpVVEYtODoxNzA1OTE3MjU3MTAwOkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 22 Jan 2024 15:24:17
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
****------------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.E.NOF.MOR.PAR.GUA(Y.FINAL.ARRAY)
*----------------------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.NOF.MOR.PAR.GUA
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.E.NOF.MOR.PAR.GUA is the Nofile Routine for the Enquiry REDO.APAP.NOF.MOR.PAR.GUR
*
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-------------------------------------------------------------------
*    Date            Who               ODR Reference             Description
*   ------         ------              -------------           -------------------
* 15 Mar 2011    Krishna Murthy T.S    ODR-2011-03-0100        Initial Creation
* 02 Sep 2014    Egambaram A           PACS00311738            changes done to get values for the fields NUMERO DE CASO and NUMERO DE POLIZA
* 03 Sep 2014    Egambaram A            PACS00311738           code review issues hadnled
* 06-06-2023      Conversion Tool       R22 Auto Conversion - FM TO @FM AND VM TO @VM AND SM TO @SM AND = TO EQ AND ++ TO + = 1
* 06-06-2023      ANIL KUMAR B          R22 Manual Conversion - REMOVING THE COMMENT AND adding packag APAP.TAM and alles changed for call routine AND AA.CUS.OWNER changed to AA.CUS.CUSTOMER and AA.CUS.PRIMARY.OWNER changed to AA.CUS.CUSTOMER.
* 19-01-2024        Narmadha V    R22 Utility Changes,Manual R22 Conversion - Call routine format modified
*--------------------------------------------------------------------------------------------------------------

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.OVERDUE
*    $INSERT I_F.AA.ARRANGEMENT ;*Manual R22 Conversion
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.RELATION
    $USING AA.Framework ;*Manual R22 Conversion
*   $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.EB.LOOKUP
    $USING APAP.TAM  ;*R22 MANUAL CONVERSION

    GOSUB INIT
    GOSUB GET.LOC.POSNS
    GOSUB PROCESS
RETURN

*-----
INIT:
*-----
    Y.AGENCY.VAL = '';         Y.LOAN.STATUS = '';           Y.AGENCY = '' ;
    Y.INVSTMNT.NUM = '' ;      Y.INVST.CUS.NAME = '' ;       Y.OPEN.DATE = '';
    Y.ACCT.EXECUTIVE = '';     Y.INVST.AMT = '' ;             Y.TERM = '';
    Y.EXP.DATE = '';           Y.INT.RATE = '';              Y.ENT.NUM = '';
    Y.GUARANTEE.NUM = '';      Y.CASE.NUM = '';              Y.PROD.TYPE = '';
    Y.DEB.NAME = '';           Y.OUT.BAL = '';               Y.LN.STATUS = '';
    Y.POLICY.NUM = '';         Y.INS.ORG.AMT = '';           Y.CANCEL.DATE = '';
    SEL.FLD.DISP = '*'

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    R.AZ.ACCOUNT = ''
    Y.AZ.READ.ERR = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    R.ACCOUNT = ''
    Y.AC.READ.ERR = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    R.AA.ARRANGEMENT = ''
    Y.READ.AA.ERR = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    R.AA.ACCOUNT.DETAILS = ''
    Y.READ.ACC.ERR = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.RELATION = 'F.RELATION'
    F.RELATION = ''
    R.RELATION = ''
    Y.READ.REL.ERR = ''
    CALL OPF(FN.RELATION,F.RELATION)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    R.CUSTOMER = ''
    Y.CUS.READ.ERR = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)


    FN.EB.LOOKUP = "F.EB.LOOKUP"
    F.EB.LOOKUP = ""
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

RETURN

*--------------
GET.LOC.POSNS:
*--------------
    Y.APPLNS = 'AZ.ACCOUNT':@FM:'AA.ARR.OVERDUE':@FM:'AA.ARR.TERM.AMOUNT':@FM:'CUSTOMER':@FM:'AA.PRD.DES.CHARGE'
    Y.LOC.FLDS  = 'L.MG.ACT.NO':@VM:'L.FHA.CASE.NO':@VM:'L.AZ.REF.NO':@VM:'L.FHA.POL.NO'
    Y.LOC.FLDS := @FM:'L.LOAN.STATUS.1'
    Y.LOC.FLDS := @FM:'L.AA.COL'
    Y.LOC.FLDS := @FM:'L.CU.TIPO.CL'
    Y.LOC.FLDS := @FM:"INS.POLICY.TYPE":@VM:"POLICY.NUMBER":@VM:"L.FHA.CASE.NO"
    Y.LOC.POSNS = ''

    CALL MULTI.GET.LOC.REF(Y.APPLNS,Y.LOC.FLDS,Y.LOC.POSNS)

    Y.MG.ACT.NO.POS = Y.LOC.POSNS<1,1>
    Y.FHA.CASE.POS  = Y.LOC.POSNS<1,2>
    Y.AZ.REF.POS    = Y.LOC.POSNS<1,3>
    Y.FHA.POL.POS   = Y.LOC.POSNS<1,4>

    Y.LOAN.STA.POS  = Y.LOC.POSNS<2,1>

    Y.AA.CO.POS     = Y.LOC.POSNS<3,1>

    LOC.L.CU.TIPO.CL.POS = Y.LOC.POSNS<4,1>

    Y.POL.TYPE.POS  = Y.LOC.POSNS<5,1>
*Y.POL.NUM.POS   = Y.LOC.POSNS<5,2>
*Y.FHA.CASE.POS  = Y.LOC.POSNS<5,3>
    Y.POL.NUM.POS   = Y.LOC.POSNS<5,2>  ;*R22 MANUAL CONVERSION REMOVING THE COMMENT
    Y.FHA.CASE.POS  = Y.LOC.POSNS<5,3>  ;*R22 MANUAL CONVERSION REMOVING THE COMMENT

RETURN

*---------
PROCESS:
*---------
    GOSUB MATCH.SEL.CRITERIA
    SEL.CMD := ' BY CO.CODE'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.ERR)
    LOOP
        REMOVE Y.AZ.ACC.ID FROM SEL.LIST SETTING Y.AZ.ACC.POS
    WHILE Y.AZ.ACC.ID:Y.AZ.ACC.POS
        R.AZ.ACCOUNT = ''
        CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ACC.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,Y.AZ.READ.ERR)
        Y.MG.AC.NO = R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.MG.ACT.NO.POS>
        Y.AZ.VAL.DATE = R.AZ.ACCOUNT<AZ.VALUE.DATE>
        Y.AZ.MAT.DATE = R.AZ.ACCOUNT<AZ.MATURITY.DATE>
*
        Y.AZ.CHK.CAT = R.AZ.ACCOUNT<AZ.CATEGORY>
*
        R.ACCOUNT = ''
        CALL F.READ(FN.ACCOUNT,Y.MG.AC.NO,R.ACCOUNT,F.ACCOUNT,Y.AC.READ.ERR)
        Y.ARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
        IF (Y.ARR.ID) AND (Y.AZ.CHK.CAT EQ "6604") THEN
            GOSUB GET.LOAN.STATUS
            IF Y.LOAN.STATUS NE '' THEN
                CHANGE @SM TO ' ' IN Y.LOAN.STATUS
                LOCATE Y.LOAN.STATUS IN Y.LOAN.STATUS1<1,1> SETTING POS1 THEN
                    Y.LOAN.STATUS1 = Y.LOAN.STATUS
                    GOSUB MAIN.PROCESS
                END
            END ELSE
                GOSUB MAIN.PROCESS
            END
        END
    REPEAT
*
    IF Y.FINAL.ARRAY THEN
        Y.FINAL.ARRAY := SEL.FLD.DISP
    END
RETURN

*--------------------------------------------------------------------------------------
MATCH.SEL.CRITERIA:
*--------------------
* Selecting AZ.ACCOUNT records depending on the Selection criteria entered
*
    SEL.CMD = "SELECT ":FN.AZ.ACCOUNT
    LOCATE 'AGENCY' IN D.FIELDS<1> SETTING Y.AGENCY.POS THEN
        Y.AGENCY.VAL = D.RANGE.AND.VALUE<Y.AGENCY.POS>
        SEL.CMD := " WITH CO.CODE EQ ":Y.AGENCY.VAL
        IF SEL.FLD.DISP EQ "*" THEN
            SEL.FLD.DISP := "AGENCIA : ":Y.AGENCY.VAL
        END ELSE
            SEL.FLD.DISP := ", AGENCIA : ":Y.AGENCY.VAL
        END
    END

    LOCATE 'LOAN.STATUS' IN D.FIELDS<1> SETTING Y.LOAN.STATUS.POS THEN
        Y.LOAN.STATUS = D.RANGE.AND.VALUE<Y.LOAN.STATUS.POS>
        IF SEL.FLD.DISP EQ "*" THEN
            SEL.FLD.DISP := "ESTATUS PRESTAMO : ":Y.LOAN.STATUS
        END ELSE
            SEL.FLD.DISP := ", ESTATUS PRESTAMO : ":Y.LOAN.STATUS
        END
    END

    IF SEL.FLD.DISP EQ '*' THEN
        SEL.FLD.DISP = "*TODO"
    END
RETURN

*----------------
GET.LOAN.STATUS:
*-----------------

    OUT.PROPERTY = ''
    R.OUT.AA.RECORD = ''
    OUT.ERR = ''
    APAP.TAM.redoGetPropertyName(Y.ARR.ID,'OVERDUE',R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)

    ArrangementID = Y.ARR.ID
    idPropertyClass = 'OVERDUE'
    idProperty = OUT.PROPERTY<1>
    effectiveDate = TODAY
    returnIds = ''
    returnCond = ''
    R.CONDITION = ''
    returnError = ''

*CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, R.CONDITION, returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, R.CONDITION, returnError);* R22 Utility Changes
    R.CONDITION = RAISE(R.CONDITION)
    Y.LOAN.STATUS1 = R.CONDITION<AA.OD.LOCAL.REF,Y.LOAN.STA.POS>
    CHANGE @SM TO @VM IN Y.LOAN.STATUS1
    GOSUB GET.POLICY.CASE
****
RETURN

*===============
GET.POLICY.CASE:
*===============
* To get the value of NUMERO DE CASO & NUMERO DE POLIZA
*
*PACS00311738 - EGA - S

    Y.POLICY.NUMBER.ARRAY = ""
    Y.CASE.NUMBER.ARRAY = ""

    ArrangementID = Y.ARR.ID
    idPropertyClass = 'CHARGE'
    idProperty = ''
    effectiveDate = TODAY
    returnIds = ''
    returnCond = ''
    R.CONDITION = ''
    returnError = ''

*Y.AA.APP = "AA.PRD.DES.CHARGE"
*Y.AA.FLD = "INS.POLICY.TYPE":VM:"POLICY.NUMBER":VM:"L.FHA.CASE.NO"
*Y.AA.POS = ""
*CALL MULTI.GET.LOC.REF(Y.AA.APP,Y.AA.FLD,Y.AA.POS)
*Y.POL.TYPE.POS  = Y.AA.POS<1,1>
*Y.POL.NUM.POS   = Y.AA.POS<1,2>
*Y.FHA.CASE.POS  = Y.AA.POS<1,3>

*CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, R.CONDITION, returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, R.CONDITION, returnError);* R22 Utility Changes
    CP = "1"
    CP.COUNT = DCOUNT(R.CONDITION,@FM)
    LOOP
    WHILE CP LE CP.COUNT
        R.REC = R.CONDITION<CP>
        R.REC = RAISE(R.REC)
        Y.INS.POL.TYPE  = R.REC<AA.CHG.LOCAL.REF,Y.POL.TYPE.POS>
        Y.POLICY.NUMBER = R.REC<AA.CHG.LOCAL.REF,Y.POL.NUM.POS>
*Y.FHA.CASE.NO   = R.REC<AA.CHG.LOCAL.REF,Y.FHA.CASE.POS>
        Y.FHA.CASE.NO   = R.REC<AA.CHG.LOCAL.REF,Y.FHA.CASE.POS>  ;*R22 MANUAL CONVERSION REMOVING THE COMMENT

        LOCATE "FHA" IN Y.INS.POL.TYPE<1,1> SETTING FHA.POS THEN
            Y.POLICY.NO = Y.POLICY.NUMBER<1,FHA.POS>
            Y.POLICY.NUMBER.ARRAY<-1> = Y.POLICY.NO
        END

        Y.CASE.NUMBER.ARRAY<-1> = Y.FHA.CASE.NO
        CP += 1
    REPEAT

    CHANGE @FM TO @VM IN Y.POLICY.NUMBER.ARRAY
    CHANGE @FM TO @VM IN Y.CASE.NUMBER.ARRAY
*
RETURN
*PACS00311738 - EGA - E
*------------
GET.GUR.DETS:
*------------
    OUT.PROPERTY = ''
    R.OUT.AA.RECORD = ''
    OUT.ERR = ''
    APAP.TAM.redoGetPropertyName(Y.ARR.ID,'TERM.AMOUNT',R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)  ;*R22 MANUAL CONVERSION

    ArrangementID = Y.ARR.ID
    idPropertyClass = 'TERM.AMOUNT'
    idProperty = OUT.PROPERTY<1>
    effectiveDate = TODAY
    returnIds = ''
    returnCond = ''
    R.CONDITION = ''
    returnError = ''
*CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, R.CONDITION, returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, R.CONDITION, returnError);* R22 Utility Changes
    R.CONDITION = RAISE(R.CONDITION)
    Y.GUR.NUM = R.CONDITION<AA.AMT.LOCAL.REF,Y.AA.CO.POS>
    Y.AMT = R.CONDITION<AA.AMT.AMOUNT>

    CHANGE @SM TO @VM IN Y.GUR.NUM
    CHANGE @SM TO @VM IN Y.AMT
RETURN

*------------
GET.CUS.DETS:
*------------
    ArrangementID = Y.ARR.ID
    idPropertyClass = 'CUSTOMER'
    idProperty = ''
    effectiveDate = TODAY
    returnIds = ''
    returnCond = ''
    R.CONDITION = ''
    returnError = ''

*CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, R.CONDITION, returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, R.CONDITION, returnError);* R22 Utility Changes
    R.CONDITION  = RAISE(R.CONDITION)
*Y.OWNER.LIST = R.CONDITION<AA.CUS.OWNER>
    Y.OWNER.LIST = R.CONDITION<AA.CUS.CUSTOMER>  ;*R22 Manual Conversion
*Y.PRIM.OWNER = R.CONDITION<AA.CUS.PRIMARY.OWNER>
    Y.PRIM.OWNER = R.CONDITION<AA.CUS.CUSTOMER>  ;*R22 Manual Conversion

    Y.CUS.ERR = ''
    R.CUSTOMER = ''
    CALL F.READ(FN.CUSTOMER,Y.PRIM.OWNER,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
    Y.PRIM.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME,1>
    CHANGE @VM TO @FM IN Y.OWNER.LIST
    Y.OWN.CNT = DCOUNT(Y.OWNER.LIST,@FM)
    IF Y.OWN.CNT EQ 1 THEN
        IF Y.PRIM.OWNER NE Y.OWNER.LIST THEN
            R.CUSTOMER = ''
            CALL F.READ(FN.CUSTOMER,Y.OWNER.LIST,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
            Y.PRIM.NAME := @VM:R.CUSTOMER<EB.CUS.SHORT.NAME,1>
        END
    END ELSE
        LOOP
            REMOVE Y.OWNER FROM Y.OWNER.LIST SETTING Y.OWN.POS
        WHILE Y.OWNER:Y.OWN.POS
            IF Y.OWNER NE Y.PRIM.OWNER THEN
                R.CUSTOMER = ''
                CALL F.READ(FN.CUSTOMER,Y.OWNER,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
                Y.PRIM.NAME := @VM:R.CUSTOMER<EB.CUS.SHORT.NAME,1>
            END
        REPEAT
    END
RETURN
*-----------------
GET.INV.CUS.NAME:
*-----------------
    R.AZ.ACC.REC = ''
    CALL F.READ(FN.ACCOUNT,Y.AZ.ACC.ID,R.AZ.ACC.REC,F.ACCOUNT,Y.AC.READ.ERR)
    Y.ACCT.EXECUTIVE = R.AZ.ACC.REC<AC.ACCOUNT.OFFICER>
    Y.AZ.CUS = R.AZ.ACC.REC<AC.CUSTOMER>
    R.AZ.CUS.REC = ''
    CALL F.READ(FN.CUSTOMER,Y.AZ.CUS,R.AZ.CUS.REC,F.CUSTOMER,Y.CUS.ERR)

    IF R.AZ.CUS.REC<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.AZ.CUS.REC<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
        Y.CUS.NAMES = R.AZ.CUS.REC<EB.CUS.GIVEN.NAMES>:" ":R.AZ.CUS.REC<EB.CUS.FAMILY.NAME>
    END
    IF R.AZ.CUS.REC<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
        Y.CUS.NAMES = R.AZ.CUS.REC<EB.CUS.NAME.1,1>:" ":R.AZ.CUS.REC<EB.CUS.NAME.2,1>
    END
    IF NOT(R.AZ.CUS.REC<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
        Y.CUS.NAMES = R.AZ.CUS.REC<EB.CUS.SHORT.NAME>
    END
    Y.RELATION.COUNT = DCOUNT(R.AZ.ACC.REC<AC.RELATION.CODE>,@VM)
    Y.COUNT = 1
    LOOP
    WHILE Y.COUNT LE Y.RELATION.COUNT
        RELATION.ID = R.AZ.ACC.REC<AC.RELATION.CODE,Y.COUNT>
        IF RELATION.ID GE 500 AND RELATION.ID LE 529 THEN
            R.RELATION = ''
            CALL F.READ(FN.RELATION,RELATION.ID,R.RELATION,F.RELATION,Y.REL.ERR)
            Y.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>
            CUSTOMER.ID = R.AZ.ACC.REC<AC.JOINT.HOLDER,Y.COUNT>
            R.JOINT.CUS.REC = ''
            CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.JOINT.CUS.REC,F.CUSTOMER,Y.CUS.ERR)
            IF R.JOINT.CUS.REC<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.JOINT.CUS.REC<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
                Y.CUS.NAME = R.JOINT.CUS.REC<EB.CUS.GIVEN.NAMES>:" ":R.JOINT.CUS.REC<EB.CUS.FAMILY.NAME>
            END
            IF R.JOINT.CUS.REC<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
                Y.CUS.NAME = R.JOINT.CUS.REC<EB.CUS.NAME.1,1>:" ":R.JOINT.CUS.REC<EB.CUS.NAME.2,1>
            END
            IF NOT(R.JOINT.CUS.REC<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
                Y.CUS.NAME = R.JOINT.CUS.REC<EB.CUS.SHORT.NAME>
            END
            Y.CUS.NAMES := " ":Y.REL.DESC:" ":Y.CUS.NAME
            Y.CLIENT.CODE := @VM:CUSTOMER.ID
        END
        Y.COUNT += 1
    REPEAT
RETURN

*---------------
GET.OUT.BAL.GUA:
*---------------
    Y.OVERDUE.STATUS.LIST = "CUR-DUE-GRC-NAB-DEL"
    Y.STATUS.CNTR = 1
    Y.STATUS.CNT  = DCOUNT(Y.OVERDUE.STATUS.LIST,'-')
    Y.CHARGE.ID   = 'ACCOUNT'
    Y.TOTAL.CHARGE.AMT = 0
    LOOP
    WHILE Y.STATUS.CNTR LE Y.STATUS.CNT
        Y.STATUS        = FIELD(Y.OVERDUE.STATUS.LIST,'-',Y.STATUS.CNTR)
        Y.BALANCE.TYPE  = Y.STATUS:Y.CHARGE.ID
        DATE.OPTIONS = ''
        DATE.OPTIONS<4>  = 'ECB'
        BALANCE.AMOUNT  = ""
        Y.START.DATE    = TODAY
        Y.END.DATE      = ''
        BAL.DETAILS     = ''
*CALL AA.GET.PERIOD.BALANCES(Y.MG.AC.NO, Y.BALANCE.TYPE, DATE.OPTIONS, Y.START.DATE ,Y.END.DATE , "", BAL.DETAILS, "")
        AA.Framework.GetPeriodBalances(Y.MG.AC.NO, Y.BALANCE.TYPE, DATE.OPTIONS, Y.START.DATE ,Y.END.DATE , "", BAL.DETAILS, "");* R22 Utility Changes
        Y.BAL.DETAIL.DATE = BAL.DETAILS<1>
        Y.BAL.DET.DATE.CNT = DCOUNT(Y.BAL.DETAIL.DATE,@VM)
        Y.TOTAL.CHARGE.AMT+=BAL.DETAILS<4,Y.BAL.DET.DATE.CNT>
        Y.STATUS.CNTR += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------------------------------------
*-------------
MAIN.PROCESS:
*-------------
    GOSUB GET.GUR.DETS
    GOSUB GET.CUS.DETS
    GOSUB GET.INV.CUS.NAME
    GOSUB GET.OUT.BAL.GUA
    IF (Y.AZ.VAL.DATE NE '') AND (Y.AZ.MAT.DATE NE '') THEN
        Y.REGION = ''
        Y.DIFF.DAYS = 'C'
        CALL CDD(Y.REGION,Y.AZ.VAL.DATE,Y.AZ.MAT.DATE,Y.DIFF.DAYS)
    END

*CALL F.READ(FN.AA.ARRANGEMENT,Y.ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,Y.READ.AA.ERR)
    R.AA.ARRANGEMENT = AA.Framework.Arrangement.Read(Y.ARR.ID, Y.READ.AA.ERR) ;*Manual R22 Conversion
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.READ.ACC.ERR)

    Y.AGENCY         = R.AZ.ACCOUNT<AZ.CO.CODE>
    Y.INVSTMNT.NUM   = Y.AZ.ACC.ID
    Y.INVST.CUS.NAME = Y.CUS.NAMES
*Y.ACCT.EXECUTIVE = R.ACCOUNT<AC.ACCOUNT.OFFICER>
*Y.ACCT.EXECUTIVE = R.ACCOUNT<AC.DEPT.CODE>
    Y.INVST.AMT      = R.AZ.ACCOUNT<AZ.ORIG.PRINCIPAL>
    Y.TERM           = Y.DIFF.DAYS
    Y.OPEN.DATE      = R.AZ.ACCOUNT<AZ.CREATE.DATE>
    Y.EXP.DATE       = R.AZ.ACCOUNT<AZ.MATURITY.DATE>
    Y.INT.RATE       = R.AZ.ACCOUNT<AZ.INTEREST.RATE>
    Y.ENT.NUM        = R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.AZ.REF.POS>
    Y.GUARANTEE.NUM  = Y.GUR.NUM
    Y.CASE.NUM       = R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.FHA.CASE.POS>
*Y.CASE.NUM       = Y.CASE.NUMBER.ARRAY
*Y.PROD.TYPE      = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    Y.PROD.TYPE      = R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrProduct> ;*Manual R22 Conversion
    Y.DEB.NAME       = Y.PRIM.NAME
    Y.OUT.BAL        = Y.TOTAL.CHARGE.AMT
*Y.LN.STATUS      = Y.LOAN.STATUS1
    LOOKUP.ID     = "L.LOAN.STATUS.1":"*":Y.LOAN.STATUS1
    CALL F.READ(FN.EB.LOOKUP,LOOKUP.ID,R.EB.LOOKUP,F.EB.LOOKUP,LOOK.ERR)
    Y.LN.STATUS = R.EB.LOOKUP<EB.LU.DESCRIPTION,2>
    Y.POLICY.NUM     = R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.FHA.POL.POS>
*Y.POLICY.NUM     = Y.POLICY.NUMBER.ARRAY
    Y.INS.ORG.AMT    = Y.AMT
    Y.CANCEL.DATE    = R.AA.ACCOUNT.DETAILS<AA.AD.MATURITY.DATE>

    CHANGE @SM TO @VM IN Y.CASE.NUM
    CHANGE @SM TO @VM IN Y.POLICY.NUM
    CHANGE @FM TO @VM IN Y.INVST.CUS.NAME

*                           1             2                   3                   4
    Y.FINAL.ARRAY<-1> = Y.AGENCY:"*":Y.INVSTMNT.NUM:"*":Y.INVST.CUS.NAME:"*":Y.ACCT.EXECUTIVE:"*"
*                           5             6             7             8                9
    Y.FINAL.ARRAY  := Y.INVST.AMT:"*":Y.TERM:"*":Y.OPEN.DATE:"*":Y.EXP.DATE:"*":Y.INT.RATE:"*"
*                          10             11                  12              13
    Y.FINAL.ARRAY  := Y.ENT.NUM:"*":Y.GUARANTEE.NUM:"*":Y.CASE.NUM:"*":Y.PROD.TYPE:"*"
*                          14             15             16               17              18
    Y.FINAL.ARRAY  := Y.DEB.NAME:"*":Y.OUT.BAL:"*":Y.LN.STATUS:"*":Y.POLICY.NUM:"*":Y.INS.ORG.AMT:"*"
*                          19
    Y.FINAL.ARRAY  := Y.CANCEL.DATE
    Y.ACCT.EXECUTIVE = ""
RETURN
END
