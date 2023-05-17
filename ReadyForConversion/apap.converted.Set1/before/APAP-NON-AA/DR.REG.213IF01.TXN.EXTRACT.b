*-----------------------------------------------------------------------------
* <Rating>-264</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE DR.REG.213IF01.TXN.EXTRACT(REC.ID)
*********
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
* 28-Jul-2014     V.P.Ashokkumar       PACS00309079 - Updated the field mapping and format
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.DATES
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.AA.TERM.AMOUNT          ;* PACS00309079
    $INSERT I_F.SEC.TRADE     ;* PACS00309079
    $INSERT I_F.AZ.ACCOUNT    ;* PACS00309079
    $INSERT I_F.AA.ARRANGEMENT          ;* PACS00309079
    $INSERT I_F.AA.PRODUCT.GROUP
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.ACCOUNT
*
    $INCLUDE REGREP.BP I_DR.REG.213IF01.TXN.EXTRACT.COMMON
    $INCLUDE REGREP.BP I_F.DR.REG.213IF01.PARAM
    $INCLUDE REGREP.BP I_F.DR.REG.213IF01.CONCAT
*
    GOSUB PROCESS
    RETURN

INIT.PROCESS:
****************
    CUST.TYPE = ''; CUST.CODE = ''; CUST.NAME = ''; INITIALS = ''; TXN.DATE = ''; TXN.TIME = ''; TXN.ACCTS = ''; CUST.INDUS = ''
    NATION = ''; TYPE.OF.OPER = ''; AC.AFFECT = ''; ACC.STATUS = ''; AMT.TXN = ''; CCY = '';  TT.CUST.2 = ''; CUST.ID = ''
    INTER.OPER = ''; INTERMEDIARY = ''; INTERM.NAME = ''; INTERM.SURNAME = ''; INT.NATION = ''; CLNT.TYPE = ''; PERS.BENEF = ''; BEN.NAME1 = ''
    BEN.NAME2 = ''; PAIS = ''; R.DR.REG.213IF01.CONCAT = ''; DR.REG.213IF01.CONCAT.ERR = ''; PER.PERSON = ''; CUS.PEP = ''; ACT.INT = ''; PEP.INTERM = ''
    TYPE.PEP.INT = ''; ACT.BEN = ''; PEP.BEN = ''; TYPE.PEP.BEN = ''; TT.ACCT.NUM = ''; FT.ACCT.NUM = ''; TT.TRANS.CODE = ''; TT.CUST.1 = ''
    RETURN

PROCESS:
********
    GOSUB INIT.PROCESS
    CONCAT.ID = REC.ID
    CALL F.READ(FN.DR.REG.213IF01.CONCAT,CONCAT.ID,R.DR.REG.213IF01.CONCAT,F.DR.REG.213IF01.CONCAT,DR.REG.213IF01.CONCAT.ERR)
    CNT.TXN = DCOUNT(R.DR.REG.213IF01.CONCAT<DR.213IF01.CONCAT.STMT.ID>,VM)

    STMT.ENT.VAL = R.DR.REG.213IF01.CONCAT<DR.213IF01.CONCAT.STMT.ID>
    STMT.ENT.VAL = SORT(STMT.ENT.VAL)
    STMT.VAL = STMT.ENT.VAL<CNT.TXN>
    AMT.TXN = R.DR.REG.213IF01.CONCAT<DR.213IF01.CONCAT.CR.AMOUNT>
    CUST.ID = FIELD(CONCAT.ID,'-',1)
    YSTMT.VAL = FIELD(STMT.VAL,'*',1)
    ACC.ID = FIELD(STMT.VAL,'*',2)
    R.STMT.ENTRY = ''; STMT.ENTRY.ERR = ''
    CALL F.READ(FN.STMT.ENTRY,YSTMT.VAL,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENTRY.ERR)
    TXN.REF = R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
    AMT.LCY = R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
    ACCT.TYPE = R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
    ACC.CODE.AFFCT.LIST = R.DR.REG.213IF01.PARAM<DR.213IF01.AC.AF.CODE>
    CHANGE VM TO FM IN ACC.CODE.AFFCT.LIST
    ACC.ID = R.STMT.ENTRY<AC.STE.ACCOUNT.NUMBER>
    IF NOT(NUM(ACC.ID)) THEN
        ACC.ID = FIELD(STMT.VAL,'*',2)
    END
    GOSUB READ.ACCOUNT
    IF R.ACCOUNT THEN
        AC.TYPE.AFFECTED = ''; ARR.ID = ''; YCATEG = ''
        ARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
        YCATEG = R.ACCOUNT<AC.CATEGORY>
        GOSUB GET.ACC.STATUS
        GOSUB TYPE.AC.AFFECTED
    END
    GOSUB GET.CUSTOMER.VALUES
*
    R.FT = ''; R.TT = ''
    BEGIN CASE
    CASE R.STMT.ENTRY<AC.STE.SYSTEM.ID> EQ 'FT'
        TXN.REF = FIELD(TXN.REF,'\',1)
        YTXN.REF = TXN.REF
        CALL EB.READ.HISTORY.REC(F.FT.HIS,TXN.REF,R.FT,ERRH.FT)
        IF NOT(R.FT) THEN
            CALL F.READ(FN.FUNDS.TRANSFER,YTXN.REF,R.FT,F.FUNDS.TRANSFER,FT.ERR)
        END
        IF R.FT THEN
            GOSUB FT.INTERMEDIARY
            INTERM.NAME = R.FT<FT.LOCAL.REF,FT.L.1ST.NAME.POS>:" ":R.FT<FT.LOCAL.REF,FT.L.2ND.NAME.POS>
            INTERM.SURNAME = R.FT<FT.LOCAL.REF,FT.LAST.NAME.POS>:" ":R.FT<FT.LOCAL.REF,FT.2ND.LAST.POS>
            INT.NATION = R.FT<FT.LOCAL.REF,FT.L.NATIONALITY.POS>
            SEX.VAL = R.FT<FT.LOCAL.REF,FT.L.SEX.POS>
            GOSUB GET.INTER.OPER
            GOSUB GET.BEN.NAME
            GOSUB FT.AC.GET.AFFECT
        END
    CASE R.STMT.ENTRY<AC.STE.SYSTEM.ID> EQ 'TT'
        TXN.REF = FIELD(TXN.REF,'\',1)
        CALL F.READ(FN.TELLER,TXN.REF,R.TT,F.TELLER,TT.ERR)
        IF NOT(R.TT) THEN
            CALL EB.READ.HISTORY.REC(F.TT.HIS,TXN.REF,R.TT,ERRH.TT)
        END
        IF R.TT THEN
            GOSUB TT.INTERMEDIARY
            INTERM.NAME = R.TT<TT.TE.LOCAL.REF,TT.L.1ST.NAME.POS>:" ":R.TT<TT.TE.LOCAL.REF,TT.L.2ND.NAME.POS>
            INTERM.SURNAME = R.TT<TT.TE.LOCAL.REF,TT.LAST.NAME.POS>:" ":R.TT<TT.TE.LOCAL.REF,TT.2ND.LAST.POS>
            INT.NATION = R.TT<TT.TE.LOCAL.REF,TT.L.NATIONALITY.POS>
            SEX.VAL = R.TT<TT.TE.LOCAL.REF,TT.L.SEX.POS>
            GOSUB GET.INTER.OPER
            GOSUB GET.BEN.TT
            GOSUB TT.AC.TYPE.AFFECT
            VAL.DATE= R.TT<TT.TE.VALUE.DATE.1>
            GOSUB TYPE.OF.OPERATION
        END
    END CASE
* PACS00309079 - start   ---- if INTERMEDIARY null then copy field 3
    IF INTERMEDIARY EQ '' THEN
        INTERMEDIARY = CUSTOMER.CODE
    END
* PACS00309079 - send
    IF VAL.DATE THEN
        TXN.DATE = VAL.DATE[7,2]:"/":VAL.DATE[5,2]:"/":VAL.DATE[1,4]
    END
    STMT.TIME = R.STMT.ENTRY<AC.STE.DATE.TIME>[7,4]
    IF STMT.TIME THEN
        TXN.TIME = STMT.TIME[1,2]:":":STMT.TIME[3,2]
    END
    CUS.PEP.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CUS.PEP.POS>
    CU.PERS.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.PEPS.POS>
    IF CU.PERS.VAL EQ 'SI' THEN
        PER.PERSON = 'S'
    END ELSE
        PER.PERSON = 'N'
    END
*
    GOSUB FMT.FLDS
    CALL F.WRITE(FN.DR.REG.213IF01.WORKFILE, CONCAT.ID, REP.LINE)
    RETURN

FT.INTERMEDIARY:
***************
    INTERMEDIARY = R.FT<FT.LOCAL.REF,FT.L.NEW.ID.CARD.POS>
    IF INTERMEDIARY EQ '' THEN
        INTERMEDIARY = R.FT<FT.LOCAL.REF,FT.L.OLD.ID.CARD.POS>
    END
    IF INTERMEDIARY EQ '' THEN
        INTERMEDIARY = R.FT<FT.LOCAL.REF,FT.L.PASSPORT.POS>
    END
    RETURN

TT.INTERMEDIARY:
****************
    INTERMEDIARY = R.TT<TT.TE.LOCAL.REF,TT.L.NEW.ID.CARD.POS>
    IF INTERMEDIARY EQ '' THEN
        INTERMEDIARY = R.TT<TT.TE.LOCAL.REF,TT.L.OLD.ID.CARD.POS>
    END
    IF INTERMEDIARY EQ '' THEN
        INTERMEDIARY = R.TT<TT.TE.LOCAL.REF,TT.L.PASSPORT.POS>
    END
    RETURN

FT.AC.GET.AFFECT:
*****************
    AC.TYPE.AFFECTED = R.FT<FT.DEBIT.ACCT.NO>
    CCY = R.FT<FT.DEBIT.CURRENCY>
    VAL.DATE = R.FT<FT.PROCESSING.DATE>
    IF ACC.ID NE AC.TYPE.AFFECTED THEN
        AC.TYPE.AFFECTED = R.FT<FT.CREDIT.ACCT.NO>
        CCY = R.FT<FT.CREDIT.CURRENCY>
    END
    FT.TRANS.CODE = R.FT<FT.TRANSACTION.TYPE>
    IF (FT.TRANS.CODE EQ 'OT30' OR FT.TRANS.CODE EQ 'OT31' OR FT.TRANS.CODE EQ 'OTP1') THEN
        TYPE.OPER = '3'
    END
    RETURN

TT.AC.TYPE.AFFECT:
******************
    LOCATE ACCT.TYPE IN ACC.CODE.AFFCT.LIST<1> SETTING ACCT.TYPE.POS THEN
        AC.TYPE.AFFECTED = R.TT<TT.TE.LOCAL.REF,L.TT.FXSN.NUM.POS>
    END ELSE
        AC.TYPE.AFFECTED = R.TT<TT.TE.ACCOUNT.1>
        IF ACC.ID NE AC.TYPE.AFFECTED THEN
            AC.TYPE.AFFECTED = R.TT<TT.TE.ACCOUNT.2>
        END
    END
    RETURN

READ.ACCOUNT:
*************
    R.ACCOUNT = ''; ACCOUNT.ERR = ''; ERR.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    IF NOT(R.ACCOUNT) THEN
        YACC.HID = ACC.ID
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HST,YACC.HID,R.ACCOUNT,ERR.ACCOUNT)
    END
    RETURN

GET.BEN.TT:
***********
    BEN.NAME1 = R.TT<TT.TE.LOCAL.REF,TT.BEN.NAME.POS>
    BEN.NAME2 = BEN.NAME1
    CLNT.TYPE = R.TT<TT.TE.LOCAL.REF,TT.L.FT.CLNT.TYPE.POS>
    PAIS = R.TT<TT.TE.LOCAL.REF,TT.L.PAIS.POS>
    ID.PERS.BENEF = R.TT<TT.TE.LOCAL.REF,TT.L.ID.PERS.BENEF.POS>
    GOSUB BENIF.IDENT
    ACT.INT = R.TT<TT.TE.LOCAL.REF,TT.L.ACT.INT.POS>
    PEP.INTERM = R.TT<TT.TE.LOCAL.REF,TT.L.PEP.INTERM.POS>
    TYPE.PEP.INT = R.TT<TT.TE.LOCAL.REF,TT.L.TYPE.PEP.INT.POS>
    ACT.BEN = R.TT<TT.TE.LOCAL.REF,TT.L.ACT.BEN.POS>
    PEP.BEN = R.TT<TT.TE.LOCAL.REF,TT.L.PEP.BEN.POS>
    TYPE.PEP.BEN = R.TT<TT.TE.LOCAL.REF,TT.L.TYPE.PEP.BEN.POS>
    RETURN

GET.BEN.NAME:
*************
    BEN.NAME1 = R.FT<FT.LOCAL.REF,FT.BEN.NAME.POS,1>
    BEN.NAME2 = BEN.NAME1
    CLNT.TYPE = R.FT<FT.LOCAL.REF,FT.L.FT.CLNT.TYPE.POS>
    PAIS = R.FT<FT.LOCAL.REF,FT.L.PAIS.POS>
    ID.PERS.BENEF = R.FT<FT.LOCAL.REF,FT.L.ID.PERS.BENEF.POS>
    GOSUB BENIF.IDENT
    ACT.INT = R.FT<FT.LOCAL.REF,FT.L.ACT.INT.POS>
    PEP.INTERM = R.FT<FT.LOCAL.REF,FT.L.PEP.INTERM.POS>
    TYPE.PEP.INT = R.FT<FT.LOCAL.REF,FT.L.TYPE.PEP.INT.POS>
    ACT.BEN = R.FT<FT.LOCAL.REF,FT.L.ACT.BEN.POS>
    PEP.BEN = R.FT<FT.LOCAL.REF,FT.L.PEP.BEN.POS>
    TYPE.PEP.BEN = R.FT<FT.LOCAL.REF,FT.L.TYPE.PEP.BEN.POS>
    RETURN

BENIF.IDENT:
***********
    BEGIN CASE
    CASE PAIS NE '' AND ID.PERS.BENEF NE ''
        PERS.BENEF = PAIS:'-':ID.PERS.BENEF
    CASE PAIS NE '' AND ID.PERS.BENEF EQ ''
        PERS.BENEF = PAIS
    CASE PAIS EQ '' AND ID.PERS.BENEF NE ''
        PERS.BENEF = ID.PERS.BENEF
    CASE 1
        PERS.BENEF = ''
    END CASE
    RETURN
*-----------------------------------------------------------------------------------
GET.CUSTOMER.VALUES:
********************
    R.CUSTOMER = ''; CUSTOMER.ERR = ''
    CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    TIPO.CL.POS.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS>
    GOSUB GET.CUSTOMER.DETAILS
    RETURN
*-----------------------------------------------------------------------------------
GET.INTER.OPER:
***************

    BEGIN CASE
    CASE INT.NATION EQ 'DO' AND SEX.VAL EQ 'MASCULINO'
        INTER.OPER = 'P3'
    CASE INT.NATION NE 'DO' AND YRESID EQ 'DO' AND SEX.VAL EQ 'MASCULINO'
        INTER.OPER = 'P4'
    CASE INT.NATION EQ 'DO' AND SEX.VAL EQ 'FEMENINO'
        INTER.OPER = 'P5'
    CASE INT.NATION NE 'DO' AND SEX.VAL EQ 'FEMENINO'
        INTER.OPER = 'P6'
    CASE INT.NATION NE 'DO' AND YRESID NE 'DO' AND SEX.VAL EQ 'MASCULINO' AND TIPO.CL.POS.VAL EQ 'PERSONA FISICA'
        INTER.OPER = 'P7'
    CASE INT.NATION NE 'DO' AND YRESID NE 'DO' AND SEX.VAL EQ 'FEMENINO'
        INTER.OPER = 'P8'
    CASE INT.NATION EQ '' OR SEX.VAL EQ ''
        INTER.OPER = CUSTOMER.TYPE
    END CASE
    RETURN

GET.ACC.STATUS:
*------------*
*
    IF R.STMT.ENTRY<AC.STE.SYSTEM.ID> EQ 'AA' THEN
        CALL F.READ(FN.AA.ARRANGEMENT,ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ERR)
        IF NOT(R.AA.ARRANGEMENT) THEN
            RETURN
        END
        AAR.STATUS.VAL = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>
        BEGIN CASE
        CASE AAR.STATUS.VAL EQ 'AUTH' OR AAR.STATUS.VAL EQ 'AUTH.FWD' OR AAR.STATUS.VAL EQ 'CURRENT'
            ACC.STATUS = 'A'
        CASE AAR.STATUS.VAL EQ 'MATURED' OR AAR.STATUS.VAL EQ 'EXPIRED' OR AAR.STATUS.VAL EQ 'REVERSED' OR AAR.STATUS.VAL EQ 'CANCELLED' OR AAR.STATUS.VAL EQ 'CLOSE'
            ACC.STATUS = 'C'
        END CASE
    END ELSE
        IF R.ACCOUNT<AC.CLOSURE.DATE> NE '' THEN  ;*  (THE ACCOUNT MUST BE IN HISTORY FILE)
            ACC.STATUS = 'C'
            RETURN
        END
        AC.STATUS1.VAL = R.ACCOUNT<AC.LOCAL.REF,AC.STATUS1.POS>
        AC.STATUS2.VAL = R.ACCOUNT<AC.LOCAL.REF,AC.STATUS2.POS>
        STAT2.CNT = DCOUNT(AC.STATUS2.VAL,SM)
        IF STAT2.CNT GE 2 THEN
            GOSUB GET.STATUS.MULTIVAL
            RETURN
        END
        GOSUB AC.STAT.CASE
    END
    RETURN

AC.STAT.CASE:
*************
    BEGIN CASE
    CASE AC.STATUS2.VAL EQ 'DECEASED'
        ACC.STATUS = 'F'
    CASE AC.STATUS2.VAL EQ 'GARNISHMENT'
        ACC.STATUS = 'E'
    CASE AC.STATUS2.VAL EQ 'GUARANTEE.STATUS'
        ACC.STATUS = 'G'
    CASE AC.STATUS1.VAL EQ 'ACTIVE' OR AC.STATUS1.VAL EQ '' OR AC.STATUS1.VAL EQ '6MINACTIVE'
        ACC.STATUS = 'A'
    CASE AC.STATUS1.VAL EQ 'ABANDONED'
        ACC.STATUS = 'B'
    CASE AC.STATUS1.VAL EQ '3YINACTIVE'
        ACC.STATUS = 'I'
    END CASE
    RETURN

GET.STATUS.MULTIVAL:
********************
    D.POSN = ''; G.POSN = ''
    LOCATE 'DECEASED' IN AC.STATUS2.VAL<1,1,1> SETTING D.POSN THEN
        ACC.STATUS = 'F'
    END ELSE
        GOSUB GET.STATUS.EG
    END
    RETURN

GET.STATUS.EG:
**************
    LOCATE 'GARNISHMENT' IN AC.STATUS2.VAL<1,1,1> SETTING G.POSN THEN
        ACC.STATUS = 'E'
    END ELSE
        ACC.STATUS = 'G'
    END
    RETURN

TYPE.OF.OPERATION:
*----------------*
    TT.TRANS.CODE = ''; OPR.POS = ''; TYPE.OPER = ''
    TT.TRANS.CODE = R.TT<TT.TE.TRANSACTION.CODE>
    LOCATE TT.TRANS.CODE IN Y.TXNACC.VAL.ARR<1,1> SETTING TXNTPE.POS THEN
        TYPE.OPER = Y.TXNACC.DIS.ARR<1,TXNTPE.POS>
    END

    TT.CUST.1 = R.TT<TT.TE.CUSTOMER.1>
    TT.CUST.2 = R.TT<TT.TE.CUSTOMER.2>
    IF (TT.TRANS.CODE EQ 24 OR TT.TRANS.CODE EQ 69) THEN
        IF CUST.ID EQ TT.CUST.1 THEN
            CCY = R.TT<TT.TE.CURRENCY.1>
        END ELSE
            CCY = R.TT<TT.TE.CURRENCY.2>
        END
    END ELSE
        IF CUST.ID EQ TT.CUST.2 THEN
            CCY = R.TT<TT.TE.CURRENCY.1>
        END ELSE
            CCY = R.TT<TT.TE.CURRENCY.2>
        END
    END
    RETURN

GET.CUSTOMER.DETAILS:
*-------------------*
    NAMES = ''; CUSTOMER.TYPE = ''; CUSTOMER.CODE = ''
    NATION = R.CUSTOMER<EB.CUS.NATIONALITY>
    YRESID = R.CUSTOMER<EB.CUS.RESIDENCE>
    YGENT = R.CUSTOMER<EB.CUS.GENDER>
    CUS.NATION = R.CUSTOMER<EB.CUS.NATIONALITY>
    CUST.INDUS = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.APAP.INDUS.POS>
    YACC.ID = ACC.ID
    CALL DR.REG.GET.CUST.TYPE(R.CUSTOMER,YACC.ID,CUSTOMER.TYPE,CUSTOMER.CODE)
    GOSUB GET.NAMES
    GOSUB GET.NAME.INITIALS
    RETURN

GET.NAME.INITIALS:
*----------------*
*
    BEGIN CASE
    CASE TIPO.CL.POS.VAL EQ "PERSONA FISICA" OR TIPO.CL.POS.VAL EQ "CLIENTE MENOR"
        NAME.INITIALS = R.CUSTOMER<EB.CUS.FAMILY.NAME>
    CASE TIPO.CL.POS.VAL EQ "PERSONA JURIDICA"
        NAME.INITIALS = R.CUSTOMER<EB.CUS.SHORT.NAME,1>
    END CASE
    RETURN
*-----------------------------------------------------------------------------------
GET.NAMES:
*--------*
    BEGIN CASE
    CASE TIPO.CL.POS.VAL EQ "PERSONA FISICA" OR TIPO.CL.POS.VAL EQ "CLIENTE MENOR"
        NAMES = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
    CASE TIPO.CL.POS.VAL EQ "PERSONA JURIDICA"
        NAMES = R.CUSTOMER<EB.CUS.NAME.1,1>:' ':R.CUSTOMER<EB.CUS.NAME.2,1>
    END CASE
    RETURN
*-----------------------------------------------------------------------------------
TYPE.AC.AFFECTED:
*****************
    IF ARR.ID THEN
        GOSUB GET.PRDT.GROUP
    END
    IF AC.AFFECT EQ '' THEN   ;* find on Az
        GOSUB GET.AC.AFFC.AZ
    END

    IF AC.AFFECT EQ '' THEN
        GOSUB GET.AC.AFFET
    END
    RETURN

GET.PRDT.GROUP:
***************
    ArrangementID = ARR.ID; idPropertyClass = 'ACCOUNT'
    idProperty = ''; effectiveDate = ''; returnIds = ''; returnConditions = ''; returnError = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.AA.ACCOUNT.APP = RAISE(returnConditions)
    AC.AFFECT = R.AA.ACCOUNT.APP<AA.AC.LOCAL.REF,L.CR.FACILITY.POS>
    RETURN

GET.AC.AFFC.AZ:
***************
    R.AZ.ACCOUNT = ''; AZ.ACCOUNT.ERR = ''; ERR.AZ.ACCOUNT = ''
    CALL F.READ(FN.AZ.ACCOUNT,ACC.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ERR)
    IF NOT(R.AZ.ACCOUNT) THEN
        YAZ.HST.ID = ACC.ID
        CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT.HST,YAZ.HST.ID,R.AZ.ACCOUNT,ERR.AZ.ACCOUNT)
    END
    IF R.AZ.ACCOUNT THEN
        AC.AFFECT = R.AZ.ACCOUNT<AZ.LOCAL.REF,L.INV.FACILITY.AZ.POS>
    END
    RETURN

ALT.ACCT.VALUE:
***************
    Y.ALT.ACCT.TYPE = ''; Y.ALT.ACCT.ID = ''; Y.PREV.ACCOUNT = ''
    Y.ALT.ACCT.TYPE=R.ACCOUNT<AC.ALT.ACCT.TYPE>
    Y.ALT.ACCT.ID=R.ACCOUNT<AC.ALT.ACCT.ID>
    LOCATE 'ALTERNO1' IN Y.ALT.ACCT.TYPE<1,1> SETTING ALT.TYPE.POS THEN
        Y.PREV.ACCOUNT = Y.ALT.ACCT.ID<1,ALT.TYPE.POS>
    END
    RETURN

GET.AC.AFFET:
*************
    LOCATE YCATEG IN Y.TXNCAT.VAL.ARR<1,1> SETTING TXNACE.POS THEN
        AC.AFFECT = Y.TXNCAT.DIS.ARR<1,TXNACE.POS>
    END
    RETURN

FMT.FLDS:
*********
    CUST.TYPE = FMT(CUSTOMER.TYPE,'L#2')
    CUST.CODE = FMT(CUSTOMER.CODE,'L#17')
    CUST.NAME = FMT(NAMES,'L#50')       ;*Client Name
    INITIALS = FMT(NAME.INITIALS,'L#30')
    NATION = FMT(NATION,'L#15')
    TYPE.OF.OPER = FMT(TYPE.OPER,'R%2')
    AC.AFFECT = FMT(AC.AFFECT,'L#3')
    IF NOT(NUM(ACC.ID)) THEN
        AC.TYPE.AFFECTED = FIELD(STMT.VAL,'*',2)
    END
    ACC.ID = AC.TYPE.AFFECTED
    GOSUB READ.ACCOUNT
    GOSUB ALT.ACCT.VALUE
    IF Y.PREV.ACCOUNT THEN
        AC.TYPE.AFFECTED = Y.PREV.ACCOUNT
    END
    AC.TYPE.AFFECTED = FMT(AC.TYPE.AFFECTED,'L#27')
    ACC.STATUS = FMT(ACC.STATUS,'L#1')
    AMT.TXN = FMT(AMT.TXN,'R2%14')
    CCY = FMT(CCY,'L#3')
    INTER.OPER = FMT(INTER.OPER,'L#2')
    INTERMEDIARY = FMT(INTERMEDIARY,'L#17')
    INTERM.NAME = FMT(INTERM.NAME,'L#30')
    INTERM.SURNAME = INTERM.SURNAME[1,30]
    INTERM.SURNAME = FMT(INTERM.SURNAME,'L#30')
    INT.NATION = FMT(INT.NATION,'L#15')
    CLNT.TYPE = FMT(CLNT.TYPE,'L#2')
    PERS.BENEF = FMT(PERS.BENEF,'L#17')
    BEN.NAME1 = FMT(BEN.NAME1,'L#50')
    BEN.NAME2 = FMT(BEN.NAME2,'L#30')
    PAIS = FMT(PAIS,'L#15')
    TXN.DATE = FMT(TXN.DATE,'L#10')
    TXN.TIME = FMT(TXN.TIME,'L#5')
    TXN.ACCTS = FMT(YOBSERVATION,'L#60')
    SUSP.TXN = FMT(YSUSP.TXN,'L#1')
    CUST.INDUS = FMT(CUST.INDUS,'R%6')
    PER.PERSON = FMT(PER.PERSON,'L#1')
    CUS.PEP.VAL = FMT(CUS.PEP.VAL,'L#1')
    ACT.INT = FMT(ACT.INT,'R%6')
    PEP.INTERM = FMT(PEP.INTERM,'L#1')
    TYPE.PEP.INT = FMT(TYPE.PEP.INT,'L#1')
    ACT.BEN = FMT(ACT.BEN,'R%6')
    PEP.BEN = FMT(PEP.BEN,'L#1')
    TYPE.PEP.BEN = FMT(TYPE.PEP.BEN,'L#1')

    REP.LINE = CUST.TYPE:CUST.CODE:CUST.NAME:INITIALS:NATION:TYPE.OF.OPER:AC.AFFECT:AC.TYPE.AFFECTED:ACC.STATUS:AMT.TXN:CCY:INTER.OPER:INTERMEDIARY:INTERM.NAME:INTERM.SURNAME:INT.NATION:CLNT.TYPE:PERS.BENEF:BEN.NAME1:BEN.NAME2:PAIS:TXN.DATE:TXN.TIME:TXN.ACCTS:SUSP.TXN:CUST.INDUS:PER.PERSON:CUS.PEP.VAL:ACT.INT:PEP.INTERM:TYPE.PEP.INT:ACT.BEN:PEP.BEN:TYPE.PEP.BEN
    CRT REP.LINE
    RETURN
END
