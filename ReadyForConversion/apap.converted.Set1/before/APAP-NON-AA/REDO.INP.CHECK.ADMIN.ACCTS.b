*-----------------------------------------------------------------------------
* <Rating>57</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.INP.CHECK.ADMIN.ACCTS
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS
    $INSERT I_F.REDO.H.ADMIN.CHEQUES

    IF OFS$OPERATION EQ 'PROCESS' THEN
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END
    GOSUB PGM.END
    RETURN

*-----------
OPEN.FILES:
*-----------

    FN.REDO.ADMIN.CHQ.PARAM = 'F.REDO.ADMIN.CHQ.PARAM'


    FN.REDO.ADMIN.CHQ.DETAILS = 'F.REDO.ADMIN.CHQ.DETAILS'
    F.REDO.ADMIN.CHQ.DETAILS = ''
    CALL OPF(FN.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS)

    FN.REDO.H.ADMIN.CHEQUES = 'F.REDO.H.ADMIN.CHEQUES'
    F.REDO.H.ADMIN.CHEQUES = ''
    CALL OPF(FN.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES)

    VAR.CHQ.PARAM.ID = 'SYSTEM'

    CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,VAR.CHQ.PARAM.ID,R.ADMIN.CHQ,ADMIN.ERR)

    VAR.ADMIN.ACCT = R.ADMIN.CHQ<ADMIN.CHQ.PARAM.ACCOUNT>
    VAR.UNPAID.ACCT = R.ADMIN.CHQ<ADMIN.CHQ.PARAM.UNPAID.ADMIN>

    CHANGE VM TO FM IN VAR.ADMIN.ACCT
    CHANGE VM TO FM IN VAR.UNPAID.ACCT

    VAR.ADM.ACCOUNTS = VAR.ADMIN.ACCT:FM:VAR.UNPAID.ACCT

    RETURN

*----------
PROCESS:
*--------
    Y.CHEQUE.NO = R.NEW(FT.CREDIT.THEIR.REF)
    Y.DEBIT.ACCT.NO = R.NEW(FT.DEBIT.ACCT.NO)
    Y.CREDIT.ACCT.NO = R.NEW(FT.CREDIT.ACCT.NO)
    IF Y.CHEQUE.NO[1,2] EQ "TT" ELSE
        CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NO,R.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,ADMIN.CHQ.ERR)
*This condition is satisfy for manager cheque and no cheque FT process
        IF NOT(Y.CHEQUE.NO) OR NOT(R.ADMIN.CHQ.DETAILS) THEN
            SEL.LIST = ''
            SEL.CMD = "SELECT ":FN.REDO.H.ADMIN.CHEQUES:" WITH SERIAL.NO EQ ":Y.CHEQUE.NO
            CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,RE.ERR)
            IF NOT(SEL.LIST) THEN
                LOCATE Y.DEBIT.ACCT.NO IN VAR.ADM.ACCOUNTS SETTING DR.POS THEN
                    AF = FT.DEBIT.ACCT.NO
                    ETEXT = 'EB-ADMIN.ACCTS.USED'
                    CALL STORE.END.ERROR
                    GOSUB PGM.END
                END

                LOCATE Y.CREDIT.ACCT.NO IN VAR.ADM.ACCOUNTS SETTING CR.POS THEN
                    AF = FT.CREDIT.ACCT.NO
                    ETEXT = 'EB-ADMIN.ACCTS.USED'
                    CALL STORE.END.ERROR
                    GOSUB PGM.END
                END
            END ELSE
                GOSUB CHECK.ADMIN.VERSION
            END
        END ELSE
            GOSUB CHECK.ADMIN.VERSION
        END
    END
    RETURN
*-----------------------
CHECK.ADMIN.VERSION:
*----------------------
*This part is used to checks if any of the admin account numbers are given debit account number field
* And also this validation is not required for reversal of admin cheques.
    IF PGM.VERSION NE ',REDO.REVERSE.CHQ' THEN
        LOCATE Y.DEBIT.ACCT.NO IN VAR.ADM.ACCOUNTS SETTING DR.POS THEN
            AF = FT.DEBIT.ACCT.NO
            ETEXT = 'EB-ADMIN.ACCTS.USED'
            CALL STORE.END.ERROR
            GOSUB PGM.END
        END
    END

    RETURN
*-------
PGM.END:
*-------
END
