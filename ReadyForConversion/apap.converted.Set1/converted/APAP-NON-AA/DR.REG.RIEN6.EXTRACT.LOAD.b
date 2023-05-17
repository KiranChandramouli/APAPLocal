SUBROUTINE DR.REG.RIEN6.EXTRACT.LOAD
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN6.EXTRACT
* Date           : 3-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the AZ.ACCOUNT
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 11/07/2014      Ashokkumar       PACS00312508 - Updated selection criteria and fixed the field bug
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_DR.REG.RIEN6.EXTRACT.COMMON
    $INSERT I_F.DR.REG.RIEN6.PARAM

    GOSUB INIT.PROCESS
RETURN

INIT.PROCESS:
*-----------*

    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT' ; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.GROUP.DATE = 'F.GROUP.DATE' ;F.GROUP.DATE = ''
    CALL OPF(FN.GROUP.DATE,F.GROUP.DATE)

    FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'; F.GROUP.CREDIT.INT = ''
    CALL OPF(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT' ; F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.DR.REG.RIEN6.WORKFILE = 'F.DR.REG.RIEN6.WORKFILE' ; F.DR.REG.RIEN6.WORKFILE = ''
    CALL OPF(FN.DR.REG.RIEN6.WORKFILE,F.DR.REG.RIEN6.WORKFILE)

    FN.DR.REG.RIEN6.WORKFILE.FCY = 'F.DR.REG.RIEN6.WORKFILE.FCY' ; F.DR.REG.RIEN6.WORKFILE.FCY = ''
    CALL OPF(FN.DR.REG.RIEN6.WORKFILE.FCY,F.DR.REG.RIEN6.WORKFILE.FCY)

    FN.REDO.AZACC.DESC = 'F.REDO.AZACC.DESC' ; F.REDO.AZACC.DESC = ''
    CALL OPF(FN.REDO.AZACC.DESC,F.REDO.AZACC.DESC)

    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'  ; F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'; F.RE.STAT.REP.LINE = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)

    FN.DR.REG.RIEN6.PARAM = 'F.DR.REG.RIEN6.PARAM' ; F.DR.REG.RIEN6.PARAM = ''
    CALL OPF(FN.DR.REG.RIEN6.PARAM,F.DR.REG.RIEN6.PARAM)

    FN.ACCOUNT.HST = 'F.ACCOUNT$HIS'; F.ACCOUNT.HST = ''
    CALL OPF(FN.ACCOUNT.HST,F.ACCOUNT.HST)

    FN.AZ.ACCOUNT.HST = 'F.AZ.ACCOUNT$HIS' ; F.AZ.ACCOUNT.HST = ''
    CALL OPF(FN.AZ.ACCOUNT.HST,F.AZ.ACCOUNT.HST)

    FN.ACCOUNT.CLOSURE = 'F.ACCOUNT.CLOSURE'; F.ACCOUNT.CLOSURE = ''
    CALL OPF(FN.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE)

    R.DR.REG.RIEN6.PARAM = ''; ERR.DR.REG.RIEN6.PARAM = ''
    CALL CACHE.READ(FN.DR.REG.RIEN6.PARAM,'SYSTEM',R.DR.REG.RIEN6.PARAM,DR.REG.RIEN6.PARAM.ERR)
*    Y.TODAY = R.DATES(EB.DAT.TODAY)
    Y.TODAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.DTE.SEL = Y.TODAY[3,6]

    Y.APP = ''; Y.FLD = ''; Y.POS = ''
    Y.APP = 'CUSTOMER':@FM:'AZ.ACCOUNT':@FM:'ACCOUNT'
    Y.FLD = 'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.TIPO.CL':@VM:'L.TIP.CLI':@VM:'L.APAP.INDUSTRY':@VM:'L.CU.FOREIGN':@FM:'L.AZ.DEP.NAME':@VM:'L.TYPE.INT.PAY':@VM:'L.AC.STATUS1':@VM:'L.AC.STATUS2':@FM:'L.AC.REINVESTED':@VM:'L.AC.AV.BAL'
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD,Y.POS)

    L.CU.CIDENT.POS = Y.POS<1,1>
    L.CU.RNC.POS = Y.POS<1,2>
    L.CU.TIPO.CL.POS = Y.POS<1,3>
    L.TIP.CLI.POS = Y.POS<1,4>
    L.APAP.INDUSTRY.POS = Y.POS<1,5>
    L.CU.FOREIGN.POS = Y.POS<1,6>
    L.INV.FACILITY.POS = Y.POS<2,1>
    L.TYPE.INT.PAY.POS = Y.POS<2,2>
    L.AC.STATUS1.POS = Y.POS<2,3>
    L.AC.STATUS2.POS = Y.POS<2,4>
    L.AC.REINVESTED.POS = Y.POS<3,1>
    L.AC.AV.BAL.POS = Y.POS<3,2>
RETURN

END
