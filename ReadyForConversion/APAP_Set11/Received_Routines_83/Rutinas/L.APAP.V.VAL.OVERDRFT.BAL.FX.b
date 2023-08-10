*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
*Fecha Modif: 23/06/2021
*Autor: Oliver Fermin
*Descripcion: Se agregara una condicion para que esta validacion solo inicie para las cuentas que inicien con 1. Obviando las cuentas internas.

    SUBROUTINE L.APAP.V.VAL.OVERDRFT.BAL.FX

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.FUNDS.TRANSFER
    $INSERT T24.BP I_F.ENQUIRY
    $INSERT T24.BP I_ENQUIRY.COMMON

    GOSUB READ.ACCOUNT
    GOSUB FT.PROCESS

    RETURN

FT.PROCESS:
***********

    YTRAN.AMT = R.NEW(FT.LOCAL.REF)<1,POS.L.TT.TRANS.AMT>

    IF YTRAN.AMT EQ '' THEN
        YTRAN.AMT = YDEBIT.AMT
    END

*Para solo validar el balance de las cuentas de ahorros y no las internas.
    Y.CATEG.INICIA = LEFT(Y.CATEG,2);
    IF Y.CATEG.INICIA EQ 60 OR Y.CATEG.INICIA EQ 65 THEN

        IF YTRAN.AMT GT Y.USABLE.BAL OR Y.BALANCE LT 0  THEN
            AF = FT.DEBIT.ACCT.NO
            ETEXT  = 'EB-REDO.ACCT.UNAUTH.OD'
            CALL STORE.END.ERROR
        END

    END

    RETURN

READ.ACCOUNT:
**************

    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = '';
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    ERR.ACCOUNT = ''; R.ACCOUNT = ''; Y.ACCOUNT.BALANCE = 0;
    Y.TRANSIT.AMOUNT = ''; Y.L.AC.AVL.BAL = ''; YVAL.POSN = '';
    YACTUAL.AMT = 0; YTRAN.AMT = '';

    YFILE.NAME = 'ACCOUNT':FM:'FUNDS.TRANSFER'
    YFIELD.NME = 'L.AC.AV.BAL':VM:'L.AC.TRAN.AVAIL':FM:'L.TT.TRANS.AMT'
    CALL MULTI.GET.LOC.REF(YFILE.NAME,YFIELD.NME,YVAL.POSN)

    POS.AVL.BAL = YVAL.POSN<1,1>
    POS.TRANS.AMT = YVAL.POSN<1,2>
    POS.L.TT.TRANS.AMT = YVAL.POSN<2,1>

    YDEBIT.ACCT = ''
    YDEBIT.ACCT = R.NEW(FT.DEBIT.ACCT.NO)
    YDEBIT.AMT  = R.NEW(FT.DEBIT.AMOUNT)

    IF NOT(YDEBIT.AMT) THEN
        YDEBIT.AMT = R.NEW(FT.CREDIT.AMOUNT)
    END

    CALL F.READ(FN.ACCOUNT,YDEBIT.ACCT,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
*Y.TRANSIT.AMOUNT  = R.ACCOUNT<AC.LOCAL.REF,POS.TRANS.AMT>
*Y.L.AC.AVL.BAL    = R.ACCOUNT<AC.LOCAL.REF,POS.AVL.BAL>

    O.DATA = YDEBIT.ACCT
    CALL E.TOTAL.LOCK.AMT
    Y.LOCK = O.DATA
    Y.BALANCE = R.ACCOUNT<AC.WORKING.BALANCE>
    Y.CATEG = R.ACCOUNT<AC.CATEGORY>
    Y.USABLE.BAL  = Y.BALANCE + YDEBIT.AMT - Y.LOCK

    RETURN

END
