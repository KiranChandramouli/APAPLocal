* @ValidationCode : MjotMTE5MjAxMjE1MDpDcDEyNTI6MTY4NDQ5MTAzMjYwMjpJVFNTOi0xOi0xOjYxNzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 617
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION     FM TO @FM, VM TO @VM, SM TO @SM
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.E.APAP.NOF.LOAN.REPORT(LN.ARRAY)
*----------------------------------------------------------------------------------------
*Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By  : Temenos Application Management
*Program Name  : REDO.E.APAP.NOF.LOAN.REPORT
*----------------------------------------------------------------------------------------
*Description   : This is a no file enquiry routine for display REPORT ON LIFE AND FIRE INSURANCE
*Linked With   : Enquiry REDO.APAP.NOF.LOAN.REPORT
*In Parameter  : N/A
*Out Parameter : LN.ARRAY
*----------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*   Date             Who                  Reference               Description
*----------------------------------------------------------------------------------------
*  24th Aug 2010    BHARATH G             ODR-2010-03-0084         Initial Creation
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.REDO.T.AUTH.ARRANGEMENT
*----------------------------------------------------------------------------------------
*
    GOSUB INIT
    GOSUB GET.LOCAL.REF
    GOSUB LOCATE.VALUE
    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------------------------
*Initialise the variables

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    R.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    R.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.T.AUTH.ARRANGEMENT = 'F.REDO.T.AUTH.ARRANGEMENT'
    F.REDO.T.AUTH.ARRANGEMENT  = ''
    R.REDO.T.AUTH.ARRANGEMENT  = ''
    CALL OPF(FN.REDO.T.AUTH.ARRANGEMENT,F.REDO.T.AUTH.ARRANGEMENT)

    FN.APAP.H.INSURANCE.DETAILS = 'F.APAP.H.INSURANCE.DETAILS'
    F.APAP.H.INSURANCE.DETAILS  = ''
    R.APAP.H.INSURANCE.DETAILS  = ''
    CALL OPF(FN.APAP.H.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS)

    Y.DATE                  = ''
    Y.INSURANCE.COMPANY     = 'All'
    Y.POLICY.NUMBER         = 'All'
    Y.POLICY.TYPE           = 'All'
    Y.POLICY.CLASS          = 'Group or endorsed'
    Y.MOVEMENT.TYPE         = 'All'
    Y.LOAN.NUMBER           = ''
    Y.PREVIOUS.LOAN.NUMBER  = ''
    Y.INSURANCE.COMP        = ''
    Y.POL.CLASS             = ''
    Y.CLIENT.NAME           = ''
    Y.TERM                  = ''
    Y.TYPE.OF.POLICY        = ''
    Y.POL.NUMBER            = ''
    Y.MOVEMENT.DATE         = ''
    Y.TYPE.OF.MOVEMENT      = ''
    Y.SECURED.AMOUNT        = ''
    Y.PREMIUM.VALUE         = ''
    Y.EXTRA.PREMIUM.VALUE   = ''

RETURN
*----------------------------------------------------------------------------------------
GET.LOCAL.REF:
*----------------------------------------------------------------------------------------
*This section gets the position of the local reference fields


    Y.APPLN = "AA.PRD.DES.CHARGE":@FM:"AA.PRD.DES.CUSTOMER":@FM:"AA.PRD.DES.TERM.AMOUNT"

    Y.FIELDS = "CLASS.POLICY":@VM:"INS.POLICY.TYPE":@VM:"POLICY.NUMBER":@VM:"MON.POL.AMT"
    Y.FIELDS = Y.FIELDS:@VM:"EXTRA.AMT":@FM:"INS.COMPANY":@FM:"INS.AMOUNT"

    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPLN,Y.FIELDS,FIELD.POS)

    CLASS.POL.POS      = FIELD.POS<1,1>
    TYPE.OF.POLICY.POS = FIELD.POS<1,2>
    POLICY.NUM.POS     = FIELD.POS<1,3>
    MON.POL.AMT.POS    = FIELD.POS<1,4>
    EXTRA.AMT.POS      = FIELD.POS<1,5>
    INS.COMP.POS       = FIELD.POS<2,1>
    INS.AMOUNT.POS     = FIELD.POS<3,1>

RETURN
*----------------------------------------------------------------------------------------
LOCATE.VALUE:
*----------------------------------------------------------------------------------------
* Locate selection crieteria field values

    Y.ALLOC.FLAG = ''

    SEL.CMD.LOAN = 'SELECT ':FN.REDO.T.AUTH.ARRANGEMENT

    LOCATE "POL.START.DATE" IN D.FIELDS<1> SETTING POL.START.DATE.POS THEN
        Y.POL.START.DATE.OPR           = D.LOGICAL.OPERANDS<POL.START.DATE.POS>
        Y.POL.START.DATE.VAL           = D.RANGE.AND.VALUE<POL.START.DATE.POS>
        Y.DATE                  = Y.POL.START.DATE.VAL

        CHANGE @SM TO ' ' IN Y.POL.START.DATE.VAL
        Y.OPERAND = Y.POL.START.DATE.OPR
        GOSUB OPERAND
        Y.POL.START.DATE.OPR = Y.OPERAND
        SEL.CMD.LOAN := " WITH POL.START.DATE ":Y.POL.START.DATE.OPR:" ":Y.POL.START.DATE.VAL
        Y.ALLOC.FLAG = 1
    END

    LOCATE "INS.COMPANY" IN D.FIELDS<1> SETTING INS.COMPANY.POS  THEN
        Y.INS.COMPANY.OPR         = D.LOGICAL.OPERANDS<INS.COMPANY.POS>
        Y.INS.COMPANY.VAL         = D.RANGE.AND.VALUE<INS.COMPANY.POS>
        Y.INSURANCE.COMPANY     = Y.INS.COMPANY.VAL

        CHANGE @SM TO ' ' IN Y.INS.COMPANY.VAL
        Y.OPERAND = Y.INS.COMPANY.OPR
        GOSUB OPERAND
        Y.INS.COMPANY.OPR = Y.OPERAND
        IF Y.ALLOC.FLAG EQ 1 THEN
            SEL.CMD.LOAN := " AND INS.COMPANY ":Y.INS.COMPANY.OPR:" ":Y.INS.COMPANY.VAL
        END
        ELSE
            SEL.CMD.LOAN := " WITH INS.COMPANY ":Y.INS.COMPANY.OPR:" ":Y.INS.COMPANY.VAL
        END
        Y.ALLOC.FLAG = 1
    END

    LOCATE "INS.POLICY.TYPE" IN D.FIELDS<1> SETTING  INS.POLICY.TYPE.POS THEN
        Y.INS.POLICY.TYPE.OPR           = D.LOGICAL.OPERANDS<INS.POLICY.TYPE.POS>
        Y.INS.POLICY.TYPE.VAL           = D.RANGE.AND.VALUE<INS.POLICY.TYPE.POS>
        Y.POLICY.TYPE           = Y.INS.POLICY.TYPE.VAL

        CHANGE @SM TO ' ' IN Y.INS.POLICY.TYPE.VAL
        Y.OPERAND = Y.INS.POLICY.TYPE.OPR
        GOSUB OPERAND
        Y.INS.POLICY.TYPE.OPR = Y.OPERAND
        IF Y.ALLOC.FLAG EQ 1 THEN
            SEL.CMD.LOAN := " AND INS.POLICY.TYPE ":Y.INS.POLICY.TYPE.OPR:" ":Y.INS.POLICY.TYPE.VAL
        END
        ELSE
            SEL.CMD.LOAN := " WITH INS.POLICY.TYPE ":Y.INS.POLICY.TYPE.OPR:" ":Y.INS.POLICY.TYPE.VAL
        END
        Y.ALLOC.FLAG = 1
    END

    LOCATE "CLASS.POLICY" IN D.FIELDS<1> SETTING CLASS.POLICY.POS THEN
        Y.CLASS.POLICY.OPR           = D.LOGICAL.OPERANDS<CLASS.POLICY.POS>
        Y.CLASS.POLICY.VAL           = D.RANGE.AND.VALUE<CLASS.POLICY.POS>
        Y.POLICY.CLASS          = Y.CLASS.POLICY.VAL

        CHANGE @SM TO ' ' IN Y.CLASS.POLICY.VAL
        Y.OPERAND = Y.CLASS.POLICY.OPR
        GOSUB OPERAND
        Y.CLASS.POLICY.OPR = Y.OPERAND
        IF Y.ALLOC.FLAG EQ 1 THEN
            SEL.CMD.LOAN := " AND CLASS.POLICY ":Y.CLASS.POLICY.OPR:" ":Y.CLASS.POLICY.VAL
        END
        ELSE
            SEL.CMD.LOAN := " WITH CLASS.POLICY ":Y.CLASS.POLICY.OPR:" ":Y.CLASS.POLICY.VAL
        END
        Y.ALLOC.FLAG = 1
    END

    LOCATE "POLICY.NUMBER" IN D.FIELDS<1> SETTING POLICY.NUMBER.POS THEN
        Y.POLICY.NUMBER.OPR           = D.LOGICAL.OPERANDS<POLICY.NUMBER.POS>
        Y.POLICY.NUMBER.VAL           = D.RANGE.AND.VALUE<POLICY.NUMBER.POS>
        Y.POLICY.NUMBER         = Y.POLICY.NUMBER.VAL
        CHANGE @SM TO ' ' IN Y.POLICY.NUMBER.VAL
        Y.OPERAND = Y.POLICY.NUMBER.OPR
        GOSUB OPERAND
        Y.POLICY.NUMBER.OPR = Y.OPERAND
        IF Y.ALLOC.FLAG EQ 1 THEN
            SEL.CMD.LOAN := " AND POLICY.NUMBER ":Y.POLICY.NUMBER.OPR:" ":Y.POLICY.NUMBER.VAL
        END
        ELSE
            SEL.CMD.LOAN := " WITH POLICY.NUMBER ":Y.POLICY.NUMBER.VAL" ":Y.POLICY.NUMBER.VAL
        END
        Y.ALLOC.FLAG = 1
    END
    Y.CANCEL.REASON.VAL = ''
    LOCATE "CANCEL.REASON" IN D.FIELDS<1> SETTING CANCEL.REASON.POS THEN
        Y.CANCEL.REASON.VAL           = D.RANGE.AND.VALUE<CANCEL.REASON.POS>
    END

    Y.MODIFICATION.TYPE = "All":@FM:"Inclusions":@FM:"Exclusions":@FM:"Modifications"

    IF Y.CANCEL.REASON.VAL NE '' THEN
        LOCATE Y.CANCEL.REASON.VAL IN Y.MODIFICATION.TYPE SETTING POS ELSE
            ENQ.ERROR = "EB-INVALID.MOV.TYPE"
            GOSUB PGM.END
        END
    END
    IF Y.CANCEL.REASON.VAL EQ '' THEN
        Y.CANCEL.REASON.VAL = 'All'
    END

RETURN
*----------------------------------------------------------------------------------------
OPERAND:
*----------------------------------------------------------------------------------------
*
    BEGIN CASE
        CASE Y.OPERAND EQ "1"
            Y.OPERAND = "EQ"
        CASE Y.OPERAND EQ "5"
            Y.OPERAND = "NE"
        CASE Y.OPERAND EQ "3"
            Y.OPERAND = "LT"
        CASE Y.OPERAND EQ "8"
            Y.OPERAND = "LE"
        CASE Y.OPERAND EQ "4"
            Y.OPERAND = "GT"
        CASE Y.OPERAND EQ "9"
            Y.OPERAND = "GE"
        CASE Y.OPERAND EQ "6"
            Y.OPERAND = "LIKE"
        CASE Y.OPERAND EQ "7"
            Y.OPERAND = "UNLIKE"
    END CASE

RETURN
*----------------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------------
*This section explains the Main process flow for displaying the loan disbursement itemization
*
    CALL EB.READLIST(SEL.CMD.LOAN,SEL.LIST.LOAN,'',NO.OF.REC,SEL.ERR.AA)

    LOOP
        REMOVE Y.AA.ID FROM SEL.LIST.LOAN SETTING AA.POS
    WHILE Y.AA.ID : AA.POS
        GOSUB FORM.SEL.CMD
        SEL.LIST = ''
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
        IF SEL.LIST NE '' THEN
            GOSUB SUB.PROCESS
        END

    REPEAT

RETURN
*----------------------------------------------------------------------------------------
SUB.PROCESS:
*----------------------------------------------------------------------------------------
*
    Y.LOAN.NUMBER           = Y.AA.ID

    idPropertyClass = "ACCOUNT"
    GOSUB GET.ARRANGEMENT.CONDITIONS
    IF R.CONDITION NE '' THEN
        Y.PREVIOUS.LOAN.NUMBER  = R.CONDITION<AA.AC.ALT.ID>
    END

    idPropertyClass = "CUSTOMER"
    GOSUB GET.ARRANGEMENT.CONDITIONS
    IF R.CONDITION NE '' THEN
        Y.INSURANCE.COMP       = R.CONDITION<AA.CUS.LOCAL.REF,INS.COMP.POS>
    END

    idPropertyClass = "CHARGE"
    GOSUB GET.ARRANGEMENT.CONDITIONS
    IF R.CONDITION NE '' THEN
        Y.POL.CLASS             = R.CONDITION<AA.CHG.LOCAL.REF,CLASS.POL.POS>
        Y.TYPE.OF.POLICY        = R.CONDITION<AA.CHG.LOCAL.REF,TYPE.OF.POLICY.POS>
        Y.POL.NUMBER            = R.CONDITION<AA.CHG.LOCAL.REF,POLICY.NUM.POS>
        Y.PREMIUM.VALUE         = R.CONDITION<AA.CHG.LOCAL.REF,MON.POL.AMT.POS>
        Y.EXTRA.PREMIUM.VALUE   = R.CONDITION<AA.CHG.LOCAL.REF,EXTRA.AMT.POS>
    END

    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)
    IF R.AA.ARRANGEMENT THEN
        CUST.ID = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
        CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUSTOMER,F.CUSTOMER,CUST.ERR)
        IF R.CUSTOMER THEN
            Y.CLIENT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
        END
    END

    idPropertyClass = "TERM.AMOUNT"
    GOSUB GET.ARRANGEMENT.CONDITIONS
    IF R.CONDITION NE '' THEN
        Y.TERM                  = R.CONDITION<AA.AMT.TERM>
        Y.SECURED.AMOUNT        = R.CONDITION<AA.AMT.LOCAL.REF,INS.AMOUNT.POS>
    END

    INS.DTL.ID = SEL.LIST<1,1>
    CALL F.READ(FN.APAP.H.INSURANCE.DETAILS,INS.DTL.ID,R.APAP.H.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS,INS.DTL.ERR)
    IF R.APAP.H.INSURANCE.DETAILS THEN

        Y.MOVEMENT.DATE         = R.APAP.H.INSURANCE.DETAILS<INS.DET.DATE.TIME>

    END

    Y.TYPE.OF.MOVEMENT      = Y.CANCEL.REASON.VAL

    GOSUB FINAL.ARRAY

RETURN
*----------------------------------------------------------------------------------------
GET.ARRANGEMENT.CONDITIONS:
*----------------------------------------------------------------------------------------
* Call AA.GET.ARRANGEMENT.CONDITIONS to get the arrangement condition record

    ArrangementID = Y.AA.ID
    idProperty = ''
    effectiveDate = ''
    returnIds = ''
    returnConditions = ''
    returnError = ''
    R.CONDITION = ''

*  Call AA.GET.ARRANGEMENT.CONDITIONS to get the arrangement condition record
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    IF returnError THEN
        RETURN
    END
    R.CONDITION = RAISE(returnConditions)

RETURN
*----------------------------------------------------------------------------------------
FORM.SEL.CMD:
*----------------------------------------------------------------------------------------
*
    BEGIN CASE
        CASE Y.CANCEL.REASON.VAL EQ "All"
            SEL.CMD = "SELECT ":FN.APAP.H.INSURANCE.DETAILS:" WITH ASSOCIATED.LOAN EQ ":Y.AA.ID

        CASE Y.CANCEL.REASON.VAL EQ "Inclusions"
            SEL.CMD = "SELECT ":FN.APAP.H.INSURANCE.DETAILS:" WITH ASSOCIATED.LOAN EQ ":Y.AA.ID:" AND CANCEL.REASON EQ Policy Substitution"

        CASE Y.CANCEL.REASON.VAL EQ "Exclusions"
            SEL.CMD = "SELECT ":FN.APAP.H.INSURANCE.DETAILS:" WITH ASSOCIATED.LOAN EQ ":Y.AA.ID:" AND CANCEL.REASON EQ Loan cancellation"

        CASE Y.CANCEL.REASON.VAL EQ "Modifications"
            SEL.CMD = "SELECT ":FN.APAP.H.INSURANCE.DETAILS:" WITH ASSOCIATED.LOAN EQ ":Y.AA.ID:" AND CURR.NO GT 1"
    END CASE

RETURN
*----------------------------------------------------------------------------------------
FINAL.ARRAY:
*----------------------------------------------------------------------------------------
*
    IF LN.ARRAY EQ '' THEN
        LN.ARRAY = Y.DATE:'*':Y.INSURANCE.COMPANY:'*':Y.POLICY.NUMBER:'*':Y.POLICY.TYPE:'*':Y.POLICY.CLASS:'*':Y.MOVEMENT.TYPE:'*':Y.INSURANCE.COMP:'*':Y.POL.CLASS:'*':Y.LOAN.NUMBER:'*':Y.PREVIOUS.LOAN.NUMBER:'*':Y.CLIENT.NAME:'*':Y.TERM:'*':Y.TYPE.OF.POLICY:'*':Y.POL.NUMBER:'*':Y.MOVEMENT.DATE:'*':Y.TYPE.OF.MOVEMENT:'*':Y.SECURED.AMOUNT:'*':Y.PREMIUM.VALUE:'*':Y.EXTRA.PREMIUM.VALUE
    END
    ELSE
        LN.ARRAY<-1> = Y.DATE:'*':Y.INSURANCE.COMPANY:'*':Y.POLICY.NUMBER:'*':Y.POLICY.TYPE:'*':Y.POLICY.CLASS:'*':Y.MOVEMENT.TYPE:'*':Y.INSURANCE.COMP:'*':Y.POL.CLASS:'*':Y.LOAN.NUMBER:'*':Y.PREVIOUS.LOAN.NUMBER:'*':Y.CLIENT.NAME:'*':Y.TERM:'*':Y.TYPE.OF.POLICY:'*':Y.POL.NUMBER:'*':Y.MOVEMENT.DATE:'*':Y.TYPE.OF.MOVEMENT:'*':Y.SECURED.AMOUNT:'*':Y.PREMIUM.VALUE:'*':Y.EXTRA.PREMIUM.VALUE

    END

RETURN
*----------------------------------------------------------------------------------------
PGM.END:
*----------------------------------------------------------------------------------------
*
END
*----------------------------------------------------------------------------------------
