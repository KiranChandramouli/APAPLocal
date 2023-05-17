*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.COMM.LOAN.SECTOR.EXT.LOAD
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.COMMERCIAL.LOAN.SECTOR.EXTRACT
* Date           : 16-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* * This multi-thread job is meant for to extact the commercial loans happened on daily basis
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 03-Oct-2014  Ashokkumar           PACS00305229:- Displaying Credit lines details
* 12-May-2015  Ashokkumar.V.P       PACS00305229:- Added new fields mapping change
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM

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

    FN.DR.REG.COM.LOAN.SECTOR.WORKFILE = 'F.DR.REG.COM.LOAN.SECTOR.WORKFILE'
    F.DR.REG.COM.LOAN.SECTOR.WORKFILE = ''
    CALL OPF(FN.DR.REG.COM.LOAN.SECTOR.WORKFILE,F.DR.REG.COM.LOAN.SECTOR.WORKFILE)

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
RETURN

INIT.PARAM:
**********
    Y.REPORT.PARAM.ID = "REDO.SEC.COMMERCIAL"
    R.REDO.H.REPORTS.PARAM = ''; PARAM.ERR = ''; Y.TXNPGRP.VAL.ARR = ''; Y.TXNLINPD.VAL.ARR = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.REPORT.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
    END

    LOCATE "PRODUCT.GROUP" IN Y.FIELD.NME.ARR<1,1> SETTING PGRP.POS THEN
        Y.TXNPGRP.VAL.ARR = Y.FIELD.VAL.ARR<1,PGRP.POS>
    END
    Y.TXNPGRP.VAL.ARR = CHANGE(Y.TXNPGRP.VAL.ARR,@SM,' ')

    LOCATE "LINEAS.DE.CREDITO" IN Y.FIELD.NME.ARR<1,1> SETTING LINPD.POS THEN
        Y.TXNLINPD.VAL.ARR = Y.FIELD.VAL.ARR<1,LINPD.POS>
    END
    Y.TXNLINPD.VAL.ARR = CHANGE(Y.TXNLINPD.VAL.ARR,@SM,@VM)

    LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    YTODAY = R.DATES(EB.DAT.TODAY)

    LOC.APP = 'CUSTOMER':@FM:'AA.PRD.DES.OVERDUE':@FM:'AA.PRD.DES.ACCOUNT':@FM:'SECTOR':@FM:'ACCOUNT'
    LOC.FLD = 'L.CU.TIPO.CL':@VM:'L.CU.CIDENT':@VM:'L.CU.RNC':@FM:'L.LOAN.STATUS.1':@FM:'ORIGEN.RECURSOS':@VM:'L.AA.LOAN.DSN':@FM:'L.REP.COM.SEC':@FM:'L.OD.STATUS'
    LOC.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.APP,LOC.FLD,LOC.POS)
    TIPO.CL.POS = LOC.POS<1,1>
    CIDENT.POS = LOC.POS<1,2>
    RNC.POS = LOC.POS<1,3>
    L.LOAN.STATUS.1.POS = LOC.POS<2,1>
    ORIGEN.RECURSOS.POS = LOC.POS<3,1>
    L.AA.LOAN.DSN.POS = LOC.POS<3,2>
    L.REP.COM.SEC.POS = LOC.POS<4,1>    ;* added by M.Medina
    L.OD.STATUS.POS = LOC.POS<5,1>
*
    MAT RCL$COMM.LOAN = ""    ;* Initialise the common variable for fresh use
*
RETURN
*-----------------------------------------------------------------------------
END
