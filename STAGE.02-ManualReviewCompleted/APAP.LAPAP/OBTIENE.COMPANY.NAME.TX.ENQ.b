* @ValidationCode : MjoxOTYxOTU2NzU3OkNwMTI1MjoxNjgyMzE2MzYyODcxOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 11:36:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE OBTIENE.COMPANY.NAME.TX.ENQ
*------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED,F.READ TO CACHE.READ
*24-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON    ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COMPANY
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER    ;*R22 AUTO CODE CONVERSION.END

*DEBUG

    Y.COMPANY.NAME = ""
    Y.COMPANY.ID = ""

    Y.TX.ID = O.DATA
    Y.TX.ID = TRIM(Y.TX.ID)
    Y.TX.ID.HIS = Y.TX.ID : ";1"

    IF Y.TX.ID NE "" THEN

        Y.TIPO.TX = Y.TX.ID[1,2]

        IF Y.TIPO.TX EQ "FT" THEN
            FN.FT = "F.FUNDS.TRANSFER$HIS"
            FV.FT = ""
            CALL OPF(FN.FT, FV.FT)

            R.FT = ""; FT.ERROR = ""
            CALL F.READ(FN.FT, Y.TX.ID.HIS, R.FT, FV.FT, FT.ERROR)
            Y.COMPANY.ID = R.FT<FT.CO.CODE>

            IF Y.COMPANY.ID EQ "" THEN
                FN.FT = "F.FUNDS.TRANSFER"
                FV.FT = ""
                CALL OPF(FN.FT, FV.FT)

                R.FT = ""; FT.ERROR = ""
                CALL F.READ(FN.FT, Y.TX.ID, R.FT, FV.FT, FT.ERROR)
                Y.COMPANY.ID = R.FT<FT.CO.CODE>
            END
        END

        IF Y.TIPO.TX EQ "TT" THEN
            FN.TT = "F.TELLER$HIS"
            FV.TT = ""
            CALL OPF(FN.TT, FV.TT)

            R.TT = ""; TT.ERROR = ""
            CALL F.READ(FN.TT, Y.TX.ID.HIS, R.TT, FV.TT, TT.ERROR)
            Y.COMPANY.ID = R.TT<TT.TE.CO.CODE>

            IF Y.COMPANY.ID EQ "" THEN
                FN.TT = "F.TELLER"
                FV.TT = ""
                CALL OPF(FN.TT, FV.TT)

                R.TT = ""; TT.ERROR = ""
                CALL F.READ(FN.TT, Y.TX.ID, R.TT, FV.TT, TT.ERROR)
                Y.COMPANY.ID = R.TT<TT.TE.CO.CODE>
            END
        END


        IF Y.COMPANY.ID NE "" THEN
            IF Y.COMPANY.ID EQ "DO0010001" THEN
                Y.COMPANY.NAME = "OFICINA PRINCIPAL"
            END
            ELSE
                FN.CMP = "F.COMPANY"
                FV.CMP = ""
                CALL OPF(FN.CMP,FV.CMP)

                R.CMP = ""; CMP.ERROR = ""
                CALL CACHE.READ(FN.CMP, Y.COMPANY.ID, R.CMP, CMP.ERROR)    ;*R22 AUTO CODE CONVERSION
                Y.COMPANY.NAME = R.CMP<EB.COM.COMPANY.NAME>
            END
        END

    END
*DEBUG
    O.DATA = Y.COMPANY.ID : "*" : Y.COMPANY.NAME
RETURN
END
