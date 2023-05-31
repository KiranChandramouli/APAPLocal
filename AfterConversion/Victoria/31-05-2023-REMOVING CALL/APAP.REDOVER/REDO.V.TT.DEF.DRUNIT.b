* @ValidationCode : MjotNjU5NTMwOTU0OkNwMTI1MjoxNjgyNDEyMzU1MTcxOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.TT.DEF.DRUNIT
*--------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*13-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*13-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*--------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.TELLER

    GOSUB INIT
    GOSUB PROCESS

RETURN

*****
INIT:
*****

RETURN

********
PROCESS:
********
*

    IF R.NEW(TT.TE.CURRENCY.1) EQ R.NEW(TT.TE.CURRENCY.2) THEN

        BEGIN CASE
            CASE R.NEW(TT.TE.DR.CR.MARKER) EQ 'DEBIT'
                R.NEW(TT.TE.DR.UNIT) = R.NEW(TT.TE.UNIT)

            CASE R.NEW(TT.TE.DR.CR.MARKER) EQ 'CREDIT'
                R.NEW(TT.TE.UNIT) = R.NEW(TT.TE.DR.UNIT)
        END CASE

    END

RETURN

END
