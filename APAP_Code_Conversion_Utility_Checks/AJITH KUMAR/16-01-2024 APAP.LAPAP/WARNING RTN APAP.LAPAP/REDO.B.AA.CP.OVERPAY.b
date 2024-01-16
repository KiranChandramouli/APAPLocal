$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.AA.CP.OVERPAY(OVERPAY.ID)

*-------------------------------------------------
*Description: This batch routine is to post the FT OFS messages for overpayment
*             and also to credit the interest in loan..
* Dev by: V.P.Ashokkumar
* Date  : 10/10/2016
*-------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*20-07-2023     Conversion tool             R22 auto code conversion      No change
*20-07-2023        samaran T                R22 Manual code conversion      No change

*---------------------------------------------------------------------------------------
    $INSERT  I_COMMON ;*R22 MANUAL CODE CONVERSION.START
    $INSERT  I_EQUATE
    $INSERT  I_F.DATES
    $INSERT  I_AA.LOCAL.COMMON
    $INSERT  I_F.AA.PAYMENT.SCHEDULE
    $INSERT  I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT  I_F.ACCOUNT
    $INSERT  I_BATCH.FILES
    $INSERT  I_F.REDO.AA.CP.OVERPAYMENT
    $INSERT  I_F.REDO.AA.OVERPAYMENT
    $INSERT  I_REDO.B.AA.OVERPAY.COMMON ;*R22 MANUAL CODE CONVERSION.END


    GOSUB PROCESS
RETURN

PROCESS:
********

    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ 'NEW.OVERPAY'
            ERR.REDO.AA.CP.OVERPAYMENT = ''; R.REDO.AA.CP.OVERPAYMENT = ''
*            CALL F.READ(FN.REDO.AA.CP.OVERPAYMENT,OVERPAY.ID,R.REDO.AA.CP.OVERPAYMENT,F.REDO.AA.CP.OVERPAYMENT,ERR.REDO.AA.CP.OVERPAYMENT)
            CALL F.READU(FN.REDO.AA.CP.OVERPAYMENT,OVERPAY.ID,R.REDO.AA.CP.OVERPAYMENT,F.REDO.AA.CP.OVERPAYMENT,ERR.REDO.AA.CP.OVERPAYMENT,'');* R22 UTILITY AUTO CONVERSION
            IF NOT(R.REDO.AA.CP.OVERPAYMENT) THEN
                RETURN
            END

            Y.AA.ID = R.REDO.AA.CP.OVERPAYMENT<REDO.AA.CP.LOAN.NO>
            IF Y.AA.ID THEN
                GOSUB SUB.PROCESS
* Delete the already processed Extrordinary payment record.
                CALL F.DELETE(FN.REDO.AA.CP.OVERPAYMENT,OVERPAY.ID)
            END

        CASE CONTROL.LIST<1,1> EQ 'OLD.OVERPAY'
            R.REDO.AA.OVERPAYMENT = ''; OVER.ERR = ''
            CALL F.READ(FN.REDO.AA.OVERPAYMENT,OVERPAY.ID,R.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT,OVER.ERR)
            IF NOT(R.REDO.AA.OVERPAYMENT) THEN
                RETURN
            END
            Y.LOAN.ACC = R.REDO.AA.OVERPAYMENT<REDO.OVER.LOAN.NO>
            IF NOT(Y.LOAN.ACC) THEN
                RETURN
            END

            ERR.ACCOUNT = ''; R.ACCOUNT = ''
            CALL F.READ(FN.ACCOUNT,Y.LOAN.ACC,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
            Y.AA.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
            IF Y.AA.ID THEN
                GOSUB SUB.PROCESS
            END
    END CASE
RETURN

SUB.PROCESS:
************
    PROCESS.MSG = ''
    Y.ACT = 'LENDING-CHANGE-REPAYMENT.SCHEDULE'
    Y.AAA.REQ<AA.ARR.ACT.ARRANGEMENT> = Y.AA.ID
    Y.AAA.REQ<AA.ARR.ACT.ACTIVITY> = Y.ACT
    Y.AAA.REQ<AA.ARR.ACT.EFFECTIVE.DATE> = TODAY
    Y.AAA.REQ<AA.ARR.ACT.PROPERTY,1> = 'REPAYMENT.SCHEDULE'

    APP.NAME = 'AA.ARRANGEMENT.ACTIVITY'
    IN.FUNCTION = 'I'
    VERSION.NAME = 'AA.ARRANGEMENT.ACTIVITY,ZERO.AUTH'
    CALL OFS.BUILD.RECORD(APP.NAME, IN.FUNCTION, "PROCESS", VERSION.NAME, "", "0", AAA.ID, Y.AAA.REQ, PROCESS.MSG)

    OFS.MSG.ID = ''; OFS.ERR = ''
    OFS.SOURCE = 'TRIGGER.INSURANCE'
    CALL OFS.POST.MESSAGE(PROCESS.MSG,OFS.MSG.ID,OFS.SOURCE,OFS.ERR)

RETURN
END
