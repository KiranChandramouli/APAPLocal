* @ValidationCode : MjotMTA2MjA1NDcwMzpDcDEyNTI6MTY4MjA2NTQ5MzIwMDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 13:54:53
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
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE AT.ISO.CHG.AMT(IN.ARG,OUT.ARG)
*Developed by s.anitha
*accept the amount from field 28 and format it to send only the ccy and the amount

*     $INCLUDE T24.BP I_COMMON        ;*/ TUS START
*     $INCLUDE T24.BP I_EQUATE
*     $INCLUDE T24.BP I_F.NUMERIC.CURRENCY
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.NUMERIC.CURRENCY        ;*/  TUS END

    GOSUB PROCESS

RETURN
*-------------------------------------------------
PROCESS:
*---------
    FN.NUMERIC.CURRENCY='F.NUMERIC.CURRENCY'
    F.NUMERIC.CURRENCY=''
    CALL OPF(FN.NUMERIC.CURRENCY,F.NUMERIC.CURRENCY)
    CCY.CDE=FIELD(IN.ARG,'%',1)
    CHG.AMT=FIELD(IN.ARG,'%',2)


    CALL F.READ(FN.NUMERIC.CURRENCY,CCY.CDE,R.NUMERIC.CURRENCY,F.NUMERIC.CURRENCY,E.NUMERIC.CURRENCY)

    ACTUAL.CCY=R.NUMERIC.CURRENCY<EB.NCN.CURRENCY.CODE>

    CHG.AMT=CHG.AMT/100


    IF CHG.AMT NE '0' THEN
        OUT.ARG=ACTUAL.CCY:CHG.AMT
    END
RETURN
*----------------------------------------
END
