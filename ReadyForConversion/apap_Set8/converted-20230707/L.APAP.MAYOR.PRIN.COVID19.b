SUBROUTINE L.APAP.MAYOR.PRIN.COVID19
*-----------------------------------------------------------------------------
* Bank name: APAP
* Decription: Rutina atachada a las nuevas versiones de abono de interes covid19 en efectivo y cheque
* la cual no permite realizar el pago mayor al monto de prelacion covid19 pendiente en la tabla
* tabla FBNK.ST.L.APAP.COVI.PRELACIONIII
* Developed By: APAP
* Date:  22/12/2020
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT I_F.ST.L.APAP.PRELACION.COVI19.DET
    $INSERT I_F.ACCOUNT
    $INSERT I_F.VERSION
    $INSERT I_F.USER
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
    FN.L.APAP.PRELACION.COVI19.DET = 'F.ST.L.APAP.PRELACION.COVI19.DET'
    FV.L.APAP.PRELACION.COVI19.DET = ''
    CALL OPF (FN.L.APAP.PRELACION.COVI19.DET,FV.L.APAP.PRELACION.COVI19.DET)

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
    Y.MONTO.COVID19 = R.PRELACIONIII<ST.L.A76.MONTO.COVI19>
    IF NOT (R.PRELACIONIII) THEN
        MENSAJE = 'ESTE CONTRATO NO TIENE  BALANCE DE PRELACION PENDIENTE'
        E = MENSAJE
        CALL ERR
        RETURN
    END
    IF Y.MONTO.COVID19 EQ 0 THEN
        MENSAJE = 'ESTE CONTRATO NO TIENE  BALANCE DE PRELACION PENDIENTE'
        E = MENSAJE
        CALL ERR
        RETURN
    END

    CALL L.APAP.MONTO.CUOTA.DIA(R.ACC<AC.ARRANGEMENT.ID>,Y.VALOR.CUOTA.PAY)

    IF Y.VALOR.CUOTA.PAY GT Y.MONTO.COVID19 THEN
        MENSAJE = 'ESTE CONTRATO NO TIENE  BALANCE DE PRELACION PENDIENTE, FUE RECIBIDO UN PAGO DE CUOTA, CON UN INTERES DE PRELACION DE: '
        MENSAJE :=" ":FMT(Y.VALOR.CUOTA.PAY,"R2,#15")
        E = MENSAJE
        CALL ERR
        RETURN
    END
    Y.MONTO.COVID19 -= Y.VALOR.CUOTA.PAY

    IF R.NEW(FT.CREDIT.AMOUNT) GT Y.MONTO.COVID19 THEN
        MENSAJE = 'NO PUEDE HACER UN ABONO DE PRELACION DE INTERES COVID19 MAYOR QUE EL BALANCE DE PRELACION PENDIENTE, MONTO PRELACION ES:'
        MENSAJE :=" ":FMT(Y.MONTO.COVID19,"R2,#15")
        E = MENSAJE
        CALL ERR
        RETURN
    END

RETURN

END
