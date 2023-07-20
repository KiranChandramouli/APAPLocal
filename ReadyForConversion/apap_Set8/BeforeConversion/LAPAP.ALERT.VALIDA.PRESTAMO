*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.ALERT.VALIDA.PRESTAMO

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_AA.LOCAL.COMMON
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT BP I_F.LAPAP.REPRECIO.TASA

    GOSUB INIT
    GOSUB PROCESS

    RETURN

INIT:

    FN.ST.LAPAP.REPRECIO.TASA = 'F.ST.LAPAP.REPRECIO.TASA'
    FV.ST.LAPAP.REPRECIO.TASA = ''
    CALL OPF (FN.ST.LAPAP.REPRECIO.TASA,FV.ST.LAPAP.REPRECIO.TASA)

    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = '';
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    RETURN

PROCESS:
********

    Y.NUMERO.PRODUCTO  = R.NEW(ST.L.A6.NUMERO.PRODUCTO);
    Y.VAR.CATEGORIA = '';

    IF Y.NUMERO.PRODUCTO NE '' THEN

        ERR.ACCOUNT = ''; R.ACCOUNT = '';
        CALL F.READ(FN.ACCOUNT, Y.NUMERO.PRODUCTO, R.ACCOUNT, F.ACCOUNT, ERR.ACCOUNT)

        IF R.ACCOUNT THEN

            Y.VAR.CATEGORIA  = R.ACCOUNT<AC.CATEGORY>

            IF (Y.VAR.CATEGORIA GE 3000 AND Y.VAR.CATEGORIA LE 3999) THEN
*Rango de categoria de prestamos
            END ELSE
*Si el numero de producto no pertene a un prestamo disparar OVERRIDE
                TEXT = 'L.APAP.VALIDA.PRESTAMO';
                CURR.NO = 1;
                CALL STORE.OVERRIDE(CURR.NO)
            END

        END

    END

    RETURN
