* @ValidationCode : MjoxNDMzODUzNDc1OkNwMTI1MjoxNjgyNjgxOTE5OTM3OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Apr 2023 17:08:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

*-----------------------------------------------------------------------------
* <Rating>-136</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.V.AUT.ACTIVATE.ACC
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.AUT.ACTIVATE.ACC
*---------------------------------------------------------------------------------

*DESCRIPTION       :Routine changes L.AC.STATUS1 to ACTIVE when FT ,TELLER and TFS
*                   involves account which is not active  and transaction is authorized
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*12/30/2009 -ODR-2009-10-03339
*Development for setting local field L.AC.STATUS1 to ACTIVE and updating PRD.STATUS
*to ACTIVE
*1-JUL-2010-modified for HD1009868-TFS part added
*29-03-20111-Modified for PACS00033264 updating the waive ledger fee to Null value and pass the OFS Message
*PACS00198700 - updating the waive ledger fee to '' value and write
*
* Date             Who                   Reference      Description
* 28.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 28.04.2023       Shanmugapriya M       R22            Manual Conversion   - FM TO @FM, VM TO @VM
*
*-----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.INTEREST.BASIS
    $INSERT I_F.CUSTOMER
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.REDO.CUST.PRD.LIST
    $INSERT I_REDO.TELLER.COMMON
    $INSERT I_F.REDO.TRANUTIL.INTAMT
    $INSERT I_F.REDO.INTRANSIT.CHQ
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.TRANSACTION
    $INSERT I_F.TELLER.TRANSACTION

    GOSUB INIT

    GOSUB FILEOPEN

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB PROCESS.FT
    END ELSE
        IF APPLICATION EQ 'TELLER' THEN
            GOSUB PROCESS.TILL
        END ELSE
            GOSUB TFS.PROCESS
        END
    END

    IF TRAN.UTIL.AMT AND L.TRANSIT.INT NE "Y" THEN
        GOSUB CALC.TRANSIT.INT
        CALL F.WRITE(FN.REDO.INTRANSIT.CHQ,TRANSIT.USAGE.AC,R.REDO.INTRANSIT.CHQ)
    END

RETURN
*----
INIT:
*----

    FN.REDO.INTRANSIT.CHQ = 'F.REDO.INTRANSIT.CHQ'
    F.REDO.INTRANSIT.CHQ = ''
    CALL OPF(FN.REDO.INTRANSIT.CHQ,F.REDO.INTRANSIT.CHQ)

    FN.REDO.TRANUTIL.INTAMT = 'F.REDO.TRANUTIL.INTAMT'
    F.REDO.TRANUTIL.INTAMT = ''
    CALL OPF(FN.REDO.TRANUTIL.INTAMT,F.REDO.TRANUTIL.INTAMT)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    FN.CUST.PRD.LIST='F.REDO.CUST.PRD.LIST'
    F.CUST.PRD.LIST =''
    LREF.APP='ACCOUNT'
    LREF.FIELD='L.AC.STATUS1':@VM:'L.AC.TRAN.AVAIL':@VM:'L.AC.TRANS.INT':


    GET.CHQ.AMOUNT = ''
    GET.UTIL.AMOUNT = ''
    GET.EXPOSURE.DATE = ''
    TOT.CHQ.CNTR = ''
    LOOP.CNTR = ''
    CURR.CHQ.AMOUNT = ''
    CURR.UTIL.AMOUNT = ''
    CURR.EXP.DATE = ''
    AVAILABLE.AMT = ''
    TRANSIT.USAGE.AC = ''
    YET.TO.APPLY = ''
    TRAN.AMT.USED = ''
    AMT.TO.BE.CHARGED = ''
    TOTAL.INT.AMT = ''
    VAR.INT.AMT = ''
    R.REDO.TRANUTIL.INTAMT = ''
    NO.OF.DAYS = ''
    VAR.INT.BASIC.DAYS = ''
    AMT.TO.BE.CHARGED = ''
    IN.TRANSIT.RATE = ''

    FN.REDO.APAP.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.PARAM = ''
    CALL OPF(FN.REDO.APAP.PARAM,F.REDO.APAP.PARAM)

    R.REDO.APAP.PARAM = ''
    CALL CACHE.READ(FN.REDO.APAP.PARAM,'SYSTEM',R.REDO.APAP.PARAM,PARAM.ERR)

    IN.TRANSIT.RATE = R.REDO.APAP.PARAM<CLEAR.PARAM.IN.TRANSIT.RATE>
    VAR.DB.INT.BASIS = R.REDO.APAP.PARAM<CLEAR.PARAM.INTEREST.BASIS>

    FN.INTEREST.BASIS = 'F.INTEREST.BASIS'
    F.INTEREST.BASIS = ''
    CALL OPF(FN.INTEREST.BASIS,F.INTEREST.BASIS)

    CALL CACHE.READ(FN.INTEREST.BASIS,VAR.DB.INT.BASIS,R.INTEREST.BASIS,ERR.INTEREST.BASIS)
    VAR.INT.BASIC.VAL  = R.INTEREST.BASIS<IB.INT.BASIS>
    VAR.INT.BASIC.DAYS = FIELD(VAR.INT.BASIC.VAL,'/',2)

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER =''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.ACCT.FROM.INACT.TO.ACT='F.REDO.ACCT.FROM.INACT.TO.ACT'
    F.REDO.ACCT.FROM.INACT.TO.ACT=''
    CALL OPF(FN.REDO.ACCT.FROM.INACT.TO.ACT,F.REDO.ACCT.FROM.INACT.TO.ACT)

    FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.CONDITION = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FN.TELLER.TRANSACTION =   'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION  = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)
RETURN
*--------
FILEOPEN:
*--------
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.CUST.PRD.LIST,F.CUST.PRD.LIST)

    LREF.POS = ''

    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    L.AC.STAT.POS = LREF.POS<1,1>
    L.TRAN.AVAIL.POS = LREF.POS<1,2>
    L.TRANS.INT.POS = LREF.POS<1,3>

RETURN
*---------
PROCESS.FT:
*---------

    Y.TXN.TYPE = R.NEW(FT.TRANSACTION.TYPE)
    R.REC.FT.TXN.TYPE = ''

    CALL F.READ(FN.FT.TXN.TYPE.CONDITION,Y.TXN.TYPE,R.REC.FT.TXN.TYPE,F.FT.TXN.TYPE.CONDITION,FT.TXN.ERR)
    Y.CR.DEB.ID=R.NEW(FT.CREDIT.ACCT.NO)

    Y.TXN.CODE = R.REC.FT.TXN.TYPE<FT6.TXN.CODE.CR>

    GOSUB GET.TRASACTION.CHECK

    IF Y.INIT.CHECK NE 'BANK' THEN
        GOSUB ACTIVATE
    END

    Y.CR.DEB.ID=R.NEW(FT.DEBIT.ACCT.NO)
    TRANSIT.USAGE.AC = R.NEW(FT.DEBIT.ACCT.NO)
    Y.TXN.CODE = R.REC.FT.TXN.TYPE<FT6.TXN.CODE.DR>
    GOSUB GET.TRASACTION.CHECK

    IF Y.INIT.CHECK NE 'BANK' THEN

        GOSUB ACTIVATE
    END

RETURN
*----------
PROCESS.TILL:
*-----------
    Y.TT.TXN.ID = R.NEW(TT.TE.TRANSACTION.CODE)
    R.TELLER.TRANS = ''

    CALL F.READ(FN.TELLER.TRANSACTION,Y.TT.TXN.ID,R.TELLER.TRANS,F.TELLER.TRANSACTION,ERR.TT.TRA)
    Y.TXN.CODE = R.TELLER.TRANS<TT.TR.TRANSACTION.CODE.1>
    Y.CR.DEB.ID=R.NEW(TT.TE.ACCOUNT.1)
    GOSUB GET.TRASACTION.CHECK

    IF Y.INIT.CHECK NE 'BANK' THEN
        GOSUB ACTIVATE
    END

    Y.CR.DEB.ID=R.NEW(TT.TE.ACCOUNT.2)
    Y.TXN.CODE = R.TELLER.TRANS<TT.TR.TRANSACTION.CODE.2>
    TRANSIT.USAGE.AC = R.NEW(TT.TE.ACCOUNT.2)

    GOSUB GET.TRASACTION.CHECK

    IF Y.INIT.CHECK NE 'BANK' THEN

        GOSUB ACTIVATE
    END
RETURN
*-----------
TFS.PROCESS:
*-----------
    Y.CR.DEB.ID=R.NEW(TFS.PRIMARY.ACCOUNT)
    GOSUB ACTIVATE
    Y.CR.DEB.ID.LIST=R.NEW(TFS.SURROGATE.AC)
    CHANGE @VM TO @FM IN Y.CR.DEB.ID.LIST
    Y.CR.DEB.ID.LIST.SIZE=DCOUNT(Y.CR.DEB.ID.LIST,@FM)

    CNT = 1
    LOOP
    WHILE CNT LE Y.CR.DEB.ID.LIST.SIZE

        Y.CR.DEB.ID=Y.CR.DEB.ID.LIST<CNT>
        GOSUB ACTIVATE
        CNT = CNT + 1
    REPEAT


RETURN


GET.TRASACTION.CHECK:

    CALL F.READ(FN.TRANSACTION,Y.TXN.CODE,R.TRAN,F.TRANSACTION,TRNS.ERR)
    Y.INIT.CHECK = R.TRAN<AC.TRA.INITIATION>

RETURN
*-------
ACTIVATE:



    R.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,Y.CR.DEB.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

    IF R.ACCOUNT<AC.CUSTOMER> THEN

        IF Y.CR.DEB.ID EQ TRANSIT.USAGE.AC THEN
            L.TRANSIT.INT = R.ACCOUNT<AC.LOCAL.REF,L.TRANS.INT.POS>
        END

        IF R.ACCOUNT<AC.LOCAL.REF,L.AC.STAT.POS> NE 'ACTIVE' THEN
            R.ACCOUNT<AC.LOCAL.REF,L.AC.STAT.POS>='ACTIVE'
            Y.CUSTOMER.ID=R.ACCOUNT<AC.CUSTOMER>
*PACS00198700 - S
            R.ACCOUNT<AC.WAIVE.LEDGER.FEE> = ''   ;*Initialising '' instead of given 'NULL' for write

*PACS00198700 - E
            CUST.JOIN='CUSTOMER'
            GOSUB UPD.PRD.LIST
            GOSUB PRD.UPD.JOIN
            GOSUB UPDATE.ACC
        END

    END


RETURN
*------------
UPD.PRD.LIST:
*------------
    R.CUST.PRD.LIST = ''
    CALL F.READ(FN.CUST.PRD.LIST,Y.CUSTOMER.ID,R.CUST.PRD.LIST,F.CUST.PRD.LIST,CUS.ERR)
    IF R.CUST.PRD.LIST THEN
        Y.PRD.LIST=R.CUST.PRD.LIST<PRD.PRODUCT.ID>
    END
    CHANGE @VM TO @FM IN Y.PRD.LIST
    LOCATE Y.CR.DEB.ID IN Y.PRD.LIST SETTING PRD.POS ELSE
    END
    R.CUST.PRD.LIST<PRD.PRD.STATUS,PRD.POS> ='ACTIVE'
    R.CUST.PRD.LIST<PRD.TYPE.OF.CUST,PRD.POS>=CUST.JOIN
    R.CUST.PRD.LIST<PRD.DATE,PRD.POS>=TODAY
    R.CUST.PRD.LIST<PRD.PROCESS.DATE> = TODAY
    CALL F.WRITE(FN.CUST.PRD.LIST,Y.CUSTOMER.ID,R.CUST.PRD.LIST)

    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,ERR)
    R.CUSTOMER<EB.CUS.CUSTOMER.STATUS>='1'
    TEMP.V=V
    V=EB.CUS.AUDIT.DATE.TIME
    CALL F.LIVE.WRITE(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER)
    V=TEMP.V
RETURN
*------------
PRD.UPD.JOIN:
*-------------
    IF R.ACCOUNT<AC.JOINT.HOLDER> NE '' THEN
        Y.CUSTOMER.ID.LIST=R.ACCOUNT<AC.JOINT.HOLDER>
        CHANGE @VM TO @FM IN Y.CUSTOMER.ID.LIST
        Y.JOIN.CUST.CNT=1
        Y.JOIN.CUST.MAX=DCOUNT(Y.CUSTOMER.ID.LIST,@FM)
        LOOP
        WHILE Y.JOIN.CUST.CNT LE Y.JOIN.CUST.MAX
            Y.CUSTOMER.ID=Y.CUSTOMER.ID.LIST<Y.JOIN.CUST.CNT>
            CUST.JOIN='JOINT.HOLDER'
            GOSUB UPD.PRD.LIST
            Y.JOIN.CUST.CNT++
        REPEAT
    END
RETURN
*--------------
UPDATE.ACC:
*-------------
*PACS00198700 - S

*    V = AC.AUDIT.DATE.TIME
*start of performance fix

    Y.AA.ARRANGEMENT=R.ACCOUNT<AC.ARRANGEMENT.ID>
    IF NOT(Y.AA.ARRANGEMENT) THEN
        Y.TODAY=TODAY:'-':OPERATOR
        CALL F.READ(FN.REDO.ACCT.FROM.INACT.TO.ACT,Y.TODAY,R.REDO.ACCT.FROM.INACT.TO.ACT,F.REDO.ACCT.FROM.INACT.TO.ACT,ERR.ACT)
        LOCATE Y.CR.DEB.ID IN R.REDO.ACCT.FROM.INACT.TO.ACT SETTING Y.CU.ACCT.IN.POS ELSE
            R.REDO.ACCT.FROM.INACT.TO.ACT<-1>=Y.CR.DEB.ID
        END
        CALL F.WRITE(FN.REDO.ACCT.FROM.INACT.TO.ACT,Y.TODAY,R.REDO.ACCT.FROM.INACT.TO.ACT)
    END
    TEMP.V=V
    V=AC.AUDIT.DATE.TIME
    CALL F.LIVE.WRITE(FN.ACCOUNT,Y.CR.DEB.ID,R.ACCOUNT)
    V=TEMP.V

*PACS00198700 -E
RETURN
*----------------------
CALC.TRANSIT.INT:


    CALL F.READ(FN.REDO.INTRANSIT.CHQ,TRANSIT.USAGE.AC,R.REDO.INTRANSIT.CHQ,F.REDO.INTRANSIT.CHQ,TRANSIT.ERR)
    IF R.REDO.INTRANSIT.CHQ THEN
        GET.CHQ.AMOUNT = R.REDO.INTRANSIT.CHQ<TRAN.CHQ.CHQ.AMOUNT>
        GET.UTIL.AMOUNT = R.REDO.INTRANSIT.CHQ<TRAN.CHQ.UTILISED.AMT>
        GET.EXPOSURE.DATE = R.REDO.INTRANSIT.CHQ<TRAN.CHQ.EXPOSURE.DATE>
    END

    CHANGE @VM TO @FM IN GET.CHQ.AMOUNT
    CHANGE @VM TO @FM IN GET.UTIL.AMOUNT
    CHANGE @VM TO @FM IN GET.EXPOSURE.DATE

    TOT.CHQ.CNTR = DCOUNT(GET.CHQ.AMOUNT,@FM)
    LOOP.CNTR = 1
    LOOP
    WHILE LOOP.CNTR LE TOT.CHQ.CNTR
        CURR.CHQ.AMOUNT = GET.CHQ.AMOUNT<LOOP.CNTR>
        CURR.UTIL.AMOUNT = GET.UTIL.AMOUNT<LOOP.CNTR>
        CURR.EXP.DATE = GET.EXPOSURE.DATE<LOOP.CNTR>

        IF CURR.UTIL.AMOUNT LT CURR.CHQ.AMOUNT THEN
            AVAILABLE.AMT = CURR.CHQ.AMOUNT - CURR.UTIL.AMOUNT
            IF YET.TO.APPLY THEN
                TRAN.AMT.USED = YET.TO.APPLY
            END ELSE
                TRAN.AMT.USED = TRAN.UTIL.AMT
            END

            IF TRAN.AMT.USED LE AVAILABLE.AMT THEN
                R.REDO.INTRANSIT.CHQ<TRAN.CHQ.UTILISED.AMT,LOOP.CNTR> = R.REDO.INTRANSIT.CHQ<TRAN.CHQ.UTILISED.AMT,LOOP.CNTR> + TRAN.AMT.USED
                AMT.TO.BE.CHARGED = TRAN.AMT.USED
                GOSUB APPLY.INTEREST
                RETURN
            END ELSE
                R.REDO.INTRANSIT.CHQ<TRAN.CHQ.UTILISED.AMT,LOOP.CNTR> = R.REDO.INTRANSIT.CHQ<TRAN.CHQ.UTILISED.AMT,LOOP.CNTR> + AVAILABLE.AMT
                AMT.TO.BE.CHARGED = AVAILABLE.AMT
                GOSUB APPLY.INTEREST
                YET.TO.APPLY = TRAN.UTIL.AMT - AVAILABLE.AMT
            END
        END
        LOOP.CNTR = LOOP.CNTR + 1
    REPEAT


RETURN
*----------------------
APPLY.INTEREST:

    Y.DATE1 = TODAY
    Y.DATE2 = CURR.EXP.DATE
    IF TODAY EQ CURR.EXP.DATE THEN
        NO.OF.DAYS = 1
    END ELSE
        NO.OF.DAYS = "C"
        CALL CDD('',Y.DATE1,Y.DATE2,NO.OF.DAYS)
    END

    VAR.INT.AMT = (AMT.TO.BE.CHARGED * IN.TRANSIT.RATE * (NO.OF.DAYS/VAR.INT.BASIC.DAYS))/100
    TOTAL.INT.AMT = TOTAL.INT.AMT + VAR.INT.AMT
    GOSUB UPDATE.TRANSIT.INT

RETURN
*----------------------

UPDATE.TRANSIT.INT:

    CALL F.READ(FN.REDO.TRANUTIL.INTAMT,TRANSIT.USAGE.AC,R.REDO.TRANUTIL.INTAMT,F.REDO.TRANUTIL.INTAMT,INT.AMT.ERR)
    IF R.REDO.TRANUTIL.INTAMT THEN
        R.REDO.TRANUTIL.INTAMT<TRAN.INT.UTIL.DATE,-1> = TODAY
        R.REDO.TRANUTIL.INTAMT<TRAN.INT.UTIL.AMOUNT,-1> = AMT.TO.BE.CHARGED
        R.REDO.TRANUTIL.INTAMT<TRAN.INT.CALC.INTEREST,-1> = VAR.INT.AMT
        R.REDO.TRANUTIL.INTAMT<TRAN.INT.NO.OF.DAYS,-1> = NO.OF.DAYS
    END ELSE
        R.REDO.TRANUTIL.INTAMT<TRAN.INT.UTIL.DATE> = TODAY
        R.REDO.TRANUTIL.INTAMT<TRAN.INT.UTIL.AMOUNT> = AMT.TO.BE.CHARGED
        R.REDO.TRANUTIL.INTAMT<TRAN.INT.CALC.INTEREST> = VAR.INT.AMT
        R.REDO.TRANUTIL.INTAMT<TRAN.INT.NO.OF.DAYS> = NO.OF.DAYS

    END
    CALL F.WRITE(FN.REDO.TRANUTIL.INTAMT,TRANSIT.USAGE.AC,R.REDO.TRANUTIL.INTAMT)
RETURN
*----------------------

END
