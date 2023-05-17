SUBROUTINE REDO.B.SOD.MM.REV.STMT.ENTRY.LOAD
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.MM.EFF.RATE.ACCR.LOAD
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.B.MM.EFF.RATE.ACCR.LOAD is the load routine to load all the variables required for the process
*Linked With  :
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date           Who                  Reference           Description
* ------         ------               -------------       -------------
* 12 FEB 2013    Balagurunathan B     RTC-553577          Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.MM.EFF.RATE.ACCR.COMMON
    $INSERT I_F.REDO.APAP.H.PRODUCT.DEFINE
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********

    FN.MM.MONEY.MARKET = 'F.MM.MONEY.MARKET'
    F.MM.MONEY.MARKET = ''
    CALL OPF(FN.MM.MONEY.MARKET,F.MM.MONEY.MARKET)

    FN.REDO.APAP.H.PRODUCT.DEFINE = 'F.REDO.APAP.H.PRODUCT.DEFINE'
    F.REDO.APAP.H.PRODUCT.DEFINE = ''
    CALL OPF(FN.REDO.APAP.H.PRODUCT.DEFINE,F.REDO.APAP.H.PRODUCT.DEFINE)

    FN.LMM.INSTALL.CONDS = 'F.LMM.INSTALL.CONDS'
    F.LMM.INSTALL.CONDS = ''
    CALL OPF(FN.LMM.INSTALL.CONDS,F.LMM.INSTALL.CONDS)


    FN.LMM.ACCOUNT.BALANCES = 'F.LMM.ACCOUNT.BALANCES'
    F.LMM.ACCOUNT.BALANCES = ''
    CALL OPF(FN.LMM.ACCOUNT.BALANCES,F.LMM.ACCOUNT.BALANCES)

    FN.BASIC.INTEREST = 'F.BASIC.INTEREST'
    F.BASIC.INTEREST = ''
    CALL OPF(FN.BASIC.INTEREST,F.BASIC.INTEREST)

    FN.INTEREST.BASIS = 'F.INTEREST.BASIS'
    F.INTEREST.BASIS  = ''
    CALL OPF(FN.INTEREST.BASIS,F.INTEREST.BASIS)

*    FN.EB.ACCRUAL.PARAM = 'F.EB.ACCRUAL.PARAM' ;* 29-Jan-2012 - S
*    F.EB.ACCRUAL.PARAM = ''
*    CALL OPF(FN.EB.ACCRUAL.PARAM,F.EB.ACCRUAL.PARAM) ;* 29-Jan-2012 - E

    FN.REDO.APAP.L.CONTRACT.BALANCES = 'F.REDO.APAP.L.CONTRACT.BALANCES'
    F.REDO.APAP.L.CONTRACT.BALANCES = ''
    CALL OPF(FN.REDO.APAP.L.CONTRACT.BALANCES,F.REDO.APAP.L.CONTRACT.BALANCES)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)
RETURN
*--------------------------------------------------------------------------------------------------------
**********
PROCESS.PARA:
**********
*    SEL.CMD.EAP = "SELECT ":FN.EB.ACCRUAL.PARAM ;* 29-Jan-2012 - S
*    CALL EB.READLIST(SEL.CMD.EAP,SEL.LIST.EAP,'',NO.OF.REC.EAP,SEL.ERR.EAP)

    CALL CACHE.READ(FN.REDO.APAP.H.PRODUCT.DEFINE,'SYSTEM',R.REDO.APAP.H.PRODUCT.DEFINE,REDO.APAP.H.PRODUCT.DEFINE.ERR)
    Y.INT.PAY.TXN.CODE = R.REDO.APAP.H.PRODUCT.DEFINE<PRD.DEF.INT.PAY.TXN.CODE>
    Y.INT.ACC.TXN.CODE = R.REDO.APAP.H.PRODUCT.DEFINE<PRD.DEF.INT.ACC.TXN.CODE>

    Y.MM.PLACE.CATEG = "21076":@FM:"21077":@FM:"21078":@FM:"21079":@FM:"21080"

RETURN
*--------------------------------------------------------------------------------------------------------
END
