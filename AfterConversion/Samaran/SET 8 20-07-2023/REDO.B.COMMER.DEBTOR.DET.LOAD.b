$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-27</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.COMMER.DEBTOR.DET.LOAD
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Description:
*------------
* * This multi-thread job is meant for to extact the commercial loans happened on daily basis
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*-----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*13-07-2023       Conversion Tool        R22 Auto Code conversion         $INCLUDE TO $INSERT
*13-07-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------------

    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_BATCH.FILES
    $INSERT  I_F.DATES
    $INSERT  I_REDO.B.COMMER.DEBTOR.DET.COMMON
    $INSERT  I_DR.REG.COMM.LOAN.SECTOR.COMMON
    $INSERT  I_F.REDO.H.REPORTS.PARAM
    $INSERT  I_REDO.GENERIC.FIELD.POS.COMMON
*$INSERT T24.BP I_F.AA.ARR.ACCOUNT

    GOSUB INIT.PROCESS
    GOSUB INIT.PARAM
RETURN

*-----------------------------------------------------------------------------
INIT.PROCESS:
*-----------*
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

* Added by Mauricio M. - Start
    FN.AA.ARR.ACCOUNT = 'F.AA.ARR.ACCOUNT'
    F.AA.ARR.ACCOUNT = ''
    CALL OPF(FN.AA.ARR.ACCOUNT,F.AA.ARR.ACCOUNT)
* Added by Mauricio M. - end

    FN.DR.REG.DE08DT.WORKFILE = 'F.DR.REG.DE08DT.WORKFILE'
    F.DR.REG.DE08DT.WORKFILE = ''
    CALL OPF(FN.DR.REG.DE08DT.WORKFILE,F.DR.REG.DE08DT.WORKFILE)

    FN.AA.INTEREST.ACCRUALS='F.AA.INTEREST.ACCRUALS'
    F.AA.INTEREST.ACCRUALS=''
    CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*
    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

* Added by Mauricio M.  - Start
    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'
    F.RE.STAT.REP.LINE = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)

    FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'
    F.AA.ARR.TERM.AMOUNT = ''
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)

    FN.AA.PRODUCT.GROUP = 'F.AA.PRODUCT.GROUP'
    F.AA.PRODUCT.GROUP = ''
    CALL OPF(FN.AA.PRODUCT.GROUP,F.AA.PRODUCT.GROUP)
* Added by Mauricio M. - end

    FN.REDO.CONCAT.ACC.NAB = 'F.REDO.CONCAT.ACC.NAB'
    F.REDO.CONCAT.ACC.NAB  = ''
    CALL OPF(FN.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'; F.REDO.APAP.PROPERTY.PARAM = ''
    CALL OPF(FN.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'; F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    FN.ACCOUNT.HST = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HST = ''
    CALL OPF(FN.ACCOUNT.HST,F.ACCOUNT.HST)
RETURN

INIT.PARAM:
**********
    Y.REPORT.PARAM.ID = "REDO.DE08"
    R.REDO.H.REPORTS.PARAM = ''; PARAM.ERR = ''; Y.TXNPGRP.VAL.ARR = ''; Y.TXNLINPD.VAL.ARR = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.REPORT.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
    END
    LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    YTODAY = R.DATES(EB.DAT.TODAY)
    YLST.TODAY = YTODAY
    CALL CDT('',YLST.TODAY,'-1C')
    IF LAST.WORK.DAY[5,2] NE YLST.TODAY[5,2] THEN
        COMI = LAST.WORK.DAY[1,6]:'01'
        CALL LAST.DAY.OF.THIS.MONTH
        YLST.TODAY = COMI
    END

    LOC.APP = 'CUSTOMER':@FM:'AA.PRD.DES.OVERDUE':@FM:'AA.PRD.DES.ACCOUNT':@FM:'SECTOR':@FM:'ACCOUNT':@FM:'AA.ARR.ACCOUNT'
    LOC.FLD = 'L.CU.TIPO.CL':@VM:'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.AA.MMD.PYME':@VM:'L.APAP.INDUSTRY':@VM:'L.CU.PASS.NAT':@VM:'L.TIP.CLI':@VM:'L.CU.DEBTOR':@FM:'L.LOAN.STATUS.1':@FM:'ORIGEN.RECURSOS':VM:'L.AA.LOAN.DSN':@FM:'L.REP.COM.SEC':@FM:'L.OD.STATUS':@FM:'L.AA.LOAN.DSN'
    LOC.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.APP,LOC.FLD,LOC.POS)
    L.CU.TIPO.CL.POS = LOC.POS<1,1>
    L.CU.CIDENT.POS = LOC.POS<1,2>
    L.CU.RNC.POS = LOC.POS<1,3>
    L.AA.MMD.PYME.POS = LOC.POS<1,4>
    L.APAP.INDUSTRY.POS = LOC.POS<1,5>
    L.CU.FOREIGN.POS = LOC.POS<1,6>
    L.TIP.CLI.POS = LOC.POS<1,7>
    L.CU.DEBTOR.POS = LOC.POS<1,8>
    L.LOAN.STATUS.1.POS = LOC.POS<2,1>
    ORIGEN.RECURSOS.POS = LOC.POS<3,1>
    L.AA.LOAN.DSN.POS = LOC.POS<3,2>
    L.REP.COM.SEC.POS = LOC.POS<4,1>    ;* added by M.Medina
    L.OD.STATUS.POS = LOC.POS<5,1>
    L.AA.LOAN.DSN.POST = LOC.POS<6,1>
*
    MAT RCL$COMM.LOAN = ""    ;* Initialise the common variable for fresh use
RETURN
*-----------------------------------------------------------------------------
END
