* @ValidationCode : Mjo1NDgwNDg0MDI6Q3AxMjUyOjE2ODQzODUyMjQyMjg6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 May 2023 10:17:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.AA.GET.OUT.BALANCE(AA.ID,Y.BALANCE)
*------------------------------------------------------------------------
*Description : This routine is nofile enquiry routine in order to fetch the loan
* details of the customer. This routine will fetch the details about the
*
*------------------------------------------------------------------------
* Input Argument : NA
* Out Argument   : Y.ARRAY.OUT
* Deals With     : ENQUIRY>REDO.LOAN.CUSTOMER.POSITION
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO         REFERENCE            DESCRIPTION
* 03-MAR-2011     H GANESH  ODR-2010-10-0045 N.107   Initial Draft
*------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*24-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,SM TO @SM,++ to +=1
*24-04-2023              Samaran T                R22 Manual Code conversion                         CALL RTN FORMAT MODIFIED
*-------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.OVERDUE
    $USING APAP.AA


    GOSUB PROCESS
RETURN

*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
* Here the main process begins

    Y.ARR.ID=AA.ID
    Y.BALANCE=''

    GOSUB GET.OVERDUE.STATUS
    GOSUB GET.PRINCIPAL.BAL
    GOSUB GET.INTEREST.BAL
    GOSUB GET.CHARGE.BAL

    Y.BALANCE=Y.PRIN.BAL+Y.INT.BAL+Y.CHRG.BAL
    Y.BALANCE=ABS(Y.BALANCE)
RETURN

*------------------------------------------------------------------------
GET.OVERDUE.STATUS:
*------------------------------------------------------------------------
* Here we gets the overdue status of that particular arrangement

    EFF.DATE = ''
    PROP.CLASS='OVERDUE'
    PROPERTY = ''
    R.OVERDUE.CONDITION = ''
    ERR.MSG = ''
*CALL APAP.AA.REDO.CRR.GET.CONDITIONS(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.OVERDUE.CONDITION,ERR.MSG)   ;*R22 MANAUAL CODE CONVERSION
    CALL APAP.AA.redoCrrGetConditions(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.OVERDUE.CONDITION,ERR.MSG) ;*R22 MANAUAL CODE CONVERSION
    Y.OVERDUE.STATUS=R.OVERDUE.CONDITION<AA.OD.OVERDUE.STATUS>
*  CHANGE VM TO FM IN Y.OVERDUE.STATUS
    CHANGE @SM TO @FM IN Y.OVERDUE.STATUS

RETURN
*------------------------------------------------------------------------
GET.PRINCIPAL.BAL:
*------------------------------------------------------------------------
* Here we gets the  outstanding principal from the customer
    OUT.PROPERTY=''
*CALL REDO.GET.PROPERTY.NAME(Y.ARR.ID,'ACCOUNT',R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)   ;*R22 MANAUAL CODE CONVERSION
    CALL APAP.TAM.redoGetPropertyName(Y.ARR.ID,'ACCOUNT',R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)   ;*R22 MANAUAL CODE CONVERSION
    OUT.ID=''
    IN.ACC.ID=''
*CALL APAP.TAM.REDO.CONVERT.ACCOUNT(IN.ACC.ID,Y.ARR.ID,OUT.ID,ERR.TEXT)   ;*R22 MANAUAL CODE CONVERSION
    CALL APAP.TAM.redoConvertAccount(IN.ACC.ID,Y.ARR.ID,OUT.ID,ERR.TEXT) ;*R22 MANAUAL CODE CONVERSION
    Y.BAL.ACC.STATUS='CUR':@FM:'DUE':@FM:Y.OVERDUE.STATUS
    Y.PRIN.BAL=0
    Y.OVERDUE.STATUS.CNT=DCOUNT(Y.BAL.REDO.GET.PROPERTY.NAMEACC.STATUS,@FM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.OVERDUE.STATUS.CNT
        BALANCE.TO.CHECK=Y.BAL.ACC.STATUS<Y.VAR1>:OUT.PROPERTY
        BALANCE.AMOUNT=''
*CALL AA.GET.ECB.BALANCE.AMOUNT(OUT.ID,BALANCE.TO.CHECK,TODAY,BALANCE.AMOUNT,RET.ERROR) ;*R22 MANAUAL CODE CONVERSION
        CALL APAP.AA.redoAaGetEcbBalanceAmount(OUT.ID,BALANCE.TO.CHECK,TODAY,BALANCE.AMOUNT,RET.ERROR) ;*R22 MANAUAL CODE CONVERSION
        Y.PRIN.BAL += BALANCE.AMOUNT
        Y.VAR1 += 1
    REPEAT

RETURN

*------------------------------------------------------------------------
GET.INTEREST.BAL:
*------------------------------------------------------------------------
* Here we calculate the outstanding interest amount for that arrangement

    OUT.PROPERTY=''
*CALL REDO.GET.PROPERTY.NAME(Y.ARR.ID,'INTEREST',R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)   ;*R22 MANUAL CODE CONVERSION
    CALL APAP.TAM.redoGetPropertyName(Y.ARR.ID,'INTEREST',R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)  ;*R22 MANUAL CODE CONVERSION
    INT.PROP.CNT=DCOUNT(OUT.PROPERTY,@FM)
    Y.INT.BAL.TYPE='ACC':@FM:'DUE':@FM:Y.OVERDUE.STATUS
    Y.OVERDUE.STATUS.CNT=DCOUNT(Y.INT.BAL.TYPE,@FM)
    Y.INT.BAL=0
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE INT.PROP.CNT
        Y.VAR2=1
        LOOP
        WHILE Y.VAR2 LE Y.OVERDUE.STATUS.CNT
            BALANCE.TO.CHECK=Y.INT.BAL.TYPE<Y.VAR2>:OUT.PROPERTY<Y.VAR1>
            BALANCE.AMOUNT=''
*CALL AA.GET.ECB.BALANCE.AMOUNT(OUT.ID,BALANCE.TO.CHECK,TODAY,BALANCE.AMOUNT,RET.ERROR) ;*R22 MANUAL CODE CONVERSION
            CALL APAP.AA.redoAaGetEcbBalanceAmount(OUT.ID,BALANCE.TO.CHECK,TODAY,BALANCE.AMOUNT,RET.ERROR) ;*R22 MANUAL CODE CONVERSION
            Y.INT.BAL += BALANCE.AMOUNT
            Y.VAR2 += 1
        REPEAT
        Y.VAR1 += 1
    REPEAT

RETURN
*------------------------------------------------------------------------
GET.CHARGE.BAL:
*------------------------------------------------------------------------
* Here we calculate the outstanding charge amount for that arrangement

    OUT.PROPERTY=''
*CALL REDO.GET.PROPERTY.NAME(Y.ARR.ID,'CHARGE',R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)   ;*R22 MANUAL CODE CONVERSION
    CALL APAP.TAM.redoGetPropertyName(Y.ARR.ID,'CHARGE',R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)  ;*R22 MANUAL CODE CONVERSION
    Y.CHRG.BAL.TYPE='ACC':@FM:'DUE':@FM:Y.OVERDUE.STATUS
    Y.OVERDUE.STATUS.CNT=DCOUNT(Y.CHRG.BAL.TYPE,@FM)
    CHRG.PROP.CNT=DCOUNT(OUT.PROPERTY,@FM)
    Y.CHRG.BAL=0
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE CHRG.PROP.CNT
        Y.VAR2=1
        LOOP
        WHILE Y.VAR2 LE Y.OVERDUE.STATUS.CNT
            BALANCE.TO.CHECK=Y.CHRG.BAL.TYPE<Y.VAR2>:OUT.PROPERTY<Y.VAR1>
            BALANCE.AMOUNT=''
            CALL AA.GET.ECB.BALANCE.AMOUNT(OUT.ID,BALANCE.TO.CHECK,TODAY,BALANCE.AMOUNT,RET.ERROR)
            Y.CHRG.BAL += BALANCE.AMOUNT
            Y.VAR2 += 1
        REPEAT
        Y.VAR1 += 1
    REPEAT

RETURN
END
