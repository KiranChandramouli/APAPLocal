*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE DR.REG.RIEN9.EXTRACT.LOAD
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN9.EXTRACT
* Date           : 3-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the MM and SEC.TRADE in DOP and non DOP.
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 28-08-2014     V.P.Ashokkumar           PACS00313072- Fixed all the fields
* 09-12-2014     V.P.Ashokkumar           PACS00313072- Added OPF for files.
* 27-03-2015     V.P.Ashokkumar           PACS00313072- Updated mapping and performance change
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INCLUDE REGREP.BP I_DR.REG.RIEN9.EXTRACT.COMMON
    $INCLUDE REGREP.BP I_F.DR.REG.RIEN9.PARAM

    GOSUB INIT.PROCESS
    GOSUB READ.PARAM.VAL
    RETURN

INIT.PROCESS:
*-----------*

    FN.REDO.AA.SCHEDULE = 'F.REDO.AA.SCHEDULE'
    F.REDO.AA.SCHEDULE = ''
    CALL OPF(FN.REDO.AA.SCHEDULE,F.REDO.AA.SCHEDULE)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.LIMIT = 'F.LIMIT'
    F.LIMIT = ''
    CALL OPF(FN.LIMIT,F.LIMIT)

    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLATERAL = ''
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)

    FN.DR.REG.RIEN9.WORKFILE = 'F.DR.REG.RIEN9.WORKFILE'
    F.DR.REG.RIEN9.WORKFILE = ''
    CALL OPF(FN.DR.REG.RIEN9.WORKFILE,F.DR.REG.RIEN9.WORKFILE)

    FN.DR.REG.RIEN9.WORKFILE.FCY = 'F.DR.REG.RIEN9.WORKFILE.FCY'
    F.DR.REG.RIEN9.WORKFILE.FCY = ''
    CALL OPF(FN.DR.REG.RIEN9.WORKFILE.FCY,F.DR.REG.RIEN9.WORKFILE.FCY)

    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.REDO.AZACC.DESC = 'F.REDO.AZACC.DESC'
    F.REDO.AZACC.DESC = ''
    CALL OPF(FN.REDO.AZACC.DESC,F.REDO.AZACC.DESC)

    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'
    F.RE.STAT.REP.LINE = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)

    FN.REDO.H.CUSTOMER.PROVISIONING = 'F.REDO.H.CUSTOMER.PROVISIONING'
    F.REDO.H.CUSTOMER.PROVISIONING = ''
    CALL OPF(FN.REDO.H.CUSTOMER.PROVISIONING,F.REDO.H.CUSTOMER.PROVISIONING)

    FN.REDO.H.PROVISION.PARAMETER = 'F.REDO.H.PROVISION.PARAMETER'
    F.REDO.H.PROVISION.PARAMETER = ''
    CALL OPF(FN.REDO.H.PROVISION.PARAMETER,F.REDO.H.PROVISION.PARAMETER)

*    CALL F.READ(FN.REDO.H.PROVISION.PARAMETER,'SYSTEM',R.REDO.H.PROVISION.PARAMETER,F.REDO.H.PROVISION.PARAMETER,REDO.H.PROVISION.PARAMETER.ERR)
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.REDO.CREATE.ARRANGEMENT = 'F.REDO.CREATE.ARRANGEMENT'
    F.REDO.CREATE.ARRANGEMENT = ''
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.DR.REG.RIEN9.PARAM = 'F.DR.REG.RIEN9.PARAM'
    F.DR.REG.RIEN9.PARAM = ''
    CALL OPF(FN.DR.REG.RIEN9.PARAM,F.DR.REG.RIEN9.PARAM)

    FN.ACCOUNT = 'F.ACCOUNT';    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.CREATE.ARRANGEMENT.ID = 'F.REDO.CREATE.ARRANGEMENT.ID.ARRANGEMENT';    F.REDO.CREATE.ARRANGEMENT.ID = ''
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT.ID,F.REDO.CREATE.ARRANGEMENT.ID)

    FN.REDO.LOAN.ACCOUNT.STATUS = 'F.REDO.LOAN.ACCOUNT.STATUS';    F.REDO.LOAN.ACCOUNT.STATUS = ''
    CALL OPF(FN.REDO.LOAN.ACCOUNT.STATUS,F.REDO.LOAN.ACCOUNT.STATUS)

    FN.RELATION = 'F.RELATION';   F.RELATION = ''
    CALL OPF(FN.RELATION,F.RELATION)

    FN.REDO.CATEGORY.CIUU = 'F.REDO.CATEGORY.CIUU';    F.REDO.CATEGORY.CIUU = ''
    CALL OPF(FN.REDO.CATEGORY.CIUU,F.REDO.CATEGORY.CIUU)

    FN.AA.PRODUCT.GROUP = 'F.AA.PRODUCT.GROUP'; F.AA.PRODUCT.GROUP = ''
    CALL OPF(FN.AA.PRODUCT.GROUP,F.AA.PRODUCT.GROUP)

    FN.REDO.CONCAT.ACC.NAB = 'F.REDO.CONCAT.ACC.NAB'
    F.REDO.CONCAT.ACC.NAB = ''
    CALL OPF(FN.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB)

    FN.ACCOUNT.HIST = 'F.ACCOUNT$HIS';    F.ACCOUNT.HIST = ''
    CALL OPF(FN.ACCOUNT.HIST,F.ACCOUNT.HIST)

    FN.COUNTRY = 'F.COUNTRY'; F.COUNTRY = ''
    CALL OPF(FN.COUNTRY,F.COUNTRY)

    FN.APAP.H.INSURANCE.DETAILS = 'F.APAP.H.INSURANCE.DETAILS'
    F.APAP.H.INSURANCE.DETAILS = ''
    CALL OPF(FN.APAP.H.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS)

    FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'; F.AA.ARR.TERM.AMOUNT = ''
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'; F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    FN.APAP.H.INSURANCE.ID.CONCAT = 'F.APAP.H.INSURANCE.ID.CONCAT'; F.APAP.H.INSURANCE.ID.CONCAT = ''
    CALL OPF(FN.APAP.H.INSURANCE.ID.CONCAT,F.APAP.H.INSURANCE.ID.CONCAT)
    RETURN

READ.PARAM.VAL:
****************
    REDO.H.PROVISION.PARAMETER.ERR = ''; R.REDO.H.PROVISION.PARAMETER = ''
    CALL CACHE.READ(FN.REDO.H.PROVISION.PARAMETER,'SYSTEM',R.REDO.H.PROVISION.PARAMETER,REDO.H.PROVISION.PARAMETER.ERR)

    DR.REG.RIEN9.PARAM.ERR = ''; R.DR.REG.RIEN9.PARAM = ''
    CALL CACHE.READ(FN.DR.REG.RIEN9.PARAM,'SYSTEM',R.DR.REG.RIEN9.PARAM,DR.REG.RIEN9.PARAM.ERR)
    IF R.DR.REG.RIEN9.PARAM THEN
        Y.FIELD.NME.ARR = R.DR.REG.RIEN9.PARAM<RIEN9.PARAM.T24.FLD.NAME>
        Y.FIELD.VAL.ARR = R.DR.REG.RIEN9.PARAM<RIEN9.PARAM.REG.FAC>
        Y.DISP.TEXT.ARR = R.DR.REG.RIEN9.PARAM<RIEN9.PARAM.T24.CR.FAC>
    END
    Y.TODAY = R.DATES(EB.DAT.TODAY)
    Y.LAST.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)

    TXNTC.POS = ''; TXNCR.POS = ''; TXNMA.POS = ''
    LOCATE "TIPO.CREDITO" IN Y.FIELD.NME.ARR<1,1> SETTING TXNTC.POS THEN
        Y.TXNTC.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNTC.POS>
        Y.TXNTC.DIS.ARR = Y.DISP.TEXT.ARR<1,TXNTC.POS>
        Y.TXNTC.VAL.ARR = CHANGE(Y.TXNTC.VAL.ARR,SM,VM)
        Y.TXNTC.DIS.ARR = CHANGE(Y.TXNTC.DIS.ARR,SM,VM)
    END

    LOCATE "CODIGO.REVOLUTIVO" IN Y.FIELD.NME.ARR<1,1> SETTING TXNCR.POS THEN
        Y.TXNCR.DIS.ARR = Y.FIELD.VAL.ARR<1,TXNCR.POS>
        Y.TXNCR.DIS.ARR = CHANGE(Y.TXNCR.DIS.ARR,SM,VM)
    END

    LOCATE "MONEDA" IN Y.FIELD.NME.ARR<1,1> SETTING TXNMA.POS THEN
        Y.TXNMA.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNMA.POS>
        Y.TXNMA.DIS.ARR = Y.DISP.TEXT.ARR<1,TXNMA.POS>
        Y.TXNMA.VAL.ARR = CHANGE(Y.TXNMA.VAL.ARR,SM,VM)
        Y.TXNMA.DIS.ARR = CHANGE(Y.TXNMA.DIS.ARR,SM,VM)
    END

    LOCATE "FRECUENCIA.DEL.REPRE" IN Y.FIELD.NME.ARR<1,1> SETTING TXNFDR.POS THEN
        Y.TXNFDR.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNFDR.POS>
        Y.TXNFDR.DIS.ARR = Y.DISP.TEXT.ARR<1,TXNFDR.POS>
        Y.TXNFDR.VAL.ARR = CHANGE(Y.TXNFDR.VAL.ARR,SM,VM)
        Y.TXNFDR.DIS.ARR = CHANGE(Y.TXNFDR.DIS.ARR,SM,VM)
    END

    Y.POS = ''; Y.APP = ''; Y.FLD = ''
    Y.APP = 'CUSTOMER':FM:'AA.PRD.DES.OVERDUE':FM:'AA.PRD.DES.TERM.AMOUNT':FM:'AA.PRD.DES.ACCOUNT':FM:'ACCOUNT':FM:'AA.PRD.DES.INTEREST':FM:'COUNTRY'
    Y.FLD = 'L.CU.RNC':VM:'L.AA.CAL.ISSUER':VM:'L.CU.TIPO.CL':VM:'L.CU.CIDENT':VM:'L.CU.DEBTOR':VM:'L.LOCALIDAD':VM:'L.APAP.INDUSTRY':VM:'L.CU.FOREIGN':FM:'L.LOAN.STATUS.1':VM:'L.STATUS.CHG.DT':FM:'L.AA.COL':VM:'L.AA.AV.COL.BAL':FM:'ORIGEN.RECURSOS':VM:'L.AA.AGNCY.CODE':VM:'L.AA.CATEG':VM:'L.CR.FACILITY':FM:'L.OD.STATUS':FM:'L.AA.RT.RV.FREQ':FM:'L.CO.RISK.CLASS'
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD,Y.POS)
    L.CU.RNC.POS = Y.POS<1,1>
    L.AA.CAL.ISSUER.POS = Y.POS<1,2>
    L.CU.TIPO.CL.POS = Y.POS<1,3>
    L.CU.CIDENT.POS = Y.POS<1,4>
    L.AA.MMD.PYME.POS = Y.POS<1,5>
    L.LOCALIDAD.POS = Y.POS<1,6>
    Y.APAP.INDUS.POS = Y.POS<1,7>
    L.CU.FOREIGN.POS = Y.POS<1,8>

    OD.L.LOAN.STATUS1.POS = Y.POS<2,1>
    OD.L.STATUS.CHG.DT.POS = Y.POS<2,2>

    L.AA.COL.POS = Y.POS<3,1>
    L.AA.AV.COL.BAL.POS = Y.POS<3,2>

    ORIGEN.RECURSOS.POS = Y.POS<4,1>
    L.AA.AGNCY.CODE.POS = Y.POS<4,2>
    L.AA.CATEG.POS1 = Y.POS<4,3>
    L.CR.FACILITY.POS = Y.POS<4,4>

    L.OD.STATUS.POS = Y.POS<5,1>
    L.AA.RT.RV.FREQ.POS = Y.POS<6,1>
    L.CO.RISK.CLASS.POS = Y.POS<7,1>
    RETURN
END
