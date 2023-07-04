* @ValidationCode : MjozODIxOTYwMzI6Q3AxMjUyOjE2ODU1NDMxMTYxNzQ6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 19:55:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.GET.OUT.BALANCE
*-----------------------------------------------------------------
* Description: This routine is to calculate the outstanding balance of Loan.
*-----------------------------------------------------------------
* Input Arg: O.DATA -> Arrangement ID.
* Out   Arg: O.DATA  -> Outstanding Amount.
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE             DESCRIPTION
* 19-APR-2012     R GANESH              PACS00180415 - R.163     Initial Draft.
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - SM to @SM , FM to @FM and ++ to +=
* 11-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCT.ACTIVITY
    $USING APAP.TAM
    $USING APAP.AA

    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------

    IN.ACC.ID     = ''
    Y.PROP.AMT    = ''
    Y.ARR.ACC.ID  = ''
    Y.TOTAL.AMT   = ''
    IN.ARR.ID = O.DATA
    APAP.TAM.redoConvertAccount(IN.ACC.ID,IN.ARR.ID,Y.ARR.ACC.ID,ERR.TEXT) ;*R22 Manual Conversion

    IF Y.ARR.ACC.ID ELSE
        RETURN
    END
    GOSUB GET.OVERDUE.STATUS
    GOSUB GET.ACCOUNT.PROP.BALANCE

    O.DATA =Y.ACC.BAL
RETURN
*-----------------------------------------------------------------
GET.OVERDUE.STATUS:
*-----------------------------------------------------------------
* Here Overdue property aging status are obtained.

    EFF.DATE = 'TODAY'
    PROP.CLASS='OVERDUE'
    PROPERTY = ''
    R.CONDITION.OVERDUE = ''
    ERR.MSG = ''
    APAP.AA.redoCrrGetConditions(IN.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG);*R22 Manual Conversion
    Y.OVERDUE.STATUS = R.CONDITION.OVERDUE<AA.OD.OVERDUE.STATUS>
*  CHANGE VM TO FM IN Y.OVERDUE.STATUS
    CHANGE @SM TO @FM IN Y.OVERDUE.STATUS

RETURN
*-----------------------------------------------------------------
GET.ACCOUNT.PROP.BALANCE:
*-----------------------------------------------------------------
* Here we will get the account property Balances.

    Y.ACC.BAL = 0
    Y.ACCOUNT.PROPERTY = ''
    APAP.TAM.redoGetPropertyName(IN.ARR.ID,'ACCOUNT',R.OUT.AA.RECORD,Y.ACCOUNT.PROPERTY,OUT.ERR);*R22 Manual Conversion

    ACC.BALANCE.TYPE = 'CUR':@FM:'DUE':@FM:Y.OVERDUE.STATUS
    Y.PROPERTY.LIST = Y.ACCOUNT.PROPERTY
    Y.BALANCE.TYPE  = ACC.BALANCE.TYPE
    GOSUB GET.BALANCE
    Y.ACC.BAL = Y.BALANCE
RETURN
*-----------------------------------------------------------------
GET.BALANCE:
*-----------------------------------------------------------------

    Y.BALANCE = 0
    Y.PROPERTY.CNT = DCOUNT(Y.PROPERTY.LIST,@FM)
    Y.BALANCE.CNT  = DCOUNT(Y.BALANCE.TYPE,@FM)
    DATE.OPTIONS = ''
    DATE.OPTIONS<4>  = 'ECB'
    Y.LOOP1 = 1
    LOOP
    WHILE Y.LOOP1 LE Y.PROPERTY.CNT
        Y.LOOP2 = 1
        LOOP
        WHILE Y.LOOP2 LE Y.BALANCE.CNT
            BALANCE.TO.CHECK = Y.BALANCE.TYPE<Y.LOOP2>:Y.PROPERTY.LIST<Y.LOOP1>
            BALANCE.AMOUNT=''
            CALL AA.GET.PERIOD.BALANCES(Y.ARR.ACC.ID,BALANCE.TO.CHECK,DATE.OPTIONS,TODAY, "", "",BALANCE.AMOUNT, "")
            Y.BALANCE += ABS(BALANCE.AMOUNT<IC.ACT.BALANCE>)
            Y.LOOP2 += 1
        REPEAT
        Y.LOOP1 += 1
    REPEAT

RETURN
END
