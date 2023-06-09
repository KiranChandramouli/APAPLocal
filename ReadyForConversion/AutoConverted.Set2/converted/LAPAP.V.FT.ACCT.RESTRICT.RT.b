SUBROUTINE LAPAP.V.FT.ACCT.RESTRICT.RT

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AI.REDO.ACCT.RESTRICT.PARAMETER

    GOSUB INIT

    Y.TYPE = 'CREDIT'
    GOSUB VALIDA.ACCT

    IF Y.CONTINUE EQ 'N' THEN
        ETEXT='CUENTA CON CONDICIONES BLOQUEANTES - ' : Y.CONDICION
        CALL STORE.END.ERROR

        RETURN
    END ELSE

        Y.TYPE = 'DEBIT'
        GOSUB VALIDA.ACCT

        IF Y.CONTINUE EQ 'N' THEN
            ETEXT='CUENTA CON CONDICIONES BLOQUEANTES - ' : Y.CONDICION
            CALL STORE.END.ERROR
            RETURN
        END

    END

RETURN

*----
INIT:
*----

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''

    FN.AI.REDO.ACCT.RESTRICT.PARAMETER = 'F.AI.REDO.ACCT.RESTRICT.PARAMETER'
    F.AI.REDO.ACCT.RESTRICT.PARAMETER  = ''

    LREF.APP = 'ACCOUNT'
    LREF.STATUS1 = 'L.AC.STATUS1'
    LREF.STATUS2 = 'L.AC.STATUS2'
    LREF.NOTIFY = 'L.AC.NOTIFY.1'
    Y.CONTINUE = 'Y'
    Y.TYPE = ''
    Y.ACCT.ID = ''
    Y.CONDICION = ''

    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL GET.LOC.REF(LREF.APP,LREF.STATUS1,STATUS1.POS)
    CALL GET.LOC.REF(LREF.APP,LREF.STATUS2,STATUS2.POS)
    CALL GET.LOC.REF(LREF.APP,LREF.NOTIFY,NOTIFY.POS)

    CALL OPF(FN.AI.REDO.ACCT.RESTRICT.PARAMETER,F.AI.REDO.ACCT.RESTRICT.PARAMETER)

RETURN

*--------------
VALIDA.ACCT:
*--------------

    IF Y.TYPE EQ 'CREDIT' THEN
        Y.ACCT.ID=R.NEW(FT.CREDIT.ACCT.NO)
    END ELSE
* DEBIT
        Y.ACCT.ID=R.NEW(FT.DEBIT.ACCT.NO)
    END

    CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,R.ERR)
    Y.STATUS1=R.ACCOUNT<AC.LOCAL.REF,STATUS1.POS>
    Y.STATUS2=R.ACCOUNT<AC.LOCAL.REF,STATUS2.POS>
    Y.NOTIFY=R.ACCOUNT<AC.LOCAL.REF,NOTIFY.POS>
    Y.POSTING.RESTRICT = R.ACCOUNT<AC.POSTING.RESTRICT>

    CALL CACHE.READ(FN.AI.REDO.ACCT.RESTRICT.PARAMETER,'SYSTEM',R.AI.REDO.ACCT.RESTRICT.PARAMETER,RES.ERR)

    Y.RESTRICT.ACCT.TYPE =  R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.RESTRICT.ACCT.TYPE>
    CHANGE @VM TO @FM IN Y.RESTRICT.ACCT.TYPE

    LOCATE Y.TYPE IN Y.RESTRICT.ACCT.TYPE SETTING OTHER.POS THEN

        Y.PARAM.ACCT.STATUS =  R.AI.REDO.ACCT.RESTRICT.PARAMETER< AI.RES.PARAM.ACCT.STATUS,OTHER.POS>
        Y.PARAM.ACCT.NOTIFY =  R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.ACCT.NOTIFY.1,OTHER.POS>
        Y.PARAM.POSTING.RESTRICT =  R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.POSTING.RESTRICT,OTHER.POS>

        CHANGE @SM TO @FM IN Y.PARAM.ACCT.STATUS
        CHANGE @SM TO @FM IN Y.PARAM.ACCT.NOTIFY
        CHANGE @SM TO @FM IN Y.PARAM.POSTING.RESTRICT

        LOCATE Y.STATUS1 IN Y.PARAM.ACCT.STATUS SETTING SUB.POS THEN
            Y.CONDICION = Y.STATUS1
            Y.CONTINUE = 'N'
            RETURN
        END

        Y.COUNT = 0
        Y.COUNT = DCOUNT(Y.STATUS2,@SM)

        FOR A = 1 TO Y.COUNT STEP 1
            Y.STATUS2.VAL = Y.STATUS2<1,1,A>
            LOCATE Y.STATUS2.VAL IN Y.PARAM.ACCT.STATUS SETTING SUB.POS THEN
                Y.CONDICION = Y.STATUS2.VAL
                Y.CONTINUE = 'N'
                RETURN
            END

        NEXT A

        Y.COUNT = 0
        Y.COUNT = DCOUNT(Y.NOTIFY,@SM)

        FOR A = 1 TO Y.COUNT STEP 1
            Y.NOTIFY.VAL = Y.NOTIFY<1,1,A>
            LOCATE Y.NOTIFY.VAL IN Y.PARAM.ACCT.NOTIFY SETTING SUB.POS THEN
                Y.CONDICION = Y.NOTIFY.VAL
                Y.CONTINUE = 'N'
                RETURN
            END

        NEXT A

        Y.COUNT = 0
        Y.COUNT = DCOUNT(Y.POSTING.RESTRICT,@VM)

        FOR A = 1 TO Y.COUNT STEP 1
            Y.POSTING.RESTRICT.VAL = Y.POSTING.RESTRICT<1,A>
            LOCATE Y.POSTING.RESTRICT.VAL IN Y.PARAM.POSTING.RESTRICT SETTING SUB.POS THEN
                Y.CONDICION = Y.POSTING.RESTRICT.VAL
                Y.CONTINUE = 'N'
                RETURN
            END

        NEXT A

    END

RETURN

END
