* @ValidationCode : MjoxMTM2MDA2MTk2OkNwMTI1MjoxNjgwNzYxNTM3NTIxOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 11:42:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.TRIGGER.INSURANCE.MOD

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
*-----------------------------------------------------------------------------------------------------------
*
* Modification History
* BY: Santiago Jijon
* DATE: 2011/11/28
*
* BY: Santiago Jijon
* DATE: 2012/02/09
* Delete information of AA.CHARGE and AA.PAYMENT.SCHEDULE when AA is diferent

* BY: Silambarasan S, 3MS Technologies
* DATE: 2017/02/02
* For LENDING-RENEGOTIATE-MAINT Activity, START.DATE needs to be assigned with TODAY.

* Correction of the PACS00580858
* For LENDING-RENEGOTIATE-MAINT Activity, the date is the the one inputted by the user.
* Date                   who                   Reference              
* 06-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION SM TO @SM AND VM TO @VM AND CHAR TO CHARX
* 06-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.APAP.H.INSURANCE.PS
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.PAYMENT.SCHEDULE
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
    ARR.OLD = R.OLD(INS.DET.ASSOCIATED.LOAN)

    CALL F.READ(FN.AA.ACCOUNT.DETAILS, ARR.ID, R.AA.ACCOUNT.DETAILS, F.AA.ACCOUNT.DETAILS, READ.ERR)

    FN.CHARGE = 'F.AA.ARR.CHARGE'
    F.CHARGE  = ''
    R.CHARGE  = ''
    Y.CHARGE  = ''
    CALL OPF(FN.CHARGE,F.CHARGE)

    FN.PAY.SCH = 'F.AA.ARR.PAYMENT.SCHEDULE'
    F.PAY.SCH  = ''
    R.PAY.SCH  = ''
    Y.PAY.SCH  = ''
    CALL OPF(FN.PAY.SCH,F.PAY.SCH)

    FN.CONCAT.PS = "F.APAP.H.INSURANCE.PS"
    F.CONCAT.PS  = ''
    R.CONCAT.PS  = ''
    CALL OPF(FN.CONCAT.PS,F.CONCAT.PS)


RETURN
*** </region>

*** <region name=PROCESS.OFS>
*-----------------------------------------------------------------------------------------------------------
PROCESS.OFS:



    AAA.REQUEST<AA.ARR.ACT.EFFECTIVE.DATE> = TODAY    ;* AA_170420 : By default, the effective date is TODAY

    Y.NAME.VER = R.NEW(INS.DET.INDICADOR)
    BEGIN CASE
        CASE Y.NAME.VER EQ ',REDO.ENMIENDAS'
            AAA.REQUEST<AA.ARR.ACT.ACTIVITY> = 'LENDING-RENEGOTIATE-MAINT'
* SM_22052107        AAA.REQUEST<AA.ARR.ACT.EFFECTIVE.DATE> = R.NEW(INS.DET.INS.START.DATE)  ;* AA_170420, The date should be choosed start date : INS.START.DATE
        CASE Y.NAME.VER EQ ',REDO.RENOVAC'
            AAA.REQUEST<AA.ARR.ACT.ACTIVITY> = 'LENDING-RENEGOTIATE-RENEW'
        CASE Y.NAME.VER EQ ',REDO.CANCELLATION'
            AAA.REQUEST<AA.ARR.ACT.ACTIVITY> = 'LENDING-RENEGOTIATE-CANCEL'
    END CASE



* IF ARR.ID NE ARR.OLD AND ARR.OLD NE '' THEN
*     AAA.REQUEST<AA.ARR.ACT.ARRANGEMENT> = R.OLD(INS.DET.ASSOCIATED.LOAN)
*     GOSUB PROCESS.DELETE
* END

    AAA.REQUEST<AA.ARR.ACT.ARRANGEMENT> = R.NEW(INS.DET.ASSOCIATED.LOAN)
    GOSUB FORM.CHARGE
    GOSUB INCLUDE.CHARGE


    APP.NAME = 'AA.ARRANGEMENT.ACTIVITY'
    IN.FUNCTION = 'I'
    VERSION.NAME = 'AA.ARRANGEMENT.ACTIVITY,ZERO.AUTH'

    CALL OFS.BUILD.RECORD(APP.NAME, IN.FUNCTION, "PROCESS", VERSION.NAME, "", "0", AAA.ID, AAA.REQUEST, PROCESS.MSG)    ;*Form the OFS Message

    GOSUB TRIGGER.OFS         ;* Post the OFS in the queue

RETURN
*** </region>

*** <region name=PROCESS.DELETE>
*-----------------------------------------------------------------------------------------------------------
PROCESS.DELETE:

    YCONCAT.ID = ID.OLD
    R.CONCAT.PS<PS.POLICY.NUMBER> = R.OLD(INS.DET.POLICY.NUMBER)
    IF R.OLD(INS.DET.MANAGEMENT.TYPE) EQ 'INCLUIR EN CUOTA' THEN

*        Y.ID.CMD = ARR.OLD
*        SEL.CMD = 'SELECT ': FN.PAY.SCH :' WITH ID.COMP.1 EQ ': Y.ID.CMD :' BY-DSND @ID'
*        CALL EB.READLIST(SEL.CMD,Y.LIST,'',NO.OF.REG,RET.CODE)
*         IF NO.OF.REG GT 0 THEN
*            LOOP
*               REMOVE Y.PAY.SCH FROM Y.LIST SETTING POS
*            WHILE Y.PAY.SCH:POS
*               CALL F.READ(FN.PAY.SCH,Y.PAY.SCH,R.PAY.SCH,F.PAY.SCH,Y.ERR)
*               Y.TOT.PAY.TYPE = DCOUNT(R.PAY.SCH<AA.PS.PAYMENT.TYPE>, VM)
*               FOR II = 1 TO Y.TOT.PAY.TYPE
*                  GOSUB GET.DATA
*               NEXT
*               BREAK
*            REPEAT
*         END

        idArrangementComp = ARR.ID
        idPropertyClass = PROPERTY.CLASS
        idProperty = AA.PROPERTY
        effectiveDate = ''
        returnIds = ''
        returnConditions = ''
        returnError = ''
        CALL AA.GET.ARRANGEMENT.CONDITIONS(idArrangementComp, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
        Y.TOT.PAY.TYPE = DCOUNT(returnConditions<1,10>, @SM)

        FOR II = 1 TO Y.TOT.PAY.TYPE
            Y.PAYMENT.TYPE = returnConditions<1,10,II>
*TUS change
*AA.PS.PROPERTY changed to 17th position in R15.
            Y.PROPERTYS = returnConditions<1,17,II>
            MMARK = CHARX(251) ;*R22 AUTO CONVERSTION CHAR TO CHARX
            Y.PROPERTY1 = CHANGE(Y.PROPERTYS, MMARK , @SM )
            Y.TOT.PROPERTY = DCOUNT(Y.PROPERTY1, @SM)

            FOR JJ = 1 TO Y.TOT.PROPERTY
                Y.PROPERTY = FIELD(Y.PROPERTY1,@SM,JJ)
                GOSUB GET.DATA
            NEXT
        NEXT


    END
*CALL F.WRITE(FN.CONCAT.PS,YCONCAT.ID,R.CONCAT.PS)
    WRITE R.CONCAT.PS TO F.CONCAT.PS,YCONCAT.ID


RETURN
*** </region>

*** <region name=GET.DATA>
*-----------------------------------------------------------------------------------------------------------
GET.DATA:

    Y.TOTPROP = DCOUNT(R.PAY.SCH<AA.PS.PROPERTY><1,II> , @SM)
    FOR JJ = 1 TO Y.TOTPROP
*Y.PAYMENT.TYPE = R.PAY.SCH<AA.PS.PAYMENT.TYPE><1,II>
*Y.PROPERTY = R.PAY.SCH<AA.PS.PROPERTY><1,II,JJ>
        IF Y.PAYMENT.TYPE EQ R.OLD(INS.DET.PAYMENT.TYPE)<1,1> AND Y.PROPERTY EQ R.OLD(INS.DET.CHARGE)<1,1>  THEN
            YCONCAT.ID = ID.OLD
            R.CONCAT.PS<PS.AA.PS> = ARR.OLD
            R.CONCAT.PS<PS.PAYMENT.TYPE> = R.OLD(INS.DET.PAYMENT.TYPE)<1,1>
            IF R.CONCAT.PS<PS.PROPERTY> EQ '' THEN
                R.CONCAT.PS<PS.PROPERTY> = R.OLD(INS.DET.CHARGE)<1,1>
            END ELSE
                R.CONCAT.PS<PS.PROPERTY> = R.CONCAT.PS<PS.PROPERTY> : @VM : R.OLD(INS.DET.CHARGE)<1,1>
            END
        END
        IF Y.PAYMENT.TYPE EQ R.OLD(INS.DET.PAYMENT.TYPE)<1,1> AND Y.PROPERTY EQ R.OLD(INS.DET.CHARGE.EXTRA.AMT)<1,1> THEN
            YCONCAT.ID = ID.OLD
            R.CONCAT.PS<PS.AA.PS> = ARR.OLD
            R.CONCAT.PS<PS.PAYMENT.TYPE> = R.OLD(INS.DET.PAYMENT.TYPE)<1,1>
            IF R.CONCAT.PS<PS.PROPERTY> EQ '' THEN
                R.CONCAT.PS<PS.PROPERTY> = R.OLD(INS.DET.CHARGE.EXTRA.AMT)<1,1>
            END ELSE
                R.CONCAT.PS<PS.PROPERTY> = R.CONCAT.PS<PS.PROPERTY> : @VM : R.OLD(INS.DET.CHARGE.EXTRA.AMT)<1,1>
            END
        END

    NEXT

RETURN
***</region>

*** <region name=FORM.CHARGE>
*-----------------------------------------------------------------------------------------------------------
FORM.CHARGE:
* This forms the OFS message request for CHARGE property

    Y.ID.CMD = ARR.ID:'-': R.NEW(INS.DET.CHARGE)<1,1>

    PROPERTY.CLASS = "CHARGE"
    GOSUB GET.PROPERTY

    AA.PROPERTY = R.NEW(INS.DET.CHARGE)<1,1>
    AAA.REQUEST<AA.ARR.ACT.PROPERTY,-1> = AA.PROPERTY       ;* Charge property to be updated as part of Insurance

    Y.POL.NUM = R.NEW(INS.DET.POLICY.NUMBER)
    Y.SEN.POL.NUM = R.NEW(INS.DET.SEN.POLICY.NUMBER)
    Y.CLAS.POL = R.NEW(INS.DET.CLASS.POLICY)
    Y.MAN.TYPE = R.NEW(INS.DET.MANAGEMENT.TYPE)
    Y.COMPANY = R.NEW(INS.DET.INS.COMPANY)

    idArrangementComp = ARR.ID
    idPropertyClass = PROPERTY.CLASS
    idProperty = AA.PROPERTY
    effectiveDate = ''
    returnIds = ''
    returnConditions = ''
    returnError = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(idArrangementComp, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    Y.POLICYTYPE = returnConditions<1,31,16>
    MMARK = CHARX(251)  ;*R22 AUTO CONVERSTION CHAR TO CHARX
    Y.POLICYTYPE1 = CHANGE(Y.POLICYTYPE, MMARK , @SM )
    Y.POLI.TOT = DCOUNT(Y.POLICYTYPE1, @SM)

    X.POL.NUM = CHANGE(returnConditions<1,31,19>, MMARK , @SM )
    X.SEN.POL.NUM = CHANGE(returnConditions<1,31,20>, MMARK , @SM )
    X.CLAS.POL = CHANGE(returnConditions<1,31,17>, MMARK , @SM )
    X.MAN.TYPE = CHANGE(returnConditions<1,31,21>, MMARK , @SM )
    X.COMPANY = CHANGE(returnConditions<1,31,18>, MMARK , @SM )


    FOR II =1 TO Y.POLI.TOT
        Z.POL.NUM = FIELD(X.POL.NUM,@SM,II)
        Z.SEN.POL.NUM = FIELD(X.SEN.POL.NUM,@SM,II)
        Z.CLAS.POL = FIELD(X.CLAS.POL,@SM,II)
        Z.MAN.TYPE = FIELD(X.MAN.TYPE,@SM,II)
        Z.COMPANY = FIELD(X.COMPANY,@SM,II)

        IF Y.POL.NUM EQ Z.POL.NUM AND Y.SEN.POL.NUM EQ Z.SEN.POL.NUM AND Y.CLAS.POL EQ Z.CLAS.POL AND Y.MAN.TYPE EQ Z.MAN.TYPE AND Y.COMPANY EQ Z.COMPANY THEN
            GOSUB ARMA.OFS.NUEVO
        END
    NEXT

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

*** <region name=INCLUDE.CHARGE>

*-----------------------------------------------------------------------------------------------------------
INCLUDE.CHARGE:

    IF R.NEW(INS.DET.MANAGEMENT.TYPE) EQ 'INCLUIR EN CUOTA' THEN
        PROPERTY.CLASS = 'PAYMENT.SCHEDULE'
        GOSUB GET.PROPERTY

        AAA.REQUEST<AA.ARR.ACT.PROPERTY,-1> = AA.PROPERTY

        Y.ID.CMD = ARR.ID
* CALL F.READ(FN.PAY.SCH,Y.PAY.SCH,R.PAY.SCH,F.PAY.SCH,Y.ERR)
        idArrangementComp = ARR.ID
        idPropertyClass = PROPERTY.CLASS
        idProperty = AA.PROPERTY
        effectiveDate = ''
        returnIds = ''
        returnConditions = ''
        returnError = ''
        CALL AA.GET.ARRANGEMENT.CONDITIONS(idArrangementComp, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)

        CALL AA.SCHEDULE.PROJECTOR(ARR.ID, SIM.REF, "",CYCLE.DATE, TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS, DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)

        Y.STR.PRP = ''

        Y.TOT.PAY.TYPE = DCOUNT(returnConditions<1,10>, @SM)

        FOR II = 1 TO Y.TOT.PAY.TYPE
            Y.PAYMENT.TYPE = returnConditions<1,10,II>
            IF Y.PAYMENT.TYPE EQ R.NEW(INS.DET.PAYMENT.TYPE)<1,1> THEN
*TUS change
*AA.PS.PROPERTY changed to 17th position in R15.
                Y.PROPERTYS = returnConditions<1,17,II>
                MMARK = CHARX(251)
                Y.PROPERTY1 = CHANGE(Y.PROPERTYS, MMARK , @SM )
                Y.STR.PRP<-1> = Y.PROPERTY1
                Y.TOT.PROPERTY = DCOUNT(Y.PROPERTY1, @SM)
                IF Y.PROPERTYS EQ R.NEW(INS.DET.CHARGE)<1,1> THEN
                    Y.CND = II
                    IF Y.NAME.VER EQ ',REDO.CANCELLATION' THEN
                        GOSUB PROCESS.REMOVE.ONE.TYPE
                    END
                END
                IF  Y.PROPERTYS EQ R.NEW(INS.DET.CHARGE.EXTRA.AMT)<1,1> THEN
                    IF Y.NAME.VER EQ ',REDO.CANCELLATION' THEN
                        GOSUB PROCESS.REMOVE.ONE.TYPE
                    END
                    Y.CND.1 = II
                END
            END
        NEXT

        IF R.NEW(INS.DET.POLICY.STATUS) NE "CANCELADA" AND Y.NAME.VER EQ ',REDO.ENMIENDAS' THEN
            GOSUB ARMA.OFS.NUEVO.SCH
        END
    END

RETURN
*** </region>


PROCESS.REMOVE.ONE.TYPE:

    AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,-1,-1> = 'PAYMENT.TYPE:':II:':1'
    AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,-1,-1> = '|-|'

RETURN

*** <region name= Process.Remove.Pay.Sch>
*-----------------------------------------------------------------------------------------------------------
*** <region name=ARMA.OFS.NUEVO.SCH>
*-----------------------------------------------------------------------------------------------------------
ARMA.OFS.NUEVO.SCH:

    Y.TOT.PROPERTY = DCOUNT(R.NEW(INS.DET.MON.POL.AMT), @VM)

    FOR JJ = 1 TO Y.TOT.PROPERTY
* IF R.NEW(INS.DET.POLICY.STATUS) EQ "CANCELADA" THEN
*     R.NEW(INS.DET.INS.END.DATE)<1,JJ> = TODAY
* END

        IF JJ EQ 1 THEN
            AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'PAYMENT.TYPE:':Y.CND:':1'
            AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = R.NEW(INS.DET.PAYMENT.TYPE)<1,JJ>

            Y.COND = RAISE(returnConditions)
            Y.FREQ = Y.COND<AA.PS.PAYMENT.FREQ,Y.CND>
            AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'PAYMENT.METHOD:':Y.CND:':1'
            AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = 'DUE'

            AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'PAYMENT.FREQ:':Y.CND:':1'
            AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = Y.FREQ

            IF R.NEW(INS.DET.CHARGE)<1,JJ> NE '' THEN
                AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'PROPERTY:':Y.CND:':':1
                AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = R.NEW(INS.DET.CHARGE)<1,JJ>
            END

            IF R.NEW(INS.DET.INS.START.DATE)<1,JJ> NE '' THEN
                AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'START.DATE:':Y.CND:':1'
                AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = R.NEW(INS.DET.INS.START.DATE)<1,JJ>      ;* AA_170420
*AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = TODAY                                   ;* AA_170420
            END

            IF R.NEW(INS.DET.INS.END.DATE)<1,JJ> NE '' THEN
                AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'END.DATE:':Y.CND:':1'
                AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = R.NEW(INS.DET.INS.END.DATE)<1,JJ>
            END

            IF R.NEW(INS.DET.MON.POL.AMT)<1,JJ> NE '' THEN
                AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'ACTUAL.AMT:':Y.CND:':':1
                AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = R.NEW(INS.DET.MON.POL.AMT)<1,JJ>
            END

        END ELSE

            IF R.NEW(INS.DET.INS.START.DATE)<1,JJ> NE '' THEN
                AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'START.DATE:':Y.CND:':':JJ
                AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = R.NEW(INS.DET.INS.START.DATE)<1,JJ>      ;* AA_170420
*AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = TODAY                                   ;* AA_170420
            END

            IF R.NEW(INS.DET.INS.END.DATE)<1,JJ> NE '' THEN
                AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'END.DATE:':Y.CND:':':JJ
                AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = R.NEW(INS.DET.INS.END.DATE)<1,JJ>
            END

            IF R.NEW(INS.DET.MON.POL.AMT)<1,JJ> NE '' THEN
                AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'ACTUAL.AMT:':Y.CND:':':JJ
                AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = R.NEW(INS.DET.MON.POL.AMT)<1,JJ>
            END
        END

    NEXT JJ
*** ESTE PROCEDIMIENTO ES SOLO PARA CUANDO EXISTEN EXTRA PRIMAS
    JJ = 1
    IF R.NEW(INS.DET.EXTRA.AMT)<1,JJ> NE '' THEN
        FOR JJ = 1 TO Y.TOT.PROPERTY
            IF JJ EQ 1 THEN
                AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'PAYMENT.TYPE:':Y.CND+1:':1'
                AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = R.NEW(INS.DET.PAYMENT.TYPE)<1,JJ>

                AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'PAYMENT.METHOD:':Y.CND+1:':1'
                AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = 'DUE'

                AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'PAYMENT.FREQ:':Y.CND+1:':1'
                AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = Y.FREQ

                AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'PROPERTY:':Y.CND+1:':':JJ
                AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = R.NEW(INS.DET.CHARGE.EXTRA.AMT)<1,JJ>

                GOSUB CHECK.EXTRA.AM

                AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'ACTUAL.AMT:':Y.CND+1:':':JJ
                AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = R.NEW(INS.DET.EXTRA.AMT)<1,JJ>
            END ELSE
                AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'START.DATE:':Y.CND+1:':':JJ
                AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = R.NEW(INS.DET.INS.START.DATE)<1,JJ>      ;* AA_170420
*AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = TODAY                                   ;* AA_170420

                AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'END.DATE:':Y.CND+1:':':JJ
                AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = R.NEW(INS.DET.INS.END.DATE)<1,JJ>

                AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'ACTUAL.AMT:':Y.CND+1:':':JJ
                AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = R.NEW(INS.DET.EXTRA.AMT)<1,JJ>
            END
        NEXT JJ
    END

RETURN
*** </region>

*** <region name=GET.PROPERTY>

CHECK.EXTRA.AM:

    Y.SRT.DT = R.NEW(INS.DET.CHARGE.EXTRA.AMT)<1,JJ>
    LOCATE Y.SRT.DT IN Y.STR.PRP SETTING POS.DTE THEN
        Y.SRT.DTE = Y.COND<AA.PS.START.DATE,Y.CND.1>
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'START.DATE:':Y.CND+1:':':JJ
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = Y.SRT.DTE

        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'END.DATE:':Y.CND+1:':':JJ
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = R.NEW(INS.DET.INS.END.DATE)<1,JJ>
    END ELSE
        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'START.DATE:':Y.CND+1:':':JJ
        LOCATE TODAY IN DUE.DATES BY 'AR' SETTING POS.TDY THEN
            AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = TODAY
        END ELSE
            AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = DUE.DATES<POS.TDY>
        END

        AAA.REQUEST<AA.ARR.ACT.FIELD.NAME,2,-1> = 'END.DATE:':Y.CND+1:':':JJ
        AAA.REQUEST<AA.ARR.ACT.FIELD.VALUE,2,-1> = R.NEW(INS.DET.INS.END.DATE)<1,JJ>
    END

RETURN

*-----------------------------------------------------------------------------------------------------------
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
***</region>

*** <region name=GET.PROPERTY.OLD>
*-----------------------------------------------------------------------------------------------------------
GET.PROPERTY.OLD:
* Get the property Name for the property class

    ARR.INFO = ''
    R.ARRANGEMENT = ''
    AA.PROPERTY = ''

    ARR.INFO<1> = R.OLD(INS.DET.ASSOCIATED.LOAN)
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
***</region>

*** <region name=TRIGGER.OFS>
*-----------------------------------------------------------------------------------------------------------
TRIGGER.OFS:

* This posts the OFS message formed to the OFS.MESSAGE.QUEUE for processing
*

    OFS.MSG.ID = ''
    OFS.SOURCE = 'TRIGGER.INSURANCE'
    OFS.ERR = ''

    CALL OFS.POST.MESSAGE(PROCESS.MSG,OFS.MSG.ID,OFS.SOURCE,OFS.ERR)

RETURN

*-----------------------------------------------------------------------------------------------------------
***</region>


END
