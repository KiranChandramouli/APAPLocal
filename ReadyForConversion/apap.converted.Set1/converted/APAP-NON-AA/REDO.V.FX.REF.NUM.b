SUBROUTINE REDO.V.FX.REF.NUM
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Chandra Prakash T
* Program Name  : REDO.V.FX.REF.NUM
* ODR NUMBER    : ODR-2010-01-0213
*----------------------------------------------------------------------------------
* Description   : This is an AFTER INAU routine is triggered to update the FXSN table
*                 with records on AUTHORISATION / REVERSAL process
*                 and produce deal slip
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
*----------------------------------------------------------------------------------
* Date             Author             Reference                   Description
* 08-Jul-2010      Chandra Prakash T  ODR-2010-01-0213          Initial creation
* 21-Sep-2010      Chandra Prakash T  ODR-2010-09-0014          CR023-Change Request - CURRENCY MARKET and Exchange Rate
* 31-MAR-2011    SUDHARSANAN S        PACS00052349              Check BUY and SELL txn type based on Currency
* 06-APR-2011    SUDHARSANAN S        PACS00033053              Generate the sequence number for BUY and SELL type Txn.
* 26-APR-2011    SUDHARSANAN S        PACS00054288&PACS00053452 Modify the logic the sequence number logic
* 14-DEC-2011    NAVA V.              FX - GROUP7               Sequential FX number & Conditional generating ticket moved
*                                                               to INPUT event (Only for TT - BUY&SELL - transactions).
* 15-DEC-2011    NAVA V.              FX - GROUP7               Conditional deal slip generation by Transaction type.
* 18-04-2012     Pradeep S            PACS00190839              Data migration fix
* 17-JUN-2012    NAVA V.              FX - GROUP7               Sequential FX number & Conditional ticket generation moved
*                                                               to After UNAU Event.
* 05-JUL-2012    NAVA V.              FX - GROUP7               Deal slip generation process moved to AFTER.UNAU and NAU event.
* 23-JUN-2014    VIGNESH KUMAAR R     PACS00325160              FXSN NUMBER NOT GETTING ASSIGNED
* 16-APR-2018    GOPALA KRISHNAN R    PACS00667498              Instead F.READ command F.READU be used.
* 31-MAY-2018    GOPALA KRISHNAN R    PACS00675435              Modification
*-----------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*
    $INSERT I_F.LOCKING
    $INSERT I_F.USER
    $INSERT I_F.CURRENCY
    $INSERT I_F.FOREX
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
*
    $INSERT I_F.REDO.FOREX.SEQ.NUM
    $INSERT I_F.REDO.FOREX.SELL.SEQ.NUM
    $INSERT I_F.REDO.UPDT.FXSN
    $INSERT I_F.REDO.ISSUE.DEPT.CODE
*
    GOSUB OPEN.FILES
    GOSUB LOCAL.REF.POSITIONS
    GOSUB INITIALISATION
    IF UPDATE.FXSN.FLAG THEN
        GOSUB INCEPT.REVERSAL
    END
*
    GOSUB CHECK.ENTRY.STATUS
*
    IF UPDATE.FXSN.FLAG THEN
        GOSUB CHOOSE.PROCESS
        GOSUB UPDATE.FXN.TABLE
    END
*
*
RETURN
*
*----------------------------------------------------------------------------------
CHECK.ENTRY.STATUS:
*----------------------------------------------------------------------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND UPDATE.FXSN.FLAG DO
        BEGIN CASE
*
            CASE LOOP.CNT EQ 1

* Fix for PACS00325160 [FXSN NUMBER NOT GETTING ASSIGNED]

*            LOCATE USR.BRANCH IN USR.IDC.BRS SETTING BR.POS THEN

                LOCATE ID.COMPANY IN USR.IDC.BRS SETTING BR.POS THEN

* End of Fix
                    USR.IDC.CODE = USR.IDC.CODES<BR.POS>
                    IF NOT(USR.IDC.CODE) THEN
                        UPDATE.FXSN.FLAG = ""
                    END
                END ELSE
                    UPDATE.FXSN.FLAG = ""
                END
*
            CASE LOOP.CNT EQ 2

                CALL CACHE.READ(FN.CURRENCY, CURRENCY.ID, R.CURRENCY, CURRENCY.ERR)
*
                IF R.CURRENCY THEN
                    CCY.FXSN.IND.VALUE = R.CURRENCY<EB.CUR.LOCAL.REF,L.CU.FXSN.IND.POS>
                    IF CCY.FXSN.IND.VALUE EQ "NO" THEN
                        UPDATE.FXSN.FLAG = ""
                    END
                END

            CASE LOOP.CNT EQ 3

                VAR.OFS.OPERATION = OFS$OPERATION
                IF VAR.OFS.OPERATION EQ "VALIDATE" THEN
                    UPDATE.FXSN.FLAG = ""
                END

        END CASE
*
*       Increase
*
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*
*----------------------------------------------------------------------------------
CHOOSE.PROCESS:
*----------------------------------------------------------------------------------
*
    BEGIN CASE
        CASE APPLICATION EQ "FUNDS.TRANSFER"
            GOSUB PROCESS.FT

        CASE APPLICATION EQ "TELLER"
            GOSUB PROCESS.TT

        CASE APPLICATION EQ "FOREX"
            GOSUB PROCESS.FX

    END CASE
*
RETURN
*
*----------------------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------------------
* Opening Files

    FN.REDO.FOREX.SEQ.NUM = 'F.REDO.FOREX.SEQ.NUM'
    F.REDO.FOREX.SEQ.NUM  = ''
*
    FN.REDO.FOREX.SELL.SEQ.NUM = 'F.REDO.FOREX.SELL.SEQ.NUM'
    F.REDO.FOREX.SELL.SEQ.NUM  = ''
*
    FN.FOREX = 'F.FOREX'
    F.FOREX  = ''
*
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  = ''
*
    FN.REDO.ISSUE.DEPT.CODE = 'F.REDO.ISSUE.DEPT.CODE'
    F.REDO.ISSUE.DEPT.CODE  = ''
*
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
*
    FN.REDO.BUY.SEQ.STATUS = 'F.REDO.FOREX.BUY.SEQ.STATUS'
    F.REDO.BUY.SEQ.STATUS  = ''
*
    FN.REDO.SELL.SEQ.STATUS = 'F.REDO.FOREX.SELL.SEQ.STATUS'
    F.REDO.SELL.SEQ.STATUS  = ''
*
    FN.LOCKING   = 'F.LOCKING'
*
    FN.CURRENCY  = 'F.CURRENCY'
*
*PACS00190839 - S
    FN.CUS.L.CU.RNC = 'F.CUSTOMER.L.CU.RNC'
    F.CUS.L.CU.RNC  = ''
*
    FN.CUS.L.CU.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
    F.CUS.L.CU.CIDENT  = ''
*
    FN.CUS.LEGAL.ID = 'F.REDO.CUSTOMER.LEGAL.ID'
    F.CUS.LEGAL.ID  = ''
*
*PACS00190839 - E
*
    CALL OPF(FN.REDO.FOREX.SEQ.NUM,F.REDO.FOREX.SEQ.NUM)
    CALL OPF(FN.REDO.FOREX.SELL.SEQ.NUM,F.REDO.FOREX.SELL.SEQ.NUM)
    CALL OPF(FN.REDO.SELL.SEQ.STATUS,F.REDO.SELL.SEQ.STATUS)
    CALL OPF(FN.REDO.BUY.SEQ.STATUS,F.REDO.BUY.SEQ.STATUS)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.REDO.ISSUE.DEPT.CODE,F.REDO.ISSUE.DEPT.CODE)
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
    CALL OPF(FN.FOREX,F.FOREX)
    CALL OPF(FN.CUS.L.CU.RNC,F.CUS.L.CU.RNC)
    CALL OPF(FN.CUS.L.CU.CIDENT,F.CUS.L.CU.CIDENT)
    CALL OPF(FN.CUS.LEGAL.ID,F.CUS.LEGAL.ID)
*
RETURN
*
*----------------------------------------------------------------------------------
LOCAL.REF.POSITIONS:
*----------------------------------------------------------------------------------
*
    APPL.ARR = "CURRENCY":@FM:"USER":@FM:"FUNDS.TRANSFER":@FM:"TELLER":@FM:"FOREX"

    FT.LOC.FIELDS = "L.FT.FX.BUY.SRC":@VM:"L.FT.FX.SEL.DST":@VM:"L.FT.FXSN.NUM":@VM:"L.FT.LEGAL.ID":@VM:"L.FT.PAY.METHOD":@VM:"L.FT.RCEP.MTHD"
    TT.LOC.FIELDS = "L.TT.FX.BUY.SRC":@VM:"L.TT.FX.SEL.DST":@VM:"L.TT.FXSN.NUM":@VM:"L.TT.LEGAL.ID":@VM:"L.TT.PAY.METHOD":@VM:"L.TT.RCEP.MTHD"
    FX.LOC.FIELDS = "L.FX.FX.BUY.SRC":@VM:"L.FX.FX.SEL.DST":@VM:"L.FX.FXSN.NUM":@VM:"L.FX.LEGAL.ID":@VM:"L.FX.PAY.METHOD":@VM:"L.FX.RCEP.MTHD"
*
    FIELDS.NAME.ARR = "L.CU.FXSN.IND":@FM:"L.US.IDC.CODE":@VM:"L.US.IDC.BR":@FM:FT.LOC.FIELDS:@FM:TT.LOC.FIELDS:@FM:FX.LOC.FIELDS
    FIELD.POS.ARR   = ''
*
    CALL MULTI.GET.LOC.REF(APPL.ARR,FIELDS.NAME.ARR,FIELD.POS.ARR)
*
    L.CU.FXSN.IND.POS   = FIELD.POS.ARR<1,1>
*
    L.US.IDC.CODE.POS   = FIELD.POS.ARR<2,1>
    L.US.IDC.BR.POS     = FIELD.POS.ARR<2,2>
*
    L.FT.FX.BUY.SRC.POS = FIELD.POS.ARR<3,1>
    L.FT.FX.SEL.DST.POS = FIELD.POS.ARR<3,2>
    L.FT.FXSN.NUM.POS   = FIELD.POS.ARR<3,3>
    L.FT.LEGAL.ID.POS   = FIELD.POS.ARR<3,4>
    L.FT.PAY.METHOD.POS = FIELD.POS.ARR<3,5>
    L.FT.RCEP.MTHD.POS  = FIELD.POS.ARR<3,6>
*
    L.TT.FX.BUY.SRC.POS = FIELD.POS.ARR<4,1>
    L.TT.FX.SEL.DST.POS = FIELD.POS.ARR<4,2>
    L.TT.FXSN.NUM.POS   = FIELD.POS.ARR<4,3>
    L.TT.LEGAL.ID.POS   = FIELD.POS.ARR<4,4>
    L.TT.PAY.METHOD.POS = FIELD.POS.ARR<4,5>
    L.TT.RCEP.MTHD.POS  = FIELD.POS.ARR<4,6>
*
    L.FX.FX.BUY.SRC.POS = FIELD.POS.ARR<5,1>
    L.FX.FX.SEL.DST.POS = FIELD.POS.ARR<5,2>
    L.FX.FXSN.NUM.POS   = FIELD.POS.ARR<5,3>
    L.FX.LEGAL.ID.POS   = FIELD.POS.ARR<5,4>
    L.FX.PAY.METHOD.POS = FIELD.POS.ARR<5,5>
    L.FX.RCEP.MTHD.POS  = FIELD.POS.ARR<5,6>
*
RETURN
*
* =============
INITIALISATION:
* =============
*
    L.FXSN.REF.NUM   = ""
    WREC.STATUS      = ""
    UPDATE.FXSN.FLAG = 1
    R.CURRENCY       = ''
    CURRENCY.ERR     = ''
    REV.TXN.TYPE     = ''
    VAR.OFS.OPERATION= ''
*
    BEGIN CASE
*
        CASE (APPLICATION EQ 'TELLER')
            L.FXSN.REF.NUM = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.FXSN.NUM.POS>
            WREC.STATUS    = R.NEW(TT.TE.RECORD.STATUS)
            IF R.NEW(TT.TE.CURRENCY.1) NE LCCY THEN
                CURRENCY.ID = R.NEW(TT.TE.CURRENCY.1)
            END ELSE
                IF R.NEW(TT.TE.CURRENCY.2) NE LCCY THEN
                    CURRENCY.ID = R.NEW(TT.TE.CURRENCY.2)
                END
            END
*
        CASE (APPLICATION EQ 'FUNDS.TRANSFER')
            L.FXSN.REF.NUM = R.NEW(FT.LOCAL.REF)<1,L.FT.FXSN.NUM.POS>
            WREC.STATUS    = R.NEW(FT.RECORD.STATUS)
            IF R.NEW(FT.DEBIT.CURRENCY) NE LCCY THEN
                CURRENCY.ID = R.NEW(FT.DEBIT.CURRENCY)
            END ELSE
                IF R.NEW(FT.CREDIT.CURRENCY) NE LCCY THEN
                    CURRENCY.ID = R.NEW(FT.CREDIT.CURRENCY)
                END
            END
*
        CASE (APPLICATION EQ 'FOREX')
            L.FXSN.REF.NUM = R.NEW(FX.LOCAL.REF)<1,L.FX.FXSN.NUM.POS>
            WREC.STATUS    = R.NEW(FX.RECORD.STATUS)
            IF R.NEW(FX.CURRENCY.BOUGHT) NE LCCY THEN
                CURRENCY.ID = R.NEW(FX.CURRENCY.BOUGHT)
            END ELSE
                IF R.NEW(FX.CURRENCY.SOLD) NE LCCY THEN
                    CURRENCY.ID = R.NEW(FX.CURRENCY.SOLD)
                END
            END
*
        CASE OTHERWISE
            UPDATE.FXSN.FLAG = ''
*
    END CASE
*
    IF CURRENCY.ID EQ '' THEN
        UPDATE.FXSN.FLAG = ''
    END

    USR.IDC.CODES = R.USER<EB.USE.LOCAL.REF,L.US.IDC.CODE.POS>
    USR.IDC.BRS   = R.USER<EB.USE.LOCAL.REF,L.US.IDC.BR.POS>
    USR.BRANCH    = R.USER<EB.USE.CO.CODE>

    CHANGE @SM TO @FM IN USR.IDC.CODES
    CHANGE @SM TO @FM IN USR.IDC.BRS
*
RETURN
*
*----------------------------------------------------------------------------------
INCEPT.REVERSAL:
*----------------------------------------------------------------------------------
*
    IF WREC.STATUS EQ "RNAU" OR WREC.STATUS EQ "RNAO" OR V$FUNCTION EQ 'R' THEN
        REV.TXN.TYPE = L.FXSN.REF.NUM[1,1]
        L.FXSN.REF.NUM = FIELD(L.FXSN.REF.NUM,'-',2)
        IF REV.TXN.TYPE EQ 1 THEN
            GOSUB UPDATE.FXSN.ON.REVE
        END ELSE
            GOSUB UPDATE.FXSN.SELL.ON.REVE
        END
        UPDATE.FXSN.FLAG = ''
    END
*
RETURN
*
*----------------------------------------------------------------------------------
PROCESS.FT:
*----------------------------------------------------------------------------------
*
    FX.TXN.TYPE     = ''
    FXSN.ID.OLD     = ''
    CUSTOMER.NO     = ''
    FX.LEGAL.ID.VAL = ''
*
    IF R.NEW(FT.CREDIT.CURRENCY) NE LCCY THEN
        FX.TXN.TYPE = '2'     ;* SELL type transaction
    END ELSE
        FX.TXN.TYPE = '1'     ;* BUY type transaction
    END

    TXN.VALUE.DATE = R.NEW(FT.DEBIT.VALUE.DATE)
    FXSN.ID.OLD    = R.NEW(FT.LOCAL.REF)<1,L.FT.FXSN.NUM.POS>
    VAR.AMOUNT     = R.NEW(FT.LOC.AMT.CREDITED)

    FXSN.TXN.TYPE.OLD = FXSN.ID.OLD[1,1]
    FXSN.ID.OLD       = FIELD(FXSN.ID.OLD,'-',2)  ;* FXSN.ID.OLD holds existing FXSN ID

    IF R.NEW(FT.LOCAL.REF)<1,L.FT.LEGAL.ID.POS> NE "" THEN
        FX.LEGAL.ID.VAL = R.NEW(FT.LOCAL.REF)<1,L.FT.LEGAL.ID.POS>
        CHANGE "." TO @FM IN FX.LEGAL.ID.VAL
        CUS.IDENTITY.TYPE = FX.LEGAL.ID.VAL<1>
        LEGAL.ID.VAL      = FX.LEGAL.ID.VAL<2>
        CUSTOMER.NAME.VAL = FX.LEGAL.ID.VAL<3>
        GOSUB GET.CUSTOMER.NO
    END
*
RETURN
*
*----------------------------------------------------------------------------------
PROCESS.TT:
*----------------------------------------------------------------------------------
*
    FX.TXN.TYPE     = ''
    FXSN.ID.OLD     = ''
    FX.LEGAL.ID.VAL = ''
*
*PACS00052349 - S
*
    IF R.NEW(TT.TE.DR.CR.MARKER) EQ 'CREDIT' THEN
        IF R.NEW(TT.TE.CURRENCY.1) NE LCCY THEN
            FX.TXN.TYPE = '2' ;* SELL type transaction
        END ELSE
            FX.TXN.TYPE = '1' ;* BUY type transaction
        END
    END
*
*PACS00052349 - E
*
    IF R.NEW(TT.TE.DR.CR.MARKER) EQ 'DEBIT' THEN
        IF R.NEW(TT.TE.CURRENCY.1) NE LCCY THEN
            FX.TXN.TYPE = '1' ;* BUY type transaction
        END ELSE
            FX.TXN.TYPE = '2' ;* SELL type transaction
        END
    END
*
    TXN.VALUE.DATE    = R.NEW(TT.TE.VALUE.DATE.1)
    TXN.DEBIT.ACCT.NO = R.NEW(TT.TE.ACCOUNT.2)
    FXSN.ID.OLD       = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.FXSN.NUM.POS>
    VAR.AMOUNT        = R.NEW(TT.TE.AMOUNT.LOCAL.2)
*
    FXSN.TXN.TYPE.OLD = FXSN.ID.OLD[1,1]
    FXSN.ID.OLD       = FIELD(FXSN.ID.OLD,'-',2)  ;* FXSN.ID.OLD holds existing FXSN ID
    IF R.NEW(TT.TE.LOCAL.REF)<1,L.TT.LEGAL.ID.POS> NE "" THEN
        FX.LEGAL.ID.VAL = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.LEGAL.ID.POS>
        CHANGE "." TO @FM IN FX.LEGAL.ID.VAL
        CUS.IDENTITY.TYPE = FX.LEGAL.ID.VAL<1>
        LEGAL.ID.VAL      = FX.LEGAL.ID.VAL<2>
        CUSTOMER.NAME.VAL = FX.LEGAL.ID.VAL<3>
        GOSUB GET.CUSTOMER.NO
    END
*
RETURN
*
*----------------------------------------------------------------------------------
PROCESS.FX:
*----------------------------------------------------------------------------------
*
    FX.TXN.TYPE     = ''
    FXSN.ID.OLD     = ''
    FX.LEGAL.ID.VAL = ''
*
    IF R.NEW(FX.CURRENCY.SOLD) NE LCCY THEN
        FX.TXN.TYPE    = '2'  ;* SELL type transaction
        TXN.VALUE.DATE = R.NEW(FX.VALUE.DATE.SELL)
        VAR.AMOUNT     = R.NEW(FX.AMOUNT.BOUGHT)
    END ELSE
        FX.TXN.TYPE    = '1'  ;* BUY type transaction
        TXN.VALUE.DATE = R.NEW(FX.VALUE.DATE.BUY)
        VAR.AMOUNT     = R.NEW(FX.AMOUNT.SOLD)
    END
*
    CUSTOMER.NO = R.NEW(FX.COUNTERPARTY)
    FXSN.ID.OLD = R.NEW(FX.LOCAL.REF)<1,L.FX.FXSN.NUM.POS>
*
    FXSN.TXN.TYPE.OLD = FXSN.ID.OLD[1,1]
    FXSN.ID.OLD       = FIELD(FXSN.ID.OLD,'-',2)  ;* FXSN.ID.OLD holds existing FXSN ID

    IF R.NEW(FX.LOCAL.REF)<1,L.FX.LEGAL.ID.POS> NE "" THEN
        FX.LEGAL.ID.VAL = R.NEW(FX.LOCAL.REF)<1,L.FX.LEGAL.ID.POS>
        CHANGE "." TO @FM IN FX.LEGAL.ID.VAL
        LEGAL.ID.VAL      = FX.LEGAL.ID.VAL<2>
        CUSTOMER.NAME.VAL = FX.LEGAL.ID.VAL<3>
    END
*
RETURN
*
*----------------------------------------------------------------------------------
UPDATE.FXN.TABLE:
*----------------------------------------------------------------------------------
*
    R.REDO.FOREX.SEQ.NUM   = ''
    REDO.FOREX.SEQ.NUM.ERR = ''
*
*PACS00033053 - S
* IF FXSN.TXN.TYPE.OLD EQ '1' THEN
*
    IF FX.TXN.TYPE EQ '1' THEN
        CALL F.READ(FN.REDO.FOREX.SEQ.NUM,FXSN.ID.OLD,R.REDO.FOREX.SEQ.NUM,F.REDO.FOREX.SEQ.NUM,REDO.FOREX.SEQ.NUM.ERR)
        GOSUB FORM.BUY.SEQ.NUM
    END ELSE
        CALL F.READ(FN.REDO.FOREX.SELL.SEQ.NUM,FXSN.ID.OLD,R.REDO.FOREX.SELL.SEQ.NUM,F.REDO.FOREX.SELL.SEQ.NUM,REDO.FOREX.SELL.SEQ.NUM.ERR)
        GOSUB FORM.SELL.SEQ.NUM
    END
*PACS00033053 - E
*
RETURN
*
*-----------------
FORM.BUY.SEQ.NUM:
*-----------------
*
    IF R.REDO.FOREX.SEQ.NUM AND R.REDO.FOREX.SEQ.NUM<REDO.FXSN.FX.TXN.ID> EQ ID.NEW THEN  ;*PACS00675435
        FXSN.ID = FXSN.ID.OLD
    END ELSE
*PACS00054288 & PACS00053452 - S
        Y.BUY.SEQ.ID = 'AVAILABLE'
        GOSUB READ.BUY.SEQ.NO
        IF R.BUY.SEQ THEN
            FXSN.ID = R.BUY.SEQ<1>
        END ELSE
            R.LOCKING.REC = ''
            LOCK.ERR      = ''
            LOCK.ID       = FN.REDO.FOREX.SEQ.NUM
            CALL F.READU(FN.LOCKING,LOCK.ID,R.LOCKING.REC,F.LOCKING,LOCK.ERR,'')          ;*PACS00667498
            IF R.LOCKING.REC EQ "" THEN
                R.LOCKING.REC<EB.LOK.CONTENT> = "0000000000"
            END
            VAR.CONTENT = R.LOCKING.REC<EB.LOK.CONTENT>
            FXSN.ID     = VAR.CONTENT + 1
            FXSN.ID     = FMT(FXSN.ID,'R%10')
            R.LOCKING.REC<EB.LOK.CONTENT> = FXSN.ID
            CALL F.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING.REC)
        END
    END
*PACS00054288 & PACS00053452 - E
    FX.TXN.REF = FX.TXN.TYPE : USR.IDC.CODE : "-" : FXSN.ID
    GOSUB GET.TXN.REF
    GOSUB GET.TIME.NOW
*
    IF R.REDO.FOREX.SEQ.NUM<REDO.FXSN.CURR.NO> EQ "" THEN
        R.REDO.FOREX.SEQ.NUM<REDO.FXSN.CURR.NO> = 0
    END
*
    R.REDO.FOREX.SEQ.NUM<REDO.FXSN.FX.SEQ.STATUS>   = "ISSUED"
    R.REDO.FOREX.SEQ.NUM<REDO.FXSN.FX.TXN.ID>       = ID.NEW
    R.REDO.FOREX.SEQ.NUM<REDO.FXSN.TXN.VALUE.DATE>  = TXN.VALUE.DATE
    R.REDO.FOREX.SEQ.NUM<REDO.FXSN.MANUAL.UPDATE>   = "NO"
    R.REDO.FOREX.SEQ.NUM<REDO.FXSN.CUSTOMER.NO>     = CUSTOMER.NO
    R.REDO.FOREX.SEQ.NUM<REDO.FXSN.CUSTOMER.NAME>   = CUSTOMER.NAME.VAL
    R.REDO.FOREX.SEQ.NUM<REDO.FXSN.LEGAL.ID>        = LEGAL.ID.VAL
    R.REDO.FOREX.SEQ.NUM<REDO.FXSN.DESCRIPTION>     = "ISSUED"
    R.REDO.FOREX.SEQ.NUM<REDO.FXSN.AMOUNT>          = VAR.AMOUNT
    R.REDO.FOREX.SEQ.NUM<REDO.FXSN.CURR.NO>        += 1
    R.REDO.FOREX.SEQ.NUM<REDO.FXSN.INPUTTER>        = C$T24.SESSION.NO:"_":OPERATOR
    R.REDO.FOREX.SEQ.NUM<REDO.FXSN.DATE.TIME>       = SYS.TIME.NOW
    R.REDO.FOREX.SEQ.NUM<REDO.FXSN.AUTHORISER>      = C$T24.SESSION.NO:"_":OPERATOR
    R.REDO.FOREX.SEQ.NUM<REDO.FXSN.CO.CODE>         = ID.COMPANY
    R.REDO.FOREX.SEQ.NUM<REDO.FXSN.DEPT.CODE>       = R.USER<EB.USE.DEPARTMENT.CODE>
*
    CALL F.WRITE(FN.REDO.FOREX.SEQ.NUM,FXSN.ID,R.REDO.FOREX.SEQ.NUM)
*
    GOSUB BUY.SEQ.NO.STATUS.UPD
*
RETURN
*
*-----------------
FORM.SELL.SEQ.NUM:
*------------------
*PACS00033053 - S
*
    IF R.REDO.FOREX.SELL.SEQ.NUM AND R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.FX.TXN.ID> EQ ID.NEW THEN       ;*PACS00675435
        FXSN.ID = FXSN.ID.OLD
    END ELSE
* PACS00054288 & PACS00053452 - S
        Y.SELL.SEQ.ID = 'AVAILABLE'
        GOSUB READ.SELL.SEQ.NO
        IF R.SELL.SEQ THEN
            FXSN.ID = R.SELL.SEQ<1>
        END ELSE
            R.LOCKING =''
            LOCK.ERR = ''
            LOCK.ID = FN.REDO.FOREX.SELL.SEQ.NUM
            CALL F.READU(FN.LOCKING,LOCK.ID,R.LOCKING.REC,F.LOCKING,LOCK.ERR,'')          ;*PACS00667498
            IF R.LOCKING.REC EQ "" THEN
                R.LOCKING.REC<EB.LOK.CONTENT> = "0000000000"
            END
            VAR.CONTENT = R.LOCKING.REC<EB.LOK.CONTENT>
            FXSN.ID = VAR.CONTENT + 1
            FXSN.ID = FMT(FXSN.ID,'R%10')
            R.LOCKING.REC<EB.LOK.CONTENT> = FXSN.ID
            CALL F.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING.REC)
        END
    END
* PACS00054288 & PACS00053452 - E
    FX.TXN.REF = FX.TXN.TYPE:USR.IDC.CODE:"-":FXSN.ID
    GOSUB GET.TXN.REF
    GOSUB GET.TIME.NOW
*
    IF R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.CURR.NO> EQ "" THEN
        R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.CURR.NO> = 0
    END
*
    R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.FX.SEQ.STATUS>   = "ISSUED"
    R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.FX.TXN.ID>       = ID.NEW
    R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.TXN.VALUE.DATE>  = TXN.VALUE.DATE
    R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.MANUAL.UPDATE>   = "NO"
    R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.CUSTOMER.NO>     = CUSTOMER.NO
    R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.CUSTOMER.NAME>   = CUSTOMER.NAME.VAL
    R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.LEGAL.ID>        = LEGAL.ID.VAL
    R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.DESCRIPTION>     = "ISSUED"
    R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.AMOUNT>          = VAR.AMOUNT
    R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.CURR.NO>        += 1
    R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.INPUTTER>        = C$T24.SESSION.NO:"_":OPERATOR
    R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.DATE.TIME>       = SYS.TIME.NOW
    R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.AUTHORISER>      = C$T24.SESSION.NO:"_":OPERATOR
    R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.CO.CODE>         = ID.COMPANY
    R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.DEPT.CODE>       = R.USER<EB.USE.DEPARTMENT.CODE>
*
    CALL F.WRITE(FN.REDO.FOREX.SELL.SEQ.NUM,FXSN.ID,R.REDO.FOREX.SELL.SEQ.NUM)
*
    GOSUB SELL.SEQ.NO.STATUS.UPD
*
*PACS00033053 - E
*
RETURN
*
*--------------------------------------------------------------------------------------------------------------------------------------
GET.TXN.REF:
*--------------------------------------------------------------------------------------------------------------------------------------
*
    BEGIN CASE
        CASE ID.NEW[1,2] EQ 'FX'
            R.NEW(FX.LOCAL.REF)<1,L.FX.FXSN.NUM.POS> = FX.TXN.REF
        CASE ID.NEW[1,2] EQ 'FT'
            R.NEW(FT.LOCAL.REF)<1,L.FT.FXSN.NUM.POS> = FX.TXN.REF
        CASE ID.NEW[1,2] EQ 'TT'
            R.NEW(TT.TE.LOCAL.REF)<1,L.TT.FXSN.NUM.POS> = FX.TXN.REF
    END CASE
*
RETURN
*
*----------------------------------------------------------------------------------
GET.TIME.NOW:
*----------------------------------------------------------------------------------
*
    SYS.TIME.NOW  = OCONV(DATE(),"D-")
    SYS.TIME.NOW  = SYS.TIME.NOW[9,2]:SYS.TIME.NOW[1,2]:SYS.TIME.NOW[4,2]
    SYS.TIME.NOW := TIMEDATE()[1,2]:TIMEDATE()[4,2]
*
RETURN
*
*----------------------------------------------------------------------------------
GET.CUSTOMER.NO:
*----------------------------------------------------------------------------------
* PACS00190839 - Logic changed
*
    CUSTOMER.NO = ''
    BEGIN CASE
        CASE CUS.IDENTITY.TYPE EQ "CEDULA"
            R.CUS.CIDENT = ''
            CALL F.READ(FN.CUS.L.CU.CIDENT,LEGAL.ID.VAL,R.CUS.CIDENT,F.CUS.L.CU.CIDENT,CID.ERR)
            CUSTOMER.NO = FIELD(R.CUS.CIDENT,"*",2)

        CASE CUS.IDENTITY.TYPE EQ "RNC"
            R.CUS.RNC = ''
            CALL F.READ(FN.CUS.L.CU.RNC,LEGAL.ID.VAL,R.CUS.RNC,F.CUS.L.CU.RNC,RNC.ERR)
            CUSTOMER.NO = FIELD(R.CUS.RNC,"*",2)

        CASE CUS.IDENTITY.TYPE EQ "PASAPORTE"
            R.CUS.LEGAL = ''
            CALL F.READ(FN.CUS.LEGAL.ID,LEGAL.ID.VAL,R.CUS.LEGAL,F.CUS.LEGAL.ID,LEGAL.ERR)
            CUSTOMER.NO = FIELD(R.CUS.LEGAL,"*",2)

    END CASE
*
RETURN
*
*----------------------------------------------------------------------------------
UPDATE.FXSN.ON.REVE:
*----------------------------------------------------------------------------------
*
    FXSN.ON.REVE.UPDATED   = 0
    R.REDO.FOREX.SEQ.NUM   = ""
    REDO.FOREX.SEQ.NUM.ERR = ""
*
    CALL F.READ(FN.REDO.FOREX.SEQ.NUM,L.FXSN.REF.NUM,R.REDO.FOREX.SEQ.NUM,F.REDO.FOREX.SEQ.NUM,REDO.FOREX.SEQ.NUM.ERR)
    IF R.REDO.FOREX.SEQ.NUM NE "" THEN
        GOSUB GET.TIME.NOW
        R.REDO.FOREX.SEQ.NUM<REDO.FXSN.MANUAL.UPDATE> = "NO"
        R.REDO.FOREX.SEQ.NUM<REDO.FXSN.FX.SEQ.STATUS> = "CANCELLED"
        R.REDO.FOREX.SEQ.NUM<REDO.FXSN.DESCRIPTION>   = "Deal Reversal"
        R.REDO.FOREX.SEQ.NUM<REDO.FXSN.CURR.NO>       = R.REDO.FOREX.SEQ.NUM<REDO.FXSN.CURR.NO> + 1
        R.REDO.FOREX.SEQ.NUM<REDO.FXSN.CURR.NO>      += 1
        R.REDO.FOREX.SEQ.NUM<REDO.FXSN.INPUTTER>      = C$T24.SESSION.NO:"_":OPERATOR
        R.REDO.FOREX.SEQ.NUM<REDO.FXSN.DATE.TIME>     = SYS.TIME.NOW
        R.REDO.FOREX.SEQ.NUM<REDO.FXSN.AUTHORISER>    = C$T24.SESSION.NO:"_":OPERATOR
        R.REDO.FOREX.SEQ.NUM<REDO.FXSN.CO.CODE>       = ID.COMPANY
        R.REDO.FOREX.SEQ.NUM<REDO.FXSN.DEPT.CODE>     = R.USER<EB.USE.DEPARTMENT.CODE>
        CALL F.WRITE(FN.REDO.FOREX.SEQ.NUM,L.FXSN.REF.NUM,R.REDO.FOREX.SEQ.NUM)
        FXSN.ON.REVE.UPDATED = "1"
        FXSN.ID              = L.FXSN.REF.NUM
        Y.BUY.SEQ.ID         = 'ISSUED'
*
        GOSUB READ.BUY.SEQ.NO
        GOSUB BUY.SEQ.NO.REV.UPD
*
    END
*
RETURN
*
*----------------------------------------------------------------------------------
UPDATE.FXSN.SELL.ON.REVE:
*----------------------------------------------------------------------------------
*
    FXSN.ON.REVE.UPDATED        = 0
    R.REDO.FOREX.SELL.SEQ.NUM   = ""
    REDO.FOREX.SELL.SEQ.NUM.ERR = ""
*
    CALL F.READ(FN.REDO.FOREX.SELL.SEQ.NUM,L.FXSN.REF.NUM,R.REDO.FOREX.SELL.SEQ.NUM,F.REDO.FOREX.SELL.SEQ.NUM,REDO.FOREX.SELL.SEQ.NUM.ERR)
    IF R.REDO.FOREX.SELL.SEQ.NUM NE "" THEN
        GOSUB GET.TIME.NOW
        R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.MANUAL.UPDATE> = "NO"
        R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.FX.SEQ.STATUS> = "CANCELLED"
        R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.DESCRIPTION>   = "Deal Reversal"
        R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.CURR.NO>       = R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.CURR.NO> + 1
        R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.CURR.NO>      += 1
        R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.INPUTTER>      = C$T24.SESSION.NO:"_":OPERATOR
        R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.DATE.TIME>     = SYS.TIME.NOW
        R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.AUTHORISER>    = C$T24.SESSION.NO:"_":OPERATOR
        R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.CO.CODE>       = ID.COMPANY
        R.REDO.FOREX.SELL.SEQ.NUM<REDO.FXSN.SELL.DEPT.CODE>     = R.USER<EB.USE.DEPARTMENT.CODE>
*
        CALL F.WRITE(FN.REDO.FOREX.SELL.SEQ.NUM,L.FXSN.REF.NUM,R.REDO.FOREX.SELL.SEQ.NUM)
*
        FXSN.ON.REVE.UPDATED = "1"
        FXSN.ID              = L.FXSN.REF.NUM
        Y.SELL.SEQ.ID        = 'ISSUED'
*
        GOSUB READ.SELL.SEQ.NO
        GOSUB SELL.SEQ.NO.REV.UPD
*
    END
*
RETURN
*
*-----------------------------------------------------------------------------------------------------------------------------------------------------
BUY.SEQ.NO.STATUS.UPD:
*-----------------------------------------------------------------------------------------------------------------------------------------------------
*
*PACS00054288 & PACS00053452 - S
*
    LOCATE FXSN.ID IN R.BUY.SEQ SETTING POS THEN
        DEL R.BUY.SEQ<POS>
        GOSUB WRITE.BUY.SEQ.NO
    END
*
    Y.BUY.SEQ.ID = 'ISSUED'
    GOSUB READ.BUY.SEQ.NO
    LOCATE FXSN.ID IN R.BUY.SEQ SETTING POS ELSE
        IF R.BUY.SEQ THEN
            R.BUY.SEQ<-1> = FXSN.ID
        END ELSE
            R.BUY.SEQ = FXSN.ID
        END
        GOSUB WRITE.BUY.SEQ.NO
    END
*
RETURN
*
*-----------------------------------------------------------------------------------------------------------------------------------------------------
READ.BUY.SEQ.NO:
*-----------------------------------------------------------------------------------------------------------------------------------------------------
    R.BUY.SEQ = ''
    CALL F.READ(FN.REDO.BUY.SEQ.STATUS,Y.BUY.SEQ.ID,R.BUY.SEQ,F.REDO.BUY.SEQ.STATUS,BUY.ERR)
*
RETURN
*
*-----------------------------------------------------------------------------------------------
WRITE.BUY.SEQ.NO:
*-----------------------------------------------------------------------------------------------
    CALL F.WRITE(FN.REDO.BUY.SEQ.STATUS,Y.BUY.SEQ.ID,R.BUY.SEQ)
RETURN
*-----------------------------------------------------------------------------------------------
BUY.SEQ.NO.REV.UPD:
*-------------------------------------------------------------------------------------------------
    LOCATE FXSN.ID IN R.BUY.SEQ SETTING POS THEN
        DEL R.BUY.SEQ<POS>
        GOSUB WRITE.BUY.SEQ.NO
    END
    Y.BUY.SEQ.ID = 'CANCELLED'
    GOSUB READ.BUY.SEQ.NO
    LOCATE FXSN.ID IN R.BUY.SEQ SETTING POS ELSE
        IF R.BUY.SEQ THEN
            R.BUY.SEQ<-1> = FXSN.ID
        END ELSE
            R.BUY.SEQ = FXSN.ID
        END
        GOSUB WRITE.BUY.SEQ.NO
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------------------------------------------
SELL.SEQ.NO.STATUS.UPD:
*-----------------------------------------------------------------------------------------------------------------------------------------------------
    LOCATE FXSN.ID IN R.SELL.SEQ SETTING POS THEN
        DEL R.SELL.SEQ<POS>
        GOSUB WRITE.SELL.SEQ.NO
    END
    Y.SELL.SEQ.ID = 'ISSUED'
    GOSUB READ.SELL.SEQ.NO
    LOCATE FXSN.ID IN R.SELL.SEQ SETTING POS ELSE
        IF R.SELL.SEQ THEN
            R.SELL.SEQ<-1> = FXSN.ID
        END ELSE
            R.SELL.SEQ = FXSN.ID
        END
        GOSUB WRITE.SELL.SEQ.NO
    END
RETURN
*----------------------------------------------------------------------------------------------------------------
READ.SELL.SEQ.NO:
*----------------------------------------------------------------------------------------------------------------
    R.SELL.SEQ = ''
    CALL F.READ(FN.REDO.SELL.SEQ.STATUS,Y.SELL.SEQ.ID,R.SELL.SEQ,F.REDO.SELL.SEQ.STATUS,SELL.ERR)
RETURN
*-----------------------------------------------------------------------------------------------
WRITE.SELL.SEQ.NO:
*-----------------------------------------------------------------------------------------------
    CALL F.WRITE(FN.REDO.SELL.SEQ.STATUS,Y.SELL.SEQ.ID,R.SELL.SEQ)
RETURN
*
*-----------------------------------------------------------------------------------------------
SELL.SEQ.NO.REV.UPD:
*-------------------------------------------------------------------------------------------------
    LOCATE FXSN.ID IN R.SELL.SEQ SETTING POS THEN
        DEL R.SELL.SEQ<POS>
        GOSUB WRITE.SELL.SEQ.NO
    END
    Y.SELL.SEQ.ID = 'CANCELLED'
    GOSUB READ.SELL.SEQ.NO
    LOCATE FXSN.ID IN R.SELL.SEQ SETTING POS ELSE
        IF R.SELL.SEQ THEN
            R.SELL.SEQ<-1> = FXSN.ID
        END ELSE
            R.SELL.SEQ = FXSN.ID
        END
        GOSUB WRITE.SELL.SEQ.NO
    END
RETURN
*PACS00054288 & PACS00053452 - E
*
END
