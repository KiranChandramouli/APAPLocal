* @ValidationCode : MjoxNTMwODQ3NzA0OkNwMTI1MjoxNzAyOTkwOTAyNzA0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 18:31:42
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
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.LOAN.INSR.PROP.REP(Y.FIN.ARR)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-APR-2023     Conversion tool    R22 Auto conversion        VM to @VM, SM to @SM
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*18-12-2023         VIGNESHWARI            R22 Manual Conversion - CALL RTN MODIFIED
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.AA.ARRANGEMENT
  *  $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.OVERDUE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
   * $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.EB.LOOKUP
    $USING AA.PaymentSchedule

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    FN.INSURANCE = 'F.APAP.H.INSURANCE.DETAILS'
    F.INSURANCE = ''
    CALL OPF(FN.INSURANCE,F.INSURANCE)

    FN.AA = 'F.AA.ARRANGEMENT'
    F.AA = ''
    CALL OPF(FN.AA,F.AA)

    FN.BILL = 'F.AA.BILL.DETAILS'
    F.BILL = ''
    CALL OPF(FN.BILL,F.BILL)

    FN.AA.PRD.PR = 'F.AA.PRD.DES.PAYMENT.RULES'
    F.AA.PRD.PR = ''
    CALL OPF(FN.AA.PRD.PR,F.AA.PRD.PR)

    FN.REDO.POLIZA.CARGOS = 'F.REDO.POLIZA.CARGOS'
    F.REDO.POLIZA.CARGOS = ''
    CALL OPF(FN.REDO.POLIZA.CARGOS,F.REDO.POLIZA.CARGOS)

    FN.AC = 'F.ACCOUNT'
    F.AC = ''
    CALL OPF(FN.AC,F.AC)

    FN.AC.HIS = 'F.ACCOUNT$HIS'
    F.AC.HIS = ''
    CALL OPF(FN.AC.HIS,F.AC.HIS)

    FN.AA.AC = 'F.AA.ACCOUNT.DETAILS'
    F.AA.AC = ''
    CALL OPF(FN.AA.AC,F.AA.AC)

    SEL.CMD = 'SELECT ':FN.INSURANCE

    Y.APL = 'AA.PRD.DES.OVERDUE'
    Y.FLDS = 'L.LOAN.STATUS.1'
    CALL MULTI.GET.LOC.REF(Y.APL,Y.FLDS,POS.LOC)
    Y.LN.ST = POS.LOC<1,1>

    GOSUB SEL.PROMPT
    GOSUB PROCESS

RETURN

SEL.PROMPT:


    LOCATE 'POL.COM.TYPE' IN D.FIELDS SETTING POS.C THEN
        Y.SET.COM = 'Y'
        Y.COMP.VAL = D.RANGE.AND.VALUE<POS.C>
        BEGIN CASE
            CASE Y.COMP.VAL EQ 'PRIMA.POR.PAGAR'
                SEL.CMD := ' WITH MANAGEMENT.TYPE EQ "NO INCLUIR EN CUOTA"'
            CASE Y.COMP.VAL EQ 'PRIMA.POR.COBRA'
                SEL.CMD := ' WITH MANAGEMENT.TYPE EQ "INCLUIR EN CUOTA"'
        END CASE

    END

    LOCATE 'POL.TYPE' IN D.FIELDS SETTING POS.P THEN
        Y.VAL.PT = D.RANGE.AND.VALUE<POS.P>
        Y.SET.PT = 'Y'
        IF Y.SET.COM EQ 'Y' THEN
            SEL.CMD := ' AND INS.POLICY.TYPE EQ ':Y.VAL.PT
        END ELSE
            SEL.CMD := ' WITH INS.POLICY.TYPE EQ ':Y.VAL.PT
        END
    END

    LOCATE 'TRANS.DATE' IN D.FIELDS SETTING POS.T THEN
        Y.VAL.DATES = D.RANGE.AND.VALUE<POS.T>
        Y.VAL.D1 = FIELD(Y.VAL.DATES,@SM,1) ; Y.VAL.D2 = FIELD(Y.VAL.DATES,@SM,2)
        IF Y.SET.PT EQ '' AND Y.SET.COM EQ '' THEN
            SEL.CMD := ' WITH POL.START.DATE GE ':Y.VAL.D1:' AND POL.START.DATE LE ':Y.VAL.D2
        END ELSE
            SEL.CMD := ' AND POL.START.DATE GE ':Y.VAL.D1:' AND POL.START.DATE LE ':Y.VAL.D2
        END
        Y.SET.D = 'Y'
    END

    LOCATE 'POL.NUM' IN D.FIELDS SETTING POS.N THEN
        Y.VAL.POL.N = D.RANGE.AND.VALUE<POS.N>
        IF Y.SET.D EQ '' AND Y.SET.PT EQ '' AND Y.SET.COM EQ '' THEN
            SEL.CMD := ' WITH POLICY.NUMBER EQ ':Y.VAL.POL.N
        END ELSE
            SEL.CMD := ' AND POLICY.NUMBER EQ ':Y.VAL.POL.N
        END
    END

    SEL.CMD := ' BY ASSOCIATED.LOAN'

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,REC.ER)


RETURN

PROCESS:


    FLG = '' ; Y.AA.ID.DP = ''
    LOOP
    WHILE NO.OF.REC GT 0 DO
        FLG += 1
        Y.ID = SEL.LIST<FLG>
        CALL F.READ(FN.INSURANCE,Y.ID,R.INSURANCE,F.INSURANCE,INS.ERR)
        Y.AA.ID = R.INSURANCE<INS.DET.ASSOCIATED.LOAN>
* IF Y.AA.ID.DP NE Y.AA.ID THEN
        GOSUB GET.AA.VALUES
*     Y.AA.ID.DP = Y.AA.ID
* END
        GOSUB GET.INS.DETAILS
        GOSUB FIN.ARR
        NO.OF.REC -= 1
    REPEAT

RETURN

GET.AA.VALUES:

    CALL F.READ(FN.AA,Y.AA.ID,R.AA,F.AA,AA.ERR)
    Y.AC.ID = R.AA<AA.ARR.LINKED.APPL.ID>
    Y.PRD = R.AA<AA.ARR.PRODUCT>
    Y.AGENCY = R.AA<AA.ARR.CO.CODE>
    Y.CUR = R.AA<AA.ARR.CURRENCY>
    GOSUB GET.LOAN.ST

    CALL F.READ(FN.AC,Y.AC.ID,R.AC,F.AC,AC.ERR)
    Y.ALT.NO = R.AC<AC.ALT.ACCT.ID>

    IF NOT(R.AC) THEN
        Y.AC.ID.J = Y.AC.ID:';1'
        CALL F.READ(FN.AC.HIS,Y.AC.ID.J,R.AC,F.AC.HIS,HI.ER)
        Y.ALT.NO = R.AC<AC.ALT.ACCT.ID>
    END

RETURN

GET.LOAN.ST:

    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.AA.ID,'OVERDUE','','',RET.PRO,RET.COND,RET.ERR)
    RET.COND = RAISE(RET.COND)
    Y.LOAN.ST = RET.COND<AA.OD.LOCAL.REF,Y.LN.ST>

    Y.EB.ID = 'L.LOAN.STATUS.1*':Y.LOAN.ST
    CALL F.READ(FN.EB.LOOKUP,Y.EB.ID,R.EB.LOOKUP,F.EB.LOOKUP,EB.ERR.U)
    Y.LOAN.ST = R.EB.LOOKUP<EB.LU.DESCRIPTION,2>
    IF Y.LOAN.ST EQ '' THEN
        Y.LOAN.ST = R.EB.LOOKUP<EB.LU.DESCRIPTION,1>
    END

    CALL F.READ(FN.AA.AC,Y.AA.ID,R.AA.AC,F.AA.AC,A.A.ER)
    *Y.LN.AGE.ST = R.AA.AC<AA.AD.ARR.AGE.STATUS>
    Y.LN.AGE.ST = R.AA.AC<AA.PaymentSchedule.AccountDetailsHist.AdArrAgeStatus>

    Y.FIN.LOAN.ST = Y.LOAN.ST:'-':Y.LN.AGE.ST

RETURN

GET.INS.DETAILS:

    Y.POL.TYPE = R.INSURANCE<INS.DET.INS.POLICY.TYPE>
    Y.POL.NUM = R.INSURANCE<INS.DET.POLICY.NUMBER>
    Y.POL.STATUS = R.INSURANCE<INS.DET.POLICY.STATUS>

    GOSUB GET.POL.COMP.TYPE

    Y.TOT.BAL = ''
    GOSUB GET.BALANCE

RETURN

GET.POL.COMP.TYPE:

    Y.MAN.TYPE = R.INSURANCE<INS.DET.MANAGEMENT.TYPE>
    Y.INS.PROP = R.INSURANCE<INS.DET.CHARGE>

    IF Y.MAN.TYPE EQ 'NO INCLUIR EN CUOTA' THEN
        Y.POL.COMP.TYPE = 'Prima por Pagar'
    END ELSE
        Y.POL.COMP.TYPE = 'Prima por Cobrar'
    END


RETURN

GET.BALANCE:

    IF Y.POL.COMP.TYPE EQ 'Prima por Cobrar' THEN
        Y.PREF = 'DUE':@VM:'DE1':@VM:'DE3':@VM:'DEL':@VM:'NAB' ; Y.CNT = DCOUNT(Y.PREF,@VM)
        Y.BAL = Y.INS.PROP
        FLG.H = ''
        LOOP
        WHILE Y.CNT GT 0 DO
            FLG.H += 1
            Y.BAL.TYPE = Y.PREF<1,FLG.H>:Y.BAL
            CALL AA.GET.ECB.BALANCE.AMOUNT(Y.AC.ID, Y.BAL.TYPE, REQUEST.DATE, BALANCE.AMOUNT,RET.ERROR)
            Y.TOT.BAL += ABS(BALANCE.AMOUNT)
            Y.CNT -= 1
        REPEAT

    END ELSE

        ARRANGEMENT.ID = Y.AA.ID ; BILL.TYPE = 'ACT.CHARGE'
* TUS START - AA.GET.BILL - API changes - DEFER.DATES
        DEFER.DATES = ""
 *       CALL AA.GET.BILL(Y.AA.ID, "", "", DEFER.DATES , "", BILL.TYPE, PAYMENT.METHOD, BILL.STATUS, "", "", "", "", Y.BILL.REFERENCE, RET.ERROR)
AA.PaymentSchedule.GetBill(Y.AA.ID, "", "", DEFER.DATES , "", BILL.TYPE, PAYMENT.METHOD, BILL.STATUS, "", "", "", "", Y.BILL.REFERENCE, RET.ERROR);*R22 Manual Conversion - CALL RTN MODIFIED

* TUS END

        IF Y.BILL.REFERENCE THEN
            Y.NCM = DCOUNT(Y.BILL.REFERENCE,@VM)
            GOSUB SEP.BILL
        END ELSE
            Y.SET.INS.CR = 'Y'
        END
    END

RETURN

SEP.BILL:

    FLG.L = '' ; Y.INS.PRO.AMT = ''
    LOOP
    WHILE Y.NCM GT 0 DO
        FLG.L += 1
        Y.BILL.ID = Y.BILL.REFERENCE<1,FLG.L>
        CALL F.READ(FN.BILL,Y.BILL.ID,R.BILL,F.BILL,BL.ER)
 *       Y.PRS = R.BILL<AA.BD.PROPERTY>
         Y.PRS = R.BILL<AA.PaymentSchedule.BillDetailsHist.BdProperty>
        LOCATE Y.INS.PROP IN Y.PRS<1,1> SETTING POS.KO THEN
        *    Y.TOT.BAL = R.BILL<AA.BD.OR.PROP.AMOUNT,POS.KO>
            Y.TOT.BAL = R.BILL<AA.PaymentSchedule.BillDetailsHist.BdOrPropAmount,POS.KO>
            Y.NCM = 0
        END
        Y.NCM -= 1
    REPEAT

RETURN

FIN.ARR:

    IF Y.SET.INS.CR EQ '' THEN
        Y.FIN.ARR<-1> = Y.AC.ID:'*':Y.PRD:'*':Y.CUR:'*':Y.AGENCY:'*':Y.ALT.NO:'*':Y.FIN.LOAN.ST:'*':Y.POL.TYPE:'*'
*                      1           2        3           4            5              6                 7

        Y.FIN.ARR := Y.POL.NUM:'*':Y.POL.STATUS:'*':Y.POL.COMP.TYPE:'*':Y.TOT.BAL
*                    8               9              10               11

    END

    Y.SET.INS.CR = ''

RETURN


END
