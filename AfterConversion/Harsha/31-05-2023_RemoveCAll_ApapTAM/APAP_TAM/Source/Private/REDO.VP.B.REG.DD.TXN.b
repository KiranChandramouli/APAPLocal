* @ValidationCode : MjotODQxMDY2MjMyOkNwMTI1MjoxNjg0ODQyMTUyNzk0OklUU1M6LTE6LTE6NDg2OjE6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 486
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VP.B.REG.DD.TXN
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 04.30.2013
* Description  : Routine for registering Direct Debit transactions
* Type         : Batch Routine
* Attached to  : BATCH > REDO.VP.DD.SERVICE
* Dependencies : NA
* Dependencies : NA
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.30.2013     lpazmino       -                 Initial Version
** 19-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 19-04-2023 Skanda R22 Manual Conversion - No changes, CALL routine format modified
*-----------------------------------------------------------------------------

* <region name="INSERTS">

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT

    $INSERT I_F.REDO.VISION.PLUS.PARAM
    $INSERT I_F.REDO.VISION.PLUS.DD

    $INSERT I_RAPID.APP.DEV.COMMON
    $INSERT I_RAPID.APP.DEV.EQUATE
    $USING APAP.REDOSRTN
    
    DEFFUN REDO.S.GET.USR.ERR.MSG()

* </region>
    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************
    FN.REDO.VISION.PLUS.DD = 'F.REDO.VISION.PLUS.DD'
    F.REDO.VISION.PLUS.DD = ''
    R.REDO.VISION.PLUS.DD = ''

    FN.REDO.VISION.PLUS.PARAM = 'F.REDO.VISION.PLUS.PARAM'
    F.REDO.VISION.PLUS.PARAM = ''
    R.REDO.VISION.PLUS.PARAM = ''
    REDO.VISION.PLUS.PARAM.ID = 'SYSTEM'

    FN.ACCOUNT = 'FBNK.ACCOUNT'
    F.ACCOUNT = ''
    R.ACCOUNT = ''

    Y.ERR = ''

    DD.LIST = ''
    DD.LIST.NAME = ''
    DD.SELECTED = ''
    DD.RETURN.CODE = ''

    VP.CUST.LIST = ''
    VP.CUST.LIST.NAME = ''
    VP.CUST.SELECTED = ''
    VP.RETURN.CODE = ''

    TXN.PAYMENT.AMT = ''
    ACCT.APPLICATION = 'ACCOUNT'
    FT.APPLICATION = 'FUNDS.TRANSFER': @FM : ACCT.APPLICATION

    Y.LOCAL.FIELDS = ''
    Y.LOCAL.FIELDS.POS = ''
*FT FIELDS
    Y.LOCAL.FIELDS<1,1> = 'L.FT.CR.CARD.NO'
    Y.LOCAL.FIELDS<1,2> = 'L.SUN.SEQ.NO'
    Y.LOCAL.FIELDS<1,3> = 'L.FT.CR.ACCT.NO'
*ACCOUNT FIELDS
    Y.LOCAL.FIELDS<2,1> = 'L.AC.STATUS1'
    Y.LOCAL.FIELDS<2,2> = 'L.AC.STATUS2'
    Y.LOCAL.FIELDS<2,3> = 'L.AC.NOTIFY.1'
    Y.LOCAL.FIELDS<2,4> = 'L.AC.AV.BAL'


    CALL MULTI.GET.LOC.REF(FT.APPLICATION, Y.LOCAL.FIELDS, Y.LOCAL.FIELDS.POS)

    CR.CARD.NO.POS = Y.LOCAL.FIELDS.POS<1,1>
    VPL.SEQ.NO.POS = Y.LOCAL.FIELDS.POS<1,2>
    CR.ACCT.NO.POS = Y.LOCAL.FIELDS.POS<1,3>

    AC.STATUS.1.POS = Y.LOCAL.FIELDS.POS<2,1>
    AC.STATUS.2.POS = Y.LOCAL.FIELDS.POS<2,2>
    AC.NOTIFY.1.POS = Y.LOCAL.FIELDS.POS<2,3>
    AC.AV.BAL.POS   = Y.LOCAL.FIELDS.POS<2,4>


RETURN

***********************
* Open Files
OPEN.FILES:
***********************
    CALL OPF(FN.REDO.VISION.PLUS.DD, F.REDO.VISION.PLUS.DD)
    CALL OPF(FN.REDO.VISION.PLUS.PARAM, F.REDO.VISION.PLUS.PARAM)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN

***********************
* Main Process
PROCESS:
***********************

*CALL F.READ(FN.REDO.VISION.PLUS.PARAM, REDO.VISION.PLUS.PARAM.ID, R.REDO.VISION.PLUS.PARAM, F.REDO.VISION.PLUS.PARAM, Y.ERR) ;*Tus Start
    CALL CACHE.READ(FN.REDO.VISION.PLUS.PARAM, REDO.VISION.PLUS.PARAM.ID, R.REDO.VISION.PLUS.PARAM,Y.ERR) ;*Tus End
    SELECT.STATEMENT = "SELECT " : FN.REDO.VISION.PLUS.DD
    SELECT.STATEMENT := " WITH PROCESADO EQ 'PEND'"

    CALL EB.READLIST(SELECT.STATEMENT, DD.LIST, DD.LIST.NAME, DD.SELECTED, DD.RETURN.CODE)

    IF DD.SELECTED LT 0 THEN
* Log writing: process finished
        APAP.REDOSRTN.redoSNotifyInterfaceAct ('VPL004', 'BATCH', '07', 'EMAIL ARCHIVO DEBITO DIRECTO', 'FIN - DEBITO DIRECTO A LAS ' : TIMEDATE(), '', '', '', '', '', OPERATOR, '') ;*MANUAL R22 CODE CONVERSION
        RETURN
    END

    LOOP
        REMOVE DD.ID FROM DD.LIST SETTING DD.POS
    WHILE DD.ID:DD.POS
* Issue Payment
        CALL F.READ(FN.REDO.VISION.PLUS.DD, DD.ID, R.REDO.VISION.PLUS.DD, F.REDO.VISION.PLUS.DD, Y.ERR)
        R.REDO.VISION.PLUS.DD<VP.DD.NUM.CTA.AHORRO> = TRIM(R.REDO.VISION.PLUS.DD<VP.DD.NUM.CTA.AHORRO>,'0','L')
        CUST.ACCOUNT = R.REDO.VISION.PLUS.DD<VP.DD.NUM.CTA.AHORRO>
        TXN.PAYMENT.AMT = R.REDO.VISION.PLUS.DD<VP.DD.MONTO.PAGO>
        GOSUB VAL.ACCOUNT
        IF NOT(R.REDO.VISION.PLUS.DD<VP.DD.OBSERVACIONES>) AND ACCT.VALIDATED THEN
            GOSUB GET.CUST.DATA
            IF Y.FLAG.WS THEN
                GOSUB PROCESS.FT
            END
        END
        CALL F.WRITE(FN.REDO.VISION.PLUS.DD, DD.ID, R.REDO.VISION.PLUS.DD)

    REPEAT


* Log writing: process finished
    APAP.REDOSRTN.redoSNotifyInterfaceAct ('VPL004', 'BATCH', '07', 'EMAIL ARCHIVO DEBITO DIRECTO', 'FIN - DEBITO DIRECTO A LAS ' : TIMEDATE(), '', '', '', '', '', OPERATOR, '') ;*MANUAL R22 CODE CONVERSION

RETURN

****************************
* Get Customer Account Data
GET.CUST.DATA:
****************************
    CREDIT.CARD.ID = R.REDO.VISION.PLUS.DD<VP.DD.NUMERO.CUENTA>
    CREDIT.CARD.ID = FMT(CREDIT.CARD.ID, 'R%19')

    ACTIVATION = 'WS_T24_VPLUS'
    Y.FLAG.WS = 0
    WS.DATA = ''
    WS.DATA<1> = 'CONSULTA_BALANCE'
    WS.DATA<2> = CREDIT.CARD.ID
    WS.DATA<3> = 'DDD'

* Invoke VisionPlus Web Service
    APAP.TAM.redoVpWsConsumer(ACTIVATION, WS.DATA) ;*MANUAL R22 CODE CONVERSION
  

* Credit Card exits - Info obtained OK
    IF WS.DATA<1> EQ 'OK' THEN
        Y.FLAG.WS = 1
        ID.COMPORTAMIENTO = WS.DATA<35>
        BEGIN CASE
            CASE ID.COMPORTAMIENTO EQ 1         ;* No Acepta Pago
                R.REDO.VISION.PLUS.DD<VP.DD.PROCESADO> = 'ERR'
                R.REDO.VISION.PLUS.DD<VP.DD.OBSERVACIONES> = REDO.S.GET.USR.ERR.MSG('ST-VP-NO.CARD.PAY') :  " " : CREDIT.CARD.ID
                Y.FLAG.WS = 0
            CASE ID.COMPORTAMIENTO EQ 2         ;* Acepta Pago con Autorizacion
                R.REDO.VISION.PLUS.DD<VP.DD.PROCESADO> = 'ERR'
                R.REDO.VISION.PLUS.DD<VP.DD.OBSERVACIONES> = REDO.S.GET.USR.ERR.MSG('ST-VP-NO.CARD.PAY') :  " " : CREDIT.CARD.ID
                Y.FLAG.WS = 0
            CASE 1
                Y.FLAG.WS = 1
        END CASE
    END ELSE
        R.REDO.VISION.PLUS.DD<VP.DD.PROCESADO> = 'ERR'
        R.REDO.VISION.PLUS.DD<VP.DD.OBSERVACIONES> = WS.DATA<1> : ' - COULD NOT OBTAIN CREDIT CARD - CUSTOMER DATA FROM VISION PLUS ' : WS.DATA<2>
    END

RETURN

*******************
* Validate Account
VAL.ACCOUNT:
*******************
    CALL F.READ(FN.ACCOUNT, CUST.ACCOUNT, R.ACCOUNT, F.ACCOUNT, Y.ERR)
    IF NOT(R.ACCOUNT) THEN
        ACCT.VALIDATED = 0
        R.REDO.VISION.PLUS.DD<VP.DD.PROCESADO> = 'ERR'
        R.REDO.VISION.PLUS.DD<VP.DD.OBSERVACIONES> = 'CUSTOMER CHECK/SAVING ACCOUNT DOES NOT EXIST OR IS CLOSED'
        RETURN
    END

*    ACCT.APPLICATION = 'ACCOUNT'
    ACCT.LOCAL.REF = 'LOCAL.REF'
    CALL EB.FIND.FIELD.NO(ACCT.APPLICATION, ACCT.LOCAL.REF)
*    ACCT.LOCAL.FIELDS = ''
*    ACCT.LOCAL.FIELDS.POS = ''

*    ACCT.LOCAL.FIELDS<1,1> = 'L.AC.STATUS1'
*    ACCT.LOCAL.FIELDS<1,2> = 'L.AC.STATUS2'
*    ACCT.LOCAL.FIELDS<1,3> = 'L.AC.NOTIFY.1'
*    ACCT.LOCAL.FIELDS<1,4> = 'L.AC.AV.BAL'


*   CALL MULTI.GET.LOC.REF(ACCT.APPLICATION, ACCT.LOCAL.FIELDS, ACCT.LOCAL.FIELDS.POS)

*   AC.STATUS.1.POS = ACCT.LOCAL.FIELDS.POS<1,1>
*   AC.STATUS.2.POS = ACCT.LOCAL.FIELDS.POS<1,2>
*   AC.NOTIFY.1.POS = ACCT.LOCAL.FIELDS.POS<1,3>
*   AC.AV.BAL.POS   = ACCT.LOCAL.FIELDS.POS<1,4>

    Y.ACCT.BALANCE = R.ACCOUNT<ACCT.LOCAL.REF, AC.AV.BAL.POS>


* Check Account Status
    GOSUB CHECK.ACCT.STATUS
    Y.PER = TXN.PAYMENT.AMT * 0.0015
    Y.PER += TXN.PAYMENT.AMT ;* R22 Auto conversion

    IF Y.PER GT Y.ACCT.BALANCE AND NOT(R.REDO.VISION.PLUS.DD<VP.DD.OBSERVACIONES>) THEN
        ACCT.VALIDATED = 0
        R.REDO.VISION.PLUS.DD<VP.DD.PROCESADO> = 'ERR'
        R.REDO.VISION.PLUS.DD<VP.DD.OBSERVACIONES> = 'PAYMENT AMOUNT IS GREATER THAN AVAILABLE AMOOUNT'
    END

RETURN

***********************
* Check Account Status
CHECK.ACCT.STATUS:
***********************
    Y.AC.STATUS.1 = R.ACCOUNT<ACCT.LOCAL.REF, AC.STATUS.1.POS>
    Y.AC.STATUS.2 = R.ACCOUNT<ACCT.LOCAL.REF, AC.STATUS.2.POS>
    Y.AC.NOTIFY.1 = R.ACCOUNT<ACCT.LOCAL.REF, AC.NOTIFY.1.POS>
    Y.AC.POST.RST = R.ACCOUNT<AC.POSTING.RESTRICT>

* Check L.AC.STATUS1
    IF Y.AC.STATUS.1 AND Y.AC.STATUS.1 NE 'ACTIVE' THEN
        Y.STATUS = Y.AC.STATUS.1
        ACCT.VALIDATED = 0
    END ELSE
        Y.STATUS = Y.AC.STATUS.1
        ACCT.VALIDATED = 1
    END

* Check L.AC.STATUS2
    FIND 'DECEASED' IN Y.AC.STATUS.2 SETTING D.POS, D.VAL THEN
        Y.STATUS = 'DECEASED'
        R.REDO.VISION.PLUS.DD<VP.DD.OBSERVACIONES> = 'CUSTOMER ACCOUNT(S) STATUS.2 IS ' : Y.STATUS
    END

    FIND 'GUARANTEE.STATUS' IN Y.AC.STATUS.2 SETTING GS.POS, GS.VAL THEN
        Y.STATUS = 'GUARANTEE.STATUS'
        R.REDO.VISION.PLUS.DD<VP.DD.OBSERVACIONES> = 'CUSTOMER ACCOUNT(S) STATUS.2 IS ' : Y.STATUS
    END

* Check L.AC.NOTIFY.1
    FIND 'EMPLOYEE' IN Y.AC.NOTIFY.1 SETTING E.POS, E.VAL THEN
        Y.STATUS = 'EMPLOYEE'
        R.REDO.VISION.PLUS.DD<VP.DD.OBSERVACIONES> = 'CUSTOMER ACCOUNT(S) NOTIFY.1 IS ' : Y.STATUS
    END

    FIND 'NOTIFY.OFFICER' IN Y.AC.NOTIFY.1 SETTING NO.POS, NO.VAL THEN
        Y.STATUS = 'NOTIFY.OFFICER'
        R.REDO.VISION.PLUS.DD<VP.DD.OBSERVACIONES> = 'CUSTOMER ACCOUNT(S) NOTIFY.1 IS ' : Y.STATUS
    END

    FIND 'NOTIFY.MGMT.MONEY.LAUNDRY.PREV' IN Y.AC.NOTIFY.1 SETTING NAML.POS, NAML.VAL THEN
        Y.STATUS = 'NOTIFY.MGMT.MONEY.LAUNDRY.PREV'
        R.REDO.VISION.PLUS.DD<VP.DD.OBSERVACIONES> = 'CUSTOMER ACCOUNT(S) NOTIFY.1 IS ' : Y.STATUS
    END

    FIND 'TELLER' IN Y.AC.NOTIFY.1 SETTING T.POS, T.VAL THEN
        Y.STATUS = 'TELLER'
        R.REDO.VISION.PLUS.DD<VP.DD.OBSERVACIONES> = 'CUSTOMER ACCOUNT(S) NOTIFY.1 IS ' : Y.STATUS
    END

* Check posting restrict
    IF Y.AC.POST.RST THEN
        BEGIN CASE
* NO DEBITO
            CASE Y.AC.POST.RST EQ '1'
                ACCT.VALIDATED = 0
* NO DEBITO NO CREDITO
            CASE Y.AC.POST.RST EQ 3
                ACCT.VALIDATED = 0
* EMPLEADO-CAJERO
            CASE Y.AC.POST.RST EQ 50
                ACCT.VALIDATED = 0
        END CASE
        IF NOT(ACCT.VALIDATED) THEN
            R.REDO.VISION.PLUS.DD<VP.DD.PROCESADO> = 'ERR'
            R.REDO.VISION.PLUS.DD<VP.DD.OBSERVACIONES> = 'ACCOUNT HAS A POSTING RESTRICT ' : CUST.ACCOUNT

        END
    END

RETURN

*************
* Process FT
PROCESS.FT:
*************
*    FT.APPLICATION = 'FUNDS.TRANSFER'

*    FT.LOCAL.FIELDS = ''
*    FT.LOCAL.FIELDS.POS = ''

*    FT.LOCAL.FIELDS<1,1> = 'L.FT.CR.CARD.NO'
*    FT.LOCAL.FIELDS<1,2> = 'L.SUN.SEQ.NO'
*    FT.LOCAL.FIELDS<1,3> = 'L.FT.CR.ACCT.NO'

*    CALL MULTI.GET.LOC.REF(FT.APPLICATION, FT.LOCAL.FIELDS, FT.LOCAL.FIELDS.POS)

*   CR.CARD.NO.POS = FT.LOCAL.FIELDS.POS<1,1>
*    VPL.SEQ.NO.POS = FT.LOCAL.FIELDS.POS<1,2>
*    CR.ACCT.NO.POS = FT.LOCAL.FIELDS.POS<1,3>

    R.FUNDS.TRANSFER = ''
*mg*
    R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO> = CUST.ACCOUNT
    R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY> = LCCY
    R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT> = TXN.PAYMENT.AMT
    R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO> = R.REDO.VISION.PLUS.PARAM<VP.PARAM.VP.ACCT>

    R.FUNDS.TRANSFER<FT.PROCESSING.DATE> = TODAY
    R.FUNDS.TRANSFER<FT.PAYMENT.DETAILS> = 'VISION PLUS CREDIT CARD PAYMENT'

* Credit Card
    Y.CREDIT.CARD = R.REDO.VISION.PLUS.DD<VP.DD.NUMERO.CUENTA>
    Y.CREDIT.CARD = Y.CREDIT.CARD[4,17]

    R.FUNDS.TRANSFER<FT.LOCAL.REF, VPL.SEQ.NO.POS> = Y.CREDIT.CARD
    R.FUNDS.TRANSFER<FT.LOCAL.REF, CR.ACCT.NO.POS> = CUST.ACCOUNT

* Check if it is necessary
* R.FUNDS.TRANSFER<FT.ORDERING.BANK> = 'VISION PLUS'

* Transform to OFS Message
    Y.VERSION      = "FUNDS.TRANSFER" : ',' : 'REDO.VP.DIRECT.DEBIT'
    TRANS.FUNC.VAL = "I"
    TRANS.OPER.VAL = "PROCESS"
    NO.AUTH        = "0"
    OFS.SOURCE     = "VP.OFS"

    CALL OFS.BUILD.RECORD(FT.APPLICATION, TRANS.FUNC.VAL, TRANS.OPER.VAL, Y.VERSION, '', NO.AUTH, '', R.FUNDS.TRANSFER, OFS.MSG.REQ)
    Y.OPTIONS = OFS.SOURCE : @FM : "OFS"

* Invoking OBM

    Y.TXN.COMMITED = 0
    CALL OFS.CALL.BULK.MANAGER(Y.OPTIONS, OFS.MSG.REQ, OFS.MSG.RES, Y.TXN.COMMITED)
    IF NOT(Y.TXN.COMMITED) THEN
        R.REDO.VISION.PLUS.DD<VP.DD.PROCESADO> = 'ERR'
        R.REDO.VISION.PLUS.DD<VP.DD.OBSERVACIONES> = 'ERROR IN FT OFS PROCESS ':OFS.MSG.REQ
    END ELSE
        R.REDO.VISION.PLUS.DD<VP.DD.PROCESADO> = 'OK'
        R.REDO.VISION.PLUS.DD<VP.DD.TXN.REF> = OFS.MSG.RES['/',1,1]
**Modified for direct debit payment report***start-----------------
        FLD.NAME='L.FT.MSG.CODE'
        NO.OF.FIELDS = DCOUNT(OFS.MSG.RES,',')
        Y.LP.CNT=1
        LOOP
        WHILE Y.LP.CNT LE NO.OF.FIELDS
            IF INDEX(FIELD(OFS.MSG.RES,',',Y.LP.CNT),FLD.NAME,1) THEN
                FLD.VALUE=FIELD(FIELD(OFS.MSG.RES,',',Y.LP.CNT),'=',2)
                IF FLD.VALUE NE '' THEN
                    R.REDO.VISION.PLUS.DD<VP.DD.TXN.REF> =R.REDO.VISION.PLUS.DD<VP.DD.TXN.REF>:"-":FLD.VALUE
                END
            END
            Y.LP.CNT += 1 ;* R22 Auto conversion
        REPEAT
**********end of change
    END
RETURN

* </region>

END
