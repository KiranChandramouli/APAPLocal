<<<<<<< Updated upstream
<<<<<<< Updated upstream
* @ValidationCode : MjoxMzUwNzY2MDQ0OkNwMTI1MjoxNjkwMjY0MzU3MDkxOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:22:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
=======
=======
>>>>>>> Stashed changes
* @ValidationCode : MjoxNTEyMDc2MTc5OkNwMTI1MjoxNjg0ODU0MzgyNTMzOklUU1M6LTE6LTE6ODkwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 890
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.COL.FF.EXT.LAST.PAY(Y.AA.ID,Y.TOTAL.CUOTAS,Y.LASTPAY.AMT, Y.LASTPAY.DAT,Y.NEXT.PAY.AMT,Y.NEXT.PAY.DATE,Y.AL.PAID.BILLS.CNT)
*-------------------------------------------------------------------------------------
*Modification
<<<<<<< Updated upstream
<<<<<<< Updated upstream
* Date                   who                   Reference
=======
* Date                   who                   Reference              
>>>>>>> Stashed changes
=======
* Date                   who                   Reference              
>>>>>>> Stashed changes
* 18-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND SM TO @SM AND ++ TO += 1 AND -- TO -= 1
* 18-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.REFERENCE.DETAILS
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_REDO.COL.CUSTOMER.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    $USING APAP.TAM
=======

>>>>>>> Stashed changes
=======

>>>>>>> Stashed changes


    GOSUB INITIALISE
    GOSUB EXTRACT
RETURN

INITIALISE:

    FN.AA.BILL.HST="F.AA.BILL.DETAILS.HIST"
    F.AA.BILL.HST =''
    CALL OPF(FN.AA.BILL.HST,F.AA.BILL.HST)

    FN.AA.DETAILS.HST="F.AA.ACCOUNT.DETAILS.HIST"
    F.AA.DETAILS.HST=''
    CALL OPF(FN.AA.DETAILS.HST,F.AA.DETAILS.HST)

    Y.AL.PAID.BILLS.CNT=''
    EFF.DATE    = ''
    PROP.CLASS  = 'PAYMENT.SCHEDULE'
    PROPERTY    = ''
    R.CONDITION = ''
    ERR.MSG     = ''
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*   CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
    APAP.TAM.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG);*R22 Manual Code Comnversion
=======
    CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
>>>>>>> Stashed changes
=======
    CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
>>>>>>> Stashed changes

    Y.TOTAL.CUOTAS = ''
    Y.LASTPAY.AMT  = ''
    Y.LASTPAY.DAT  = ''
RETURN

EXTRACT:
    GOSUB EXTRACT.NUM.CUOTAS
    GOSUB GET.HISTORY.PAYMENT
RETURN

EXTRACT.NUM.CUOTAS:

    CALL F.READ(FN.AA.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.DETAILS,ACT.ERR)
    CALL F.READ(FN.REDO.AA.SCHEDULE,Y.AA.ID,R.REDO.AA.SCHEDULE,F.REDO.AA.SCHEDULE,SCH.ERR)
    Y.TOTAL.CUOTAS = DCOUNT(R.REDO.AA.SCHEDULE<2>,@VM) + Y.AL.PAID.BILLS.CNT

    Y.FIN.AMT       = ''
    Y.NEXT.PAYAMT   = ''
    Y.LAST.PAYAMT   = ''
    Y.FIN.AMT       = ''
    Y.OTHER.AMT     = ''
    Y.OTHER.DATE    = ''
    Y.LAST.PAY.DATE = ''

    ACCOUNT.PROPERTY = ''
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*   CALL REDO.GET.PROPERTY.NAME(Y.AA.ID,'ACCOUNT',R.OUT.AA.RECORD,ACCOUNT.PROPERTY,OUT.ERR)
    APAP.TAM.redoGetPropertyName(Y.AA.ID,'ACCOUNT',R.OUT.AA.RECORD,ACCOUNT.PROPERTY,OUT.ERR) ;*R22 Manual Code Conversion
=======
    CALL REDO.GET.PROPERTY.NAME(Y.AA.ID,'ACCOUNT',R.OUT.AA.RECORD,ACCOUNT.PROPERTY,OUT.ERR)
>>>>>>> Stashed changes
=======
    CALL REDO.GET.PROPERTY.NAME(Y.AA.ID,'ACCOUNT',R.OUT.AA.RECORD,ACCOUNT.PROPERTY,OUT.ERR)
>>>>>>> Stashed changes
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

                Y.NEXT.PAY.AMT=Y.DUE.AMTS<Y.VAR1>
                Y.NEXT.PAY.DATE= Y.DATE
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
EXTRACT.NUM.CUOTAS.PART:

    IF Y.NEXT.PAYAMT THEN
        Y.FIN.AMT = Y.NEXT.PAYAMT
        LOCATE Y.DATE IN R.AA.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE,1> SETTING BILL.POS THEN
            Y.BILL.IDS   = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,BILL.POS>
            Y.BILL.TYPES = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,BILL.POS>
            CHANGE @SM TO @FM IN Y.BILL.IDS
            CHANGE @SM TO @FM IN Y.BILL.TYPES
            GOSUB REMOVE.PAYOFF.BILLS
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*          CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
            APAP.TAM.redoGetBillActualAmt(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE) ;*R22 Manual Code Conversion
=======
            CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
>>>>>>> Stashed changes
=======
            CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
>>>>>>> Stashed changes
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
                GOSUB REMOVE.PAYOFF.BILLS
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*              CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
                APAP.TAM.redoGetBillActualAmt(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE) ;*R22 Manual Code Conversion
=======
                CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
>>>>>>> Stashed changes
=======
                CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
>>>>>>> Stashed changes
                Y.FIN.AMT = SUM(R.ARRAY<4>)
            END ELSE
                GOSUB READ.AA.DET.HIST
                LOCATE Y.LAST.PAY.DATE IN R.AA.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE,1> SETTING BILL.POSN THEN
                    Y.BILL.IDS   = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,BILL.POS>
                    Y.BILL.TYPES = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,BILL.POS>
                    CHANGE @SM TO @FM IN Y.BILL.IDS
                    CHANGE @SM TO @FM IN Y.BILL.TYPES
                    GOSUB REMOVE.PAYOFF.BILLS     ;* No need to sum the amount of payoff bill
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*                 CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
                    APAP.TAM.redoGetBillActualAmt(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE) ;*R22 Manual Code Conversion
=======
                    CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
>>>>>>> Stashed changes
=======
                    CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
>>>>>>> Stashed changes
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
                GOSUB REMOVE.PAYOFF.BILLS
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*              CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
                APAP.TAM.redoGetBillActualAmt(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE) ;* R22 Manual Code Conversion
=======
                CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
>>>>>>> Stashed changes
=======
                CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
>>>>>>> Stashed changes
                Y.FIN.AMT = SUM(R.ARRAY<4>)
            END ELSE
                GOSUB READ.AA.DET.HIST
                LOCATE Y.OTHER.DATE IN R.AA.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE,1> SETTING BILL.POSN THEN
                    Y.BILL.IDS   = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,BILL.POS>
                    Y.BILL.TYPES = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,BILL.POS>
                    CHANGE @SM TO @FM IN Y.BILL.IDS
                    CHANGE @SM TO @FM IN Y.BILL.TYPES
                    GOSUB REMOVE.PAYOFF.BILLS     ;* No need to sum the amount of payoff bill
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*                  CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
                    APAP.TAM.redoGetBillActualAmt(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE) ;*R22 Manual Code Conversion
=======
                    CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
>>>>>>> Stashed changes
=======
                    CALL REDO.GET.BILL.ACTUAL.AMT(Y.BILL.IDS,R.ARRAY,Y.FUTURE.USE)
>>>>>>> Stashed changes
                    Y.FIN.AMT = SUM(R.ARRAY<4>)
                END
            END
        END
    END
RETURN

GET.HISTORY.PAYMENT:

    CALL F.READ(FN.AA.REFERENCE.DETAILS,Y.AA.ID,R.AA.TXN.DET,F.AA.REFERENCE.DETAILS,TXN.REF.ERR)
    IF R.AA.TXN.DET THEN
        Y.ACTIVITY.CNT = DCOUNT(R.AA.TXN.DET<AA.REF.TRANS.REF>,@VM)
        YACTIVITY.CNT = Y.ACTIVITY.CNT
        Y.VAR1 = 1
        LOOP
        WHILE Y.VAR1 LE Y.ACTIVITY.CNT
            Y.AAA.ID = R.AA.TXN.DET<AA.REF.AAA.ID,YACTIVITY.CNT>
            Y.LASTPAY.AMT.TP = ''; Y.LASTPAY.DAT.TP = ''; Y.ACT.CLASS = ''
            CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.AAA.ID,R.AAA,F.AA.ARRANGEMENT.ACTIVITY,AAA.ERR)
            Y.ACT.CLASS = R.AAA<AA.ARR.ACT.ACTIVITY.CLASS>
            Y.LASTPAY.AMT.TP = R.AAA<AA.ARR.ACT.ORIG.TXN.AMT>
            Y.LASTPAY.DAT.TP = R.AAA<AA.ARR.ACT.EFFECTIVE.DATE>
            IF Y.ACT.CLASS NE 'LENDING-DISBURSE-TERM.AMOUNT' AND Y.ACT.CLASS NE '' AND R.AAA<AA.ARR.ACT.EFFECTIVE.DATE> LE TODAY THEN
                IF Y.LASTPAY.DAT AND Y.LASTPAY.DAT.TP NE Y.LASTPAY.DAT THEN
                    Y.VAR1 = Y.ACTIVITY.CNT
                END ELSE
                    Y.LASTPAY.DAT = Y.LASTPAY.DAT.TP
                    Y.LASTPAY.AMT += Y.LASTPAY.AMT.TP
                END
            END
            Y.VAR1 += 1
            YACTIVITY.CNT -= 1
        REPEAT
    END
RETURN

REMOVE.PAYOFF.BILLS:

    LOCATE 'PAYOFF' IN Y.BILL.TYPES<1> SETTING POS.PAYOFF THEN
        DEL Y.BILL.IDS<POS.PAYOFF>
    END

RETURN

READ.AA.DET.HIST:
*****************
    R.AA.ACCOUNT.DETAILS = ''; ACT.ERR = ''
    CALL F.READ(FN.AA.DETAILS.HST,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.DETAILS.HST,ACT.ERR)
RETURN

END
