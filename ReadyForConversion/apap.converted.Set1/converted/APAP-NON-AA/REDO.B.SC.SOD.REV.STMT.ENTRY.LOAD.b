SUBROUTINE REDO.B.SC.SOD.REV.STMT.ENTRY.LOAD
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This BATCH routine will look for Spec entries that raised on the bussiness day from RE.SPEC.ENT.TODAY to reverse and re-calculate interest accrual based on
*               effective interest rate method and raise accounting entries
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Pradeep S
* PROGRAM NAME : REDO.B.SC.REV.SPEC.ENTRY.LOAD
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference           Description
* 06 Jul 2011      Pradeep S          PACS00080124        Initial creation
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COMPANY
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SC.PARAMETER
    $INSERT I_F.SC.STD.SEC.TRADE
    $INSERT I_F.SC.TRADING.POSITION
    $INSERT I_REDO.B.SC.SOD.REV.STMT.ENTRY.COMMON
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    FN.SPEC.LWORK = 'F.RE.SPEC.ENT.LWORK.DAY'
    F.SPEC.LWORK = ''
    CALL OPF(FN.SPEC.LWORK,F.SPEC.LWORK)

    FN.SPEC.TODAY = 'F.RE.SPEC.ENT.TODAY'
    F.SPEC.TODAY = ''
    CALL OPF(FN.SPEC.TODAY,F.SPEC.TODAY)

    FN.SPEC.XREF = 'F.RE.SPEC.ENTRY.XREF'
    F.SPEC.XREF = ''
    CALL OPF(FN.SPEC.XREF,F.SPEC.XREF)

    FN.SPEC.DTL = 'F.RE.SPEC.ENTRY.DETAIL'
    F.SPEC.DTL = ''
    CALL OPF(FN.SPEC.DTL,F.SPEC.DTL)

    FN.SPEC = 'F.RE.CONSOL.SPEC.ENTRY'
    F.SPEC = ''
    CALL OPF(FN.SPEC,F.SPEC)

    FN.SC.STD.SEC.TRADE = 'F.SC.STD.SEC.TRADE'
    F.SC.STD.SEC.TRADE = ''
    CALL OPF(FN.SC.STD.SEC.TRADE,F.SC.STD.SEC.TRADE)

    FN.SECURITY.MASTER = "F.SECURITY.MASTER"
    F.SECURITY.MASTER = ""
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)

    FN.SC.PARAMETER = "F.SC.PARAMETER"
    F.SC.PARAMETER = ""
    CALL OPF(FN.SC.PARAMETER,F.SC.PARAMETER)

    FN.SC.TRADING.POSITION = "F.SC.TRADING.POSITION"
    F.SC.TRADING.POSITION  = ""
    CALL OPF(FN.SC.TRADING.POSITION,F.SC.TRADING.POSITION)

    FN.SC.TRADE.POS.HISTORY = "F.SC.TRADE.POS.HISTORY"
    F.SC.TRADE.POS.HISTORY  = ""
    CALL OPF(FN.SC.TRADE.POS.HISTORY,F.SC.TRADE.POS.HISTORY)

    FN.REDO.APAP.L.CONTRACT.BALANCES = "F.REDO.APAP.L.CONTRACT.BALANCES"
    F.REDO.APAP.L.CONTRACT.BALANCES  = ""
    CALL OPF(FN.REDO.APAP.L.CONTRACT.BALANCES,F.REDO.APAP.L.CONTRACT.BALANCES)

    FN.REDO.APAP.L.SC.ENTRIES = "F.REDO.APAP.L.SC.ENTRIES"
    F.REDO.APAP.L.SC.ENTRIES = ""
    CALL OPF(FN.REDO.APAP.L.SC.ENTRIES,F.REDO.APAP.L.SC.ENTRIES)

    FN.SEC.ACC.MASTER = 'F.SEC.ACC.MASTER'
    F.SEC.ACC.MASTER = ''
    CALL OPF(FN.SEC.ACC.MASTER,F.SEC.ACC.MASTER)

    LOC.REF.APPLICATION = "SC.PARAMETER":@FM:'SEC.ACC.MASTER'
    LOC.REF.FIELDS = "L.SC.INT.ACCT":@FM:'L.INT.ADJ.CAT'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.SC.INT.ACCT = LOC.REF.POS<1,1>
    POS.L.INT.ADJ.CAT = LOC.REF.POS<2,1>

    R.SC.STD.TRADE = ""
    CALL F.READ(FN.SC.STD.SEC.TRADE,ID.COMPANY,R.SC.STD.TRADE,F.SC.STD.SEC.TRADE,SC.STD.ERR)

    IF R.SC.STD.TRADE THEN
        Y.SC.CR.TXN.CODE = R.SC.STD.TRADE<SC.SST.ACCR.CR.CODE>
        Y.SC.DR.TXN.CODE = R.SC.STD.TRADE<SC.SST.ACCR.DR.CODE>
    END ELSE
        CALL F.READ(FN.SC.STD.SEC.TRADE,R.COMPANY(EB.COM.FINANCIAL.COM),R.SC.STD.TRADE,F.SC.STD.SEC.TRADE,SC.STD.ERR)
        Y.SC.CR.TXN.CODE = R.SC.STD.TRADE<SC.SST.ACCR.CR.CODE>
        Y.SC.DR.TXN.CODE = R.SC.STD.TRADE<SC.SST.ACCR.DR.CODE>S
    END

    R.SC.PARAM = ""
    CALL CACHE.READ(FN.SC.PARAMETER, ID.COMPANY, R.SC.PARAM, ERR.SC.PARAM)

    IF R.SC.PARAM THEN
        Y.CCY.MARKET   = R.SC.PARAM<SC.PARAM.DEFAULT.CCY.MARKET>
        Y.PARK.IN.ACCT = R.SC.PARAM<SC.PARAM.LOCAL.REF,POS.L.SC.INT.ACCT>
    END ELSE
        CALL CACHE.READ(FN.SC.PARAMETER, R.COMPANY(EB.COM.FINANCIAL.COM), R.SC.PARAM, ERR.SC.PARAM)
        Y.CCY.MARKET = R.SC.PARAM<SC.PARAM.DEFAULT.CCY.MARKET>
        Y.PARK.IN.ACCT = R.SC.PARAM<SC.PARAM.LOCAL.REF,POS.L.SC.INT.ACCT>
    END

RETURN
END
