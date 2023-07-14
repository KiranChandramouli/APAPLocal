* @ValidationCode : MjoxMzc4MjM3NzY2OkNwMTI1MjoxNjg5MjQ0MjYwNTY4OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 16:01:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.TXN.INFO
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON                     ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.T24.FUND.SERVICES        ;*R22 Auto conversion - End

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
