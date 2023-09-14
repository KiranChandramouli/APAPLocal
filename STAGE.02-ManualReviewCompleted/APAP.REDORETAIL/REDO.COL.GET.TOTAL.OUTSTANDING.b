* @ValidationCode : MjotMTc0Njk1NTM5ODpDcDEyNTI6MTY4MTg5MTEzNDc2NjpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 13:28:54
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
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*12-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*12-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION        CALL method format changed
SUBROUTINE REDO.COL.GET.TOTAL.OUTSTANDING(ARR.ID,Y.PROP.AMT,Y.TOTAL.AMT)
*-----------------------------------------------------------------
* Description: This routine is to calculate the outstanding balance of Loan
*-----------------------------------------------------------------
* Input Arg: ARR.ID -> Arrangement ID
* Out   Arg: Y.AMT  -> Outstanding Amount
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE             DESCRIPTION
* 02-JAN-2012     H GANESH              PACS00174524 - B.43     Initial Draft
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.OVERDUE

    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------

    IN.ACC.ID     = ''
    Y.PROP.AMT    = ''
    Y.ARR.ACC.ID  = ''
    Y.TOTAL.AMT   = ''
    CALL APAP.TAM.REDO.CONVERT.ACCOUNT(IN.ACC.ID,ARR.ID,Y.ARR.ACC.ID,ERR.TEXT);* R22 Manual conversion

    IF Y.ARR.ACC.ID ELSE
        RETURN
    END
    GOSUB GET.OVERDUE.STATUS
    GOSUB GET.ACCOUNT.PROP.BALANCE
    GOSUB GET.INTEREST.PROP.BALANCE
    GOSUB GET.CHARGE.PROP.BALANCE
    Y.PROP.AMT = Y.ACC.BAL:@FM:Y.INT.BALANCE:@FM:Y.CHRG.BALANCE
    Y.TOTAL.AMT =Y.ACC.BAL+Y.INT.BALANCE+Y.CHRG.BALANCE
    Y.TOTAL.AMT=ABS(Y.TOTAL.AMT)
RETURN
*-----------------------------------------------------------------
GET.OVERDUE.STATUS:
*-----------------------------------------------------------------
* Here Overdue property aging status are obtained

    EFF.DATE = ''
    PROP.CLASS='OVERDUE'
    PROPERTY = ''
    R.CONDITION.OVERDUE = ''
    ERR.MSG = ''
    CALL APAP.AA.REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG);* R22 Manual conversion
    Y.OVERDUE.STATUS = R.CONDITION.OVERDUE<AA.OD.OVERDUE.STATUS>
*  CHANGE VM TO FM IN Y.OVERDUE.STATUS
    CHANGE @SM TO @FM IN Y.OVERDUE.STATUS

RETURN
*-----------------------------------------------------------------
GET.ACCOUNT.PROP.BALANCE:
*-----------------------------------------------------------------
* Here we will get the account property Balances

    Y.ACC.BAL = 0
    Y.ACCOUNT.PROPERTY = ''
    CALL REDO.GET.PROPERTY.NAME(ARR.ID,'ACCOUNT',R.OUT.AA.RECORD,Y.ACCOUNT.PROPERTY,OUT.ERR)

    ACC.BALANCE.TYPE = 'CUR':@FM:'DUE':@FM:'UNC':@FM:'UND':@FM:Y.OVERDUE.STATUS
    Y.PROPERTY.LIST = Y.ACCOUNT.PROPERTY
    Y.BALANCE.TYPE  = ACC.BALANCE.TYPE
    GOSUB GET.BALANCE
    Y.ACC.BAL = Y.BALANCE
RETURN
*-----------------------------------------------------------------
GET.INTEREST.PROP.BALANCE:
*-----------------------------------------------------------------
* Here we will get the Interest property Balances

    Y.INT.BALANCE = 0
    Y.INT.PROPERTY = ''
    CALL REDO.GET.PROPERTY.NAME(ARR.ID,'INTEREST',R.OUT.AA.RECORD,Y.INT.PROPERTY,OUT.ERR)
    Y.PROPERTY.LIST = Y.INT.PROPERTY
    Y.BALANCE.TYPE  = 'ACC':@FM:'DUE':@FM:Y.OVERDUE.STATUS
    GOSUB GET.BALANCE
    Y.INT.BALANCE = Y.BALANCE

RETURN
*-----------------------------------------------------------------
GET.CHARGE.PROP.BALANCE:
*-----------------------------------------------------------------
* Here we will get the Charge property Balances

    Y.CHRG.BALANCE = 0
    Y.CHRG.PROPERTY = ''
    CALL REDO.GET.PROPERTY.NAME(ARR.ID,'CHARGE',R.OUT.AA.RECORD,Y.CHRG.PROPERTY,OUT.ERR)
    Y.PROPERTY.LIST = Y.CHRG.PROPERTY
    Y.BALANCE.TYPE  = 'ACC':@FM:'DUE':@FM:Y.OVERDUE.STATUS
    GOSUB GET.BALANCE
    Y.CHRG.BALANCE = Y.BALANCE

RETURN
*-----------------------------------------------------------------
GET.BALANCE:
*-----------------------------------------------------------------

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
            BALANCE.AMOUNT=''
****PACS00523653****
            CALL APAP.AA.REDO.AA.GET.ECB.BALANCE.AMOUNT(Y.ARR.ACC.ID,BALANCE.TO.CHECK,TODAY,BALANCE.AMOUNT,RET.ERROR);* R22 Manual conversion
****PACS00523653****
            Y.BALANCE += BALANCE.AMOUNT
            Y.LOOP2 += 1
        REPEAT
        Y.LOOP1 += 1
    REPEAT

RETURN
END
