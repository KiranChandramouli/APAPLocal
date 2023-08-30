$PACKAGE APAP.TAM
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
* 15/01/2018  Ashokkumar            CN008154 -> Added new field to display Currency and amended the Tipo de Operacion field.
** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*-------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_TSA.COMMON ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_REDO.B.DEBTOR.PUNISH.COMMON ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON ;* R22 Auto conversion

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

    FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'; F.REDO.APAP.PROPERTY.PARAM = ''
    CALL OPF(FN.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'; F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    FN.REDO.APAP.CREDIT.CARD.DET = 'F.REDO.APAP.CREDIT.CARD.DET'; F.REDO.APAP.CREDIT.CARD.DET = ''
    CALL OPF(FN.REDO.APAP.CREDIT.CARD.DET,F.REDO.APAP.CREDIT.CARD.DET)

    L.APAP.INDUSTRY.POS = ''; Y.L.LOAN.STATUS.1.POS = ''

    Y.APP = "CUSTOMER":@FM:"AA.PRD.DES.OVERDUE":@FM:"INDUSTRY"
    Y.FIELD = "L.CU.TIPO.CL":@VM:"L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.PASS.NAT":@VM:'L.APAP.INDUSTRY':@VM:'L.CU.DEBTOR':@FM:"L.STATUS.CHG.DT":@VM:"L.LOAN.STATUS.1":@VM:"L.LOAN.COND":@FM:"L.AA.CATEG"
    Y.FIELD.POS = ""
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FIELD,Y.FIELD.POS)
    L.CU.TIPO.CL.POS = Y.FIELD.POS<1,1>
    L.CU.CIDENT.POS = Y.FIELD.POS<1,2>
    L.CU.RNC.POS = Y.FIELD.POS<1,3>     ;* (S/E) 20140619 incorrect value passed
    L.CU.FOREIGN.POS = Y.FIELD.POS<1,4>
    L.APAP.INDUSTRY.POS = Y.FIELD.POS<1,5>
    L.CU.DEBTOR.POSN = Y.FIELD.POS<1,6>
    Y.STATUS.CHG.DT.POS = Y.FIELD.POS<2,1>
    Y.L.LOAN.STATUS.1.POS = Y.FIELD.POS<2,2>
    L.LOAN.COND.POS = Y.FIELD.POS<2,3>
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
    END
    Y.PRODUCT.RECORD = ""
    Y.PROPERTY.CLASS = "OVERDUE"
    Y.PROPERTY = ""
    Y.RETURN.CONDITION = ""
    Y.RET.ERR = ""
RETURN

END
