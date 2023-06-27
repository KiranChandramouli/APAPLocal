$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION

*26-06-2023       S.AJITHKUMAR               R22 Manual Code Conversion       T24.BP IS REMOVED,Command this Insert file I_F.T24.FUND.SERVICES
SUBROUTINE L.APAP.GET.TXN.COMMENT
    $INSERT  I_COMMON ;*R22 manual code conversion
    $INSERT  I_EQUATE
    $INSERT I_ENQUIRY.COMMON ;*R22 manual code conversion
    $INSERT  I_F.TELLER
    $INSERT  I_F.FUNDS.TRANSFER
*$INSERT  I_F.T24.FUND.SERVICES;*R22 manual code conversion
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
