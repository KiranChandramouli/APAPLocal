* @ValidationCode : MjotMTUwNjQ1MzU1NzpDcDEyNTI6MTY4Mzg2NjMzMjg2NjpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 May 2023 10:08:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

SUBROUTINE REDO.RE.GET.PAID.PER(CUSTOMER.IDENTITY)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached to EB.CONTEXT to get the loan paid percentage.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 24-AUG-2011     SHANKAR RAJU     ODR-2011-07-0162     Initial Creation
* 13.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM,  SM TO @SM, ++ TO += 1
* 13.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.TERM.AMOUNT

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------

    FN.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.ARRANGEMENT = ''
    CALL OPF(FN.ARRANGEMENT,F.ARRANGEMENT)

RETURN
*-----------------------------------------------------------------------------
PROCESS:

    Y.CUS.ID  = CUSTOMER.IDENTITY

    SEL.CMD = 'SELECT ':FN.ARRANGEMENT:' WITH CUSTOMER EQ ':Y.CUS.ID:' AND PRODUCT.GROUP NE HIPOTECARIO AND PRODUCT.GROUP NE COMERCIAL AND PRODUCT UNLIKE ...VEH...'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)

    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE SEL.NOR
        ARR.ID = SEL.LIST<Y.VAR1>
        GOSUB LOAN.DETAILS
        GOSUB GET.TERM.AMOUNT
        GOSUB GET.OVERDUE.TYPE
        GOSUB CALC.BALANCE

        Y.LOAN.PAID = Y.LOAN.AMOUNT - Y.OUTSTANDING.BAL

        IF Y.LOAN.PAID GT 0 AND Y.LOAN.AMOUNT GT 0 THEN
            Y.PERCENTAGE = (Y.LOAN.PAID/Y.LOAN.AMOUNT)*100
        END

        IF Y.PERCENTAGE GT 50 THEN
            CUSTOMER.IDENTITY = 1
            RETURN
        END ELSE
            CUSTOMER.IDENTITY = 0
        END

        Y.VAR1 += 1                   ;** R22 Auto conversion - ++ TO += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------
LOAN.DETAILS:
*-----------------------------------------------------------------------------
    Y.AA.ACC.ID  = ''
    IN.ACC.ID    = ''
*CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,ARR.ID,Y.AA.ACC.ID,ERR.TEXT)
** R22 Manual conversion
    CALL APAP.TAM.redoConvertAccount(IN.ACC.ID,ARR.ID,Y.AA.ACC.ID,ERR.TEXT)

    OUT.PROP.ACC    = ''
    R.OUT.AA.RECORD = ''
    CALL APAP.TAM.redoGetPropertyName(ARR.ID,'ACCOUNT',R.OUT.AA.RECORD,OUT.PROP.ACC,OUT.ERR) ;*MANUAL R22 CODE CONVERSION

RETURN
*-----------------------------------------------------------------------------
GET.TERM.AMOUNT:
*-----------------------------------------------------------------------------
* This part gets the Loan amount

    EFF.DATE = ''
    PROP.CLASS='TERM.AMOUNT'
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
*CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.TERM,ERR.MSG)
** R22 Manual conversion
    CALL APAP.TAM.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.TERM,ERR.MSG)
    Y.LOAN.AMOUNT=R.CONDITION.TERM<AA.AMT.AMOUNT>

RETURN
*-----------------------------------------------------------------------------
GET.OVERDUE.TYPE:
*-----------------------------------------------------------------------------
* This part gets the Overdue record

    EFF.DATE = ''
    PROP.CLASS='OVERDUE'
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
*CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG)
** R22 Manual conversion
    CALL APAP.TAM.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG)
    Y.OVERDUE.STATUS =  R.CONDITION.OVERDUE<AA.OD.OVERDUE.STATUS>
*  CHANGE VM TO FM IN Y.OVERDUE.STATUS
    CHANGE @SM TO @FM IN Y.OVERDUE.STATUS
RETURN


*-----------------------------------------------------------------------------
CALC.BALANCE:
*-----------------------------------------------------------------------------
    Y.OUTSTANDING.BAL = 0
    Y.BALANCE.PREFIX = 'CUR':@FM:'DUE':@FM:Y.OVERDUE.STATUS
    Y.PREFIX.CNT = DCOUNT(Y.BALANCE.PREFIX,@FM)

    Y.VAR2 =1
    LOOP
    WHILE Y.VAR2 LE Y.PREFIX.CNT

        BALANCE.TO.CHECK=Y.BALANCE.PREFIX<Y.VAR2>:OUT.PROP.ACC
        BALANCE.AMOUNT=''
        CALL AA.GET.ECB.BALANCE.AMOUNT(Y.AA.ACC.ID,BALANCE.TO.CHECK,TODAY,BALANCE.AMOUNT,RET.ERROR)
        Y.OUTSTANDING.BAL+= ABS(BALANCE.AMOUNT)

        Y.VAR2 += 1                 ;** R22 Auto conversion - ++ TO += 1
    REPEAT


RETURN
END
