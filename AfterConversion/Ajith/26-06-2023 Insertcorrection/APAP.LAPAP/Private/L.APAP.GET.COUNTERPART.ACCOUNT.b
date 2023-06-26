$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*26-06-2023       Conversion Tool           R22 Auto Code conversion          No Changes
*26-06-2023       S.AJITHKUMAR               R22 Manual Code Conversion       T24.BP IS REMOVED , Command this Insert file I_F.T24.FUND.SERVICES And Y.DEBIT.AC ,Y.CREDIT.AC also command
SUBROUTINE L.APAP.GET.COUNTERPART.ACCOUNT
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.ACCOUNT
    $INSERT  I_ENQUIRY.COMMON
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.TELLER
*  $INSERT  I_F.T24.FUND.SERVICES ;*R22 MANUAL CODE


    Y.NO.REF = O.DATA
    O.DATA = ""

    Y.NO.TRANS = ""
    Y.NO.ACC = ""
    Y.CREDIT.AC = ""
    Y.DEBIT.AC = ""

    Y.DEL.INDEX = INDEX(Y.NO.REF, "|", 1)

    Y.NO.TRANS = SUBSTRINGS(Y.NO.REF, 0, Y.DEL.INDEX-1)
    Y.NO.ACC = SUBSTRINGS(Y.NO.REF, Y.DEL.INDEX+1, LEN(Y.NO.REF))

    FINDSTR "\" IN Y.NO.TRANS SETTING R.VAL, R.POS THEN
    
        Y.NO.TRANS = SUBSTRINGS(Y.NO.REF, 0, Y.DEL.INDEX-5)

    END

    FINDSTR "FT" IN Y.NO.REF SETTING R.VAL, R.POS THEN
        FN.DAT = "F.FUNDS.TRANSFER"
        FV.DAT = ""
        CALL OPF(FN.DAT, FV.DAT)
        R.DAT = ""
        DAT.ERR = ""

        CALL F.READ(FN.DAT, Y.NO.TRANS, R.DAT, FV.DAT, DAT.ERR)

        Y.CREDIT.AC = R.DAT<FT.CREDIT.ACCT.NO>
        Y.DEBIT.AC = R.DAT<FT.DEBIT.ACCT.NO>

        IF DAT.ERR NE "" THEN

            FN.FT.HIS = "F.FUNDS.TRANSFER$HIS"
            F.FT.HIS = ""
            HIST.REC = ""
            YERROR = ""

            CALL OPF(FN.FT.HIS,F.FT.HIS)
            CALL EB.READ.HISTORY.REC(F.FT.HIS, Y.NO.TRANS, HIST.REC, YERROR)

            Y.CREDIT.AC = HIST.REC<FT.CREDIT.ACCT.NO>
            Y.DEBIT.AC = HIST.REC<FT.DEBIT.ACCT.NO>
        END

        IF Y.NO.ACC EQ Y.CREDIT.AC THEN
            O.DATA = Y.DEBIT.AC
        END ELSE
            O.DATA = Y.CREDIT.AC
        END

    END

    FINDSTR "TT" IN Y.NO.REF SETTING R.VAL, R.POS THEN
        FN.DAT = "F.TELLER"
        FV.DAT = ""
        CALL OPF(FN.DAT, FV.DAT)
        R.DAT = ""
        DAT.ERR = ""

        CALL F.READ(FN.DAT, Y.NO.TRANS, R.DAT, FV.DAT, DAT.ERR)

        Y.CREDIT.AC = R.DAT<TT.TE.ACCOUNT.1>
        Y.DEBIT.AC = R.DAT<TT.TE.ACCOUNT.2>

        IF DAT.ERR NE "" THEN

            FN.FT.HIS = "F.TELLER$HIS"
            F.FT.HIS = ""
            HIST.REC = ""
            YERROR = ""

            CALL OPF(FN.FT.HIS,F.FT.HIS)
            CALL EB.READ.HISTORY.REC(F.FT.HIS, Y.NO.TRANS, HIST.REC, YERROR)

            Y.CREDIT.AC = HIST.REC<TT.TE.ACCOUNT.1>
            Y.DEBIT.AC = HIST.REC<TT.TE.ACCOUNT.2>

        END

        IF Y.NO.ACC EQ Y.CREDIT.AC THEN
            O.DATA = Y.DEBIT.AC
        END ELSE
            O.DATA = Y.CREDIT.AC
        END

    END

    FINDSTR "T24FS" IN Y.NO.REF SETTING R.VAL, R.POS THEN
        FN.DAT = "F.T24.FUND.SERVICES"
        FV.DAT = ""
        CALL OPF(FN.DAT, FV.DAT)
        R.DAT = ""
        DAT.ERR = ""

        CALL F.READ(FN.DAT, Y.NO.TRANS, R.DAT, FV.DAT, DAT.ERR)

*Y.CREDIT.AC = R.DAT<TFS.ACCOUNT.CR>
*Y.DEBIT.AC = R.DAT<TFS.ACCOUNT.DR>

        IF DAT.ERR NE "" THEN

            FN.FT.HIS = "F.T24.FUND.SERVICES$HIS"
            F.FT.HIS = ""
            HIST.REC = ""
            YERROR = ""

            CALL OPF(FN.FT.HIS,F.FT.HIS)
            CALL EB.READ.HISTORY.REC(F.FT.HIS, Y.NO.TRANS, HIST.REC, YERROR)

*Y.CREDIT.AC = HIST.REC<TFS.ACCOUNT.CR>
*Y.DEBIT.AC = HIST.REC<TFS.ACCOUNT.DR>

        END

        IF Y.NO.ACC EQ Y.CREDIT.AC THEN
            O.DATA = Y.DEBIT.AC
        END ELSE
            O.DATA = Y.CREDIT.AC
        END

    END

RETURN

END
