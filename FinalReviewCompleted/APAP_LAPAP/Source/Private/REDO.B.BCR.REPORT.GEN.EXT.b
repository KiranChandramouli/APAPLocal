* @ValidationCode : MjotMzU0OTg4NDI6Q3AxMjUyOjE2ODU5NTI0ODY5NzA6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jun 2023 13:38:06
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
$PACKAGE APAP.LAPAP
* @(#) REDO.B.BCR.REPORT.GEN.EXT Ported to jBASE 16:17:03  28 NOV 2017
*  The following variable names were converted
*   EXTRACT
*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.BCR.REPORT.GEN.EXT(Y.AA.ID,Y.TOTAL.CUOTAS,Y.LASTPAY.AMT, Y.LASTPAY.DAT,Y.FIN.AMT,Y.PRODUCTO.GRUPO )
*-----------------------------------------------------------------------------
* Mutli-threaded Close of Business routine, related to REDO.B.BCR.REPORT.GEN
*
*-----------------------------------------------------------------------------
* Modification History:
* Revision History:
* -----------------
* Date       Name              Reference                     Version
* --------   ----              ----------                    --------
* 17.04.12   hpasquel          PACS00191153                  C.22 problems, improve COB
* 08.09.22   APAP              MDP-2591                      Incosistencia en los total cuota, monto cuota
*                                                            fecha ultimo pago y monto ultimo pago
*
*
* 21-APR-2023     Conversion tool    R22 Auto conversion       FM TO @FM, VM to @VM, SM to @SM, ++ to +=, I to I.VAR, = to EQ
* 21-APR-2023      Harishvikram C   Manual R22 conversion      CALL routine format modified, Y.CATEGORIA.WOF added in insert file  I_REDO.B.BCR.REPORT.GEN.COMMON

*------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.REFERENCE.DETAILS
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.PAYMENT.SCHEDULE
*
    $INSERT I_F.REDO.BCR.REPORT.DATA
    $INSERT I_REDO.B.BCR.REPORT.GEN.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.DATES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    
    $USING APAP.TAM
    
    GOSUB INITIALISE
    GOSUB Extract

**** Si el prestamo es catigado no aplicar esta logica.
    IF Y.PRODUCTO.GRUPO EQ 'PRODUCTOS.WOF' THEN
        RETURN
    END
**-----total de cuota pr
    IF Y.TOTAL.CUOTAS EQ 0 THEN
        GOSUB GET.ALL.BILL
    END


**--- Si el monto de cuota esta en blanco y tiene cuotas
**--- entoces busca la penultima factura excluyendo la factura de
**--- balance de cancelacion la cual no aplica
    IF Y.TOTAL.CUOTAS GT 0 AND NOT(Y.FIN.AMT) THEN
        GOSUB GET.PENULTIMA.BILL
    END

***--- Para los casos en que la cuota esta en cero y pr esta cancelado
    GOSUB GET.FIND.CANCELADO
    IF Y.FIN.AMT LT 1 AND Y.ESTADO.CANCELADO EQ 'YES' THEN
        GOSUB GET.PENULTIMA.BILL
    END

***---- fecha ultimo pago pr y monto ultimo pago pr
    IF NOT (Y.LASTPAY.AMT) THEN
        GOSUB READ.FROM.ACCOUNT
    END

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.PAID.BILLS.CNT = ''
    Y.PAID.BILLS.CNT = Y.TOTAL.CUOTAS
    Y.TOTAL.CUOTAS = ''
    Y.LASTPAY.AMT  = ''
    Y.LASTPAY.DAT  = ''
RETURN

*-----------------------------------------------------------------------------
Extract:
*-----------------------------------------------------------------------------
    GOSUB EXTRACT.NUM.CUOTAS
    GOSUB GET.HISTORY.PAYMENT
RETURN

*-----------------------------------------------------------------------------
EXTRACT.NUM.CUOTAS:
*-----------------------------------------------------------------------------
*CALL AA.SCHEDULE.PROJECTOR(Y.AA.ID, SIM.REF, "",CYCLE.DATE, TOT.PAYMENT, DUE.DATES, DUE.TYPES, DUE.METHODS, DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)        ;* Routine to Project complete schedules

    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACT.ERR)
    CALL F.READ(FN.REDO.AA.SCHEDULE,Y.AA.ID,R.REDO.AA.SCHEDULE,F.REDO.AA.SCHEDULE,SCH.ERR)
    Y.TOTAL.CUOTAS = DCOUNT(R.REDO.AA.SCHEDULE<2>,@VM) + Y.PAID.BILLS.CNT

    Y.FIN.AMT       = ''
    Y.NEXT.PAYAMT   = ''
    Y.LAST.PAYAMT   = ''
    Y.FIN.AMT       = ''
    Y.OTHER.AMT     = ''
    Y.OTHER.DATE    = ''
    Y.LAST.PAY.DATE = ''

    ACCOUNT.PROPERTY = ''
    APAP.TAM.redoGetPropertyName(Y.AA.ID,'ACCOUNT',R.OUT.AA.RECORD,ACCOUNT.PROPERTY,OUT.ERR) ;*MANUAL R22 CODE CONVERSION
    Y.PAYMENT.DATES     = RAISE(R.REDO.AA.SCHEDULE<2>)
    Y.PROPERTY          = RAISE(R.REDO.AA.SCHEDULE<6>)
    Y.DUE.AMTS          = RAISE(R.REDO.AA.SCHEDULE<1>)
    Y.PAYMENT.DATES.CNT = DCOUNT(Y.PAYMENT.DATES,@FM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.PAYMENT.DATES.CNT
        Y.PROP.LIST = Y.PROPERTY<Y.VAR1>
        Y.DATE      = Y.PAYMENT.DATES<Y.VAR1>
        IF Y.DATE GE TODAY THEN
            FINDSTR 'ACCOUNT' IN Y.PROP.LIST SETTING POS.AF,POS.AV THEN
                Y.NEXT.PAYAMT = Y.DUE.AMTS<Y.VAR1>
                IF Y.NEXT.PAYAMT THEN
                    Y.VAR1 = Y.PAYMENT.DATES.CNT + 1        ;* Break
                END
            END ELSE
                FINDSTR 'PRINCIPALINT' IN Y.PROP.LIST SETTING POS.AF,POS.AV THEN
                    Y.NEXT.PAYAMT = Y.DUE.AMTS<Y.VAR1>
                    IF Y.NEXT.PAYAMT THEN
                        Y.VAR1 = Y.PAYMENT.DATES.CNT + 1    ;* Break
                    END
                END ELSE
                    Y.OTHER.AMT  = Y.DUE.AMTS<Y.VAR1>
                    Y.OTHER.DATE = Y.DATE
                END
            END
        END ELSE
            FINDSTR 'ACCOUNT' IN Y.PROP.LIST SETTING POS.AF,POS.AV THEN
                Y.LAST.PAYAMT   = Y.DUE.AMTS<Y.VAR1>
                Y.LAST.PAY.DATE = Y.DATE
            END ELSE
                FINDSTR 'PRINCIPALINT' IN Y.PROP.LIST SETTING POS.AF,POS.AV THEN
                    Y.LAST.PAYAMT = Y.DUE.AMTS<Y.VAR1>
                    Y.LAST.PAY.DATE = Y.DATE
                END ELSE
                    Y.OTHER.AMT = Y.DUE.AMTS<Y.VAR1>
                    Y.OTHER.DATE = Y.DATE
                END
            END
        END

        Y.VAR1 += 1
    REPEAT
    GOSUB EXTRACT.NUM.CUOTAS.PART

RETURN
*-----------------------------------------------------------------------------
EXTRACT.NUM.CUOTAS.PART:
*-----------------------------------------------------------------------------
    IF Y.NEXT.PAYAMT THEN
        Y.FIN.AMT = Y.NEXT.PAYAMT
        LOCATE Y.DATE IN R.AA.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE,1> SETTING BILL.POS THEN
            Y.BILL.IDS   = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,BILL.POS>
            Y.BILL.TYPES = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,BILL.POS>
            CHANGE @SM TO @FM IN Y.BILL.IDS
            CHANGE @SM TO @FM IN Y.BILL.TYPES
            GOSUB REMOVE.PAYOFF.BILLS   ;* No need to sum the amount of payoff bill
            GOSUB PROCESS.BILL
            Y.FIN.AMT = SUM(R.ARRAY<4>)
        END
    END ELSE
        IF Y.LAST.PAYAMT THEN
            Y.FIN.AMT = Y.LAST.PAYAMT
            LOCATE Y.LAST.PAY.DATE IN R.AA.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE,1> SETTING BILL.POS THEN
                Y.BILL.IDS   = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,BILL.POS>
                Y.BILL.TYPES = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,BILL.POS>
                CHANGE @SM TO @FM IN Y.BILL.IDS
                CHANGE @SM TO @FM IN Y.BILL.TYPES
                GOSUB REMOVE.PAYOFF.BILLS         ;* No need to sum the amount of payoff bill
                GOSUB PROCESS.BILL
                Y.FIN.AMT = SUM(R.ARRAY<4>)
            END ELSE
                GOSUB READ.AA.DET.HIST
                LOCATE Y.LAST.PAY.DATE IN R.AA.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE,1> SETTING BILL.POSN THEN
                    Y.BILL.IDS   = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,BILL.POS>
                    Y.BILL.TYPES = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,BILL.POS>
                    CHANGE @SM TO @FM IN Y.BILL.IDS
                    CHANGE @SM TO @FM IN Y.BILL.TYPES
                    GOSUB REMOVE.PAYOFF.BILLS     ;* No need to sum the amount of payoff bill
                    GOSUB PROCESS.BILL
                    Y.FIN.AMT = SUM(R.ARRAY<4>)
                END
            END
        END ELSE
            Y.FIN.AMT = Y.OTHER.AMT
            LOCATE Y.OTHER.DATE IN R.AA.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE,1> SETTING BILL.POS THEN
                Y.BILL.IDS   = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,BILL.POS>
                Y.BILL.TYPES = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,BILL.POS>
                CHANGE @SM TO @FM IN Y.BILL.IDS
                CHANGE @SM TO @FM IN Y.BILL.TYPES
                GOSUB REMOVE.PAYOFF.BILLS         ;* No need to sum the amount of payoff bill
                GOSUB PROCESS.BILL
                Y.FIN.AMT = SUM(R.ARRAY<4>)
            END ELSE
                GOSUB READ.AA.DET.HIST
                LOCATE Y.OTHER.DATE IN R.AA.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE,1> SETTING BILL.POSN THEN
                    Y.BILL.IDS   = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,BILL.POS>
                    Y.BILL.TYPES = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,BILL.POS>
                    CHANGE @SM TO @FM IN Y.BILL.IDS
                    CHANGE @SM TO @FM IN Y.BILL.TYPES
                    GOSUB REMOVE.PAYOFF.BILLS     ;* No need to sum the amount of payoff bill
                    GOSUB PROCESS.BILL
                    Y.FIN.AMT = SUM(R.ARRAY<4>)
                END
            END
        END
    END
RETURN

READ.AA.DET.HIST:
*****************
    R.AA.ACCOUNT.DETAILS = ''; ACT.ERR = ''
    CALL F.READ(FN.AA.DETAILS.HST,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.DETAILS.HST,ACT.ERR)
RETURN

*-----------------------------------------------------------------------------
GET.HISTORY.PAYMENT:
*-----------------------------------------------------------------------------
    Y.LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    CALL F.READ(FN.AA.REFERENCE.DETAILS,Y.AA.ID,R.AA.TXN.DET,F.AA.REFERENCE.DETAILS,TXN.REF.ERR)
    IF R.AA.TXN.DET THEN
        Y.ACTIVITY.CNT = DCOUNT(R.AA.TXN.DET<AA.REF.TRANS.REF>,@VM)
        Y.VAR1 = 1
        LOOP
        WHILE Y.VAR1 LE Y.ACTIVITY.CNT
            Y.AAA.ID = R.AA.TXN.DET<AA.REF.AAA.ID,Y.VAR1>
            CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.AAA.ID,R.AAA,F.AA.ARRANGEMENT.ACTIVITY,AAA.ERR)
            Y.ACT.CLASS = R.AAA<AA.ARR.ACT.ACTIVITY.CLASS>
***Excluyendo los pagos de interes,cargos y ajustes
            YACTIVITY = R.AAA<AA.ARR.ACT.ACTIVITY>

            IF R.AAA<AA.ARR.ACT.TXN.AMOUNT> NE '' AND R.AAA<AA.ARR.ACT.TXN.AMOUNT> LT 1 THEN
                Y.VAR1 += 1
                CONTINUE
            END


            IF YACTIVITY EQ 'LENDING-APPLYPAYMENT-RP.INT' OR RIGHT(YACTIVITY,11) EQ 'RADIACIOHIP' OR RIGHT(YACTIVITY,12) EQ 'RADIACIOHIP1' OR  LEFT(YACTIVITY,24) EQ 'LENDING-AGE-APAP.OVERDUE' OR YACTIVITY EQ 'LENDING-MAKEDUE-REPAYMENT.SCHEDULE' OR YACTIVITY EQ  'LENDING-UPDATE-OD.STATUS' OR YACTIVITY EQ 'MORA.CHARGE.ADJUSTMENT' OR YACTIVITY EQ 'LENDING-ISSUEBILL-REPAYMENT.SCHEDULE*SOLO.INTERES' THEN
                Y.VAR1 += 1
                CONTINUE
            END
**----------------------------------------------------

            IF Y.ACT.CLASS NE 'LENDING-DISBURSE-TERM.AMOUNT' AND Y.ACT.CLASS NE '' THEN
*IF R.AAA<AA.ARR.ACT.EFFECTIVE.DATE> LE TODAY THEN
                IF R.AAA<AA.ARR.ACT.EFFECTIVE.DATE> LE Y.LAST.WORK.DAY THEN
                    Y.FINAL.AAA.ID = Y.AAA.ID
                END
            END
            Y.VAR1 += 1
        REPEAT
    END
    IF Y.FINAL.AAA.ID ELSE
        RETURN
    END

    CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.FINAL.AAA.ID,R.AAA,F.AA.ARRANGEMENT.ACTIVITY,AAA.ERR)

    Y.LASTPAY.AMT    = R.AAA<AA.ARR.ACT.ORIG.TXN.AMT>
    Y.LASTPAY.DAT    = R.AAA<AA.ARR.ACT.EFFECTIVE.DATE>
RETURN
*-----------------------------------------------------------------------------
REMOVE.PAYOFF.BILLS:
*-----------------------------------------------------------------------------
    LOCATE 'PAYOFF' IN Y.BILL.TYPES<1> SETTING POS.PAYOFF THEN
        DEL Y.BILL.IDS<POS.PAYOFF>
    END
RETURN

*-----------------------------------------------------------------------------
PROCESS.BILL:
*************
    Y.BILL.CNT = DCOUNT(Y.BILL.IDS,@FM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.BILL.CNT
        Y.BILL.ID = Y.BILL.IDS<Y.VAR1>
        R.ARRAY<1,Y.VAR1> = Y.BILL.ID
        CALL F.READ(FN.AA.BILL,Y.BILL.ID,R.BILL.DETAILS,F.AA.BILL,BILL.ERR)
        IF NOT(R.BILL.DETAILS) THEN
            R.BILL.DETAILS = ''; BILL.ERR = ''
            CALL F.READ(FN.AA.BILL.HST,Y.BILL.ID,R.BILL.DETAILS,F.AA.BILL.HST,BILL.ERR)
        END
        GOSUB GET.RESPECTIVES.AMOUNT
        Y.VAR1 += 1
    REPEAT
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


GET.ALL.BILL:
    SEL.CMD = ''; SEL.LIST = ''; NO.OF.RECS = ''; RET.CODE = '';
    SEL.CMD = "SELECT ":FN.AA.BILL:" WITH ARRANGEMENT.ID EQ ":Y.AA.ID:" AND BILL.TYPE NE 'PAYOFF' BY-DSND PAYMENT.DATE"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,RET.CODE)
    Y.TOTAL.CUOTAS = NO.OF.RECS
    IF NO.OF.RECS EQ 0 THEN
        SEL.CMD = ''; SEL.LIST = ''; NO.OF.RECS = ''; RET.CODE = '';
        SEL.CMD = "SELECT ":FN.AA.BILL.HST:" WITH ARRANGEMENT.ID EQ ":Y.AA.ID:" AND BILL.TYPE NE 'PAYOFF' BY-DSND PAYMENT.DATE"
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,RET.CODE)
        Y.TOTAL.CUOTAS = NO.OF.RECS
        IF NO.OF.RECS EQ 0 THEN
            Y.TOTAL.CUOTAS = NO.OF.RECS
        END
    END
    LOOP
        REMOVE Y.BILL.ID FROM SEL.LIST SETTING BIL.POST1
    WHILE  Y.BILL.ID  DO

        CALL F.READ (FN.AA.BILL,Y.BILL.ID,R.AA.BILL.1,F.AA.BILL,ERROR.AA.BILL.1)
        IF NOT (R.AA.BILL.1) THEN
            CALL F.READ (FN.AA.BILL.HST,Y.BILL.ID,R.AA.BILL.1,F.AA.BILL.HST,ERROR.AA.BILL.1)
        END
*Y.FIN.AMT = Y.FIN.AMT + SUM(R.AA.BILL.1<AA.BD.OS.PROP.AMOUNT>)
*retorna el valor del campo : OR.TOTAL.AMOUNT para que muestre valor de la ultima cuota
        Y.FIN.AMT = Y.FIN.AMT + SUM(R.AA.BILL.1<AA.BD.OR.TOTAL.AMOUNT>)
        RETURN
    REPEAT
RETURN

GET.PENULTIMA.BILL:
    SEL.CMD = ''; SEL.LIST = ''; NO.OF.RECS = ''; RET.CODE = '';
    SEL.CMD = "SELECT ":FN.AA.BILL:" WITH ARRANGEMENT.ID EQ ":Y.AA.ID:" AND BILL.TYPE NE 'PAYOFF' BY-DSND PAYMENT.DATE"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,RET.CODE)
    IF NO.OF.RECS EQ 0 THEN
        SEL.CMD = ''; SEL.LIST = ''; NO.OF.RECS = ''; RET.CODE = '';
        SEL.CMD = "SELECT ":FN.AA.BILL.HST:" WITH ARRANGEMENT.ID EQ ":Y.AA.ID:" AND BILL.TYPE NE 'PAYOFF' BY-DSND PAYMENT.DATE"
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,RET.CODE)
    END

    LOOP
        REMOVE Y.BILL.ID FROM SEL.LIST SETTING BIL.POST1
    WHILE  Y.BILL.ID  DO

        CALL F.READ (FN.AA.BILL,Y.BILL.ID,R.AA.BILL.1,F.AA.BILL,ERROR.AA.BILL.1)
        IF NOT (R.AA.BILL.1) THEN
            CALL F.READ (FN.AA.BILL.HST,Y.BILL.ID,R.AA.BILL.1,F.AA.BILL.HST,ERROR.AA.BILL.1)
        END
        Y.FIN.AMT = Y.FIN.AMT + SUM(R.AA.BILL.1<AA.BD.OR.TOTAL.AMOUNT>)
        RETURN
    REPEAT
RETURN


READ.FROM.ACCOUNT:
    Y.ERROR  = @FALSE
    R.AA = ''; Y.ERR = ''; R.REDO.LOG = '' ; Y.LINKED.APP.ID = ''
    CALL F.READ(FN.AA,Y.AA.ID,R.AA,F.AA,Y.ERR)
    Y.LINKED.APP.ID = R.AA<AA.ARR.LINKED.APPL.ID,1>
    CALL F.READ(FN.ACCOUNT,Y.LINKED.APP.ID,R.ACCOUNT,F.ACCOUNT,Y.ACC.ERR)
    IF NOT(R.ACCOUNT) THEN
        YACC.HID = Y.LINKED.APP.ID
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HST,YACC.HID,R.ACCOUNT,ERR.ACCOUNT)
    END

    GOSUB GET.ALT.ID

RETURN


GET.ALT.ID:
    ID.ALTENO = '' ; Y.ALT.ACCT.ID = '' ; Y.ALT.TYPE = ''
    Y.ALT.TYPE = R.ACCOUNT<AC.ALT.ACCT.TYPE>
    ID.ALTENO  = R.ACCOUNT<AC.ALT.ACCT.ID>
    LOCATE R.ACCOUNT<AC.CATEGORY> IN Y.CATEGORIA.WOF<1,1> SETTING C.WOF.POS THEN
        CHANGE @VM TO @FM IN Y.ALT.TYPE
        CHANGE @SM TO @FM IN Y.ALT.TYPE
        CHANGE @VM TO @FM IN ID.ALTENO
        CHANGE @SM TO @FM IN ID.ALTENO

        Y.CNT.TYPE = DCOUNT(Y.ALT.TYPE,@FM)

        FOR I.VAR = 1 TO Y.CNT.TYPE
            ID.TYPE.ACTUAL = Y.ALT.TYPE<I.VAR>[1,7]

            IF ID.TYPE.ACTUAL NE 'ALTERNO' THEN
                CONTINUE
            END
            Y.ALT.ACCT.ID = ID.ALTENO<I.VAR>[3,LEN(ID.ALTENO)]

            CALL F.READ(FN.ACCOUNT,Y.ALT.ACCT.ID,R.ACCOUNT.1,F.ACCOUNT,Y.ACC.ERR.1)
            IF NOT(R.ACCOUNT.1) THEN
                YACC.HID.HIST  = Y.ALT.ACCT.ID
                Y.ALT.ACCT.ID =YACC.HID.HIST:";1"
                CALL F.READ(FN.ACCOUNT.HST,Y.ALT.ACCT.ID,R.ACCOUNT.1,F.ACCOUNT.HST,Y.ACC.ERR.1)
            END
            Y.LEGACY.ARR =  R.ACCOUNT.1<AC.ARRANGEMENT.ID>
            Y.TOTAL.CUOTAS.1 = 0 ;  Y.LASTPAY.AMT.1 = 0

            APAP.LAPAP.redoBBcrReportGenExt(Y.LEGACY.ARR,Y.TOTAL.CUOTAS.1,Y.LASTPAY.AMT,Y.LASTPAY.DAT, Y.MNTPAY,Y.PRODUCTO.GRUPO);*MANUAL R22 CODE CONVERSION

            IF Y.LASTPAY.AMT NE '' AND Y.LASTPAY.DAT NE '' THEN
                RETURN
            END
            GOSUB GET.PAGOS.FROM.AAA
            IF Y.LASTPAY.AMT NE '' AND Y.LASTPAY.DAT NE '' THEN
                RETURN
            END

        NEXT I.VAR


    END


RETURN

GET.PAGOS.FROM.AAA:
    Y.ACTIVIDADES = ''
    Y.ACTIVIDADES = ' LENDING-APPLYPAYMENT-RP.COM.SG.ADV':" ":'LENDING-APPLYPAYMENT-RP.COM.SG.ADV.CHQ'
    Y.ACTIVIDADES:= " ":'LENDING-APPLYPAYMENT-RP.CAP.INT.PYT':" ":'LENDING-APPLYPAYMENT-RP.DIR.DEBIT'
    Y.ACTIVIDADES:= " ":'LENDING-APPLYPAYMENT-RP.COM.SG.ADV.OL':" ":'LENDING-APPLYPAYMENT-RP.COM.SG.ADV.BL'
    Y.ACTIVIDADES:= " ":'LENDING-APPLYPAYMENT-RP.PAYMENT':" ":'LENDING-APPLYPAYMENT-RP.PAYOFF.CHQ'
    Y.ACTIVIDADES:= " ":'LENDING-APPLYPAYMENT-RP.PAYOFF':" ":'LENDING-SETTLE-RP.PAGO.ANTICIPADO'
    SEL.CMD.AAA = '' ; SEL.LIST.AAA = '' ; NO.OF.REC.AAA = '' ; RET.CODE.AAA = ''
    SEL.CMD.AAA = "SELECT ":FN.AA.ARRANGEMENT.ACTIVITY:" WITH ARRANGEMENT EQ ":Y.LEGACY.ARR:" AND ACTIVITY EQ ":Y.ACTIVIDADES:" BY-DSND EFFECTIVE.DATE"
    CALL EB.READLIST(SEL.CMD.AAA,SEL.LIST.AAA,'',NO.OF.REC.AAA,RET.CODE.AAA)
    LOOP
        REMOVE LEGACY.ID.AAA FROM SEL.LIST.AAA SETTING AAA.POS
    WHILE LEGACY.ID.AAA DO
        CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,LEGACY.ID.AAA,R.AAA.LEGACY,F.AA.ARRANGEMENT.ACTIVITY,AAA.ERR.LEGACY)
        IF(R.AAA.LEGACY) THEN
            Y.LASTPAY.AMT    = R.AAA.LEGACY<AA.ARR.ACT.ORIG.TXN.AMT>
            Y.LASTPAY.DAT    = R.AAA.LEGACY<AA.ARR.ACT.EFFECTIVE.DATE>
            RETURN
        END
    REPEAT

RETURN
GET.FIND.CANCELADO:
    Y.ESTADO.CANCELADO = '';
    CALL F.READ (FN.AA,Y.AA.ID,R.AA.1,F.AA,ERROR.AA.1)
    IF R.AA.1<AA.ARR.ARR.STATUS> EQ 'CLOSE' OR R.AA.1<AA.ARR.ARR.STATUS>  EQ 'PENDING.CLOSURE' THEN
        Y.ESTADO.CANCELADO = 'YES'
        RETURN
    END
    APAP.LAPAP.lApapReturnBanlaceCancelacion(Y.AA.ID,OUT.RECORD);* R22 Manual conversion
    Y.CAPITAL.PENDIENTE = FIELD(OUT.RECORD,"*",1)

    IF Y.CAPITAL.PENDIENTE EQ 0 THEN
        Y.ESTADO.CANCELADO = 'YES'
    END


RETURN

END
