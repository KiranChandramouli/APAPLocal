* @ValidationCode : MjoxNjc5OTUwNjQ1OkNwMTI1MjoxNjkwMTY3NTMyMzM0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:52
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
SUBROUTINE L.APAP.GET.TXN.COMMENT
    
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No changes
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.T24.FUND.SERVICES

    Y.TXN.ID = FIELD(O.DATA, "\", 1)
    O.DATA = ""

    FINDSTR "FT" IN Y.TXN.ID SETTING Ap, Vp THEN

*PARA ABRIR EL ACHIVO DE FUNDS.TRANSFER
        FN.FT = "F.FUNDS.TRANSFER"
        FV.FT = ""
        RS.FT = ""
        FT.ERR = ""

        CALL OPF(FN.FT, FV.FT)
        CALL F.READ(FN.FT, Y.TXN.ID, RS.FT, FV.FT, FT.ERR)
        O.DATA = RS.FT<FT.PAYMENT.DETAILS>

        IF FT.ERR NE "" THEN

            FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS'
            FV.FT.HIS = ""
            RS.FT.HIS = ""
            FT.ERR.HIS = ""

            CALL OPF(FN.FT.HIS, FV.FT.HIS)
            CALL EB.READ.HISTORY.REC(FV.FT.HIS, Y.TXN.ID, RS.FT.HIS, FT.ERR.HIS)

            O.DATA = RS.FT.HIS<FT.PAYMENT.DETAILS>

        END

    END

RETURN

END
