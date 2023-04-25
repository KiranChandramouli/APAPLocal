*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.COMMER.DEBTOR.UPD.LOAD
*--------------------------------------------------------------------------------------------------
*
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
* Include files
*--------------------------------------------------------------------------------------------------
*
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.AA.ACCOUNT
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_F.EB.CONTRACT.BALANCES
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT T24.BP I_F.AA.OVERDUE
    $INSERT T24.BP I_F.AA.TERM.AMOUNT
    $INSERT T24.BP I_F.AA.ARRANGEMENT
    $INSERT T24.BP I_F.DATES
    $INSERT T24.BP I_TSA.COMMON
    $INSERT T24.BP I_BATCH.FILES
    $INSERT LAPAP.BP I_REDO.B.COMMER.DEBTOR.UPD.COMMON
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT TAM.BP I_F.REDO.CUSTOMER.ARRANGEMENT
*
    GOSUB INIT
    GOSUB FIND.LOC.REF
    GOSUB PROCESS
    GOSUB GET.VALUES
    RETURN

INIT:
*---
    FN.REDO.H.REPORTS.PARAM = ''
    F.REDO.H.REPORTS.PARAM = ''
    FN.EB.CON.BAL = ''
    F.EB.CON.BAL = ''
    FN.CUSTOMER = ''
    F.CUSTOMER = ''
    FN.AA.ARR.TERM.AMOUNT = ''
    F.AA.ARR.TERM.AMOUNT = ''
    L.TIP.CLI.POS = ''
    FN.AA.ARRANGEMENT = ''
    F.AA.ARRANGEMENT = ''
    L.CU.FOREIGN.POS = ''
    L.APAP.INDUSTRY.POS = ''; YTODAY.DAT = ''
    RETURN

FIND.LOC.REF:
*-----------
    Y.APP = "CUSTOMER":FM:"INDUSTRY":FM:"AA.PRD.DES.OVERDUE":FM:'ACCOUNT'
    Y.FIELDS = "L.CU.TIPO.CL":VM:"L.CU.CIDENT":VM:"L.CU.RNC":VM:"L.CU.DEBTOR":VM:"L.TIP.CLI":VM:"L.CU.PASS.NAT":VM:"L.APAP.INDUSTRY":VM:"L.CU.COM.CLASIF":FM:"L.AA.CATEG":FM:"L.LOAN.STATUS.1":FM:"L.OD.STATUS"
    Y.FIELD.POS = ""
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FIELDS,Y.FIELD.POS)
    L.CU.TIPO.CL.POS = Y.FIELD.POS<1,1>
    L.CU.CIDENT.POS = Y.FIELD.POS<1,2>
    L.CU.RNC.POS = Y.FIELD.POS<1,3>
    L.CU.DEBTOR.POS = Y.FIELD.POS<1,4>
    L.TIP.CLI.POS = Y.FIELD.POS<1,5>
    L.CU.FOREIGN.POS =  Y.FIELD.POS<1,6>
    L.APAP.INDUSTRY.POS = Y.FIELD.POS<1,7>
    L.AA.MMD.PYME.POS = Y.FIELD.POS<1,8>
    L.AA.CATEG.POS = Y.FIELD.POS<2,1>
    Y.L.LOAN.STATUS.1.POS = Y.FIELD.POS<3,1>
    L.OD.STATUS.POS = Y.FIELD.POS<4,1>
    RETURN

PROCESS:
*------
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    FN.REDO.CUSTOMER.ARRANGEMENT = 'F.REDO.CUSTOMER.ARRANGEMENT'
    F.REDO.CUSTOMER.ARRANGEMENT = ''
    CALL OPF(FN.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT)
*
    FN.EB.CON.BAL = 'F.EB.CONTRACT.BALANCES'
    F.EB.CON.VAL = ''
    CALL OPF(FN.EB.CON.BAL,F.EB.CON.BAL)
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*
    FN.AA.ARR.TERM.AMOUNT = "F.AA.ARR.TERM.AMOUNT"
    F.AA.ARR.TERM.AMOUNT  = ""
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)
*
    FN.REDO.CONCAT.ACC.NAB = 'F.REDO.CONCAT.ACC.NAB'
    F.REDO.CONCAT.ACC.NAB = ''
    CALL OPF(FN.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'; F.REDO.APAP.PROPERTY.PARAM = ''
    CALL OPF(FN.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'; F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    FN.REDO.APAP.COMMER.DEBT.DET = 'F.REDO.APAP.COMMER.DEBT.DET'
    F.REDO.APAP.COMMER.DEBT.DET = ''
    CALL OPF(FN.REDO.APAP.COMMER.DEBT.DET, F.REDO.APAP.COMMER.DEBT.DET)
    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'; F.RE.STAT.REP.LINE = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)
    RETURN

GET.VALUES:
*----------
    YLAST.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.TODAY = TODAY
    YTODAY.DAT = Y.TODAY
    CALL CDT('',YTODAY.DAT,'-1C')
    IF YLAST.DATE[5,2] NE YTODAY.DAT[5,2] THEN
        COMI = YLAST.DATE[1,6]:'01'
        CALL LAST.DAY.OF.THIS.MONTH
        YTODAY.DAT = COMI
    END
    Y.REP.PARAM.ID = "REDO.DE08"
    Y.RCL.DEB.ID = "REDO.RCL.DE08"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.REP.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.OUTPUT.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.FILE.NAME  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FILE.DIR   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        Y.FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    END
    RETURN
END