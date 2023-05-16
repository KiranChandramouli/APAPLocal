* @ValidationCode : MjotMTQzOTU0MDg3NDpDcDEyNTI6MTY4MjQzMDA0MjQ1OTpJVFNTOi0xOi0xOjg3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 19:10:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 87
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.V.ATM.NON.ACCT.DEF

* Description: The validation routine to update the credit account for ATM money transfer
* Dev by : V.P.Ashokkumar
*
*----------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
*DATE           WHO                 REFERENCE               DESCRIPTION
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED, F.READ TO CACHE.READ
*21-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-------------------------------------------------------------------------
******************************************************************************
    $INSERT I_COMMON ;*R22 AUTO CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.COMPANY
    $INSERT I_F.TELLER.TRANSACTION ;*R22 AUTO CONVERSION END

    IF V$FUNCTION EQ 'I' THEN
        GOSUB INIT
        GOSUB PROCESS
    END
RETURN

INIT:
*****
    R.TT.TR = ''; ERR.TT.TR = ''; TT.TR.ID = ''; GET.CURRENCY = ''; GET.TELLER.ID = ''
    GET.DIVISION.CODE = ''; GET.CATEGORY = ''; Y.GET.ACCT2 = ''
    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION = ''
    CALL OPF(FN.TELLER.TRANSACTION, F.TELLER.TRANSACTION)
RETURN

PROCESS:
********
    GET.CURRENCY = R.NEW(TT.TE.CURRENCY.1)
    TT.TR.ID = R.NEW(TT.TE.TRANSACTION.CODE)
    CALL CACHE.READ(FN.TELLER.TRANSACTION, TT.TR.ID, R.TT.TR, ERR.TT.TR) ;*R22 AUTO CONVERSION
    GET.DIVISION.CODE = R.COMPANY(EB.COM.SUB.DIVISION.CODE)

    Y.GET.ACCT2 = R.NEW(TT.TE.ACCOUNT.2)
    IF NOT(Y.GET.ACCT2) AND AF EQ TT.TE.ACCOUNT.2 THEN
        Y.GET.ACCT2 = COMI
    END
    GET.TELLER.ID = Y.GET.ACCT2[9,4]
    GET.CATEGORY = R.TT.TR<TT.TR.CAT.DEPT.CODE.1>
    R.NEW(TT.TE.ACCOUNT.1) = GET.CURRENCY:GET.CATEGORY:GET.TELLER.ID:GET.DIVISION.CODE
RETURN

END
