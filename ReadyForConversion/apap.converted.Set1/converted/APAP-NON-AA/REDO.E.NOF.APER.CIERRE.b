SUBROUTINE REDO.E.NOF.APER.CIERRE(Y.FIN.ARRAY)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.CATEGORY
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.USER
    $INSERT I_F.DATES
*
*
    GOSUB INITS
    GOSUB SEL.PROCESS
    GOSUB FORM.DATA

*
*  Sort the output array generated.
*
    Y.FIN.ARRAY = CHANGE(Y.FIN.ARRAY, @VM, '**********')
    Y.FIN.ARRAY = CHANGE(Y.FIN.ARRAY, @SM, '$$$$$$$$$$')
    Y.FIN.ARRAY = SORT(Y.FIN.ARRAY)
    Y.FIN.ARRAY = CHANGE(Y.FIN.ARRAY, '**********', @VM)
    Y.FIN.ARRAY = CHANGE(Y.FIN.ARRAY, '$$$$$$$$$$', @SM)

RETURN
*------------------------------------
SEL.PROCESS:
*-----------

    Y.SEL.STRING  = 'SELECT ':FN.AZ.ACCOUNT
    Y.AGENCY = ''; Y.EL.REGION = ''; Y.CATEGORY = ''
    LOCATE 'AGENCIA' IN D.FIELDS<1> SETTING Y.AGENCIA.POS THEN
        Y.AGENCY = D.RANGE.AND.VALUE<Y.AGENCIA.POS>
        IF Y.AGENCY THEN
            Y.SEL.STRING := ' WITH CO.CODE EQ ':Y.AGENCY
            Y.CLASSIFICATION := "Agencia :":Y.AGENCY:'; '
        END
    END
    LOCATE 'REGION' IN D.FIELDS<1> SETTING Y.SEL.REG.POS THEN
        Y.SEL.REGION = D.RANGE.AND.VALUE<Y.SEL.REG.POS>
        IF Y.SEL.REGION THEN
            Y.CLASSIFICATION := 'Region : ':Y.SEL.REGION:'; '
        END
    END


    LOCATE 'TIPO.INV' IN D.FIELDS<1> SETTING Y.CATEGORY.POS THEN
        Y.CATEGORY = D.RANGE.AND.VALUE<Y.CATEGORY.POS>
        IF Y.CATEGORY AND NOT(Y.AGENCY) THEN
            Y.SEL.STRING := ' WITH CATEGORY EQ ':Y.CATEGORY
            Y.CLASSIFICATION := 'Tipo de Inversion :':Y.CATEGORY:'; '
        END
        IF Y.CATEGORY AND Y.AGENCY THEN
            Y.SEL.STRING := ' AND CATEGORY EQ ':Y.CATEGORY
            Y.CLASSIFICATION := 'Tipo de Inversion :':Y.CATEGORY:'; '
        END
    END

    YLWD.DTE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    LOCATE 'FECHA' IN D.FIELDS<1> SETTING Y.FECHA.POS THEN
        Y.DATES = D.RANGE.AND.VALUE<Y.FECHA.POS>
        Y.DATE.OPERAND = D.LOGICAL.OPERANDS<Y.FECHA.POS>
        GOSUB LOCATE.DATE.VALIDATION
        IF Y.START.DATE AND Y.END.DATE AND NOT(Y.CATEGORY) AND NOT(Y.AGENCY) THEN
            Y.SEL.STRING := ' WITH (CREATE.DATE GE ':Y.START.DATE:' AND CREATE.DATE LE ':Y.END.DATE:')'
        END ELSE
            Y.SEL.STRING := ' AND (CREATE.DATE GE ':Y.START.DATE:' AND CREATE.DATE LE ':Y.END.DATE:')'
        END
    END ELSE
        IF NOT(Y.CATEGORY) AND NOT(Y.AGENCY) THEN
            Y.SEL.STRING := ' WITH (CREATE.DATE EQ ':YLWD.DTE:')'
        END ELSE
            Y.SEL.STRING := ' AND (CREATE.DATE EQ ':YLWD.DTE:')'
        END
    END

    CALL EB.READLIST(Y.SEL.STRING, R.SEL.AZ.IDS, '', NO.OF.RECAZ, '')
    GOSUB GET.CLOSED.AZ.IDS
    Y.FINAL.LIST = R.SEL.AZ.IDS:@FM:R.AZ.HIST.IDS
    YTOT.CNT = NO.OF.RECAZ + YHIST.CNT

* In case if nothing is selected in the main select
    IF Y.FINAL.LIST<1> EQ '' THEN
        DEL Y.FINAL.LIST<1>
    END
RETURN
*-------------------------------------

LOCATE.DATE.VALIDATION:
*----------------------
    Y.START.DATE = FIELD(Y.DATES, @SM, 1)
    Y.END.DATE = FIELD(Y.DATES, @SM, 2)
    IF NOT(Y.END.DATE) AND Y.START.DATE THEN
        Y.END.DATE = Y.START.DATE
    END
    IF NOT(Y.END.DATE) AND NOT(Y.START.DATE) THEN
        Y.START.DATE = YLWD.DTE
        Y.END.DATE = YLWD.DTE
    END

    CALL EB.DATE.FORMAT.DISPLAY(Y.START.DATE, Y.START.DATE.FMT, '', '')
    CALL EB.DATE.FORMAT.DISPLAY(Y.END.DATE, Y.END.DATE.FMT, '', '')
    Y.CLASSIFICATION := 'Fecha : ':Y.START.DATE.FMT:' a ':Y.END.DATE.FMT

    IF NOT(Y.START.DATE) OR NOT(Y.END.DATE) THEN
        ENQ.ERROR = 'AZ-ENTER.BOTH.DATES'
    END
    IF Y.START.DATE GT Y.END.DATE THEN
        ENQ.ERROR = 'AZ-ST.DATE.GT.END.DATE'
    END
RETURN
*------------------------------------
INITS:
*-----
*
* Initialisation
*
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'; F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT, F.AZ.ACCOUNT)

    FN.AZ.ACCT.BAL.HIST = 'F.AZ.ACCT.BAL.HIST'; F.AZ.ACCT.BAL.HIST = ''
    CALL OPF(FN.AZ.ACCT.BAL.HIST, F.AZ.ACCT.BAL.HIST)

    FN.EB.LOOKUP = 'F.EB.LOOKUP'; F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP, F.EB.LOOKUP)

    FN.ACCOUNT$HIS = 'F.ACCOUNT$HIS'; F.ACCOUNT$HIS = ''
    CALL OPF(FN.ACCOUNT$HIS, F.ACCOUNT$HIS)

    FN.AZ.ACCOUNT$HIS = 'F.AZ.ACCOUNT$HIS'; F.AZ.ACCOUNT$HIS = ''
    CALL OPF(FN.AZ.ACCOUNT$HIS, F.AZ.ACCOUNT$HIS)

    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.CATEGORY = 'F.CATEGORY'; F.CATEGORY = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    FN.STMT.ENTRY = 'F.STMT.ENTRY'; F.STMT.ENTRY = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.STMT.ENTRY.DETAIL = 'F.STMT.ENTRY.DETAIL'; F.STMT.ENTRY.DETAIL  = ''
    CALL OPF(FN.STMT.ENTRY.DETAIL,F.STMT.ENTRY.DETAIL)

    FN.ACCOUNT.CLOSURE = 'F.ACCOUNT.CLOSURE'; F.ACCOUNT.CLOSURE = ''
    CALL OPF(FN.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE)

    FN.USER = 'F.USER'; F.USER = ''
    CALL OPF(FN.USER,F.USER)

    FN.USER.HST = 'F.USER$HIS'; F.USER.HST = ''
    CALL OPF(FN.USER.HST,F.USER.HST)
    YTOT.CNT = 0
    GOSUB LOC.REF.INIT
RETURN

LOC.REF.INIT:

*------------


    Y.APP.LIST = 'CUSTOMER':@FM:'AZ.ACCOUNT':@FM:'ACCOUNT':@FM:'USER'
    Y.FIELD.LIST = 'L.CU.TIPO.CL':@FM:'L.AZ.METHOD.PAY':@VM:'L.AZ.AMOUNT':@VM:'L.AC.CAN.REASON':@VM:'L.TYPE.INT.PAY':@VM:'L.AZ.ORG.DP.AMT':@VM:'ORIG.DEP.AMT':@VM:'L.AZ.DEP.NAME':@VM:'L.AZ.PENAL.AMT':@FM:'L.AC.REINVESTED':@FM:'L.US.IDC.BR'
    Y.LOC.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APP.LIST, Y.FIELD.LIST, Y.LOC.POS)
    Y.CL.TYPE.POS = Y.LOC.POS<1,1>
    Y.AZ.METHOD.POS = Y.LOC.POS<2,1>
    Y.AZ.AMT.POS = Y.LOC.POS<2,2>
    Y.CAN.REASON.POS = Y.LOC.POS<2,3>
    Y.TYPE.INTPAY.POS = Y.LOC.POS<2,4>
    L.AZ.ORG.DP.AMT.POS = Y.LOC.POS<2,5>
    ORIG.DEP.AMT.POS = Y.LOC.POS<2,6>
    L.AZ.DEP.NAME.POS = Y.LOC.POS<2,7>
    L.AZ.PENAL.AMT.POS = Y.LOC.POS<2,8>
    L.AC.REINVESTED.POS = Y.LOC.POS<3,1>
    L.US.IDC.BR.POS = Y.LOC.POS<4,1>
RETURN

GET.CLOSED.AZ.IDS:
*------------------
*
* Get the Closed deposit IDs
*
    YHIST.CNT = ''; R.AZ.HIST.IDS = ''
    IF Y.START.DATE AND Y.END.DATE THEN
        Y.SEL.AZ.HIST = 'SELECT ':FN.AZ.ACCT.BAL.HIST:" WITH NOTES EQ 'CONTRACT CLOSED' AND DATE GE ":Y.START.DATE:" AND DATE LE ":Y.END.DATE
    END ELSE
        Y.SEL.AZ.HIST = 'SELECT ':FN.AZ.ACCT.BAL.HIST:" WITH NOTES EQ 'CONTRACT CLOSED' AND DATE EQ ":YLWD.DTE
    END
    CALL EB.READLIST(Y.SEL.AZ.HIST, R.AZ.HIST.IDS, '', YHIST.CNT,'')
* Seperate the AZ id from the selected ID
RETURN

FORM.DATA:
*----------

    FLG = 0
    LOOP
        REMOVE Y.AZ.ID FROM Y.FINAL.LIST SETTING Y.AZ.ID.POS
    WHILE Y.AZ.ID:Y.AZ.ID.POS
        Y.CLOSE.DATE = ''; Y.OPENING.DATE = ''; Y.OPEN.TDATE = ''; Y.CLOSUR.DATE = ''
        IF LEN(Y.AZ.ID) NE 10 THEN
            Y.CLOSE.DATE = FIELDS(Y.AZ.ID, '-', 2)
            Y.AZ.ID = FIELDS(Y.AZ.ID, '-', 1)
        END
        FLG += 1
        GOSUB CLEAR.VARS      ;* Clear variables for every line
        GOSUB READ.RECORDS
        CRT "Procesamiento de registro - ":FLG:"/":YTOT.CNT
        IF YAZ.HIST EQ 0 THEN
            CONTINUE
        END
        IF Y.CLOSE.DATE EQ Y.OPENING.DATE THEN
            CONTINUE
        END
* For the cancelled deposits
        IF Y.AGENCY AND (Y.AGENCY NE R.AZ.ACCOUNT<AZ.CO.CODE>) THEN
            CONTINUE
        END
        IF Y.CATEGORY AND (Y.CATEGORY NE R.AZ.ACCOUNT<AZ.CATEGORY>) THEN
            CONTINUE
        END
        GOSUB FORM.DATA.SUB
        IF Y.SEL.REGION AND (Y.SEL.REGION NE Y.REGION) THEN
            CONTINUE
        END
        GOSUB FORM.PROCESS.2
        GOSUB FOR.CANCELLED.DEP
*        Y.AGN.EXEC = Y.AGENCIA:'-':Y.DEPT.CODE
        YLOC.AMT = R.ACCOUNT<AC.LOCKED.AMOUNT>
        YLOCK.CNT = DCOUNT(YLOC.AMT,@VM)
        YLOC.AMT.VAL = R.ACCOUNT<AC.LOCKED.AMOUNT,YLOCK.CNT>
        Y.INPUTTER = FIELD(R.AZ.ACCOUNT<AZ.INPUTTER>, '_', 2,1)
        Y.AUTHORISER = FIELD(R.AZ.ACCOUNT<AZ.AUTHORISER>, '_', 2, 1)
        USER.ERR = ''; R.USER = ''
        CALL CACHE.READ(FN.USER, Y.AUTHORISER, R.USER, USER.ERR)
        IF NOT(R.USER) THEN
            Y.INPUTTER.HST = Y.AUTHORISER
            CALL EB.READ.HISTORY.REC(F.USER.HST,Y.INPUTTER.HST,R.USER.HST,USER.ERR)
        END
*        Y.AGN.EXEC = R.USER<EB.USE.CO.CODE>
        Y.AGN.EXEC = R.USER<EB.USE.LOCAL.REF,L.US.IDC.BR.POS>
        Y.CCY = R.AZ.ACCOUNT<AZ.CURRENCY>
        Y.OUT.ARRAY = Y.CCY:'*':Y.AGENCIA:'*':Y.OPENING.DATE:'*':Y.OPENING.DATE:'*':Y.AGENCIA:'*':Y.EXECUTIVE:'*':Y.REGION:'*':Y.DEP.NAME:'*':Y.CCY:'*':Y.INV.NUM:'*':Y.INV.NUM.LEGACY
        Y.OUT.ARRAY := '*':Y.BENEFICIARY:'*':Y.ID.CLIENTES:'*':Y.INV.AMT:'*':Y.PLAZO:'*':Y.TASA.INT:'*':Y.VENCIMIENTO:'*':Y.FECHA.CANCEL:'*':Y.MONTO.CANCEL:'*':Y.CANCEL.MODE
        Y.OUT.ARRAY := '*':Y.CANCEL.MOTIVE:'*':Y.AGN.EXEC:'*':YLOC.AMT.VAL:'*':Y.PEN.AMT:'*':Y.INPUTTER:'*':Y.AUTHORISER:'*':Y.CLASSIFICATION
        Y.FIN.ARRAY<-1> = Y.OUT.ARRAY
    REPEAT
RETURN

FORM.DATA.SUB:
**************
    Y.DEP.OPEN.DATE = Y.OPENING.DATE
    Y.AGENCIA = R.AZ.ACCOUNT<AZ.CO.CODE>
    Y.DEPT.CODE = R.AZ.ACCOUNT<AZ.DEPT.CODE>
    Y.EXECUTIVE = R.ACCOUNT<AC.ACCOUNT.OFFICER>
    IF Y.EXECUTIVE THEN
        Y.ACC.OFF.VAL = Y.EXECUTIVE[8]
    END
    IF LEN(Y.ACC.OFF.VAL) LT 7 THEN
        Y.REGION = ""
    END ELSE
        Y.REGION = Y.ACC.OFF.VAL[1,2]
    END
RETURN

READ.RECORDS:
*-------------
    R.ACCOUNT = ''; Y.READ.ERR = ''; YAZ.HIST = 0
    CALL F.READ(FN.ACCOUNT, Y.AZ.ID, R.ACCOUNT, F.ACCOUNT, Y.READ.ERR)
* In case if the Base account is closed, read from History
    IF NOT(R.ACCOUNT) THEN
        Y.AC.HIST.ID = Y.AZ.ID:';1'
        CALL F.READ(FN.ACCOUNT$HIS, Y.AC.HIST.ID, R.ACCOUNT, F.ACCOUNT$HIS, Y.READ.ERR)
    END
* Get the correct closing value.
    GOSUB GET.CLOSURE.DATE
    Y.READ.ERR = '';    R.AZ.ACCOUNT = ''
    CALL F.READ(FN.AZ.ACCOUNT, Y.AZ.ID, R.AZ.ACCOUNT , F.AZ.ACCOUNT , Y.READ.ERR)
* If the deposit is matured, read from history
    IF NOT(R.AZ.ACCOUNT) THEN
        Y.AZ.HIST.ID = Y.AZ.ID
        CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT$HIS, Y.AZ.HIST.ID, R.AZ.ACCOUNT, Y.READ.ERR)
        YAZ.HIST = 1
    END
    Y.OPENING.DATE = R.AZ.ACCOUNT<AZ.CREATE.DATE>
    Y.AC.CLOSURE.DATE = R.ACCOUNT.HIS<AC.CLOSURE.DATE>
    Y.OPEN.TDATE = Y.OPENING.DATE
    IF (Y.OPEN.TDATE GE Y.START.DATE AND Y.OPEN.TDATE LE Y.END.DATE) AND (YAZ.HIST NE 1 AND Y.CLOSE.DATE EQ '') THEN
        YAZ.HIST = 1
    END
RETURN

FORM.PROCESS.2:
*-----------------


    Y.INV.CATEG = R.AZ.ACCOUNT<AZ.CATEGORY>
    CALL CACHE.READ(FN.CATEGORY, Y.INV.CATEG, R.CATEG, CATEG.ERR)
    Y.INV.TYPE=R.CATEG<EB.CAT.DESCRIPTION>

    Y.INV.NUM = Y.AZ.ID
    Y.INV.NUM.LEGACY = R.ACCOUNT<AC.ALT.ACCT.ID>


    GOSUB GET.BENEFICIARY
    Y.BENEFICIARY = Y.CUS.NAMES.ALL
    Y.ID.CLIENTES = Y.JOINT.HOLDER


    Y.BENEFICIARY = CHANGE(Y.BENEFICIARY, @VM, '; ')
    Y.ID.CLIENTES = CHANGE(Y.ID.CLIENTES, @VM, '; ')
    Y.PLAZO = R.AZ.ACCOUNT<AZ.ROLLOVER.TERM>
    Y.TASA.INT = R.AZ.ACCOUNT<AZ.INTEREST.RATE>
    Y.VENCIMIENTO = R.AZ.ACCOUNT<AZ.MATURITY.DATE>
    Y.DEP.NAME = R.AZ.ACCOUNT<AZ.CATEGORY>
*Y.DEP.NAME = R.AZ.ACCOUNT<AZ.LOCAL.REF,L.AZ.DEP.NAME.POS>
    Y.PEN.AMT = R.AZ.ACCOUNT<AZ.LOCAL.REF,L.AZ.PENAL.AMT.POS>
RETURN

GET.BENEFICIARY:
*---------------
*
*  Get the ID and name of the Joint account holders
*
    Y.JOINT.HOLDER = R.ACCOUNT<AC.JOINT.HOLDER>
    Y.ACC.CUST.ID = R.ACCOUNT<AC.CUSTOMER>
    Y.JOINT.HOLDER = INSERT(Y.JOINT.HOLDER, 1,1;Y.ACC.CUST.ID)
    Y.JOINT.HOLDER.LIST = Y.JOINT.HOLDER

    LOOP
        REMOVE Y.HOLDER.ID FROM Y.JOINT.HOLDER.LIST SETTING Y.HOLDER.POS
    WHILE Y.HOLDER.ID:Y.HOLDER.POS
        R.HOLDER = ''
        CALL F.READ(FN.CUSTOMER, Y.HOLDER.ID, R.HOLDER, F.CUSTOMER, Y.READ.ERR)

        IF R.HOLDER<EB.CUS.LOCAL.REF,Y.CL.TYPE.POS> EQ "PERSONA FISICA" OR R.HOLDER<EB.CUS.LOCAL.REF,Y.CL.TYPE.POS> EQ "CLIENTE MENOR" THEN
            Y.CUS.NAMES = R.HOLDER<EB.CUS.GIVEN.NAMES>:" ":R.HOLDER<EB.CUS.FAMILY.NAME>
        END
        IF R.HOLDER<EB.CUS.LOCAL.REF,Y.CL.TYPE.POS> EQ "PERSONA JURIDICA" THEN
            Y.CUS.NAMES = R.HOLDER<EB.CUS.NAME.1,1>:" ":R.HOLDER<EB.CUS.NAME.2,1>
        END
        IF NOT(R.HOLDER<EB.CUS.LOCAL.REF,Y.CL.TYPE.POS>) THEN
            Y.CUS.NAMES = R.HOLDER<EB.CUS.SHORT.NAME,1>
        END

        Y.CUS.NAMES.ALL<1,-1> = Y.CUS.NAMES
    REPEAT
RETURN

GET.CANCEL.MODE.DESC:
*--------------------
*
* Get the description for Cancel mode
*
    Y.LOOKUP.TEMP.LIST = ''
    LOOP
        REMOVE Y.CANCEL.MODE.VAL FROM Y.CANCEL.MODE SETTING Y.CANCEL.MODE.POS
    WHILE Y.CANCEL.MODE.VAL:Y.CANCEL.MODE.POS
        Y.LOOKUP.ID = 'L.AZ.METHOD.PAY*':Y.CANCEL.MODE.VAL

        R.LOOKUP = ''
        CALL F.READ(FN.EB.LOOKUP, Y.LOOKUP.ID, R.LOOKUP, F.EB.LOOKUP, Y.READ.ERR)
        Y.CANCEL.MODE.TEMP = R.LOOKUP<EB.LU.DESCRIPTION,LNGG>

        IF NOT(Y.CANCEL.MODE.TEMP) THEN
            Y.CANCEL.MODE.TEMP = R.LOOKUP<EB.LU.DESCRIPTION, 1>
        END
        Y.LOOKUP.TEMP.LIST<1, -1> = Y.CANCEL.MODE.TEMP
    REPEAT

    Y.CANCEL.MODE = Y.LOOKUP.TEMP.LIST
RETURN
*-----------------------------------
GET.CANCEL.MOTIVE.DESC:
*----------------------
*
* To get the description for Cancel Reason
*
    Y.CM.LOOKUP.ID = 'L.AC.CAN.REASON*':Y.CANCEL.MOTIVE
    R.CM.LOOKUP = ''
    CALL F.READ(FN.EB.LOOKUP, Y.CM.LOOKUP.ID, R.CM.LOOKUP, F.EB.LOOKUP, Y.READ.ERR)
    Y.CANCEL.MOTIVE = R.CM.LOOKUP<EB.LU.DESCRIPTION,LNGG>

    IF NOT(Y.CANCEL.MOTIVE) THEN
        Y.CANCEL.MOTIVE = R.CM.LOOKUP<EB.LU.DESCRIPTION, 1>
    END
RETURN
*-----------------------------------
FOR.CANCELLED.DEP:
*-----------------
*
* If the deposit is cancelled, fetch related values
*
    Y.INV.AMT = R.AZ.ACCOUNT<AZ.ORIG.PRINCIPAL>
    IF NOT(Y.INV.AMT) THEN
        Y.INV.AMT = R.AZ.ACCOUNT<AZ.PRINCIPAL>
    END
    IF R.AZ.ACCOUNT<AZ.RECORD.STATUS> EQ 'MAT' THEN
        Y.FECHA.CANCEL = Y.CLOSE.DATE
        IF NOT(Y.CLOSE.DATE) THEN
            Y.FECHA.CANCEL = Y.AC.CLOSURE.DATE
        END
        CALL REDO.GET.AZCANCEL.AMT.MODE(R.AZ.ACCOUNT,Y.AZ.ID,CANCEL.AMT,CANCEL.MODE)
        Y.MONTO.CANCEL = ABS(CANCEL.AMT)
        Y.CANCEL.MODE = CANCEL.MODE
        Y.CANCEL.MOTIVE = R.AZ.ACCOUNT<AZ.LOCAL.REF, Y.CAN.REASON.POS>
        GOSUB GET.CANCEL.MOTIVE.DESC
    END ELSE
        Y.FECHA.CANCEL  = '';  Y.MONTO.CANCEL = ''; Y.CANCEL.MODE = ''; Y.CANCEL.MOTIVE = ''
    END
RETURN
*-----------------------------------
CLEAR.VARS:
*----------
*
* Clear the variables
*
    Y.JOINT.HOLDER = '';    Y.OUT.ARRAY = '';    Y.OPENING.DATE = '';    Y.AGENCIA = '';    Y.EXECUTIVE = '';    Y.REGION = ''
    Y.INV.TYPE = ''; Y.CCY = '';    Y.INV.NUM = '';    Y.INV.NUM.LEGACY = '';    Y.OUT.ARRAY = '';    Y.BENEFICIARY = ''
    Y.ID.CLIENTES = '';    Y.INV.AMT = '';    Y.PLAZO = '';    Y.TASA.INT = '';    Y.VENCIMIENTO = ''; Y.DEP.NAME = ''
    Y.MONTO.CANCEL = '';   Y.CANCEL.MODE = '';    Y.OUT.ARRAY = '';    Y.CANCEL.MOTIVE = '';    Y.AGN.EXEC = ''; Y.PEN.AMT = ''
    Y.INPUTTER = '';    Y.AUTHORISER = '';    Y.CUS.NAMES.ALL = '';    Y.READ.ERR = '';    R.ACCOUNT = ''; Y.INV.AMT = ''
    YLOC.AMT.VAL = ''; YLOC.AMT = ''; YLOCK.CNT = 0
RETURN


GET.CLOSURE.DATE:
    ACCOUNT.ID.HIS = Y.AZ.ID
    CALL EB.READ.HISTORY.REC(F.ACCOUNT$HIS,ACCOUNT.ID.HIS,R.ACCOUNT.HIS,AC.HIS.ERROR)
RETURN
*
* Program end
*
END