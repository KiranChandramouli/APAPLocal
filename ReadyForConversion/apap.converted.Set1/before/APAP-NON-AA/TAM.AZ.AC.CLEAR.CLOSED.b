*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------


    SUBROUTINE TAM.AZ.AC.CLEAR.CLOSED

    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_F.AZ.ACCOUNT

    IF V$FUNCTION EQ 'I' THEN
        GOSUB INIT
        GOSUB MAIN.PROCESS

    END


    RETURN
INIT:


    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)


    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    APPL.ARRAY = 'AZ.ACCOUNT'
    FLD.ARRAY  = 'L.AZ.DEBIT.ACC'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    Y.VAL.DEBIT.ACC = FLD.POS<1,1>
    RETURN

MAIN.PROCESS:

    Y.ACC.CNT = DCOUNT(R.NEW(AZ.LOCAL.REF)<1,Y.VAL.DEBIT.ACC>,SM)
    Y.VAR = 1
    LOOP
    WHILE Y.VAR LE Y.ACC.CNT
        Y.ACC.ID = R.NEW(AZ.LOCAL.REF)<1,Y.VAL.DEBIT.ACC,Y.VAR>
        CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        IF R.ACCOUNT EQ '' THEN
            DEL R.NEW(AZ.LOCAL.REF)<1,Y.VAL.DEBIT.ACC,Y.VAR>
        END

        Y.VAR++
    REPEAT

    RETURN

END

