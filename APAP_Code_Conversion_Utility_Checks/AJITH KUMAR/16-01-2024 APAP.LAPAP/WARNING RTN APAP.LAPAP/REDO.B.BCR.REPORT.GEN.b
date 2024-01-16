* @ValidationCode : MjotMTQxNjUxMjQ1NjpDcDEyNTI6MTcwNTA0Njc5NjU2Mzphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jan 2024 13:36:36
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
$PACKAGE APAP.LAPAP
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
* 26/09/2017 V.P.Ashokkumar    APAP                          Changed to display 'C' for Loan without any balance.
* 06/02/2018 Ashokkumar        APAP                          REmove the Product 'LINEAS.DE.CREDITO.TC'(Credit card) from the report.
* 27/04/2019  APAP              ET-2149                       cambios en el buro, reportar todas las transaciones solo a la fecha corte.
* 08.09.22   APAP              MDP-2591                      Incosistencia en los total cuota, monto cuota
*            APAP                                            fecha ultimo pago y monto ultimo pago
* 13/10/2022 APAP              MDP-2878:
*          1- Balance Actual el balance no es el correcto. le está faltando considerar la (mora) en los casos que corresponde.
*          2- En algunos casos en la columna fecha de apertura están colocando la fecha de apertura del ID nuevo y no del original con el cual nació el préstamo.
*          3- tenemos clientes que desaparecen sin indicar si están cancelados, por ejemplo: Para el corte de 15/07/2022 subieron 100 clientes de los cuales 10 están cancelados, para el corte del 30/07/2022 debe subir los 90 activos del corte anterior + los clientes nuevos del corte. Es lo que debe pasar sin embargo en vez de subir los 90 clientes del corte anterior solo están subiendo 75, dejando por fuera a 15 clientes aproximadamente que de a cuerdo a la verificación de los balances les correspondía subir en estado cancelado.
*          4- En la columna monto en atraso no debe ser mayo a la columna de balance actual.
*          5- La suma de los montos en el desglose de atrasos que corresponde a las ultimas 7 columnas debe ser igual a la columna monto en atraso.
*          6- Verificar los clientes que están subiendo con su nuevo ID y no con el que nació el préstamo, para el reporte de Buro de crédito debe de subir los cliente con su ID original ya que los cambio de ID son transparentes para algunos clientes.
*
* 21-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 21-APR-2023      Harishvikram C   Manual R22 conversion      <AA.CUS.PRIMARY.OWNER>  to <AA.CUS.CUSTOMER>

*----------------------------------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*23/05/2023      CONVERSION TOOL         AUTO R22 CODE CONVERSION             FM TO @FM, VM to @VM, SM to @SM, ++ to +=, = to EQ
*23/05/2023      HARISH VIKRAM           MANUAL R22 CODE CONVERSION           CALL routine format modified, PAYMT.METHOD.POS, Y.LAST.MONTH.ACT, Y.ESTATUS.VAL.ARR, Y.CATEGORIA.WOF added in insert file  I_REDO.B.BCR.REPORT.GEN.COMMON

*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.CUSTOMER
*    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.COUNTRY
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.OVERDUE
*    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_F.REDO.BCR.REPORT.DATA
    $INSERT I_REDO.B.BCR.REPORT.GEN.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
    $INSERT I_F.REDO.BCR.REPORT.EXEC
   $USING AA.Framework
*   $INSERT I_F.EB.CONTRACT.BALANCES
*    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY

    $USING APAP.AA
    $USING APAP.TAM

    CALL OCOMO(" processing Y.AA.ID [" : Y.AA.ID : "]")
*-----------------------------------------------------------------------------
    K.ID.PROC = Y.AA.ID

* Initiliaze variables
    GOSUB INITIALISE
    IF (Y.ERROR OR Y.ERR EQ '1') THEN
        RETURN
    END
    Y.MAIN.ARR.PRCT = R.AA<AA.Framework.Arrangement.ArrProduct ,1>
* Check whether it is a cancelled loan. then check if it is closed previous month.
    PROP.CLASS = 'PAYMENT.SCHEDULE'; PROPERTY = ''; EFF.DATE = ''; R.CONDITION = ''
    ERR.MSG = ''; R.AA.PAYMENT.SCHEDULE = ''
    APAP.AA.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    R.AA.PAYMENT.SCHEDULE = R.CONDITION
    GOSUB CHECK.CANCELLED.LOAN

    IF Y.PAST.MONTH.CLOSED.LOAN EQ 'YES' THEN
        CALL OCOMO("Loan skipped for closed last month - ":Y.AA.ID:" - ":YARR.EFFDTE:"/":Y.LAST.MONTH.ACT)
        RETURN
    END
*---------------------------------------------ET-2149
    IF Y.START EQ TODAY THEN
        CALL OCOMO("Excluyendo las aperturas y cancelaciones de préstamos que ocurren el día de la ejecucción del reporte. - ":Y.AA.ID:" - ":YARR.EFFDTE:"/":Y.LAST.MONTH.ACT)
        RETURN
    END
*--------------------------------------------------

    Y.STATUS.DD = ''; Y.PAID.BILLS.CNT = ''; Y.ROLE = ''
    IF R.AA.PAYMENT.SCHEDULE THEN
        Y.STATUS.DD  = R.AA.PAYMENT.SCHEDULE<AA.PS.LOCAL.REF,PAYMT.METHOD.POS>
        Y.PAID.BILLS.CNT = R.AA.PAYMENT.SCHEDULE<AA.PS.LOCAL.REF,POS.L.PAID.BILL.CNT>
    END
*---ET-2149
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
    YRECORD.STAT = ''; YCLOSE.DATE = ''  ; Y.CANCELACION.TODAY = ''
    Y.ARR.STAT = R.AA<AA.Framework.Arrangement.ArrProduct >
    Y.LINKED.APP.ID = R.AA<AA.Framework.ArrangementSim.ArrLinkedApplId,1>
    Y.START = R.AA<AA.Framework.ArrangementSim.ArrStartDate,1>
    R.ACCOUNT = ''; Y.ACC.ERR = ''; YOD.STAT = ''; YPOST.REST = ''
    CALL F.READ(FN.ACCOUNT,Y.LINKED.APP.ID,R.ACCOUNT,F.ACCOUNT,Y.ACC.ERR)
    IF NOT(R.ACCOUNT) THEN
        YACC.HID = Y.LINKED.APP.ID
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HST,YACC.HID,R.ACCOUNT,ERR.ACCOUNT)
    END
    IF R.ACCOUNT THEN
        YPOST.REST = R.ACCOUNT<AC.POSTING.RESTRICT,1>
        YRECORD.STAT = R.ACCOUNT<AC.RECORD.STATUS>
        YDTE.LST = R.ACCOUNT<AC.CLOSURE.DATE>
    END
    IF NOT(YDTE.LST) THEN
        YDTE.LST = R.ACCOUNT<AC.DATE.LAST.UPDATE>
    END
    IF Y.PRODUCT.GROUP.ARR EQ 'PRODUCTOS.WOF' THEN
        GOSUB GET.ACTUAL.BALANCE.WOF
    END ELSE
        GOSUB GET.ACTUAL.BALANCE
    END

    Y.MAIN.PROD.GROUP = R.AA<AA.Framework.ArrangementSim.ArrProductGroup,1>
    REQD.MODE = ''; EFF.DATE = Y.START; R.AA.ACTIVITY.HISTORY = ''
*    CALL AA.READ.ACTIVITY.HISTORY(Y.AA.ID, REQD.MODE, EFF.DATE, R.AA.ACTIVITY.HISTORY)
AA.Framework.ReadActivityHistory(Y.AA.ID, REQD.MODE, EFF.DATE, R.AA.ACTIVITY.HISTORY);* R22 UTILITY AUTO CONVERSION
    IF R.AA.ACTIVITY.HISTORY THEN
        YACT.ID.ARR = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistoryHist.AhActivity>
        YACT.IS.STAT = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistory.AhActStatus>
        YACT.EFF.DATE = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistory.AhActStatus>
        CHANGE @VM TO @FM IN YACT.ID.ARR
        CHANGE @SM TO @FM IN YACT.ID.ARR
        CHANGE @VM TO @FM IN YACT.IS.STAT
        CHANGE @SM TO @FM IN YACT.IS.STAT
        CHANGE @VM TO @FM IN YACT.EFF.DATE
        CHANGE @SM TO @FM IN YACT.EFF.DATE
*---------------------------------------------------------
**Agregando la actividad de AA
        Y.ACTIVITY.REF = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistory.AhActivityRef>
        CHANGE @VM TO @FM IN Y.ACTIVITY.REF
        CHANGE @SM TO @FM IN Y.ACTIVITY.REF
*----------------------------------------------------------

    END
    ERR.REDO.APAP.PROPERTY.PARAM = ''; R.REDO.APAP.PROPERTY.PARAM = ''; YPAYOFF.ACT = ''; YPAY.CNT = 0
*    CALL F.READ(FN.REDO.APAP.PROPERTY.PARAM,Y.MAIN.PROD.GROUP,R.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM,ERR.REDO.APAP.PROPERTY.PARAM)
    CALL CACHE.READ(FN.REDO.APAP.PROPERTY.PARAM,Y.MAIN.PROD.GROUP,R.REDO.APAP.PROPERTY.PARAM,ERR.REDO.APAP.PROPERTY.PARAM);* R22 UTILITY AUTO CONVERSION
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
        YCNT += 1
    REPEAT
**----------------------------------------------------------------------------------------------------------------

    IF Y.PAST.MONTH.CLOSED.LOAN NE 'YES' AND Y.PAST.MONTH.CLOSED.LOAN NE 'CURRNT' THEN
        GOSUB GET.VALIDAR.EB
        IF YACCT.GRP.IN EQ 1 THEN
            GOSUB GET.ACTIVITY.AA
            IF YARR.EFFDTE LT Y.LAST.MONTH.ACT  THEN
                Y.PAST.MONTH.CLOSED.LOAN = 'YES'
            END ELSE
                Y.PAST.MONTH.CLOSED.LOAN = 'CURRNT'
            END
        END
    END

***---excluir las cancelaciones que ocurren el dia de la ejecucion del reporte
    IF Y.PAST.MONTH.CLOSED.LOAN EQ 'YES' OR  Y.PAST.MONTH.CLOSED.LOAN EQ 'CURRNT' AND YARR.EFFDTE EQ TODAY THEN
        Y.PAST.MONTH.CLOSED.LOAN = ''
        Y.CANCELACION.TODAY = 'YES'
    END
***-------------------------------------------------------------------------------------------------------------
RETURN
GET.VALIDAR.EB:
    Y.CUENTA = "ACCOUNT" ; Y.UNCUENTA = "UNCACCOUNT" ; R.CB = ''
    CB.ERROR = ''; YACCT.GRP.IN = 0 ; Y.MONTO.EB = 0; Y.NROPRESTAMO = Y.LINKED.APP.ID
    BEGIN CASE
        CASE (Y.ARR.STAT EQ 'CLOSE' OR Y.ARR.STAT EQ 'PENDING.CLOSURE')
            YACCT.GRP.IN = 1
        CASE  (Y.ARR.STAT NE 'CLOSE' AND Y.ARR.STAT NE 'PENDING.CLOSURE')
            CALL F.READ(FN.EB.CONT.BAL,Y.NROPRESTAMO,R.CB,F.EB.CONT.BAL,CB.ERROR)
            IF R.CB THEN
                Y.TYPE.CB =  R.CB<ECB.TYPE.SYSDATE>
                Y.CNT = DCOUNT(Y.TYPE.CB,@VM)
                Y.CB.ACCOUN.TYPE = ""
                FOR I.VAR = 1 TO Y.CNT
                    Y.CB.ACCOUN.TYPE = R.CB<ECB.TYPE.SYSDATE,I.VAR>
                    IF Y.PRODUCT.GROUP.ARR EQ 'PRODUCTOS.WOF' AND INDEX(Y.CB.ACCOUN.TYPE,'WOFBL',1) GT 0 THEN
                        CONTINUE
                    END
                    FINDSTR Y.CUENTA IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN
                        FINDSTR Y.UNCUENTA IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN
                            CONTINUE
                        END
                        Y.TO.OPEN = R.CB<ECB.OPEN.BALANCE,I.VAR,1>
                        Y.CREDIT.AMT = R.CB<ECB.CREDIT.MVMT,I.VAR,1>
                        Y.DEBIT.AMT = R.CB<ECB.DEBIT.MVMT,I.VAR,1>
                        Y.SUMA.AMT = Y.TO.OPEN + Y.CREDIT.AMT + Y.DEBIT.AMT
                        Y.TOTAL.AMT += Y.SUMA.AMT
                        Y.MONTO.EB = Y.TOTAL.AMT
                    END
                NEXT I.VAR
                IF ABS(Y.MONTO.EB) EQ 0 THEN
                    YACCT.GRP.IN = 1
                END
            END
    END CASE
RETURN
GET.ACTIVITY.AA:
*******************
    Y.CNT = ''
    Y.CNT = DCOUNT(Y.ACTIVITY.REF,@FM)
    Y.FECHA.EFECTIVIDAD = ''; I.VAR = '' ; R.AA.ARRANGEMENT.ACTIVITY = '' ; ERR.AA.ARRANGEMENT.ACTIVITY = ''
    Y.TXN.AMOUNT = '' ; Y.ID = ''; Y.ACTIVIDAD = '';
    FOR I.VAR = 1 TO Y.CNT
        Y.ID = Y.ACTIVITY.REF<I.VAR>
        CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.ID,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,ERR.AA.ARRANGEMENT.ACTIVITY)
        R.AA.ARRANGEMENT.ACTIVITY=AA.Framework.ArrangementActivity.Read(Y.ID, ERR.AA.ARRANGEMENT.ACTIVITY)
        Y.TXN.AMOUNT =  R.AA.ARRANGEMENT.ACTIVITY<AA.Framework.SimulationCapture.ArrActTxnAmount>
        Y.ACTIVIDAD = R.AA.ARRANGEMENT.ACTIVITY<AA.Framework.RrControl.ArrActActivity>

*mayor que o igual a
* Se agrega tambien la activida de ajuste de cuota para los prestamo que son cancelados por ajuste
        IF Y.TXN.AMOUNT GE 0  OR Y.ACTIVIDAD EQ 'LENDING-AJUSTE.MANTENIMIENTO-CUOTA' THEN
            YARR.EFFDTE = R.AA.ARRANGEMENT.ACTIVITY<AA.Framework.SimulationCapture.ArrActEffectiveDate>
            RETURN
        END
    NEXT I.VAR
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
    Y.ORG.ARRANGEMENT=R.AA<AA.Framework.ArrangementSim.ArrOrigContractDate>
*----------------------------------------------------------------
    Y.ESTATUS.ARR = R.AA<AA.Framework.ArrangementSim.ArrOrigContractDate>
    Y.PRODUCT.GROUP.ARR = R.AA<AA.Framework.ArrangementSim.ArrOrigContractDate>
    IF Y.PRODUCT.GROUP.ARR EQ 'LINEAS.DE.CREDITO.TC' THEN
        Y.ERR = '1'
        RETURN
    END
    LOCATE Y.ESTATUS.ARR IN Y.ESTATUS.VAL.ARR<1,1> SETTING ES.POS THEN
        Y.ERR = ''
    END ELSE
        Y.ERR = '1'
        RETURN
    END
*--------------------------------------------------------------------
    IF NOT(Y.ORG.ARRANGEMENT) THEN
        Y.ORG.ARRANGEMENT = R.AA<AA.Framework.ArrangementSim.ArrProdEffDate >
    END
    IF Y.ERR NE '' THEN
        RETURN
    END
    LOC.REF.FIELDS = ""; C.VALD.POS = ''
    Y.TEL.OTR=''; Y.TEL.OFI=''
    Y.CUSTOMER.ID=R.AA<AA.Framework.ArrangementSim.ArrCustomer>
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
        CASE R.AA<AA.Framework.Arrangement.ArrCurrency> EQ 'DOP'
            Y.CURRENCY = 1
        CASE R.AA<AA.Framework.Arrangement.ArrCurrency> EQ 'USD'
            Y.CURRENCY = 2
        CASE 1
            Y.CURRENCY = "MONEDA [" : R.AA<A AA.Framework.Arrangement.ArrCurrency> : "] NO DEFINIDA"
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
    Y.PRIMARY.OWNER=R.AA.CUSTOMER<AA.CUS.CUSTOMER> ;*Manual R22 conversion
*Y.OWNER = R.AA.CUSTOMER<AA.CUS.OWNER,2>
    Y.OWNER = R.AA.CUSTOMER<AA.CUS.OTHER.PARTY>
    Y.OTHR.PARTY=R.AA.CUSTOMER<AA.CUS.OTHER.PARTY>
    Y.ROLE = R.AA.CUSTOMER<AA.CUS.ROLE>
    CALL OCOMO("customer info done")

*--- GDC-588 - ofermin -- TIPO DE PRODUCTO

    IF Y.PRODUCT.GROUP.ARR EQ 'PRODUCTOS.WOF' THEN

        Y.PRODUCT     = R.AA< AA.Framework.Arrangement.ArrProduct,1>
        Y.POS.PRODUCT = INDEX(Y.PRODUCT , ".WOF", 1);
        Y.PRODUCT     = LEFT(Y.PRODUCT, Y.POS.PRODUCT-1);

    END ELSE
        Y.PRODUCT = R.AA< AA.Framework.Arrangement.ArrProductGroup>
    END

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

    IF  Y.MONTO EQ '' THEN
        Y.MONTO=0
    END

    CALL OCOMO("AA terms info done")
*---- AA num cuotas
* Get AccountId associated with the current AA.ID
    Y.ACCOUNT.ID = ''
    LOCATE "ACCOUNT" IN R.AA<AA.Framework.ArrangementSim.ArrLinkedAppl, 1> SETTING Y.POS.ACCT THEN
        Y.ACCOUNT.ID = R.AA<AA.Framework.ArrangementSim.ArrLinkedApplId, Y.POS.ACCT>
    END ELSE
        RETURN
    END
    Y.BILL.SETCNT = R.AA.DETAILS<AA.AD.BILLS.SETTLED.CNT>
    Y.AD.BILL.LIST  = R.AA.DETAILS<AA.AD.BILL.ID> ;* Based on the logic of REDO.S.FC.AA.MNTPAY
    CHANGE @SM TO @VM IN Y.AD.BILL.LIST
    Y.TOTAL.DB = DCOUNT(Y.AD.BILL.LIST, @VM)
    YBILL.CNT = Y.TOTAL.DB

    GOSUB GET.BALANCES        ;* Balances by segment.

    CALL OCOMO("Balances done [" : Y.SALDO1 : "] [" : Y.SALDO2 : "] [" :Y.SALDO3 : "] [" :Y.SALDO4 : "] [" :Y.SALDO5: "] [" :Y.SALDO6 : "] [" :Y.SALDO7 : "]" )
*---- Rutinas - monto de la cuota
    Y.TOTAL.CUOTAS = Y.PAID.BILLS.CNT
*--------------------------------------------------------------------------------------------------
    IF Y.PRODUCT.GROUP.ARR EQ 'PRODUCTOS.WOF' THEN
        APAP.LAPAP.lapapBBcrReportGenWof(Y.AA.ID,Y.TOTAL.CUOTAS,Y.LASTPAY.AMT, Y.LASTPAY.DAT, Y.MNTPAY) ;*Manual R22 conversion
    END ELSE
        APAP.LAPAP.redoBBcrReportGenExt(Y.AA.ID,Y.TOTAL.CUOTAS,Y.LASTPAY.AMT, Y.LASTPAY.DAT, Y.MNTPAY,Y.PRODUCT.GROUP.ARR);*MANUAL R22 CODE CONVERSION
    END
*-------------------------------------------------------------------------------------------------


    IF (Y.LASTPAY.DAT AND Y.LASTPAY.DAT LT Y.LAST.MONTH.ACT) AND Y.ACC.AMT EQ 0 THEN
        CALL OCOMO("Loan skipped for closed last month payoff - ":Y.AA.ID:" - ":Y.LASTPAY.DAT:"/":Y.LAST.MONTH.ACT)
        Y.ERROR = 1
        RETURN
    END

    IF (Y.LASTPAY.DAT EQ '' AND Y.ACC.AMT EQ 0 AND (Y.ARR.STAT EQ 'PENDING.CLOSURE' OR Y.ARR.STAT EQ 'CLOSE') AND Y.FCORTE EQ '') THEN
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
*-----------------------------------------------------------------------------
GET.BALANCES:
*-----------------------------------------------------------------------------
    Y.UNPAID.BILL.CNT = 0; Y.FCORTE = 0
    Y.UNPAID.BILL.AMT = 0
    Y.CNT = 0
    LOOP
    WHILE Y.CNT NE YBILL.CNT
        Y.AA.BILL3 = Y.AD.BILL.LIST<1,YBILL.CNT,1>
        GOSUB READ.BILL.AA
        YBILL.TYPE = R.AA.BILL3<AA.BD.BILL.TYPE>
        IF Y.FCORTE EQ 0 THEN
            LOCATE 'PAYMENT' IN YBILL.TYPE<1,1> SETTING YPOSN THEN
                LOCATE 'DUE' IN R.AA.BILL3<AA.BD.BILL.STATUS,1> SETTING Y.POS THEN
***-----------------------------------------------------ET-2149
                    IF R.AA.BILL3<AA.BD.PAYMENT.DATE> EQ TODAY AND Y.CANCELACION.TODAY EQ 'YES' THEN
                        YBILL.CNT -= 1
                        CONTINUE
                    END
***-----------------------------------------------------------
                    Y.FCORTE = R.AA.BILL3<AA.BD.BILL.ST.CHG.DT, Y.POS>

                END
            END
        END
        IF Y.CANCELACION.TODAY EQ 'YES' THEN
            GOSUB GET.BILL.CLOSE.LOAN
        END ELSE
            GOSUB GET.BILL.CURRENT.LOAN
        END
        YBILL.CNT -= 1
    REPEAT

    Y.MONTOMORA  = Y.UNPAID.BILL.AMT
    Y.NUMCUOMORA = Y.UNPAID.BILL.CNT

    IF Y.FCORTE EQ 0 THEN
        ERR.AA.DETAILS.HST = ''; R.AA.DETAILS.HST = ''; Y.AD.BILL.LISTH = ''; Y.TOTAL.DBH = ''
        CALL F.READ(FN.AA.DETAILS.HST,Y.AA.ID,R.AA.DETAILS.HST,F.AA.DETAILS.HST,ERR.AA.DETAILS.HST)
        IF R.AA.DETAILS.HST THEN
            Y.AD.BILL.LISTH  = R.AA.DETAILS.HST<AA.AD.BILL.DATE>
            CHANGE @SM TO @VM IN Y.AD.BILL.LISTH
            Y.TOTAL.DBH = DCOUNT(Y.AD.BILL.LISTH, @VM)
            Y.FCORTE = Y.AD.BILL.LISTH<1,Y.TOTAL.DBH>
        END
    END
    IF Y.FCORTE EQ 0 AND Y.TOTAL.DB GE 1 AND R.AA.DETAILS THEN
        Y.AD.BILL.LISTH  = R.AA.DETAILS<AA.AD.BILL.DATE>
        CHANGE @SM TO @VM IN Y.AD.BILL.LISTH
        Y.TOTAL.DBH = DCOUNT(Y.AD.BILL.LISTH, @VM)
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
RETURN


GET.BILL.CLOSE.LOAN:
    Y.PROP.AMOUNT = 0 ; Y.REF.CNT = 0
    Y.REPAY.REF = R.AA.BILL3<AA.BD.REPAY.REF>
    Y.REPAY.REF = CHANGE(Y.REPAY.REF,@SM,@FM)
    Y.REPAY.REF  = CHANGE(Y.REPAY.REF,@VM,@FM)
    Y.REF.CNT = DCOUNT(Y.REPAY.REF,@FM)
    Y.REPAY.AMOUNT = R.AA.BILL3<AA.BD.REPAY.AMOUNT>
    Y.REPAY.AMOUNT = CHANGE(Y.REPAY.AMOUNT,@SM,@FM)
    Y.REPAY.AMOUNT = CHANGE(Y.REPAY.AMOUNT,@VM,@FM)

    FOR I.VAR = 1 TO Y.REF.CNT
        Y.FECHA.REPAY.REF = Y.REPAY.REF<I.VAR>
        Y.FECHA.REPAY.REF = CHANGE(Y.FECHA.REPAY.REF,'-',@FM)
        Y.FECHA.REPAY.REF = Y.FECHA.REPAY.REF<2>
        IF Y.FECHA.REPAY.REF EQ TODAY THEN
            Y.PROP.AMOUNT+= Y.REPAY.AMOUNT<I.VAR>
        END
    NEXT I.VAR

    IF Y.PROP.AMOUNT GT 0 THEN
        NO.OF.DAYS  = 'C'
        Y.PREV.DATE = R.AA.BILL3<AA.BD.PAYMENT.DATE>
        Y.NEXT.DATE = TODAY
        CALL CDD('',Y.PREV.DATE,Y.NEXT.DATE,NO.OF.DAYS)
        IF NO.OF.DAYS GT 30 THEN
            Y.UNPAID.BILL.CNT += 1
            Y.UNPAID.BILL.AMT+= Y.PROP.AMOUNT
        END
        BEGIN CASE
            CASE (NO.OF.DAYS GE 31) AND (NO.OF.DAYS LE 60)
                Y.SALDO1 += Y.PROP.AMOUNT
            CASE (NO.OF.DAYS GE 61) AND (NO.OF.DAYS LE 90)
                Y.SALDO2 += Y.PROP.AMOUNT
            CASE (NO.OF.DAYS GE 91) AND (NO.OF.DAYS LE 120)
                Y.SALDO3 += Y.PROP.AMOUNT
            CASE (NO.OF.DAYS GE 121) AND (NO.OF.DAYS LE 150)
                Y.SALDO4 += Y.PROP.AMOUNT
            CASE (NO.OF.DAYS GE 151) AND (NO.OF.DAYS LE 180)
                Y.SALDO5 += Y.PROP.AMOUNT
            CASE (NO.OF.DAYS GE 181) AND (NO.OF.DAYS LE 210)
                Y.SALDO6 += Y.PROP.AMOUNT
            CASE (NO.OF.DAYS GE 211)
                Y.SALDO7 += Y.PROP.AMOUNT
        END CASE
    END
RETURN

GET.BILL.CURRENT.LOAN:
    IF R.AA.BILL3<AA.BD.BILL.STATUS,1> NE 'SETTLED' AND SUM(R.AA.BILL3<AA.BD.OS.PROP.AMOUNT>) GT 0 THEN
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
    R.DATA<BCR.CUS.PASAPORTE>          = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
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
    GOSUB GET.ALT.IDWOF
    R.DATA<BCR.LOAN.CCY>               = Y.CURRENCY
    R.DATA<BCR.LOAN.TIPO>              = Y.PRODUCT
    R.DATA<BCR.LOAN.FPAGO>             = Y.FORM.PAYMENT     ;* PACS00356448
    R.DATA<BCR.LOAN.CTA.NUM>           = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.LOAN.CTA.RELACION>      = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.LOAN.CTA.DESCRIP>       = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.LOAN.CTA.STATUS>        = ''       ;* NO EN TRANSUNION
    R.DATA<BCR.LOAN.COMENTESPEC>       = ''       ;* NO EN TRANSUNION

    Y.FECHA.APERTURA = ''
    IF R.AA<AA.Framework.ArrangementSim.ArrOrigContractDate> THEN
        Y.FECHA.APERTURA  = R.AA<AA.Framework.ArrangementSim.ArrOrigContractDate>
    END ELSE
        Y.FECHA.APERTURA = R.AA<AA.Framework.ArrangementSim.ArrStartDate>
    END

    IF NOT(Y.FECHA.APERTURA.ALT) THEN
        R.DATA<BCR.LOAN.FAPERTURA> = Y.FECHA.APERTURA
    END ELSE
        R.DATA<BCR.LOAN.FAPERTURA> = Y.FECHA.APERTURA.ALT
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
    GOSUB GET.REDONDEAR.DECIMAL
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

GET.REDONDEAR.DECIMAL:
    Y.RESULTADO = 0; Y.RESULTADO.DIF  = 0;
    Y.MONTOMORA = FIELD(Y.MONTOMORA,'.',1)
    Y.SALDO1 = FIELD(Y.SALDO1,'.',1)
    Y.SALDO2 = FIELD(Y.SALDO2,'.',1)
    Y.SALDO3 = FIELD(Y.SALDO3,'.',1)
    Y.SALDO4 = FIELD(Y.SALDO4,'.',1)
    Y.SALDO5 = FIELD(Y.SALDO5,'.',1)
    Y.SALDO6 = FIELD(Y.SALDO6,'.',1)
    Y.SALDO7 = FIELD(Y.SALDO7,'.',1)
    Y.RESULTADO = Y.SALDO1 + Y.SALDO2 + Y.SALDO3 + Y.SALDO4 + Y.SALDO5 + Y.SALDO6 + Y.SALDO7;

    IF Y.MONTOMORA NE Y.RESULTADO THEN
        Y.RESULTADO.DIF = Y.MONTOMORA - Y.RESULTADO;

        BEGIN CASE
            CASE Y.SALDO7 GT 0
                Y.SALDO7 += Y.RESULTADO.DIF;
            CASE Y.SALDO6 GT 0
                Y.SALDO6 += Y.RESULTADO.DIF;
            CASE Y.SALDO5 GT 0
                Y.SALDO5 += Y.RESULTADO.DIF;
            CASE Y.SALDO4 GT 0
                Y.SALDO4 += Y.RESULTADO.DIF;
            CASE Y.SALDO3 GT 0
                Y.SALDO3 += Y.RESULTADO.DIF;
            CASE Y.SALDO2 GT 0
                Y.SALDO2 += Y.RESULTADO.DIF;
            CASE Y.SALDO1 GT 0
                Y.SALDO1 += Y.RESULTADO.DIF;
        END CASE


    END

RETURN
GET.ALT.IDWOF:
    ID.ALTENO4 = '' ; Y.ALT.ACCT.ID = '' ; Y.ALT.TYPE = ''
    Y.ALT.TYPE = R.ACCOUNT<AC.ALT.ACCT.TYPE>
    LOCATE R.ACCOUNT<AC.CATEGORY> IN Y.CATEGORIA.WOF<1,1> SETTING C.WOF.POS THEN
        CHANGE @VM TO @FM IN Y.ALT.TYPE
        CHANGE @SM TO @FM IN Y.ALT.TYPE
*--------------------------------------------------------- Alterno PLAN Z
        LOCATE "ALTERNO2" IN Y.ALT.TYPE<1> SETTING EYPO.POS THEN
            ID.ALTENO4  = R.ACCOUNT<AC.ALT.ACCT.ID,EYPO.POS,1>
            FINDSTR "VI" IN ID.ALTENO4 SETTING Ap, Vp THEN
                Y.ALT.ACCT.ID = ID.ALTENO4[3,LEN(ID.ALTENO4)]
            END
        END
*----------------------------------------------------------- Alterno migracion WOF
        IF Y.ALT.ACCT.ID EQ '' THEN
            CHANGE @VM TO @FM IN Y.ALT.TYPE
            CHANGE @SM TO @FM IN Y.ALT.TYPE
            LOCATE "ALTERNO3" IN Y.ALT.TYPE<1> SETTING EYPO.POS THEN
                ID.ALTENO4  = R.ACCOUNT<AC.ALT.ACCT.ID,EYPO.POS,1>
                FINDSTR "VI" IN ID.ALTENO4 SETTING Ap, Vp THEN
                    Y.ALT.ACCT.ID = ID.ALTENO4[3,LEN(ID.ALTENO4)]
                END
            END
        END
*-------------------------------------------------------------
    END ELSE
        CHANGE @VM TO @FM IN Y.ALT.TYPE
        CHANGE @SM TO @FM IN Y.ALT.TYPE
        LOCATE "ALTERNO2" IN Y.ALT.TYPE<1> SETTING EYPO.POS THEN
            ID.ALTENO4  = R.ACCOUNT<AC.ALT.ACCT.ID,EYPO.POS,1>
            Y.ALT.ACCT.ID = ID.ALTENO4[3,LEN(ID.ALTENO4)]
        END

        IF Y.ALT.ACCT.ID EQ '' THEN
            LOCATE "ALTERNO3" IN Y.ALT.TYPE<1> SETTING EYPO.POS THEN
                ID.ALTENO4  = R.ACCOUNT<AC.ALT.ACCT.ID,EYPO.POS,1>
                Y.ALT.ACCT.ID = ID.ALTENO4[3,LEN(ID.ALTENO4)]
            END
        END
    END

    IF Y.ALT.ACCT.ID NE '' THEN
        R.DATA<BCR.LOAN.ID>   = Y.ALT.ACCT.ID
    END ELSE
        R.DATA<BCR.LOAN.ID>   = R.AA<AA.Framework.ArrangementSim.ArrLinkedApplId,1>
        Y.ALT.ACCT.ID = R.AA<AA.Framework.ArrangementSim.ArrLinkedApplId,1>
    END
    GOSUB GET.FECHA.APE.ID.ALTERNO
RETURN

GET.FECHA.APE.ID.ALTERNO:
    Y.ALT.ACC.ID.HIS = Y.ALT.ACCT.ID ; Y.ALT.ACC.ID.HIS = Y.ALT.ACC.ID.HIS:";1" ; Y.FECHA.APERTURA.ALT = ''
    CALL F.READ(FN.ACCOUNT.HST,Y.ALT.ACC.ID.HIS,R.ACCOUNT.HST.1,F.ACCOUNT.HST,Y.ACC.ERR.1)

    IF R.ACCOUNT.HST.1 THEN
        CALL F.READ(FN.AA,R.ACCOUNT.HST.1<AC.ARRANGEMENT.ID>,R.AA.1,F.AA,Y.ERR.1)
        Y.FECHA.APERTURA.ALT = R.AA.1<AA.Framework.ArrangementSim.ArrOrigContractDate>
        IF NOT(Y.FECHA.APERTURA.ALT) THEN
            Y.FECHA.APERTURA.ALT = R.AA.1<AA.Framework.ArrangementSim.ArrStartDate>
        END
    END


RETURN

SET.CANCEL.MONTO:
*****************

    IF Y.PAST.MONTH.CLOSED.LOAN EQ 'CURRNT' THEN
        GOSUB ZERO.DEFLT
        RETURN
    END

    IF ((Y.ARR.STAT EQ 'EXPIRED' OR Y.ARR.STAT EQ 'PENDING.CLOSURE' OR Y.ARR.STAT EQ 'CLOSE' OR Y.ARR.STAT EQ 'CURRENT') AND Y.ACC.AMT EQ 0) THEN
        GOSUB ZERO.DEFLT
        RETURN
    END

    IF ((Y.ARR.STAT EQ 'EXPIRED' OR Y.ARR.STAT EQ 'PENDING.CLOSURE' OR Y.ARR.STAT EQ 'CLOSE' OR Y.ARR.STAT EQ 'CURRENT') AND Y.ACC.AMT NE 0) THEN
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
****Solicitado que este campo Y.MNTPAY , en el mdp-2951 no sebe reportal en cero
*Y.MNTPAY = 0
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
    APAP.AA.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    Y.LOAN.STATUS = R.CONDITION.OVERDUE<AA.OD.LOCAL.REF,POS.L.LOAN.STATUS.1>
    Y.LOAN.COND   = R.CONDITION.OVERDUE<AA.OD.LOCAL.REF,Y.L.LOAN.COND>

    IF R.AA.ACTIVITY.HISTORY AND (NOT(Y.LOAN.STATUS) AND NOT(Y.LOAN.COND)) THEN
        GOSUB GET.OVERD.VALUE
    END
***-------------------------------------------------------------------------*
    IF Y.PRODUCT.GROUP.ARR EQ 'PRODUCTOS.WOF' THEN
        LOCATE 'CASTIGADO' IN Y.LOAN.COND<1,1,1> SETTING Y.POS THEN
            Y.STATUS = 'Castigado'
            RETURN
        END
    END
***--------------------------------------------------------------------------*


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

GET.OVERD.VALUE:
****************
    YACT.ARR.ID = ''; YAACT.EFF.DATE = ''; ACT.OVER.ID = ''
    YACT.ARR.ID = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistoryHist.AhActivity>
    FINDSTR "LENDING-UPDATE-APAP.OVERDUE" IN YACT.ARR.ID<1> SETTING YFM, YVM, YSM THEN
        YAACT.EFF.DATE = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistoryHist.AhActivity,YVM,YSM>
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
*    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError);* R22 UTILITY AUTO CONVERSION
RETURN

GET.ACTUAL.BALANCE:
*-----------------------------------------------------------------------------
    PROP.CLASS = 'OVERDUE'
    PROPERTY   = ''; R.CONDITION.OVERDUE = ''; ERR.MSG = ''; EFF.DATE   = ''; Y.MORA.AMT = 0
    APAP.AA.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG);*MANUAL R22 CODE CONVERSION
    IF R.CONDITION.OVERDUE NE '' THEN

        Y.BILL.TYPE = R.CONDITION.OVERDUE<AA.OD.BILL.TYPE>
        LOCATE 'PAYMENT' IN Y.BILL.TYPE<1,1> SETTING YPOSN THEN
            Y.OD.STATUS.ARR = R.CONDITION.OVERDUE<AA.OD.OVERDUE.STATUS,YPOSN>
        END
        CHANGE @SM TO @FM IN Y.OD.STATUS.ARR
        Y.OVERDUE.STATUS = Y.OD.STATUS.ARR

        Y.ACCOUNT.PROPERTY = ''
        APAP.TAM.redoGetPropertyName(Y.AA.ID,'ACCOUNT',R.OUT.AA.RECORD,Y.ACCOUNT.PROPERTY,OUT.ERR);*MANUAL R22 CODE CONVERSION
        ACC.BALANCE.TYPE   = 'CUR':@FM:'DUE':@FM:Y.OVERDUE.STATUS

        PROP.NAME          = 'PRINCIPAL'
        APAP.TAM.redoGetInterestProperty(Y.AA.ID,PROP.NAME,PRINCIPAL.PROP,ERR) ;*MANUAL R22 CODE CONVERSION
        Y.PRINCIPALINT.TYPE = 'ACC':@FM:'DUE':@FM:Y.OVERDUE.STATUS

        PROP.NAME           = 'PENALTY'
        APAP.TAM.redoGetInterestProperty(Y.AA.ID,PROP.NAME,PENALTY.PROP,ERR) ;*MANUAL R22 CODE CONVERSION
        Y.PENALTYINT.TYPE   = 'ACC'
        Y.ACC.AMT = 0; Y.PRIN.AMT = 0; Y.PEN.AMT = 0
        Y.PROPERTY.LIST = Y.ACCOUNT.PROPERTY
        Y.BALANCE.TYPE  = ACC.BALANCE.TYPE
****-----------------------------------------------------------------------*********ET-2149
        Y.NOMBRE.PROPIEDAD = "ACCOUNT" ; Y.UNCUENTA = "UNCACCOUNT"
        GOSUB GET.BALANCE.EB.PROPIEDAD
        Y.ACC.AMT =  Y.MONTO.EB
***--------------------------------------------------------------------------------------------
        Y.PROPERTY.LIST = PRINCIPAL.PROP
        Y.BALANCE.TYPE  = Y.PRINCIPALINT.TYPE
*CALL REDO.GET.TOTAL.OUTSTANDING.BYPROP(Y.AA.ID,Y.PROPERTY.LIST,Y.BALANCE.TYPE,Y.PRIN.AMT)
        Y.NOMBRE.PROPIEDAD = "PRINCIPAL"
        GOSUB GET.BALANCE.EB.PROPIEDAD
        Y.PRIN.AMT = Y.MONTO.EB
***---------------------------------------------------------------------------------------------
        Y.PROPERTY.LIST = PENALTY.PROP
        Y.BALANCE.TYPE  = Y.PENALTYINT.TYPE
*CALL REDO.GET.TOTAL.OUTSTANDING.BYPROP(Y.AA.ID,Y.PROPERTY.LIST,Y.BALANCE.TYPE,Y.PEN.AMT)
        Y.NOMBRE.PROPIEDAD = "PENALTINT"
        GOSUB GET.BALANCE.EB.PROPIEDAD
        Y.PEN.AMT = Y.MONTO.EB
***------------------------------------------------------------------------------------------------------
*Y.BALACT = Y.ACC.AMT + Y.PRIN.AMT + Y.PEN.AMT + Y.MORA.AMT
        GOSUB GET.BALANCE.EB.PROPIEDAD.TOTAL
        Y.BALACT = Y.MONTO.EB
        Y.BALACT = ABS(Y.BALACT)
****-------------------------------------------------------------------------------------------------ET-2149
*--GDC-588 - ofermin

        FINDSTR PRINCIPAL.PROP IN R.AA.PAYMENT.SCHEDULE<AA.PS.PROPERTY> SETTING POS.AF,POS.AV,POS.AS THEN
            Y.PAY.FREQ = FIELD(R.AA.PAYMENT.SCHEDULE<AA.PS.PAYMENT.FREQ,POS.AV>," ",1,3):" e0D e0F"
            Y.FORM.PAYMENT = ''
            IN.DATE = ''
            CALL EB.BUILD.RECURRENCE.MASK(Y.PAY.FREQ, IN.DATE, Y.FORM.PAYMENT)
        END ELSE
            Y.FORM.PAYMENT = 'Mensual'
        END
    END


RETURN

GET.ACTUAL.BALANCE.WOF:
*-----------------------------------------------------------------------------

    IF Y.PRODUCT.GROUP.ARR EQ 'PRODUCTOS.WOF' THEN
        Y.FORM.PAYMENT = 'Mensual'
    END

    PROP.CLASS = 'OVERDUE'
    PROPERTY   = ''; R.CONDITION.OVERDUE = ''; ERR.MSG = ''; EFF.DATE   = ''
    APAP.AA.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    IF R.CONDITION.OVERDUE NE '' THEN

        Y.BILL.TYPE = R.CONDITION.OVERDUE<AA.OD.BILL.TYPE>
        LOCATE 'PAYMENT' IN Y.BILL.TYPE<1,1> SETTING YPOSN THEN
            Y.OD.STATUS.ARR = R.CONDITION.OVERDUE<AA.OD.OVERDUE.STATUS,YPOSN>
        END
        CHANGE @SM TO @FM IN Y.OD.STATUS.ARR
        Y.OVERDUE.STATUS = Y.OD.STATUS.ARR

        ACC.BALANCE.TYPE   = 'CUR':@FM:'DUE':@FM:Y.OVERDUE.STATUS
        Y.PRINCIPALINT.TYPE = 'ACC':@FM:'DUE':@FM:Y.OVERDUE.STATUS

        Y.ACC.AMT = 0; Y.PRIN.AMT = 0; Y.PRINTC.AMT = 0 ; Y.PRIN.AMT.SP = 0
        Y.MORA.WOF = 0; Y.MORA.WOF = 0; Y.PRADMSEGWOF = 0; Y.PRADMVARWOF = 0; Y.PRCOMCKDEV = 0;
**------------------------------------------------------------------------------ET-2149
        Y.NOMBRE.PROPIEDAD = "ACCOUNTWOF"
        GOSUB GET.BALANCE.EB.PROPIEDAD
        Y.ACC.AMT = Y.MONTO.EB
        Y.NOMBRE.PROPIEDAD = "PRINCIPALINTWOF"
        GOSUB GET.BALANCE.EB.PROPIEDAD
        Y.PRIN.AMT = Y.MONTO.EB
        Y.NOMBRE.PROPIEDAD = "PRINCIPALINWOF"
        GOSUB GET.BALANCE.EB.PROPIEDAD
        Y.PRIN.AMT.SP = Y.MONTO.EB
        Y.NOMBRE.PROPIEDAD = "PENALTYINTWOF"
        GOSUB GET.BALANCE.EB.PROPIEDAD
        Y.PEN.AMT  = Y.MONTO.EB
        Y.NOMBRE.PROPIEDAD = "PRMORAWOF"
        GOSUB GET.BALANCE.EB.PROPIEDAD
        Y.MORA.WOF  = Y.MONTO.EB

        Y.NOMBRE.PROPIEDAD = "PRADMVARWOF"
        GOSUB GET.BALANCE.EB.PROPIEDAD
        Y.PRADMVARWOF  = Y.MONTO.EB

        Y.NOMBRE.PROPIEDAD = "PRCOMCKDEV"
        GOSUB GET.BALANCE.EB.PROPIEDAD
        Y.PRCOMCKDEV  = Y.MONTO.EB

        Y.NOMBRE.PROPIEDAD = "PRADMSEGWOF"
        GOSUB GET.BALANCE.EB.PROPIEDAD
        Y.PRADMSEGWOF = Y.MONTO.EB


        Y.BALACT = Y.ACC.AMT + Y.PRIN.AMT + Y.PRIN.AMT.SP + Y.PEN.AMT + Y.MORA.WOF + Y.PRADMVARWOF + Y.PRCOMCKDEV + Y.PRADMSEGWOF;
        Y.BALACT = ABS(Y.BALACT)
        RETURN

***----------------------***
GET.BALANCE.EB.PROPIEDAD:
***----------------------***
        R.EB.CONT.BAL = ''
        CB.ERROR = ''; YACCT.GRP.IN = 0 ; Y.MONTO.EB = 0; Y.FECHA.EB  = ''; Y.TOTAL.AMT = 0;
        Y.TO.OPEN = 0; Y.CREDIT.AMT = 0 ; Y.DEBIT.AMT = 0; Y.SUMA.AMT = 0;
        Y.NROPRESTAMO = Y.LINKED.APP.ID
        CALL F.READ(FN.EB.CONT.BAL,Y.NROPRESTAMO,R.EB.CONT.BAL,F.EB.CONT.BAL,EB.CONTRACT.BALANCES.ERR)
        Y.TYPE.CB =  R.EB.CONT.BAL<ECB.TYPE.SYSDATE>
        Y.CNT = DCOUNT(Y.TYPE.CB,@VM)
        Y.CB.ACCOUN.TYPE = ""
        FOR I.VAR = 1 TO Y.CNT
            Y.CB.ACCOUN.TYPE = R.EB.CONT.BAL<ECB.TYPE.SYSDATE,I.VAR>
            IF Y.PRODUCT.GROUP.ARR EQ 'PRODUCTOS.WOF' AND INDEX(Y.CB.ACCOUN.TYPE,'WOFBL',1) GT 0 THEN
                CONTINUE
            END
            FINDSTR Y.NOMBRE.PROPIEDAD IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN

                BEGIN CASE
                    CASE Y.NOMBRE.PROPIEDAD EQ 'ACCOUNT'
                        FINDSTR Y.UNCUENTA IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN
                            CONTINUE
                        END
                    CASE  Y.NOMBRE.PROPIEDAD EQ 'PRINCIPAL'
                        FINDSTR 'PRINCIPALINTBL' IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN
                            CONTINUE
                        END
                        FINDSTR 'PRINCIPALINTSP' IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN
                            CONTINUE
                        END
                    CASE Y.NOMBRE.PROPIEDAD EQ 'PENALTINT'
                        FINDSTR 'PENALTINTBL' IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN
                            CONTINUE
                        END
                        FINDSTR 'PENALTINTSP' IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN
                            CONTINUE
                        END

                    CASE Y.NOMBRE.PROPIEDAD EQ 'PRMORA'
                        FINDSTR 'PRMORABL' IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN
                            CONTINUE
                        END

                END CASE

                Y.CB.ACCOUN.TYPE = CHANGE(Y.CB.ACCOUN.TYPE,"-",@FM)
                Y.FECHA.EB = Y.CB.ACCOUN.TYPE<2>
                IF Y.FECHA.EB EQ TODAY THEN
                    CONTINUE
                END
                Y.TO.OPEN = R.EB.CONT.BAL<ECB.OPEN.BALANCE,I.VAR,1>
                Y.CREDIT.AMT = R.EB.CONT.BAL<ECB.CREDIT.MVMT,I.VAR,1>
                Y.DEBIT.AMT = R.EB.CONT.BAL<ECB.DEBIT.MVMT,I.VAR,1>
                Y.SUMA.AMT = Y.TO.OPEN + Y.CREDIT.AMT + Y.DEBIT.AMT
                Y.TOTAL.AMT += Y.SUMA.AMT
                Y.MONTO.EB = Y.TOTAL.AMT
            END
        NEXT I.VAR
        RETURN

***----------------------***
GET.BALANCE.EB.PROPIEDAD.TOTAL:
***----------------------***

        R.EB.CONT.BAL = ''
        CB.ERROR = ''; YACCT.GRP.IN = 0 ; Y.MONTO.EB = 0; Y.FECHA.EB  = ''; Y.TOTAL.AMT = 0;
        Y.TO.OPEN = 0; Y.CREDIT.AMT = 0 ; Y.DEBIT.AMT = 0; Y.SUMA.AMT = 0; Y.SALDO.EXCLUIR  = '';
        Y.NROPRESTAMO = Y.LINKED.APP.ID
        CALL F.READ(FN.EB.CONT.BAL,Y.NROPRESTAMO,R.EB.CONT.BAL,F.EB.CONT.BAL,EB.CONTRACT.BALANCES.ERR)
        Y.TYPE.CB =  R.EB.CONT.BAL<ECB.TYPE.SYSDATE>
        Y.CNT = DCOUNT(Y.TYPE.CB,@VM)
        Y.CB.ACCOUN.TYPE = ""
        FOR I.VAR = 1 TO Y.CNT
            Y.LONGITUD = 0;
            Y.CB.ACCOUN.TYPE = R.EB.CONT.BAL<ECB.TYPE.SYSDATE,I.VAR>
            IF Y.PRODUCT.GROUP.ARR EQ 'PRODUCTOS.WOF' AND INDEX(Y.CB.ACCOUN.TYPE,'WOFBL',1) GT 0 THEN
                CONTINUE
            END

            FINDSTR "UNCACCOUNT" IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN
                CONTINUE
            END


            FINDSTR 'TOTCOMMITMENT' IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN
                CONTINUE
            END


            Y.SALDO.EXCLUIR = Y.CB.ACCOUN.TYPE
            Y.SALDO.EXCLUIR = CHANGE(Y.CB.ACCOUN.TYPE,"-",@FM)
            Y.SALDO.EXCLUIR = Y.SALDO.EXCLUIR<1>
            Y.LONGITUD = LEN(Y.SALDO.EXCLUIR)
            Y.SALDO.EXCLUIR = Y.SALDO.EXCLUIR[Y.LONGITUD-1,2]
            IF Y.SALDO.EXCLUIR EQ 'BL' OR  Y.SALDO.EXCLUIR EQ 'SP' THEN
                CONTINUE
            END
            Y.CB.ACCOUN.TYPE = CHANGE(Y.CB.ACCOUN.TYPE,"-",@FM)
            Y.FECHA.EB = Y.CB.ACCOUN.TYPE<2>
            IF Y.FECHA.EB EQ TODAY THEN
                CONTINUE
            END
            Y.TO.OPEN = R.EB.CONT.BAL<ECB.OPEN.BALANCE,I.VAR,1>
            Y.CREDIT.AMT = R.EB.CONT.BAL<ECB.CREDIT.MVMT,I.VAR,1>
            Y.DEBIT.AMT = R.EB.CONT.BAL<ECB.DEBIT.MVMT,I.VAR,1>
            Y.SUMA.AMT = Y.TO.OPEN + Y.CREDIT.AMT + Y.DEBIT.AMT
            Y.TOTAL.AMT += Y.SUMA.AMT
            Y.MONTO.EB = Y.TOTAL.AMT
        NEXT I.VAR
        RETURN


    END
