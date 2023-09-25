* @ValidationCode : MjotMTM2NTg5MTUwMTpDcDEyNTI6MTY5MDE2NzUzNzg3MDpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.VAL.PRIN.COVID19
*-----------------------------------------------------------------------------
* Bank name: APAP
* Decription: Rutina atachada a las versiones abono de capital extraudinario en efectivo y cheque
* la cual no permite realizar el pago si el cliente tiene balance de prelación pendiente en la tabla
* tabla FBNK.ST.L.APAP.COVI.PRELACIONIII
* Developed By: APAP
* Date:  22/12/2020
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed, -- to -=
* 13-07-2023     Harishvikram C   Manual R22 conversion       CALL routine format modified
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT I_F.ACCOUNT
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
*    CALL L.APAP.MONTO.CUOTA.DIA(R.ACC<AC.ARRANGEMENT.ID>,Y.VALOR.CUOTA.PAY)
    APAP.LAPAP.lApapMontoCuotaDia(R.ACC<AC.ARRANGEMENT.ID>,Y.VALOR.CUOTA.PAY)         ;*Manual R22 conversion
    IF Y.VALOR.CUOTA.PAY LE Y.MONTO.COVID19 THEN
        Y.MONTO.COVID19 -= Y.VALOR.CUOTA.PAY
        IF Y.MONTO.COVID19 GT 0 THEN
            MENSAJE = 'TIENE BALANCE DE PRELACION COVID19 PENDIENTE FAVOR HACER EL ABONO POR LA VERSION DE INTERES COVID19 (CHEQUE O EFECTIVO), MONTO PRELACION ES:'
            MENSAJE :=" ":FMT(Y.MONTO.COVID19,"R2,#15")
            E = MENSAJE
            CALL ERR

        END
    END

RETURN

END
