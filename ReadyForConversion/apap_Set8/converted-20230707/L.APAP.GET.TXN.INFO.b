SUBROUTINE L.APAP.GET.TXN.INFO
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.T24.FUND.SERVICES

    Y.RESULT = "NO"

*-- VARIALES PARA EJECUTAR SELECT
    SEL.FN = "FBNK.TELLER"
    SEL.LIST = ""
    NO.REC = ""
    SEL.ERR = ""
    SEL.CMD = "SELECT ": SEL.FN :" WITH @ID EQ " : COMI : " AND OVERRIDE LIKE 'L.APAP.SEND.RECEIPT.EMAIL}DESEA RECIBIR EL RECIBO POR CORREO ELECTRONICO? YES'... "

    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.REC, SEL.ERR)

    IF NO.REC GT 0 THEN

        Y.RESULT = "SI"

    END ELSE

*-- PARA ABRIR EL ACHIVO CUSTOMER
        FN.TT = "F.TELLER"
        FV.TT = ""
        RS.TT = ""
        ERR.TT = ""

        CALL OPF(FN.TT, FV.TT)
        CALL F.READ(FN.TT, COMI, RS.TT, FV.TT, ERR.TT)

        Y.THEIR.REFERENCE = RS.TT<TT.TE.THEIR.REFERENCE>

        FINDSTR "T24FS" IN Y.THEIR.REFERENCE SETTING F.P, V.P THEN

*-- VARIALES PARA EJECUTAR SELECT
            SEL.FN = "FBNK.T24.FUND.SERVICES"
            SEL.LIST = ""
            NO.REC = ""
            SEL.ERR = ""
            SEL.CMD = "SELECT ": SEL.FN :" WITH @ID EQ " : Y.THEIR.REFERENCE : " AND OVERRIDE LIKE 'L.APAP.SEND.RECEIPT.EMAIL}DESEA RECIBIR EL RECIBO POR CORREO ELECTRONICO? YES'... "

            CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.REC, SEL.ERR)

            IF NO.REC GT 0 THEN

                Y.RESULT = "SI"

            END

        END

    END

    COMI = Y.RESULT

RETURN
END
