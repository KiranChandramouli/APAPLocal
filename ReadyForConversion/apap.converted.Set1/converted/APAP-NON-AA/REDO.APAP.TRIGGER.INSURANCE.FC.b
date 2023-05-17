SUBROUTINE REDO.APAP.TRIGGER.INSURANCE.FC

*-----------------------------------------------------------------------------------------------------------
* Description
*
* This routine reads the values from the application APAP.H.INSURANCE.DETAILS and triggers an
* AA Activity 'LENDING-RENEGOTIATE-ARRANGEMENT' which will update the Insurance details given as part of this
* Application
*
* This routine is attached to as a AUTH routine to the version used by APAP.H.INSURANCE.DETAILS so that the AA
* activity message is posted in OFS.MESSAGE.QUEUE
*
* This routine is used for authorize record that come from FABRICA DE CREDITO
*
*-----------------------------------------------------------------------------------------------------------
*
* Modification History
* BY: Santiago Jijon
* DATE: 2012/03/05
*
*-----------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.CHARGE

*-----------------------------------------------------------------------------------------------------------
MAIN.LOGIC:

    GOSUB INITIALISE

    GOSUB PROCESS.OFS

RETURN

*** <region name= Initialise>
*-----------------------------------------------------------------------------------------------------------
INITIALISE:

    AAA.REQUEST = ''

    PROPERTY.CLASS = ''

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    R.AA.ACCOUNT.DETAILS = ''
    CALL OPF (FN.AA.ACCOUNT.DETAILS, F.AA.ACCOUNT.DETAILS)

    ARR.ID = R.NEW(INS.DET.ASSOCIATED.LOAN)

    CALL F.READ(FN.AA.ACCOUNT.DETAILS, ARR.ID, R.AA.ACCOUNT.DETAILS, F.AA.ACCOUNT.DETAILS, READ.ERR)

    FN.CHARGE = 'F.AA.ARR.CHARGE'
    F.CHARGE  = ''
    R.CHARGE  = ''
    Y.CHARGE  = ''
    CALL OPF(FN.CHARGE,F.CHARGE)


RETURN
*** </region>

*** <region name=PROCESS.OFS>
*-----------------------------------------------------------------------------------------------------------
PROCESS.OFS:

    AAA.REQUEST<AA.ARR.ACT.ARRANGEMENT> = R.NEW(INS.DET.ASSOCIATED.LOAN)
    AAA.REQUEST<AA.ARR.ACT.ACTIVITY> = 'LENDING-RENEGOTIATE-OPEN'
    AAA.REQUEST<AA.ARR.ACT.EFFECTIVE.DATE> = TODAY

    GOSUB FORM.CHARGE

    APP.NAME = 'AA.ARRANGEMENT.ACTIVITY'
    IN.FUNCTION = 'I'
    VERSION.NAME = 'AA.ARRANGEMENT.ACTIVITY,ZERO.AUTH'


    CALL OFS.BUILD.RECORD(APP.NAME, IN.FUNCTION, "PROCESS", VERSION.NAME, "", "0", AAA.ID, AAA.REQUEST, PROCESS.MSG)      ;*Form the OFS Message

    GOSUB TRIGGER.OFS ;* Post the OFS in the queue


RETURN

*** </region>

*** <region name=FORM.CHARGE>
*-----------------------------------------------------------------------------------------------------------
FORM.CHARGE:
* This forms the OFS message request for CHARGE property

    Y.ID.CMD = ARR.ID:'-': R.NEW(INS.DET.CHARGE)<1,1>

    PROPERTY.CLASS = "CHARGE"
    GOSUB GET.PROPERTY

    AA.PROPERTY = R.NEW(INS.DET.CHARGE)<1,1>
    AAA.REQUEST<AA.ARR.ACT.PROPERTY,-1> = AA.PROPERTY         ;* Charge property to be updated as part of Insurance

*    CALL F.READ(FN.CHARGE, ARR.ID, R.CHARGE, F.CHARGE, Y.ERR)
*    SEL.CMD = 'SELECT ': FN.CHARGE :' WITH @ID LIKE ': Y.ID.CMD : '... AND ACTIVITY EQ LENDING-RENEGOTIATE-OPEN BY-DSND DATE.TIME'
*    CALL EB.READLIST(SEL.CMD,Y.LIST,'',NO.OF.REG,RET.CODE)
*    IF NO.OF.REG GT 0 THEN
*        GOSUB GET.LOCAL.FIELDS
*        LOOP
*            REMOVE Y.CHARGE FROM Y.LIST SETTING POS
*        WHILE Y.CHARGE:POS
*            CALL F.READ(FN.CHARGE,Y.CHARGE,R.CHARGE,F.CHARGE,Y.ERR)
*            GOSUB GET.VALUES.LOCAL.FIELDS
*            Y.TOT.POL.NUMBER = DCOUNT(Y.POL.NUMBER, SM)
*            FOR II = 1 TO Y.TOT.POL.NUMBER
*                GOSUB ARMA.OFS
*            NEXT
*            II = Y.TOT.POL.NUMBER + 1
*            GOSUB ARMA.OFS.NUEVO
*            BREAK
*        REPEAT
*    END ELSE
*        II = 1
*        GOSUB ARMA.OFS.NUEVO
*    END
    idArrangementComp = ARR.ID
    idPropertyClass = PROPERTY.CLASS
    idProperty = AA.PROPERTY
    effectiveDate = ''
    returnIds = ''
    returnConditions = ''
    returnError = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(idArrangementComp, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)

    Y.POLICYTYPE = returnConditions<1,31,16>
    MMARK = CHARX(251)
    Y.POLICYTYPE1 = CHANGE(Y.POLICYTYPE, MMARK , @SM )
    II = DCOUNT(Y.POLICYTYPE1, @SM) + 1

    GOSUB ARMA.OFS.NUEVO
RETURN
*** </region>

*** <region name=GET.LOCAL.FIELDS>
*-----------------------------------------------------------------------------------------------------------
GET.LOCAL.FIELDS:
    LOC.REF.POS=0
    LOC.REF.APPL="AA.PRD.DES.CHARGE"
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

*** <region name=ARMA.OFS>
*-----------------------------------------------------------------------------------------------------------
ARMA.OFS:
    IF Y.POL.NUMBER<1,1,II> NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'POL.NUMBER:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = Y.POL.NUMBER<1,1,II>
    END

    IF Y.SNR.PLY.NUMBER<1,1,II> NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'SNR.PLY.NUMBER:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = Y.SNR.PLY.NUMBER<1,1,II>
    END

    IF Y.POLICY.TYPE<1,1,II> NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'POLICY.TYPE:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = Y.POLICY.TYPE<1,1,II>
    END

    IF Y.POLICY.CLASS<1,1,II> NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'POLICY.CLASS:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = Y.POLICY.CLASS<1,1,II>
    END

    IF Y.MANAG.TYPE<1,1,II> NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'MANAG.TYPE:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = Y.MANAG.TYPE<1,1,II>
    END

    IF Y.MNTY.POLICY.AMT<1,1,II> NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'MNTY.POLICY.AMT:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = Y.MNTY.POLICY.AMT<1,1,II>
    END

    IF Y.EXTRA.POLICY<1,1,II> NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'EXTRA.POLICY:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = Y.EXTRA.POLICY<1,1,II>
    END

    IF Y.TOT.MNT.PLY.AMT<1,1,II> NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'TOT.MNT.PLY.AMT:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = Y.TOT.MNT.PLY.AMT<1,1,II>
    END

    IF Y.TOT.PLY.AMT<1,1,II> NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'TOT.PLY.AMT:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = Y.TOT.PLY.AMT<1,1,II>
    END

    IF Y.STATUS.POLICY<1,1,II> NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'STATUS.POLICY:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = Y.STATUS.POLICY<1,1,II>
    END

    IF Y.INS.COMPANY<1,1,II> NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'INS.COMPANY:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = Y.INS.COMPANY<1,1,II>
    END

    IF Y.EXPIRY.DATE<1,1,II> NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'EXPIRY.DATE:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = Y.EXPIRY.DATE<1,1,II>
    END

RETURN
*** </region>

*** <region name=ARMA.OFS.NUEVO>
*-----------------------------------------------------------------------------------------------------------
ARMA.OFS.NUEVO:

    IF R.NEW(INS.DET.POLICY.NUMBER) NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'POL.NUMBER:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.NEW(INS.DET.POLICY.NUMBER)
    END

    IF R.NEW(INS.DET.SEN.POLICY.NUMBER) NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'SNR.PLY.NUMBER:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.NEW(INS.DET.SEN.POLICY.NUMBER)
    END

    IF R.NEW(INS.DET.INS.POLICY.TYPE) NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'POLICY.TYPE:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.NEW(INS.DET.INS.POLICY.TYPE)
    END

    IF R.NEW(INS.DET.CLASS.POLICY) NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'POLICY.CLASS:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.NEW(INS.DET.CLASS.POLICY)
    END

    IF R.NEW(INS.DET.MANAGEMENT.TYPE) NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'MANAG.TYPE:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.NEW(INS.DET.MANAGEMENT.TYPE)
    END

    IF R.NEW(INS.DET.MON.POL.AMT)<1,1> NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'MNTY.POLICY.AMT:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.NEW(INS.DET.MON.POL.AMT)<1,1>
    END

    IF R.NEW(INS.DET.EXTRA.AMT)<1,1> NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'EXTRA.POLICY:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.NEW(INS.DET.EXTRA.AMT)<1,1>
    END

    IF R.NEW(INS.DET.MON.TOT.PRE.AMT)<1,1> NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'TOT.MNT.PLY.AMT:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.NEW(INS.DET.MON.TOT.PRE.AMT)<1,1>
    END

    IF R.NEW(INS.DET.TOTAL.PRE.AMT) NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'TOT.PLY.AMT:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.NEW(INS.DET.TOTAL.PRE.AMT)
    END

    IF R.NEW(INS.DET.POLICY.STATUS) NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'STATUS.POLICY:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.NEW(INS.DET.POLICY.STATUS)
    END

    IF R.NEW(INS.DET.INS.COMPANY) NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'INS.COMPANY:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.NEW(INS.DET.INS.COMPANY)
    END

    IF R.NEW(INS.DET.POL.EXP.DATE) NE '' THEN
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,1,-1> = 'EXPIRY.DATE:':II:':1'
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.NEW(INS.DET.POL.EXP.DATE)
    END

RETURN
*** </region>

*** <region name=GET.PROPERTY>
GET.PROPERTY:
* Get the property Name for the property class

    ARR.INFO = ''
    R.ARRANGEMENT = ''
    AA.PROPERTY = ''

    ARR.INFO<1> = R.NEW(INS.DET.ASSOCIATED.LOAN)
    ARR.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.BASE.DATE>

    CALL AA.GET.ARRANGEMENT.PROPERTIES(ARR.INFO, ARR.DATE, R.ARRANGEMENT, PROP.LIST)

    CLASS.LIST = ''
    CALL AA.GET.PROPERTY.CLASS (PROP.LIST, CLASS.LIST)

    CLASS.LIST = RAISE(CLASS.LIST)
    PROP.LIST = RAISE(PROP.LIST)

    CLASS.CTR = ''
    LOOP
        REMOVE Y.CLASS FROM CLASS.LIST SETTING CLASS.POS
        CLASS.CTR +=1
    WHILE Y.CLASS:CLASS.POS
        IF Y.CLASS EQ PROPERTY.CLASS THEN
            AA.PROPERTY = PROP.LIST<CLASS.CTR>
            BREAK
        END
    REPEAT

RETURN
*** </region>

*** <region name=TRIGGER.OFS>
*-----------------------------------------------------------------------------------------------------------
TRIGGER.OFS:
*DEBUG
* This posts the OFS message formed to the OFS.MESSAGE.QUEUE for processing
*
    OFS.MSG.ID = ''
    OFS.SOURCE = 'TRIGGER.INSURANCE'
    OFS.ERR = ''

    CALL OFS.POST.MESSAGE(PROCESS.MSG,OFS.MSG.ID,OFS.SOURCE,OFS.ERR)

RETURN

*** </region>


END
