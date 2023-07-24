* @ValidationCode : MjoyOTEzNzMwNjE6Q3AxMjUyOjE2OTAxNjc1MzgzMDQ6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:58
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
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.VALI.PAY.COVID.LOAD
*-----------------------------------------------------------------------------
* Bank name: APAP
* Decription: Rutina LOAD Validar los pagos realizdos a los cotratos COVID19 con el monto de prelacion
* Logica: Lee todos los pagos realizados en el dia de las tablas (FBNK.AA.ARRANGEMENT.ACTIVITY,FBNK.FUNDS.TRASNFER)
* y va contra la tabla F.ST.L.APAP.COVI.PRELACIONIII
* y verifica si contrato se encuentra en esa tabla y tiene monto pendiente y le recta el valor que tenga
* monto pagado FT
* Developed By: APAP
* Date:  10122020
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No Changes
* 13-07-2023     Harishvikram C   Manual R22 conversion       BP Removed
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.AA.PAYMENT.SCHEDULE
    $INSERT  I_F.ST.L.APAP.PRELACION.COVI19.DET
    $INSERT  I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT  I_L.APAP.VALI.PAY.COVID.COMMON

    GOSUB TABLAS

RETURN

TABLAS:
    FN.L.APAP.COVI.PRELACIONIII = 'F.ST.L.APAP.COVI.PRELACIONIII'
    FV.L.APAP.COVI.PRELACIONIII = ''
    CALL OPF (FN.L.APAP.COVI.PRELACIONIII,FV.L.APAP.COVI.PRELACIONIII)

    FN.FT = 'F.FUNDS.TRANSFER'
    FV.FT = ''
    CALL OPF (FN.FT,FV.FT)

    FN.AAA = 'F.AA.ARRANGEMENT.ACTIVITY'
    FV.AAA = ''
    CALL OPF (FN.AAA,FV.AAA)

    FN.L.APAP.PRELACION.COVI19.DET = 'F.ST.L.APAP.PRELACION.COVI19.DET'
    FV.L.APAP.PRELACION.COVI19.DET = ''
    CALL OPF (FN.L.APAP.PRELACION.COVI19.DET,FV.L.APAP.PRELACION.COVI19.DET)
    Y.ACTIVIDADES = ''
    Y.ACTIVIDADES = ' LENDING-APPLYPAYMENT-RP.COM.SG.ADV':" ":'LENDING-APPLYPAYMENT-RP.COM.SG.ADV.CHQ'
    Y.ACTIVIDADES:= " ":'LENDING-APPLYPAYMENT-RP.CAP.INT.PYT':" ":'LENDING-APPLYPAYMENT-RP.DIR.DEBIT'
    Y.ACTIVIDADES:= " ":'LENDING-APPLYPAYMENT-RP.COM.SG.ADV.OL':" ":'LENDING-APPLYPAYMENT-RP.COM.SG.ADV.BL'
    Y.ACTIVIDADES:= " ":'LENDING-APPLYPAYMENT-RP.PAYMENT':" ":'LENDING-APPLYPAYMENT-RP.PAYOFF.CHQ'
    Y.ACTIVIDADES:= " ":'LENDING-APPLYPAYMENT-RP.PAYOFF':" ":'LENDING-SETTLE-RP.PAGO.ANTICIPADO'
RETURN

END


