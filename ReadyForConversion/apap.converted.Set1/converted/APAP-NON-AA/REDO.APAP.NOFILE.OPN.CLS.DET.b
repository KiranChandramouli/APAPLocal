SUBROUTINE REDO.APAP.NOFILE.OPN.CLS.DET(Y.FINAL.ARRAY)
******************************************************************************
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : G.Sabari
*  ODR Number        : ODR-2010-03-0155
*  Program   Name    : REDO.APAP.NOFILE.OPN.CLS.DET
*-----------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : Y.FINAL.ARRAY
*-----------------------------------------------------------------------------
* DESCRIPTION       : This is a NOFILE enquiry routine to get a report on a
*                     report on accounts openings and cancellations performed by
*                     agency, as well as account type and date range
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO         REFERENCE            DESCRIPTION
*  -----           ----        ----------           -----------
*  24-Sep-2010     G.Sabari    ODR-2010-03-0155     INITIAL CREATION
*-------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COMPANY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.GROUP.DATE
    $INSERT I_F.RELATION
    $INSERT I_F.ACCOUNT.PARAMETER
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.GROUP.CREDIT.INT
* Tus start
    $INSERT I_F.EB.CONTRACT.BALANCES
* Tus end


    GOSUB INITIALIZE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------------
INITIALIZE:
************

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''

    FN.CATEGORY = 'F.CATEGORY'
    F.CATEGORY = ''

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''

    FN.RELATION = 'F.RELATION'
    F.RELATION= ''

    FN.REDO.W.ACCOUNT.UPDATE = 'F.REDO.W.ACCOUNT.UPDATE'
    F.REDO.W.ACCOUNT.UPDATE = ''

    FN.ACCT.ACTIVITY = 'F.ACCT.ACTIVITY'
    F.ACCT.ACTIVITY = ''

    FN.ACCOUNT.CREDIT.INT = 'F.ACCOUNT.CREDIT.INT'
    F.ACCOUNT.CREDIT.INT = ''

    FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'
    F.GROUP.CREDIT.INT = ''

    FN.ACCOUNT.CLOSED = 'F.ACCOUNT.CLOSED'
    F.ACCOUNT.CLOSED = ''

    FN.GROUP.DATE = 'F.GROUP.DATE'
    F.GROUP.DATE = ''

    FN.ACCOUNT.PARAMETER = 'F.ACCOUNT.PARAMETER'
    F.ACCOUNT.PARAMETER = ''

    FN.ACCOUNT.CLOSURE = 'F.ACCOUNT.CLOSURE'
    F.ACCOUNT.CLOSURE = ''

    FN.ACCOUNT$HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT$HIS  = ''
    CALL OPF(FN.ACCOUNT$HIS,F.ACCOUNT$HIS)

    VALUE.BK = D.RANGE.AND.VALUE
    OPERAND.BK = D.LOGICAL.OPERANDS
    FIELDS.BK = D.FIELDS

    Y.REG = ''
    ID.LIST.ACC = ''
    Y.NAME1 = ''
    Y.NAME2 = ''
    Y.ACC.REL.DESC = ''
    Y.SEL.FLD = ''
    Y.SEL.VAL = ''
    Y.ACC.INT.RATE = 0.00
    Y.COMP.NAME = ''
RETURN
*-------------------------------------------------------------------------------
OPENFILES:
**********

    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.CATEGORY,F.CATEGORY)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.COMPANY,F.COMPANY)
    CALL OPF(FN.RELATION,F.RELATION)
    CALL OPF(FN.ACCT.ACTIVITY,F.ACCT.ACTIVITY)
    CALL OPF(FN.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT)
    CALL OPF(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)
    CALL OPF(FN.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE)
    CALL OPF(FN.ACCOUNT.PARAMETER,F.ACCOUNT.PARAMETER)
    CALL OPF(FN.GROUP.DATE,F.GROUP.DATE)
    CALL OPF(FN.REDO.W.ACCOUNT.UPDATE,F.REDO.W.ACCOUNT.UPDATE)
RETURN

*-------------------------------------------------------------------------------
PROCESS:
********

    IF NOT(RUNNING.UNDER.BATCH) THEN
        GOSUB SEL.STMT
    END ELSE
        GOSUB SEL.STMT.COB
    END

    GOSUB ACC.DETAILS

RETURN
*-------------------------------------------------------------------------------
ACC.DETAILS:
************

    GOSUB FIND.MULTI.LOCAL.REF

    LOOP REMOVE ACCOUNT.ID FROM ID.LIST.ACC SETTING Y.ACC.POS1
    WHILE ACCOUNT.ID:Y.ACC.POS1
        R.ACCOUNT = ''
        Y.ACCOUNT.ID = ACCOUNT.ID
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACC)
* Tus start
        R.ECB = ''
        ECB.ERR = ''
        CALL EB.READ.HVT("EB.CONTRACT.BALANCES", Y.ACCOUNT.ID,R.ECB,ECB.ERR)
* Tus end
        IF NOT(R.ACCOUNT) THEN
            CALL EB.READ.HISTORY.REC (F.ACCOUNT$HIS,Y.ACCOUNT.ID,R.ACCOUNT,Y.ERR)
        END
        Y.ACC.AGENCY = R.ACCOUNT<AC.CO.CODE>
        Y.ACC.CATEGORY = R.ACCOUNT<AC.CATEGORY>
        IF Y.ACC.CATEGORY GE Y.CATEGORY.VAL.ST AND Y.ACC.CATEGORY LE Y.CATEGORY.VAL.END ELSE
            CONTINUE
        END

        CALL CACHE.READ(FN.COMPANY, Y.ACC.AGENCY, R.COMPANY.REC, ERR.CMP)
        Y.COMP.NAME = R.COMPANY.REC<EB.COM.COMPANY.NAME>

        Y.ACC.REG1 = R.ACCOUNT<AC.ACCOUNT.OFFICER>
        Y.LENGTH1 = LEN(Y.ACC.REG1)
        Y.CNT1 = Y.LENGTH1-7

        IF Y.CNT1 GT 0 THEN
            Y.TO.COMP1 = Y.ACC.REG1[Y.CNT1,2]
            Y.ACC.REGION1 = Y.TO.COMP1
        END ELSE
            Y.ACC.REGION1 = ''
        END

        Y.ACC.EXECUTIVE = R.ACCOUNT<AC.ACCOUNT.OFFICER>
        Y.ACC.CLIENT.CODE = R.ACCOUNT<AC.CUSTOMER>
        Y.ACC.TYPE = R.ACCOUNT<AC.CATEGORY>
        Y.ACC.NO = ACCOUNT.ID
        Y.ACC.PREV.AC.NO = R.ACCOUNT<AC.ALT.ACCT.ID>
        Y.ACC.OPEN.DATE = R.ACCOUNT<AC.OPENING.DATE>
        Y.ACC.CURR = R.ACCOUNT<AC.CURRENCY>
*Y.ACC.CRNT.BAL = R.ACCOUNT<AC.ONLINE.ACTUAL.BAL>
* Tus start
        Y.ACC.CRNT.BAL = R.ECB<ECB.ONLINE.ACTUAL.BAL>
* Tus end
        Y.ACC.USR.INP = FIELD(R.ACCOUNT<AC.INPUTTER>,'_',2)
        Y.ACC.AUTH = FIELD(R.ACCOUNT<AC.AUTHORISER>,'_',2)
        Y.DET.CODE = R.ACCOUNT<AC.DEPT.CODE>
        Y.ACC.EXE.AGENCY = Y.ACC.AGENCY:"  ":Y.DET.CODE

        GOSUB CU.DETAILS

        GOSUB AMT.DETAILS

        GOSUB INT.DETAILS

        GOSUB ACC.CLO.DETAILS

        GOSUB HDR.DETAILS


        Y.FINAL.ARRAY<-1> :=Y.COMP.NAME:"*":Y.ACC.REGION1:"*":Y.ACC.EXECUTIVE:"*":Y.ACC.CLIENT.TYPE:"*"
        Y.FINAL.ARRAY:= Y.ACC.CLIENT.CODE:"*":Y.ACC.TYPE:"*":Y.ACC.PREV.AC.NO:"*":Y.ACC.NO:"*":Y.ACC.NAME:"*"
        Y.FINAL.ARRAY:= Y.ACC.OPEN.DATE:"*":Y.ACC.CURR:"*":Y.ACC.OPEN.AMT1:"*":Y.ACC.INT.RATE:"*":Y.ACC.CRNT.BAL:"*"
        Y.FINAL.ARRAY:= Y.ACC.CANCEL.DATE:"*":Y.ACC.CANCEL.AMT:"*":Y.ACC.REASON.CANCEL:"*":Y.ACC.USR.INP:"*"
        Y.FINAL.ARRAY:= Y.ACC.AUTH:"*":Y.ACC.EXE.AGENCY:"*":Y.DATE:"*":Y.TIME:"*":Y.CLASSIFICATION

    REPEAT

RETURN
*-------------------------------------------------------------------------------
GET.ACCOUNT.PARAMETER:
*-------------------------------------------------------------------------------

    CALL CACHE.READ(FN.ACCOUNT.PARAMETER,'SYSTEM',R.ACCOUNT.PARAMETER,Y.ERR.AP)
    Y.CAT.DES = R.ACCOUNT.PARAMETER<AC.PAR.ACCT.CATEG.DESC>
    Y.CAT.ST = R.ACCOUNT.PARAMETER<AC.PAR.ACCT.CATEG.STR>
    Y.CAT.END = R.ACCOUNT.PARAMETER<AC.PAR.ACCT.CATEG.END>

    Y.COUNT = 1
    LOOP
    WHILE Y.COUNT LE DCOUNT(Y.CAT.DES,@VM)
        Y.DES.CAT = Y.CAT.DES<1,Y.COUNT>
        Y.STORED = UPCASE(Y.DES.CAT)
        FINDSTR 'SAVING' IN Y.STORED SETTING POS.FM,POS.VM THEN
            Y.CATEGORY.VAL.ST = Y.CAT.ST<1,Y.COUNT>
            Y.CATEGORY.VAL.END = Y.CAT.END<1,Y.COUNT>
        END
        Y.COUNT += 1
    REPEAT
RETURN
*-------------------------------------------------------------------------------
SEL.STMT.COB:
*-------------------------------------------------------------------------------
    GOSUB GET.ACCOUNT.PARAMETER
    CALL F.READ(FN.REDO.W.ACCOUNT.UPDATE,TODAY,R.REDO.W.ACCOUNT.UPDATE,F.REDO.W.ACCOUNT.UPDATE,Y.ERR)
    ID.LIST.ACC<-1> = R.REDO.W.ACCOUNT.UPDATE
    SEL.CMD = ' SELECT ':FN.ACCOUNT.CLOSURE: ' WITH CAPITAL.DATE EQ ': TODAY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,Y.ER)
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS
    WHILE Y.ID:POS
        LOCATE Y.ID IN ID.LIST.ACC SETTING POS.AC ELSE
            ID.LIST.ACC<-1> = Y.ID
        END
    REPEAT
RETURN
*-------------------------------------------------------------------------------
SEL.STMT:
*********

    GOSUB GET.ACCOUNT.PARAMETER
    LOCATE "AGENCY" IN FIELDS.BK<1> SETTING Y.AGENCY.POS THEN
        Y.AGENCY = VALUE.BK<Y.AGENCY.POS>
        IF Y.AGENCY NE '' THEN
            CALL CACHE.READ(FN.COMPANY, Y.AGENCY, R.COMP, COMP.ERR)
            IF R.COMP THEN
                Y.SEL.VAL = " AND WITH CO.CODE EQ ":Y.AGENCY
                Y.SEL.FLD = "BY CO.CODE"
            END ELSE
                Y.SEL.VAL = " AND WITH DEPT.CODE EQ ":Y.AGENCY
                Y.SEL.FLD = "BY DEPT.CODE"
            END
        END
    END

    Y.ARR.FLAG = ''
    D.RANGE.AND.VALUE=''
    D.LOGICAL.OPERANDS=''
    D.FIELDS=''

    APPL.FIELDS = 'CATEGORY':@FM:'OPENING.DATE':@FM:'CURRENCY':@FM:'ACCOUNT.OFFICER'
    LOOP
        REMOVE ARR.FLD FROM APPL.FIELDS SETTING ARR.FLD.POS
    WHILE ARR.FLD:ARR.FLD.POS
        LOCATE ARR.FLD IN FIELDS.BK<1> SETTING POS1 THEN
            Y.ARR.FLAG = 1
            D.RANGE.AND.VALUE<-1>=VALUE.BK<POS1>
            D.LOGICAL.OPERANDS<-1>=OPERAND.BK<POS1>
            D.FIELDS<-1>=FIELDS.BK<POS1>
        END
    REPEAT


    IF D.FIELDS NE '' THEN
        FILE.NAME = FN.ACCOUNT

        CALL REDO.E.FORM.SEL.STMT(FILE.NAME, '', '', SEL.CMD.ACC)

        SEL.CMD.ACC := ' WITH CATEGORY GE ':Y.CATEGORY.VAL.ST:' AND WITH CATEGORY LE ':Y.CATEGORY.VAL.END:' AND WITH ( CATEGORY LT 6011 OR WITH CATEGORY GT 6020 )'
        SEL.CMD.ACC := Y.SEL.VAL :" BY CATEGORY " : Y.SEL.FLD

        CALL EB.READLIST(SEL.CMD.ACC,SEL.LIST.ACC,'',NO.OF.REC.ACC,SEL.ERR)

    END ELSE

        SEL.CMD.ACC = "SELECT ":FN.ACCOUNT:Y.SEL.VAL
        SEL.CMD.ACC := ' WITH CATEGORY GE ':Y.CATEGORY.VAL.ST:' AND WITH CATEGORY LE ':Y.CATEGORY.VAL.END:' AND WITH ( CATEGORY LT 6011 OR WITH CATEGORY GT 6020 ) '
        SEL.CMD.ACC := " BY CATEGORY " :Y.SEL.FLD

        CALL EB.READLIST(SEL.CMD.ACC,SEL.LIST.ACC,'',NO.OF.REC.ACC,SEL.ERR)
    END

    LOCATE "REGION" IN FIELDS.BK<1> SETTING Y.REG.POS THEN
        Y.REG = VALUE.BK<Y.REG.POS>
    END

    LOCATE "CLOSURE.DATE" IN FIELDS.BK<1> SETTING Y.CLOS.POS THEN
        Y.CLOSURE.DATE = VALUE.BK<Y.CLOS.POS>
    END

    IF (Y.REG NE '') AND (Y.CLOSURE.DATE EQ '') THEN

        LOOP REMOVE ACCOUNT.ID FROM SEL.LIST.ACC SETTING Y.ACC.POS
        WHILE ACCOUNT.ID:Y.ACC.POS
            R.ACCOUNT = ''
            ERR.ACCOUNT = ''
            CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
            Y.ACC.REG = R.ACCOUNT<AC.ACCOUNT.OFFICER>
            Y.LENGTH = LEN(Y.ACC.REG)
            Y.CNT = Y.LENGTH-7
            IF Y.CNT GT 0 THEN
                Y.TO.COMP = Y.ACC.REG[Y.CNT,2]
                Y.ACC.REGION = Y.TO.COMP
            END ELSE
                Y.ACC.REGION = ''
            END

            IF Y.REG EQ Y.ACC.REGION THEN
                ID.LIST.ACC<-1>= ACCOUNT.ID
            END

        REPEAT
    END

    IF (Y.REG EQ '') AND (Y.CLOSURE.DATE EQ '') THEN
        ID.LIST.ACC = SEL.LIST.ACC
    END

    IF (Y.CLOSURE.DATE NE '') AND (Y.CLOSURE.DATE LE TODAY) AND (Y.REG EQ '') THEN
        LOOP REMOVE ACCOUNT.ID FROM SEL.LIST.ACC SETTING Y.ACC.POS
        WHILE ACCOUNT.ID:Y.ACC.POS
            R.ACCOUNT.CLOSURE = ''
            ERR.ACC.CLOS = ''
            CALL F.READ(FN.ACCOUNT.CLOSURE,ACCOUNT.ID,R.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE,ERR.ACC.CLOS)

            CLOS.DATE = R.ACCOUNT.CLOSURE<AC.ACL.CAPITAL.DATE>

            REC.STAT = R.ACCOUNT.CLOSURE<AC.ACL.RECORD.STATUS>

            IF CLOS.DATE EQ Y.CLOSURE.DATE AND CLOS.DATE LT TODAY AND REC.STAT EQ '' THEN
                ID.LIST.ACC<-1>= ACCOUNT.ID
            END

            IF CLOS.DATE EQ Y.CLOSURE.DATE AND CLOS.DATE EQ TODAY AND REC.STAT EQ '' THEN
                IF R.ACCOUNT.CLOSURE<AC.ACL.CLOSE.ONLINE> EQ 'Y' THEN
                    ID.LIST.ACC<-1>= ACCOUNT.ID
                END
            END

        REPEAT
    END

    IF (Y.CLOSURE.DATE NE '') AND (Y.CLOSURE.DATE LE TODAY) AND (Y.REG NE '') THEN
        LOOP REMOVE ACCOUNT.ID FROM SEL.LIST.ACC SETTING Y.ACC.POS
        WHILE ACCOUNT.ID:Y.ACC.POS

            R.ACCOUNT.CLOSURE = ''
            ERR.ACC.CLOS = ''
            CALL F.READ(FN.ACCOUNT.CLOSURE,ACCOUNT.ID,R.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE,ERR.ACC.CLOS)
            R.ACCOUNT = ''
            ERR.ACCOUNT = ''

            CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
            Y.ACC.REG = R.ACCOUNT<AC.ACCOUNT.OFFICER>
            Y.LENGTH = LEN(Y.ACC.REG)
            Y.CNT = Y.LENGTH-7
            IF Y.CNT GT 0 THEN
                Y.TO.COMP = Y.ACC.REG[Y.CNT,2]
                Y.ACC.REGION = Y.TO.COMP
            END ELSE
                Y.ACC.REGION = ''
            END

            CLOS.DATE = R.ACCOUNT.CLOSURE<AC.ACL.CAPITAL.DATE>

            REC.STAT = R.ACCOUNT.CLOSURE<AC.ACL.RECORD.STATUS>

            IF CLOS.DATE EQ Y.CLOSURE.DATE AND CLOS.DATE LT TODAY AND REC.STAT EQ '' AND (Y.REG EQ Y.ACC.REGION) THEN
                ID.LIST.ACC<-1>= ACCOUNT.ID
            END

            IF CLOS.DATE EQ Y.CLOSURE.DATE AND CLOS.DATE EQ TODAY AND REC.STAT EQ '' AND (Y.REG EQ Y.ACC.REGION) THEN
                IF R.ACCOUNT.CLOSURE<AC.ACL.CLOSE.ONLINE> EQ 'Y' THEN
                    ID.LIST.ACC<-1>= ACCOUNT.ID
                END
            END

        REPEAT
    END

RETURN
*-----------------------------------------------------------------------------
CU.DETAILS:
***********

    CALL F.READ(FN.CUSTOMER,Y.ACC.CLIENT.CODE,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    Y.NAME1 = ''
    Y.ACC.REL.DESC = ''
    Y.NAME2 = ''
    Y.ACC.CLIENT.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
        Y.NAME1 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END ELSE
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
            Y.NAME1 = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
        END
    END

    Y.ACC.REL.CODE = R.CUSTOMER<EB.CUS.RELATION.CODE>

    IF Y.ACC.REL.CODE GE 500 AND Y.ACC.REL.CODE LE 529 THEN
        CALL F.READ(FN.RELATION,Y.ACC.REL.CODE,R.RELATION,F.RELATION,REL.ERR)
        Y.ACC.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>
        Y.ACC.JOINT.HOLD = R.ACCOUNT<AC.JOINT.HOLDER>

        CALL F.READ(FN.CUSTOMER,Y.ACC.JOINT.HOLD,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)

        Y.NAME = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>

        IF R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
            Y.NAME2 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
        END ELSE
            IF R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
                Y.NAME2 = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
            END
        END
    END

    Y.ACC.NAME = Y.NAME1:'':Y.ACC.REL.DESC:'':Y.NAME2

RETURN
*-----------------------------------------------------------------------------
AMT.DETAILS:
************

    Y.DATE = Y.ACC.OPEN.DATE[1,6]
    Y.AMT.ID = ACCOUNT.ID:'-':Y.DATE
    CALL F.READ(FN.ACCT.ACTIVITY,Y.AMT.ID,R.ACCT.ACTIVITY,F.ACCT.ACTIVITY,ACCT.ACTIV.ERR)
    Y.ACC.OPEN.AMT1 = R.ACCT.ACTIVITY<IC.ACT.TURNOVER.CREDIT,1>

RETURN
*-----------------------------------------------------------------------------
INT.DETAILS:
************
    SEL.LIST.AINT = ''
    Y.CREDIT.INT.VAL = ''
*    SEL.CMD.AINT = 'SELECT ':FN.ACCOUNT.CREDIT.INT: ' WITH @ID LIKE ': ACCOUNT.ID : '...'
*   CALL EB.READLIST(SEL.CMD.AINT,SEL.LIST.AINT,'',NO.OF.REC.AINT,SEL.ERR.AINT)
    Y.CREDIT.INT.VAL = R.ACCOUNT<AC.ACCT.CREDIT.INT>
    Y.COUNT.CREDIT = DCOUNT(Y.CREDIT.INT.VAL,@VM)
    SEL.LIST.INT = Y.CREDIT.INT.VAL<1,Y.COUNT.CREDIT>
    IF SEL.LIST.INT THEN
        SEL.LIST.AINT = ACCOUNT.ID: '-':SEL.LIST.INT
    END

    IF SEL.LIST.AINT NE '' THEN
        CALL F.READ(FN.ACCOUNT.CREDIT.INT,SEL.LIST.AINT<1>,R.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT,AINT.ERR)
        Y.ACC.INT.RATE = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.INT.RATE>
    END ELSE
        Y.ACC.COND.GRP = ''
        Y.ACC.COND.GRP = R.ACCOUNT<AC.CONDITION.GROUP>
        IF Y.ACC.COND.GRP THEN
            Y.COND.ID = Y.ACC.COND.GRP:Y.ACC.CURR
        END

*        SEL.CMD.GINT = 'SELECT ':FN.GROUP.CREDIT.INT: ' WITH @ID LIKE ': Y.COND.ID : '...'
*       CALL EB.READLIST(SEL.CMD.GINT,SEL.LIST.GINT,'',NO.OF.REC.GINT,SEL.ERR.GINT)
        IF Y.COND.ID THEN
            CALL CACHE.READ(FN.GROUP.DATE, Y.COND.ID, R.GROUP.DATE, Y.ERR)
            Y.DATE = R.GROUP.DATE<AC.GRD.CREDIT.GROUP.DATE>
            SEL.LIST.GINT = Y.COND.ID:Y.DATE
            CALL CACHE.READ(FN.GROUP.CREDIT.INT, SEL.LIST.GINT<1>, R.GROUP.CREDIT.INT, GINT.ERR)
            Y.ACC.INT.RATE = R.GROUP.CREDIT.INT<IC.GCI.CR.INT.RATE>
        END
    END

RETURN
*-----------------------------------------------------------------------------
ACC.CLO.DETAILS:
****************

    CALL F.READ(FN.ACCOUNT.CLOSURE,ACCOUNT.ID,R.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE,ACC.CLO.ERR)
    Y.ACC.CANCEL.DATE = R.ACCOUNT.CLOSURE<AC.ACL.CAPITAL.DATE>
    Y.ACC.CANCEL.AMT = R.ACCOUNT.CLOSURE<AC.ACL.TOTAL.ACC.AMT>
    Y.ACC.REASON.CANCEL = R.ACCOUNT.CLOSURE<AC.ACL.LOCAL.REF,L.AC.CAN.REASON.POS>

RETURN
*-----------------------------------------------------------------------------
HDR.DETAILS:
************
    Y.DATE = ICONV(TODAY,'D')
    Y.DATE = OCONV(Y.DATE,'D4')

    Y.TIME = OCONV(TIME(), "MTS")

    TEMP.RANGE.AND.VALUE = VALUE.BK
    CHANGE @FM TO ',' IN TEMP.RANGE.AND.VALUE

    Y.CLASSIFICATION = TEMP.RANGE.AND.VALUE
    IF TEMP.RANGE.AND.VALUE  EQ '' THEN
        Y.CLASSIFICATION = 'ALL'
    END

RETURN
*-----------------------------------------------------------------------------
FIND.MULTI.LOCAL.REF:
*********************

    APPL.ARRAY = 'CUSTOMER':@FM:'ACCOUNT.CLOSURE'
    FLD.ARRAY = 'L.CU.TIPO.CL':@FM:'L.AC.CAN.REASON'

    FLD.POS = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    L.CU.TIPO.CL.POS = FLD.POS<1,1>
    L.AC.CAN.REASON.POS = FLD.POS<2,1>

RETURN
*-----------------------------------------------------------------------------
END
