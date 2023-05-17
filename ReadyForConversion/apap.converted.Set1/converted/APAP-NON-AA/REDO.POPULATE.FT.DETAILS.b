SUBROUTINE REDO.POPULATE.FT.DETAILS
**************************************************************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Ganesh R
* PROGRAM NAME: REDO.POPULATE.FT.DETAILS
* ODR NO      : ODR-2011-03-0150
*-----------------------------------------------------------------------------------------------------
*DESCRIPTION: This routine is to get the FT details from a Work File REDO.AUTH.CODE.DETAILS and populate in Teller Version
*******************************************************************************************************
*linked with :
*In parameter:
*Out parameter:
*****************************************************************************************************
*Modification History
*  Date       Who             Reference       Description
* 16 jan 2011 Ganesh R    ODR-2011-03-0150    Will Store the Detils
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_System
    $INSERT I_GTS.COMMON
    $INSERT I_REDO.DEBIT.CARD.COMMON
    $INSERT I_F.ATM.REVERSAL

    IF OFS$HOT.FIELD EQ 'L.TT.POS.AUTHNM' THEN
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END
    GOSUB PGM.END
RETURN
************
OPEN.FILES:
************
    FN.ATM.REVERSAL = 'F.ATM.REVERSAL'
    F.ATM.REVERSAL  = ''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIS = ''
    CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)


    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
**********
PROCESS:
***********
*Get the Value of Auth Code.
*    Y.CCARD.NO = TEMP.VAR
    Y.CCARD.NO = System.getVariable("CURRENT.CARD.NUM")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CCARD.NO = ""
    END
    Y.AUTH.ID = COMI
    Y.AUTH.ID = Y.CCARD.NO:'.':Y.AUTH.ID

    Y.DR.CR.MARKER = R.NEW(TT.TE.DR.CR.MARKER)
    CALL F.READ(FN.ATM.REVERSAL,Y.AUTH.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.ERR)
    IF R.ATM.REVERSAL THEN
        GOSUB CHECK.PROCESS
    END ELSE
        ETEXT = "EB-REDO.WRONG.AUTH.NUM"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END

*Read the FT id and get the details

    CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.ERR)
    IF FUNDS.ERR THEN
        FUNDS.ERR = ''
        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,Y.FT.ID,R.FUNDS.TRANSFER,FUNDS.ERR)
    END
    IF R.FUNDS.TRANSFER THEN
        Y.DEBIT.ACCOUNT = R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>
        Y.ACC.ID        = R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>
        Y.DEBIT.AMOUNT  = R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>
        IF NOT(Y.DEBIT.AMOUNT) THEN
            Y.DEBIT.AMOUNT = R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>
            Y.DEBIT.CCY    = R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>
        END
        Y.DEBIT.CCY     = R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>

        R.NEW(TT.TE.ACCOUNT.2)  = Y.DEBIT.ACCOUNT
        R.NEW(TT.TE.CURRENCY.2) = Y.DEBIT.CCY

        IF Y.DEBIT.CCY EQ LCCY THEN
            R.NEW(TT.TE.AMOUNT.LOCAL.2) = Y.DEBIT.AMOUNT
            R.NEW(TT.TE.AMOUNT.LOCAL.1) = Y.DEBIT.AMOUNT
        END ELSE
            R.NEW(TT.TE.AMOUNT.FCY.2) = Y.DEBIT.AMOUNT
            R.NEW(TT.TE.AMOUNT.FCY.1) = Y.DEBIT.AMOUNT
        END
    END ELSE
        ETEXT = "EB-REDO.WRONG.AUTH.NUM"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    R.NEW(TT.TE.CUSTOMER.1) = R.ACCOUNT<AC.CUSTOMER>
RETURN

*****************
CHECK.PROCESS:
*****************
    Y.WITHDRAW.STATUS = R.ATM.REVERSAL<AT.REV.WITHDRAW.STATUS>
    IF NOT(Y.WITHDRAW.STATUS) THEN
        Y.FT.ID = R.ATM.REVERSAL<AT.REV.TRANSACTION.ID>
    END ELSE
        ETEXT = "EB-NUM.ALREADY.USED"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
RETURN
*************
PGM.END:
************
END
