* @ValidationCode : MjotMTYzODQ4MDQwNDpDcDEyNTI6MTY4NTk0OTIzMzYwODpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jun 2023 12:43:53
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOFILE.CANC.LOAN.DET(LN.ARRAY)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : T.Jeeva, Temenos Application Management
*Program   Name    : REDO.APAP.NOFILE.CANC.LOAN.DET
*ODR Reference     : ODR-2010-03-0171
*--------------------------------------------------------------------------------------------------------
*Description  : This is nofile enquiry routine is used to retrieve the cancelled loans satisfying the criteria
*In Parameter : N/A
*Out Parameter: LN.ARRAY
*LINKED WITH  : STANDARD.SELECTION>NOFILE.REDO.CANC.LOAN.DET
*Modification History:
*DATE              WHO                REFERENCE                        DESCRIPTION
*23-05-2023      MOHANRAJ R        AUTO R22 CODE CONVERSION          VM TO @VM,FM TO @FM,SM TO @SM,++ TO +=1
*23-05-2023      MOHANRAJ R        MANUAL R22 CODE CONVERSION         changed to AA.CUS.CUSTOMER
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.COMPANY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.COLLATERAL
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.REDO.AA.PAYOFF.DETAILS

    GOSUB OPENFILES
    GOSUB GET.LR.FLD.POS
    GOSUB LOCATE.VALUE
    GOSUB PROCESS

RETURN

*-----------------------------------------------------------------------------
GET.LR.FLD.POS:
*-----------------------------------------------------------------------------

    Y.LRF.APPL = "AA.ARR.TERM.AMOUNT":@FM:"AA.ARR.CHARGE":@FM:"COLLATERAL"
    Y.LRF.FIELDS = "L.AA.COL":@FM:"INS.POLICY.TYPE":@VM:"POLICY.NUMBER":@FM:"L.COL.SEC.STA":@VM:"L.CO.LOC.STATUS"
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(Y.LRF.APPL,Y.LRF.FIELDS,FIELD.POS)

    L.AA.COL.POS=FIELD.POS<1,1>
    POLICY.POS=FIELD.POS<2,1>
    P.NUM.POS=FIELD.POS<2,2>
    L.COL.SEC.STA.POS=FIELD.POS<3,1>
    L.CO.LOC.STATUS.POS=FIELD.POS<3,2>

RETURN
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    FN.AA.ACCOUNT='F.AA.ACCOUNT'
    F.AA.ACCOUNT=''
    CALL OPF(FN.AA.ACCOUNT,F.AA.ACCOUNT)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.AA.PAYOFF.DETAILS='F.REDO.AA.PAYOFF.DETAILS'
    F.REDO.AA.PAYOFF.DETAILS=''
    CALL OPF(FN.REDO.AA.PAYOFF.DETAILS,F.REDO.AA.PAYOFF.DETAILS)

    FN.AA.BILL.DETAILS='F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS=''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

    FN.AA.INTEREST.ACCRUALS='F.AA.INTEREST.ACCRUALS'
    F.AA.INTEREST.ACCRUALS=''
    CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS=''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.COMPANY ='F.COMPANY'; F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

    FN.CUSTOMER='F.CUSTOMER'; F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'; F.AA.ARRANGEMENT.ACTIVITY = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

    FN.AA.ARR.ACCOUNT = 'F.AA.ARR.ACCOUNT'; F.AA.ARR.ACCOUNT = ''
    CALL OPF(FN.AA.ARR.ACCOUNT,F.AA.ARR.ACCOUNT)

    FN.COLLATERAL='F.COLLATERAL'; F.COLLATERAL=''
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)

    FN.DEPT.ACCT.OFFICER='F.DEPT.ACCT.OFFICER'; F.DEPT.ACCT.OFFICER=''
    CALL OPF(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)
RETURN
*-----------------------------------------------------------------------------
NULLIFY:
*-----------------------------------------------------------------------------

    Y.GUARANTEE.LOC='';Y.LOAN.NUMBER= '' ;Y.PREVIOUS.LOAN.NUMBER ='' ; Y.AGENCY =''; Y.REGION.NUMBER ='' ; Y.PRODUCT ='' ; Y.CLIENT.NAME ='';Y.CURRECNY ='';Y.OPENING.DATE=''; Y.AMOUNT='0.00';Y.INTEREST='0.00';Y.DISB.AMOUNT='0.00';Y.POLICY.NUMBER='' ;Y.PROPERTY.NUMBER='';Y.FHA.NUMBER='';Y.GUARANTEE.LOCATION='';Y.GUARANTEE.TYPE='';Y.GUARANTEE.NUMBER='';Y.GUARANTEE.STATUS='';Y.CANCEL.DATE='';Y.WAY.PAYMENT=''; Y.CANCEL.AGENCY ='';Y.CANCEL.USER='';Y.TOT.CANCEL.AMT='0.00';Y.TOTAL.BALANCE.DUE='0.00';Y.COMMISSION.CHARGE.BALANCE='0.00'
    Y.CANCEL.CHARAGE.AMOUNT='0.00';Y.CANCEL.CAPITAL.AMOUNT='0.00';Y.CANCEL.INT.AMOUNT='0.00' ; Y.AA.ID.FLAG = '' ; Y.GUARANTEE.FLAG = ''

RETURN
*-----------------------------------------------------------------------------
LOCATE.VALUE:
*-----------------------------------------------------------------------------
    LOCATE "LOAN.ORIGIN.AGENCY" IN D.FIELDS<1> SETTING Y.AGENCY.POS  THEN
        Y.AGENCY.VAL= D.RANGE.AND.VALUE<Y.AGENCY.POS>
        CHANGE @SM TO ' ' IN Y.AGENCY.VAL
    END
    LOCATE "GUARANTEE.TYPE" IN D.FIELDS<1> SETTING Y.GUARANTEE.TYPE.POS  THEN
        Y.GUARANTEE.TYPE.VAL= D.RANGE.AND.VALUE<Y.GUARANTEE.TYPE.POS>
        CHANGE @SM TO ' ' IN Y.GUARANTEE.TYPE.VAL
    END
    LOCATE "GUARANTEE.STATUS" IN D.FIELDS<1> SETTING Y.GUARANTEE.STATUS.POS  THEN
        Y.GUARANTEE.STATUS.VAL= D.RANGE.AND.VALUE<Y.GUARANTEE.STATUS.POS>
        CHANGE @SM TO ' ' IN Y.GUARANTEE.STATUS.VAL
    END
    LOCATE "GUARANTEE.LOCATION" IN D.FIELDS<1> SETTING Y.GUARANTEE.LOC.POS  THEN
        Y.GUARANTEE.LOC.VAL= D.RANGE.AND.VALUE<Y.GUARANTEE.LOC.POS>
        CHANGE @SM TO ' ' IN Y.GUARANTEE.LOC.VAL
    END
    LOCATE "PRODUCT" IN D.FIELDS<1> SETTING Y.PRODUCT.TYPE.POS THEN
        Y.PRODUCT.TYPE.VAL= D.RANGE.AND.VALUE<Y.PRODUCT.TYPE.POS>
        CHANGE @SM TO ' ' IN Y.PRODUCT.TYPE.VAL
    END
    LOCATE "LOAN.PORTFOLIO.TYP" IN D.FIELDS<1> SETTING Y.LOAN.PORTFOLIO.TYPE.POS THEN
        Y.LOAN.PORTFOLIO.TYPE.VAL= D.RANGE.AND.VALUE<Y.LOAN.PORTFOLIO.TYPE.POS>
        CHANGE @SM TO ' ' IN Y.LOAN.PORTFOLIO.TYPE.VAL
    END
    LOCATE "REGION" IN D.FIELDS<1> SETTING Y.REGION.POS THEN
        Y.REGION.VAL= D.RANGE.AND.VALUE<Y.REGION.POS>
        CHANGE @SM TO ' ' IN Y.REGION.VAL
    END
    LOCATE "CANCEL.DATE.FROM" IN D.FIELDS<1> SETTING Y.CANC.DATE.FROM.POS THEN
        Y.CANC.DATE.FROM.VAL= D.RANGE.AND.VALUE<Y.CANC.DATE.FROM.POS>
        CHANGE @SM TO ' ' IN Y.CANC.DATE.FROM.VAL
    END
    LOCATE "CANCEL.DATE.UNTIL" IN D.FIELDS<1> SETTING Y.CANC.DATE.TO.POS THEN
        Y.CANC.DATE.TO.VAL= D.RANGE.AND.VALUE<Y.CANC.DATE.TO.POS>
        CHANGE @SM TO ' ' IN Y.CANC.DATE.TO.VAL
    END
RETURN
*-----------------------------------------------------------------------------
ARR.READ:
*-----------------------------------------------------------------------------

    CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.AAA.ID,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,Y.ERR.AAA)
    IF R.AA.ARRANGEMENT.ACTIVITY EQ '' THEN
        Y.AA.ID.FLAG = '1'
    END
    Y.AA.ID=R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.ARRANGEMENT>
    Y.EFF.DATE=R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.EFFECTIVE.DATE>
    Y.ACT.CLASS=R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.ACTIVITY.CLASS>
    IF Y.TOT.CANCEL.AMT EQ '' THEN
        Y.TOT.CANCEL.AMT=R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.AMOUNT>
    END ELSE
        Y.TOT.CANCEL.AMT = Y.TOT.CANCEL.AMT + R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.AMOUNT>
    END
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    GOSUB ERROR.CHECK
    GOSUB SELECT.CMD

    CALL EB.READLIST(SEL.CMD.AA,SEL.LIST.AA,'',NO.OF.AA.REC,SEL.ERR.AA)
    LOOP
        REMOVE Y.AAA.ID FROM SEL.LIST.AA SETTING AAA.POS
    WHILE Y.AAA.ID : AAA.POS
        GOSUB NULLIFY
        GOSUB ARR.READ
        GOSUB WAY.PAYMENT
        GOSUB DISBURSED.AMT
        CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,Y.ERR.AA)
        Y.ACC.ID=R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
        IF Y.ACC.ID NE '' THEN
            CALL REDO.E.NOF.GET.REGION(Y.ACC.ID,Y.REGION.VAL,Y.REGION,Y.REGION.NUMBER,Y.REGION.FLAG)
        END
        GOSUB ASSIGN.VALUES
        GOSUB CHECK
        GOSUB FINAL.ARRAY
    REPEAT
RETURN
*-----------------------------------------------------------------------------
ERROR.CHECK:
*-----------------------------------------------------------------------------
    IF Y.GUARANTEE.LOC.VAL NE '' THEN
        Y.GUA.LOCATION = "In External Legal Department":@FM:"In Registry of Titles":@FM:"In External collecting Agency":@FM:"In Vault"
        LOCATE Y.GUARANTEE.LOC.VAL IN Y.GUA.LOCATION SETTING GU.POS THEN
        END ELSE
            ENQ.ERROR = "EB-INVALID.GUA.LOCATION"
        END
    END
    IF Y.GUARANTEE.STATUS.VAL NE '' THEN
        Y.GUA.TYPE = "Interface":@FM:"Inuse":@FM:"Liquidated":@FM:"Override"
        LOCATE Y.GUARANTEE.STATUS.VAL IN Y.GUA.TYPE SETTING GU.TYP.POS THEN
        END ELSE
            ENQ.ERROR = "EB-INVALID.GUA.TYPE"
        END
    END


RETURN
*-----------------------------------------------------------------------------
WAY.PAYMENT:
*-----------------------------------------------------------------------------

    Y.TXN.SYS.ID=R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.SYSTEM.ID>
    Y.TXN.CONT.ID =R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.CONTRACT.ID>
    CALL REDO.E.NOF.PAYMENT.TYPE(Y.TXN.SYS.ID,Y.TXN.CONT.ID,Y.CANCEL.AGENCY,Y.CANCEL.USER)
    IF Y.TXN.SYS.ID EQ 'TT' THEN
        Y.WAY.PAYMENT='CASH'
    END
    IF Y.TXN.SYS.ID EQ 'FT' THEN
        Y.WAY.PAYMENT='TRANSFER'
    END
RETURN
*-----------------------------------------------------------------------------
SELECT.CMD:
*-----------------------------------------------------------------------------
    SEL.CMD.AA = "SELECT ":FN.REDO.AA.PAYOFF.DETAILS

    IF Y.CANC.DATE.FROM.VAL NE '' THEN
        SEL.CMD.AA:= " WITH (PAYOFF.DATE GE ":Y.CANC.DATE.FROM.VAL:")"
    END

    IF Y.CANC.DATE.TO.VAL NE '' THEN
        SEL.CMD.AA:= " AND WITH (PAYOFF.DATE LE ":Y.CANC.DATE.TO.VAL:")"
    END

RETURN
*-----------------------------------------------------------------------------
CHECK:
*-----------------------------------------------------------------------------

    IF Y.AGENCY.VAL NE '' THEN
        Y.CO.CODE=R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
        IF Y.AGENCY.VAL NE Y.CO.CODE THEN
            Y.AGENCY.FLAG ='1'
        END
    END
    IF Y.GUARANTEE.TYPE.VAL NE '' THEN
        IF Y.GUARANTEE.TYPE.VAL NE Y.GUARANTEE.TYPE THEN
            Y.GUARANTEE.TYPE.FLAG ='1'
        END
    END
    IF Y.GUARANTEE.STATUS.VAL NE '' THEN
        IF Y.GUARANTEE.STATUS.VAL NE Y.GUARANTEE.STATUS THEN
            Y.GUARANTEE.STATUS.FLAG ='1'
        END
    END
    IF Y.PRODUCT.TYPE.VAL NE '' THEN
        Y.PRODUCT.TYPE=R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
        IF Y.PRODUCT.TYPE.VAL NE Y.PRODUCT.TYPE THEN
            Y.PRODUCT.FLAG ='1'
        END
    END
    IF Y.LOAN.PORTFOLIO.TYPE.VAL NE '' THEN
        Y.LOAN.PORTFOLIO = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
        IF Y.LOAN.PORTFOLIO.TYPE.VAL NE Y.LOAN.PORTFOLIO THEN
            Y.LOAN.PORTFOLIO.FLAG ='1'
        END
    END
RETURN
*-----------------------------------------------------------------------------
ACCOUNT.CLASS:
*-----------------------------------------------------------------------------
    idPropertyClass = "ACCOUNT"
    GOSUB ARR.CONDITIONS
    IF returnError THEN
        RETURN
    END
    R.CONDITION = RAISE(returnConditions)
    IF R.CONDITION THEN
        Y.PREVIOUS.LOAN.NUMBER=R.CONDITION<AA.AC.ALT.ID>
    END
RETURN
*-----------------------------------------------------------------------------
CHARGE.CLASS:
*-----------------------------------------------------------------------------
    idPropertyClass = "CHARGE"
    GOSUB ARR.CONDITIONS
    IF returnError THEN
        RETURN
    END
    R.CONDITION = RAISE(returnConditions)
    IF R.CONDITION THEN
        Y.POLICY.TYPE=R.CONDITION<AA.CHG.LOCAL.REF><1,POLICY.POS>
        Y.POLICY.CNT=DCOUNT(Y.POLICY.TYPE,@SM)
        CHANGE @SM TO @FM IN Y.POLICY.TYPE
        Y.COUNT =1
        LOOP
        WHILE Y.COUNT LE Y.POLICY.CNT
            Y.POLICY=Y.POLICY.TYPE<Y.COUNT>
            GOSUB POLICY.CHECK
            Y.COUNT += 1
        REPEAT
    END
RETURN
*-----------------------------------------------------------------------------
POLICY.CHECK:
*-----------------------------------------------------------------------------

    IF Y.POLICY EQ 'VI' OR Y.POLICY EQ 'VU' THEN
        IF Y.POLICY.NUMBER EQ '' THEN
            Y.POLICY.NUMBER=R.CONDITION<AA.CHG.LOCAL.REF><1,P.NUM.POS,Y.COUNT>
        END ELSE
            Y.POLICY.NUMBER := @VM:R.CONDITION<AA.CHG.LOCAL.REF><1,P.NUM.POS,Y.COUNT>
        END
    END
    IF Y.POLICY EQ 'PVP' OR Y.POLICY EQ 'PVC' THEN
        IF Y.PROPERTY.NUMBER EQ '' THEN
            Y.PROPERTY.NUMBER=R.CONDITION<AA.CHG.LOCAL.REF><1,P.NUM.POS,Y.COUNT>
        END ELSE
            Y.PROPERTY.NUMBER := @VM:R.CONDITION<AA.CHG.LOCAL.REF><1,P.NUM.POS,Y.COUNT>
        END
    END
    IF Y.POLICY EQ 'FHA' THEN
        IF Y.FHA.NUMBER EQ '' THEN
            Y.FHA.NUMBER =R.CONDITION<AA.CHG.LOCAL.REF><1,P.NUM.POS,Y.COUNT>
        END ELSE
            Y.FHA.NUMBER := @VM:R.CONDITION<AA.CHG.LOCAL.REF><1,P.NUM.POS,Y.COUNT>
        END
    END
RETURN
*-----------------------------------------------------------------------------
TERM.AMOUNT.CLASS:
*-----------------------------------------------------------------------------
    idPropertyClass = "TERM.AMOUNT"
    GOSUB ARR.CONDITIONS

    IF returnError THEN
        RETURN
    END
    R.CONDITION = RAISE(returnConditions)
    IF R.CONDITION THEN
        Y.GUARANTEE.NUMBER=R.CONDITION<AA.AMT.LOCAL.REF,L.AA.COL.POS>
        Y.AMOUNT=R.CONDITION<AA.AMT.AMOUNT>
        CALL F.READ(FN.COLLATERAL,Y.GUARANTEE.NUMBER,R.COLLATERAL,F.COLLATERAL,Y.COLLATERAL.ERR)
        Y.GUARANTEE.STATUS=R.COLLATERAL<COLL.LOCAL.REF,L.COL.SEC.STA.POS>
        Y.GUARANTEE.TYPE=R.COLLATERAL<COLL.COLLATERAL.CODE>
        Y.GUARANTEE.LOC=R.COLLATERAL<COLL.LOCAL.REF><1,L.CO.LOC.STATUS.POS>
        CHANGE @VM TO @FM IN Y.GUARANTEE.LOC
        CHANGE @SM TO @FM IN Y.GUARANTEE.LOC

        Y.GUARANTEE.LOCATION = Y.GUARANTEE.LOC
        GOSUB GUARANTEE.LOC.CHECK
    END

RETURN
*-----------------------------------------------------------------------------
GUARANTEE.LOC.CHECK:
*-----------------------------------------------------------------------------

    IF Y.GUARANTEE.LOC.VAL NE '' THEN

        LOCATE Y.GUARANTEE.LOC.VAL IN Y.GUARANTEE.LOC SETTING G.POS ELSE
            Y.GUARANTEE.FLAG = '1'
        END
    END
RETURN
*-----------------------------------------------------------------------------
ASSIGN.VALUES:
*-----------------------------------------------------------------------------
    GOSUB ACCOUNT.CLASS
    GOSUB CHARGE.CLASS
    GOSUB TERM.AMOUNT.CLASS
    GOSUB CUSTOMER.CLASS

    Y.LOAN.NUMBER=Y.AA.ID
    Y.PRODUCT=R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    Y.AGENCY=R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
    Y.CURRECNY=R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
    Y.OPENING.DATE=R.AA.ARRANGEMENT<AA.ARR.PROD.EFF.DATE>
    Y.CANCEL.DATE=Y.EFF.DATE
    CALL REDO.INT.PROPERTY(Y.AA.ID,Y.EFF.DATE,Y.INTEREST,Y.INT.FLAG)
    CALL REDO.E.NOF.BILL.AMOUNT(Y.AA.ID,Y.CANCEL.CHARAGE.AMOUNT,Y.CANCEL.CAPITAL.AMOUNT,Y.CANCEL.INT.AMOUNT)
    CALL REDO.E.NOF.BILL.DETAILS(Y.AA.ID,Y.TOTAL.BALANCE.DUE,Y.COMMISSION.CHARGE.BALANCE)

RETURN
*-----------------------------------------------------------------------------
GET.ACTIVITY:
*-----------------------------------------------------------------------------
    PROP.CLASS='TERM.AMOUNT'
    PROPERTY = ''
    GOSUB ARR.CONDITIONS
    CALL AA.GET.PROPERTY.NAME(Y.AA.ID,PROP.CLASS,OUT.PARAM)
    Y.ACTIVITY = 'LENDING-DISBURSE-':OUT.PARAM
RETURN
*-----------------------------------------------------------------------------
DISBURSED.AMT:
*-----------------------------------------------------------------------------
    GOSUB GET.ACTIVITY
    CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.AA.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,Y.ERR.ACT.HIS)
    TOTAL.AAH = DCOUNT(R.AA.ACTIVITY.HISTORY<AA.AH.EFFECTIVE.DATE>,@VM)
    Y.POS.AAH = 1
    LOOP
    WHILE Y.POS.AAH LE TOTAL.AAH
        Y.ALL.ACTIVITY = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY,Y.POS.AAH>
        TOTAL.ACT = DCOUNT(Y.ALL.ACTIVITY,@SM)
        CHANGE @SM TO @FM IN Y.ALL.ACTIVITY
        Y.POS.ST = 1

        LOOP
        WHILE Y.POS.ST LE TOTAL.ACT
            LOCATE Y.ACTIVITY IN Y.ALL.ACTIVITY,Y.POS.ST SETTING POS.ACT THEN
                Y.ARR.ACT.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF,Y.POS.AAH,POS.ACT>
                CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.ARR.ACT.ID,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,ERR.AAA)
                Y.DISB.AMOUNT+= R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.AMOUNT>
                Y.POS.ST = POS.ACT + 1
            END ELSE
                Y.POS.ST = TOTAL.ACT + 1
            END
        REPEAT

        Y.POS.AAH += 1
    REPEAT
RETURN
*-----------------------------------------------------------------------------
ARR.CONDITIONS:
*-----------------------------------------------------------------------------
    ArrangementID = Y.AA.ID ; idProperty = ''; effectiveDate = ''; returnIds = ''; R.CONDITION =''; returnConditions = ''; returnError = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
RETURN
*-----------------------------------------------------------------------------
CUSTOMER.CLASS:
*-----------------------------------------------------------------------------
    idPropertyClass = "CUSTOMER"
    GOSUB ARR.CONDITIONS
    IF returnError THEN
        RETURN
    END
    R.CONDITION = RAISE(returnConditions)
    IF R.CONDITION THEN
        GOSUB CUST.DET
    END
RETURN
*----------------------------------------------------------------------
CUST.DET:
*----------------------------------------------------------------------
    Y.PRI.OWNER=R.CONDITION<AA.CUS.CUSTOMER>    ;*R22 Manual Conversion - changed to AA.CUS.CUSTOMER
    CALL F.READ(FN.CUSTOMER,Y.PRI.OWNER,R.CUS,F.CUSTOMER,CUS.ERR)
    Y.CLIENT.NAME =R.CUS<EB.CUS.SHORT.NAME>
    Y.OWNER.LIST=R.CONDITION<AA.CUS.CUSTOMER>   ;*R22 Manual Conversion - changed to AA.CUS.CUSTOMER
    Y.OWNER.LIST.SIZE=DCOUNT(Y.OWNER.LIST,@VM)
    Y.OWNER.CNT=1
    CHANGE @VM TO @FM IN Y.OWNER.LIST
    IF Y.OWNER.LIST.SIZE NE '' THEN

        LOOP
        WHILE Y.OWNER.CNT LE Y.OWNER.LIST.SIZE
            IF Y.PRI.OWNER NE Y.OWNER.LIST<Y.OWNER.CNT> THEN
                Y.CUS.ID=Y.OWNER.LIST<Y.OWNER.CNT>
                GOSUB CUST.NAME
            END
            Y.OWNER.CNT += 1
        REPEAT

    END
RETURN
*----------------------------------------------------------------------
CUST.NAME:
*----------------------------------------------------------------------
    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUS,F.CUSTOMER,CUS.ERR)
    IF Y.CLIENT.NAME NE '' THEN
        Y.CLIENT.NAME := @VM:R.CUS<EB.CUS.SHORT.NAME>
    END
RETURN
*----------------------------------------------------------------------
FINAL.ARRAY:
*----------------------------------------------------------------------

    IF Y.AGENCY.FLAG NE '1' AND Y.GUARANTEE.TYPE.FLAG NE '1' AND Y.GUARANTEE.STATUS.FLAG NE '1' AND Y.GUARANTEE.LOC.FLAG NE '1' AND Y.PRODUCT.FLAG NE '1' AND Y.LOAN.PORTFOLIO.FLAG NE '1' AND Y.REGION.FLAG NE '1' AND Y.GUARANTEE.FLAG NE '1' AND Y.AA.ID.FLAG NE '1' THEN
        IF LN.ARRAY EQ '' THEN
*                          1                 2                  3                4                    5                           6                  7                   8              9               10                   11                      12                  13                 14                    15                        16                       17                       18                     19                  20                21                     22                    23                       24                        25                         26                             27
            LN.ARRAY = Y.AGENCY:"*": Y.REGION.NUMBER :"*": Y.PRODUCT :"*": Y.LOAN.NUMBER :"*": Y.PREVIOUS.LOAN.NUMBER :"*": Y.CLIENT.NAME :"*": Y.CURRECNY :"*": Y.OPENING.DATE :"*": Y.AMOUNT :"*": Y.INTEREST :"*": Y.DISB.AMOUNT :"*": Y.PROPERTY.NUMBER :"*": Y.FHA.NUMBER :"*": Y.POLICY.NUMBER :"*": Y.GUARANTEE.LOCATION :"*": Y.GUARANTEE.TYPE :"*": Y.GUARANTEE.NUMBER :"*": Y.GUARANTEE.STATUS :"*": Y.CANCEL.DATE :"*": Y.WAY.PAYMENT :"*": Y.CANCEL.AGENCY :"*": Y.CANCEL.USER :"*": Y.TOT.CANCEL.AMT :"*": Y.CANCEL.CAPITAL.AMOUNT :"*": Y.CANCEL.INT.AMOUNT :"*": Y.TOTAL.BALANCE.DUE :"*": Y.CANCEL.CHARAGE.AMOUNT
        END ELSE
            LN.ARRAY <-1> = Y.AGENCY:"*": Y.REGION.NUMBER :"*": Y.PRODUCT :"*": Y.LOAN.NUMBER :"*": Y.PREVIOUS.LOAN.NUMBER :"*": Y.CLIENT.NAME :"*": Y.CURRECNY :"*": Y.OPENING.DATE :"*": Y.AMOUNT :"*": Y.INTEREST :"*": Y.DISB.AMOUNT :"*": Y.PROPERTY.NUMBER :"*": Y.FHA.NUMBER :"*": Y.POLICY.NUMBER :"*": Y.GUARANTEE.LOCATION :"*": Y.GUARANTEE.TYPE :"*": Y.GUARANTEE.NUMBER :"*": Y.GUARANTEE.STATUS :"*": Y.CANCEL.DATE :"*": Y.WAY.PAYMENT :"*": Y.CANCEL.AGENCY:"*": Y.CANCEL.USER :"*": Y.TOT.CANCEL.AMT :"*": Y.CANCEL.CAPITAL.AMOUNT :"*": Y.CANCEL.INT.AMOUNT:"*": Y.TOTAL.BALANCE.DUE :"*": Y.CANCEL.CHARAGE.AMOUNT
        END
    END
    Y.AGENCY.FLAG = '';Y.GUARANTEE.TYPE.FLAG ='';Y.GUARANTEE.STATUS.FLAG = '';Y.GUARANTEE.LOC.FLAG =''; Y.PRODUCT.FLAG = '' ; Y.LOAN.PORTFOLIO.FLAG ='';Y.REGION.FLAG='';Y.CANC.DATE.FROM.FLAG='';Y.CANC.DATE.TO.FLAG=''

    Y.LOAN.NUMBER= '' ;Y.PREVIOUS.LOAN.NUMBER ='' ; Y.AGENCY =''; Y.REGION.NUMBER ='' ; Y.PRODUCT ='' ; Y.CLIENT.NAME =''; Y.CURRECNY ='';Y.OPENING.DATE=''; Y.AMOUNT='0.00';Y.INTEREST='0.00';Y.DISB.AMOUNT='0.00';Y.POLICY.NUMBER='' ; Y.PROPERTY.NUMBER='';Y.FHA.NUMBER='';Y.GUARANTEE.LOCATION='';Y.GUARANTEE.TYPE='';Y.GUARANTEE.NUMBER=''; Y.GUARANTEE.STATUS='';Y.CANCEL.DATE='';Y.WAY.PAYMENT=''; Y.CANCEL.AGENCY ='';Y.CANCEL.USER='';Y.TOT.CANCEL.AMT='0.00';Y.CANCEL.INT.AMOUNT='0.00' ; Y.TOTAL.BALANCE.DUE = '0.00' ; Y.CANCEL.CHARAGE.AMOUNT = '' ; Y.GUARANTEE.FLAG = ''
RETURN
END
