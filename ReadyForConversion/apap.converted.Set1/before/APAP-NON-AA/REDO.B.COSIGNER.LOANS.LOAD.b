*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.COSIGNER.LOANS.LOAD
*-----------------------------------------------------------------------------------------------------------------
* Description           : This routine is used to initialize the variables and open files
*
* Developed By          : Saranraj S
*
* Development Reference : DE04
*
* Attached To           : BATCH>BNK/REDO.B.COSIGNER.LOANS
*
* Attached As           : Batch Routine
*-----------------------------------------------------------------------------------------------------------------
*------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
* Argument#2 : NA
* Argument#3 : NA
*-----------------------------------------------------------------------------------------------------------------
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
*XXXX                   <<name of modifier>>                                 <<modification details goes here>>
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.AA.OVERDUE
    $INSERT TAM.BP I_REDO.B.COSIGNER.LOANS.COMMON
    $INSERT TAM.BP I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT I_TSA.COMMON

    GOSUB INITIALIZE
    GOSUB PROCESS

    RETURN
*----------
INITIALIZE:
*----------
    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER  = ""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.INDUSTRY = 'F.INDUSTRY'
    F.INDUSTRY  = ''
    CALL OPF(FN.INDUSTRY,F.INDUSTRY)

    FN.AA.ARR.CUSTOMER = 'F.AA.ARR.CUSTOMER'
    F.AA.ARR.CUSTOMER  = ''
    CALL OPF(FN.AA.ARR.CUSTOMER,F.AA.ARR.CUSTOMER)

    FN.REDO.ACCT.MRKWOF.HIST = 'F.REDO.ACCT.MRKWOF.HIST'
    F.REDO.ACCT.MRKWOF.HIST  = ''
    CALL OPF(FN.REDO.ACCT.MRKWOF.HIST,F.REDO.ACCT.MRKWOF.HIST)

    FN.AA.ARR.OVERDUE = 'F.AA.ARR.OVERDUE'
    F.AA.ARR.OVERDUE  = ''
    CALL OPF(FN.AA.ARR.OVERDUE,F.AA.ARR.OVERDUE)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    YL.TODAY = TODAY

    FN.DR.REG.DE04.WORKFILE = 'F.DR.REG.DE04.WORKFILE'; F.DR.REG.DE04.WORKFILE =''
    CALL OPF(FN.DR.REG.DE04.WORKFILE,F.DR.REG.DE04.WORKFILE)

    L.APAP.INDUSTRY.POS = ''
    Y.APPL.NAME = 'CUSTOMER':FM:'INDUSTRY':FM:'AA.PRD.DES.OVERDUE'
    Y.APPL.FLD  = 'L.CU.CIDENT':VM:'L.CU.RNC':VM:'L.CU.FOREIGN':VM:'L.CU.TIPO.CL':VM:'L.CU.DEBTOR':VM:'L.APAP.INDUSTRY':FM:'L.AA.CATEG':FM:'L.LOAN.STATUS.1'
    Y.FLD.POS   = ''
    CALL MULTI.GET.LOC.REF(Y.APPL.NAME,Y.APPL.FLD,Y.FLD.POS)
    L.CU.CIDENT.POS   = Y.FLD.POS<1,1>
    L.CU.RNC.POS      = Y.FLD.POS<1,2>
    L.CU.FOREIGN.POS  = Y.FLD.POS<1,3>
    L.CU.TIPO.CL.POS  = Y.FLD.POS<1,4>
    L.CU.DEBTOR.POS   = Y.FLD.POS<1,5>
    L.APAP.INDUSTRY.POS = Y.FLD.POS<1,6>
    L.AA.CATEG.POS    = Y.FLD.POS<2,1>
    Y.LOAN.STATUS.POS = Y.FLD.POS<3,1>

    RETURN
*-------
PROCESS:
*-------
    Y.REPORT.PARAM.ID = "REDO.RCL.DE04"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.REPORT.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.OUT.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
*        Y.TEMP.FILE.NAME = Y.OUT.FILE.NAME:".TEMP.":SESSION.NO:".":SERVER.NAME
    END ELSE
        GOSUB RAISE.ERR.C.22
    END
    RETURN
*---------------
RAISE.ERR.C.22:
*---------------
    MON.TP = "04"
    Y.ERR.MSG = "Record not found"
    REC.CON = "DE04-":Y.ERR.MSG
    DESC = "DE04-":Y.ERR.MSG
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    BAT.NO   = ''
    BAT.TOT  = ''
    INFO.OR  = ''
    INFO.DE  = ''
    ID.PROC  = ''
    EX.USER  = ''
    EX.PC    = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    RETURN
*--------------------------------------------------End Of Record------------------------------------------------------
END
