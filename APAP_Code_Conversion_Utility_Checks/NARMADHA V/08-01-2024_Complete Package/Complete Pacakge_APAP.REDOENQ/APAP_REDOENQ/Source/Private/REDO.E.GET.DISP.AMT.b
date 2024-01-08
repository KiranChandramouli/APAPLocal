* @ValidationCode : MjotMTM1NDQyMzUwMDpVVEYtODoxNzA0MTk4NzMxOTgzOkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 Jan 2024 18:02:11
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.GET.DISP.AMT
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
* 11-APRIL-2023      Harsha                R22 Auto Conversion  - FM to @FM
* 11-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCT.ACTIVITY
    $USING APAP.TAM
    $USING AA.Framework

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
    APAP.TAM.redoConvertAccount(IN.ACC.ID,IN.ARR.ID,Y.ARR.ACC.ID,ERR.TEXT);*R22 Manual Conversion

    IF Y.ARR.ACC.ID ELSE
        RETURN
    END
    GOSUB GET.ACCOUNT.PROP.BALANCE

    O.DATA =Y.ACC.BAL

RETURN
*-----------------------------------------------------------------
GET.ACCOUNT.PROP.BALANCE:
*-----------------------------------------------------------------
* Here we will get the account property Balances.

    Y.ACC.BAL = 0
    Y.ACCOUNT.PROPERTY = ''
    APAP.TAM.redoGetPropertyName(IN.ARR.ID,'ACCOUNT',R.OUT.AA.RECORD,Y.ACCOUNT.PROPERTY,OUT.ERR)

    ACC.BALANCE.TYPE = 'CURCOMMITMENT'
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
    DATE.OPTIONS  = ''
    DATE.OPTIONS<4>  = 'ECB'
    BALANCE.AMOUNT=''

*CALL AA.GET.PERIOD.BALANCES(Y.ARR.ACC.ID,ACC.BALANCE.TYPE,DATE.OPTIONS,TODAY, "", "",BALANCE.AMOUNT, "")
    AA.Framework.GetPeriodBalances(Y.ARR.ACC.ID,ACC.BALANCE.TYPE,DATE.OPTIONS,TODAY, "", "",BALANCE.AMOUNT, "");* R22 AUTO CONVERSION
    Y.BALANCE += ABS(BALANCE.AMOUNT<IC.ACT.TURNOVER.CREDIT>)

RETURN
END
