* @ValidationCode : MjotMTY5MzYzMDI2MjpDcDEyNTI6MTY4MjMzNTk0NDkyMDpJVFNTOi0xOi0xOjM4NToxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 385
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                = TO EQ , INCLUDE TO INSERT
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.CUENTA.CLIENTE.RT
*-----------------------------------------------------------------------------
* Proposito: Identifica si la cuenta corresponde a una cuenta de cliente o interna.
* Parametro de entrada: TT o FT de la transaccion
* Parametro de salida: Indicador S = si una cuenta de cliente. N = si es una cuenta interna.

    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER ;* AUTO R22 CODE CONVERSION END

    Y.RETURN = 'S'
    ERR.TT = ''; ERR.FT = ''; Y.ACCT.1 = ''; Y.ACCT.2 = ''; Y.CONSULTED = 0
    Y.NUM.TXN = COMI

    IF SUBSTRINGS(Y.NUM.TXN, 1, 2) EQ 'TT' THEN
        GOSUB TT.PROCESS
    END ELSE
        GOSUB FT.PROCESS
    END

    IF Y.CONSULTED EQ 1 THEN ;* AUTO R22 CODE CONVERSION = TO EQ
        IF SUBSTRINGS(Y.ACCT.1, 1, 1) NE '1' AND SUBSTRINGS(Y.ACCT.2, 1, 1) NE '1' THEN
            Y.RETURN = 'N'
        END
    END

    COMI = Y.RETURN

RETURN

*---------------
TT.PROCESS:
*---------------
    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER, F.TELLER)
    CALL F.READ(FN.TELLER, Y.NUM.TXN, R.TELLER, F.TELLER, ERR.TT)

    IF NOT(ERR.TT) THEN
        Y.ACCT.1 = R.TELLER<TT.TE.ACCOUNT.1>
        Y.ACCT.2 = R.TELLER<TT.TE.ACCOUNT.2>
        Y.CONSULTED = 1
    END

RETURN

*---------------
FT.PROCESS:
*---------------
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)
    CALL F.READ(FN.FUNDS.TRANSFER, Y.NUM.TXN, R.FUNDS.TRANSFER, F.FUNDS.TRANSFER, ERR.FT)

    IF NOT(ERR.FT) THEN
        Y.ACCT.1 = R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>
        Y.ACCT.2 = R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>
        Y.CONSULTED = 1
    END

RETURN

END
