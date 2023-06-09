*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.B.TASAS.ACTIV.PASIV.DUP.LOAD
*
* Client Name   : APAP
* Develop By    : Ashokkumar
* Description   : The routine to generate the Activasa and Pasivas report AR010.
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.COLLATERAL
    $INSERT I_F.DATES
    $INCLUDE REGREP.BP I_F.DR.REG.PASIVAS.PARAM
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT I_L.APAP.B.TASAS.ACTIV.PASIV.DUP.COMMON



    GOSUB INIT
    GOSUB GET.LOC.REF
    RETURN

INIT:
*****
    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'; F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'; F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    FN.BASIC.INTEREST = 'F.BASIC.INTEREST' ; F.BASIC.INTEREST = ''
    CALL OPF(FN.BASIC.INTEREST,F.BASIC.INTEREST)
    FN.GROUP.DATE = 'F.GROUP.DATE' ; F.GROUP.DATE = ''
    CALL OPF(FN.GROUP.DATE,F.GROUP.DATE)
    FN.PERIODIC.INTEREST = 'F.PERIODIC.INTEREST'  ; F.PERIODIC.INTEREST = ''
    CALL OPF(FN.PERIODIC.INTEREST,F.PERIODIC.INTEREST)
    FN.AZ.PRODUCT.PARAMETER = 'F.AZ.PRODUCT.PARAMETER' ; F.AZ.PRODUCT.PARAMETER = ''
    CALL OPF(FN.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER)
    FN.DR.REG.PASIVAS.PARAM = 'F.DR.REG.PASIVAS.PARAM' ; F.DR.REG.PASIVAS.PARAM = ''
    CALL OPF(FN.DR.REG.PASIVAS.PARAM,F.DR.REG.PASIVAS.PARAM)
    FN.COLLATERAL = 'F.COLLATERAL'; F.COLLATERAL = ''
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
    FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'; F.AA.ARR.TERM.AMOUNT = ''
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)
    FN.DR.REG.PASIVAS.ACTIV.DUP = 'F.DR.REG.PASIVAS.ACTIV.DUP'; F.DR.REG.PASIVAS.ACTIV.DUP = ''
    CALL OPF(FN.DR.REG.PASIVAS.ACTIV.DUP,F.DR.REG.PASIVAS.ACTIV.DUP)
    FN.BASIC.INTEREST = 'F.BASIC.INTEREST'; F.BASIC.INTEREST =''
    CALL OPF(FN.BASIC.INTEREST,F.BASIC.INTEREST)
    FN.PERIODIC.INTEREST = 'F.PERIODIC.INTEREST'; F.PERIODIC.INTEREST =''
    CALL OPF(FN.PERIODIC.INTEREST,F.PERIODIC.INTEREST)
    FN.GROUP.DATE = 'F.GROUP.DATE'; F.GROUP.DATE = ''
    CALL OPF(FN.GROUP.DATE,F.GROUP.DATE)
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'; F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    FN.REDO.APAP.INSTIT.FINANC.PARAM = 'F.REDO.APAP.INSTIT.FINANC.PARAM'; F.REDO.APAP.INSTIT.FINANC.PARAM = ''
    CALL OPF(FN.REDO.APAP.INSTIT.FINANC.PARAM,F.REDO.APAP.INSTIT.FINANC.PARAM)
    FN.COMPANY = 'F.COMPANY'; F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

    LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    CALL CACHE.READ(FN.DR.REG.PASIVAS.PARAM,'SYSTEM',R.DR.REG.PASIVAS.PARAM,DR.REG.PASIVAS.PARAM.ERR)
    CAT.LIST3 = R.DR.REG.PASIVAS.PARAM<DR.PASIVAS.PARAM.GRP16.CATEGORY>
    CHANGE VM TO FM IN CAT.LIST3

    REDO.H.REPORTS.PARAM.ID = 'REDO.TASAS.PASIV'
    ERR.REDO.H.REPORTS.PARAM = ''; R.REDO.H.REPORTS.PARAM = ''
    CALL F.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM,ERR.REDO.H.REPORTS.PARAM)
    Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
    Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>

    LOCATE "CODIGO.PROVINCIA" IN Y.FIELD.NME.ARR<1,1> SETTING COMP.POS THEN
        Y.COMP.VAL.ARR = Y.FIELD.VAL.ARR<1,COMP.POS>
        Y.COMP.DIS.ARR = Y.DISP.TEXT.ARR<1,COMP.POS>
    END
    Y.COMP.VAL.ARR = CHANGE(Y.COMP.VAL.ARR,SM,VM)
    Y.COMP.DIS.ARR = CHANGE(Y.COMP.DIS.ARR,SM,VM)

    LOCATE "GRUPO.CONTRAPARTE" IN Y.FIELD.NME.ARR<1,1> SETTING SECT.POS THEN
        Y.SECT.VAL.ARR = Y.FIELD.VAL.ARR<1,SECT.POS>
        Y.SECT.DIS.ARR = Y.DISP.TEXT.ARR<1,SECT.POS>
    END
    Y.SECT.VAL.ARR = CHANGE(Y.SECT.VAL.ARR,SM,VM)
    Y.SECT.DIS.ARR = CHANGE(Y.SECT.DIS.ARR,SM,VM)

    LOCATE "TIPO.DE.EDIFICATION" IN Y.FIELD.NME.ARR<1,1> SETTING TIPO.POS THEN
        Y.TIPO.VAL.ARR = Y.FIELD.VAL.ARR<1,TIPO.POS>
        Y.TIPO.DIS.ARR = Y.DISP.TEXT.ARR<1,TIPO.POS>
    END
    Y.TIPO.VAL.ARR = CHANGE(Y.TIPO.VAL.ARR,SM,VM)
    Y.TIPO.DIS.ARR = CHANGE(Y.TIPO.DIS.ARR,SM,VM)

    RETURN

GET.LOC.REF:
************
    YTA.FILENAME = 'AZ.PRODUCT.PARAMETER':FM:'CUSTOMER':FM:'AZ.ACCOUNT':FM:'AA.PRD.DES.INTEREST':FM:'AA.PRD.DES.TERM.AMOUNT':FM:'COLLATERAL':FM:'AA.PRD.DES.OVERDUE':FM:'AA.PRD.DES.ACCOUNT':FM:'AA.PRD.DES.CUSTOMER'
    YTA.FIELDNAME = 'L.AP.ABB.DEPO':FM:'L.CU.TIPO.CL':VM:'L.CU.CIDENT':VM:'L.CU.RNC':VM:'L.CU.PASS.NAT':VM:'L.CU.NOUNICO':VM:'L.CU.ACTANAC':VM:'L.LOCALIDAD':VM:'L.APAP.INDUSTRY':VM:'L.TIP.CLI':FM:'L.AZ.REIVSD.INT':VM:'L.AZ.DEP.NAME':FM:'L.AA.RT.RV.FREQ':FM:'L.AA.COL'
    YTA.FIELDNAME := FM:'L.COL.TOT.VALUA':VM:'L.COL.BLD.AREA':VM:'L.COL.DEP.VALUE':FM:'L.LOAN.STATUS.1':FM:'L.AA.LOAN.DSN':FM:'L.AA.CAMP.TY'
    YTA.FIELDPOSN = ''
    CALL MULTI.GET.LOC.REF(YTA.FILENAME,YTA.FIELDNAME,YTA.FIELDPOSN)
    L.AP.ABB.DEPO.POSN = YTA.FIELDPOSN<1,1>
    L.CU.TIPO.CL.POSN = YTA.FIELDPOSN<2,1>
    L.CU.CIDENT.POSN = YTA.FIELDPOSN<2,2>
    L.CU.RNC.POSN = YTA.FIELDPOSN<2,3>
    L.CU.PASS.NAT.POSN = YTA.FIELDPOSN<2,4>
    L.CU.NOUNICO.POSN = YTA.FIELDPOSN<2,5>
    L.CU.ACTANAC.POSN = YTA.FIELDPOSN<2,6>
    L.LOCALIDAD.POSN = YTA.FIELDPOSN<2,7>
    L.APAP.INDUSTRY.POSN = YTA.FIELDPOSN<2,8>
    L.TIP.CLI.POSN = YTA.FIELDPOSN<2,9>
    L.AZ.REIVSD.INT.POSN = YTA.FIELDPOSN<3,1>
    L.AZ.DEP.NAME.POSN = YTA.FIELDPOSN<3,2>
    L.AA.RT.RV.FREQ.POSN = YTA.FIELDPOSN<4,1>
    L.AA.COL.POSN = YTA.FIELDPOSN<5,1>
    L.COL.TOT.VALUA.POSN = YTA.FIELDPOSN<6,1>
    L.COL.BLD.AREA.POSN = YTA.FIELDPOSN<6,2>
    L.COL.DEP.VALUE.POSN = YTA.FIELDPOSN<6,3>
    OD.L.LOAN.STATUS1.POS = YTA.FIELDPOSN<7,1>
    L.AA.LOAN.DSN.POS = YTA.FIELDPOSN<8,1>
    L.AA.CAMP.TY.POS = YTA.FIELDPOSN<9,1>
    RETURN

END
