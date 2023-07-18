*-----------------------------------------------------------------------------
* <Rating>-24</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.AA.ACC.NEG.VAL.LOAD
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*
*                       Ashokkumar.V.P                  07/09/2015      .
*--------------------------------------------------------------------------------------------------
*
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_F.DATES
    $INCLUDE T24.BP I_ENQUIRY.COMMON
    $INCLUDE LAPAP.BP I_REDO.B.AA.ACC.NEG.VAL.COMMON
    $INCLUDE TAM.BP I_F.REDO.H.REPORTS.PARAM


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

    FN.DR.REG.AA.PROB.WORKFILE = 'F.DR.REG.AA.ACC.WORKFILE'
    F.DR.REG.AA.PROB.WORKFILE = ''
    CALL OPF(FN.DR.REG.AA.PROB.WORKFILE,F.DR.REG.AA.PROB.WORKFILE)

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'; F.REDO.APAP.PROPERTY.PARAM = ''
    CALL OPF(FN.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'; F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    AC.LEN = 7      ;* This is length of word 'ACCOUNT'
    PRIN.INT.LEN = 12         ;* This is length of word 'PRINCIPALINT'
    PENL.INT.LEN = 6          ;* PENALT
    PROM.CHG.LEN = 6          ;* PROMORA

    LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    YTODAY = R.DATES(EB.DAT.TODAY)
    YLST.TODAY = YTODAY
*    CALL CDT('',YLST.TODAY,'-1C')
    YTLST.TODAY = YTODAY
    CALL CDT('',YTLST.TODAY,'-2C')
    RETURN

GET.LRF.POS:
*************
*----------------------------------------------------------------------
* This section gets the position of the local reference field positions
*----------------------------------------------------------------------
    LR.APP = 'AA.PRD.DES.PAYMENT.SCHEDULE':FM:'ACCOUNT':FM:"AA.PRD.DES.OVERDUE"
    LR.FLDS = 'L.AA.PAY.METHD':VM:'L.AA.DEBT.AC':FM
    LR.FLDS := 'L.AC.STATUS2':VM:'L.AC.AV.BAL':VM:'L.AC.TRAN.AVAIL':VM:'L.OD.STATUS':FM:'L.LOAN.STATUS.1'
    LR.POS = ''
    CALL MULTI.GET.LOC.REF(LR.APP,LR.FLDS,LR.POS)
    PAYMT.METHOD.POS   = LR.POS<1,1>
    DEBIT.ACCT.POS     = LR.POS<1,2>
    POS.STATUS.2       = LR.POS<2,1>
    POS.AVL.BAL        = LR.POS<2,2>
    POS.TRANS.AMT      = LR.POS<2,3>
    L.OD.STATUS.POS    = LR.POS<2,4>
    Y.L.LOAN.STATUS.1.POS = LR.POS<3,1>
    RETURN
END
