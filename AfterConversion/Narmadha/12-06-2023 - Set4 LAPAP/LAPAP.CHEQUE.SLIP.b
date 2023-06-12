* @ValidationCode : MjotODQ5NDA3ODU4OlVURi04OjE2ODY1NzM5ODcxMDY6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Jun 2023 18:16:27
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

SUBROUTINE LAPAP.CHEQUE.SLIP(Y.INP.DEAL)
    
*-----------------------------------------------------------------------------
* MODIFICATION HISTORY:

* DATE               WHO                  REFERENCE                 DESCRIPTION

* 12-JUNE-2023    Conversion tool     R22 Auto conversion          INCLUDE to INSERT, BP is removed in Insert File
* 12-JUNE-2023    Narmadha V         MANUAL R22 CODE CONVERSION     No Changes

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY
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
RETURN
GET.VALUES:
    Y.TOTAL.PAGADO = R.DEAL.ARRAY<17,POS1>
    Y.INP.DEAL = FMT(Y.TOTAL.PAGADO,"18R,2")
RETURN

END
