SUBROUTINE DR.REG.REGN16.ACCT.CCY
* Description  : This routine will update the Currency value
*
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
* 31-07-2014        Ashokkumar                PACS00366332- Initial revision
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CURRENCY
    $INSERT I_F.CCY.HISTORY
    $INSERT I_DR.REG.REGN16.EXTRACT.COMMON

    GOSUB INIT
    GOSUB PROCESS
RETURN

PROCESS:
********

    YCLAIM.CCY = ''
    YCLAIM.CCY = COMI
    IF YCLAIM.CCY EQ LCCY THEN
        COMI = ''
        RETURN
    END

    ACCT.ID = R.REDO.ISSUE.CLAIMS<ISS.CL.ACCOUNT.ID>
    R.ACCOUNT = ''; ACCOUNT.ERR = ''
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    IF R.ACCOUNT THEN
        YOPEN.DATE = R.ACCOUNT<AC.OPENING.DATE>
        LCY.DATE.REC = ''; RETURN.CODE = ''
        CALL GET.CCY.HISTORY(YOPEN.DATE,YCLAIM.CCY,LCY.DATE.REC,RETURN.CODE)

        CCY.MKT.POS = ''
        LOCATE '1' IN LCY.DATE.REC<EB.CUR.CURRENCY.MARKET,1> SETTING CCY.MKT.POS THEN
            EXCH.RATE = LCY.DATE.REC<EB.CUR.MID.REVAL.RATE,CCY.MKT.POS>
        END
    END

    COMI = FMT(EXCH.RATE,"R2%6")
RETURN

INIT:
*****

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

    FN.CCY.HISTORY = 'F.CCY.HISTORY'
    F.CCY.HISTORY = ''
    CALL OPF(FN.CCY.HISTORY,F.CCY.HISTORY)
RETURN
END
