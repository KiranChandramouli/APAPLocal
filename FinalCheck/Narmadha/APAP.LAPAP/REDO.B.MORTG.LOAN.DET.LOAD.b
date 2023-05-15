$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.MORTG.LOAN.DET.LOAD
*--------------------------------------------------------------------------------------------------
* Description           : This is the Batch Load Routine used to initalize all the required variables
*
* Developed By          : Vijayarani G
*
* Development Reference : 786872(FS-210-DE25)
*
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*-----------------*
* Output Parameter:
* ----------------*
* Argument#2 : NA
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
*--------------------------------------------------------------------------------------------------
* PACS00362987           Ashokkumar.V.P                 29/10/2014            New mapping changes - Rewritten the whole source.
* PACS00464363           Ashokkumar.V.P                 22/06/2015            Changed to avoid ageing problem and mapping changes.
** 24-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 24-04-2023 Skanda R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.COMPANY ;* R22 Auto conversion
    $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_F.AA.ACCOUNT.DETAILS ;* R22 Auto conversion
    $INSERT I_F.AA.PRODUCT ;* R22 Auto conversion
    $INSERT I_F.AA.OVERDUE ;* R22 Auto conversion
    $INSERT I_F.ACCOUNT ;* R22 Auto conversion
    $INSERT I_F.AA.ARRANGEMENT ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $INSERT I_REDO.B.MORTG.LOAN.DET.COMMON ;* R22 Auto conversion
    $INSERT I_F.RE.STAT.REP.LINE ;* R22 Auto conversion
    $INSERT I_F.AA.BILL.DETAILS ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_TSA.COMMON ;* R22 Auto conversion
*   $INSERT I_BATCH.FILES ;* R22 Auto conversion
*
    GOSUB INITIALISATION
    GOSUB FIND.LOC.REF.FLDS
    GOSUB GET.BATCH.VALUE
RETURN
*
*--------------
INITIALISATION:
*-------------
*
    FN.COMPANY = ""
    F.COMPANY = ""
    FN.AA.ARR = ""
    F.AA.ARR = ""
    FN.RE.STAT.REP.LINE = ""
    F.RE.STAT.REP.LINE = ""
    FN.AA.ACCT.DET = ""
    F.AA.ACCT.DET = ""
    FN.EB.CONT.BAL = ""
    F.EB.CONT.BAL = ""
    FN.PRODUCT = ""
    F.PRODUCT = ""
    FN.ACCOUNT = ""
    F.ACCOUNT = ""
    FN.AA.BILL.DET = ""
    F.AA.BILL.DET = ""
    Y.REPORT.PARAM.ID = ""
    Y.RCL.ID = ""
    Y.FILE.NAME = ""
    Y.FIELD.NME.ARR = ""
    Y.FIELD.VAL.ARR = ""
    Y.DISP.TEXT.ARR = ""
    Y.ERR.MSG = ""
    Y.L.LOAN.STATUS.1.POS = ''

*
    FN.AA.ARR = "F.AA.ARRANGEMENT"
    F.AA.ARR = ""
    CALL OPF(FN.AA.ARR,F.AA.ARR)
*
    FN.RE.STAT.REP.LINE = "F.RE.STAT.REP.LINE"
    F.RE.STAT.REP.LINE = ""
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)
*
    FN.AA.ACCT.DET = "F.AA.ACCOUNT.DETAILS"
    F.AA.ACCT.DET = ""
    CALL OPF(FN.AA.ACCT.DET,F.AA.ACCT.DET)
*
    FN.COMPANY = "F.COMPANY"
    F.COMPANY = ""
    CALL OPF(FN.COMPANY,F.COMPANY)
*
    FN.EB.CONT.BAL = "F.EB.CONTRACT.BALANCES"
    F.EB.CONT.BAL = ""
    CALL OPF(FN.EB.CONT.BAL,F.EB.CONT.BAL)
*
    FN.AA.OVERDUE = "F.AA.ARR.OVERDUE"
    F.AA.OVERDUE = ""
    CALL OPF(FN.AA.OVERDUE,F.AA.OVERDUE)
*
    FN.PRODUCT = "F.AA.PRODUCT"
    F.PRODUCT = ""
    CALL OPF(FN.PRODUCT,F.PRODUCT)
*
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    FN.AA.BILL.DET = "F.AA.BILL.DETAILS"
    F.AA.BILL.DET = ""
    CALL OPF(FN.AA.BILL.DET,F.AA.BILL.DET)

    FN.REDO.CONCAT.ACC.NAB = 'F.REDO.CONCAT.ACC.NAB'
    F.REDO.CONCAT.ACC.NAB = ''
    CALL OPF(FN.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB)

    FN.REDO.B.MORTG.LOAN.WORKFILE = 'F.REDO.B.MORTG.LOAN.WORKFILE'
    F.REDO.B.MORTG.LOAN.WORKFILE = ''
    CALL OPF(FN.REDO.B.MORTG.LOAN.WORKFILE,F.REDO.B.MORTG.LOAN.WORKFILE)

    FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'; F.REDO.APAP.PROPERTY.PARAM = ''
    CALL OPF(FN.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'; F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)
RETURN
*
FIND.LOC.REF.FLDS:
*---------------
    Y.APPL = 'AA.PRD.DES.OVERDUE':@FM:'ACCOUNT'
    Y.FLD = 'L.LOAN.STATUS.1':@FM:'L.OD.STATUS'
    Y.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPL,Y.FLD,Y.POS)
    Y.L.LOAN.STATUS.1.POS = Y.POS<1,1>
    L.OD.STATUS.POS = Y.POS<2,1>
RETURN
*---------------
GET.BATCH.VALUE:
*---------------
    DATE.TODAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.TODAY = TODAY
    YLST.TODAY = Y.TODAY
    CALL CDT('',YLST.TODAY,'-1C')
    IF DATE.TODAY[5,2] NE YLST.TODAY[5,2] THEN
        COMI = DATE.TODAY[1,6]:'01'
        CALL LAST.DAY.OF.THIS.MONTH
        YLST.TODAY = COMI
    END
    Y.REPORT.PARAM.ID = "REDO.DE25"
    Y.RCL.ID          = "REDO.RCL.DE25"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.REPORT.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
    END
RETURN
*
RAISE.ERR.C.22:
*-----------------------------------------------------------------------------------------------------------------
*Handling Fatal error to halt the process
*-----------------------------------------------------------------------------------------------------------------
    MON.TP    = "25"
    Y.ERR.MSG = Y.ERR.MSG
    REC.CON   = "DE25-LOAD-":Y.ERR.MSG
    DESC      = "DE25-LOAD-":Y.ERR.MSG
    INT.CODE  = 'REP001'
    INT.TYPE  = 'ONLINE'
    BAT.NO    = ''
    BAT.TOT   = ''
    INFO.OR   = ''
    INFO.DE   = ''
    ID.PROC   = ''
    EX.USER   = ''
    EX.PC     = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
*
RETURN
END
