SUBROUTINE REDO.B.BCR.REPORT.GEN(Y.AA.ID)
*-----------------------------------------------------------------------------
* Mutli-threaded Close of Business routine
*
*-----------------------------------------------------------------------------
* Modification History:
* Revision History:
* -----------------
* Date       Name              Reference                     Version
* --------   ----              ----------                    --------
* X          Jijon Santiago    ODR-2010-10-0181              Initial Creation
* 16.06.11   RMONDRAGON        ODR-2010-03-                  Fix for PACS00056300: Change to input the records in REDO.INTERFACE.ACT.DETAILS using as the first part of
*                                                            the ID the Interface Code (INT.CODE as routine parameter) instead of the Interface Name parametrized in REDO.INTERFACE.PARAM
* 18.07.11   Ivan Roman        ODT-2011-03-                  Assign variale K.INT.CODE to BCR001
* 29.08.11   hpasquel          PACS00060197                  Re-factor some code
* 17.04.12   hpasquel          PACS00191153                  C.22 problems, improve COB, OCOMO calls allow to measure process timing.
* 26/02/2016 V.P.ASHOKKUMAR    APAP                          Fixing all the report bugs.
*------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
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
*
    $INSERT I_F.REDO.BCR.REPORT.DATA
    $INSERT I_REDO.B.BCR.REPORT.GEN.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
    $INSERT I_F.REDO.BCR.REPORT.EXEC

    CALL OCOMO(" processing Y.AA.ID [" : Y.AA.ID : "]")
*
*-----------------------------------------------------------------------------

    IF K_PROCESS_FLAG EQ 0 THEN
        RETURN      ;* Process must not be continued never never
    END

    K.ID.PROC = Y.AA.ID

* Initiliaze variables
    GOSUB INITIALISE
    IF Y.ERROR THEN
        RETURN
    END
    Y.MAIN.ARR.PRCT = R.AA<AA.ARR.PRODUCT,1>
    LOCATE Y.MAIN.ARR.PRCT IN Y.PRDG.VAL.ARR<1,1> SETTING C.VALD.POS THEN
        CALL OCOMO("Loan skipped for the product - ":Y.AA.ID:" - ":Y.MAIN.ARR.PRCT)
        RETURN
    END
* Check whether it is a cancelled loan. then check if it is closed previous month.
    GOSUB CHECK.CANCELLED.LOAN
    IF Y.PAST.MONTH.CLOSED.LOAN EQ 'YES' THEN
        CALL OCOMO("Loan skipped for not closed last month - ":Y.AA.ID:" - ":YARR.EFFDTE:"/":Y.LAST.MONTH.ACT)
        RETURN
    END

    PROP.CLASS = 'PAYMENT.SCHEDULE'; PROPERTY = ''; EFF.DATE = ''; R.CONDITION = ''
    ERR.MSG = ''; Y.STATUS.DD = ''; R.AA.PAYMENT.SCHEDULE = ''; Y.PAID.BILLS.CNT = ''; Y.ROLE = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
    R.AA.PAYMENT.SCHEDULE = R.CONDITION
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
    Y.LOAN.RELATION = 'PRINCIPAL'
    Y.CUSTOMER.ID = Y.PRIMARY.OWNER
    GOSUB WRITE.DATA
    GOSUB WRITE.CODEBTOR

    CALL OCOMO("ending [" : Y.AA.ID : "]")
RETURN

*-----------------------------------------------------------------------------
CHECK.CANCELLED.LOAN:
*-----------------------------------------------------------------------------
    Y.PAST.MONTH.CLOSED.LOAN = ''; Y.LINKED.APP.ID = ''; YPOST.REST = ''; YDTE.LST = ''
    YRECORD.STAT = ''; YCLOSE.DATE = ''
    Y.ARR.STAT = R.AA<AA.ARR.ARR.STATUS>
    Y.LINKED.APP.ID = R.AA<AA.ARR.LINKED.APPL.ID,1>
    R.ACCOUNT = ''; Y.ACC.ERR = ''; YOD.STAT = ''; YPOST.REST = ''
    CALL F.READ(FN.ACCOUNT,Y.LINKED.APP.ID,R.ACCOUNT,F.ACCOUNT,Y.ACC.ERR)
    IF NOT(R.ACCOUNT) THEN
        YACC.HID = Y.LINKED.APP.ID
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HST,YACC.HID,R.ACCOUNT,ERR.ACCOUNT)
    END
    IF R.ACCOUNT THEN
        YPOST.REST = R.ACCOUNT<AC.POSTING.RESTRICT>
        YRECORD.STAT = R.ACCOUNT<AC.RECORD.STATUS>
        YDTE.LST = R.ACCOUNT<AC.CLOSURE.DATE>
    END
    IF NOT(YDTE.LST) THEN
        YDTE.LST = R.ACCOUNT<AC.DATE.LAST.UPDATE>
    END
    GOSUB GET.ACTUAL.BALANCE
    Y.MAIN.PROD.GROUP = R.AA<AA.ARR.PRODUCT.GROUP>
    ERR.AA.ACTIVITY.HISTORY = ''; R.AA.ACTIVITY.HISTORY = ''; YACT.IS.STAT = ''; YACT.ID.ARR = ''; YACT.EFF.DATE = ''
    CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.AA.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,ERR.AA.ACTIVITY.HISTORY)
    IF R.AA.ACTIVITY.HISTORY THEN
        YACT.ID.ARR = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY>
        YACT.IS.STAT = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.STATUS>
        YACT.EFF.DATE = R.AA.ACTIVITY.HISTORY<AA.AH.SYSTEM.DATE>
        CHANGE @VM TO @FM IN YACT.ID.ARR
        CHANGE @SM TO @FM IN YACT.ID.ARR
        CHANGE @VM TO @FM IN YACT.IS.STAT
        CHANGE @SM TO @FM IN YACT.IS.STAT
        CHANGE @VM TO @FM IN YACT.EFF.DATE
        CHANGE @SM TO @FM IN YACT.EFF.DATE
    END
    ERR.REDO.APAP.PROPERTY.PARAM = ''; R.REDO.APAP.PROPERTY.PARAM = ''; YPAYOFF.ACT = ''; YPAY.CNT = 0
    CALL F.READ(FN.REDO.APAP.PROPERTY.PARAM,Y.MAIN.PROD.GROUP,R.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM,ERR.REDO.APAP.PROPERTY.PARAM)
    IF R.REDO.APAP.PROPERTY.PARAM THEN
        YPAYOFF.ACT = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PAYOFF.ACTIVITY>
        YPAY.CNT = DCOUNT(YPAYOFF.ACT,@VM)
    END

    YCNT = 1
    LOOP
    WHILE YCNT LE YPAY.CNT
        YPAYOFF.ACT.1 = ''; YARR.EFFDTE = ''; YARR.STAT = ''
        YPAYOFF.ACT.1 = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PAYOFF.ACTIVITY,YCNT>
        LOCATE YPAYOFF.ACT.1 IN YACT.ID.ARR<1> SETTING CHG.POSN.1 THEN
            YARR.STAT = YACT.IS.STAT<CHG.POSN.1>
            YARR.EFFDTE = YACT.EFF.DATE<CHG.POSN.1>
            IF YARR.STAT EQ 'AUTH' AND YARR.EFFDTE LE Y.LAST.MONTH.ACT AND Y.ACC.AMT EQ 0 THEN
                Y.PAST.MONTH.CLOSED.LOAN = 'YES'
                YCNT = YPAY.CNT + 1
                CONTINUE
            END
            IF YARR.STAT EQ 'AUTH' AND YARR.EFFDTE GT Y.LAST.MONTH.ACT AND Y.ACC.AMT NE 0 THEN
                Y.PAST.MONTH.CLOSED.LOAN = 'CURRNT'
                YCNT = YPAY.CNT + 1
                CONTINUE
            END
            IF YARR.STAT EQ 'AUTH' AND YARR.EFFDTE GT Y.LAST.MONTH.ACT THEN
                Y.PAST.MONTH.CLOSED.LOAN = 'CURRNT'
                YCNT = YPAY.CNT + 1
                CONTINUE
            END
        END
        YCNT += 1
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
WRITE.CODEBTOR:
*-----------------------------------------------------------------------------
* Get and Write Codebtor info
    IF NOT(Y.ERROR) AND Y.OTHR.PARTY NE '' THEN
    END ELSE
        RETURN
    END
    Y.SEC.OWN.CNT = DCOUNT(Y.OTHR.PARTY,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.SEC.OWN.CNT
        YAA.ROLE = ''; Y.CUSTOMER.ID = ''
        Y.DATA.ID=UNIQUEKEY ()
        Y.LOAN.RELATION = 'CODEUDOR'
        Y.CUSTOMER.ID = Y.OTHR.PARTY<1,Y.VAR1>
        YAA.ROLE = Y.ROLE<1,Y.VAR1>
        IF YAA.ROLE EQ 'CO-SIGNER' THEN
            GOSUB WRITE.DATA
        END
        Y.VAR1 += 1
    REPEAT
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.ERROR  = @FALSE
    R.AA = ''; Y.ERR = ''; R.REDO.LOG = ''
    CALL F.READ(FN.AA,Y.AA.ID,R.AA,F.AA,Y.ERR)
    Y.ORG.ARRANGEMENT=R.AA<AA.ARR.ORIG.CONTRACT.DATE>
    IF Y.ERR NE '' THEN
        K.MON.TP  = '08'
        K.DESC    = 'REGISTRO ' : Y.AA.ID: ' NO ENCONTRADO EN ':FN.AA
        GOSUB THROW.ERROR     ;*CALL REDO.INTERFACE.REC.ACT(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC)
        RETURN
    END
    LOC.REF.FIELDS = ""; C.VALD.POS = ''
    Y.TEL.OTR=''; Y.TEL.OFI=''
    Y.CUSTOMER.ID=R.AA<AA.ARR.CUSTOMER>
    Y.DATA.ID=UNIQUEKEY ()
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

    R.AA.CUSTOMER = RAISE(returnConditions)
    Y.PRIMARY.OWNER=R.AA.CUSTOMER<AA.CUS.PRIMARY.OWNER>
*Y.OWNER = R.AA.CUSTOMER<AA.CUS.OWNER,2>
    Y.OWNER = R.AA.CUSTOMER<AA.CUS.OTHER.PARTY>
    Y.OTHR.PARTY=R.AA.CUSTOMER<AA.CUS.OTHER.PARTY>
    Y.ROLE = R.AA.CUSTOMER<AA.CUS.ROLE>
    CALL OCOMO("customer info done")

    Y.PRODUCT= R.AA<AA.ARR.PRODUCT.GROUP>
*---- AA details
    CALL F.READ(FN.AA.DETAILS,Y.AA.ID,R.AA.DETAILS,F.AA.DETAILS,Y.ERR)
    IF Y.ERR NE '' THEN
        K.MON.TP='08'
        K.DESC='REGISTRO ' : Y.AA.ID : ' NO ENCONTRADO EN: ' : FN.AA.DETAILS
        GOSUB THROW.ERROR     ;*CALL REDO.INTERFACE.REC.ACT(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC)
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

    IF  Y.MONTO EQ '' THEN
        Y.MONTO=0
    END

    CALL OCOMO("AA terms info done")
*---- AA num cuotas
    Y.AD.BILL.LIST  = CHANGE(R.AA.DETAILS<AA.AD.BILL.ID>, @SM, @VM)
    Y.TOTAL.DB = DCOUNT(Y.AD.BILL.LIST, @VM)
    Y.FCORTE = ''
    LOOP
    WHILE NOT(Y.FCORTE) AND Y.TOTAL.DB GT 0
        Y.AA.BILL = Y.AD.BILL.LIST<1,Y.TOTAL.DB>
        CALL F.READ(FN.AA.BILL,Y.AA.BILL,R.AA.BILL,F.AA.BILL,Y.ERR)
        LOCATE 'DUE' IN R.AA.BILL<AA.BD.BILL.STATUS,1> SETTING Y.POS THEN
            Y.FCORTE = R.AA.BILL<AA.BD.BILL.ST.CHG.DT, Y.POS>
        END
        Y.TOTAL.DB -= 1
    REPEAT
    CALL OCOMO("getting F.CORTE [" : Y.FCORTE : "]")

* Get AccountId associated with the current AA.ID
    Y.ACCOUNT.ID = ''
    LOCATE "ACCOUNT" IN R.AA<AA.ARR.LINKED.APPL, 1> SETTING Y.POS.ACCT THEN
        Y.ACCOUNT.ID = R.AA<AA.ARR.LINKED.APPL.ID, Y.POS.ACCT>
    END ELSE
        K.MON.TP = '08'
        K.DESC   = 'AA.ID ' : Y.AA.ID : ' NO TIENE UN ACCOUNT ID CORRESPONDIENTE, CAMPO ENCONTRADO LINKED.APPL.ID ESTA VACIO '
        GOSUB THROW.ERROR     ;*CALL REDO.INTERFACE.REC.ACT(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC)
        RETURN
    END

* Get AA Balances on ranges
*GOSUB GET.SALDOS

* Si OS.TOTAL.AMOUNT > 0 & al menos un BILL.STATUS NE 'SETTLED' significa que se adeuda el valor
* If OS.TOTAL.AMOUNT > 0 & at least on mv BILL.STATUS NE 'SETTLED', means the bill is not totaly paid yet
    GOSUB GET.BALANCES        ;* Balances by segment.

    CALL OCOMO("Balances done [" : Y.SALDO1 : "] [" : Y.SALDO2 : "] [" :Y.SALDO3 : "] [" :Y.SALDO4 : "] [" :Y.SALDO5: "] [" :Y.SALDO6 : "] [" :Y.SALDO7 : "]" )
*---- Rutinas - monto de la cuota
    Y.AD.BILL.LIST  = CHANGE(R.AA.DETAILS<AA.AD.BILL.ID>, @SM, @VM)     ;* Based on the logic of REDO.S.FC.AA.MNTPAY
    Y.TOTAL.DB = DCOUNT(Y.AD.BILL.LIST, @VM)
    BILL.REFERENCE = R.AA.DETAILS<AA.AD.BILL.ID,Y.TOTAL.DB>
*CALL AA.GET.BILL.DETAILS(Y.AA.ID, BILL.REFERENCE, BILL.DETAILS, RET.ERROR)
*Y.MNTPAY =  BILL.DETAILS<AA.BD.OR.TOTAL.AMOUNT>         ;* 35

*---- Rutinas - fecha ultimo pago
*    PACS00191153
    Y.TOTAL.CUOTAS = Y.PAID.BILLS.CNT
    CALL REDO.B.BCR.REPORT.GEN.EXT(Y.AA.ID,Y.TOTAL.CUOTAS,Y.LASTPAY.AMT, Y.LASTPAY.DAT, Y.MNTPAY)

    IF (Y.LASTPAY.DAT AND Y.LASTPAY.DAT LE Y.LAST.MONTH.ACT) AND Y.ACC.AMT EQ 0 THEN
        CALL OCOMO("Loan skipped for not closed last month - ":Y.AA.ID:" - ":Y.LASTPAY.DAT:"/":Y.LAST.MONTH.ACT)
        Y.ERROR = 1
        RETURN
    END
*
*---- Rutinas - balance actual
*    GOSUB GET.ACTUAL.BALANCE
*CALL REDO.S.FC.AA.BAL(Y.AA.ID,Y.BALACT)
*CALL REDO.GET.TOTAL.OUTSTANDING.SIN.UNC.UND(Y.AA.ID,Y.PROP.AMT,Y.BALACT)
    IF Y.BALACT ELSE
        Y.BALACT = ''
    END

*---- Rutinas - monto en mora
*CALL REDO.S.FC.AA.BILL.DUE.AMT(Y.AA.ID, Y.MONTOMORA) ;* Changed.
*CALL REDO.GET.TOTAL.OUTSTANDING.SIN.UNC.UND(Y.AA.ID,Y.PROP.AMT,Y.MONTOMORA) ;* Changed.


*---- Rutinas - cantidad de cuotas en mora
*CALL REDO.S.FC.AA.BL.AIGING(Y.AA.ID, Y.NUMCUOMORA) ;* Changed

*---- Rutinas - Estatus de la cuenta
*CALL REDO.S.FC.AA.LOAN.STATUS(Y.AA.ID, Y.LOAN.STATUS)
*CALL REDO.S.FC.AA.LOAN.COND(Y.AA.ID, Y.STATUS2)
    GOSUB GET.AA.STATUS

    CALL OCOMO("Other info get ends")
RETURN
*-----------------------------------------------------------------------------
GET.BALANCES:
*-----------------------------------------------------------------------------
    Y.UNPAID.BILL.CNT = 0
    Y.UNPAID.BILL.AMT = 0
    LOOP
        REMOVE Y.AA.BILL3 FROM Y.AD.BILL.LIST SETTING POS
    WHILE Y.AA.BILL3:POS
        Y.ERR = ''; R.AA.BILL3 = ''
        CALL F.READ(FN.AA.BILL,Y.AA.BILL3,R.AA.BILL3,F.AA.BILL,Y.ERR)
        IF R.AA.BILL3<AA.BD.BILL.STATUS> NE 'SETTLED' AND SUM(R.AA.BILL3<AA.BD.OS.PROP.AMOUNT>) GT 0 THEN
            NO.OF.DAYS  = 'C'
            Y.PREV.DATE = R.AA.BILL3<AA.BD.PAYMENT.DATE>
            Y.NEXT.DATE = TODAY
            CALL CDD('',Y.PREV.DATE,Y.NEXT.DATE,NO.OF.DAYS)
            IF NO.OF.DAYS GT 30 THEN
                Y.UNPAID.BILL.CNT += 1
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
    REPEAT
    Y.MONTOMORA  = Y.UNPAID.BILL.AMT
    Y.NUMCUOMORA = Y.UNPAID.BILL.CNT
RETURN

*-----------------------------------------------------------------------------
WRITE.DATA:         * PACS00060197: Write a record for each loan debtor
*-----------------------------------------------------------------------------

    GOSUB GET.CUSTOMER.INFO

    IF Y.ERROR THEN
        RETURN
    END
    R.DATA = ''
    R.DATA<BCR.EMP.ENTIDAD>            = Y.ENTIDAD
    R.DATA<BCR.EMP.RNC>                = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.RNC.POS>
    R.DATA<BCR.EMP.SIGLAS>             = ''
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS> EQ 'PERSONA JURIDICA' THEN
        R.DATA<BCR.EMP.RAZONSOCIAL>    = R.CUSTOMER<EB.CUS.NAME.1>:' ':R.CUSTOMER<EB.CUS.NAME.2>
    END
    R.DATA<BCR.RESERVED.EMP1>          = ''
    R.DATA<BCR.RESERVED.EMP2>          = ''
    R.DATA<BCR.RESERVED.EMP3>          = ''
    R.DATA<BCR.RESERVED.EMP4>          = ''
    R.DATA<BCR.CUS.ID>                 = Y.CUSTOMER.ID
    R.DATA<BCR.CUS.RELACION>           = Y.LOAN.RELATION
    R.DATA<BCR.CUS.NOMBRE>             = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
    R.DATA<BCR.CUS.GENERO>             = R.CUSTOMER<EB.CUS.GENDER>
    R.DATA<BCR.CUS.CEDULAOLD>          = ''       ;* NO APLICA
    R.DATA<BCR.CUS.CEDULANEW>          = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.CIDENT.POS>
    R.DATA<BCR.CUS.RNC>                = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.RNC.POS>      ;*PENDIENTE X Q ESTOY TOMANDO RNC DE LA EMPRESA
    R.DATA<BCR.CUS.PASAPORTE>          = R.CUSTOMER<EB.CUS.LEGAL.ID>
    R.DATA<BCR.CUS.NACIONALIDAD>       = R.CUSTOMER<EB.CUS.NATIONALITY>
    R.DATA<BCR.CUS.LICENCIA>           = ''       ;* PENDIENTE
    R.DATA<BCR.CUS.FNAC>               = ''       ;* PENDIENTE
    R.DATA<BCR.CUS.CIUDADNAC>          = ''       ;* PENDIENTE
    R.DATA<BCR.CUS.PAISNAC>            = ''       ;* PENDIENTE
    R.DATA<BCR.CUS.ESTCIVIL>           = ''       ;* PENDIENTE
    R.DATA<BCR.CUS.NUMDEP>             = ''       ;* PENDIENTE
    R.DATA<BCR.CUS.CONYUGE>            = ''       ;* PENDIENTE
    R.DATA<BCR.CUS.CONYUGEID>          = ''       ;* PENDIENTE
    R.DATA<BCR.CUS.TELF.CASA>          = Y.TEL.CASA
    R.DATA<BCR.CUS.TELF.TRABAJO>       = Y.TEL.OFI
    R.DATA<BCR.CUS.TELF.CELULAR>       = Y.TEL.CEL
    R.DATA<BCR.CUS.BEEPER>             = ''       ;* NO APLICA
    R.DATA<BCR.CUS.FAX>                = ''       ;* NO APLICA
    R.DATA<BCR.CUS.TELF.OTRO>          = Y.TEL.OTR
    R.DATA<BCR.CUS.DIR.CALLE1>         = R.CUSTOMER<EB.CUS.STREET>
    R.DATA<BCR.CUS.DIR.ESQUI1>         = ''       ;* NO APLICA
    R.DATA<BCR.CUS.DIR.NUMERO1>        = Y.DIRECCION<1,1>
    R.DATA<BCR.CUS.DIR.EDIFI1>         = ''       ;* NO APLICA
    R.DATA<BCR.CUS.DIR.PISO1>          = Y.DIRECCION<1,1>
    R.DATA<BCR.CUS.DIR.DPTO1>          = Y.DIRECCION<1,1>
    R.DATA<BCR.CUS.DIR.URB1>           = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.URB.ENS.RE.POS>
    R.DATA<BCR.CUS.DIR.SECTOR1>        = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.RES.SECTOR.POS>
    R.DATA<BCR.CUS.DIR.CIUDAD1>        = Y.COUNTRY
    R.DATA<BCR.CUS.DIR.PROVIN1>        = R.CUSTOMER<EB.CUS.TOWN.COUNTRY>
    R.DATA<BCR.CUS.DIR.CALLE2>         = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.CUS.DIR.ESQUI2>         = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.CUS.DIR.NUMERO2>        = Y.DIRECCION<1,2>
    R.DATA<BCR.CUS.DIR.EDIFI2>         = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.CUS.DIR.PISO2>          = Y.DIRECCION<1,2>
    R.DATA<BCR.CUS.DIR.DPTO2>          = Y.DIRECCION<1,2>
    R.DATA<BCR.CUS.DIR.URB2>           = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.CUS.DIR.SECTOR2>        = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.CUS.DIR.CIUDAD2>        = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.CUS.DIR.PROVIN2>        = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.RESERVED.CUS1>          = ''
    R.DATA<BCR.RESERVED.CUS2>          = ''
    R.DATA<BCR.RESERVED.CUS3>          = ''
    R.DATA<BCR.RESERVED.CUS4>          = ''
*R.DATA<BCR.LOAN.ID>=Y.AA.ID
    R.DATA<BCR.LOAN.ID>                = R.AA<AA.ARR.LINKED.APPL.ID,1>          ;* Changed from arrangement id to loan acc no.
    R.DATA<BCR.LOAN.CCY>               = Y.CURRENCY
    R.DATA<BCR.LOAN.TIPO>              = Y.PRODUCT
    R.DATA<BCR.LOAN.FPAGO>             = Y.FORM.PAYMENT     ;* PACS00356448
    R.DATA<BCR.LOAN.CTA.NUM>           = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.LOAN.CTA.RELACION>      = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.LOAN.CTA.DESCRIP>       = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.LOAN.CTA.STATUS>        = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.LOAN.COMENTESPEC>       = ''       ;* NO EN TRANSUNION
    IF R.AA<AA.ARR.ORIG.CONTRACT.DATE> THEN
        R.DATA<BCR.LOAN.FAPERTURA>     = R.AA<AA.ARR.ORIG.CONTRACT.DATE>
    END ELSE
        R.DATA<BCR.LOAN.FAPERTURA>     = R.AA<AA.ARR.START.DATE>
    END
    GOSUB SET.CANCEL.MONTO
    R.DATA<BCR.LOAN.FVENCIMIENTO>      = R.AA.DETAILS<AA.AD.MATURITY.DATE>
    R.DATA<BCR.LOAN.MONTO>             = FIELD(Y.MONTO,'.',1)         ;* No decimals required.
    R.DATA<BCR.LOAN.LIMITE>            = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.LOAN.TOPCREDITO>        = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.LOAN.NUMCUOTAS>         = Y.TOTAL.CUOTAS     ;* PACS00191153
    R.DATA<BCR.LOAN.MONTOCUOTA>        = FIELD(Y.MNTPAY,'.',1)        ;* No decimals required.
    R.DATA<BCR.LOAN.FCORTE>            = Y.FCORTE
    R.DATA<BCR.LOAN.ULTACT>            = Y.LASTPAY.DAT      ;* PACS00191153
    R.DATA<BCR.LOAN.MONTULTPAGO>       = FIELD(Y.LASTPAY.AMT,'.',1)   ;* PACS00191153. No decimals required.
    R.DATA<BCR.LOAN.BALANACT>          = FIELD(Y.BALACT,'.',1)        ;* No decimals required.
    R.DATA<BCR.LOAN.MONTOATRASO>       = FIELD(Y.MONTOMORA,'.',1)     ;* No decimals required.
    R.DATA<BCR.LOAN.CUOATRASADAS>      = Y.NUMCUOMORA
    R.DATA<BCR.LOAN.CLASIFICACTA>      = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.LOAN.COMENTSUBSCRI>     = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.LOAN.ESTATUSCTA>        = Y.STATUS
    R.DATA<BCR.LOAN.ESTADOCTA>         = Y.ESTADO
    R.DATA<BCR.LOAN.SALDO1>            = FIELD(Y.SALDO1,'.',1)        ;* No decimals required.
    R.DATA<BCR.LOAN.SALDO2>            = FIELD(Y.SALDO2,'.',1)        ;* No decimals required.
    R.DATA<BCR.LOAN.SALDO3>            = FIELD(Y.SALDO3,'.',1)        ;* No decimals required.
    R.DATA<BCR.LOAN.SALDO4>            = FIELD(Y.SALDO4,'.',1)        ;* No decimals required.
    R.DATA<BCR.LOAN.SALDO5>            = FIELD(Y.SALDO5,'.',1)        ;* No decimals required.
    R.DATA<BCR.LOAN.SALDO6>            = FIELD(Y.SALDO6,'.',1)        ;* No decimals required.
    R.DATA<BCR.LOAN.SALDO7>            = FIELD(Y.SALDO7,'.',1)        ;* No decimals required.
    R.DATA<BCR.RESERVED.LOAN1>         = 0
    R.DATA<BCR.RESERVED.LOAN2>         = 0
    R.DATA<BCR.RESERVED.LOAN3>         = 0
    R.DATA<BCR.RESERVED.LOAN4>         = 0
    R.DATA<BCR.CO.CODE>                = ID.COMPANY

    CALL F.WRITE(FN.DATA,Y.DATA.ID,R.DATA)
RETURN

SET.CANCEL.MONTO:
*****************
    IF Y.PAST.MONTH.CLOSED.LOAN EQ 'CURRNT' THEN
        GOSUB ZERO.DEFLT
    END

    IF ((Y.ARR.STAT EQ 'EXPIRED' OR Y.ARR.STAT EQ 'MATURED' OR Y.ARR.STAT EQ 'CURRENT' ) AND Y.ACC.AMT EQ 0) THEN
        GOSUB ZERO.DEFLT
    END
    IF ((Y.ARR.STAT EQ 'EXPIRED' OR Y.ARR.STAT EQ 'MATURED' OR Y.ARR.STAT EQ 'CURRENT' ) AND Y.ACC.AMT NE 0) THEN
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
GET.SALDOS:
*-----------------------------------------------------------------------------

    ACCT.BAL.TYPE = Y.ACCOUNT.ID :'.ACCPENALTYINT'
    CALL GET.ACTIVITY.DATES(ACCT.BAL.TYPE, ACCT.ACTIVITY.DATES)
*
    LOOP
        REMOVE Y.AA.ACCT.ID FROM ACCT.ACTIVITY.DATES SETTING Y.POS
    WHILE Y.POS : Y.AA.ACCT.ID
        Y.AA.ACCT.ID = Y.ACCOUNT.ID :'.ACCPENALTYINT-' : Y.AA.ACCT.ID
        R.AA.ACTIVITY = ''
        CALL F.READ(FN.AA.ACTIVITY,Y.AA.ACCT.ID, R.AA.ACTIVITY ,F.AA.ACTIVITY,Y.ERR)
        Y.MONTH = Y.AA.ACCT.ID["-", 2, 2]
        Y.MONTH = CHANGE(Y.MONTH,"-","")
        GOSUB CALC.SALDO
    REPEAT
RETURN

*-----------------------------------------------------------------------------
CALC.SALDO:
*-----------------------------------------------------------------------------
    Y.TOTAL.DN = DCOUNT(R.AA.ACTIVITY<IC.ACT.DAY.NO>,@VM)
    Y.VALDEB   = R.AA.ACTIVITY<IC.ACT.TURNOVER.DEBIT>
    Y.VALCRED  = R.AA.ACTIVITY<IC.ACT.TURNOVER.CREDIT>

    Y.I = 1
    LOOP
    WHILE Y.I LE Y.TOTAL.DN
        Y.DATE.TO.TEST = Y.MONTH : R.AA.ACTIVITY<IC.ACT.DAY.NO, Y.I>
        NO.OF.DAYS  = 'C'
        Y.NEXT.DATE = TODAY
        CALL CDD('',Y.DATE.TO.TEST,Y.NEXT.DATE,NO.OF.DAYS)
        BEGIN CASE
            CASE (NO.OF.DAYS GE 1) AND (NO.OF.DAYS LE 30)
                Y.SALDO1=Y.SALDO1 + ABS(Y.VALDEB<1,Y.I> + Y.VALCRED<1,Y.I>)
            CASE (NO.OF.DAYS GE 31) AND (NO.OF.DAYS LE 60)
                Y.SALDO2=Y.SALDO2 + ABS(Y.VALDEB<1,Y.I> + Y.VALCRED<1,Y.I>)
            CASE (NO.OF.DAYS GE 61) AND (NO.OF.DAYS LE 90)
                Y.SALDO3=Y.SALDO3 + ABS(Y.VALDEB<1,Y.I> + Y.VALCRED<1,Y.I>)
            CASE (NO.OF.DAYS GE 91) AND (NO.OF.DAYS LE 120)
                Y.SALDO4=Y.SALDO4 + ABS(Y.VALDEB<1,Y.I> + Y.VALCRED<1,Y.I>)
            CASE (NO.OF.DAYS GE 121) AND (NO.OF.DAYS LE 150)
                Y.SALDO5=Y.SALDO5 + ABS(Y.VALDEB<1,Y.I> + Y.VALCRED<1,Y.I>)
            CASE (NO.OF.DAYS GE 151) AND (NO.OF.DAYS LE 180)
                Y.SALDO6=Y.SALDO6 + ABS(Y.VALDEB<1,Y.I> + Y.VALCRED<1,Y.I>)
            CASE (NO.OF.DAYS GE 181)
                Y.SALDO7=Y.SALDO7 + ABS(Y.VALDEB<1,Y.I> + Y.VALCRED<1,Y.I>)
        END CASE
        Y.I += 1
    REPEAT
RETURN
*-----------------------------------------------------------------------------
GET.CUSTOMER.INFO:
*-----------------------------------------------------------------------------
*---- Customer
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.ERR)
    IF Y.ERR NE '' THEN
        K.MON.TP='08'
        K.DESC='REGISTRO ' : Y.CUSTOMER.ID : ' NO ENCONTRADO EN: ':FN.CUSTOMER
        GOSUB THROW.ERROR     ;*CALL REDO.INTERFACE.REC.ACT(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC)
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
                Y.TEL.CASA=Y.TEL.AREA<1,1,Y.VAR>:' ':Y.TEL.NUM<1,1,Y.VAR>
            CASE Y.TEL.ID<1,1,Y.VAR> EQ '05'
                Y.TEL.OFI=Y.TEL.AREA<1,1,Y.VAR>:' ':Y.TEL.NUM<1,1,Y.VAR>:' ':Y.TEL.EXT<1,1,Y.VAR>
            CASE Y.TEL.ID<1,1,Y.VAR> EQ '06'
                Y.TEL.CEL=Y.TEL.AREA<1,1,Y.VAR>:' ':Y.TEL.NUM<1,1,Y.VAR>
            CASE 1
                Y.TEL.OTR=Y.TEL.AREA<1,1,Y.VAR>:' ':Y.TEL.NUM<1,1,Y.VAR>:' ':Y.TEL.EXT<1,1,Y.VAR>
        END CASE
        Y.VAR += 1
    REPEAT

*---- ADDRESS
    Y.DIRECCION = R.CUSTOMER<EB.CUS.ADDRESS>

*---- COUNTRY
    Y.COUNTRY = R.CUSTOMER<EB.CUS.COUNTRY>
*Y.ERR = ''  ;* Changes made for PACS00356448
*Y.COUNTRY = ''
*IF Y.COUNTRY.ID NE '' THEN
*R.COUNTRY = ''
*CALL F.READ(FN.COUNTRY,Y.COUNTRY.ID,R.COUNTRY,F.COUNTRY,Y.ERR)
*Y.COUNTRY=R.COUNTRY<EB.COU.COUNTRY.NAME,LNGG>
*END

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
    EFF.DATE     = ''
    PROP.CLASS   = 'OVERDUE'
    PROPERTY     = ''
    R.CONDITION.OVERDUE  = ''
    ERR.MSG      = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG)
    Y.LOAN.STATUS = R.CONDITION.OVERDUE<AA.OD.LOCAL.REF,POS.L.LOAN.STATUS.1>
    Y.LOAN.COND   = R.CONDITION.OVERDUE<AA.OD.LOCAL.REF,Y.L.LOAN.COND>

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

*-----------------------------------------------------------------------------
THROW.ERROR:
*-----------------------------------------------------------------------------
* << PACS00060197: One call to C.22 interface
* PACS00191153
    R.REDO.LOG<1>  = K.INT.CODE  ; R.REDO.LOG<2>  = ''      ; R.REDO.LOG<3>  = ''         ;* INT.CODE,BAT.NO,BAT.TOT
    R.REDO.LOG<4>  = ''          ; R.REDO.LOG<5>  = ''      ; R.REDO.LOG<6>  = Y.AA.ID    ;* INFO.OR ,ID.PROC,INFO.DE
    R.REDO.LOG<7>  = K.MON.TP    ; R.REDO.LOG<8>  = K.DESC  ; R.REDO.LOG<9>  = ''         ;* MON.TP,DESC,REC.CON
    R.REDO.LOG<10> = OPERATOR    ; R.REDO.LOG<11> = C$T24.SESSION.NO     ;* EX.USER,EX.PC
    R.REDO.LOG<12> = K.INT.TYPE
    CALL REDO.R.BCR.LOG(R.REDO.LOG)
    Y.ERROR = @TRUE
* get out and take Next Id
    VAR.TEXT = K.DESC
    CALL OCOMO(VAR.TEXT)
    SOURCE.INFO = "REDO.B.BCR.REPORT.GEN"
    SOURCE.INFO<7> = "YES"
    CALL FATAL.ERROR(SOURCE.INFO)
RETURN
* >>
*-----------------------------------------------------------------------------
ARR.CONDITIONS:
*-----------------------------------------------------------------------------
    ArrangementID = Y.AA.ID ; idProperty = ''; effectiveDate = TODAY; returnIds = ''; R.CONDITION =''; returnConditions = ''; returnError = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
RETURN
*-----------------------------------------------------------------------------
GET.ACTUAL.BALANCE:
*-----------------------------------------------------------------------------

    EFF.DATE   = ''
    PROP.CLASS = 'OVERDUE'
    PROPERTY   = ''
    R.CONDITION.OVERDUE = ''
    ERR.MSG    = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG)
    Y.OVERDUE.STATUS   = R.CONDITION.OVERDUE<AA.OD.OVERDUE.STATUS>
    CHANGE @VM TO @FM IN Y.OVERDUE.STATUS

    Y.ACCOUNT.PROPERTY = ''
    CALL REDO.GET.PROPERTY.NAME(Y.AA.ID,'ACCOUNT',R.OUT.AA.RECORD,Y.ACCOUNT.PROPERTY,OUT.ERR)
    ACC.BALANCE.TYPE   = 'CUR':@FM:'DUE':@FM:Y.OVERDUE.STATUS

    PROP.NAME          = 'PRINCIPAL'
    CALL REDO.GET.INTEREST.PROPERTY(Y.AA.ID,PROP.NAME,PRINCIPAL.PROP,ERR)
    Y.PRINCIPALINT.TYPE = 'ACC':@FM:'DUE':@FM:Y.OVERDUE.STATUS

    PROP.NAME           = 'PENALTY'
    CALL REDO.GET.INTEREST.PROPERTY(Y.AA.ID,PROP.NAME,PENALTY.PROP,ERR)
    Y.PENALTYINT.TYPE   = 'ACC'

    Y.ACC.AMT = 0; Y.PRIN.AMT = 0; Y.PEN.AMT = 0
    Y.PROPERTY.LIST = Y.ACCOUNT.PROPERTY
    Y.BALANCE.TYPE  = ACC.BALANCE.TYPE
    CALL REDO.GET.TOTAL.OUTSTANDING.BYPROP(Y.AA.ID,Y.PROPERTY.LIST,Y.BALANCE.TYPE,Y.ACC.AMT)
    IF NOT(Y.ACC.AMT) THEN
        Y.ACC.AMT = 0
    END
    Y.PROPERTY.LIST = PRINCIPAL.PROP
    Y.BALANCE.TYPE  = Y.PRINCIPALINT.TYPE
    CALL REDO.GET.TOTAL.OUTSTANDING.BYPROP(Y.AA.ID,Y.PROPERTY.LIST,Y.BALANCE.TYPE,Y.PRIN.AMT)


    Y.PROPERTY.LIST = PENALTY.PROP
    Y.BALANCE.TYPE  = Y.PENALTYINT.TYPE
    CALL REDO.GET.TOTAL.OUTSTANDING.BYPROP(Y.AA.ID,Y.PROPERTY.LIST,Y.BALANCE.TYPE,Y.PEN.AMT)

    Y.BALACT = Y.ACC.AMT + Y.PRIN.AMT + Y.PEN.AMT

    PROPERTY.CLASS = 'PAYMENT.SCHEDULE'
    PROPERTY  = ''
    EFF.DATE  = ''
    ERR.MSG   = ''
    R.PAY.SCH = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.PAY.SCH,ERR.MSG)
    FINDSTR PRINCIPAL.PROP IN R.PAY.SCH<AA.PS.PROPERTY> SETTING POS.AF,POS.AV,POS.AS THEN
        Y.PAY.FREQ = FIELD(R.PAY.SCH<AA.PS.PAYMENT.FREQ,POS.AV>," ",1,3):" e0D e0F"
        Y.FORM.PAYMENT = ''
        IN.DATE = ''
        CALL EB.BUILD.RECURRENCE.MASK(Y.PAY.FREQ, IN.DATE, Y.FORM.PAYMENT)
    END ELSE
        Y.FORM.PAYMENT = ''
        RETURN
    END
RETURN
END
