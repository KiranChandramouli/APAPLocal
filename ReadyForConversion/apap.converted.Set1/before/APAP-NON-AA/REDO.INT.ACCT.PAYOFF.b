*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.INT.ACCT.PAYOFF

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.MULTITXN.PARAMETER
    $INSERT I_F.FUNDS.TRANSFER
*-----------------------------------------------------------------------------

    FN.REDO.MULTITXN.PARAMETER = 'F.REDO.MULTITXN.PARAMETER'
    F.REDO.MULTITXN.PARAMETER = ''
    CALL OPF(FN.REDO.MULTITXN.PARAMETER,F.REDO.MULTITXN.PARAMETER)

    CALL CACHE.READ(FN.REDO.MULTITXN.PARAMETER,'SYSTEM',R.RMP,RMP.ERR)

    IF APPLICATION EQ "FUNDS.TRANSFER" THEN
        IF R.NEW(FT.DEBIT.ACCT.NO) EQ '' AND R.RMP<RMP.CHECK.ACCOUNT> NE '' THEN
            Y.DEB.AC = LCCY:R.RMP<RMP.CHECK.ACCOUNT>
            CALL INT.ACC.OPEN(Y.DEB.AC,PRETURN.CODE)
            IF PGM.VERSION EQ ',REDO.UNC.CUR' THEN
                R.NEW(FT.DEBIT.ACCT.NO)= LCCY:R.RMP<RMP.CHECK.ACCOUNT>
            END ELSE
                R.NEW(FT.CREDIT.ACCT.NO)= LCCY:R.RMP<RMP.CHECK.ACCOUNT>
            END
        END
    END

    RETURN

END
