* @ValidationCode : MjotNzU4MjQ0MjkxOkNwMTI1MjoxNzA1MDQzODMxMzI4OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Jan 2024 12:47:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

SUBROUTINE REDO.GET.TOTAL.OUTSTANDING.SIN.UNC.UND(ARR.ID,Y.PROP.AMT,Y.TOTAL.AMT)
*-----------------------------------------------------------------
* Description: This routine is to calculate the outstanding balance of Loan.
*-----------------------------------------------------------------
* Input Arg: ARR.ID<1> -> Arrangement ID.
*            ARR.ID<2> -> Optional ; Date.
* Out   Arg: Y.AMT  -> Outstanding Amount.
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE             DESCRIPTION
* 02-JAN-2012     H GANESH              PACS00174524 - B.43     Initial Draft.
* 13.04.2023      Conversion Tool           R22                 Auto Conversion     - FM TO @FM, ++ TO += 1, SM TO @SM
* 13.04.2023      Shanmugapriya M           R22                 Manual Conversion   - Add call routine prefix
*
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.OVERDUE
    $USING APAP.AA
   $USING AA.Framework

    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------

    IF FIELD(ARR.ID,"*",2) THEN
        Y.REQ.DATE = FIELD(ARR.ID,"*",2)
        ARR.ID     = FIELD(ARR.ID,"*",1)
    END ELSE
        Y.REQ.DATE = TODAY
    END

    IN.ACC.ID     = ''
    Y.PROP.AMT    = ''
    Y.ARR.ACC.ID  = ''
    Y.TOTAL.AMT   = ''

*CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,ARR.ID,Y.ARR.ACC.ID,ERR.TEXT)
** R22 Manual conversion
    APAP.TAM.redoConvertAccount(IN.ACC.ID,ARR.ID,Y.ARR.ACC.ID,ERR.TEXT)

    IF Y.ARR.ACC.ID ELSE
        RETURN
    END
    GOSUB GET.OVERDUE.STATUS
    GOSUB GET.ACCOUNT.PROP.BALANCE
    GOSUB GET.INTEREST.PROP.BALANCE
    GOSUB GET.CHARGE.PROP.BALANCE
    Y.PROP.AMT = Y.ACC.BAL:@FM:Y.INT.BALANCE:@FM:Y.CHRG.BALANCE
    Y.TOTAL.AMT =Y.ACC.BAL+Y.INT.BALANCE+Y.CHRG.BALANCE

RETURN
*-----------------------------------------------------------------
GET.OVERDUE.STATUS:
*-----------------------------------------------------------------
* Here Overdue property aging status are obtained.

    EFF.DATE = ''
    PROP.CLASS='OVERDUE'
    PROPERTY = ''
    R.CONDITION.OVERDUE = ''
    ERR.MSG = ''

*CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG)
** R22 Manual conversion
    APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG)
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
*    CALL REDO.GET.PROPERTY.NAME(ARR.ID,'ACCOUNT',R.OUT.AA.RECORD,Y.ACCOUNT.PROPERTY,OUT.ERR)
    APAP.TAM.redoGetPropertyName(ARR.ID,'ACCOUNT',R.OUT.AA.RECORD,Y.ACCOUNT.PROPERTY,OUT.ERR) ;*R22 Manual Conversion

    ACC.BALANCE.TYPE = 'CUR':@FM:'DUE':@FM:Y.OVERDUE.STATUS
    Y.PROPERTY.LIST = Y.ACCOUNT.PROPERTY
    Y.BALANCE.TYPE  = ACC.BALANCE.TYPE
    GOSUB GET.BALANCE
    Y.ACC.BAL = Y.BALANCE
RETURN
*-----------------------------------------------------------------
GET.INTEREST.PROP.BALANCE:
*-----------------------------------------------------------------
* Here we will get the Interest property Balances.

    Y.INT.BALANCE = 0
    Y.INT.PROPERTY = ''
*    CALL REDO.GET.PROPERTY.NAME(ARR.ID,'INTEREST',R.OUT.AA.RECORD,Y.INT.PROPERTY,OUT.ERR)
    APAP.TAM.redoGetPropertyName(ARR.ID,'INTEREST',R.OUT.AA.RECORD,Y.INT.PROPERTY,OUT.ERR) ;*R22 Manual Conversion
    Y.PROPERTY.LIST = Y.INT.PROPERTY
    Y.BALANCE.TYPE  = 'ACC':@FM:'DUE':@FM:Y.OVERDUE.STATUS
    GOSUB GET.BALANCE
    Y.INT.BALANCE = Y.BALANCE

RETURN
*-----------------------------------------------------------------
GET.CHARGE.PROP.BALANCE:
*-----------------------------------------------------------------
* Here we will get the Charge property Balances.

    Y.CHRG.BALANCE = 0
    Y.CHRG.PROPERTY = ''
*    CALL REDO.GET.PROPERTY.NAME(ARR.ID,'CHARGE',R.OUT.AA.RECORD,Y.CHRG.PROPERTY,OUT.ERR)
    APAP.TAM.redoGetPropertyName(ARR.ID,'CHARGE',R.OUT.AA.RECORD,Y.CHRG.PROPERTY,OUT.ERR) ;*R22 Manual Conversion
    Y.PROPERTY.LIST = Y.CHRG.PROPERTY
    Y.BALANCE.TYPE  = 'ACC':@FM:'DUE':@FM:Y.OVERDUE.STATUS
    GOSUB GET.BALANCE
    Y.CHRG.BALANCE = Y.BALANCE

RETURN
*-----------------------------------------------------------------
GET.BALANCE:
*-----------------------------------------------------------------

* REQUEST.TYPE     =  '';REQUEST.TYPE<2> = 'ALL';REQUEST.TYPE<4> = 'ECB'
    REQUEST.TYPE     =  '';REQUEST.TYPE<4> = 'ECB'
    START.DATE       =  Y.REQ.DATE
    END.DATE         = ''
    SYSTEM.DATE      = ''
    ERROR.MESSAGE    = ''
    Y.BALANCE = 0
    Y.PROPERTY.CNT = DCOUNT(Y.PROPERTY.LIST,@FM)
    Y.BALANCE.CNT  = DCOUNT(Y.BALANCE.TYPE,@FM)
    Y.LOOP1 = 1
    LOOP
    WHILE Y.LOOP1 LE Y.PROPERTY.CNT
        Y.LOOP2 = 1
        LOOP
        WHILE Y.LOOP2 LE Y.BALANCE.CNT

            BALANCE.TO.CHECK = Y.BALANCE.TYPE<Y.LOOP2>:Y.PROPERTY.LIST<Y.LOOP1>
*BALANCE.AMOUNT=''
*CALL AA.GET.ECB.BALANCE.AMOUNT(Y.ARR.ACC.ID,BALANCE.TO.CHECK,TODAY,BALANCE.AMOUNT,RET.ERROR)
            BAL.DETAILS = ''
*            CALL AA.GET.PERIOD.BALANCES(Y.ARR.ACC.ID, BALANCE.TO.CHECK, REQUEST.TYPE, START.DATE, END.DATE, SYSTEM.DATE, BAL.DETAILS, ERROR.MESSAGE)
AA.Framework.GetPeriodBalances(Y.ARR.ACC.ID, BALANCE.TO.CHECK, REQUEST.TYPE, START.DATE, END.DATE, SYSTEM.DATE, BAL.DETAILS, ERROR.MESSAGE);* R22 UTILITY AUTO CONVERSION
            Y.BALANCE += ABS(BAL.DETAILS<4>)
            Y.LOOP2 += 1         ;** R22 Auto conversion - ++ TO += 1
        REPEAT
        Y.LOOP1 += 1            ;** R22 Auto conversion - ++ TO += 1
    REPEAT

RETURN
END
