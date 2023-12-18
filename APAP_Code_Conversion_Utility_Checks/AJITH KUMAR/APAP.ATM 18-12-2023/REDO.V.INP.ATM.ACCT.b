* @ValidationCode : MjoxNTAxOTE1NTIwOkNwMTI1MjoxNzAyNDY1ODAwMTU3OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Dec 2023 16:40:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.ATM

SUBROUTINE REDO.V.INP.ATM.ACCT

*---------------------------------------------------------------------------------------
* DESCRIPTION: Attached as Input routine, for TELLER application related to ATM versions
*
*---------------------------------------------------------------------------------------
*
* COMPANY NAME : APAP
* DEVELOPED BY : S
* PROGRAM NAME : REDO.V.INP.ATM.ACCT
*----------------------------------------------------------------------------------------------
* Modification History:
*------------------------
* DATE               WHO              REFERENCE                    DESCRIPTION
* ******************************INITIAL DRAFT UNKNOWN****************************
* 18-04-2013   Vignesh Kumaar M R    PACS00265602         TELLER DENOM NOT UPDATING DURING THE REVERSAL
*-----------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*11-04-2023       Conversion Tool        R22 Auto Code conversion         F.READ TO CACHE.READ
*11-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY ;*
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.PARAMETER
    $INSERT I_F.TELLER.TRANSACTION

***********
INITIALISE:
***********
*
    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION = ''
    CALL OPF(FN.TELLER.TRANSACTION, F.TELLER.TRANSACTION)

*FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
*F.TELLER.PARAMETER = ''
*CALL OPF(FN.TELLER.PARAMETER, F.TELLER.PARAMETER)

    R.TT.TR   = ''
    TT.TR.ID  = ''
    TT.TR.ERR = ''

    R.TT.TP   = ''
    TT.TR.ID  = ''
    TT.TR.ERR = ''
    SET.FLAG = ''

********
PROCESS:
********
*

    WCAJERO = R.NEW(TT.TE.ACCOUNT.1)[9,4]
    IF WCAJERO EQ R.NEW(TT.TE.TELLER.ID.1) THEN
        R.NEW(TT.TE.ACCOUNT.1) = R.NEW.LAST(TT.TE.ACCOUNT.1)
        SET.FLAG = R.NEW(TT.TE.ACCOUNT.1)
    END
*
    WCAJERO = R.NEW(TT.TE.ACCOUNT.2)[9,4]
    IF WCAJERO EQ R.NEW(TT.TE.TELLER.ID.2) THEN
        R.NEW(TT.TE.ACCOUNT.2) = R.NEW.LAST(TT.TE.ACCOUNT.2)
        SET.FLAG = R.NEW(TT.TE.ACCOUNT.2)
    END
*

* Fix for PACS00265602 [TELLER DENOM NOT UPDATING DURING THE REVERSAL]

    IF SET.FLAG EQ '' AND V$FUNCTION EQ 'I' THEN

        GET.CURRENCY = R.NEW(TT.TE.CURRENCY.1)
        TT.TR.ID = R.NEW(TT.TE.TRANSACTION.CODE)
        CALL CACHE.READ(FN.TELLER.TRANSACTION, TT.TR.ID, R.TT.TR, ERR.TT.TR)   ;*R22 AUTO CODE CONVERSION
        GET.DIVISION.CODE = R.COMPANY(EB.COM.SUB.DIVISION.CODE)

        BEGIN CASE
            CASE PGM.VERSION EQ ',REDO.ATM.TILLTFR'
                GET.TELLER.ID = R.NEW(TT.TE.TELLER.ID.2)
                GET.CATEGORY = R.TT.TR<TT.TR.CAT.DEPT.CODE.2>
                R.NEW(TT.TE.ACCOUNT.2) = GET.CURRENCY:GET.CATEGORY:GET.TELLER.ID:GET.DIVISION.CODE

            CASE PGM.VERSION EQ ',REDO.ATM.SALID.TILLTFR'
                GET.TELLER.ID = R.NEW(TT.TE.TELLER.ID.1)
                GET.CATEGORY = R.TT.TR<TT.TR.CAT.DEPT.CODE.1>
                R.NEW(TT.TE.ACCOUNT.1) = GET.CURRENCY:GET.CATEGORY:GET.TELLER.ID:GET.DIVISION.CODE

            CASE PGM.VERSION EQ ',REDO.ATM.FALT.TILLTFR'
                Y.GET.ACCT2 = R.NEW(TT.TE.ACCOUNT.2)
                GET.TELLER.ID = Y.GET.ACCT2[9,4]
*            GET.TELLER.ID = R.NEW(TT.TE.TELLER.ID.1)
                GET.CATEGORY = R.TT.TR<TT.TR.CAT.DEPT.CODE.1>
                R.NEW(TT.TE.ACCOUNT.1) = GET.CURRENCY:GET.CATEGORY:GET.TELLER.ID:GET.DIVISION.CODE

            CASE PGM.VERSION EQ ',REDO.ATM.SOBRA.TILLTFR'
                Y.GET.ACCT2 = R.NEW(TT.TE.ACCOUNT.2)
                GET.TELLER.ID = Y.GET.ACCT2[9,4]
*            GET.TELLER.ID = R.NEW(TT.TE.TELLER.ID.1)
                GET.CATEGORY = R.TT.TR<TT.TR.CAT.DEPT.CODE.1>
                R.NEW(TT.TE.ACCOUNT.1) = GET.CURRENCY:GET.CATEGORY:GET.TELLER.ID:GET.DIVISION.CODE

        END CASE
    END

* End of Fix

RETURN

END
