*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.VAL.PRIN.COVID19
*-----------------------------------------------------------------------------
* Bank name: APAP
* Decription: Rutina atachada a las versiones abono de capital extraudinario en efectivo y cheque
* la cual no permite realizar el pago si el cliente tiene balance de prelación pendiente en la tabla
* tabla FBNK.ST.L.APAP.COVI.PRELACIONIII
* Developed By: APAP
* Date:  22/12/2020
*-----------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.FUNDS.TRANSFER
    $INSERT BP I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT T24.BP I_F.ACCOUNT
    GOSUB MAIN.PROCESS
    RETURN
MAIN.PROCESS:
    GOSUB OPEN.TABLA
    GOSUB READ.ACCOUNT

    RETURN

OPEN.TABLA:
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    CALL OPF (FN.ACC,F.ACC)
    FN.PRELACIONIII = 'F.ST.L.APAP.COVI.PRELACIONIII'
    F.PRELACIONIII = ''
    CALL OPF (FN.PRELACIONIII,F.PRELACIONIII)

    RETURN

READ.ACCOUNT:
    R.ACC = ''; ERR.ACC = ''
    CALL F.READ(FN.ACC,R.NEW(FT.CREDIT.ACCT.NO),R.ACC,F.ACC,ERR.ACC)
    IF (R.ACC) THEN
        GOSUB READ.PRELACIONIII
    END
    RETURN

READ.PRELACIONIII:
    Y.MONTO.COVID19 = 0; Y.VALOR.CUOTA.PAY = 0
    CALL F.READ(FN.PRELACIONIII,R.ACC<AC.ARRANGEMENT.ID>,R.PRELACIONIII,F.PRELACIONIII,ERROR.PRELACIONIII)
    IF NOT(R.PRELACIONIII) THEN
        RETURN
    END
    Y.MONTO.COVID19 = R.PRELACIONIII<ST.L.A76.MONTO.COVI19>
    IF Y.MONTO.COVID19 LE 0 THEN
        RETURN
    END
    CALL L.APAP.MONTO.CUOTA.DIA(R.ACC<AC.ARRANGEMENT.ID>,Y.VALOR.CUOTA.PAY)
    IF Y.VALOR.CUOTA.PAY LE Y.MONTO.COVID19 THEN
        Y.MONTO.COVID19 = Y.MONTO.COVID19 - Y.VALOR.CUOTA.PAY
        IF Y.MONTO.COVID19 GT 0 THEN
            MENSAJE = 'TIENE BALANCE DE PRELACION COVID19 PENDIENTE FAVOR HACER EL ABONO POR LA VERSION DE INTERES COVID19 (CHEQUE O EFECTIVO), MONTO PRELACION ES:'
            MENSAJE :=" ":FMT(Y.MONTO.COVID19,"R2,#15")
            E = MENSAJE
            CALL ERR

        END
    END

    RETURN

END
