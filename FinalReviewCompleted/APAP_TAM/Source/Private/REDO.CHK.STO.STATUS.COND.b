* @ValidationCode : MjotMTgxNzE1MTYwMDpDcDEyNTI6MTY4MzgwNzU3MzkyMTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 May 2023 17:49:33
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
SUBROUTINE REDO.CHK.STO.STATUS.COND(STO.ID,R.STO,R.ACC,CUR.AMT)
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is attached in the STANDING ORDER record for the field STO.CUR.AMT.ROUTINE
* This routine will update the CURRENT.AMOUNT.BAL with null value when Status or Condition exists on the loan
* or when there is no sufficient balance in the debit accout no.  Cob job will reupdate the amount with appropriate amount
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  :
*   STO.ID - @id of the STANDING.ORDER record currently processed
*   R.STO - STANDING.ORDER record
*   R.ACC - Account record of the debit account
* OUT :
*   CUR.AMT - The amount that needs to be updated in the field CURRENT.AMOUNT.BAL of STO
*
* Dependencies:
*---------------
* CALLS     : REDO.U.NEW.FT.IN.HOLD
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 07-JUN-2010   N.Satheesh Kumar   ODR-2009-10-0331      Initial Creation
* 28-APR-2011      H GANESH           CR009              Change the Vetting value of local field
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           = TO EQ, FM TO @FM, VM TO @VM, SM TO @SM
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION          CALL Rtn format modified
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.STANDING.ORDER
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER

    $INSERT I_F.REDO.RESUBMIT.FT.DET
    $INSERT I_F.REDO.STO.PENDING.RESUBMISSION

    GOSUB INIT
    IF NOT(RUNNING.UNDER.BATCH) THEN
        RETURN
    END

    BATCH.JOB = BATCH.INFO<1>
    BATCH.JOB = RIGHT(BATCH.JOB,15)
    IF BATCH.JOB NE 'FT.START.OF.DAY' THEN
        RETURN
    END

    GOSUB GET.LRF.POS
    ARR.ID = R.STO<STO.LOCAL.REF,STO.ARR.ID.POS>
    IF ARR.ID EQ '' THEN
        RETURN
    END

    GOSUB GET.OD.STATUS.COND
    IF LS.LC.FLAG EQ 0 THEN
        GOSUB CHK.DR.ACC.BAL
    END

    IF LS.LC.FLAG THEN
        CUR.AMT = ''
        GOSUB CREATE.FT.IN.HOLD
        RETURN
    END

RETURN

*----
INIT:
*----
*-------------------------------------------------
* This section initialises the necessary variables
*-------------------------------------------------

    CUR.AMT = R.STO<STO.CURRENT.AMOUNT.BAL>
    DEAL.AMOUNT = R.STO<STO.CURRENT.AMOUNT.BAL>
    DR.ACC.NO = FIELD(STO.ID,'.',1)
    CR.ACC.NO = R.STO<STO.CPTY.ACCT.NO>
    LS.LC.FLAG = 0

RETURN

*-----------
GET.LRF.POS:
*-----------
*----------------------------------------------------------------------
* This section gets the position of the local reference field positions
*----------------------------------------------------------------------

    LR.APP = 'STANDING.ORDER':@FM:'AA.PRD.DES.OVERDUE':@FM:'ACCOUNT':@FM:'FUNDS.TRANSFER'
    LR.FLDS = 'L.LOAN.ARR.ID':@VM:'L.LOAN.STATUS.1':@VM:'L.LOAN.COND':@VM:'L.RETRY.DAYS':@FM
    LR.FLDS := 'L.LOAN.STATUS.1':@VM:'L.LOAN.COND':@FM
    LR.FLDS := 'L.AC.STATUS2':@FM
    LR.FLDS := 'L.LOAN.STATUS.1':@VM:'L.LOAN.COND'
    LR.POS = ''
    CALL MULTI.GET.LOC.REF(LR.APP,LR.FLDS,LR.POS)

    STO.ARR.ID.POS = LR.POS<1,1>
    STO.LOAN.STATUS.POS = LR.POS<1,2>
    STO.LOAN.COND.POS =  LR.POS<1,3>
    STO.RETRY.DAYS.POS = LR.POS<1,4>
    OD.LOAN.STATUS.POS = LR.POS<2,1>
    OD.LOAN.COND.POS =  LR.POS<2,2>
    ACC.STAT2.POS = LR.POS<3,1>
    FT.LOAN.STATUS.POS = LR.POS<4,1>
    FT.LOAN.COND.POS =  LR.POS<4,2>

RETURN

*------------------
GET.OD.STATUS.COND:
*------------------
*----------------------------------------------------------------------------------------------------------------------------------------
* This section gets the latest overdue record for the arrangement id and stores the value of loan status and condition in local variables
*----------------------------------------------------------------------------------------------------------------------------------------

    PROP.CLASS = 'OVERDUE'
    PROPERTY = ''
    R.Condition = ''
    ERR.MSG = ''
    EFF.DATE = ''
* CALL APAP.TAM.REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.TAM.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG) ;*R22 Manual Conversion
    LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.STATUS.POS>
    LOAN.COND = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.COND.POS>

    IF LOAN.STATUS EQ '' AND LOAN.COND EQ '' THEN
        RETURN
    END

    CHANGE @SM TO @VM IN LOAN.STATUS
    CHANGE @SM TO @VM IN LOAN.COND
    IF ('JudicialCollection' MATCHES LOAN.STATUS) OR ('Write-off' MATCHES LOAN.STATUS) OR ('Legal' MATCHES LOAN.COND) THEN
        LS.LC.FLAG = 1
    END
RETURN

*--------------
CHK.DR.ACC.BAL:
*--------------
*----------------------------------------------------------------------------------------------------
* This section checks whether Debit Account has sufficient balance or any block exists on the account
*----------------------------------------------------------------------------------------------------

    IF R.ACC<AC.LOCAL.REF,ACC.STAT2.POS> NE '' THEN
        LS.LC.FLAG = 1
        RETURN
    END

    ONLINE.ACT.BAL = R.ACC<AC.ONLINE.ACTUAL.BAL>
    LOCKED.AMOUNT = SUM(R.ACC<AC.LOCKED.AMOUNT>)
    AVAIL.AMOUNT = ONLINE.ACT.BAL - LOCKED.AMOUNT

    GOSUB GET.CHARGE.AMT
    FINAL.DEAL.AMT = DEAL.AMOUNT + TOT.CHARGE.LCCY

    IF AVAIL.AMOUNT LT FINAL.DEAL.AMT THEN
        LS.LC.FLAG = 1
    END
RETURN

*--------------
GET.CHARGE.AMT:
*--------------
*-------------------------------------------------------------
* This section calculates the various charges and taxes for FT
*-------------------------------------------------------------

    CUSTOMER = R.STO<STO.DEBIT.CUSTOMER>
    DEAL.CURRENCY = R.STO<STO.CURRENCY>
    CURRENCY.MARKET = 1
    CROSS.RATE = ''
    CROSS.CURRENCY = ''
    DRAWDOWN.CCY = ''
    T.DATA<1> = R.STO<STO.COMMISSION.TYPE>:@VM:R.STO<STO.CHARGE.TYPE>
    CUST.COND = ''
    TOT.CHARGE.LCCY = ''
    TOT.CHARGE.FCCY = ''
    CALL CALCULATE.CHARGE (CUSTOMER, DEAL.AMOUNT, DEAL.CURRENCY, CURRENCY.MARKET, CROSS.RATE, CROSS.CURRENCY, DRAWDOWN.CCY, T.DATA, CUST.COND, TOT.CHARGE.LCCY, TOT.CHARGE.FCCY)
RETURN

*-----------------
CREATE.FT.IN.HOLD:
*-----------------
*--------------------------------------------------------------------------------------------------------------------------------
* This section creates FT record in HOLD when status or condition exists on loan account or insufficient balance in debit account
*--------------------------------------------------------------------------------------------------------------------------------

    FT.ID = ''
    CALL FT.GENERATE.ID('STO',FT.ID)
    R.FUNDS.TRANSFER = ''
    R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE> = R.STO<STO.PAY.METHOD>
    R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO> = DR.ACC.NO
    R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY> = R.STO<STO.CURRENCY>
    R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT> = DEAL.AMOUNT
    R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE> = TODAY
    R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO> = R.STO<STO.CPTY.ACCT.NO>
    R.FUNDS.TRANSFER<FT.COMMISSION.CODE> = R.STO<STO.COMMISSION.CODE>
    R.FUNDS.TRANSFER<FT.COMMISSION.TYPE> = R.STO<STO.COMMISSION.TYPE>
    R.FUNDS.TRANSFER<FT.LOCAL.REF,FT.LOAN.STATUS.POS> = LOAN.STATUS
    R.FUNDS.TRANSFER<FT.LOCAL.REF,FT.LOAN.COND.POS> = LOAN.COND
*  CALL APAP.TAM.REDO.U.NEW.FT.IN.HOLD(ARR.ID,FT.ID,R.FUNDS.TRANSFER,R.STO) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.TAM.RedoUNewFtInHold(ARR.ID,FT.ID,R.FUNDS.TRANSFER,R.STO) ;*R22 Manual Conversion
RETURN

END
