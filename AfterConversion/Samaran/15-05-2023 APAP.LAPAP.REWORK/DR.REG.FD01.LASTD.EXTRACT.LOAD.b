* @ValidationCode : MjoxMTAyNTc5OTU4OkNwMTI1MjoxNjgyMzIyODk0MTU5OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 13:24:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.FD01.LASTD.EXTRACT.LOAD
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Program Name   : DR.REG.FD01.LASTD.EXTRACT
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the TELLER and FOREX
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date       Author              Modification Description
*
* 14-May-2015  Ashokkumar.V.P      PACS00309078 - Initial Version
* 24-Jun-2015   Ashokkumar.V.P     PACS00466000 - Mapping changes - Fetch customer details to avoid blank.
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   $INCLUDE to $INSERT , LAPAP.BP &REGREP.BP is removed
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------


*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_DR.REG.FD01.LASTD.EXTRACT.COMMON
    $INSERT I_F.DR.REG.FD01.PARAM

    GOSUB INIT.PROCESS
RETURN

INIT.PROCESS:
*-----------*
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'; F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER.HST = 'F.FUNDS.TRANSFER$HIS' ; F.FUNDS.TRANSFER.HST = ''
    CALL OPF(FN.FUNDS.TRANSFER.HST,F.FUNDS.TRANSFER.HST)

    FN.EB.LOOKUP = 'F.EB.LOOKUP'; F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.TELLER = 'F.TELLER' ;  F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FOREX = 'F.FOREX'; F.FOREX = ''
    CALL OPF(FN.FOREX,F.FOREX)

    FN.TELLER.HST = 'F.TELLER$HIS' ; F.TELLER.HST = ''
    CALL OPF(FN.TELLER.HST,F.TELLER.HST)

    FN.FOREX.HST = 'F.FOREX$HIS' ; F.FOREX.HST = ''
    CALL OPF(FN.FOREX.HST,F.FOREX.HST)

    FN.DR.REG.FD01.WORKFILE = 'F.DR.REG.FD01.WORKFILE' ; F.DR.REG.FD01.WORKFILE = ''
    CALL OPF(FN.DR.REG.FD01.WORKFILE,F.DR.REG.FD01.WORKFILE)

    FN.POS.MVMT.HST = 'F.POS.MVMT.HIST'; F.POS.MVMT.HST = ''
    CALL OPF(FN.POS.MVMT.HST,F.POS.MVMT.HST)

    FN.DR.REG.FD01.PARAM = 'F.DR.REG.FD01.PARAM' ; F.DR.REG.FD01.PARAM = ''
    CALL OPF(FN.DR.REG.FD01.PARAM,F.DR.REG.FD01.PARAM)

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

    R.DR.REG.FD01.PARAM = ''; DR.REG.FD01.PARAM.ERR = ''; TXNFX.POS = ''
    TXNTT.POS = ''; TXNFT.POS = ''
    CALL CACHE.READ(FN.DR.REG.FD01.PARAM,'SYSTEM',R.DR.REG.FD01.PARAM,DR.REG.FD01.PARAM.ERR)
    IF R.DR.REG.FD01.PARAM THEN
        REP.START.DATE = R.DR.REG.FD01.PARAM<DR.FD01.PARAM.START.TIME>
        REP.END.DATE = R.DR.REG.FD01.PARAM<DR.FD01.PARAM.END.TIME>
        TT.CODES = R.DR.REG.FD01.PARAM<DR.FD01.PARAM.TT.TXN.TYPE>
        CHANGE @VM TO @FM IN TT.CODES
        FX.CODES = R.DR.REG.FD01.PARAM<DR.FD01.PARAM.FX.DEAL.TYPE>
        CHANGE @VM TO @FM IN FX.CODES
        Y.FIELD.NME.ARR = R.DR.REG.FD01.PARAM<DR.FD01.PARAM.FLD.NAME>
        Y.FIELD.VAL.ARR = R.DR.REG.FD01.PARAM<DR.FD01.PARAM.FLD.VALUE>
        Y.DISP.TEXT.ARR = R.DR.REG.FD01.PARAM<DR.FD01.PARAM.FLD.DISP.VALUE>
    END

    LOCATE "FOREX.VAL" IN Y.FIELD.NME.ARR<1,1> SETTING TXNFX.POS THEN
        Y.FXTXN.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNFX.POS>
        Y.FXTXN.DIS.ARR = Y.DISP.TEXT.ARR<1,TXNFX.POS>
    END
    Y.FXTXN.VAL.ARR = CHANGE(Y.FXTXN.VAL.ARR,@SM,@VM)
    Y.FXTXN.DIS.ARR = CHANGE(Y.FXTXN.DIS.ARR,@SM,@VM)

    LOCATE "TELLER.VAL" IN Y.FIELD.NME.ARR<1,1> SETTING TXNTT.POS THEN
        Y.TTTXN.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNTT.POS>
        Y.TTTXN.DIS.ARR = Y.DISP.TEXT.ARR<1,TXNTT.POS>
    END
    Y.TTTXN.VAL.ARR = CHANGE(Y.TTTXN.VAL.ARR,@SM,@VM)
    Y.TTTXN.DIS.ARR = CHANGE(Y.TTTXN.DIS.ARR,@SM,@VM)

    LOCATE "FT.VAL" IN Y.FIELD.NME.ARR<1,1> SETTING TXNFT.POS THEN
        Y.FTTXN.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNFT.POS>
        Y.FTTXN.DIS.ARR = Y.DISP.TEXT.ARR<1,TXNFT.POS>
    END
    FT.CODES = Y.FTTXN.VAL.ARR
    CHANGE @SM TO @FM IN FT.CODES
    Y.FTTXN.VAL.ARR = CHANGE(Y.FTTXN.VAL.ARR,@SM,@VM)
    Y.FTTXN.DIS.ARR = CHANGE(Y.FTTXN.DIS.ARR,@SM,@VM)

    LOCATE "COMP.VAL" IN Y.FIELD.NME.ARR<1,1> SETTING TXNCMP.POS THEN
        Y.CMPTXN.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNCMP.POS>
        Y.CMPTXN.DIS.ARR = Y.DISP.TEXT.ARR<1,TXNCMP.POS>
    END
    Y.CMPTXN.VAL.ARR = CHANGE(Y.CMPTXN.VAL.ARR,@SM,@VM)
    Y.CMPTXN.DIS.ARR = CHANGE(Y.CMPTXN.DIS.ARR,@SM,@VM)

    Y.TODAY = R.DATES(EB.DAT.TODAY)
    Y.LAST = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.LAST.DATE.TIME = Y.LAST
    Y2.LWORK.DAY = Y.LAST
    CALL CDT('',Y2.LWORK.DAY,'-1W')
*
    L.APP = 'CUSTOMER':@FM:'TELLER':@FM:'FOREX':@FM:'FUNDS.TRANSFER':@FM:'FT.TXN.TYPE.CONDITION'
    L.FLD = 'L.CU.CIDENT':@VM:'L.CU.TIPO.CL':@VM:'L.CU.RNC':@VM:'L.APAP.INDUSTRY':@VM:'L.CU.PASS.NAT':@VM:'L.LOCALIDAD':@FM:'L.TT.PAY.METHOD':@VM:'L.TT.FX.BUY.SRC':@VM:'L.TT.FX.SEL.DST':@VM:'L.TT.RCEP.MTHD':@VM:'L.TT.FXSN.NUM':@VM:'L.TT.CLNT.TYPE':@VM:'L.TT.LEGAL.ID':@VM:'L.TT.DOC.NUM':@VM:'L.TT.DOC.DESC':@VM:'L.TT.CLIENT.COD':@VM:'L.TT.CLIENT.NME':@FM:'L.FX.FX.BUY.SRC':@VM:'L.FX.FX.SEL.DST':@VM:'L.FX.RCEP.MTHD':@VM:'L.FX.PAY.METHOD':@VM:'L.VERSION':@VM:'L.FX.FXSN.NUM':@VM:'L.FX.CLNT.TYPE':@VM:'L.FX.LEGAL.ID':@FM:'L.FT.FXSN.NUM':@VM:'L.FT.FX.BUY.SRC':@VM:'L.FT.FX.SEL.DST':@VM:'L.FT.RCEP.MTHD':@VM:'L.FT.PAY.METHOD':@VM:'L.FT.CLNT.TYPE':@VM:'L.FT.LEGAL.ID':@VM:'L.FT.CHANNELS':@FM:'L.FTTC.CHANNELS'
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
    L.FX.FX.BUY.SRC.POS = L.POS<3,1>
    L.FX.FX.SEL.DST.POS = L.POS<3,2>
    L.FX.RCEP.MTHD.POS = L.POS<3,3>
    L.FX.PAY.METHOD.POS = L.POS<3,4>
    L.FX.VERSION.POS = L.POS<3,5>
    L.FX.FXSN.NUM.POS = L.POS<3,6>
    L.FX.CLNT.TYPE.POS = L.POS<3,7>
    L.FX.LEGAL.ID.POS = L.POS<3,8>
    L.FT.FXSN.NUM.POS = L.POS<4,1>
    L.FT.FX.BUY.SRC.POS = L.POS<4,2>
    L.FT.FX.SEL.DST.POS = L.POS<4,3>
    L.FT.RCEP.MTHD.POS = L.POS<4,4>
    L.FT.PAY.METHOD.POS = L.POS<4,5>
    L.FT.CLNT.TYPE.POS = L.POS<4,6>
    L.FT.LEGAL.ID.POS = L.POS<4,7>
    L.FT.CHANNELS.POS = L.POS<4,8>
    L.FTTC.CHANNELS.POS = L.POS<5,1>
RETURN
END
