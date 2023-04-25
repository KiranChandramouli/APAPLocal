*-----------------------------------------------------------------------------
* <Rating>4056</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.213IF01.TXN.EXTRACT(REC.ID)
*********
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
* 28-Jul-2014     V.P.Ashokkumar      PACS00309079 - Updated the field mapping and format
* 23-Feb-2017     Bernard Gladin S    Modified based on the RTE process change
* 29-Jun-2017     V.P.Ashokkumar      Fixed to show Joint holder TXN once, Actual loan account
*-----------------------------------------------------------------------------
$INSERT T24.BP I_COMMON
$INSERT T24.BP I_EQUATE
$INSERT T24.BP I_BATCH.FILES
$INSERT T24.BP I_TSA.COMMON
$INSERT T24.BP I_F.DATES
$INSERT T24.BP I_F.CUSTOMER
$INSERT T24.BP I_F.ACCOUNT
$INSERT T24.BP I_F.STMT.ENTRY
$INSERT T24.BP I_F.FUNDS.TRANSFER
$INSERT T24.BP I_F.TELLER
$INSERT T24.BP I_F.AA.TERM.AMOUNT          ;* PACS00309079
$INSERT T24.BP I_F.SEC.TRADE     ;* PACS00309079
$INSERT T24.BP I_F.AZ.ACCOUNT    ;* PACS00309079
$INSERT T24.BP I_F.AA.ARRANGEMENT          ;* PACS00309079
$INSERT T24.BP I_F.AA.PRODUCT.GROUP
$INSERT T24.BP I_F.AA.ACCOUNT
$INSERT T24.BP I_F.ACCOUNT
$INSERT USPLATFORM.BP I_F.T24.FUND.SERVICES
$INSERT T24.BP I_F.COUNTRY
$INSERT T24.BP I_F.CURRENCY
$INSERT LAPAP.BP I_DR.REG.213IF01.TXN.EXTRACT.COMMON
$INSERT REGREP.BP I_F.DR.REG.213IF01.PARAM
$INSERT REGREP.BP I_F.DR.REG.213IF01.CONCAT
$INSERT LAPAP.BP I_F.REDO.RTE.CUST.CASHTXN
*
*    GOSUB PROCESS
GOSUB RTE.PROCESS
RETURN

INIT.PROCESS:
****************
CUST.TYPE = ''; CUST.CODE = ''; CUST.NAME = ''; INITIALS = ''; TXN.DATE = ''; TXN.TIME = ''; TXN.ACCTS = ''; CUST.INDUS = ''
NATION = ''; TYPE.OF.OPER = ''; AC.AFFECT = ''; ACC.STATUS = ''; AMT.TXN = ''; CCY = '';  TT.CUST.2 = ''; CUST.ID = ''; STMT.ENT.VAL = ''
INTER.OPER = ''; INTERMEDIARY = ''; INTERM.NAME = ''; INTERM.SURNAME = ''; INT.NATION = ''; CLNT.TYPE = ''; PERS.BENEF = ''; BEN.NAME1 = ''
BEN.NAME2 = ''; PAIS = ''; R.DR.REG.213IF01.CONCAT = ''; DR.REG.213IF01.CONCAT.ERR = ''; PER.PERSON = ''; CUS.PEP = ''; ACT.INT = ''; PEP.INTERM = ''
TYPE.PEP.INT = ''; ACT.BEN = ''; PEP.BEN = ''; TYPE.PEP.BEN = ''; TT.ACCT.NUM = ''; FT.ACCT.NUM = ''; TT.TRANS.CODE = ''; TT.CUST.1 = ''
Y.FCY.FLAG = ''; YJOINT.VAL = ''
TOT.CASH.AMT = ''
Y.CHQ.TXN.FLAG = ''
Y.AMY.FCY.1 = ''
AMT.LCY = ''; THRESHOLD.FCY = ''; R.CURRENCY = ''; CURR.ERR = ''
CUR.AMLBUY.RATE = ''; YTHRESHOLD.CCY = ''
THRESHOLD.FCY = R.DR.REG.213IF01.PARAM<DR.213IF01.THRESHOLD.AMT>
YTHRESHOLD.CCY = R.DR.REG.213IF01.PARAM<DR.213IF01.THRESHOLD.CCY>

CALL CACHE.READ(FN.CURRENCY,YTHRESHOLD.CCY,R.CURRENCY,CURR.ERR)
CUR.AMLBUY.RATE = R.CURRENCY<EB.CUR.LOCAL.REF,L.CU.AMLBUY.RT.POS>
AMT.LCY = THRESHOLD.FCY * CUR.AMLBUY.RATE

RETURN

RTE.PROCESS:
************

GOSUB INIT.PROCESS

RTE.CUST.ID = REC.ID
CONCAT.ID = REC.ID

R.REDO.RTE.CUST.CASHTXN = '';CUST.DATE = ''
CALL F.READ(FN.REDO.RTE.CUST.CASHTXN,RTE.CUST.ID,R.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN,REDO.RTE.CUST.CASHTXN.ERR)
CNT.TXN = DCOUNT(R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT>,VM)
*    IF R.REDO.RTE.CUST.CASHTXN THEN
*        TOT.CASH.AMT = SUM(R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT>)
*    END
*    AMT.TXN = TOT.CASH.AMT
*    IF AMT.TXN LT AMT.LCY THEN
*        RETURN
*    END
*  Change - New RTE 24 hours process.

CNT.TXN = DCOUNT(R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT>,VM)
IF R.REDO.RTE.CUST.CASHTXN THEN
Y.RTE.TXN.CNT = ''
Y.TXN.CNT = DCOUNT(R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT>,VM)
FOR I = 1 TO Y.TXN.CNT
IF R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,I> NE '' THEN
Y.RTE.TXN.CNT += 1
TOT.CASH.AMT += R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,I>
*                IF TOT.CASH.AMT GE AMT.LCY THEN
Y.ID.COMPANY = R.REDO.RTE.CUST.CASHTXN<RTE.BRANCH.CODE,I>
Y.RTE.TXN.DATE = R.REDO.RTE.CUST.CASHTXN<RTE.TRANS.DATE,I>
AMT.TXN  = R.REDO.RTE.CUST.CASHTXN<RTE.CASH.AMOUNT,I>
Y.TXN.ID = R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID,I>

Y.CNT.REC = DCOUNT(RTE.CUST.ID,'.')

IF Y.CNT.REC EQ 2 THEN				
CUST.ID = FIELD(RTE.CUST.ID,'.',1)
CUST.DATE = FIELD(RTE.CUST.ID,'.',2)				
END ELSE
*Requerimiento CN009150
CUST.ID = '617545'
CUST.DATE = FIELD(RTE.CUST.ID,'.',3)
END

TXN.REF = R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID,I>

GOSUB GET.TXN.DETAILS
*                    GOSUB FORM.RTE.ARR
*                END
END
NEXT I
END


*    CUST.ID = FIELD(RTE.CUST.ID,'.',1)
*    CUST.DATE = FIELD(RTE.CUST.ID,'.',2)
*    TXN.REF = R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID,CNT.TXN>
*    LPJ = CNT.TXN

*  Change - New RTE 24 hours process.
*    GOSUB GET.CUSTOMER.VALUES
*CHECK.DOP.LOOPING:
*    LPJ--
RETURN
*****************
GET.TXN.DETAILS:
*****************

R.FT = ''; R.TT = ''
AML.CHECK.OVERRIDE.ID = 'AML.TXN.AMT.EXCEED'
BEGIN CASE
CASE TXN.REF[1,2] EQ 'FT'
YTXN.REF = TXN.REF
CALL EB.READ.HISTORY.REC(F.FT.HIS,TXN.REF,R.FT,ERRH.FT)
IF NOT(R.FT) THEN
CALL F.READ(FN.FUNDS.TRANSFER,YTXN.REF,R.FT,F.FUNDS.TRANSFER,FT.ERR)
END
IF R.FT THEN

Y.FT.OVERRIDE = R.FT<FT.OVERRIDE>

FINDSTR AML.CHECK.OVERRIDE.ID IN Y.FT.OVERRIDE SETTING OVER.POS THEN
Y.OVERRIDE.FLAG = 'Y'
END ELSE
Y.OVERRIDE.FLAG = ''
RETURN
END

GOSUB GET.CUSTOMER.VALUES
ACC.ID = R.FT<FT.CREDIT.ACCT.NO>
GOSUB GET.STMT.TXN.CODE
GOSUB CHECK.ACCOUNT
GOSUB FT.INTERMEDIARY
INTERM.NAME = R.FT<FT.LOCAL.REF,FT.L.1ST.NAME.POS>:" ":R.FT<FT.LOCAL.REF,FT.L.2ND.NAME.POS>
INTERM.SURNAME = R.FT<FT.LOCAL.REF,FT.LAST.NAME.POS>:" ":R.FT<FT.LOCAL.REF,FT.2ND.LAST.POS>
INT.NATION = R.FT<FT.LOCAL.REF,FT.L.NATIONALITY.POS>
SEX.VAL = R.FT<FT.LOCAL.REF,FT.L.SEX.POS>
GOSUB GET.INTER.OPER
GOSUB GET.BEN.NAME
GOSUB FT.AC.GET.AFFECT
* Fix - 20170515 - Loan Payment
* Fix 20170629
IF AC.AFFECT EQ '181' OR AC.AFFECT EQ '164' OR AC.AFFECT EQ '112' OR AC.AFFECT EQ '163' OR AC.AFFECT EQ '161' THEN
TYPE.OPER = '8'
END
END ELSE
RETURN
END
CASE TXN.REF[1,2] EQ 'TT'
*        TXN.REF = FIELD(TXN.REF,'\',1)
GOSUB READ.TELLER
IF R.TT THEN

Y.TT.OVERRIDE = R.TT<TT.TE.OVERRIDE>

FINDSTR AML.CHECK.OVERRIDE.ID IN Y.TT.OVERRIDE SETTING OVER.POS THEN
Y.OVERRIDE.FLAG = 'Y'
END ELSE
Y.OVERRIDE.FLAG = ''
RETURN
END

IF R.TT<TT.TE.ACCOUNT.1>[1,2] EQ 'PL' THEN
RETURN
*                TXN.REF = R.REDO.RTE.CUST.CASHTXN<RTE.TXN.ID,LPJ>
*                GOTO CHECK.DOP.LOOPING
END
* Add the local field L.TT.CLIENT.COD in multi get loc ref in the load routine to fetch below data.
* Initialise the variable Y.TT.ACC.ID
IF NOT(NUM(CUST.ID)) THEN
CUST.ID = R.TT<TT.TE.LOCAL.REF><1,TT.L.CUSTOMER.CODE.POS>
IF CUST.ID EQ '' OR CUST.ID EQ 'NA' THEN
*                IF CUST.ID EQ '' THEN
RETURN
END
END
ACC.ID = R.TT<TT.TE.ACCOUNT.2>
Y.TT.ACC.ID = R.TT<TT.TE.LOCAL.REF><1,TT.L.CUSTOMER.CODE.POS>
GOSUB GET.CUSTOMER.VALUES
GOSUB GET.STMT.TXN.CODE
GOSUB CHECK.ACCOUNT
GOSUB TT.INTERMEDIARY
INTERM.NAME = R.TT<TT.TE.LOCAL.REF,TT.L.1ST.NAME.POS>:" ":R.TT<TT.TE.LOCAL.REF,TT.L.2ND.NAME.POS>
INTERM.SURNAME = R.TT<TT.TE.LOCAL.REF,TT.LAST.NAME.POS>:" ":R.TT<TT.TE.LOCAL.REF,TT.2ND.LAST.POS>
INT.NATION = R.TT<TT.TE.LOCAL.REF,TT.L.NATIONALITY.POS>
SEX.VAL = R.TT<TT.TE.LOCAL.REF,TT.L.SEX.POS>
GOSUB GET.INTER.OPER
GOSUB GET.BEN.TT
Y.CCY.1 = R.TT<TT.TE.CURRENCY.1>
Y.CCY.2 = R.TT<TT.TE.CURRENCY.2>
IF (Y.CCY.1 NE LCCY AND Y.CCY.1 NE '') OR (Y.CCY.2 NE LCCY AND Y.CCY.2 NE '') THEN
Y.FCY.FLAG = 1
AC.AFFECT = 622
AC.TYPE.AFFECTED = R.TT<TT.TE.LOCAL.REF,L.TT.FXSN.NUM.POS>
IF AC.TYPE.AFFECTED NE '' THEN
AC.TYPE.AFFECTED = FIELD(AC.TYPE.AFFECTED,'-',1):FIELD(AC.TYPE.AFFECTED,'-',2)
END ELSE
Y.TT.CREDIT.CARD.NO = R.TT<TT.TE.LOCAL.REF,TT.L.TT.CR.ACCT.NO.POS>
IF Y.TT.CREDIT.CARD.NO NE '' THEN
AC.AFFECT = 173
AC.TYPE.AFFECTED = Y.TT.CREDIT.CARD.NO
Y.TT.CR.AC.STATUS = R.TT<TT.TE.LOCAL.REF,TT.L.TT.AC.STATUS.POS>
ACC.STATUS = Y.TT.CR.AC.STATUS[1,1]
END
END
IF ACC.STATUS EQ '' THEN
ACC.STATUS = 'A'
END
BEGIN CASE
CASE R.TT<TT.TE.CURRENCY.1> NE LCCY AND R.TT<TT.TE.DR.CR.MARKER> EQ 'CREDIT'
* "V" 6
TYPE.OPER = '5'
CASE R.TT<TT.TE.CURRENCY.2> EQ LCCY AND R.TT<TT.TE.DR.CR.MARKER> EQ 'CREDIT'
* "V" 6
TYPE.OPER = '5'
CASE R.TT<TT.TE.CURRENCY.1> NE LCCY AND R.TT<TT.TE.DR.CR.MARKER> EQ 'DEBIT'
* "C" 5
TYPE.OPER = '6'
CCY = 'DOP'
CASE R.TT<TT.TE.CURRENCY.2> EQ LCCY AND R.TT<TT.TE.DR.CR.MARKER> EQ 'DEBIT'
* "C" 5
TYPE.OPER = '6'
CCY = 'DOP'
END CASE
END
IF Y.FCY.FLAG NE 1 THEN
Y.TT.CREDIT.CARD.NO = R.TT<TT.TE.LOCAL.REF,TT.L.TT.CR.ACCT.NO.POS>
IF Y.TT.CREDIT.CARD.NO NE '' THEN
AC.AFFECT = 173
AC.TYPE.AFFECTED = Y.TT.CREDIT.CARD.NO
Y.TT.CR.AC.STATUS = R.TT<TT.TE.LOCAL.REF,TT.L.TT.AC.STATUS.POS>
ACC.STATUS = Y.TT.CR.AC.STATUS[1,1]
IF ACC.STATUS EQ '' THEN
ACC.STATUS = 'A'
END
END ELSE
Y.CR.DR.MARKER = R.TT<TT.TE.DR.CR.MARKER>
Y.TT.AC1 = R.TT<TT.TE.ACCOUNT.1>
Y.TT.AC2 = R.TT<TT.TE.ACCOUNT.2>
IF NOT(NUM(Y.TT.AC1)) AND NOT(NUM(Y.TT.AC2)) THEN
BEGIN CASE
CASE Y.CR.DR.MARKER  EQ 'CREDIT'
AC.TYPE.AFFECTED = R.TT<TT.TE.ACCOUNT.1>
CASE Y.CR.DR.MARKER  EQ 'DEBIT'
AC.TYPE.AFFECTED = R.TT<TT.TE.ACCOUNT.2>
END CASE
END
END
END

IF AC.TYPE.AFFECTED EQ '' THEN
GOSUB TT.AC.TYPE.AFFECT
END
VAL.DATE= R.TT<TT.TE.DATE.TIME>
GOSUB TYPE.OF.OPERATION
* FIX - TYPE.OPER - 00 - 08
IF Y.FCY.FLAG EQ 1 AND TYPE.OPER EQ '' THEN
Y.TT.CREDIT.CARD.NO = R.TT<TT.TE.LOCAL.REF,TT.L.TT.CR.ACCT.NO.POS>
IF Y.TT.CREDIT.CARD.NO THEN
TYPE.OPER = 8
END
END

IF TT.TRANS.CODE EQ 10 AND TYPE.OPER EQ 1 THEN
AC.AFFECT = 213
END			

END ELSE
RETURN
END
CASE TXN.REF[1,5] EQ 'T24FS'
CALL F.READ(FN.T24FS,TXN.REF,R.T24FS,F.T24FS,T24FS.ERR)
IF NOT(R.T24FS) THEN
CALL EB.READ.HISTORY.REC(F.T24FS.HIS,TXN.REF,R.T24FS,ERRH.T24FS)
END
IF R.T24FS THEN

Y.TFS.OVERRIDE = R.T24FS<TFS.OVERRIDE>

FINDSTR AML.CHECK.OVERRIDE.ID IN Y.TFS.OVERRIDE SETTING OVER.POS THEN
Y.OVERRIDE.FLAG = 'Y'
END ELSE
Y.OVERRIDE.FLAG = ''
RETURN
END

Y.TFS.ACT.VERSION = R.T24FS<TFS.LOCAL.REF,L.T24FS.TRA.DAY.POS>
ACC.ID = R.T24FS<TFS.PRIMARY.ACCOUNT>
LOCATE Y.TFS.ACT.VERSION IN Y.TFS.SERVICE.VERSIONS<1,1> SETTING TFS.SERVICE.POS THEN
ACC.ID = R.T24FS<TFS.LOCAL.REF,L.FT.ADD.INFO.POS>
END

IF NOT(NUM(ACC.ID)) THEN
RETURN
END
Y.TFS.ACCT.DR = R.T24FS<TFS.ACCOUNT.DR>
Y.TFS.ACCT.CR = R.T24FS<TFS.ACCOUNT.CR>
Y.TFS.AC.CNT = DCOUNT(Y.TFS.ACCT.DR,VM)
Y.TFS.ACT.VERSION = R.T24FS<TFS.LOCAL.REF,L.T24FS.TRA.DAY.POS>
LOCATE Y.TFS.ACT.VERSION IN Y.TFS.LCY.VERSIONS<1,1> SETTING TFS.LCY.POS THEN
FOR V = 1 TO Y.TFS.AC.CNT
IF NUM(Y.TFS.ACCT.DR<1,V>) OR NUM(Y.TFS.ACCT.CR<1,V>) THEN
Y.TFS.TT.REF = R.T24FS<TFS.UNDERLYING,V>
IF Y.TFS.TT.REF[1,2] EQ 'TT' THEN
CALL F.READ(FN.TELLER,Y.TFS.TT.REF,R.TT,F.TELLER,TT.ERR)
IF NOT(R.TT) THEN
CALL EB.READ.HISTORY.REC(F.TT.HIS,Y.TFS.TT.REF,R.TT,ERRH.TT)
END
IF R.TT THEN
ACC.ID = R.TT<TT.TE.ACCOUNT.2>
Y.TT.ACC.ID = R.TT<TT.TE.LOCAL.REF><1,TT.L.CUSTOMER.CODE.POS>
GOSUB GET.CUSTOMER.VALUES
GOSUB GET.STMT.TXN.CODE

GOSUB CHECK.ACCOUNT
END
END
GOSUB GET.TFS.DETAILS
IF AC.TYPE.AFFECTED EQ '' THEN
AC.TYPE.AFFECTED = ACC.ID
END
END
NEXT V
END
LOCATE Y.TFS.ACT.VERSION IN Y.TFS.SERVICE.VERSIONS<1,1> SETTING TFS.SERVICE.POS THEN
GOSUB GET.CUSTOMER.VALUES
AC.AFFECT = 231
* Fix - 20170515 - Certificates
TYPE.OPER = '2'
AC.TYPE.AFFECTED = ACC.ID
R.AZ.ACCOUNT = ''; AZ.ACCOUNT.ERR = ''; ERR.AZ.ACCOUNT = ''
CALL F.READ(FN.AZ.ACCOUNT,AC.TYPE.AFFECTED,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ERR)
IF NOT(R.AZ.ACCOUNT) THEN
YAZ.HST.ID = AC.TYPE.AFFECTED
CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT.HST,YAZ.HST.ID,R.AZ.ACCOUNT,ERR.AZ.ACCOUNT)
END
IF R.AZ.ACCOUNT THEN
ACC.STATUS = R.AZ.ACCOUNT<AZ.LOCAL.REF,AZ.L.AC.STATUS.POS>
ACC.STATUS = ACC.STATUS[1,1]
END
GOSUB GET.TFS.DETAILS
END
END ELSE
RETURN
END
END CASE

IF INTERMEDIARY EQ '' THEN
INTERMEDIARY = CUSTOMER.CODE
END

IF VAL.DATE THEN
TXN.DATE = VAL.DATE[5,2]:"/":VAL.DATE[3,2]:"/":TODAY[1,2]:VAL.DATE[1,2]
TXN.TIME = VAL.DATE[7,2]:":":VAL.DATE[9,2]
END

CUS.PEP.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CUS.PEP.POS>
CU.PERS.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.PEPS.POS>
IF CU.PERS.VAL EQ 'SI' THEN
PER.PERSON = 'S'
END ELSE
PER.PERSON = 'N'
END
IF Y.OVERRIDE.FLAG EQ 'Y' THEN
GOSUB FMT.FLDS
END
IF (YJOINT.VAL AND YJOINT.VAL EQ CUST.ID) THEN
RETURN
END

IF ymend EQ 0 OR Y.LAST.WORK.DAY EQ CUST.DATE THEN
CONCAT.ID := '.':TXN.REF
CALL F.WRITE(FN.DR.REG.213IF01.WORKFILE, CONCAT.ID, REP.LINE)
END

IF ymend EQ 1 THEN
CONCAT.ID = "MTH-":REC.ID:'.':TXN.REF
CALL F.WRITE(FN.DR.REG.213IF01.WORKFILE, CONCAT.ID, REP.LINE)
END
RETURN

READ.TELLER:
************
R.TT = ''; TT.ERR = ''; ERRH.TT = ''
CALL F.READ(FN.TELLER,TXN.REF,R.TT,F.TELLER,TT.ERR)
IF NOT(R.TT) THEN
CALL EB.READ.HISTORY.REC(F.TT.HIS,TXN.REF,R.TT,ERRH.TT)
END
RETURN

GET.TFS.DETAILS:
****************

INTERMEDIARY = R.T24FS<TFS.LOCAL.REF,L.NEW.ID.CARD.POS>
IF INTERMEDIARY EQ '' THEN
INTERMEDIARY = R.T24FS<TFS.LOCAL.REF,L.OLD.ID.CARD.POS>
END
IF INTERMEDIARY THEN
INTERMEDIARY = FMT(INTERMEDIARY,'R%11')
INTERMEDIARY = INTERMEDIARY[1,3]:'-':INTERMEDIARY[4,7]:'-':INTERMEDIARY[11,1]
END
IF INTERMEDIARY EQ '' THEN
INTERMEDIARY = R.T24FS<TFS.LOCAL.REF,L.PASSPORT.POS>
END
INTERM.NAME = R.T24FS<TFS.LOCAL.REF,L.1ST.NAME.POS>:" ":R.T24FS<TFS.LOCAL.REF,L.2ND.NAME.POS>
INTERM.SURNAME = R.T24FS<TFS.LOCAL.REF,L.LAST.NAME.POS>:" ":R.T24FS<TFS.LOCAL.REF,L.2ND.LAST.NAME.POS>
INT.NATION = R.T24FS<TFS.LOCAL.REF,L.NATIONALITY.POS>
SEX.VAL = R.T24FS<TFS.LOCAL.REF,L.SEX.POS>
GOSUB GET.INTER.OPER

BEN.NAME1 = R.T24FS<TFS.LOCAL.REF,L.TT.BENEFICIAR.POS>
BEN.NAME2 = BEN.NAME1

CLNT.TYPE = ''
PAIS = ''

ID.PERS.BENEF = R.T24FS<TFS.LOCAL.REF,L.TT.BENEFICIAR.POS>

GOSUB BENIF.IDENT
ACT.INT = R.T24FS<TFS.LOCAL.REF,L.ACT.INT.POS>
PEP.INTERM = R.T24FS<TFS.LOCAL.REF,L.PEP.INTERM.POS>
TYPE.PEP.INT = R.T24FS<TFS.LOCAL.REF,L.TYPE.PEP.INT.POS>
ACT.BEN = R.T24FS<TFS.LOCAL.REF,L.ACT.BEN.POS>
PEP.BEN = R.T24FS<TFS.LOCAL.REF,L.PEP.BEN.POS>
TYPE.PEP.BEN = R.T24FS<TFS.LOCAL.REF,L.TYPE.PEP.BEN.POS>
* GOSUB TT.AC.TYPE.AFFECT
VAL.DATE= R.T24FS<TFS.DATE.TIME>
*                    GOSUB TYPE.OF.OPERATION
CCY = R.T24FS<TFS.CURRENCY>

RETURN
CHECK.ACCOUNT:
**************

ACC.CODE.AFFCT.LIST = R.DR.REG.213IF01.PARAM<DR.213IF01.AC.AF.CODE>
CHANGE VM TO FM IN ACC.CODE.AFFCT.LIST

*    IF NOT(NUM(ACC.ID)) THEN
*        ACC.ID = Y.TT.ACC.ID
*    END

IF NOT(ACC.ID) THEN
ACC.ID = R.STMT.ENTRY<AC.STE.NARRATIVE,1>
END
GOSUB READ.ACCOUNT
IF R.ACCOUNT THEN
AC.TYPE.AFFECTED = ''; ARR.ID = ''; YCATEG = ''; YAC.FACIL = ''
ARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
YCATEG = R.ACCOUNT<AC.CATEGORY>
YAC.FACIL = R.ACCOUNT<AC.LOCAL.REF,L.INV.FACILITY.POS>
GOSUB GET.ACC.STATUS
GOSUB TYPE.AC.AFFECTED
END
RETURN

*******************
GET.STMT.TXN.CODE:
*******************

R.ACCT.ENT.LWORK.DAY = ''; ACCT.ENT.LWORK.DAY.ERR = ''; YACCT.ID = REC.ID; YSUSP.FLG = 0
CALL F.READ(FN.ACCT.ENT.LWORK.DAY,ACC.ID,R.ACCT.ENT.LWORK.DAY,F.ACCT.ENT.LWORK.DAY,ACCT.ENT.LWORK.DAY.ERR)
*    CALL F.READ(FN.ACCT.ENT.TODAY,ACC.ID,R.ACCT.ENT.LWORK.DAY,F.ACCT.ENT.TODAY,ACCT.ENT.TODAY.ERR)
IF R.ACCT.ENT.LWORK.DAY THEN
CTR.STMT.ID = 1
CNT.STMT.ID = DCOUNT(R.ACCT.ENT.LWORK.DAY,FM)
LOOP
WHILE CTR.STMT.ID LE CNT.STMT.ID
R.STMT.ENTRY = ''; STMT.ENTRY.ERR = ''; AMT.FCY.VAL = ''; YCCY = ''; YTRANS.TYPE = ''
AMT.LCY.VAL = ''; TXN.FT.TT = ''; YSTMT.CUST = ''; AMT.VAL = ''; RTE.FORM.VAL = ''
STMT.VAL = R.ACCT.ENT.LWORK.DAY<CTR.STMT.ID>
CALL F.READ(FN.STMT.ENTRY,STMT.VAL,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENTRY.ERR)
YSTMT.CUST = R.STMT.ENTRY<AC.STE.CUSTOMER.ID>
IF YSTMT.CUST THEN
ACCT.TYPE = R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
RETURN
END
* CONCAT.ID = YSTMT.CUST:'-':LAST.WRK.DATE
* GOSUB PROCESS.1
CTR.STMT.ID += 1
REPEAT
END

RETURN

FT.INTERMEDIARY:
***************
INTERMEDIARY = R.FT<FT.LOCAL.REF,FT.L.NEW.ID.CARD.POS>
IF INTERMEDIARY EQ '' THEN
INTERMEDIARY = R.FT<FT.LOCAL.REF,FT.L.OLD.ID.CARD.POS>
END
IF INTERMEDIARY THEN
INTERMEDIARY = FMT(INTERMEDIARY,'R%11')
INTERMEDIARY = INTERMEDIARY[1,3]:'-':INTERMEDIARY[4,7]:'-':INTERMEDIARY[11,1]
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
IF INTERMEDIARY THEN
INTERMEDIARY = FMT(INTERMEDIARY,'R%11')
INTERMEDIARY = INTERMEDIARY[1,3]:'-':INTERMEDIARY[4,7]:'-':INTERMEDIARY[11,1]
END
IF INTERMEDIARY EQ '' THEN
INTERMEDIARY = R.TT<TT.TE.LOCAL.REF,TT.L.PASSPORT.POS>
END
RETURN

FT.AC.GET.AFFECT:
*****************
AC.TYPE.AFFECTED = R.FT<FT.DEBIT.ACCT.NO>
CCY = R.FT<FT.DEBIT.CURRENCY>
VAL.DATE = R.FT<FT.DATE.TIME>
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
* FIX 20170629
YJOINT.VAL = R.ACCOUNT<AC.JOINT.HOLDER,1>
RETURN

GET.BEN.TT:
***********
* Fix - 20170515
*    BEN.NAME1 = R.TT<TT.TE.LOCAL.REF,TT.BEN.NAME.POS>
BEN.NAME1 = R.TT<TT.TE.LOCAL.REF,TT.BEN.NAME.POS,1>
BEN.NAME2 = BEN.NAME1
IF BEN.NAME1 NE '' THEN
Y.CHQ.TXN.FLAG = 'Y'
END
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
INTER.OPER = CUSTOMER.TYPE
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
CASE AAR.STATUS.VAL EQ 'PENDING.CLOSURE' OR AAR.STATUS.VAL EQ 'EXPIRED' OR AAR.STATUS.VAL EQ 'REVERSED' OR AAR.STATUS.VAL EQ 'CANCELLED' OR AAR.STATUS.VAL EQ 'CLOSED'
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
TT.TRANS.CODE = ''; OPR.POS = ''
TT.TRANS.CODE = R.TT<TT.TE.TRANSACTION.CODE>
IF AC.AFFECT EQ '622' AND (R.TT<TT.TE.CURRENCY.1> NE 'DOP' OR R.TT<TT.TE.CURRENCY.2> NE 'DOP') ELSE
LOCATE TT.TRANS.CODE IN Y.TXNACC.VAL.ARR<1,1> SETTING TXNTPE.POS THEN
TYPE.OPER = Y.TXNACC.DIS.ARR<1,TXNTPE.POS>
END
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
* Fix - FX Txn Currency
Y.AMY.FCY.1 = R.TT<TT.TE.AMOUNT.FCY.1>
IF Y.AMY.FCY.1 NE '' THEN
CCY = R.TT<TT.TE.CURRENCY.1>
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
*    CALL DR.REG.GET.CUST.TYPE(R.CUSTOMER,YACC.ID,CUSTOMER.TYPE,CUSTOMER.CODE)
CALL DR.REG.GET.CUST.TYPE(R.CUSTOMER,OUT.ARR)
CUSTOMER.TYPE  = OUT.ARR<1>
CUSTOMER.CODE = OUT.ARR<2>

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
* Fix - 20170515
NAMES = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
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
TYPE.OPER = '8'
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
* Fix 20170629
IF AC.AFFECT EQ '' THEN
IF (YCATEG GE 3000 AND YCATEG LE 3099) THEN
AC.AFFECT = '112'
END
IF (YCATEG GE 3100 AND YCATEG LE 3199) THEN
AC.AFFECT = '161'
END
IF (YCATEG GE 3200 AND YCATEG LE 3299) THEN
AC.AFFECT = '181'
END
END
IF YCATEG[1,1] EQ 3 THEN
TYPE.OPER = '8'
END
RETURN

GET.NATIONALITY:
****************
R.COUNTRY = ''
COUNTRY.ERR = ''
IF Y.NATION NE '' THEN
CALL F.READ(FN.COUNTRY,Y.NATION,R.COUNTRY,F.COUNTRY,COUNTRY.ERR)
IF R.COUNTRY THEN
Y.NATION = R.COUNTRY<EB.COU.SHORT.NAME>
END
END
RETURN

FMT.FLDS:
*********
CUST.TYPE = FMT(CUSTOMER.TYPE,'L#2')
CUST.CODE = FMT(CUSTOMER.CODE,'L#17')
CUST.NAME = FMT(NAMES,'L#50')       ;*Client Name
INITIALS = FMT(NAME.INITIALS,'L#30')
*    Y.NATION = NATION
*    GOSUB GET.NATIONALITY
*    NATION = Y.NATION
NATION = FMT(NATION,'L#15')
IF AC.AFFECT EQ '111' OR YAC.FACIL EQ '111' THEN
TYPE.OPER = '8'
END
TYPE.OF.OPER = FMT(TYPE.OPER,'R%2')
* Fix - 20170515
IF TYPE.OPER EQ 7 THEN
AC.AFFECT = 618
END
IF NOT(AC.AFFECT) THEN
AC.AFFECT = YAC.FACIL
*TT.TRANS.CODE
END

IF Y.TT.CREDIT.CARD.NO NE '' THEN
AC.AFFECT = 173
END

AC.AFFECT = FMT(AC.AFFECT,'L#3')

ACC.ID = AC.TYPE.AFFECTED
IF NOT(NUM(ACC.ID)) THEN
*        AC.TYPE.AFFECTED = FIELD(STMT.VAL,'*',2)
AC.TYPE.AFFECTED = YACC.ID
END
IF NOT(ACC.ID) THEN
ACC.ID = R.STMT.ENTRY<AC.STE.NARRATIVE,1>
END
GOSUB READ.ACCOUNT
GOSUB ALT.ACCT.VALUE
IF Y.PREV.ACCOUNT THEN
AC.TYPE.AFFECTED = Y.PREV.ACCOUNT
END
IF NOT(AC.TYPE.AFFECTED) THEN
AC.TYPE.AFFECTED = ''
END
AC.TYPE.AFFECTED = FMT(AC.TYPE.AFFECTED,'L#27')
IF NOT(ACC.STATUS) THEN
ACC.STATUS = ''
END
ACC.STATUS = FMT(ACC.STATUS,'L#1')
AMT.TXN = FMT(AMT.TXN,'R2%14')
CCY = FMT(CCY,'L#3')

* To assign the main customer details to the Intermediary and Benefiaciary column if they are null.

IF TRIM(INTERM.NAME) EQ '' OR TRIM(INTERM.SURNAME) EQ '' THEN
BEGIN CASE
CASE TIPO.CL.POS.VAL EQ "PERSONA FISICA" OR TIPO.CL.POS.VAL EQ "CLIENTE MENOR"
INTERM.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
INTERM.SURNAME = R.CUSTOMER<EB.CUS.FAMILY.NAME>
CASE TIPO.CL.POS.VAL EQ "PERSONA JURIDICA"
INTERM.NAME = R.CUSTOMER<EB.CUS.NAME.1,1>
INTERM.SURNAME = R.CUSTOMER<EB.CUS.NAME.2,1>
END CASE
*  INTERM.NAME  = CUST.NAME[1,30]
END

IF NOT(INTERM.SURNAME) THEN
INTERM.SURNAME = INITIALS
END

IF INT.NATION EQ '' THEN
INT.NATION = NATION
END
*    Y.NATION = INT.NATION
*    GOSUB GET.NATIONALITY
*    INT.NATION = Y.NATION
*   IF Y.CHQ.TXN.FLAG NE 'Y' THEN
IF CLNT.TYPE EQ '' THEN
CLNT.TYPE = CUSTOMER.TYPE
END

IF PERS.BENEF EQ '' THEN
PERS.BENEF = CUSTOMER.CODE
END
IF PAIS EQ '' THEN
PAIS = NATION
END
IF PAIS EQ '' THEN
PAIS = INT.NATION
END
*        Y.NATION = PAIS
*        GOSUB GET.NATIONALITY
*        PAIS = Y.NATION
*    END

IF BEN.NAME1 EQ '' THEN
BEN.NAME1 = INTERM.NAME
END

IF BEN.NAME2 EQ '' THEN
BEN.NAME2 = INTERM.SURNAME
END

YOBSERVATION = ''

SUSP.TXN = ''

IF ACT.INT EQ '000000' OR ACT.INT EQ '' THEN
ACT.INT = CUST.INDUS
END

IF ACT.BEN EQ '000000' OR ACT.BEN EQ '' THEN
ACT.BEN = CUST.INDUS
END
IF INTER.OPER EQ '' THEN
INTER.OPER = CUSTOMER.TYPE
END
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
* Fix - 20170515
YSUSP.TXN = 'N'
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