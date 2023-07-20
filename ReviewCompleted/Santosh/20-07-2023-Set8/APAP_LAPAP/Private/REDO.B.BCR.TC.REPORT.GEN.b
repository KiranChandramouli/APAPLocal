$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.BCR.TC.REPORT.GEN(Y.AA.ID)
*-----------------------------------------------------------------------------
* Mutli-threaded Close of Business routine
*
*-----------------------------------------------------------------------------
* Modification History:
* Revision History:
* -----------------
* Date       Name              Reference                     Version
* --------   ----              ----------                    --------
*
* 06/02/2018 Ashokkumar        APAP                          REmove the Product 'LINEAS.DE.CREDITO.TC'(Credit card) from the report.
*------------------------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-07-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM,INSERT FILE MODIFIED
*13-07-2023              Samaran T                R22 Manual Code conversion                         CALL RTN FORMAT MODIFIED
*------------------------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON  ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.COUNTRY
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_F.CATEGORY
    $INSERT I_REDO.B.BCR.TC.REPORT.GEN.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
    $INSERT I_F.REDO.APAP.CREDIT.CARD.DET  ;*R22 AUTO CODE CONVERSION.END
    $USING APAP.AA
    $USING APAP.TAM


    CALL OCOMO(" processing Y.AA.ID [" : Y.AA.ID : "]")
*
*-----------------------------------------------------------------------------
    K.ID.PROC = Y.AA.ID

* Initiliaze variables
    GOSUB INITIALISE
    IF Y.ERROR THEN
        RETURN
    END
    Y.MAIN.ARR.PRCT = R.AA<AA.ARR.PRODUCT,1>

* Check whether it is a cancelled loan. then check if it is closed previous month.
    PROP.CLASS = 'PAYMENT.SCHEDULE'; PROPERTY = ''; EFF.DATE = ''; R.CONDITION = ''
    ERR.MSG = ''; R.AA.PAYMENT.SCHEDULE = ''
*CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
    APAP.AA.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG) ;*R22 MANUAL CODE CONVERSION
    R.AA.PAYMENT.SCHEDULE = R.CONDITION
    GOSUB CHECK.CANCELLED.LOAN

    IF Y.PAST.MONTH.CLOSED.LOAN EQ 'YES' THEN
        CALL OCOMO("Loan skipped for closed last month - ":Y.AA.ID:" - ":YARR.EFFDTE:"/":Y.LAST.MONTH.ACT)
        RETURN
    END
    Y.STATUS.DD = ''; Y.PAID.BILLS.CNT = ''; Y.ROLE = ''
    IF R.AA.PAYMENT.SCHEDULE THEN
        Y.STATUS.DD  = R.AA.PAYMENT.SCHEDULE<AA.PS.LOCAL.REF,PAYMT.METHOD.POS>
        Y.PAID.BILLS.CNT = R.AA.PAYMENT.SCHEDULE<AA.PS.LOCAL.REF,POS.L.PAID.BILL.CNT>
    END
    LOCATE Y.STATUS.DD IN Y.PAYR.VAL.ARR<1,1> SETTING C.PAYR.POS THEN
        CALL OCOMO("Loan skipped for the APAP employee payment - ":Y.AA.ID:" - ":Y.STATUS.DD)
        RETURN
    END
* Get AA information

    GOSUB EXTRACT.INFO
    IF Y.ERROR THEN
        RETURN
    END

* Get and Write MainHolder info
    Y.OWNER = ''
    Y.CUSTOMER.ID = Y.PRIMARY.OWNER
    GOSUB WRITE.DATA

    CALL OCOMO("ending [" : Y.AA.ID : "]")
RETURN

*-----------------------------------------------------------------------------
CHECK.CANCELLED.LOAN:
*-----------------------------------------------------------------------------
    Y.PAST.MONTH.CLOSED.LOAN = ''; Y.LINKED.APP.ID = ''; YPOST.REST = ''; YDTE.LST = ''
    YRECORD.STAT = ''; YCLOSE.DATE = ''; Y.TC.ACCOUNT = ''; Y.CC.ACCOUNT = ''
    Y.ARR.STAT = R.AA<AA.ARR.ARR.STATUS>
    Y.LINKED.APP.ID = R.AA<AA.ARR.LINKED.APPL.ID,1>
    Y.START = R.AA<AA.ARR.START.DATE,1>
    R.ACCOUNT = ''; Y.ACC.ERR = ''; YOD.STAT = ''; YPOST.REST = ''
    CALL F.READ(FN.ACCOUNT,Y.LINKED.APP.ID,R.ACCOUNT,F.ACCOUNT,Y.ACC.ERR)
    IF NOT(R.ACCOUNT) THEN
        YACC.HID = Y.LINKED.APP.ID
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HST,YACC.HID,R.ACCOUNT,ERR.ACCOUNT)
    END
    IF R.ACCOUNT THEN
        YCATEG = R.ACCOUNT<AC.CATEGORY>
        YPOST.REST = R.ACCOUNT<AC.POSTING.RESTRICT,1>
        YRECORD.STAT = R.ACCOUNT<AC.RECORD.STATUS>
        YDTE.LST = R.ACCOUNT<AC.CLOSURE.DATE>
        Y.ALT.ACCT.TYPE = R.ACCOUNT<AC.ALT.ACCT.TYPE>
        Y.ALT.ACCT.ID = R.ACCOUNT<AC.ALT.ACCT.ID>
        LOCATE 'T.DEBITO.1' IN Y.ALT.ACCT.TYPE<1,1> SETTING ALT.TYPE.POS THEN
            Y.TC.ACCOUNT = Y.ALT.ACCT.ID<1,ALT.TYPE.POS>
            Y.TC.ACCOUNT = TRIM(Y.TC.ACCOUNT,'0',"L")
            Y.TCACCOUNT = FMT(Y.TC.ACCOUNT,'R%19')
        END
        LOCATE 'T.DEBITO.2' IN Y.ALT.ACCT.TYPE<1,1> SETTING ALT.TYPE.POSN THEN
            Y.CC.ACCOUNT = Y.ALT.ACCT.ID<1,ALT.TYPE.POSN>
            Y.CC.ACCOUNT = TRIM(Y.CC.ACCOUNT,'0',"L")
            Y.CC.ACCOUNT = Y.CC.ACCOUNT[1,4]:'-':Y.CC.ACCOUNT[5,2]:'XX-XXXX-':Y.CC.ACCOUNT[13,4]
        END
    END
    IF NOT(YDTE.LST) THEN
        YDTE.LST = R.ACCOUNT<AC.DATE.LAST.UPDATE>
    END

    GOSUB GET.ACTUAL.BALANCE
    Y.MAIN.PROD.GROUP = R.AA<AA.ARR.PRODUCT.GROUP,1>
    REQD.MODE = ''; EFF.DATE = Y.START; R.AA.ACTIVITY.HISTORY = ''
    CALL AA.READ.ACTIVITY.HISTORY(Y.AA.ID, REQD.MODE, EFF.DATE, R.AA.ACTIVITY.HISTORY)
    IF R.AA.ACTIVITY.HISTORY THEN
        YACT.ID.ARR = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY>
        YACT.IS.STAT = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.STATUS>
        YACT.EFF.DATE = R.AA.ACTIVITY.HISTORY<AA.AH.SYSTEM.DATE>
        CHANGE @VM TO @FM IN YACT.ID.ARR   ;*R22 AUTO CODE CONVERSION
        CHANGE @SM TO @FM IN YACT.ID.ARR  ;*R22 AUTO CODE CONVERSION
        CHANGE @VM TO @FM IN YACT.IS.STAT ;*R22 AUTO CODE CONVERSION
        CHANGE @SM TO @FM IN YACT.IS.STAT ;*R22 AUTO CODE CONVERSION
        CHANGE @VM TO @FM IN YACT.EFF.DATE ;*R22 AUTO CODE CONVERSION
        CHANGE @SM TO @FM IN YACT.EFF.DATE ;*R22 AUTO CODE CONVERSION
    END
    ERR.REDO.APAP.PROPERTY.PARAM = ''; R.REDO.APAP.PROPERTY.PARAM = ''; YPAYOFF.ACT = ''; YPAY.CNT = 0
    CALL F.READ(FN.REDO.APAP.PROPERTY.PARAM,Y.MAIN.PROD.GROUP,R.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM,ERR.REDO.APAP.PROPERTY.PARAM)
    IF R.REDO.APAP.PROPERTY.PARAM THEN
        YPAYOFF.ACT = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PAYOFF.ACTIVITY>
        YPAY.CNT = DCOUNT(YPAYOFF.ACT,@VM)  ;*R22 AUTO CODE CONVERSION
    END

    YCNT = 1
    LOOP
    WHILE YCNT LE YPAY.CNT
        YPAYOFF.ACT.1 = ''; YARR.EFFDTE = ''; YARR.STAT = ''
        YPAYOFF.ACT.1 = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PAYOFF.ACTIVITY,YCNT>
        LOCATE YPAYOFF.ACT.1 IN YACT.ID.ARR<1> SETTING CHG.POSN.1 THEN
            YARR.STAT = YACT.IS.STAT<CHG.POSN.1>
            YARR.EFFDTE = YACT.EFF.DATE<CHG.POSN.1>
            IF YARR.STAT EQ 'AUTH' AND YARR.EFFDTE LT Y.LAST.MONTH.ACT AND Y.ACC.AMT EQ 0 THEN
                Y.PAST.MONTH.CLOSED.LOAN = 'YES'
                YCNT = YPAY.CNT + 1
                CONTINUE
            END
            IF YARR.STAT EQ 'AUTH' AND YARR.EFFDTE GE Y.LAST.MONTH.ACT AND Y.ACC.AMT NE 0 THEN
                Y.PAST.MONTH.CLOSED.LOAN = 'CURRNT'
                YCNT = YPAY.CNT + 1
                CONTINUE
            END
            IF YARR.STAT EQ 'AUTH' AND YARR.EFFDTE GE Y.LAST.MONTH.ACT THEN
                Y.PAST.MONTH.CLOSED.LOAN = 'CURRNT'
                YCNT = YPAY.CNT + 1
                CONTINUE
            END
        END
        YCNT += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT

    IF ((YPOST.REST EQ '90' OR YPOST.REST EQ '75' OR YRECORD.STAT EQ 'CLOSED') AND NOT(Y.PAST.MONTH.CLOSED.LOAN)) THEN
        IF (YDTE.LST[1,6] EQ Y.LAST.MONTH AND YDTE.LST NE '') AND Y.ACC.AMT NE 0 THEN
            Y.PAST.MONTH.CLOSED.LOAN = 'CURRNT'
        END ELSE
            Y.PAST.MONTH.CLOSED.LOAN = 'YES'
            YARR.EFFDTE = YDTE.LST
        END
    END
RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.ERROR  = @FALSE
    R.AA = ''; Y.ERR = ''; R.REDO.LOG = ''
    CALL F.READ(FN.AA,Y.AA.ID,R.AA,F.AA,Y.ERR)
    Y.ORG.ARRANGEMENT=R.AA<AA.ARR.ORIG.CONTRACT.DATE>
    IF NOT(Y.ORG.ARRANGEMENT) THEN
        Y.ORG.ARRANGEMENT = R.AA<AA.ARR.PROD.EFF.DATE>
    END
    IF Y.ERR NE '' THEN
        RETURN
    END
    LOC.REF.FIELDS = ""; C.VALD.POS = ''
    Y.TEL.OTR=''; Y.TEL.OFI=''
    Y.CUSTOMER.ID=R.AA<AA.ARR.CUSTOMER>
*    Y.DATA.ID=UNIQUEKEY ()
    Y.TEL.CASA=0; Y.TEL.OFI=0
    Y.TEL.CEL=0; Y.TEL.OTR=0; Y.COUNTRY=''
    Y.TOTAL.CUOTAS = 0        ;* PACS00191153
    Y.LASTPAY.AMT = ''        ;* PACS00191153
    Y.LASTPAY.DAT = ''        ;* PACS00191153
    Y.CURRENCY=0; Y.MNTPAY=0
    Y.BALACT=0; Y.MONTOMORA=0; Y.NUMCUOMORA=0; Y.STATUS=''
    Y.LOAN.STATUS=''; Y.LOAN.COND=''; Y.PRIMARY.OWNER=''
    Y.OWNER=''; Y.AA.CUS.ID=''; Y.TEL.ID=0; Y.TEL.AREA=''
    Y.TEL.NUM=''; Y.TEL.EXT=''; Y.TEL.TOT=0; Y.DIRECCION=''
    Y.PRODUCT=''; Y.MONTO=0; Y.FCORTE=''; Y.AA.BILL3=''
    NO.OF.DAYS=''; Y.PREV.DATE=''; Y.NEXT.DATE=''; Y.SALDO1 = 0
    Y.SALDO2 = 0; Y.SALDO3 = 0; Y.SALDO4 = 0; Y.SALDO5 = 0
    Y.SALDO6 = 0; Y.SALDO7 = 0; Y.BUSCAR=0; Y.ESTADO=''
RETURN

*--------------------------------------------------------------------------------
EXTRACT.INFO:
*--------------------------------------------------------------------------------
* Currency
    BEGIN CASE
        CASE R.AA<AA.ARR.CURRENCY> EQ 'DOP'
            Y.CURRENCY = 1
        CASE R.AA<AA.ARR.CURRENCY> EQ 'USD'
            Y.CURRENCY = 2
        CASE 1
            Y.CURRENCY = "MONEDA [" : R.AA<AA.ARR.CURRENCY> : "] NO DEFINIDA"
    END CASE

*---- AA customer
* << PACS00191153
    idPropertyClass = "CUSTOMER"
    GOSUB ARR.CONDITIONS
    IF returnError THEN
        E = returnError
        RETURN
    END

    IF Y.TC.ACCOUNT THEN
        ERR.REDO.APAP.CREDIT.CARD.DET = ''; R.REDO.APAP.CREDIT.CARD.DET = ''; YORG = ''; YDESCRIP = ''
        CALL F.READ(FN.REDO.APAP.CREDIT.CARD.DET,Y.TC.ACCOUNT,R.REDO.APAP.CREDIT.CARD.DET,F.REDO.APAP.CREDIT.CARD.DET,ERR.REDO.APAP.CREDIT.CARD.DET)
        YORG = R.REDO.APAP.CREDIT.CARD.DET<CRDT.CARD.CARD.ORG>
        YDESCRIP = R.REDO.APAP.CREDIT.CARD.DET<CRDT.CARD.CARD.DESCRIPTION>

        R.AA.CUSTOMER = RAISE(returnConditions)
        Y.PRIMARY.OWNER=R.AA.CUSTOMER<AA.CUS.CUSTOMER>

        Y.PRODUCT= R.AA<AA.ARR.PRODUCT.GROUP,1>
*---- AA details
        CALL F.READ(FN.AA.DETAILS,Y.AA.ID,R.AA.DETAILS,F.AA.DETAILS,Y.ERR)
        IF Y.ERR NE '' THEN
            RETURN
        END
*---- AA term
* << PACS00191153
        idPropertyClass = "TERM.AMOUNT"
        GOSUB ARR.CONDITIONS
        IF returnError THEN
            E = returnError
            RETURN
        END
        R.AA.TERM = RAISE(returnConditions)
        Y.MONTO = R.AA.TERM<AA.AMT.AMOUNT>

        IF Y.MONTO EQ 0 OR Y.MONTO EQ '' THEN
            Y.ORG.TERM.ID = Y.AA.ID : "-COMMITMENT-" : Y.ORG.ARRANGEMENT:'.1'
            CALL F.READ(FN.AA.TERM,Y.ORG.TERM.ID,R.AA.TERM.AMOUNT,F.AA.TERM,Y.TERM.ERR)
            Y.MONTO=R.AA.TERM.AMOUNT<AA.AMT.AMOUNT>
        END

        IF Y.MONTO EQ '' THEN
            Y.MONTO=0
        END

        CALL OCOMO("AA terms info done")
*---- AA num cuotas
* Get AccountId associated with the current AA.ID
        Y.ACCOUNT.ID = ''
        LOCATE "ACCOUNT" IN R.AA<AA.ARR.LINKED.APPL, 1> SETTING Y.POS.ACCT THEN
            Y.ACCOUNT.ID = R.AA<AA.ARR.LINKED.APPL.ID, Y.POS.ACCT>
        END ELSE
            RETURN
        END

        Y.BILL.SETCNT = R.AA.DETAILS<AA.AD.BILLS.SETTLED.CNT>
        Y.AD.BILL.LIST  = R.AA.DETAILS<AA.AD.BILL.ID>       ;* Based on the logic of REDO.S.FC.AA.MNTPAY
        CHANGE @SM TO @VM IN Y.AD.BILL.LIST  ;*R22 AUTO CODE CONVERSION
        Y.TOTAL.DB = DCOUNT(Y.AD.BILL.LIST, @VM)   ;*R22 AUTO CODE CONVERSION
        YBILL.CNT = Y.TOTAL.DB

        GOSUB GET.BALANCES    ;* Balances by segment.

        CALL OCOMO("Balances done [" : Y.SALDO1 : "] [" : Y.SALDO2 : "] [" :Y.SALDO3 : "] [" :Y.SALDO4 : "] [" :Y.SALDO5: "] [" :Y.SALDO6 : "] [" :Y.SALDO7 : "]" )
*---- Rutinas - monto de la cuota

        Y.TOTAL.CUOTAS = Y.PAID.BILLS.CNT

        IF (Y.LASTPAY.DAT EQ '' AND Y.ACC.AMT EQ 0 AND Y.ARR.STAT EQ 'PENDING.CLOSURE' AND Y.FCORTE EQ '') THEN
            CALL OCOMO("Loan skipped for PENDING.CLOSURE status with last payment didnt happen - ":Y.AA.ID:" - ":Y.LASTPAY.DAT:"/":Y.LAST.MONTH.ACT)
            Y.ERROR = 1
            RETURN
        END

        IF Y.BALACT ELSE
            Y.BALACT = ''
        END
        GOSUB GET.AA.STATUS
        CALL OCOMO("Other info get ends")
        RETURN

GET.BALANCES:
*-----------------------------------------------------------------------------

        Y.UNPAID.BILL.CNT = 0; Y.FCORTE = 0
        Y.UNPAID.BILL.AMT = 0
        Y.CNT = 0; Y.VAR1 = 1
        LOOP
        WHILE Y.CNT NE YBILL.CNT
            Y.AA.BILL3 = Y.AD.BILL.LIST<1,YBILL.CNT,1>
            GOSUB READ.BILL.AA
            GOSUB GET.RESPECTIVES.AMOUNT
            YBILL.TYPE = R.AA.BILL3<AA.BD.BILL.TYPE>
            IF Y.FCORTE EQ 0 THEN
                LOCATE 'PAYMENT' IN YBILL.TYPE<1,1> SETTING YPOSN THEN
                    LOCATE 'DUE' IN R.AA.BILL3<AA.BD.BILL.STATUS,1> SETTING Y.POS THEN
                        Y.FCORTE = R.AA.BILL3<AA.BD.BILL.ST.CHG.DT, Y.POS>
                    END
                END
            END

            IF R.AA.BILL3<AA.BD.BILL.STATUS,1> NE 'SETTLED' AND SUM(R.AA.BILL3<AA.BD.OS.PROP.AMOUNT>) GT 0 THEN
                NO.OF.DAYS  = 'C'
                Y.PREV.DATE = R.AA.BILL3<AA.BD.PAYMENT.DATE>
                Y.NEXT.DATE = TODAY
                CALL CDD('',Y.PREV.DATE,Y.NEXT.DATE,NO.OF.DAYS)
                IF NO.OF.DAYS GT 30 THEN
                    Y.UNPAID.BILL.CNT += 1  ;*R22 AUTO CODE CONVERSION
                    Y.UNPAID.BILL.AMT+=SUM(R.AA.BILL3<AA.BD.OS.PROP.AMOUNT>)
                END
                BEGIN CASE
                    CASE (NO.OF.DAYS GE 31) AND (NO.OF.DAYS LE 60)
                        Y.SALDO1=Y.SALDO1+ SUM(R.AA.BILL3<AA.BD.OS.PROP.AMOUNT>)
                    CASE (NO.OF.DAYS GE 61) AND (NO.OF.DAYS LE 90)
                        Y.SALDO2=Y.SALDO2+ SUM(R.AA.BILL3<AA.BD.OS.PROP.AMOUNT>)
                    CASE (NO.OF.DAYS GE 91) AND (NO.OF.DAYS LE 120)
                        Y.SALDO3=Y.SALDO3+ SUM(R.AA.BILL3<AA.BD.OS.PROP.AMOUNT>)
                    CASE (NO.OF.DAYS GE 121) AND (NO.OF.DAYS LE 150)
                        Y.SALDO4=Y.SALDO4+ SUM(R.AA.BILL3<AA.BD.OS.PROP.AMOUNT>)
                    CASE (NO.OF.DAYS GE 151) AND (NO.OF.DAYS LE 180)
                        Y.SALDO5=Y.SALDO5+ SUM(R.AA.BILL3<AA.BD.OS.PROP.AMOUNT>)
                    CASE (NO.OF.DAYS GE 181) AND (NO.OF.DAYS LE 210)
                        Y.SALDO6=Y.SALDO6+ SUM(R.AA.BILL3<AA.BD.OS.PROP.AMOUNT>)
                    CASE (NO.OF.DAYS GE 211)
                        Y.SALDO7=Y.SALDO7+ SUM(R.AA.BILL3<AA.BD.OS.PROP.AMOUNT>)
                END CASE
            END
            YBILL.CNT -= 1
            Y.VAR1 += 1 ;*R22 AUTO CODE CONVERSION
        REPEAT
        Y.MONTOMORA  = Y.UNPAID.BILL.AMT
        Y.NUMCUOMORA = Y.UNPAID.BILL.CNT

        IF Y.FCORTE EQ 0 THEN
            ERR.AA.DETAILS.HST = ''; R.AA.DETAILS.HST = ''; Y.AD.BILL.LISTH = ''; Y.TOTAL.DBH = ''
            CALL F.READ(FN.AA.DETAILS.HST,Y.AA.ID,R.AA.DETAILS.HST,F.AA.DETAILS.HST,ERR.AA.DETAILS.HST)
            IF R.AA.DETAILS.HST THEN
                Y.AD.BILL.LISTH  = R.AA.DETAILS.HST<AA.AD.BILL.DATE>
                CHANGE @SM TO @VM IN Y.AD.BILL.LISTH  ;*R22 AUTO CODE CONVERSION
                Y.TOTAL.DBH = DCOUNT(Y.AD.BILL.LISTH, @VM)
                Y.FCORTE = Y.AD.BILL.LISTH<1,Y.TOTAL.DBH>
            END
        END
        IF Y.FCORTE EQ 0 AND Y.TOTAL.DB GE 1 AND R.AA.DETAILS THEN
            Y.AD.BILL.LISTH  = R.AA.DETAILS<AA.AD.BILL.DATE>
            CHANGE @SM TO @VM IN Y.AD.BILL.LISTH
            Y.TOTAL.DBH = DCOUNT(Y.AD.BILL.LISTH, @VM) ;*R22 AUTO CODE CONVERSION
            Y.FCORTE = Y.AD.BILL.LISTH<1,Y.TOTAL.DBH>
        END
        IF Y.FCORTE EQ 0 THEN
            Y.FCORTE = ''
        END
        RETURN

READ.BILL.AA:
*************
        Y.ERR = ''; R.AA.BILL3 = ''
        CALL F.READ(FN.AA.BILL,Y.AA.BILL3,R.AA.BILL3,F.AA.BILL,Y.ERR)
        IF NOT(R.AA.BILL3) THEN
            Y.ERR.BILL = ''
            CALL F.READ(FN.AA.BILL.HST,Y.AA.BILL3,R.AA.BILL3,F.AA.BILL.HST,Y.ERR.BILL)
        END
        R.BILL.DETAILS = Y.AA.BILL3
        RETURN

*---------------------------------------------------
GET.RESPECTIVES.AMOUNT:
*---------------------------------------------------
        Y.PROPERTIES  =  R.BILL.DETAILS<AA.BD.PROPERTY>
        Y.PROP.CNT    =  DCOUNT(Y.PROPERTIES,@VM)
        Y.VAR2 = 1
        LOOP
        WHILE Y.VAR2 LE Y.PROP.CNT
            Y.PROPERTY = Y.PROPERTIES<1,Y.VAR2>
            GOSUB GET.AMOUNT
            R.ARRAY<2,Y.VAR1,Y.VAR2> = Y.PROPERTY
            R.ARRAY<3,Y.VAR1,Y.VAR2> = R.BILL.DETAILS<AA.BD.OR.PROP.AMOUNT,Y.VAR2> + ADJ.AMOUNT
            R.ARRAY<4,Y.VAR1>        = R.ARRAY<4,Y.VAR1> + (R.BILL.DETAILS<AA.BD.OR.PROP.AMOUNT,Y.VAR2> + ADJ.AMOUNT)
            Y.VAR2 += 1
        REPEAT
        Y.FIN.AMT = SUM(R.ARRAY<4>)
        RETURN

*-------------------------------------
GET.AMOUNT:
*-------------------------------------
        Y.EXCLUSION.ADJ.STATUS = 'SUSPEND':@VM:'CAPTURE.BILL':@VM:'RESUME'
        Y.FINAL.AMOUNT = 0
        ADJ.AMOUNT     = 0
        Y.ADJUSTED.REF = R.BILL.DETAILS<AA.BD.ADJUST.REF,Y.VAR2>
        Y.ADJUSTED.AMT = R.BILL.DETAILS<AA.BD.ADJUST.AMT,Y.VAR2>
        Y.ADJUSTED.CNT = DCOUNT(Y.ADJUSTED.REF,@SM)
        Y.VAR3 = 1
        LOOP
        WHILE Y.VAR3 LE Y.ADJUSTED.CNT
            Y.ADJUSTED.ID = Y.ADJUSTED.REF<1,1,Y.VAR3>
            Y.SECOND.PART = FIELD(Y.ADJUSTED.ID,'-',2)
            IF Y.SECOND.PART MATCHES Y.EXCLUSION.ADJ.STATUS ELSE
                ADJ.AMOUNT += Y.ADJUSTED.AMT<1,1,Y.VAR3>
            END
            Y.VAR3 += 1
        REPEAT
        RETURN

*-----------------------------------------------------------------------------
WRITE.DATA:         * PACS00060197: Write a record for each loan debtor
*-----------------------------------------------------------------------------

        GOSUB GET.CUSTOMER.INFO

        IF Y.ERROR THEN
            RETURN
        END
        YFLD1            = Y.ENTIDAD
        YFLD8            = ''
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS> EQ 'PERSONA JURIDICA' THEN
            YFLD7    = R.CUSTOMER<EB.CUS.NAME.1>:' ':R.CUSTOMER<EB.CUS.NAME.2>
        END
        YCUSTOMERID = ''; YCUSTOMERID = FMT(Y.CUSTOMER.ID,'R%15'):'/':YORG
        YFLD2          = YCUSTOMERID
        YFLD3             = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
        YFLD5          = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.CIDENT.POS>
        YFLD4          = YFLD5
        YFLD9          = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.RNC.POS>  ;*PENDIENTE X Q ESTOY TOMANDO RNC DE LA EMPRESA
        YFLD6          = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
        YFLD10          = Y.TEL.CASA
        YFLD11       = Y.TEL.OFI
        YFLD12       = Y.TEL.CEL
        YFLD13             = ''         ;* NO APLICA
        YFLD14                = ''      ;* NO APLICA
        YFLD15          = Y.TEL.OTR
        YFLD16         = R.CUSTOMER<EB.CUS.STREET>
        YFLD17         = ''   ;* NO APLICA
        YFLD18        = Y.DIRECCION<1,1>
        YFLD19         = ''   ;* NO APLICA
        YFLD20          = Y.DIRECCION<1,1>
        YFLD21          = Y.DIRECCION<1,1>
        YFLD22           = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.URB.ENS.RE.POS>
        YFLD23        = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.RES.SECTOR.POS>
        YFLD24        = Y.COUNTRY
        YFLD25        = R.CUSTOMER<EB.CUS.TOWN.COUNTRY>
        YFLD26         = ''   ;* NO EN TRANSUNION
        YFLD27         = ''   ;* NO EN TRANSUNION
        YFLD28        = Y.DIRECCION<1,2>
        YFLD29         = ''   ;* NO EN TRANSUNION
        YFLD30          = Y.DIRECCION<1,2>
        YFLD31          = Y.DIRECCION<1,2>
        YFLD32           = '' ;* NO EN TRANSUNION
        YFLD33        = ''    ;* NO EN TRANSUNION
        YFLD34        = ''    ;* NO EN TRANSUNION
        YFLD35        = ''    ;* NO EN TRANSUNION
        YFLD36        = Y.TCACCOUNT
        YFLD37        = Y.CC.ACCOUNT
        YFLD38        = Y.CURRENCY
        YFLD39        = YDESCRIP
        IF R.AA<AA.ARR.ORIG.CONTRACT.DATE> THEN
            YFLD40     = R.AA<AA.ARR.ORIG.CONTRACT.DATE>
        END ELSE
            YFLD40     = R.AA<AA.ARR.START.DATE>
        END
        GOSUB SET.CANCEL.MONTO
*        YFLD41      = R.AA.DETAILS<AA.AD.MATURITY.DATE>
        YFLD44            = '0'         ;* NO EN TRANSUNION
        YFLD45        = ''    ;* NO EN TRANSUNION
        YFLD41            = Y.FCORTE
        YFLD42            = Y.LASTPAY.DAT         ;* PACS00191153
        YFLD43       = FIELD(Y.LASTPAY.AMT,'.',1) ;* PACS00191153. No decimals required.
        YFLD46          = FIELD(Y.BALACT,'.',1)   ;* No decimals required.
        YFLD47       = FIELD(Y.MONTO,'.',1)
        YFLD48       = FIELD(Y.MONTOMORA,'.',1)   ;* No decimals required.
        YFLD49      = Y.NUMCUOMORA
        YFLD50        = Y.STATUS
        YFLD51         = Y.ESTADO
        YFLD52            = FIELD(Y.SALDO1,'.',1) ;* No decimals required.
        YFLD53            = FIELD(Y.SALDO2,'.',1) ;* No decimals required.
        YFLD54            = FIELD(Y.SALDO3,'.',1) ;* No decimals required.
        YFLD55            = FIELD(Y.SALDO4,'.',1) ;* No decimals required.
        YFLD56            = FIELD(Y.SALDO5,'.',1) ;* No decimals required.
        YFLD57            = FIELD(Y.SALDO6,'.',1) ;* No decimals required.
        YFLD58            = FIELD(Y.SALDO7,'.',1) ;* No decimals required.

        YDELIM = "|"
        R.DATA = YFLD1:YDELIM:YFLD2:YDELIM:YFLD3:YDELIM:YFLD4:YDELIM:YFLD5:YDELIM:YFLD6:YDELIM:YFLD7:YDELIM:YFLD8:YDELIM:YFLD9:YDELIM:YFLD10:YDELIM:YFLD11:YDELIM:YFLD12
        R.DATA := YDELIM:YFLD13:YDELIM:YFLD14:YDELIM:YFLD15:YDELIM:YFLD16:YDELIM:YFLD17:YDELIM:YFLD18:YDELIM:YFLD19:YDELIM:YFLD20:YDELIM:YFLD21:YDELIM:YFLD22:YDELIM:YFLD23
        R.DATA := YDELIM:YFLD24:YDELIM:YFLD25:YDELIM:YFLD26:YDELIM:YFLD27:YDELIM:YFLD28:YDELIM:YFLD29:YDELIM:YFLD30:YDELIM:YFLD31:YDELIM:YFLD32:YDELIM:YFLD33:YDELIM:YFLD34
        R.DATA := YDELIM:YFLD35:YDELIM:YFLD36:YDELIM:YFLD37:YDELIM:YFLD38:YDELIM:YFLD39:YDELIM:YFLD40:YDELIM:YFLD41:YDELIM:YFLD42:YDELIM:YFLD43:YDELIM:YFLD44:YDELIM:YFLD45
        R.DATA := YDELIM:YFLD46:YDELIM:YFLD47:YDELIM:YFLD48:YDELIM:YFLD49:YDELIM:YFLD50:YDELIM:YFLD51:YDELIM:YFLD52:YDELIM:YFLD53:YDELIM:YFLD54:YDELIM:YFLD55:YDELIM:YFLD56
        R.DATA := YDELIM:YFLD57:YDELIM:YFLD58

        CALL F.WRITE(FN.DATA,Y.AA.ID,R.DATA)
*--------------------------------------* si es dual entoces escribir otra linea con los campo de monto en cero
        IF YORG EQ '320' THEN
            YCUSTOMERID = ''; YCUSTOMERID = FMT(Y.CUSTOMER.ID,'R%15'):'/':Y.ORG.USD
            Y.CURRENCY = '2'
            YFLD2          = YCUSTOMERID
            GOSUB ZERO.DEFLT
            YFLD49 = Y.NUMCUOMORA
            Y.MONTO = 0
            YFLD47 = Y.MONTO
            YFLD48 = Y.MONTOMORA
            YFLD46 = Y.BALACT
            YFLD52 = Y.SALDO1
            YFLD53 = Y.SALDO2
            YFLD54 = Y.SALDO3
            YFLD55 = Y.SALDO4
            YFLD56 = Y.SALDO5
            YFLD57 = Y.SALDO6
            YFLD58 = Y.SALDO7
            YFLD38 = Y.CURRENCY
            YDELIM  = '' ; R.DATA = ''
            YDELIM = "|"
            R.DATA = YFLD1:YDELIM:YFLD2:YDELIM:YFLD3:YDELIM:YFLD4:YDELIM:YFLD5:YDELIM:YFLD6:YDELIM:YFLD7:YDELIM:YFLD8:YDELIM:YFLD9:YDELIM:YFLD10:YDELIM:YFLD11:YDELIM:YFLD12
            R.DATA := YDELIM:YFLD13:YDELIM:YFLD14:YDELIM:YFLD15:YDELIM:YFLD16:YDELIM:YFLD17:YDELIM:YFLD18:YDELIM:YFLD19:YDELIM:YFLD20:YDELIM:YFLD21:YDELIM:YFLD22:YDELIM:YFLD23
            R.DATA := YDELIM:YFLD24:YDELIM:YFLD25:YDELIM:YFLD26:YDELIM:YFLD27:YDELIM:YFLD28:YDELIM:YFLD29:YDELIM:YFLD30:YDELIM:YFLD31:YDELIM:YFLD32:YDELIM:YFLD33:YDELIM:YFLD34
            R.DATA := YDELIM:YFLD35:YDELIM:YFLD36:YDELIM:YFLD37:YDELIM:YFLD38:YDELIM:YFLD39:YDELIM:YFLD40:YDELIM:YFLD41:YDELIM:YFLD42:YDELIM:YFLD43:YDELIM:YFLD44:YDELIM:YFLD45
            R.DATA := YDELIM:YFLD46:YDELIM:YFLD47:YDELIM:YFLD48:YDELIM:YFLD49:YDELIM:YFLD50:YDELIM:YFLD51:YDELIM:YFLD52:YDELIM:YFLD53:YDELIM:YFLD54:YDELIM:YFLD55:YDELIM:YFLD56
            R.DATA := YDELIM:YFLD57:YDELIM:YFLD58
            Y.AA.ID1 = Y.AA.ID:"#1"
            CALL F.WRITE(FN.DATA,Y.AA.ID1,R.DATA)
        END
*--------------------------------------*
        RETURN
SET.CANCEL.MONTO:
*****************
        IF Y.PAST.MONTH.CLOSED.LOAN EQ 'CURRNT' THEN
            GOSUB ZERO.DEFLT
            RETURN
        END

        IF ((Y.ARR.STAT EQ 'EXPIRED' OR Y.ARR.STAT EQ 'PENDING.CLOSURE' OR Y.ARR.STAT EQ 'CURRENT' ) AND Y.ACC.AMT EQ 0) THEN
            GOSUB ZERO.DEFLT
            RETURN
        END
        IF ((Y.ARR.STAT EQ 'EXPIRED' OR Y.ARR.STAT EQ 'PENDING.CLOSURE' OR Y.ARR.STAT EQ 'CURRENT' ) AND Y.ACC.AMT NE 0) THEN
            Y.ESTADO = 'A'
        END
        IF NOT(Y.ESTADO) THEN
            Y.ESTADO = 'A'
        END
        RETURN
ZERO.DEFLT:
***********
        Y.ESTADO = 'C'
*    Y.MONTO = 0
        Y.NUMCUOMORA = 0
        Y.MNTPAY = 0
        Y.MONTOMORA = 0
        Y.BALACT = 0
        Y.SALDO1 = 0
        Y.SALDO2 = 0
        Y.SALDO3 = 0
        Y.SALDO4 = 0
        Y.SALDO5 = 0
        Y.SALDO6 = 0
        Y.SALDO7 = 0
        RETURN

*-----------------------------------------------------------------------------
GET.CUSTOMER.INFO:
*-----------------------------------------------------------------------------
*---- Customer
        CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.ERR)
        IF Y.ERR NE '' THEN
            RETURN
        END
*---- Customer Local Tables

        Y.TEL.ID=R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TEL.TYPE.POS>
        Y.TEL.AREA=R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TEL.AREA.POS>
        Y.TEL.NUM=R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TEL.NO.POS>
        Y.TEL.EXT=R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TEL.EXT.POS>

        Y.TEL.TOT = COUNT(Y.TEL.ID,@SM) + 1
        Y.VAR = 1
        LOOP
        WHILE Y.VAR LE Y.TEL.TOT
            BEGIN CASE
                CASE Y.TEL.ID<1,1,Y.VAR> EQ '01'
                    Y.TEL.CASA=Y.TEL.AREA<1,1,Y.VAR>:' ':Y.TEL.NUM<1,1,Y.VAR>  ;*R22 AUTO CODE CONVERSION
                CASE Y.TEL.ID<1,1,Y.VAR> EQ '05'
                    Y.TEL.OFI=Y.TEL.AREA<1,1,Y.VAR>:' ':Y.TEL.NUM<1,1,Y.VAR>:' ':Y.TEL.EXT<1,1,Y.VAR> ;*R22 AUTO CODE CONVERSION
                CASE Y.TEL.ID<1,1,Y.VAR> EQ '06'
                    Y.TEL.CEL=Y.TEL.AREA<1,1,Y.VAR>:' ':Y.TEL.NUM<1,1,Y.VAR> ;*R22 AUTO CODE CONVERSION
                CASE 1
                    Y.TEL.OTR=Y.TEL.AREA<1,1,Y.VAR>:' ':Y.TEL.NUM<1,1,Y.VAR>:' ':Y.TEL.EXT<1,1,Y.VAR> ;*R22 AUTO CODE CONVERSION
            END CASE
            Y.VAR += 1 ;*R22 AUTO CODE CONVERSION
        REPEAT

*---- ADDRESS
        Y.DIRECCION = R.CUSTOMER<EB.CUS.ADDRESS>

*---- COUNTRY
        Y.COUNTRY = R.CUSTOMER<EB.CUS.COUNTRY>

* el codigo queda quemado porque en el local table no esta codificado
        Y.ENTIDAD='I'
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS> EQ 'PERSONA JURIDICA' THEN
            Y.ENTIDAD='E'
        END
        RETURN

*-----------------------------------------------------------------------------
GET.AA.STATUS:
* PACS00060197: Esto lo cambie de acuerdo al excel que explica la comibanaciones posibles
*-----------------------------------------------------------------------------
        PROP.CLASS = 'OVERDUE'
        PROPERTY = ''; R.CONDITION.OVERDUE = ''; ERR.MSG = ''; EFF.DATE = ''
*CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG)
        APAP.AA.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG) ;*R22 MANUAL CODE CONVERSION
        Y.LOAN.STATUS = R.CONDITION.OVERDUE<AA.OD.LOCAL.REF,POS.L.LOAN.STATUS.1>
        Y.LOAN.COND   = R.CONDITION.OVERDUE<AA.OD.LOCAL.REF,Y.L.LOAN.COND>

        IF R.AA.ACTIVITY.HISTORY AND (NOT(Y.LOAN.STATUS) AND NOT(Y.LOAN.COND)) THEN
            GOSUB GET.OVERD.VALUE
        END

        BEGIN CASE
            CASE Y.LOAN.STATUS EQ 'JudicialCollection'
                Y.STATUS = 'Cobranza'
            CASE Y.LOAN.STATUS EQ 'Restructured'
                Y.STATUS = 'Restructurado'
                LOCATE 'Legal' IN Y.LOAN.COND<1,1,1> SETTING Y.POS THEN
                    Y.STATUS = 'Legal'
                END
                IF NOT(Y.STATUS) THEN
                    Y.STATUS = R.CONDITION.OVERDUE<AA.OD.LOCAL.REF,Y.L.LOAN.COND,1>
                END
            CASE Y.LOAN.STATUS EQ 'Write-off'
                Y.STATUS = 'Castigado'
            CASE Y.LOAN.STATUS EQ 'Normal'
                Y.STATUS = 'Normal'
                LOCATE 'CASTIGADO' IN Y.LOAN.COND<1,1,1> SETTING Y.POS THEN
                    Y.STATUS = 'Castigado'
                    RETURN
                END
                LOCATE 'Write-off' IN Y.LOAN.COND<1,1,1> SETTING Y.POS THEN
                    Y.STATUS = 'Castigado'
                    RETURN
                END
                LOCATE 'Legal' IN Y.LOAN.COND<1,1,1> SETTING Y.POS THEN
                    Y.STATUS = 'Legal'
                END ELSE
                    LOCATE 'Restructured' IN Y.LOAN.COND<1,1,1> SETTING Y.POS THEN
                        Y.STATUS = 'Restructurado'
                    END
                END
                IF NOT(Y.STATUS) THEN
                    Y.STATUS = R.CONDITION.OVERDUE<AA.OD.LOCAL.REF,Y.L.LOAN.COND,1>
                END
            CASE Y.LOAN.STATUS EQ ''
                Y.STATUS = ''
                LOCATE 'Legal' IN Y.LOAN.COND<1,1,1> SETTING Y.POS THEN
                    Y.STATUS = 'Legal'
                END ELSE
                    LOCATE 'Restructured' IN Y.LOAN.COND<1,1,1> SETTING Y.POS THEN
                        Y.STATUS = 'Restructurado'
                    END
                END
                IF NOT(Y.STATUS) THEN
                    Y.STATUS = R.CONDITION.OVERDUE<AA.OD.LOCAL.REF,Y.L.LOAN.COND,1>
                END
            CASE 1
                Y.STATUS = 'LOAN.STATUS [' : Y.LOAN.STATUS : '] NO DEFINIDO'
        END CASE
        RETURN

GET.OVERD.VALUE:
****************
        YACT.ARR.ID = ''; YAACT.EFF.DATE = ''; ACT.OVER.ID = ''
        YACT.ARR.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY>
        FINDSTR "LENDING-UPDATE-APAP.OVERDUE" IN YACT.ARR.ID<1> SETTING YFM, YVM, YSM THEN
            YAACT.EFF.DATE = R.AA.ACTIVITY.HISTORY<AA.AH.SYSTEM.DATE,YVM,YSM>
        END ELSE
            RETURN
        END

        FN.AA.ARR.OVER = 'F.AA.ARR.OVERDUE'; F.AA.ARR.OVER = ''
        ERR.AA.ARR.OVER = ''; R.AA.ARR.OVER = ''
        CALL OPF(FN.AA.ARR.OVER,F.AA.ARR.OVER)
        ACT.OVER.ID = Y.AA.ID:"-APAP.OVERDUE-":YAACT.EFF.DATE:".1"
        CALL F.READ(FN.AA.ARR.OVER,ACT.OVER.ID,R.AA.ARR.OVER,F.AA.ARR.OVER,ERR.AA.ARR.OVER)
        IF R.AA.ARR.OVER THEN
            Y.LOAN.STATUS = R.AA.ARR.OVER<AA.OD.LOCAL.REF,POS.L.LOAN.STATUS.1>
            Y.LOAN.COND = R.AA.ARR.OVER<AA.OD.LOCAL.REF,Y.L.LOAN.COND>
        END
        RETURN

*-----------------------------------------------------------------------------
ARR.CONDITIONS:
*-----------------------------------------------------------------------------
        ArrangementID = Y.AA.ID ; idProperty = ''; effectiveDate = TODAY; returnIds = ''; R.CONDITION =''; returnConditions = ''; returnError = ''
        CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
        RETURN

GET.ACTUAL.BALANCE:
*-----------------------------------------------------------------------------
        PROP.CLASS = 'OVERDUE'
        PROPERTY   = ''; R.CONDITION.OVERDUE = ''; ERR.MSG = ''; EFF.DATE   = ''
*CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG)
        APAP.AA.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG)  ;*R22 MANUAL CODE CONVERSION
        IF R.CONDITION.OVERDUE NE '' THEN

            Y.BILL.TYPE = R.CONDITION.OVERDUE<AA.OD.BILL.TYPE>
            LOCATE 'PAYMENT' IN Y.BILL.TYPE<1,1> SETTING YPOSN THEN
                Y.OD.STATUS.ARR = R.CONDITION.OVERDUE<AA.OD.OVERDUE.STATUS,YPOSN>
            END
            CHANGE @SM TO @FM IN Y.OD.STATUS.ARR  ;*R22 AUTO CODE CONVERSION
            Y.OVERDUE.STATUS = Y.OD.STATUS.ARR

            ACC.BALANCE.TYPE   = 'CUR':@FM:'DUE':@FM:Y.OVERDUE.STATUS  ;*R22 AUTO CODE CONVERSION
            Y.PRINCIPALINT.TYPE = 'ACC':@FM:'DUE':@FM:Y.OVERDUE.STATUS   ;*R22 AUTO CODE CONVERSION

            Y.ACC.AMT = 0; Y.PRIN.AMT = 0; Y.PRINTC.AMT = 0
            Y.PROPERTY.LIST = 'ACCOUNTTC'
            Y.BALANCE.TYPE  = ACC.BALANCE.TYPE
*CALL REDO.GET.TOTAL.OUTSTANDING.BYPROP(Y.AA.ID,Y.PROPERTY.LIST,Y.BALANCE.TYPE,Y.ACC.AMT)
            APAP.TAM.redoGetTotalOutstandingByprop(Y.AA.ID,Y.PROPERTY.LIST,Y.BALANCE.TYPE,Y.ACC.AMT)  ;*R22 MANUAL CODE CONVERSION
            IF NOT(Y.ACC.AMT) THEN
                Y.ACC.AMT = 0
            END
            Y.PROPERTY.LIST = 'PRINCIPALINTTC'
            Y.BALANCE.TYPE  = Y.PRINCIPALINT.TYPE
*CALL REDO.GET.TOTAL.OUTSTANDING.BYPROP(Y.AA.ID,Y.PROPERTY.LIST,Y.BALANCE.TYPE,Y.PRIN.AMT)
            APAP.TAM.redoGetTotalOutstandingByprop(Y.AA.ID,Y.PROPERTY.LIST,Y.BALANCE.TYPE,Y.PRIN.AMT)  ;*R22 MANUAL CODE CONVERSION

            Y.PROPERTY.LIST = 'PRINCIPALINTTCC'
            Y.BALANCE.TYPE  = Y.PRINCIPALINT.TYPE
*CALL REDO.GET.TOTAL.OUTSTANDING.BYPROP(Y.AA.ID,Y.PROPERTY.LIST,Y.BALANCE.TYPE,Y.PRINTC.AMT)
            APAP.TAM.redoGetTotalOutstandingByprop(Y.AA.ID,Y.PROPERTY.LIST,Y.BALANCE.TYPE,Y.PRINTC.AMT)   ;*R22 MANUAL CODE CONVERSION

            Y.BALACT = Y.ACC.AMT + Y.PRIN.AMT + Y.PRINTC.AMT
        END
        RETURN
    END
