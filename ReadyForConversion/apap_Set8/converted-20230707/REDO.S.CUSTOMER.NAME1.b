SUBROUTINE REDO.S.CUSTOMER.NAME1(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.S.CUSTOMER.NAME1
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the all mapping details for RTE form
*
*Date           ref            who                description
*16-08-2011   PACS000100501    Prabhu             PACS000100501-Customer mapping added for credit cards
*15-11-2011   PACS00142988     Pradeep S          Positions defined for Nature of Operation fields
*28-02-2014   PACS00347212     Vignesh Kumaar R   TFS - RTE FORM
*16-12-2014   PACS00392651     Vignesh Kumaar R   AA OVERPAYMENT THROUGH CASH/CHEQUE
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.COUNTRY
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.TFS.TRANSACTION
    $INSERT I_REDO.DEAL.SLIP.COMMON
    $INSERT I_F.REDO.PAY.TYPE
    $INSERT I_F.REDO.RTE.CATEG.POSITION
    $INSERT I_F.REDO.TFS.PROCESS


    GOSUB INIT
    GOSUB READ.RTE.CATEG.POS
    GOSUB PROCESS
RETURN
*********
INIT:
*********
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    FN.REDO.PAY.TYPE = 'F.REDO.PAY.TYPE'
    F.REDO.PAY.TYPE = ''
    CALL OPF(FN.REDO.PAY.TYPE,F.REDO.PAY.TYPE)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.RTE.CATEG.POS = 'F.REDO.RTE.CATEG.POSITION'
    F.REDO.RTE.CATEG.POS = ''
    CALL OPF(FN.REDO.RTE.CATEG.POS,F.REDO.RTE.CATEG.POS)

    FN.REDO.TFS.PROCESS = 'F.REDO.TFS.PROCESS'
    F.REDO.TFS.PROCESS = ''
    CALL OPF(FN.REDO.TFS.PROCESS,F.REDO.TFS.PROCESS)

    FN.TFS.TRANSACTION = 'F.TFS.TRANSACTION'
    F.TFS.TRANSACTION  = ''
    CALL OPF(FN.TFS.TRANSACTION,F.TFS.TRANSACTION)

    FN.FTTC = 'F.FT.TXN.TYPE.CONDITION'
    F.FTTC  = ''
    CALL OPF(FN.FTTC,F.FTTC)

    FN.COUNTRY='F.COUNTRY'
    F.COUNTRY =''
    CALL OPF(FN.COUNTRY,F.COUNTRY)

    LRF.APP = "CUSTOMER":@FM:"TELLER":@FM:"TELLER.TRANSACTION":@FM:"T24.FUND.SERVICES":@FM:"FT.TXN.TYPE.CONDITION"
    LRF.FIELD     = "L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.RES.SECTOR":@VM:"L.CU.TEL.TYPE":@VM:"L.CU.TEL.NO":@VM:"L.CU.TIPO.CL":@VM:"L.CU.TEL.AREA":@VM:"L.CU.URB.ENS.RE":@VM:"L.APAP.INDUSTRY":@VM:"L.CUS.PEP":@VM:"L.CU.PASS.NAT"
    LRF.FIELD<-1> = "L.TT.CLIENT.COD":@VM:"L.TT.CR.ACCT.NO":@VM:"L.ACTUAL.VERSIO":@VM:"L.COMMENTS":@VM:"L.DEBIT.AMOUNT"
    LRF.FIELD<-1> = "L.TT.PAY.TYPE"
    LRF.FIELD<-1> = "L.TT.PROCESS"
    LRF.FIELD<-1> = "L.FTTC.PAY.TYPE"
    LRF.POS = ''
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)

    VAR.SOCIAL = '' ; VAR.RNC = '' ;
    VAR.NAME1 = ''; VAR.NAME2 = ''; VAR.LASTNAME1 = '' ; VAR.LASTNAME2 = ''
    VAR.GENDER = '' ; VAR.DOB= '' ; VAR.NATION = '' ; VAR.CEDULA = '' ; VAR.PASSPORT = ''
    VAR.ADD1 = ''; VAR.ADD2 = ''; VAR.ADD3 = ''; VAR.ADD4 = ''; VAR.RES.SECTOR = ''
    VAR.STREET = ''; VAR.CITY = '' ; VAR.TOWN.COUNTRY = ''; VAR.OFF = ''; VAR.TEL.TYPE = '' ; VAR.TEL.NO = ''
    VAR.HOME = '' ; VAR.CELL = '' ; VAR.SECTOR = '' ; VAR.RTE.POS = ''
    Y.TEL.AREA=''
    CID.POS = LRF.POS<1,1>
    RNC.POS = LRF.POS<1,2>
    SEC.POS = LRF.POS<1,3>
    TYP.POS = LRF.POS<1,4>
    TEL.POS = LRF.POS<1,5>
    TIPO.POS = LRF.POS<1,6>
    Y.TEL.AREA.POS=LRF.POS<1,7>
    Y.CUS.RES.POS =LRF.POS<1,8>
    Y.IND.POS =LRF.POS<1,9>
    Y.PEP.POS =LRF.POS<1,10>
    Y.PNA.POS =LRF.POS<1,11>
    Y.CUST.COD.POS=LRF.POS<2,1>
    Y.CUST.CRED.ACC = LRF.POS<2,2>
    Y.ACTUAL.VERSION.ID = LRF.POS<2,3>
    Y.L.COMMENTS = LRF.POS<2,4>
    Y.L.TXN.AMT.POS=LRF.POS<2,5>
    Y.TT.PAY.TYPE.POS = LRF.POS<3,1>
    POS.TT.PROCESS = LRF.POS<4,1>
    POS.L.FTTC.PAY.TYPE = LRF.POS<5,1>
RETURN

********************
READ.RTE.CATEG.POS:
********************
*New section included for PACS00142988

    R.RTE.CATEG.POS = ''
    CALL CACHE.READ(FN.REDO.RTE.CATEG.POS,"SYSTEM",R.RTE.CATEG.POS,CATEG.ERR)

    Y.RTE.POSITION = R.RTE.CATEG.POS<REDO.RTE.POS.RTE.POSITION>
    Y.CATEG.INIT   = R.RTE.CATEG.POS<REDO.RTE.POS.CATEG.INIT>
    Y.CATEG.END    = R.RTE.CATEG.POS<REDO.RTE.POS.CATEG.END>

RETURN

**************
PROCESS:
*************
*This para is used to get credit customer id based on application

    BEGIN CASE

        CASE ID.NEW[1,2] EQ 'TT'
            GOSUB TT.PROCESS
        CASE ID.NEW[1,2] EQ 'FT'
            GOSUB FT.PROCESS
        CASE ID.NEW[1,5] EQ 'T24FS' ;* Changed by Vignesh
            GOSUB TFS.PROCESS

    END CASE

    GOSUB GET.CUST.DETAILS

RETURN
*************
TT.PROCESS:
*************

    VAR.DR.CR.MARKER = R.NEW(TT.TE.DR.CR.MARKER)
    IF VAR.DR.CR.MARKER EQ 'CREDIT' THEN
        VAR.CUS = R.NEW(TT.TE.CUSTOMER.1)
        Y.VAR.CCY = R.NEW(TT.TE.CURRENCY.2)
*        IF VAR.CCY EQ LCCY THEN
*            VAR.AMOUNT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
*        END ELSE
*            VAR.AMOUNT = R.NEW(TT.TE.AMOUNT.FCY.1)
*        END
        VAR.AMOUNT  = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TXN.AMT.POS>
        VAR.ACCOUNT = R.NEW(TT.TE.ACCOUNT.1)
        GOSUB READ.ACCOUNT
        IF NOT(R.ACC<AC.CUSTOMER>) THEN
            VAR.ACCOUNT = R.NEW(TT.TE.ACCOUNT.2)
        END

    END ELSE
        VAR.CUS = R.NEW(TT.TE.CUSTOMER.2)
        Y.VAR.CCY = R.NEW(TT.TE.CURRENCY.1)
*        IF VAR.CCY EQ LCCY THEN
*            VAR.AMOUNT = R.NEW(TT.TE.AMOUNT.LOCAL.2)
*        END ELSE
*            VAR.AMOUNT = R.NEW(TT.TE.AMOUNT.FCY.2)
*        END
        VAR.AMOUNT= R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TXN.AMT.POS>
        VAR.ACCOUNT = R.NEW(TT.TE.ACCOUNT.2)
        GOSUB READ.ACCOUNT
        IF NOT(R.ACC<AC.CUSTOMER>) THEN
            VAR.ACCOUNT = R.NEW(TT.TE.ACCOUNT.1)
        END
    END

* Fix for PACS00392651 [AA OVERPAYMENT THROUGH CASH/CHEQUE]

    IF NOT(VAR.CUS) AND R.NEW(TT.TE.LOCAL.REF)<1,Y.ACTUAL.VERSION.ID> EQ 'TELLER,REDO.OVERPYMT.CASH' THEN
        VAR.CUS = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.COMMENTS>
        VAR.ACCOUNT = R.NEW(TT.TE.NARRATIVE.1)
        GOSUB READ.ACCOUNT
    END

* End of Fix

*PACS000100501-S
    IF NOT(VAR.CUS) THEN
        VAR.CUS=R.NEW(TT.TE.LOCAL.REF)<1,Y.CUST.COD.POS>
        Y.CREDIT.CARD.ACC = R.NEW(TT.TE.LOCAL.REF)<1,Y.CUST.CRED.ACC>
        IF Y.CREDIT.CARD.ACC THEN
            VAR.ACCOUNT = Y.CREDIT.CARD.ACC
            GOSUB READ.ACCOUNT
        END
    END
*PACS000100501-E
*PACS00142988 - S
    Y.TT.TXN.ID = R.NEW(TT.TE.TRANSACTION.CODE)
    GOSUB CHECK.TT.TRANSACTION
*PACS00142988 - E

RETURN

*------------------*
TT.OVERPYMT.PROCESS:
*------------------*

    VAR.DR.CR.MARKER = R.NEW(TT.TE.DR.CR.MARKER)
    IF VAR.DR.CR.MARKER EQ 'CREDIT' THEN
        VAR.CUS = R.NEW(TT.TE.CUSTOMER.1)
        Y.VAR.CCY = R.NEW(TT.TE.CURRENCY.1)
*        IF VAR.CCY EQ LCCY THEN
*            VAR.AMOUNT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
*        END ELSE
*            VAR.AMOUNT = R.NEW(TT.TE.AMOUNT.FCY.1)
*        END
        VAR.AMOUNT  = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TXN.AMT.POS>
        VAR.ACCOUNT = R.NEW(TT.TE.ACCOUNT.1)
    END ELSE
        VAR.CUS = R.NEW(TT.TE.CUSTOMER.2)
        Y.VAR.CCY = R.NEW(TT.TE.CURRENCY.2)
*        IF VAR.CCY EQ LCCY THEN
*            VAR.AMOUNT = R.NEW(TT.TE.AMOUNT.LOCAL.2)
*        END ELSE
*            VAR.AMOUNT = R.NEW(TT.TE.AMOUNT.FCY.2)
*        END
        VAR.ACCOUNT = R.NEW(TT.TE.ACCOUNT.2)
        VAR.AMOUNT  = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TXN.AMT.POS>
        GOSUB READ.ACCOUNT
    END

RETURN

**************
FT.PROCESS:
*************
    VAR.AMOUNT.CCY = R.NEW(FT.AMOUNT.DEBITED)

    Y.VAR.CCY      =VAR.AMOUNT.CCY[1,3]
    Y.LEN.AMTCCY   =LEN(VAR.AMOUNT.CCY)
    Y.LEN.AMTCCY -= 3
    VAR.AMOUNT     =VAR.AMOUNT.CCY[4,Y.LEN.AMTCCY]
    VAR.ACCOUNT    = R.NEW(FT.CREDIT.ACCT.NO)
    GOSUB READ.ACCOUNT
    VAR.CUS        = R.ACC<AC.CUSTOMER>
    IF NOT(VAR.CUS) THEN
        VAR.ACCOUNT    = R.NEW(FT.DEBIT.ACCT.NO)
        GOSUB READ.ACCOUNT
        VAR.CUS = R.ACC<AC.CUSTOMER>
    END
    Y.FTTC = R.NEW(FT.TRANSACTION.TYPE)
    CALL CACHE.READ(FN.FTTC, Y.FTTC, R.FTTC, FTTC.ERR)
    IF R.FTTC THEN
        Y.TT.PAY.TYPE.ID = R.FTTC<FT6.LOCAL.REF,POS.L.FTTC.PAY.TYPE>
        GOSUB TT.PAY.TYPE
    END
RETURN
************
TFS.PROCESS:
*************

    Y.TFS.ID =  R.NEW(TFS.LOCAL.REF)<1,POS.TT.PROCESS>
    Y.VAR.CCY  =R.NEW(TFS.CURRENCY)
    Y.VAR.CCY  =Y.VAR.CCY<1,1>
    IF Y.TFS.ID THEN
        CALL F.READ(FN.REDO.TFS.PROCESS,Y.TFS.ID,R.TFS.PROCESS,F.REDO.TFS.PROCESS,TFS.ERR)
        VAR.ACCOUNT = R.TFS.PROCESS<TFS.PRO.PRIMARY.ACCT>
        VAR.AMOUNT = R.TFS.PROCESS<TFS.PRO.TOTAL.AMOUNT>
        CALL F.READ(FN.ACCOUNT,VAR.ACCOUNT,R.ACC,F.ACCOUNT,ERR.ACC)
        GOSUB READ.ACCOUNT
        VAR.CUS = R.ACC<AC.CUSTOMER>
        GOSUB GET.TFS.AMOUNT
        VAR.AMOUNT = Y.CASH.AMT
    END ELSE
        VAR.ACCOUNT = R.NEW(TFS.PRIMARY.ACCOUNT)
        VAR.CUS = R.NEW(TFS.PRIMARY.CUSTOMER)
        GOSUB READ.ACCOUNT
        GOSUB GET.TFS.AMOUNT
        VAR.AMOUNT = Y.CASH.AMT
    END

    IF Y.TT.TXN.ID THEN
        GOSUB CHECK.TT.TRANSACTION
    END
RETURN
**********************
GET.TFS.AMOUNT:
**********************
    Y.CASH.AMT=''
    Y.TRANSACTION.CODE = R.NEW(TFS.TRANSACTION)
    Y.TRANSACTION.CNT = DCOUNT(Y.TRANSACTION.CODE,@VM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.TRANSACTION.CNT
        Y.TRANS = Y.TRANSACTION.CODE<1,Y.VAR1>
        IF Y.TRANS EQ 'CASHDEP' OR Y.TRANS EQ 'FCASHDEP' OR Y.TRANS EQ 'CASHDEPD' THEN
            CALL F.READ(FN.TFS.TRANSACTION,Y.TRANS,R.TFS.TRANSACTION,F.TFS.TRANSACTION,TFS.ERR)
            Y.TT.TXN.ID = R.TFS.TRANSACTION<TFS.TXN.INTERFACE.AS>
            Y.CASH.AMT += R.NEW(TFS.AMOUNT)<1,Y.VAR1>
        END
        Y.VAR1 += 1
    REPEAT

RETURN
**********************
CHECK.TT.TRANSACTION:
***********************
    R.TT.TXN = ''
    CALL CACHE.READ(FN.TELLER.TRANSACTION, Y.TT.TXN.ID, R.TT.TXN, TT.TXN.ERR)
    IF R.TT.TXN THEN
        Y.TT.PAY.TYPE.ID = R.TT.TXN<TT.TR.LOCAL.REF,Y.TT.PAY.TYPE.POS>
        GOSUB TT.PAY.TYPE
    END
RETURN
*************
READ.ACCOUNT:
*************
* New section included for PACS00142988

    R.ACC = ''
    CALL F.READ(FN.ACCOUNT,VAR.ACCOUNT,R.ACC,F.ACCOUNT,ERR.ACC)
    IF R.ACC THEN
        Y.ACC.CATEG = R.ACC<AC.CATEGORY>
    END

RETURN

************
TT.PAY.TYPE:
************

    Y.PAY.TYPE.ID = Y.TT.PAY.TYPE.ID
    R.PAY.TYPE = ''
    CALL F.READ(FN.REDO.PAY.TYPE,Y.PAY.TYPE.ID,R.PAY.TYPE,F.REDO.PAY.TYPE,PAY.ERR)
    IF R.PAY.TYPE THEN
        Y.RTE.POS.VALUE = R.PAY.TYPE<REDO.PAY.TYPE.RTE.POSITION>
        GOSUB UPDATE.VAR.RTE.POS
    END
RETURN

*******************
UPDATE.VAR.RTE.POS:
*******************

    Y.TOT.CNT = 17 ; Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.TOT.CNT

        LOCATE Y.CNT IN Y.RTE.POSITION<1,1> SETTING RTE.POS THEN
            GOSUB CHECK.ACC.CATEG
        END ELSE
            IF Y.CNT EQ Y.RTE.POS.VALUE THEN
                VAR.RTE.POS<Y.CNT> = "Si"
            END ELSE
                VAR.RTE.POS<Y.CNT> = "No"
            END
        END
        Y.CNT += 1
    REPEAT

    IF Y.SI.FLAG.OTR ELSE
        VAR.RTE.POS<16> = "Si"
    END

RETURN

*****************
CHECK.ACC.CATEG:
*****************
    Y.SI.FLAG = @FALSE
    Y.CATEG.FROM = Y.CATEG.INIT<1,RTE.POS>
    Y.CATEG.TO   = Y.CATEG.END<1,RTE.POS>

    Y.CNT.CATEG = DCOUNT(Y.CATEG.FROM,@SM)
    Y.CATEG = 1
    LOOP
    WHILE Y.CATEG LE Y.CNT.CATEG
        IF Y.ACC.CATEG GE Y.CATEG.FROM<1,1,Y.CATEG> AND Y.ACC.CATEG LE Y.CATEG.TO<1,1,Y.CATEG> THEN
            VAR.RTE.POS<Y.CNT> = "Si"
            Y.SI.FLAG = @TRUE
            Y.SI.FLAG.OTR = @TRUE
            Y.CATEG += Y.CNT.CATEG
        END
        Y.CATEG += 1
    REPEAT

    IF Y.SI.FLAG ELSE
        VAR.RTE.POS<Y.CNT> = "No"
    END

RETURN

****************
GET.CUST.DETAILS:
*****************
*This para is used to fetch required customer details
    CALL F.READ(FN.CUSTOMER,VAR.CUS,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    VAR.CLIENT.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.POS>

    IF VAR.CLIENT.TYPE EQ "PERSONA JURIDICA" THEN
        Y.NAME1 = R.CUSTOMER<EB.CUS.NAME.1>
        Y.NAME2 = R.CUSTOMER<EB.CUS.NAME.2>
        VAR.SOCIAL = Y.NAME1:" ":Y.NAME2
        VAR.RNC = R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS>
    END ELSE
        VAR.NAME1 = FIELD(R.CUSTOMER<EB.CUS.GIVEN.NAMES>," ",1)
        VAR.NAME2 = FIELD(R.CUSTOMER<EB.CUS.GIVEN.NAMES>," ",2)
        VAR.LASTNAME1 = FIELD(R.CUSTOMER<EB.CUS.FAMILY.NAME>," ",1)
        VAR.LASTNAME2 = FIELD(R.CUSTOMER<EB.CUS.FAMILY.NAME>," ",2)
        VAR.GENDER = R.CUSTOMER<EB.CUS.GENDER>
        Y.DOB = R.CUSTOMER<EB.CUS.DATE.OF.BIRTH>
        Y.DOB=ICONV(Y.DOB,"D2")
        VAR.DOB=OCONV(Y.DOB,"D4")
        VAR.NATION = R.CUSTOMER<EB.CUS.NATIONALITY>
        CALL CACHE.READ(FN.COUNTRY, VAR.NATION, R.COUNTRY, ERR)
        VAR.NATION=R.COUNTRY<EB.COU.COUNTRY.NAME>
        VAR.CEDULA = R.CUSTOMER<EB.CUS.LOCAL.REF,CID.POS>
        VAR.PASSPORT = R.CUSTOMER<EB.CUS.LEGAL.ID>
    END
    VAR.ADD1 = R.CUSTOMER<EB.CUS.ADDRESS,1>
    VAR.ADD2 = R.CUSTOMER<EB.CUS.ADDRESS,2>
    VAR.ADD3 = R.CUSTOMER<EB.CUS.ADDRESS,3>
*    VAR.ADD4 = R.CUSTOMER<EB.CUS.ADDRESS,4>
    VAR.ADD4    = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CUS.RES.POS>
    VAR.INDUSTRY= R.CUSTOMER<EB.CUS.LOCAL.REF,Y.IND.POS>

    VAR.CUS.PEP = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.PEP.POS>
    IF VAR.CUS.PEP THEN
        Y.LOOKUP.ID='L.CUS.PEP'
        Y.LOOKUP.VAL=VAR.CUS.PEP
        CALL REDO.EB.LOOKUP.LIST(Y.LOOKUP.ID,Y.LOOKUP.VAL,Y.DESC.VAL,RES1,RES2)
        VAR.CUS.PEP=Y.DESC.VAL
    END
    VAR.PASS.NAT=R.CUSTOMER<EB.CUS.LOCAL.REF,Y.PNA.POS>
    VAR.PASS.NAT=FIELD(VAR.PASS.NAT,'-',2)
    CALL CACHE.READ(FN.COUNTRY, VAR.PASS.NAT, R.COUNTRY.ACQ, ERR)
    VAR.PASS.NAT=R.COUNTRY.ACQ<EB.COU.COUNTRY.NAME>
    VAR.RES.SECTOR = R.CUSTOMER<EB.CUS.LOCAL.REF,SEC.POS>
    VAR.STREET = R.CUSTOMER<EB.CUS.STREET>
    VAR.CITY = R.CUSTOMER<EB.CUS.COUNTRY>
    VAR.TOWN.COUNTRY = R.CUSTOMER<EB.CUS.TOWN.COUNTRY>
*    VAR.OFF = R.CUSTOMER<EB.CUS.OFF.PHONE>
    VAR.TEL.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,TYP.POS>
    VAR.TEL.NO = R.CUSTOMER<EB.CUS.LOCAL.REF,TEL.POS>
    VAR.TEL.AREA = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.TEL.AREA.POS>
    CHANGE @SM TO @FM IN VAR.TEL.TYPE
    CHANGE @SM TO @FM IN VAR.TEL.NO
    CHANGE @SM TO @FM IN VAR.TEL.AREA
    LOCATE '01' IN VAR.TEL.TYPE SETTING POS THEN
        VAR.HOME = VAR.TEL.AREA<POS>:VAR.TEL.NO<POS>
    END
    LOCATE '05' IN VAR.TEL.TYPE SETTING POS2 THEN
        VAR.OFF = VAR.TEL.AREA<POS2>:VAR.TEL.NO<POS2>
    END
    LOCATE '06' IN VAR.TEL.TYPE SETTING POS1 THEN
        VAR.CELL = VAR.TEL.AREA<POS1>:VAR.TEL.NO<POS1>
    END
    VAR.SECTOR = R.CUSTOMER<EB.CUS.SECTOR>
    Y.OUT = VAR.SOCIAL[1,30]
RETURN
*------------------------------------------------------------------------------------
END
