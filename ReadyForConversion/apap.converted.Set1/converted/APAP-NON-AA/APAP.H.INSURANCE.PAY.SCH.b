* Description
*
* This delete Multi Values with value equal to INSURANCE from AA.ARR.PAYMENT.SCHEDULE when the user change
* the AA in APAP.H.INSURANCE.DETAILS
*
*
*
* This routine is attached to AA.PRD.DES.ACTIVITY.API as a RECORD routine
*
*-----------------------------------------------------------------------------------------------------------
*
* Modification History
* BY: Santiago Jijon
* DATE: 2012/02/13
*-----------------------------------------------------------------------------------------------------------

SUBROUTINE APAP.H.INSURANCE.PAY.SCH
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.APAP.H.INSURANCE.PS

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*** <region name= Initialise>
*-----------------------------------------------------------------------------------------------------------
INITIALISE:

    Y.B2 = ''
    Y.ID.CMD = ''
    Y.ID.CMD.CHARGE = ''
    Y.PAYMENT.TYPE = ''
    Y.PROPERTY = ''
    SEL.CMD  = ''
    SEL.CMD1 = ''
    SEL.CMD2 = ''
    Y.LIST= ''
    Y.LIST3= ''
    Y.LIST2= ''

    FN.PAY.SCH = 'F.AA.ARR.PAYMENT.SCHEDULE'
    F.PAY.SCH  = ''
    R.PAY.SCH  = ''
    Y.PAY.SCH  = ''
    CALL OPF(FN.PAY.SCH,F.PAY.SCH)

    FN.CONCAT.PS = "F.APAP.H.INSURANCE.PS"
    F.CONCAT.PS  = ''
    R.CONCAT.PS  = ''
    CALL OPF(FN.CONCAT.PS,F.CONCAT.PS)

    FN.CHARGE = 'F.AA.ARR.CHARGE'
    F.CHARGE  = ''
    R.CHARGE  = ''
    Y.CHARGE  = ''
    CALL OPF(FN.CHARGE,F.CHARGE)


RETURN
*** </region>

*** <region name= Process>
*-----------------------------------------------------------------------------------------------------------
PROCESS:

    SEL.CMD = "SELECT ":FN.CONCAT.PS

    CALL EB.READLIST(SEL.CMD,Y.LIST,'',NO.OF.REG,RET.CODE)
    LOOP
        REMOVE Y.B2 FROM Y.LIST SETTING POS
    WHILE Y.B2:POS
        CALL F.READ(FN.CONCAT.PS,Y.B2,R.CONCAT.PS,F.CONCAT.PS,Y.ERR)
        Y.TOTPROP = DCOUNT(R.CONCAT.PS<PS.PROPERTY>,@VM)
        FOR II = 1 TO Y.TOTPROP
            Y.ID.CMD = R.CONCAT.PS<PS.AA.PS>
            Y.PAYMENT.TYPE = R.CONCAT.PS<PS.PAYMENT.TYPE>
            Y.PROPERTY = R.CONCAT.PS<PS.PROPERTY><1,II>
            Y.POLICY.NUMBER = R.CONCAT.PS<PS.POLICY.NUMBER>
            GOSUB PROCESS.REMOVE.CHARGE
            GOSUB PROCESS.REMOVE.PAY.SCH
        NEXT II

        CLEAR.CMD = "CLEAR.FILE F.APAP.H.INSURANCE.PS"
        EXECUTE CLEAR.CMD

    REPEAT

RETURN
*** </region>

*** <region name= Process.Remove.Charge>
*-----------------------------------------------------------------------------------------------------------
PROCESS.REMOVE.CHARGE:

    Y.ID.CMD.CHARGE = Y.ID.CMD:'-':Y.PROPERTY

    SEL.CMD1 = 'SELECT ': FN.CHARGE :' WITH @ID LIKE ': Y.ID.CMD.CHARGE : '... AND ACTIVITY EQ LENDING-RENEGOTIATE... BY-DSND @ID'
    CALL EB.READLIST(SEL.CMD1,Y.LIST1,'',NO.OF.REG,RET.CODE)
    GOSUB GET.LOCAL.FIELDS
    LOOP
        REMOVE Y.CHARGE FROM Y.LIST1 SETTING POS1
    WHILE Y.CHARGE:POS1
        CALL F.READ(FN.CHARGE,Y.CHARGE,R.CHARGE,F.CHARGE,Y.ERR)
        GOSUB GET.VALUES.LOCAL.FIELDS
        IF Y.POLICY.NUMBER EQ Y.POL.NUMBER<1,1,1> THEN ;*AND R.OLD(INS.DET.CLASS.POLICY) EQ Y.POLICY.CLASS<1,1,II> AND R.OLD(INS.DET.MANAGEMENT.TYPE) EQ Y.MANAG.TYPE<1,1,II> AND R.OLD(INS.DET.INS.COMPANY) EQ Y.INS.COMPANY<1,1,II> THEN
            R.CHARGE<AA.CHG.LOCAL.REF,Y.POLICY.TYPE.POS>=""
            R.CHARGE<AA.CHG.LOCAL.REF,Y.POLICY.CLASS.POS>=""
            R.CHARGE<AA.CHG.LOCAL.REF,Y.INS.COMPANY.POS>=""
            R.CHARGE<AA.CHG.LOCAL.REF,Y.POL.NUMBER.POS>=""
            R.CHARGE<AA.CHG.LOCAL.REF,Y.SNR.PLY.NUMBER.POS>=""
            R.CHARGE<AA.CHG.LOCAL.REF,Y.MANAG.TYPE.POS>=""
            R.CHARGE<AA.CHG.LOCAL.REF,Y.MNTY.POLICY.AMT.POS>=""
            R.CHARGE<AA.CHG.LOCAL.REF,Y.EXTRA.POLICY.POS>=""
            R.CHARGE<AA.CHG.LOCAL.REF,Y.TOT.MNT.PLY.AMT.POS>=""
            R.CHARGE<AA.CHG.LOCAL.REF,Y.TOT.PLY.AMT.POS>=""
            R.CHARGE<AA.CHG.LOCAL.REF,Y.STATUS.POLICY.POS>=""
            R.CHARGE<AA.CHG.LOCAL.REF,Y.EXPIRY.DATE.POS>=""

* I tried with F.WRITE but doesn´t work
            WRITE R.CHARGE TO F.CHARGE,Y.CHARGE

        END
        BREAK
    REPEAT

RETURN
*** </region>

*** <region name= Process.Remove.Pay.Sch>
*-----------------------------------------------------------------------------------------------------------
PROCESS.REMOVE.PAY.SCH:

    SEL.CMD2 = 'SELECT ': FN.PAY.SCH :' WITH ID.COMP.1 EQ ': Y.ID.CMD :' BY-DSND @ID'
    CALL EB.READLIST(SEL.CMD2,Y.LIST2,'',NO.OF.REG,RET.CODE)
    LOOP
        REMOVE Y.PAY.SCH FROM Y.LIST2 SETTING POS2
    WHILE Y.PAY.SCH:POS2
*
*   READ R.PAY.SCH FROM F.PAY.SCH, Y.PAY.SCH THEN      ;*Tus Start
        CALL F.READ(FN.PAY.SCH,Y.PAY.SCH,R.PAY.SCH,F.PAY.SCH,R.PAY.SCH.ERR)
        IF R.PAY.SCH THEN  ;* Tus End
            Y.TOTPAY.TYPE = DCOUNT(R.PAY.SCH<AA.PS.PAYMENT.TYPE>,@VM)
            FOR I.VAR = 1 TO Y.TOTPAY.TYPE
                GOSUB PROCESS.REMOVE.DATA
            NEXT
        END

        BREAK

    REPEAT

RETURN
*** </region>
*** <region name=PROCESS.REMOVE.DATA>
*-----------------------------------------------------------------------------------------------------------
PROCESS.REMOVE.DATA:
    IF R.PAY.SCH<AA.PS.PAYMENT.TYPE,I.VAR> EQ  Y.PAYMENT.TYPE THEN
        X6 = DCOUNT(R.PAY.SCH<AA.PS.PROPERTY,I.VAR>,@SM)
        FOR J.VAR = 1 TO X6
            X7 = R.PAY.SCH<AA.PS.PROPERTY,I.VAR,J.VAR>
            LOCATE Y.PROPERTY IN R.PAY.SCH<AA.PS.PROPERTY,I.VAR,J.VAR> SETTING Y.POS THEN
                DEL R.PAY.SCH<AA.PS.PAYMENT.TYPE,I.VAR>
                DEL R.PAY.SCH<AA.PS.PAYMENT.METHOD,I.VAR>
                DEL R.PAY.SCH<AA.PS.PAYMENT.FREQ,I.VAR>
                DEL R.PAY.SCH<AA.PS.BILL.TYPE,I.VAR>

                DEL R.PAY.SCH<AA.PS.PROPERTY,I.VAR,Y.POS>
                DEL R.PAY.SCH<AA.PS.DUE.FREQ,I.VAR,Y.POS>
                DEL R.PAY.SCH<AA.PS.START.DATE,I.VAR,Y.POS>
                DEL R.PAY.SCH<AA.PS.END.DATE,I.VAR,Y.POS>
                DEL R.PAY.SCH<AA.PS.ACTUAL.AMT,I.VAR,Y.POS>

                WRITE R.PAY.SCH TO F.PAY.SCH,Y.PAY.SCH
*CALL F.WRITE(FN.PAY.SCH,Y.ID,R.PAY.SCH)
            END
        NEXT
    END
RETURN
*** </region>

*** <region name=GET.LOCAL.FIELDS>
*-----------------------------------------------------------------------------------------------------------
GET.LOCAL.FIELDS:
    LOC.REF.POS = 0
    LOC.REF.APPL = "AA.PRD.DES.CHARGE"
    LOC.REF.FIELDS = "POLICY.TYPE": @VM :"POLICY.CLASS": @VM :"INS.COMPANY": @VM :"POL.NUMBER": @VM :"SNR.PLY.NUMBER": @VM :"MANAG.TYPE": @VM
    LOC.REF.FIELDS := "MNTY.POLICY.AMT": @VM :"EXTRA.POLICY": @VM :"TOT.MNT.PLY.AMT": @VM :"TOT.PLY.AMT": @VM :"STATUS.POLICY": @VM : "EXPIRY.DATE"
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    Y.POLICY.TYPE.POS     = LOC.REF.POS<1,1>
    Y.POLICY.CLASS.POS    = LOC.REF.POS<1,2>
    Y.INS.COMPANY.POS     = LOC.REF.POS<1,3>
    Y.POL.NUMBER.POS      = LOC.REF.POS<1,4>
    Y.SNR.PLY.NUMBER.POS  = LOC.REF.POS<1,5>
    Y.MANAG.TYPE.POS      = LOC.REF.POS<1,6>
    Y.MNTY.POLICY.AMT.POS = LOC.REF.POS<1,7>
    Y.EXTRA.POLICY.POS    = LOC.REF.POS<1,8>
    Y.TOT.MNT.PLY.AMT.POS = LOC.REF.POS<1,9>
    Y.TOT.PLY.AMT.POS     = LOC.REF.POS<1,10>
    Y.STATUS.POLICY.POS   = LOC.REF.POS<1,11>
    Y.EXPIRY.DATE.POS     = LOC.REF.POS<1,12>
RETURN
*** </region>

*** <region name=GET.VALUES.LOCAL.FIELDS>
*-----------------------------------------------------------------------------------------------------------
GET.VALUES.LOCAL.FIELDS:

    Y.POLICY.TYPE     = R.CHARGE<AA.CHG.LOCAL.REF,Y.POLICY.TYPE.POS>
    Y.POLICY.CLASS    = R.CHARGE<AA.CHG.LOCAL.REF,Y.POLICY.CLASS.POS>
    Y.INS.COMPANY     = R.CHARGE<AA.CHG.LOCAL.REF,Y.INS.COMPANY.POS>
    Y.POL.NUMBER      = R.CHARGE<AA.CHG.LOCAL.REF,Y.POL.NUMBER.POS>
    Y.SNR.PLY.NUMBER  = R.CHARGE<AA.CHG.LOCAL.REF,Y.SNR.PLY.NUMBER.POS>
    Y.MANAG.TYPE      = R.CHARGE<AA.CHG.LOCAL.REF,Y.MANAG.TYPE.POS>
    Y.MNTY.POLICY.AMT = R.CHARGE<AA.CHG.LOCAL.REF,Y.MNTY.POLICY.AMT.POS>
    Y.EXTRA.POLICY    = R.CHARGE<AA.CHG.LOCAL.REF,Y.EXTRA.POLICY.POS>
    Y.TOT.MNT.PLY.AMT = R.CHARGE<AA.CHG.LOCAL.REF,Y.TOT.MNT.PLY.AMT.POS>
    Y.TOT.PLY.AMT     = R.CHARGE<AA.CHG.LOCAL.REF,Y.TOT.PLY.AMT.POS>
    Y.STATUS.POLICY   = R.CHARGE<AA.CHG.LOCAL.REF,Y.STATUS.POLICY.POS>
    Y.EXPIRY.DATE     = R.CHARGE<AA.CHG.LOCAL.REF,Y.EXPIRY.DATE.POS>

RETURN
*** </region>


END
