* @ValidationCode : MjotMTM3MTc1NzM1NTpDcDEyNTI6MTY4NDg1NDM4Njc1NDpJVFNTOi0xOi0xOjEwNDQ6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1044
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.FT.RETRY(ARR.ID)
*----------------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is the record routine of the batch job REDO.B.FT.RETRY
* This routine updates the local table REDO.STO.PENDING.RESUBMISSION, by deleting the record if amt is paid through
* other channels or retried FT with latest amount is successful
* ---------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  :
*  ARR..ID - Arrangement id
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 07-JUN-2010   N.Satheesh Kumar  TAM-ODR-2009-10-0331   Initial Creation
* 28-APR-2011      H GANESH           CR009              Change the Vetting value of local field.
* Date                   who                   Reference              
* 11-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - SM TO @SM AND VM TO @VM AND FM TO @FM AND ++ TO += 1
* 11-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES

*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.STANDING.ORDER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.CHEQUE.COLLECTION
    $INSERT I_F.REDO.RESUBMIT.FT.DET
    $INSERT I_F.REDO.STO.PENDING.RESUBMISSION
    $INSERT I_REDO.B.FT.RETRY.COMMON ;*Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES ;*Tus End

    GOSUB INIT
    GOSUB GET.OD.STATUS.COND
    GOSUB PROCESS
RETURN

*----
INIT:
*----
*-------------------------------------------------
* This section initialises the necessary variables
*-------------------------------------------------

    LOAN.STATUS = ''
    LOAN.COND = ''
    LS.LC.FLAG = 0
    DR.COND.FLAG = 0
    GTSMODE = ''
    NO.OF.AUTH = 0

RETURN

*-------
PROCESS:
*-------
*-------------------------------------------------------
* This section updates the local table after retrying FT
*-------------------------------------------------------

    IF ('JudicialCollection' MATCHES LOAN.STATUS) OR ('Write-off' MATCHES LOAN.STATUS) OR ('Legal' MATCHES LOAN.COND) THEN
        LS.LC.FLAG = 1
    END
    GOSUB GET.BILL.IDS
    CALL F.READ(FN.REDO.RESUBMIT.FT.DET,ARR.ID,R.REDO.RESUBMIT.FT.DET,F.REDO.RESUBMIT.FT.DET,FT.RESUB.ERR)
    FT.DATES = R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.DATE>

    LOCATE TODAY IN FT.DATES<1,1> SETTING FT.DATE.POS ELSE
        GOSUB GET.CUR.DATE.OS.AMT
        IF CUR.DATE.OS.AMT GT 0 THEN
            R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.FT.ID,-1> = FT.ID
            R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.DATE,-1> = TODAY
            R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.BILL.AMT,-1> = CUR.DATE.OS.AMT
            FT.DATES = R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.DATE>
        END
    END
    RESUB.FT.IDS = R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.FT.ID>

    RESUB.FT.CNT = 0
    LOOP
        RESUB.FT.CNT += 1
        REMOVE RESUB.FT.ID FROM RESUB.FT.IDS SETTING RESUB.FT.POS
    WHILE RESUB.FT.ID:RESUB.FT.POS
        ACT.FT.DATE = R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.DATE,RESUB.FT.CNT>
        DEAL.AMOUNT = R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.BILL.AMT,RESUB.FT.CNT>
        GOSUB UPDATE.BILLS
        CALL F.READ(FN.REDO.STO.PENDING.RESUBMISSION,RESUB.FT.ID,R.REDO.STO.PENDING.RESUBMISSION,F.REDO.STO.PENDING.RESUBMISSION,STO.RESUB.ERR)
        GOSUB GET.DR.AMT
        GOSUB CHK.CR.DR.COND
    REPEAT

    LOOP
        REMOVE DEL.FT.ID FROM DEL.FT.IDS SETTING DEL.FT.ID.POS
    WHILE DEL.FT.ID:DEL.FT.ID.POS
        LOCATE DEL.FT.ID IN RESUB.FT.IDS SETTING DEL.POS THEN
            DEL R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.FT.ID,DEL.POS>
            DEL R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.DATE,DEL.POS>
            DEL R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.BILL.AMT,DEL.POS>
            DEL R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.OFS.MSG.ID,DEL.POS>
            CALL F.DELETE(FN.REDO.STO.PENDING.RESUBMISSION,RESUB.FT.ID)
        END
    REPEAT
    CALL F.WRITE(FN.REDO.RESUBMIT.FT.DET,ARR.ID,R.REDO.RESUBMIT.FT.DET)
RETURN

*--------------
CHK.CR.DR.COND:
*--------------
*-----------------------------------------------------------------------------------------------------------------------------------
* This section checks whether loan status or condition exists on loan account and whether the debit account conditions are satisfied
*-----------------------------------------------------------------------------------------------------------------------------------

    IF DR.AMT EQ 0 THEN
        DEL.FT.IDS<-1> = RESUB.FT.ID
        RETURN
    END
    IF LS.LC.FLAG THEN
        RETURN
    END
    GOSUB CHK.DR.COND
    IF NOT(DR.COND.FLAG) THEN
        GOSUB EXECUTE.FT
    END

RETURN

*------------------
GET.OD.STATUS.COND:
*------------------
*----------------------------------------------------------------------------------------------------------------------
* This section gets the latest overdue record for the arrangement id and stores the value of loan status and condition
*----------------------------------------------------------------------------------------------------------------------

    PROP.CLASS = 'OVERDUE'
    PROPERTY = ''
    R.Condition = ''
    ERR.MSG = ''
    EFF.DATE = ''
    CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
    LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.STATUS.POS>
    LOAN.COND = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.COND.POS>
    CHANGE @SM TO @VM IN LOAN.STATUS
    CHANGE @SM TO @VM IN LOAN.COND
RETURN

*----------
GET.DR.AMT:
*----------
*-----------------------------------------------------------------------
* This section gets the latest amount to be debited during retry process
*-----------------------------------------------------------------------

    BILL.ID.CNT = 0
    DR.AMT = 0
    LOOP
        BILL.ID.CNT += 1
        REMOVE BILL.ID FROM FT.BILL.IDS SETTING FT.BILL.ID.POS
    WHILE BILL.ID:FT.BILL.ID.POS
        CALL F.READ(FN.AA.BILL.DETAILS,BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.DET.ERR)
        IF SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>) GT 0 THEN
            DR.AMT += SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
        END
    REPEAT
    R.REDO.STO.PENDING.RESUBMISSION<REDO.RESUB.DEBIT.AMOUNT> = DR.AMT

RETURN

*-----------
CHK.DR.COND:
*-----------
*----------------------------------------------------------------------
* This section checks whether the debit account condition are satisfied
*----------------------------------------------------------------------

    Y.ACCOUNT.1 = R.REDO.STO.PENDING.RESUBMISSION<REDO.RESUB.DEBIT.ACCT.NO>
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.1,R.ACCOUNT,F.ACCOUNT,ERR.ACC)
    R.ECB='' ; ECB.ERR='' ;*Tus Start
    CALL EB.READ.HVT('EB.CONTRACT.BALANCES',Y.ACCOUNT.1,R.ECB,ECB.ERR);*Tus End
    Y.STATUS.2 = R.ACCOUNT<AC.LOCAL.REF,POS.STATUS.2>
    IF Y.STATUS.2 NE '' THEN
        DR.COND.FLAG = 1
        RETURN
    END
    CNT.CHQ = 1
    CHANGE @VM TO @FM IN CHQ.COL.LST
    CHANGE @SM TO @FM IN CHQ.COL.LST
    CHQ.COL.CNT = DCOUNT(CHQ.COL.LST,@FM)
    LOOP
    WHILE CNT.CHQ LE CHQ.COL.CNT
        CHQ.COL.ID = CHQ.COL.LST<CNT.CHQ>
        CALL F.READ(FN.CHEQUE.COLLECTION,CHQ.COL.ID,R.CHEQUE.COLLECTION,F.CHEQUE.COLLECTION,CHQ.ERR)
        IF R.CHEQUE.COLLECTION<CHQ.COL.CREDIT.ACC.NO> EQ Y.ACCOUNT.1 AND R.CHEQUE.COLLECTION<CHQ.COL.EXPOSURE.DATE> NE TODAY THEN
            DR.COND.FLAG = 1
            CNT.CHQ = CHQ.COL.CNT+1
        END
        CNT.CHQ += 1
    REPEAT

* Y.ONLINE.ACT.BAL = R.ACCOUNT<AC.ONLINE.ACTUAL.BAL> ;*Tus Start
    Y.ONLINE.ACT.BAL = R.ECB<ECB.ONLINE.ACTUAL.BAL> ;*Tus End
    Y.LOCKED.AMOUNT = SUM(R.ACCOUNT<AC.LOCKED.AMOUNT>)
    Y.AVAIL.AMOUNT = Y.ONLINE.ACT.BAL - Y.LOCKED.AMOUNT

    Y.DEBIT.AMOUNT = DR.AMT
    CHARGE.TYPE = R.REDO.STO.PENDING.RESUBMISSION<REDO.RESUB.COMMISSION.TYPE>:@VM:R.REDO.STO.PENDING.RESUBMISSION<REDO.RESUB.CHARGE.TYPE>
    CHARGE.TYPE := R.REDO.STO.PENDING.RESUBMISSION<REDO.RESUB.TAX.TYPE>
    GOSUB GET.CHARGE.AMT
    Y.TOTAL.AMT = Y.DEBIT.AMOUNT + TOT.CHARGE.LCCY

    IF Y.AVAIL.AMOUNT LT Y.TOTAL.AMT THEN
        DR.COND.FLAG = 1
    END
RETURN

*--------------
GET.CHARGE.AMT:
*--------------
*-----------------------------------------------------
* This section calculates the total charges for the FT
*-----------------------------------------------------

    CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
    DEAL.CURRENCY = R.REDO.STO.PENDING.RESUBMISSION<REDO.RESUB.DEBIT.CURRENCY>
    CURRENCY.MARKET = 1
    CROSS.RATE = ''
    CROSS.CURRENCY = ''
    DRAWDOWN.CCY = ''
    T.DATA<1> = CHARGE.TYPE
    CUST.COND = ''
    TOT.CHARGE.LCCY = ''
    TOT.CHARGE.FCCY = ''
    CALL CALCULATE.CHARGE (CUSTOMER, Y.DEBIT.AMOUNT, DEAL.CURRENCY, CURRENCY.MARKET, CROSS.RATE, CROSS.CURRENCY, DRAWDOWN.CCY, T.DATA, CUST.COND, TOT.CHARGE.LCCY, TOT.CHARGE.FCCY)

RETURN

*----------
EXECUTE.FT:
*----------
*-----------------------------------------------------------
* This section creates FT using OFS as part of retry process
*-----------------------------------------------------------

    FT.ID = ''
    VAR.GTSMODE = ''
    R.FUNDS.TRANSFER = ''
    R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE> = R.REDO.STO.PENDING.RESUBMISSION<REDO.RESUB.TRANSACTION.TYPE>
    R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO> = R.REDO.STO.PENDING.RESUBMISSION<REDO.RESUB.DEBIT.ACCT.NO>
    R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY> = R.REDO.STO.PENDING.RESUBMISSION<REDO.RESUB.DEBIT.CURRENCY>
    R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT> = R.REDO.STO.PENDING.RESUBMISSION<REDO.RESUB.DEBIT.AMOUNT>
    R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE> = TODAY
    R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO> = R.REDO.STO.PENDING.RESUBMISSION<REDO.RESUB.CREDIT.ACCT.NO>
    R.FUNDS.TRANSFER<FT.COMMISSION.CODE> = R.REDO.STO.PENDING.RESUBMISSION<REDO.RESUB.COMMISSION.CODE>
    R.FUNDS.TRANSFER<FT.COMMISSION.TYPE> = R.REDO.STO.PENDING.RESUBMISSION<REDO.RESUB.COMMISSION.TYPE>

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,VAR.GTSMODE,NO.OF.AUTH,FT.ID,R.FUNDS.TRANSFER,OFSRECORD)
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
    R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.OFS.MSG.ID,RESUB.FT.CNT> = OFS.MSG.ID
RETURN

*------------
GET.BILL.IDS:
*------------
*-----------------------------------------------------------
* This section gets the list of bill ids for the arrangement
*-----------------------------------------------------------

    CALL F.READ(FN.AA.ACCOUNT.DETAILS,ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACT.DET.ERR)
    Y.BILL.DATE=R.AA.ACCOUNT.DETAILS<AA.AD.BILL.DATE>
    Y.BILL.IDS=R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    CHANGE @SM TO @FM IN Y.BILL.DATE
    CHANGE @VM TO @FM IN Y.BILL.DATE
    CHANGE @SM TO @FM IN Y.BILL.IDS
    CHANGE @VM TO @FM IN Y.BILL.IDS
    Y.BILL.COUNT=DCOUNT(Y.BILL.IDS,@FM)

RETURN

*------------
UPDATE.BILLS:
*------------
*--------------------------------------------------------------
* This section gets the list of bill ids for which FT is failed
*--------------------------------------------------------------

    FT.BILL.IDS = ''
    Y.AMOUNT=0
    Y.FLAG=0
    GOSUB CHECK.DEL.AMOUNT.1
    IF Y.AMOUNT EQ DEAL.AMOUNT THEN
        Y.FLAG += 1
    END
    IF Y.FLAG EQ 0 THEN
        FT.BILL.IDS=''
        Y.AMOUNT=0
        GOSUB CHECK.DEL.AMOUNT.2
    END
RETURN
*------------------
CHECK.DEL.AMOUNT.1:
*------------------
*----------------------------------------------------------
* This section gets the list of bill ids for the given date
*----------------------------------------------------------

    VAR1=1
    LOOP
    WHILE VAR1 LE Y.BILL.COUNT
        IF Y.BILL.DATE<VAR1> EQ ACT.FT.DATE THEN
            Y.BILL.ID=Y.BILL.IDS<VAR1>
            CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)
            Y.AMOUNT+=R.AA.BILL.DETAILS<AA.BD.OR.TOTAL.AMOUNT>
            FT.BILL.IDS<-1>=Y.BILL.ID
        END
        VAR1 += 1
    REPEAT
RETURN

*------------------
CHECK.DEL.AMOUNT.2:
*------------------
*-----------------------------------------------------------------------
* This section gets the list of bill ids for current date and past dates
*-----------------------------------------------------------------------

    VAR1=1
    LOOP
    WHILE VAR1 LE Y.BILL.COUNT
        IF Y.BILL.DATE<VAR1> LE ACT.FT.DATE THEN
            Y.BILL.ID=Y.BILL.IDS<VAR1>
            CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)
            Y.AMOUNT+=R.AA.BILL.DETAILS<AA.BD.OR.TOTAL.AMOUNT>
            FT.BILL.IDS<-1>=Y.BILL.ID
        END
        VAR1 += 1
    REPEAT
RETURN

*-------------------
GET.CUR.DATE.OS.AMT:
*-------------------
*-------------------------------------------------------------------------------
* This section computes the outstanding amount for which FT retry need to happen
*-------------------------------------------------------------------------------

    CUR.DATE.OS.AMT = 0
    VAR1=1
    LOOP
    WHILE VAR1 LE Y.BILL.COUNT
        IF Y.BILL.DATE<VAR1> EQ TODAY THEN
            Y.BILL.ID=Y.BILL.IDS<VAR1>
            CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)
            CUR.DATE.OS.AMT+=R.AA.BILL.DETAILS<AA.BD.OR.TOTAL.AMOUNT>
        END
        VAR1 += 1
    REPEAT
    IF CUR.DATE.OS.AMT GT 0 THEN
        GOSUB CREATE.FT.IN.HLD
    END
RETURN

*----------------
CREATE.FT.IN.HLD:
*----------------
*--------------------------------
* This section creates FT ih HOLD
*--------------------------------

    GOSUB GET.STO.ID
    FT.ID = ''
    CALL FT.GENERATE.ID('STO',FT.ID)
    R.FUNDS.TRANSFER = ''
    R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE> = R.STO<STO.PAY.METHOD>
    R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO> = FIELD(STO.ID,'.',1)
    R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY> = R.STO<STO.CURRENCY>
    R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT> = CUR.DATE.OS.AMT
    R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE> = TODAY
    R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO> = R.STO<STO.CPTY.ACCT.NO>
    R.FUNDS.TRANSFER<FT.COMMISSION.CODE> = R.STO<STO.COMMISSION.CODE>
    R.FUNDS.TRANSFER<FT.COMMISSION.TYPE> = R.STO<STO.COMMISSION.TYPE>
    R.FUNDS.TRANSFER<FT.LOCAL.REF,FT.LOAN.STATUS.POS> = LOAN.STATUS
    R.FUNDS.TRANSFER<FT.LOCAL.REF,FT.LOAN.COND.POS> = LOAN.COND
    CALL REDO.U.NEW.FT.IN.HOLD(ARR.ID,FT.ID,R.FUNDS.TRANSFER,R.STO)

RETURN

*----------
GET.STO.ID:
*----------
*-------------------------------------------------------------------------
* This section gets the STANDING.ORDER id corresponding to the arrangement
*-------------------------------------------------------------------------
    STO.CNT = 1
    CHANGE @VM TO @FM IN STO.ID.LST
    CHANGE @SM TO @FM IN STO.ID.LST
    STO.ID.CNT.CNT = DCOUNT(STO.ID.LST,@FM)
    LOOP
    WHILE STO.CNT LE STO.ID.CNT.CNT
        STO.ID = STO.ID.LST<STO.CNT>
        R.STO = ''
        CALL F.READ(FN.STANDING.ORDER,STO.ID,R.STO,F.STANDING.ORDER,STO.ERR)
        IF R.STO<STO.LOCAL.REF,STO.ARR.ID.POS> EQ ARR.ID THEN
            STO.CNT = STO.ID.CNT.CNT + 1
        END
        STO.CNT += 1
    REPEAT
RETURN
*--------------------------------------------------------------------------
END
