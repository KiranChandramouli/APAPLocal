$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.DIVISAS.EXTRACT.LOAD
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Program Name   : DR.REG.DIVISAS.EXTRACT
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the TELLER and FOREX
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date       Author              Modification Description
* 05-Dec-2017  Ashokkumar.V.P      CN007023 - Initial Version.
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INCLUDE to INSERT ,VM,SM,FM to @VM,@SM,@FM
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_DR.REG.DIVISAS.EXTRACT.COMMON ;*R22 Auto code conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_F.DR.REG.FD01.PARAM ;*R22 Auto code conversion

    GOSUB INIT.PROCESS
RETURN

INIT.PROCESS:
*-----------*
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'; F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER.HST = 'F.FUNDS.TRANSFER$HIS' ; F.FUNDS.TRANSFER.HST = ''
    CALL OPF(FN.FUNDS.TRANSFER.HST,F.FUNDS.TRANSFER.HST)

    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.TELLER = 'F.TELLER' ;  F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.TELLER.HST = 'F.TELLER$HIS' ; F.TELLER.HST = ''
    CALL OPF(FN.TELLER.HST,F.TELLER.HST)

    FN.DR.REG.DIVIAS.WORKFILE = 'F.DR.REG.DIVIAS.WORKFILE' ; F.DR.REG.DIVIAS.WORKFILE = ''
    CALL OPF(FN.DR.REG.DIVIAS.WORKFILE,F.DR.REG.DIVIAS.WORKFILE)

    FN.CUSTOMER.L.CU.PASS.NAT = 'F.CUSTOMER.L.CU.PASS.NAT'; F.CUSTOMER.L.CU.PASS.NAT = ''
    CALL OPF(FN.CUSTOMER.L.CU.PASS.NAT,F.CUSTOMER.L.CU.PASS.NAT)

    FN.CUSTOMER.L.CU.RNC = 'F.CUSTOMER.L.CU.RNC'; F.CUSTOMER.L.CU.RNC = ''
    CALL OPF(FN.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC)

    FN.CUSTOMER.L.CU.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'; F.CUSTOMER.L.CU.CIDENT = ''
    CALL OPF(FN.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT)

    FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'; F.FT.TXN.TYPE.CONDITION = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

    FN.DR.REG.FD01.CONCAT = 'F.DR.REG.FD01.CONCAT'; F.DR.REG.FD01.CONCAT = ''
    CALL OPF(FN.DR.REG.FD01.CONCAT,F.DR.REG.FD01.CONCAT)

    FN.REDO.APAP.INSTIT.FINANC.PARAM = 'F.REDO.APAP.INSTIT.FINANC.PARAM'; F.REDO.APAP.INSTIT.FINANC.PARAM = ''
    CALL OPF(FN.REDO.APAP.INSTIT.FINANC.PARAM,F.REDO.APAP.INSTIT.FINANC.PARAM)

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'; F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    REDO.H.REPORTS.PARAM.ID = 'REDO.TASAS.PASIV'
    ERR.REDO.H.REPORTS.PARAM = ''; R.REDO.H.REPORTS.PARAM = ''
    CALL F.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM,ERR.REDO.H.REPORTS.PARAM)
    Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
    Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>

    LOCATE "GRUPO.CONTRAPARTE" IN Y.FIELD.NME.ARR<1,1> SETTING SECT.POS THEN
        Y.SECT.VAL.ARR = Y.FIELD.VAL.ARR<1,SECT.POS>
        Y.SECT.DIS.ARR = Y.DISP.TEXT.ARR<1,SECT.POS>
    END
    Y.SECT.VAL.ARR = CHANGE(Y.SECT.VAL.ARR,@SM,@VM) ;*R22 Auto code conversion
    Y.SECT.DIS.ARR = CHANGE(Y.SECT.DIS.ARR,@SM,@VM) ;*R22 Auto code conversion

    Y.TODAY = R.DATES(EB.DAT.TODAY)
    Y.LAST = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.LAST.DATE.TIME = Y.LAST
    Y2.LWORK.DAY = Y.LAST
    CALL CDT('',Y2.LWORK.DAY,'-1W')
*
    L.APP = 'CUSTOMER':@FM:'TELLER':@FM:'FUNDS.TRANSFER' ;*R22 Auto code conversion
    L.FLD = 'L.CU.CIDENT':@VM:'L.CU.TIPO.CL':@VM:'L.CU.RNC':@VM:'L.APAP.INDUSTRY':@VM:'L.CU.PASS.NAT':@VM:'L.LOCALIDAD':@FM:'L.TT.PAY.METHOD':@VM:'L.TT.FX.BUY.SRC':@VM:'L.TT.FX.SEL.DST':@VM:'L.TT.RCEP.MTHD':@VM:'L.TT.FXSN.NUM':@VM:'L.TT.CLNT.TYPE':@VM:'L.TT.LEGAL.ID':@VM:'L.TT.DOC.NUM':@VM:'L.TT.DOC.DESC':@VM:'L.TT.CLIENT.COD':@VM:'L.TT.CLIENT.NME':@FM:'L.FT.FXSN.NUM':@VM:'L.FT.FX.BUY.SRC':@VM:'L.FT.FX.SEL.DST':@VM:'L.FT.RCEP.MTHD':@VM:'L.FT.PAY.METHOD':@VM:'L.FT.CLNT.TYPE':@VM:'L.FT.LEGAL.ID':@VM:'L.FT.CHANNELS' ;*R22 Auto code conversion
    L.POS = ''
    CALL MULTI.GET.LOC.REF(L.APP,L.FLD,L.POS)
    L.CU.CIDENT.POS = L.POS<1,1>
    L.CU.TIPO.CL.POS = L.POS<1,2>
    L.CU.RNC.POS = L.POS<1,3>
    L.APAP.INDUSTRY.POS = L.POS<1,4>
    L.CU.FOREIGN.POS = L.POS<1,5>
    L.LOCALIDAD.POS = L.POS<1,6>
    L.TT.PAY.METHOD.POS = L.POS<2,1>
    L.TT.FX.BUY.SRC.POS = L.POS<2,2>
    L.TT.FX.SEL.DST.POS = L.POS<2,3>
    L.TT.RCEP.MTHD.POS = L.POS<2,4>
    L.TT.FXSN.NUM.POS = L.POS<2,5>
    L.TT.CLNT.TYPE.POS = L.POS<2,6>
    L.TT.LEGAL.ID.POS = L.POS<2,7>
    L.TT.DOC.NUM.POS = L.POS<2,8>
    L.TT.DOC.DESC.POS = L.POS<2,9>
    L.TT.CLIENT.COD.POS = L.POS<2,10>
    L.TT.CLIENT.NME.POS = L.POS<2,11>
    L.FT.FXSN.NUM.POS = L.POS<3,1>
    L.FT.FX.BUY.SRC.POS = L.POS<3,2>
    L.FT.FX.SEL.DST.POS = L.POS<3,3>
    L.FT.RCEP.MTHD.POS = L.POS<3,4>
    L.FT.PAY.METHOD.POS = L.POS<3,5>
    L.FT.CLNT.TYPE.POS = L.POS<3,6>
    L.FT.LEGAL.ID.POS = L.POS<3,7>
    L.FT.CHANNELS.POS = L.POS<3,8>
RETURN
END
