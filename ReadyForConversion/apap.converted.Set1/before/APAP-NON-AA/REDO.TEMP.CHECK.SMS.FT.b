*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.TEMP.CHECK.SMS.FT

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.FT.TT.TRANSACTION
    $INSERT I_F.ACCOUNT
    $INSERT I_F.USER

MAIN:

    FN.AC = 'F.ACCOUNT'
    F.AC = ''
    CALL OPF(FN.AC,F.AC)

    FN.USER = 'F.USER'
    F.USER = ''
    CALL OPF(FN.USER,F.USER)

    POS.SS = ''
    Y.FLDS = 'L.TELR.LOAN':VM:'L.ALLOW.ACTS'
    Y.APPLNS = 'USER'
    CALL MULTI.GET.LOC.REF(Y.APPLNS,Y.FLDS,POS.SS)
    Y.POS.TRL = POS.SS<1,1>
    Y.POS.ALW.ACT = POS.SS<1,2>


    Y.ARR.ID = R.NEW(FT.TN.DEBIT.ACCT.NO)

    CALL F.READ(FN.AC,Y.ARR.ID,R.AC,F.AC,AC.ERR)
    Y.AA.ID = R.AC<AC.ARRANGEMENT.ID>

    IF Y.AA.ID THEN
        GOSUB PROCESS
    END ELSE
        RETURN
    END


PROCESS:

    Y.USR = OPERATOR
    CALL F.READ(FN.USER,Y.USR,R.USR,F.USER,ERR.US)

    IF R.USR<EB.USE.LOCAL.REF,Y.POS.TRL> EQ 'TELLER' OR R.USR<EB.USE.LOCAL.REF,Y.POS.TRL> EQ 'OTHERS' THEN
        AF = FT.TN.TRANSACTION.TYPE
        ETEXT = 'EB-ACTIVITY.NOT.ALLOW'
        CALL STORE.END.ERROR
        CALL TRANSACTION.ABORT
    END

    RETURN

END
