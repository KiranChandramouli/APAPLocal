* @ValidationCode : MjotODYxMDEzODk3OkNwMTI1MjoxNjgxNzI4NTY5NzU4OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Apr 2023 16:19:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.INSMT.PRT(Y.OUT.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.APAP.NOF.INSMT.PRT
*--------------------------------------------------------------------------------------------------------
*Description       : This is a NO-FILE enquiry routine, the routine based on the selection criteria selects
*                     the records from AZ.ACCOUNT & ACCOUNT and displays the processed records
*In Parameter      :
*Out Parameter     : Y.OUT.ARRAY
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference                      Description
*   ------         ------               -------------                    -------------
*  28/09/2010     Arul prakasam p       ODR-2010-03-0183                   Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM ,SMto @SM,=to EQ,++ to +=
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.COLLATERAL
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.RELATION
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.INT.PAY.METHOD
    $INSERT I_F.CATEGORY

    Y.OUT.ARRAY = ''

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB MAIN.PARA

    IF Y.OUT.ARRAY THEN

        Y.OUT.ARRAY = CHANGE(Y.OUT.ARRAY, @VM, '#######')
        Y.OUT.ARRAY = CHANGE(Y.OUT.ARRAY, @SM, '@@@@@@@')

        Y.OUT.ARRAY = SORT(Y.OUT.ARRAY)

        Y.OUT.ARRAY = CHANGE(Y.OUT.ARRAY, '#######', @VM)
        Y.OUT.ARRAY = CHANGE(Y.OUT.ARRAY, '@@@@@@@', @SM)
*        Y.OUT.ARRAY = FIELDS(Y.OUT.ARRAY, '*', 3, 499)

    END

RETURN

*******
INIT:
*******
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''

    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLATERAL = ''

    FN.ACCT.ACTIVITY = 'F.ACCT.ACTIVITY'
    F.ACCT.ACTIVITY = ''

    FN.RELATION = 'F.RELATION'
    F.RELATION = ''

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP, F.EB.LOOKUP)

    FN.CATEGORY = 'F.CATEGORY'
    F.CATEGORY = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    FN.AZ.INT.PAY.METHOD = 'F.AZ.INT.PAY.METHOD'
    F.AZ.INT.PAY.METHOD = ''
    CALL OPF(FN.AZ.INT.PAY.METHOD, F.AZ.INT.PAY.METHOD)

    Y.PAY.METHOD.POS = '' ; Y.CLIENT.TYPE.POS = '' ; Y.INVEST.TYPE.POS = '' ; Y.ARR.ID1 = '' ; Y.AGENCY = '' ; Y.INVEST.TYPE = '' ;
    Y.CURRENCY = '' ; Y.BDY.AMOUNT = '' ; Y.PAY.METHOD = '' ; Y.BDY.TERM = '' ; Y.AZ.SORT.VAL = '' ; Y.SORT.ARR = '' ; Y.PRINCIPAL = ''
    Y.WORK.BAL = '' ;  Y.BDY.CURR.BAL = '' ; Y.BDY.PLEDGED.AMT = '' ; REGION.CODE = '' ; Y.CUS = '' ; Y.ACC.LIST = '' ; Y.REINVESTED.DEPOSIT = ''
    TRNS.THREE.POS = '' ; Y.BDY.CUSTOMER.NAME = '' ; Y.CATEGORY = ''  ; Y.BDY.REGION = ''
    Y.BDY.NOTIFICATION = ''
    Y.DIFF = 'C'
    GOSUB GET.LOCAL.REF

RETURN

**********
OPENFILES:
**********

    CALL OPF(FN.AZ.ACCOUNT, F.AZ.ACCOUNT)
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
    CALL OPF(FN.ACCT.ACTIVITY,F.ACCT.ACTIVITY)
    CALL OPF(FN.RELATION,F.RELATION)
RETURN

**********
MAIN.PARA:
**********


    SEL.CMD.AZ = 'SELECT ':FN.AZ.ACCOUNT
*    SEL.CMD.CUS = 'SELECT ':FN.CUSTOMER:' WITH @ID'

    GOSUB SEL.STMT.FORMATION

*    GOSUB GET.SORTED.IDS

    LOOP
        Y.AC.FLAG = ''
        Y.INCL.FLAG = ''
        Y.CLI.TYPE = ''
        REMOVE Y.AZ.ID FROM SEL.LIST.AZ1 SETTING POS
    WHILE Y.AZ.ID:POS

        Y.BDY.NOTIFICATION = ''
        GOSUB GET.REGION

        IF Y.CLIENT.CODE THEN
            Y.BDY.CUSTOMER = Y.CLIENT.CODE
        END

        IF Y.INCL.FLAG EQ 'N' ELSE

            Y.OUT.ARRAY<-1> = Y.BDY.CURRENCY:'*':Y.BDY.INV.TYPE:'*':Y.BDY.AGENCY:'*':Y.BDY.ACCT.EXE:'*':Y.BDY.REGION:'*':Y.BDY.INV.TYPE:'*':Y.BDY.PRE.INV.NO:"*":Y.BDY.INV.NO:"*":Y.BDY.CUSTOMER.NAME:"*":Y.BDY.CUSTOMER:"*":Y.LIST.CUST.TYPE:"*":Y.BDY.OPENING.DATE:"*":Y.BDY.CURRENCY:"*":Y.BDY.AMOUNT:"*":Y.BDY.TERM:"*":Y.BDY.INTEREST.RATE:"*":Y.BDY.MATURITY.DATE:"*":Y.BDY.INT.MTD.PAY:"*":Y.BDY.INT.PAYDATE:'*':Y.BDY.CDT.ACCT.NO:"*":Y.BDY.CURR.BAL:"*":Y.BDY.ACR.INT:"*":Y.BDY.STATUS:"*":Y.BDY.NOTIFICATION:"*":Y.BDY.PLEDGED.AMT:"*":Y.BDY.CANCELLATION.DATE:"*":Y.BDY.CANCELLATION.AMT:"*":Y.BDY.ROLLOVER.DATE:"*":STATUS1:"*":STATUS2

            Y.PAY.METHOD.POS = '' ; Y.CLIENT.TYPE.POS = '' ; Y.INVEST.TYPE.POS = '' ; Y.ARR.ID1 = '' ; Y.AGENCY = '' ; Y.INVEST.TYPE = '' ;
            Y.CURRENCY = '' ; Y.BDY.AMOUNT = '' ; Y.PAY.METHOD = '' ; Y.BDY.TERM = '' ; Y.AZ.SORT.VAL = '' ; Y.SORT.ARR = '' ; Y.PRINCIPAL = ''
            Y.WORK.BAL = '' ;  Y.BDY.CURR.BAL = '' ; Y.BDY.PLEDGED.AMT = '' ; REGION.CODE = '' ; Y.CUS = '' ; Y.ACC.LIST = '' ; Y.REINVESTED.DEPOSIT = ''
            TRNS.THREE.POS = '' ; Y.BDY.CUSTOMER.NAME = '' ; Y.CATEGORY = ''  ; Y.BDY.REGION = ''

        END
*                                 1              2                  3                  4                      5                6                      7                      8                    9                     10                   11               12               13                     14                15                      16                       17               18                  19               20                  21                   22                        23                       24                      25                         26
        Y.FLAG = '' ; Y.BDY.REGION = ''

    REPEAT

RETURN

*****************
CHECK.PAY.METHOD:
*****************
*    ACCOUNT.ID = Y.AZ.ID
*    R.ACCOUNT  = ''
*    ACCOUNT.ER = ''
*    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)
*    IF Y.PAY.METHOD EQ R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.PAYMT.MODE.POS> THEN
*        Y.AC.FLAG = 1
*    END

RETURN

***********
GET.REGION:
***********

    CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,F.ERR)
    Y.ID1 = R.AZ.ACCOUNT<AZ.CUSTOMER>


    CALL F.READ(FN.CUSTOMER,Y.ID1,R.CUSTOMER,F.CUSTOMER,ERR)
    Y.CLI.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS>

    IF Y.PAY.METHOD AND (Y.PAY.METHOD NE R.AZ.ACCOUNT<AZ.LOCAL.REF, Y.L.AZ.PAYMT.MODE.POS>) THEN
        Y.INCL.FLAG = 'N'
        RETURN
    END

    CALL F.READ(FN.ACCOUNT,Y.AZ.ID,R.ACC.REC,F.ACCOUNT,F.ERR)
    Y.CUSTOMER.ID = R.AZ.ACCOUNT<AZ.CUSTOMER>
*
*    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUS.REC,F.CUSTOMER,F.ERR)

    IF Y.CLIENT.TYPE AND (Y.CLI.TYPE NE Y.CLIENT.TYPE) THEN
        Y.INCL.FLAG = 'N'
        RETURN
    END

*L.AZ.ORG.DP.AMT  = R.AZ.ACCOUNT<AZ.LOCAL.REF, Y.L.AZ.ORG.DP.AMT.POS>
    L.AZ.ORG.DP.AMT  = R.AZ.ACCOUNT<AZ.LOCAL.REF, Y.L.AZ.ORIG.DEP.AMT.POS>

*IF NOT(L.AZ.ORG.DP.AMT) THEN
*L.AZ.ORG.DP.AMT = R.AZ.ACCOUNT<AZ.PRINCIPAL>
*END

    IF Y.SEL.AMOUNT THEN
        IF ((L.AZ.ORG.DP.AMT GE AMOUNT.1) AND (L.AZ.ORG.DP.AMT LE AMOUNT.2)) ELSE
            Y.INCL.FLAG = 'N'
            RETURN
        END
    END

    Y.ACC.OFF = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
    Y.CNT = LEN(Y.ACC.OFF)

    IF Y.CNT GT 8 THEN
        Y.CNT1 = Y.CNT-8
        Y.CNT2 = Y.CNT1+1
        Y.BDY.REGION = Y.ACC.OFF[Y.CNT2,2]
    END
    IF Y.CNT EQ 8 THEN
        Y.BDY.REGION = Y.ACC.OFF[1,2]
    END

    Y.BDY.AGENCY = R.AZ.ACCOUNT<AZ.CO.CODE>
    Y.BDY.ACCT.EXE = R.ACC.REC<AC.ACCOUNT.OFFICER>
    Y.CATEG = R.AZ.ACCOUNT<AZ.CATEGORY>

    CALL CACHE.READ(FN.CATEGORY, Y.CATEG, R.CATEGORY, Y.ERR.CATEG) ;*R22 AUTO CODE CONVERSION
    Y.BDY.INV.TYPE = R.CATEGORY<EB.CAT.DESCRIPTION>

    Y.BDY.PRE.INV.NO = R.ACC.REC<AC.ALT.ACCT.ID>
    Y.BDY.INV.NO = Y.AZ.ID
    Y.BDY.CUSTOMER = Y.CUSTOMER.ID
*    Y.CLIENT.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF><1,Y.L.CU.TIPO.CL.POS>
    Y.BDY.CLIENT.TYPE = Y.CLI.TYPE
*    Y.BDY.OPENING.DATE = R.AZ.ACCOUNT<AZ.VALUE.DATE>
    Y.BDY.OPENING.DATE = R.ACC.REC<AC.OPENING.DATE> ;* The actual opening date of the Deposit as per Legacy system.
    Y.BDY.CURRENCY = R.AZ.ACCOUNT<AZ.CURRENCY>
    Y.BDY.MATURITY.DATE = R.AZ.ACCOUNT<AZ.MATURITY.DATE>
    Y.BDY.INT.PAYDATE = R.AZ.ACCOUNT<AZ.FREQUENCY>

    IF Y.BDY.INT.PAYDATE THEN

        Y.RECURRENCE = Y.BDY.INT.PAYDATE[9,99]

        IF NOT(Y.RECURRENCE) THEN
            Y.BDY.INT.PAYDATE = 'el dia ':Y.BDY.INT.PAYDATE[7,2]

        END
        ELSE
            CALL EB.BUILD.RECURRENCE.MASK(Y.RECURRENCE, '', Y.OUT.MASK)

            Y.INT.PAYDATE= Y.BDY.INT.PAYDATE[1,8]
*        CALL EB.DATE.FORMAT.DISPLAY(Y.INT.PAYDATE, Y.INT.PAYDATE2, '', '')

            Y.BDY.INT.PAYDATE = Y.OUT.MASK
        END
    END

*Y.BDY.AMOUNT =R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.L.AZ.ORG.DP.AMT.POS>
    Y.BDY.AMOUNT =R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.L.AZ.ORIG.DEP.AMT.POS>

*IF NOT(Y.BDY.AMOUNT) THEN
*Y.BDY.AMOUNT = R.AZ.ACCOUNT<AZ.PRINCIPAL>
*END

    Y.DIFF = 'C'
    CALL CDD(REGION.CODE,Y.BDY.OPENING.DATE,Y.BDY.MATURITY.DATE,Y.DIFF)
    Y.BDY.TERM = Y.DIFF

    IF Y.DIFF GT 30 THEN
        CALL EB.NO.OF.MONTHS(Y.BDY.OPENING.DATE,Y.BDY.MATURITY.DATE,Y.TERM.MNTHS)
        IF Y.TERM.MNTHS EQ '1' THEN
            Y.BDY.TERM = Y.TERM.MNTHS:' MES'
        END
        ELSE
            Y.BDY.TERM = Y.TERM.MNTHS:' MEMES'
        END
    END
    ELSE
        Y.BDY.TERM = Y.DIFF:' DIAS'
    END

    Y.BDY.INTEREST.RATE = R.AZ.ACCOUNT<AZ.INTEREST.RATE>
    GOSUB GET.INT.PAY.METHOD
    Y.BDY.CDT.ACCT.NO = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>

    GOSUB GET.CUR.BALANCE

    Y.BDY.ACR.INT = R.ACC.REC<AC.ACCR.CR.AMOUNT>
    GOSUB GET.STATUS


    Y.NOTIFY.ALL = ''
    Y.NOTIFY.VAL = R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.L.AC.NOTIFY.1.POS>
    Y.NOTIFY.CNT = DCOUNT(Y.NOTIFY.VAL,@SM)
    FOR Y.NOTIF.REC = 1 TO Y.NOTIFY.CNT
        Y.NOTIFY.ID = 'L.AC.NOTIFY.1*':Y.NOTIFY.VAL<1,1,Y.NOTIF.REC>
        Y.READ.ERR = ''
        CALL F.READ(FN.EB.LOOKUP, Y.NOTIFY.ID, R.NOTIFY.REC, F.EB.LOOKUP, Y.READ.ERR)
        Y.NOTIFY = R.NOTIFY.REC<EB.LU.DESCRIPTION, LNGG>

        IF NOT(Y.NOTIFY) THEN
            Y.NOTIFY = R.NOTIFY.REC<EB.LU.DESCRIPTION, 1>
        END
        Y.NOTIFY.ALL<-1> = Y.NOTIFY

    NEXT Y.NOTIF.REC

    CHANGE @FM TO ';' IN Y.NOTIFY.ALL


    Y.BDY.NOTIFICATION = Y.NOTIFY.ALL
*    GOSUB COLL.VALUE
    Y.BDY.PLEDGED.AMT  = SUM(R.ACC.REC<AC.LOCKED.AMOUNT>)
    Y.BDY.CANCELLATION.DATE = Y.CLOUSURE
    Y.BDY.CANCELLATION.AMT = R.AZ.ACCOUNT<AZ.PRINCIPAL>
    Y.BDY.ROLLOVER.DATE = R.AZ.ACCOUNT<AZ.ROLLOVER.DATE>

    GOSUB GET.CUSTOMER.NAME

RETURN
***********
*COLL.VALUE:
***********
*    SEL.CMD2 = "SELECT ":FN.COLLATERAL:" WITH APPLICATION.ID EQ ":Y.AZ.ID
*    CALL EB.READLIST(SEL.CMD2,SEL.LIST2,'',NO.OF.REC2,F.ERR2)
*    LOOP
*        REMOVE Y.CO.ID FROM SEL.LIST2 SETTING POS
*    WHILE Y.CO.ID:POS
*        CALL F.READ(FN.COLLATERAL,Y.CO.ID,R.COLLATERAL,F.COLLATERAL,F.ERR)
*        Y.BDY.PLEDGED.AMT = R.COLLATERAL<COLL.EXECUTION.VALUE>
*    REPEAT
*
*
*    RETURN
********************
SEL.STMT.FORMATION:
********************

    LOCATE  'AGENCY' IN D.FIELDS<1> SETTING Y.AGENCY.POS THEN
        Y.AGENCY = D.RANGE.AND.VALUE<Y.AGENCY.POS>
    END
    IF Y.AGENCY THEN
        SEL.CMD.AZ  := ' WITH CO.CODE EQ ' :Y.AGENCY
    END

    LOCATE 'CATEGORY' IN D.FIELDS<1> SETTING Y.CATEG.POS THEN
        Y.CATEGORY =D.RANGE.AND.VALUE<Y.CATEG.POS>
    END
    IF Y.CATEGORY THEN
        SEL.CMD.AZ:= ' WITH CATEGORY EQ ':Y.CATEGORY
    END

    LOCATE 'CLIENT.TYPE' IN D.FIELDS<1> SETTING Y.CLIENT.POS THEN
        Y.CLIENT.TYPE = D.RANGE.AND.VALUE<Y.CLIENT.POS>
        Y.CLIENT.TYPE = CHANGE(Y.CLIENT.TYPE, '.', ' ')
    END
*    IF Y.CLIENT.TYPE THEN
*        SEL.CMD.CUS = 'SELECT ':FN.CUSTOMER:' WITH L.CU.TIPO.CL EQ ': Y.CLIENT.TYPE
*        CALL EB.READLIST(SEL.CMD.CUS,SEL.LIST,'',NO.OF.REC,RET.CODE)
*        CUSTOMER.LIST1 = SEL.LIST
*        CHANGE FM TO ' ' IN CUSTOMER.LIST1
*        SEL.CMD.AZ :=  ' AND CUSTOMER EQ ':CUSTOMER.LIST1
*    END

    LOCATE 'CURRENCY' IN D.FIELDS<1> SETTING Y.CURRENCY.POS THEN
        Y.CURRENCY = D.RANGE.AND.VALUE<Y.CURRENCY.POS>
    END
    IF Y.CURRENCY THEN
        SEL.CMD.AZ : = " WITH CURRENCY EQ ":Y.CURRENCY
    END

    LOCATE 'AMOUNT' IN D.FIELDS<1> SETTING Y.AMOUNT.POS THEN
        Y.SEL.AMOUNT = D.RANGE.AND.VALUE<Y.AMOUNT.POS>
        Y.COUNT = DCOUNT(Y.SEL.AMOUNT,@SM)
        AMOUNT.1 = FIELD(Y.SEL.AMOUNT,@SM,1)
        AMOUNT.2 = FIELD(Y.SEL.AMOUNT,@SM,2)
    END
*    IF Y.BDY.AMOUNT THEN
*        SEL.CMD.AZ : = ' WITH L.AZ.ORG.DP.AMT GT ':AMOUNT.1: ' AND LE ' : AMOUNT.2
*    END

    LOCATE 'PAY.METHOD' IN D.FIELDS<1> SETTING Y.PAY.POS THEN
        Y.PAY.METHOD = D.RANGE.AND.VALUE<Y.PAY.POS>
*        CHANGE SM TO ' ' IN Y.PAY.METHOD

        FN.AZ.INT.PAY.METHOD = 'F.AZ.INT.PAY.METHOD'
        F.AZ.INT.PAY.METHOD = ''
        CALL OPF(FN.AZ.INT.PAY.METHOD, F.AZ.INT.PAY.METHOD)

        Y.READ.ERR = ''
        R.AZ.INT.PAY.METHOD = ''
        CALL F.READ(FN.AZ.INT.PAY.METHOD, Y.PAY.METHOD, R.AZ.INT.PAY.METHOD, F.AZ.INT.PAY.METHOD, Y.READ.ERR)

        Y.PAY.METHOD = R.AZ.INT.PAY.METHOD<AZ.INT32.DESC,1>

        SEL.CMD.AZ := ' WITH L.TYPE.INT.PAY EQ ':Y.PAY.METHOD

    END
    CALL EB.READLIST(SEL.CMD.AZ,SEL.LIST.AZ1,'',NO.OF.REC.AZ,SEL.ERR.AZ)
    Y.FINAL.AZ.IDS = SEL.LIST.AZ1

RETURN

***************
*GET.SORTED.IDS:
***************
*
*    LOOP
*        REMOVE AZ.ACCOUNT.ID FROM Y.FINAL.AZ.IDS SETTING Y.AZ.POS
*    WHILE AZ.ACCOUNT.ID : Y.AZ.POS
*        CALL F.READ(FN.AZ.ACCOUNT,AZ.ACCOUNT.ID,R.AZ.REC,F.AZ.ACCOUNT,Y.AZ.ERR)
*        Y.CUSTOMER.ID = R.AZ.REC<AZ.CUSTOMER>
*        CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,F.ERR)
*        ACCOUNT.ID = AZ.ACCOUNT.ID
*        CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
*       CUS.VALUE = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
*
*        Y.CUSTOMER.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS>
*
*        IF Y.CUSTOMER.TYPE NE Y.CLIENT.TYPE THEN
*            CONTINUE
*        END
*
*        Y.CNT1 = LEN(CUS.VALUE)
*        IF Y.CNT1 GT 8 THEN
*            Y.ACT1.POS =  Y.CNT1 - 8
*            CUS.FINAL.VAL = CUS.VALUE[Y.ACT1.POS,2]
*        END
*        IF Y.CNT1 EQ 8 THEN
*            CUS.FINAL.VAL = CUS.VALUE[1,2]
*        END
*        Y.SORT.VAL = R.AZ.REC<AZ.CO.CODE>:FMT(R.ACCOUNT<AC.ACCOUNT.OFFICER>,'R%12'):FMT(CUS.FINAL.VAL,'R%5'):R.AZ.REC<AZ.CURRENCY>
*        Y.AZ.SORT.VAL<-1> = AZ.ACCOUNT.ID:FM:Y.SORT.VAL
*        Y.SORT.ARR<-1> = Y.SORT.VAL
*    REPEAT

*    Y.SORT.ARR = SORT(Y.SORT.ARR)

*    LOOP
*        REMOVE Y.ARR.ID1 FROM Y.SORT.ARR SETTING Y.ARR.POS
*    WHILE Y.ARR.ID1 : Y.ARR.POS
*        LOCATE Y.ARR.ID1 IN Y.AZ.SORT.VAL SETTING Y.FM.POS THEN
*            Y.ACC.LIST<-1> = Y.AZ.SORT.VAL<Y.FM.POS-1>
*            DEL Y.AZ.SORT.VAL<Y.FM.POS>
*            DEL Y.AZ.SORT.VAL<Y.FM.POS-1>
*        END
*    REPEAT
*
*    RETURN

**************
GET.LOCAL.REF:
**************
    APPL.ARRAY = 'CUSTOMER':@FM:'ACCOUNT':@FM:'AZ.ACCOUNT'
    FLD.ARRAY  = 'L.CU.TIPO.CL':@FM:'L.AC.PAYMT.MODE':@VM:'L.AC.STATUS1':@VM:'L.AC.NOTIFY.1':@VM:'L.AC.REINVESTED':@VM:'L.AC.STATUS2':@FM:'L.TYPE.INT.PAY':@VM:'L.AZ.ORG.DP.AMT':@VM:'L.AC.NOTIFY.1':@VM:'ORIG.DEP.AMT':@VM:'L.AZ.REIVSD.INT'
    FLD.POS    = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    Y.L.CU.TIPO.CL.POS = FLD.POS<1,1>
    Y.L.AC.PAYMT.MODE.POS = FLD.POS<2,1>
    Y.ACCOUNT.STATUS1.POS = FLD.POS<2,2>
    Y.L.AC.NOTIFY.1.POS = FLD.POS<3,3>
    Y.L.AC.REINVESTED.POS = FLD.POS<2,4>
    Y.ACCOUNT.STATUS2.POS = FLD.POS<2,5>
    Y.L.AZ.PAYMT.MODE.POS = FLD.POS<3,1>
    Y.L.AZ.ORG.DP.AMT.POS = FLD.POS<3,2>
    Y.L.AZ.ORIG.DEP.AMT.POS = FLD.POS<3,4>
    Y.L.AZ.REIVSD.INT.POS = FLD.POS<3,5>
RETURN

***********
GET.STATUS:
***********

    Y.CLOUSURE = R.ACC.REC<AC.CLOSURE.DATE>
    IF Y.CLOUSURE NE "" THEN
        Y.BDY.STATUS = "CLOSED"
    END
    STATUS1 = R.ACC.REC<AC.LOCAL.REF,Y.ACCOUNT.STATUS1.POS>

    Y.READ.ERR = ''
    R.STATUS1.DESC = ''
    Y.STATUS1.ID = 'L.AC.STATUS1*':STATUS1
    CALL CACHE.READ(FN.EB.LOOKUP, Y.STATUS1.ID, R.STATUS1.REC, Y.READ.ERR)
    STATUS1 = R.STATUS1.REC<EB.LU.DESCRIPTION,LNGG>
    IF NOT(STATUS1) THEN
        STATUS1 = R.STATUS1.REC<EB.LU.DESCRIPTION,1>
    END

    STATUS2 = R.ACC.REC<AC.LOCAL.REF,Y.ACCOUNT.STATUS2.POS>
    Y.READ.ERR = ''
    R.STATUS2.DESC = ''
    Y.STATUS2.ID = 'L.AC.STATUS2*':STATUS2
    CALL CACHE.READ(FN.EB.LOOKUP, Y.STATUS2.ID, R.STATUS2.REC, Y.READ.ERR)
    STATUS2 = R.STATUS2.REC<EB.LU.DESCRIPTION,LNGG>
    IF NOT(STATUS2) THEN
        STATUS2 = R.STATUS2.REC<EB.LU.DESCRIPTION,1>
    END

RETURN

GET.CUR.BALANCE:
****************
    Y.REINVESTED.DEPOSIT = R.ACC.REC<AC.LOCAL.REF><1,Y.L.AC.REINVESTED.POS>
    Y.PRINCIPAL = R.AZ.ACCOUNT<AZ.PRINCIPAL>

    Y.LIQ.AC.ID = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
    R.LIQ.AC = ''
    CALL F.READ(FN.ACCOUNT, Y.LIQ.AC.ID, R.LIQ.ACC, F.ACCOUNT, Y.READ.ERR)

    IF Y.REINVESTED.DEPOSIT EQ 'YES' THEN
*Y.WORK.BAL = R.LIQ.ACC<AC.ONLINE.ACTUAL.BAL>
*Y.BDY.CURR.BAL = Y.PRINCIPAL + Y.WORK.BAL
        Y.L.AZ.REIVSD.INT = R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.L.AZ.REIVSD.INT.POS>
        Y.BDY.CURR.BAL = Y.PRINCIPAL + Y.L.AZ.REIVSD.INT
    END ELSE
        Y.BDY.CURR.BAL = Y.PRINCIPAL
    END
RETURN

GET.INT.PAY.METHOD:
*******************
*    Y.MTD.PAY = R.ACC.REC<AC.LOCAL.REF,Y.L.AC.PAYMT.MODE.POS>
*    Y.BDY.INT.MTD.PAY = Y.MTD.PAY
*    IF Y.BDY.INT.MTD.PAY EQ ' ' THEN
*        Y.LIQ.ACT.ID = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
**        CALL F.READ(FN.ACCOUNT,Y.AZ.ID,R.ACCT.REC,F.ACCOUNT,F.LIQ.ERR)
*        Y.BDY.INT.MTD.PAY = R.ACCT.REC<AC.LOCAL.REF,Y.L.AC.PAYMT.MODE.POS>
*    END


    Y.MID.PAY = R.AZ.ACCOUNT<AZ.LOCAL.REF, Y.L.AZ.PAYMT.MODE.POS>

    IF Y.MID.PAY THEN
        Y.LOOKUP.ID = 'L.TYPE.INT.PAY*':Y.MID.PAY
        CALL CACHE.READ(FN.EB.LOOKUP, Y.LOOKUP.ID, R.LOOKUP.REC, Y.READ.ERR)

        Y.BDY.INT.MTD.PAY = R.LOOKUP.REC<EB.LU.DESCRIPTION, LNGG>
        IF NOT(Y.BDY.INT.MTD.PAY) THEN
            Y.BDY.INT.MTD.PAY = R.LOOKUP.REC<EB.LU.DESCRIPTION, 1>
        END

    END

RETURN

GET.CUSTOMER.NAME:
******************
    Y.REL.CODE = R.ACC.REC<AC.RELATION.CODE>
*    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
    END
    IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS>) THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.SHORT.NAME>
    END

    Y.CLIENT.CODE = Y.CUSTOMER.ID
    Y.LIST.CUST.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS>

    Y.RELATION.COUNT = DCOUNT(Y.REL.CODE,@VM)
    Y.COUNT = 1
    LOOP
    WHILE Y.COUNT LE Y.RELATION.COUNT
        RELATION.ID = R.ACC.REC<AC.RELATION.CODE,Y.COUNT>
        IF RELATION.ID LT 500 AND RELATION.ID GT 529 THEN
            CONTINUE
        END
        CALL F.READ(FN.RELATION,RELATION.ID,R.RELATION,F.RELATION,Y.REL.ERR)
        Y.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>
        CUSTOMER.ID = R.ACC.REC<AC.JOINT.HOLDER,Y.COUNT>
        CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
        END
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN ;*R22 AUTO CODE CONVERSION
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
        END
        IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS>) THEN
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
        END
        Y.CUS.NAMES := @VM:Y.CUS.NAME
        Y.CLIENT.CODE := @VM:CUSTOMER.ID
        Y.LIST.CUST.TYPE := @VM:R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS>
        Y.COUNT += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT

    Y.BDY.CUSTOMER.NAME = Y.CUS.NAMES
RETURN
END
