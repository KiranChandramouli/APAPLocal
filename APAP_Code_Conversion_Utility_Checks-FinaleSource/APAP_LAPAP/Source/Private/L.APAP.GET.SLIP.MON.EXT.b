* @ValidationCode : MjotMTM3NDA2MDA4MzpDcDEyNTI6MTY4OTc0NDU2ODEzMjpJVFNTOi0xOi0xOjQ3MToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Jul 2023 10:59:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 471
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion             BP removed in INSERT file, INCLUDE TO INSERT
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*----------------------------------------------------------------------------------------
SUBROUTINE L.APAP.GET.SLIP.MON.EXT(Y.INP.DEAL)
    $INSERT I_COMMON                       ;*R22 Auto Conversion  - Start
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.L.APAP.GENERACION.CARGO     ;*R22 Auto Conversion - End

    GOSUB PROCESS
RETURN

PROCESS:
    GOSUB OPEN.TABLE:
    GET.TXN.ID = System.getVariable("CURRENT.WTM.FIRST.ID")

    IF GET.TXN.ID EQ 'CURRENT.WTM.FIRST.ID' THEN
        GET.TXN.ID = ID.NEW:'-NV.INFO'
    END ELSE
        GET.TXN.ID = GET.TXN.ID:'-NV.INFO'
    END

    READ R.REDO.CASHIER.DEALSLIP.INFO FROM F.REDO.CASHIER.DEALSLIP.INFO, GET.TXN.ID THEN
        IF R.REDO.CASHIER.DEALSLIP.INFO NE '' OR R.REDO.CASHIER.DEALSLIP.INFO NE 0 THEN
            R.DEAL.ARRAY = R.REDO.CASHIER.DEALSLIP.INFO
        END
    END

    LOCATE ID.NEW IN R.DEAL.ARRAY<1,1> SETTING POS1 THEN
        GOSUB GET.VALUES
    END

RETURN
OPEN.TABLE:
    FN.REDO.CASHIER.DEALSLIP.INFO = 'F.REDO.CASHIER.DEALSLIP.INFO'
    F.REDO.CASHIER.DEALSLIP.INFO = ''
    CALL OPF(FN.REDO.CASHIER.DEALSLIP.INFO,F.REDO.CASHIER.DEALSLIP.INFO)
    FN.ST.L.APAP.GENERACION.CARGO = "F.ST.L.APAP.GENERACION.CARGO"
    FV.ST.L.APAP.GENERACION.CARGO = ""
    CALL OPF (FN.ST.L.APAP.GENERACION.CARGO,FV.ST.L.APAP.GENERACION.CARGO)
    FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER";
    FV.FUNDS.TRANSFER = ""
    CALL OPF (FN.FUNDS.TRANSFER,FV.FUNDS.TRANSFER)

RETURN

GET.MONTO:
    Y.MONTO.CARGO = 0
*CALL F.READ(FN.ST.L.APAP.GENERACION.CARGO,Y.ACCOUNT.ID,R.L.APAP.GENERACION,FV.ST.L.APAP.GENERACION.CARGO,ERROR.GENERACION.CARGO)
*IF (R.L.APAP.GENERACION) THEN
*    Y.MONTO.CARGO = R.L.APAP.GENERACION<ST.L.A46.L.APAP.MONTO>
*END

    CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.ID,R.FUNDS.TRANSFER,FV.FUNDS.TRANSFER,ERROR.FUNDS.TRANSFER)
    IF (R.FUNDS.TRANSFER) THEN
        Y.CHAR.AMOUNT.POS = '';
        CALL GET.LOC.REF("FUNDS.TRANSFER","L.MON.CARG",Y.CHAR.AMOUNT.POS)
        Y.MONTO.CARGO = R.FUNDS.TRANSFER<FT.LOCAL.REF,Y.CHAR.AMOUNT.POS>
    END
    Y.INP.DEAL = FMT(Y.MONTO.CARGO,"18R,2")

RETURN

GET.VALUES:
    Y.ACCOUNT.ID = R.DEAL.ARRAY<2,POS1>
    Y.FT.ID = R.DEAL.ARRAY<1,POS1>
    GOSUB GET.MONTO
RETURN

END
