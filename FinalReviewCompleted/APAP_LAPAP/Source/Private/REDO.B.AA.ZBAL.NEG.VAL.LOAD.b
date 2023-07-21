$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.AA.ZBAL.NEG.VAL.LOAD
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*
*                       Ashokkumar.V.P                  07/09/2015      .
*--------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-07-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM,INSERT FILE MODIFIED
*13-07-2023              Samaran T                R22 Manual Code conversion                         No Changes
*----------------------------------------------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON  ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_REDO.B.AA.ZBAL.NEG.VAL.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM  ;*R22 AUTO CODE CONVERSION.END


    GOSUB OPEN.FILES
    GOSUB GET.LRF.POS
RETURN

OPEN.FILES:
***********
    FN.AA.ARR = 'F.AA.ARRANGEMENT'
    F.AA.ARR = ''
    CALL OPF(FN.AA.ARR,F.AA.ARR)

    FN.EB.CON.BAL = 'F.EB.CONTRACT.BALANCES'
    F.EB.CON.BAL = ''
    CALL OPF(FN.EB.CON.BAL,F.EB.CON.BAL)

    FN.REDO.CONCAT.ACC.NAB = 'F.REDO.CONCAT.ACC.NAB'
    F.REDO.CONCAT.ACC.NAB = ''
    CALL OPF(FN.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB)

    FN.DR.REG.AA.PROB.WORKFILE = 'F.DR.REG.AA.PROB.WORKFILE'
    F.DR.REG.AA.PROB.WORKFILE = ''
    CALL OPF(FN.DR.REG.AA.PROB.WORKFILE,F.DR.REG.AA.PROB.WORKFILE)

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

    FN.AA.ARRANGEMENT.ACTIVITY.H = "F.AA.ARRANGEMENT.ACTIVITY$HIS"
    F.AA.ARRANGEMENT.ACTIVITY.H = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY.H,F.AA.ARRANGEMENT.ACTIVITY.H)

    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

    FN.FUNDS.TRANS.H = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANS.H = ''
    CALL OPF(FN.FUNDS.TRANS.H,F.FUNDS.TRANS.H)

    FN.FUNDS.TRANS = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANS = ''
    CALL OPF(FN.FUNDS.TRANS,F.FUNDS.TRANS)

    FN.AA.INTEREST.ACCRUALS = 'F.AA.INTEREST.ACCRUALS'
    F.AA.INTEREST.ACCRUALS = ''
    CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)

    FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'; F.REDO.APAP.PROPERTY.PARAM = ''
    CALL OPF(FN.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'; F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    AC.LEN = 7      ;* This is length of word 'ACCOUNT'
    PRIN.INT.LEN = 12         ;* This is length of word 'PRINCIPALINT'
    PENL.INT.LEN = 6          ;* PENALT
    PROM.CHG.LEN = 6          ;* PROMORA

    LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    YLST.TODAY = TODAY
    CALL CDT('',YLST.TODAY,'-1C')
    IF LAST.WORK.DAY[5,2] NE YLST.TODAY[5,2] THEN
        COMI = LAST.WORK.DAY[1,6]:'01'
        CALL LAST.DAY.OF.THIS.MONTH
        YLST.TODAY = COMI
    END
RETURN

GET.LRF.POS:
*************
*----------------------------------------------------------------------
* This section gets the position of the local reference field positions
*----------------------------------------------------------------------
    LR.APP = 'AA.PRD.DES.PAYMENT.SCHEDULE':@FM:'ACCOUNT':@FM:"AA.PRD.DES.OVERDUE"  ;*R22 AUTO CODE CONVERSION
    LR.FLDS = 'L.AA.PAY.METHD':@VM:'L.AA.DEBT.AC':@FM  ;*R22 AUTO CODE CONVERSION
    LR.FLDS := 'L.AC.STATUS2':@VM:'L.AC.AV.BAL':@VM:'L.AC.TRAN.AVAIL':@VM:'L.OD.STATUS':@FM:'L.LOAN.STATUS.1':@VM:'L.LOAN.COND'  ;*R22 AUTO CODE CONVERSION
    LR.POS = ''
    CALL MULTI.GET.LOC.REF(LR.APP,LR.FLDS,LR.POS)
    PAYMT.METHOD.POS   = LR.POS<1,1>
    DEBIT.ACCT.POS     = LR.POS<1,2>
    POS.STATUS.2       = LR.POS<2,1>
    POS.AVL.BAL        = LR.POS<2,2>
    POS.TRANS.AMT      = LR.POS<2,3>
    L.OD.STATUS.POS    = LR.POS<2,4>
    Y.L.LOAN.STATUS.1.POS = LR.POS<3,1>
    L.LOAN.COND.POS = LR.POS<3,2>
RETURN
END
