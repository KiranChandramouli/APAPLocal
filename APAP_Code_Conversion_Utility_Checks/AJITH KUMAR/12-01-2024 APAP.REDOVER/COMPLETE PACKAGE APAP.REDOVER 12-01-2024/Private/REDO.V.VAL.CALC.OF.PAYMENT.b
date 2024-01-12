* @ValidationCode : MjozNTczNDU5OTY6Q3AxMjUyOjE3MDI5OTEwODgyNjk6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 18:34:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.CALC.OF.PAYMENT
*------------------------------------------------------------------------------------------------------------------
* Developer    : NAVEENKUMAR.N
* Date         : 25.05.2010
* Description  : REDO.V.VAL.CALC.OF.PAYMENT is a validation routine for the version FUNDS.TRANSFER,REDO.ACTR
*
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : --N/A--
* Out : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : --N/A--
* Called By : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
*
*------------------------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,F.READ TO CACHE.READ
*13-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-----------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.TAX
    $INSERT I_F.REDO.T.AUTH.ARRANGEMENT
    $USING AA.PaymentSchedule

    GOSUB INIT
    GOSUB MULTI.GET
    GOSUB PROCESS
RETURN
***
INIT:
***

    Y.TOTAL.DUE = ''
    Y.TOTAL.OUT = ''
    FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER"
    F.FUNDS.TRANSFER = ""
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
*
    FN.REDO.T.AUTH.ARRANGEMENT = "F.REDO.T.AUTH.ARRANGEMENT"
    F.REDO.T.AUTH.ARRANGEMENT = ""
    CALL OPF(FN.REDO.T.AUTH.ARRANGEMENT,F.REDO.T.AUTH.ARRANGEMENT)
*
    FN.FT.TXN.TYPE.CONDITION = "F.FT.TXN.TYPE.CONDITION"
    F.FT.TXN.TYPE.CONDITION = ""
    R.FT.TXN.TYPE.CONDITION = ""
    E.FT.TXN.TYPE.CONDITION = ""
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)
*
    FN.FT.COMMISSION.TYPE = "F.FT.COMMISSION.TYPE"
    F.FT.COMMISSION.TYPE = ""
    R.FT.COMMISSION.TYPE = ""
    E.FT.COMMISSION.TYPE = ""
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
*
    FN.TAX = "F.TAX"
    F.TAX = ""
    R.TAX = ""
    E.TAX = ""
    CALL OPF(FN.TAX,F.TAX)
*
    Y.PAYMENT.DATE = ""
    TOT.PER.AMT = ""
    TOT.TAX = ""
RETURN

*******
PROCESS:
*******



    INS.CMP = R.NEW(FT.LOCAL.REF)<1,INS.CMP.POS>
    INS.POL.TYPE = R.NEW(FT.LOCAL.REF)<1,INS.POL.TYPE.POS>
    CLOSE.BAL.DATE = R.NEW(FT.LOCAL.REF)<1,CLOSE.BAL.DATE.POS>

    NO.OF.REC = ""
    RET.CODE = ""

*  SEL.CMD = "SELECT ":"F.REDO.T.AUTH.ARRANGEMENT":" WITH INS.COMPANY EQ :"INS.CMP": AND INS.POLICY.TYPE EQ ":"INS.POL.TYPE"

    SEL.CMD ='SELECT ':FN.REDO.T.AUTH.ARRANGEMENT:' WITH INS.COMPANY EQ ':INS.CMP:' AND INS.POLICY.TYPE EQ ':INS.POL.TYPE

    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.REC,RET.CODE)

    GOSUB AA.SCHEDULES

    R.NEW(FT.LOCAL.REF)<1,TOT.CHG.VALUE.POS> = Y.TOTAL.DUE

    IF INS.POL.TYPE EQ "FHA" THEN
        R.NEW(FT.LOCAL.REF)<1,TOT.OUTST.BAL.POS> = Y.TOTAL.OUT
    END

    GOSUB FT.TXN.TYPE
    GOSUB FT.COMM.TYPE


    TOT.CHG.VAL =  R.NEW(FT.LOCAL.REF)<1,TOT.CHG.VALUE.POS>
    NET.VAL.POS = TOT.CHG.VAL/(TOT.TAX/100)
    R.NEW(FT.LOCAL.REF)<1,POLICY.NET.VAL.POS> = NET.VAL.POS

    COM.VAL.POS = R.NEW(FT.LOCAL.REF)<1,POLICY.NET.VAL.POS>*TOT.PER.AMT
    R.NEW(FT.LOCAL.REF)<1,COMMISON.VAL.POS> = COM.VAL.POS


    ITBIS.VAL = R.NEW(FT.LOCAL.REF)<1,COMMISON.VAL.POS>*R.NEW(FT.LOCAL.REF)<1,COMM.PERCENT.POS>
    R.NEW(FT.LOCAL.REF)<1,ITBIS.COM.VAL.POS> = ITBIS.VAL



*  TOT.CHG.VAL = R.NEW(FT.LOCAL.REF)<1,TOT.CHG.VALUE.POS>-R.NEW(FT.LOCAL.REF)<1,COMMISON.VAL.POS>-R.NEW(FT.LOCAL.REF)<ITBIS.COM.VAL.POS>

    TOT.CHG.VAL =  R.NEW(FT.LOCAL.REF)<1,TOT.CHG.VALUE.POS>
    COMM.VAL  = R.NEW(FT.LOCAL.REF)<1,COMMISON.VAL.POS>
    ITBIS.COM.VAL = R.NEW(FT.LOCAL.REF)<1,ITBIS.COM.VAL.POS>

    PAY.VAL = TOT.CHG.VAL - (COMM.VAL - ITBIS.COM.VAL)

    R.NEW(FT.LOCAL.REF)<1,PAYMENT.VALUE.POS> = PAY.VAL

    IF PAY.VAL LT 0 THEN
        PAY.VAL = -1 * PAY.VAL
    END

    R.NEW(FT.CREDIT.AMOUNT) = PAY.VAL

RETURN

*******
MULTI.GET:
*******

    FIELD.NAME = "INS.COMPANY":@VM:"INS.POLICY.TYPE":@VM:"CLOSE.BAL.DATE":@VM:"TOT.CHG.VALUE":@VM:"TOT.OUTST.BAL":@VM:"POLICY.NET.VAL":@VM:"ITBIS.COM.VAL":@VM:"COMM.PERCENT":@VM:"PAYMENT.VALUE":@VM:"COMMISON.VAL"
    FIELD.POS = ""
    CALL MULTI.GET.LOC.REF('FUNDS.TRANSFER',FIELD.NAME,FIELD.POS)

    INS.CMP.POS = FIELD.POS<1,1>
    INS.POL.TYPE.POS = FIELD.POS<1,2>
    CLOSE.BAL.DATE.POS = FIELD.POS<1,3>
    TOT.CHG.VALUE.POS = FIELD.POS<1,4>
    TOT.OUTST.BAL.POS = FIELD.POS<1,5>
    POLICY.NET.VAL.POS = FIELD.POS<1,6>
    ITBIS.COM.VAL.POS = FIELD.POS<1,7>
    COMM.PERCENT.POS = FIELD.POS<1,8>
    PAYMENT.VALUE.POS = FIELD.POS<1,9>
    COMMISON.VAL.POS = FIELD.POS<1,10>
RETURN
*******

*****
AA.SCHEDULES:
*****

    LOOP
        REMOVE ARR.ID FROM SEL.LIST SETTING ARR.ID.POS
    WHILE ARR.ID:ARR.ID.POS

* CALL AA.SCHEDULE.PROJECTOR(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS,DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
        AA.PaymentSchedule.ScheduleProjector(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS,DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
        GOSUB AA.SCHEDULE.LOOP
    REPEAT
RETURN
*****

****
AA.SCHEDULE.LOOP:

    Y.NO.OF.DATE = DCOUNT(DUE.DATES,@FM)
    VAR1=1
    LOOP
    WHILE VAR1 LE Y.NO.OF.DATE
        Y.PAYMENT.DATE = DUE.DATES<VAR1>
        IF Y.PAYMENT.DATE LE CLOSE.BAL.DATE THEN
            Y.TOTAL.DUE += TOT.PAYMENT<VAR1>
            Y.TOTAL.OUT += DUE.OUTS<VAR1>
        END
        VAR1 += 1
    REPEAT
RETURN
****

*****
FT.TXN.TYPE:

    TRAN.TYPE = R.NEW(FT.TRANSACTION.TYPE)
    CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION, TRAN.TYPE, R.FT.TXN.TYPE.CONDITION, E.FT.TXN.TYPE.CONDITION)   ;*R22 AUTO CODE CONVERSION
    COMM.TYPES = R.FT.TXN.TYPE.CONDITION<FT6.COMM.TYPES>
    TOT.COMM.TYPE = DCOUNT(COMM.TYPES,@FM)
RETURN
*****

******
FT.COMM.TYPE:

    CNT = 1
    LOOP
    WHILE CNT LE TOT.COMM.TYPE
        FT.COMM.ID = COMM.TYPES<1,CNT>
        CALL CACHE.READ(FN.FT.COMMISSION.TYPE, FT.COMM.ID, R.FT.COMMISSION.TYPE, E.FT.COMMISSION.TYPE)     ;*R22 AUTO CODE CONVERSION
        TOT.PER.AMT += R.FT.COMMISSION.TYPE<FT4.PERCENTAGE>
        TAX.ID = R.FT.COMMISSION.TYPE<FT4.TAX.CODE>
        SEL.CMD = "SELECT ":FN.TAX:" WITH @ID LIKE ":TAX.ID:"..."
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)
        TAX.ID = SEL.LIST<NOR>
        CALL CACHE.READ(FN.TAX, TAX.ID, R.TAX, E.TAX)     ;*R22 AUTO CODE CONVERSION
        TOT.TAX += R.TAX<EB.TAX.RATE>
        CNT += 1
    REPEAT
RETURN
*****
END
