* @ValidationCode : MjotMjExODA0NjUzOkNwMTI1MjoxNjkxNzQ2OTk1MTE3OklUU1M6LTE6LTE6LTE0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Aug 2023 15:13:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -14
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.IVR.INP.CCARD
**
* Subroutine Type : VERSION
* Attached to     : FUNDS.TRANSFER,REDO.IVR.PAGTC,
*                   FUNDS.TRANSFER,REDO.IVR.PAGTCBEN
* Attached as     : Field CREDIT.CURRENCY as VALIDATION.RTN
* Primary Purpose : Assign the internel account depending of currency used.
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 07/02/13 - First Version
*            ODR Reference: ODR-2011-02-0099
*            Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP)
*            Roberto Mondragon - TAM Latin America
*            rmondragon@temenos.com
*DATE          WHO                 REFERENCE               DESCRIPTION
*10-08-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_GTS.COMMON
    $INSERT I_F.FUNDS.TRANSFER

    $INSERT I_F.REDO.IVR.PARAMS.ALLOPER

    GOSUB INITIALSE
    GOSUB PROCESS

RETURN

*---------
INITIALSE:
*---------

    FN.REDO.IVR.PARAMS.ALLOPER = 'F.REDO.IVR.PARAMS.ALLOPER'

RETURN

*-------
PROCESS:
*-------

    Y.CURRENCY = COMI

    CALL CACHE.READ(FN.REDO.IVR.PARAMS.ALLOPER,'SYSTEM',R.REDO.IVR.PARAMS.ALLOPER,ERR.MPAR)
    VAR.CURRENCY = R.REDO.IVR.PARAMS.ALLOPER<IVR.AO.CCARD.CUR>
    VAR.INT.ACCT = R.REDO.IVR.PARAMS.ALLOPER<IVR.AO.CCARD.INT.ACCT>

    LOCATE Y.CURRENCY IN VAR.CURRENCY<1,1> SETTING POS.CUR THEN
        VAR.INT.ACCT = R.REDO.IVR.PARAMS.ALLOPER<IVR.AO.CCARD.INT.ACCT,POS.CUR>
        R.NEW(FT.CREDIT.ACCT.NO) = VAR.INT.ACCT
    END

RETURN

END
