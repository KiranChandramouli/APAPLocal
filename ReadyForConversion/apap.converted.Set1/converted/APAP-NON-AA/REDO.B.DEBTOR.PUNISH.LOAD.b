SUBROUTINE REDO.B.DEBTOR.PUNISH.LOAD
*-----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine is used to initialize the variables and open files
*
* Developed By          : Nowful Rahman M
*
* Development Reference : 202_DE05
*
* Attached To           : BNK/REDO.B.DEBTOR.PUNISH
*
* Attached As           : Batch Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
* Argument#2 : NA
* Argument#3 : NA
*
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*   Date       Author              Modification Description
*
* 29/10/2014  Ashokkumar.V.P        PACS00400717 - New mapping changes
*-------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.B.DEBTOR.PUNISH.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_TSA.COMMON
    $INSERT I_F.DATES

    GOSUB INITIALIZE
RETURN
*-----------------------------------------------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------------------------------------------
*Initialize the variables
*-----------------------------------------------------------------------------------------------------------------
    FN.REDO.ACCT.MRKWOF.HIST = "F.REDO.ACCT.MRKWOF.HIST"
    F.REDO.ACCT.MRKWOF.HIST = ""
    CALL OPF(FN.REDO.ACCT.MRKWOF.HIST,F.REDO.ACCT.MRKWOF.HIST)

    FN.AA.ARR.OVERDUE = "F.AA.ARR.OVERDUE"
    F.AA.ARR.OVERDUE = ""
    CALL OPF(FN.AA.ARR.OVERDUE,F.AA.ARR.OVERDUE)

    FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"
    F.AA.ARRANGEMENT = ""
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.EB.CONTRACT.BALANCES = "F.EB.CONTRACT.BALANCES"
    F.EB.CONTRACT.BALANCES = ""
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.REDO.REPORT.TEMP = "F.REDO.REPORT.TEMP"
    F.REDO.REPORT.TEMP = ""
    CALL OPF(FN.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP)

    FN.RE.STAT.REP.LINE = "F.RE.STAT.REP.LINE"
    F.RE.STAT.REP.LINE = ""
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)

    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.DR.REG.DE05.WORKFILE = 'F.DR.REG.DE05.WORKFILE'; F.DR.REG.DE05.WORKFILE =''
    CALL OPF(FN.DR.REG.DE05.WORKFILE,F.DR.REG.DE05.WORKFILE)

    L.APAP.INDUSTRY.POS = ''; Y.L.LOAN.STATUS.1.POS = ''

    Y.APP = "CUSTOMER":@FM:"AA.PRD.DES.OVERDUE":@FM:"INDUSTRY"
    Y.FIELD = "L.CU.TIPO.CL":@VM:"L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.FOREIGN":@VM:'L.APAP.INDUSTRY':@FM:"L.STATUS.CHG.DT":@VM:"L.LOAN.STATUS.1":@FM:"L.AA.CATEG"
    Y.FIELD.POS = ""
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FIELD,Y.FIELD.POS)
    L.CU.TIPO.CL.POS = Y.FIELD.POS<1,1>
    L.CU.CIDENT.POS = Y.FIELD.POS<1,2>
    L.CU.RNC.POS = Y.FIELD.POS<1,3>     ;* (S/E) 20140619 incorrect value passed
    L.CU.FOREIGN.POS = Y.FIELD.POS<1,4>
    L.APAP.INDUSTRY.POS = Y.FIELD.POS<1,5>
    Y.STATUS.CHG.DT.POS = Y.FIELD.POS<2,1>
    Y.L.LOAN.STATUS.1.POS = Y.FIELD.POS<2,2>
    L.AA.CATEG.POS = Y.FIELD.POS<3,1>

    Y.LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.TODAY = TODAY
    YLST.TODAY = Y.TODAY
    CALL CDT('',YLST.TODAY,'-1C')
    Y.PARAM.ID = "REDO.DE05"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
    END ELSE
        GOSUB RAISE.ERR.C.22
    END
    Y.PRODUCT.RECORD = ""
    Y.PROPERTY.CLASS = "OVERDUE"
    Y.PROPERTY = ""
    Y.RETURN.CONDITION = ""
    Y.RET.ERR = ""
RETURN
*-----------------------------------------------------------------------------------------------------------------
RAISE.ERR.C.22:
*-----------------------------------------------------------------------------------------------------------------
*Handling error process
*-----------------------------------------------------------------------------------------------------------------
    MON.TP = "04"
    Y.ERR.MSG = "Record not found in REDO.H.REPORTS.PARAM"
    REC.CON = "DE05.":Y.PARAM.ID:Y.ERR.MSG
    DESC = "DE05.":Y.PARAM.ID:Y.ERR.MSG
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    EX.USER = ''
    EX.PC = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
RETURN
*------------------------------------------------------------------Final End--------------------------------------------------------------------------------
END
