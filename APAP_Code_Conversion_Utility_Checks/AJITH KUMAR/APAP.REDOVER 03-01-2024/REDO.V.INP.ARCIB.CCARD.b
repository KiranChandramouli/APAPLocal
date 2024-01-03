* @ValidationCode : MjoxMTM2NTEwNzk2OkNwMTI1MjoxNjgyNDEyMzQ3NTc3OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:47
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
SUBROUTINE  REDO.V.INP.ARCIB.CCARD
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* THIS IS AN INPUT ROUTINE TO DEFAULT THE ACCOUNT NUMBER BASED ON CREDIT CURRENCY

* INPUT/OUTPUT:
*--------------

* OUT : N/A

* DEPENDDENCIES:
*-------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*11-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*11-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AI.REDO.ARCIB.PARAMETER
$INSERT I_F.ACCOUNT
$INSERT I_GTS.COMMON
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.STANDING.ORDER
GOSUB INITIALSE
RETURN
*----------------------------------------------------------------------
*~~~~~~~~~
INITIALSE:
*~~~~~~~~~

FN.AI.REDO.ARCIB.PARAMETER = 'F.AI.REDO.ARCIB.PARAMETER'
IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
GOSUB FT.PROCESS
END
IF APPLICATION EQ 'STANDING.ORDER' THEN
GOSUB STO.PROCESS
END
RETURN
*----------------------------------------------------------------------
*~~~~~~~~~~~~~~~
FT.PROCESS:
*~~~~~~~~~~~~~~~

*CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,'SYSTEM',R.AI.REDO.ARCIB.PARAMETER,ERR.MPAR)
IDVAR.1 = 'SYSTEM' ;* R22 AUTO CONVERSION
CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,IDVAR.1,R.AI.REDO.ARCIB.PARAMETER,ERR.MPAR);* R22 AUTO CONVERSION
VAR.CURRENCY = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.CCARD.CUR>
VAR.INT.ACCT = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.CCARD.INT.ACCT>
Y.CURRENCY = R.NEW(FT.CREDIT.CURRENCY)
LOCATE Y.CURRENCY IN VAR.CURRENCY<1,1> SETTING POS.CUR THEN
VAR.INT.ACCT = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.CCARD.INT.ACCT,POS.CUR>
R.NEW(FT.CREDIT.ACCT.NO) = VAR.INT.ACCT
END
RETURN
*----------------------------------------------------------------------
*------------
STO.PROCESS:
*------------
*CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,'SYSTEM',R.AI.REDO.ARCIB.PARAMETER,ERR.MPAR)
IDVAR.1 = 'SYSTEM' ;* R22 AUTO CONVERSION
CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,IDVAR.1,R.AI.REDO.ARCIB.PARAMETER,ERR.MPAR);* R22 AUTO CONVERSION
VAR.CURRENCY = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.CCARD.CUR>
VAR.INT.ACCT = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.CCARD.INT.ACCT>
Y.CURRENCY   = R.NEW(STO.CURRENCY)
LOCATE Y.CURRENCY IN VAR.CURRENCY<1,1> SETTING POS.CUR THEN
VAR.INT.ACCT = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.CCARD.INT.ACCT,POS.CUR>
R.NEW(STO.CPTY.ACCT.NO) = VAR.INT.ACCT
END
RETURN
END
