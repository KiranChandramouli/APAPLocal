* @ValidationCode : MjotMTQ4MzQyMjY0NDpDcDEyNTI6MTY4NDQ5MTAzMTg0MjpJVFNTOi0xOi0xOjE2MzI6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1632
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION         FM TO @FM, VM TO @VM, SM TO @SM, F.READ TO CACHE.READ
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION         CALL routine format modified
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.CURR.ACC.CLOSURE.REP(Y.FIN.ARR)
*-----------------------------------------------------------------------------

*Company   Name    : Asociacion Popular De Ahorros Y Pristamos Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CURR.ACC.CLOSURE.REP
*------------------------------------------------------------------------------------------------------------

*Description       : This is nofile enquiry routine used to fetch the details neccessary for current accout closure report

*Linked With       : AZ,REDO as AUTH.ROUTINE
*In  Parameter     : -N/A-
*Out Parameter     : Y.FIN.ARR
*------------------------------------------------------------------------------------------------------------

*Modification Details:
*=====================
*11/09/2011  - PACS00217602 - MARIMUTHU S - Initial creation.
*------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.CATEGORY
    $INSERT I_F.GROUP.DATE
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_F.REDO.CUST.PRD.LIST
    $INSERT I_F.USER


    GOSUB MAIN
    GOSUB PROCESS.END

MAIN:

    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

OPENFILES:

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT.CLOSURE = 'F.ACCOUNT.CLOSURE'
    F.ACCOUNT.CLOSURE = ''
    CALL OPF(FN.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE)

    FN.CATEGORY = 'F.CATEGORY'
    F.CATEGORY = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HIS = ''
    CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)

    FN.AI.REDO.ARCIB.PARAMETER = 'F.AI.REDO.ARCIB.PARAMETER'
    F.AI.REDO.ARCIB.PARAMETER = ''

    FN.ACCOUNT.CREDIT.INT = 'F.ACCOUNT.CREDIT.INT'
    F.ACCOUNT.CREDIT.INT = ''
    CALL OPF(FN.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT)

    FN.ACCOUNT.CREDIT.INT.HIS = 'F.ACCOUNT.CREDIT.INT$HIS'
    F.ACCOUNT.CREDIT.INT.HIS = ''
    CALL OPF(FN.ACCOUNT.CREDIT.INT.HIS,F.ACCOUNT.CREDIT.INT.HIS)

    FN.GROUP.DATE = 'F.GROUP.DATE'
    F.GROUP.DATE = ''
    CALL OPF(FN.GROUP.DATE,F.GROUP.DATE)

    FN.REDO.CUST.PRD.LIST = 'F.REDO.CUST.PRD.LIST'
    F.REDO.CUST.PRD.LIST = ''
    CALL OPF(FN.REDO.CUST.PRD.LIST,F.REDO.CUST.PRD.LIST)

    FN.ACCOUNT.CLOSED = 'F.ACCOUNT.CLOSED'
    F.ACCOUNT.CLOSED = ''
    CALL OPF(FN.ACCOUNT.CLOSED,F.ACCOUNT.CLOSED)

    POS.FLS = ''
    APPLN = 'ACCOUNT.CLOSURE':@FM:'CUSTOMER':@FM:'ACCOUNT'
    F.FIELDS = 'L.AC.CAN.REASON':@FM:'L.CU.TEL.TYPE':@VM:'L.CU.TIPO.CL':@FM:'L.AC.AV.BAL':@VM:'L.AC.CAN.REASON'
    CALL MULTI.GET.LOC.REF(APPLN,F.FIELDS,POS.FLS)
    Y.REA.POS = POS.FLS<1,1>
    Y.TEL.POS = POS.FLS<2,1>
    Y.TIP.POS = POS.FLS<2,2>
    Y.AV.BAL.POS = POS.FLS<3,1>
    Y.RE.AC.PS = POS.FLS<3,2>

RETURN

PROCESS:


    LOCATE 'CANCEL.DATE' IN D.FIELDS<1> SETTING POS.C THEN
        Y.DATE.VALUE = D.RANGE.AND.VALUE<POS.C>
        Y.OPD = D.LOGICAL.OPERANDS<POS.C>
        Y.DT.SET = 'Y'
        Y.D.V = ICONV(Y.DATE.VALUE,'D')
        Y.D.V = OCONV(Y.D.V,'D4')
        Y.DT.STR = 'FECHA DE CANCELACION - ':Y.D.V
        GOSUB IDEN.OPR
        IF Y.OPDR EQ 'RG' THEN
            Y.DT.VAL = CHANGE(Y.DATE.VALUE,@SM,@VM)
            Y.DATE1 = Y.DT.VAL<1,1>
            Y.DATE2 = Y.DT.VAL<1,2>
            Y.S.D = ICONV(Y.DATE1,'D')
            Y.S.D = OCONV(Y.S.D,'D4')
            Y.E.D = ICONV(Y.DATE2,'D')
            Y.E.D = OCONV(Y.E.D,'D4')
            Y.DT.STR = 'FECHA DE CANCELACION - ':Y.S.D:'-':Y.E.D
        END
    END
    LOCATE 'ACCOUNT.OFFICER' IN D.FIELDS<1> SETTING POS.A THEN
        Y.AC.OFI = D.RANGE.AND.VALUE<POS.A>
        Y.OF.SET = 'Y'
        IF Y.DT.STR THEN
            Y.DT.STR := ', OFICIAL DE CUENTA - ':Y.AC.OFI
        END ELSE
            Y.DT.STR = 'OFICIAL DE CUENTA - ':Y.AC.OFI
        END
    END
    LOCATE 'PROCESS.AGENCY' IN D.FIELDS<1> SETTING POS.P THEN
        Y.AG = D.RANGE.AND.VALUE<POS.P>
        Y.AG.SET = 'Y'
        IF Y.DT.STR THEN
            Y.DT.STR := ', AGENCIA - ':Y.AG
        END ELSE
            Y.DT.STR = 'AGENCIA - ':Y.AG
        END
    END

    IF Y.DATE.VALUE THEN
        IF Y.OPDR NE 'RG' THEN
            SEL.CMD = 'SELECT ':FN.ACCOUNT.CLOSED:' WITH @ID UNLIKE DOP... AND @ID UNLIKE USD... AND ACCT.CLOSE.DATE ':Y.OPDR:'  ':Y.DATE.VALUE
            CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
        END ELSE
            SEL.CMD = 'SELECT ':FN.ACCOUNT.CLOSED:' WITH @ID UNLIKE DOP... AND @ID UNLIKE USD... AND ACCT.CLOSE.DATE GT ':Y.DATE1:' AND ACCT.CLOSE.DATE LT ':Y.DATE2
            CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
        END
    END ELSE
        SEL.CMD = 'SELECT ':FN.ACCOUNT.CLOSED:' WITH @ID UNLIKE DOP... AND @ID UNLIKE USD...'
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    END

    CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,'SYSTEM',R.AI.REDO.ARCIB.PARAMETER,AI.ERR)
    Y.TYP = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.ACCOUNT.TYPE>
    LOCATE 'CURRENT' IN Y.TYP<1,1> SETTING POS.CR THEN
        Y.CAT.ST =  R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.CATEG.START,POS.CR>
        Y.CAT.END = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.CATEG.END,POS.CR>
    END

    FLG = ''
    LOOP
    WHILE NO.OF.REC GE 0 DO
        FLG += 1
        Y.AC = SEL.LIST<FLG>
        R.AC = ''
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HIS,Y.AC,R.AC,AC.ERR)
        IF R.AC THEN
            Y.CT = R.AC<AC.CATEGORY>
            IF Y.CT GE Y.CAT.ST AND Y.CT LE Y.CAT.END THEN
                GOSUB CASE.ANALYS
            END

        END
        NO.OF.REC -= 1
    REPEAT


RETURN


IDEN.OPR:

    BEGIN CASE

        CASE Y.OPD EQ '1'
            Y.OPDR = 'EQ'

        CASE Y.OPD EQ '4'
            Y.OPDR = 'GT'

        CASE Y.OPD EQ '3'
            Y.OPDR = 'LT'

        CASE Y.OPD EQ '9'
            Y.OPDR = 'GE'

        CASE Y.OPD EQ '8'
            Y.OPDR = 'LE'

        CASE Y.OPD EQ '2'
            Y.OPDR = 'RG'

    END CASE

RETURN

CASE.ANALYS:

    BEGIN CASE

        CASE Y.OF.SET EQ 'Y' AND Y.AG.SET EQ 'Y'
            IF Y.AC.OFI EQ R.AC<AC.ACCOUNT.OFFICER> AND Y.AG EQ R.AC<AC.CO.CODE> THEN
                GOSUB GET.AC.DETAILS
            END

        CASE Y.OF.SET EQ '' AND Y.AG.SET EQ ''
            GOSUB GET.AC.DETAILS

        CASE Y.OF.SET EQ 'Y' AND Y.AG.SET  EQ ''
            IF Y.AC.OFI EQ R.AC<AC.ACCOUNT.OFFICER> THEN
                GOSUB GET.AC.DETAILS
            END

        CASE Y.OF.SET EQ '' AND Y.AG.SET EQ 'Y'
            IF Y.AG EQ R.AC<AC.CO.CODE> THEN
                GOSUB GET.AC.DETAILS
            END

    END CASE

RETURN


GET.AC.DETAILS:

    Y.CLOSE.DATE = R.AC<AC.CLOSURE.DATE>
    Y.DATE.TIME = R.AC<AC.DATE.TIME>
    Y.OPEN.DATE = R.AC<AC.OPENING.DATE>

    Y.ACL = FIELD(Y.AC,';',1)
    CALL F.READ(FN.ACCOUNT.CLOSURE,Y.ACL,R.ACC.CL,F.ACCOUNT.CLOSURE,AC.CL.ER)
    IF R.ACC.CL THEN
        Y.REASON = R.ACC.CL<AC.ACL.LOCAL.REF,Y.REA.POS>
        Y.INPUT = R.ACC.CL<AC.ACL.INPUTTER>
        Y.ACL.CO.CODE = R.ACC.CL<AC.ACL.CO.CODE>
    END ELSE
        Y.REASON = R.AC<AC.LOCAL.REF,Y.RE.AC.PS>
        Y.INPUT = R.AC<AC.INPUTTER>
        Y.ACL.CO.CODE = R.AC<AC.CO.CODE>
    END
    IF Y.REASON THEN
        GOSUB GET.REASON
    END

    Y.AC.OFF = R.AC<AC.ACCOUNT.OFFICER>

    GOSUB GET.ONLINE.BAL

    Y.CATEG = R.AC<AC.CATEGORY>
    CALL CACHE.READ(FN.CATEGORY, Y.CATEG, R.CATEG, CAT.ERR) ;*AUTO R22 CODE CONVERSION
    Y.CAT.DESC = R.CATEG<EB.CAT.DESCRIPTION,LNGG>
    Y.CAT.DESC = CHANGE(Y.CAT.DESC,'*','')

    IF Y.CAT.DESC EQ '' THEN
        Y.CAT.DESC = R.CATEG<EB.CAT.DESCRIPTION,1>
        Y.CAT.DESC = CHANGE(Y.CAT.DESC,'*','')
    END

    Y.CUS = R.AC<AC.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,Y.CUS,R.CUS,F.CUSTOMER,CUS.ERR)
    Y.CUS.OFF = R.CUS<EB.CUS.ACCOUNT.OFFICER>
    IF LEN(Y.CUS.OFF) GE 8 THEN
        Y.V = LEN(Y.CUS.OFF)
        Y.FF = Y.CUS.OFF[1,-7]
        Y.CC = Y.FF[LEN(Y.FF)-1,1]:Y.FF[LEN(Y.FF),1]
    END ELSE
        Y.CC = Y.CUS.OFF
    END

    Y.CO.CODE = R.AC<AC.CO.CODE>
* Y.ACL.CO.CODE = R.ACC.CL<AC.ACL.CO.CODE>
* Y.INPUT = R.ACC.CL<AC.ACL.INPUTTER>

    Y.OT.PRODS = ''
    CALL F.READ(FN.REDO.CUST.PRD.LIST,Y.CUS,R.REDO.CUST.PRD.LIST,F.REDO.CUST.PRD.LIST,CUS.ERR)
    Y.PRD = R.REDO.CUST.PRD.LIST<PRD.PRODUCT.ID>
    Y.CND = DCOUNT(Y.PRD,@VM)
    FLD = ''
    LOOP
    WHILE Y.CND GT 0 DO
        FLD += 1
        IF R.REDO.CUST.PRD.LIST<PRD.PRD.STATUS,FLD> EQ 'ACTIVE' THEN
            Y.OT.PRODS<1,-1> = R.REDO.CUST.PRD.LIST<PRD.PRODUCT.ID,FLD>
        END
        Y.CND -= 1
    REPEAT



    Y.TEL.NO = R.CUS<EB.CUS.LOCAL.REF,Y.TEL.POS>
    Y.TEL.NO = CHANGE(Y.TEL.NO,@SM,@VM)
    GOSUB GET.TEL.NO

    Y.INT.RATES = ''
    GOSUB GET.INT.RATES

    Y.ALT.AC.ID = R.AC<AC.ALT.ACCT.ID>
    GOSUB MOD.ALT.ID

    Y.TIPO = R.CUS<EB.CUS.LOCAL.REF,Y.TIP.POS>
    Y.CURR = R.AC<AC.CURRENCY>
    Y.AUT = R.AC<AC.AUTHORISER>
    Y.FM.NAME = R.CUS<EB.CUS.NAME.1>: ' ' :R.CUS<EB.CUS.NAME.2>


    IF Y.FIN.ARR THEN
        Y.FIN.ARR<-1> = Y.CLOSE.DATE:'*':Y.DATE.TIME:'*':Y.OPEN.DATE:'*':Y.AC:'*':Y.MESSAGE:'*':Y.AC.OFF:'*':Y.ONLINE.BAL:'*':Y.CAT.DESC
        Y.FIN.ARR := '*':Y.CC:'*':Y.CO.CODE:'*':Y.ACL.CO.CODE:'*':Y.INPUT:'*':Y.OT.PRODS:'*':Y.TEL.VLS:'*':Y.INT.RATES
        Y.FIN.ARR := '*':Y.ALT.VLS:'*':Y.TIPO:'*':Y.CUS:'*':Y.CURR:'*':Y.AUT:'*':Y.FM.NAME:'*':Y.DT.STR

    END ELSE
        Y.FIN.ARR = Y.CLOSE.DATE:'*':Y.DATE.TIME:'*':Y.OPEN.DATE:'*':Y.AC:'*':Y.MESSAGE:'*':Y.AC.OFF:'*':Y.ONLINE.BAL:'*':Y.CAT.DESC
        Y.FIN.ARR := '*':Y.CC:'*':Y.CO.CODE:'*':Y.ACL.CO.CODE:'*':Y.INPUT:'*':Y.OT.PRODS:'*':Y.TEL.VLS:'*':Y.INT.RATES
        Y.FIN.ARR := '*':Y.ALT.VLS:'*':Y.TIPO:'*':Y.CUS:'*':Y.CURR:'*':Y.AUT:'*':Y.FM.NAME:'*':Y.DT.STR
    END

RETURN

MOD.ALT.ID:

    Y.ALT.VLS = ''
    Y.ALT.CNT = DCOUNT(Y.ALT.AC.ID,@VM)
    ALT = ''
    LOOP
    WHILE Y.ALT.CNT GT 0 DO
        ALT += 1
        Y.ALT.VL = Y.ALT.AC.ID<1,ALT>
        GOSUB IDEN.ALT.ID
        Y.ALT.CNT -= 1
    REPEAT

RETURN

IDEN.ALT.ID:

    IF Y.ALT.VL THEN
        LOCATE Y.ALT.VL IN Y.ALT.VLS<1,1> SETTING PS.ALT ELSE
            IF Y.ALT.VLS THEN
                Y.ALT.VLS<1,-1> = Y.ALT.VL
            END ELSE
                Y.ALT.VLS = Y.ALT.VL
            END
        END
    END

RETURN

GET.TEL.NO:

    Y.TEL.VLS = ''
    Y.TEL.CNT = DCOUNT(Y.TEL.NO,@VM)
    TEL = ''
    LOOP
    WHILE Y.TEL.CNT GT 0 DO
        TEL += 1
        Y.TEL.VL = Y.TEL.NO<1,TEL>
        GOSUB IDEN.TEL.ID
        Y.TEL.CNT -= 1
    REPEAT

RETURN

IDEN.TEL.ID:

    IF Y.TEL.VL THEN
        LOCATE Y.TEL.VL IN Y.TEL.VLS<1,1> SETTING PS.TEL ELSE
            IF Y.TEL.VLS THEN
                Y.TEL.VLS<1,-1> = Y.TEL.VL
            END ELSE
                Y.TEL.VLS = Y.TEL.VL
            END
        END
    END

RETURN

GET.ONLINE.BAL:

    Y.HIS.CN = FIELD(Y.AC,';',2)
    Y.TOT.HIS = Y.HIS.CN
    FLM = ''
    LOOP
    WHILE  Y.HIS.CN GT 0 DO
        FLM += 1
        Y.HIS.CNV = Y.TOT.HIS - FLM
        Y.LV.R = Y.ACL:';':Y.HIS.CNV
        CALL F.READ(FN.ACCOUNT.HIS,Y.LV.R,R.AC.HIS,F.ACCOUNT.HIS,HIS.ER)
        IF R.AC.HIS<AC.RECORD.STATUS> NE 'CLOSED' THEN
            Y.ONLINE.BAL = R.AC.HIS<AC.LOCAL.REF,Y.AV.BAL.POS>
* Y.ONLINE.BAL = R.AC<AC.ONLINE.ACTUAL.BAL>
            Y.HIS.CN = 0
        END
        Y.HIS.CN -= 1
    REPEAT

RETURN

GET.REASON:

    VIRTUAL.TAB.ID = 'L.AC.CAN.REASON'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
    Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
    Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC
    Y.REASON = CHANGE(Y.REASON,@SM,@VM)
    Y.DND = DCOUNT(Y.REASON,@VM)

    Y.FND = ''
    LOOP
    WHILE Y.DND GT 0 DO
        Y.FND += 1
        LOCATE Y.REASON<1,Y.FND> IN Y.LOOKUP.LIST SETTING POS1 THEN
            IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN        ;* This is for english user
                Y.MESSAGE=Y.LOOKUP.DESC<POS1,1>
            END
            IF R.USER<EB.USE.LANGUAGE> EQ 2 AND Y.LOOKUP.DESC<POS1,2> NE '' THEN
                Y.MESSAGE=Y.LOOKUP.DESC<POS1,2> ;* This is for spanish user
            END ELSE
                Y.MESSAGE=Y.LOOKUP.DESC<POS1,1>
            END
        END
        Y.DND -= 1
    REPEAT

RETURN

GET.INT.RATES:

    Y.ACI.DATE=R.AC<AC.ACCT.CREDIT.INT>
    IF Y.ACI.DATE EQ '' THEN
        Y.ACI.ID=''
    END ELSE
        Y.ACI.ID = Y.ACL:'-':Y.ACI.DATE<1,DCOUNT(Y.ACI.DATE,@VM)>
    END

    Y.ACI.CUR=R.AC<AC.CURRENCY>

    CALL EB.READ.HISTORY.REC(F.ACCOUNT.CREDIT.INT.HIS,Y.ACI.ID,R.ACCOUNT.CREDIT.INT,AC.ERR)

    IF R.ACCOUNT.CREDIT.INT THEN
        Y.ACI.ID = FIELD(Y.ACI.ID,';',1)
*APAP.TAM.REDO.GET.ACI.HIS(R.ACCOUNT.CREDIT.INT,Y.ACI.CUR,Y.INT.RATES) ;*MANUAL R22 CODE CONVERSION
        APAP.TAM.redoGetAciHis(R.ACCOUNT.CREDIT.INT,Y.ACI.CUR,Y.INT.RATES) ;*MANUAL R22 CODE CONVERSION
    END ELSE
        GOSUB GET.GCI
    END

RETURN

GET.GCI:

    Y.CONDITION.GROUP = R.AC<AC.CONDITION.GROUP>
    Y.GCI.CUR = R.AC<AC.CURRENCY>
    Y.COND.AND.CURR = Y.CONDITION.GROUP:Y.GCI.CUR
    CALL CACHE.READ(FN.GROUP.DATE, Y.COND.AND.CURR, R.GROUP.DATE, GROUP.ERR) ;*AUTO R22 CODE CONVERSION
    Y.GCI.ID=Y.COND.AND.CURR:R.GROUP.DATE<AC.GRD.CREDIT.GROUP.DATE>

*APAP.TAM.REDO.GET.HIGH.GCI(Y.GCI.ID,Y.GCI.CUR,Y.INT.RATES) ;*MANUAL R22 CODE CONVERSION
    APAP.TAM.redoGetHighGci(Y.GCI.ID,Y.GCI.CUR,Y.INT.RATES) ;*MANUAL R22 CODE CONVERSION

RETURN

PROCESS.END:

END
