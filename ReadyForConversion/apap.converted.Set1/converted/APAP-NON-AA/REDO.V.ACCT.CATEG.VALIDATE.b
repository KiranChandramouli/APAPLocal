SUBROUTINE REDO.V.ACCT.CATEG.VALIDATE

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT

***********
INITIALISE:
***********
*
    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION  = ''
    CALL OPF(FN.TELLER.TRANSACTION, F.TELLER.TRANSACTION)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    R.ACCOUNT = ''
    R.RELLER.TRANSACTION = ''

    TT.TR.ID = ''
    AC.ID = ''
    TT.TR.ERR = ''

*********
PROCESS:
*********
*
    TT.TR.ID = R.NEW(TT.TE.TRANSACTION.CODE)
    AC.ID    = COMI
*
    CALL CACHE.READ(FN.TELLER.TRANSACTION, TT.TR.ID, R.TT.TR, TT.TR.ERR)

    BEGIN CASE
        CASE AF EQ TT.TE.ACCOUNT.1
            IF NOT(AC.ID) THEN
                AC.ID = R.NEW(TT.TE.ACCOUNT.1)
            END

            CATEG.TO.CHECK = R.TT.TR<TT.TR.CAT.DEPT.CODE.1>

        CASE AF EQ TT.TE.ACCOUNT.2
            IF NOT(AC.ID) THEN
                AC.ID = R.NEW(TT.TE.ACCOUNT.2)
            END

            CATEG.TO.CHECK = R.TT.TR<TT.TR.CAT.DEPT.CODE.2>

    END CASE


    CALL F.READ(FN.ACCOUNT, AC.ID, R.ACCOUNT, F.ACCOUNT, AC.ERR)

    IF AC.ERR OR (R.ACCOUNT<AC.CATEGORY> NE CATEG.TO.CHECK) THEN
        ETEXT = "TT-REDO.AC.CAT.NOT.MATCHES"
    END

    IF MESSAGE EQ "VAL" AND R.NEW(TT.TE.RECORD.STATUS) EQ "IHLD" THEN
        GOSUB ANALISE.HOLD.PROCESS
    END

    IF R.NEW(TT.TE.RECORD.STATUS) EQ "IHLD" AND MESSAGE NE "VAL" THEN
        IF AF EQ TT.TE.ACCOUNT.1 THEN
            R.NEW.LAST(TT.TE.ACCOUNT.1) = AC.ID
        END
        IF AF EQ TT.TE.ACCOUNT.2 THEN
            R.NEW.LAST(TT.TE.ACCOUNT.2) = AC.ID
        END
    END

    CALL REDO.V.INP.TT.AC.VAL

RETURN
*
* ===================
ANALISE.HOLD.PROCESS:
* ===================
*

    IF AF EQ TT.TE.ACCOUNT.1 THEN
        WCAJERO = R.NEW(TT.TE.ACCOUNT.1)[9,4]
        IF WCAJERO EQ R.NEW(TT.TE.TELLER.ID.1) THEN
            R.NEW(TT.TE.ACCOUNT.1) = R.NEW.LAST(TT.TE.ACCOUNT.1)
        END
    END
*
    IF AF EQ TT.TE.ACCOUNT.2 THEN
        WCAJERO = R.NEW(TT.TE.ACCOUNT.2)[9,4]
        IF WCAJERO EQ R.NEW(TT.TE.TELLER.ID.2) THEN
            R.NEW(TT.TE.ACCOUNT.2) = R.NEW.LAST(TT.TE.ACCOUNT.2)
        END
    END
*
RETURN

END
