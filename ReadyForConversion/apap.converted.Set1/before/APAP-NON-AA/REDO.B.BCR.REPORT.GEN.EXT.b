*
*-----------------------------------------------------------------------------
* <Rating>38</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.BCR.REPORT.GEN.EXT(Y.AA.ID,Y.TOTAL.CUOTAS,Y.LASTPAY.AMT, Y.LASTPAY.DAT,Y.FIN.AMT )
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
*------------------------------------------------------------------------------------------------------------------

    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_F.AA.ACTIVITY.HISTORY
    $INCLUDE T24.BP I_F.AA.ACCOUNT.DETAILS
    $INCLUDE T24.BP I_F.AA.REFERENCE.DETAILS
    $INCLUDE T24.BP I_F.AA.ARRANGEMENT.ACTIVITY
    $INCLUDE T24.BP I_F.AA.PAYMENT.SCHEDULE
*
    $INSERT TAM.BP I_F.REDO.BCR.REPORT.DATA
    $INSERT TAM.BP I_REDO.B.BCR.REPORT.GEN.COMMON
    $INSERT TAM.BP I_F.REDO.INTERFACE.PARAM


    GOSUB INITIALISE
    GOSUB EXTRACT
    RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    EFF.DATE    = ''
    PROP.CLASS  = 'PAYMENT.SCHEDULE'
    PROPERTY    = ''
    R.CONDITION = ''
    ERR.MSG     = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
    Y.PAID.BILLS.CNT = R.CONDITION<AA.PS.LOCAL.REF,POS.L.PAID.BILL.CNT>

    Y.TOTAL.CUOTAS = ''
    Y.LASTPAY.AMT  = ''
    Y.LASTPAY.DAT  = ''
    RETURN

*-----------------------------------------------------------------------------
EXTRACT:
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
    Y.TOTAL.CUOTAS = DCOUNT(R.REDO.AA.SCHEDULE<2>,VM) + Y.PAID.BILLS.CNT

    Y.FIN.AMT       = ''
    Y.NEXT.PAYAMT   = ''
    Y.LAST.PAYAMT   = ''
    Y.FIN.AMT       = ''
    Y.OTHER.AMT     = ''
    Y.OTHER.DATE    = ''
    Y.LAST.PAY.DATE = ''

    ACCOUNT.PROPERTY = ''
    CALL REDO.GET.PROPERTY.NAME(Y.AA.ID,'ACCOUNT',R.OUT.AA.RECORD,ACCOUNT.PROPERTY,OUT.ERR)
    Y.PAYMENT.DATES     = RAISE(R.REDO.AA.SCHEDULE<2>)
    Y.PROPERTY          = RAISE(R.REDO.AA.SCHEDULE<6>)
    Y.DUE.AMTS          = RAISE(R.REDO.AA.SCHEDULE<1>)
    Y.PAYMENT.DATES.CNT = DCOUNT(Y.PAYMENT.DATES,FM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.PAYMENT.DATES.CNT
        Y.PROP.LIST = Y.PROPERTY<Y.VAR1>
        Y.DATE      = Y.PAYMENT.DATES<Y.VAR1>
        IF Y.DATE GE TODAY THEN
            FINDSTR ACCOUNT.PROPERTY IN Y.PROP.LIST SETTING POS.AF,POS.AV THEN
                Y.NEXT.PAYAMT = Y.DUE.AMTS<Y.VAR1>
                IF Y.NEXT.PAYAMT THEN
                    Y.VAR1 = Y.PAYMENT.DATES.CNT + 1        ;* Break
                END
            END ELSE
                Y.OTHER.AMT  = Y.DUE.AMTS<Y.VAR1>
                Y.OTHER.DATE = Y.DATE
            END
        END ELSE
            FINDSTR ACCOUNT.PROPERTY IN Y.PROP.LIST SETTING POS.AF,POS.AV THEN
                Y.LAST.PAYAMT   = Y.DUE.AMTS<Y.VAR1>
                Y.LAST.PAY.DATE = Y.DATE
            END ELSE
                Y.OTHER.AMT = Y.DUE.AMTS<Y.VAR1>
                Y.OTHER.DATE = Y.DATE
            END
        END

        Y.VAR1++
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
            CHANGE SM TO FM IN Y.BILL.IDS
            CHANGE SM TO FM IN Y.BILL.TYPES
            GOSUB REMOVE.PAYOFF.BILLS   ;* No need to sum the amount of payoff bill
            CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
            Y.FIN.AMT = SUM(R.ARRAY<4>)
        END
    END ELSE
        IF Y.LAST.PAYAMT THEN
            Y.FIN.AMT = Y.LAST.PAYAMT
            LOCATE Y.LAST.PAY.DATE IN R.AA.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE,1> SETTING BILL.POS THEN
                Y.BILL.IDS   = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,BILL.POS>
                Y.BILL.TYPES = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,BILL.POS>
                CHANGE SM TO FM IN Y.BILL.IDS
                CHANGE SM TO FM IN Y.BILL.TYPES
                GOSUB REMOVE.PAYOFF.BILLS         ;* No need to sum the amount of payoff bill
                CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
                Y.FIN.AMT = SUM(R.ARRAY<4>)
            END
        END ELSE
            Y.FIN.AMT = Y.OTHER.AMT
            LOCATE Y.OTHER.DATE IN R.AA.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE,1> SETTING BILL.POS THEN
                Y.BILL.IDS   = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,BILL.POS>
                Y.BILL.TYPES = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,BILL.POS>
                CHANGE SM TO FM IN Y.BILL.IDS
                CHANGE SM TO FM IN Y.BILL.TYPES
                GOSUB REMOVE.PAYOFF.BILLS         ;* No need to sum the amount of payoff bill
                CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
                Y.FIN.AMT = SUM(R.ARRAY<4>)
            END
        END
    END
    RETURN
*-----------------------------------------------------------------------------
GET.HISTORY.PAYMENT:
*-----------------------------------------------------------------------------

    CALL F.READ(FN.AA.REFERENCE.DETAILS,Y.AA.ID,R.AA.TXN.DET,F.AA.REFERENCE.DETAILS,TXN.REF.ERR)
    IF R.AA.TXN.DET THEN
        Y.ACTIVITY.CNT = DCOUNT(R.AA.TXN.DET<AA.REF.TRANS.REF>,VM)
        Y.VAR1 = 1
        LOOP
        WHILE Y.VAR1 LE Y.ACTIVITY.CNT
            Y.AAA.ID = R.AA.TXN.DET<AA.REF.AAA.ID,Y.VAR1>
            CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.AAA.ID,R.AAA,F.AA.ARRANGEMENT.ACTIVITY,AAA.ERR)
            Y.ACT.CLASS = R.AAA<AA.ARR.ACT.ACTIVITY.CLASS>
            IF Y.ACT.CLASS NE 'LENDING-DISBURSE-TERM.AMOUNT' AND Y.ACT.CLASS NE '' THEN
                IF R.AAA<AA.ARR.ACT.EFFECTIVE.DATE> LE TODAY THEN
                    Y.FINAL.AAA.ID = Y.AAA.ID
                END
            END
            Y.VAR1++
        REPEAT
    END
    IF Y.FINAL.AAA.ID ELSE
        RETURN
    END

    CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.FINAL.AAA.ID,R.AAA,F.AA.ARRANGEMENT.ACTIVITY,AAA.ERR)

    Y.LASTPAY.AMT    = R.AAA<AA.ARR.ACT.ORIG.TXN.AMT>
    Y.LASTPAY.DAT    = R.AAA<AA.ARR.ACT.EFFECTIVE.DATE>

*Y.CHILD.ACTIVITY = R.AAA<AA.ARR.ACT.CHILD.ACTIVITY>
*IF Y.CHILD.ACTIVITY THEN
*Y.LOOP.BRK = 1
*LOOP
*WHILE Y.LOOP.BRK
*CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.CHILD.ACTIVITY,R.AAA,F.AA.ARRANGEMENT.ACTIVITY,AAA.ERR)
*Y.LASTPAY.AMT    += R.AAA<AA.ARR.ACT.TXN.AMOUNT>
*Y.CHILD.ACTIVITY = R.AAA<AA.ARR.ACT.CHILD.ACTIVITY>
*IF Y.CHILD.ACTIVITY ELSE
*Y.LOOP.BRK = 0
*END
*REPEAT
*END


    RETURN
*-----------------------------------------------------------------------------
REMOVE.PAYOFF.BILLS:
*-----------------------------------------------------------------------------

    LOCATE 'PAYOFF' IN Y.BILL.TYPES<1> SETTING POS.PAYOFF THEN
        DEL Y.BILL.IDS<POS.PAYOFF>
    END

    RETURN
*-----------------------------------------------------------------------------
END
