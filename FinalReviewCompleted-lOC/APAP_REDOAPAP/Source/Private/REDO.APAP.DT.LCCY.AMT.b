* @ValidationCode : MjotNDEwOTY3NTY6Q3AxMjUyOjE2ODEyOTM5NjY1NjU6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 15:36:06
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
$PACKAGE APAP.REDOAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.APAP.DT.LCCY.AMT(LOC.CCY.AMT)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.APAP.DT.LCCY.AMT
* ODR NUMBER    : ODR-2010-07-0074
*----------------------------------------------------------------------------------
*Description:  REDO.APAP.DT.LCCY.AMT is a deal slip routine for the DEAL.SLIP.FORMAT FX.DEAL.TICKET,
*             the routine reads the currencies from CURRENCY.BOUGHT and CURRENCY.SOLD
*             fetches the local currency and the respective AMOUNT.SOLD or AMOUNT.BOUGHT


* In parameter  : None
* out parameter : LOC.CCY.AMT
*----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX

    GOSUB PROCESS.PARA
RETURN

PROCESS.PARA:
    GOSUB GET.LOC.CCY.AMT
RETURN

GET.LOC.CCY.AMT:
*Get the Currency Details

    Y.CCY.SOLD = R.NEW(FX.CURRENCY.SOLD)
    Y.CCY.BUY = R.NEW(FX.CURRENCY.BOUGHT)
    IF Y.CCY.SOLD EQ LCCY THEN
        LOC.CCY.AMT  = R.NEW(FX.AMOUNT.SOLD)
        COMI = LOC.CCY.AMT
        CALL IN2AMT('19','AMT')
        LOC.CCY.AMT = V$DISPLAY
    END
    IF Y.CCY.BUY EQ LCCY THEN
        LOC.CCY.AMT = R.NEW(FX.AMOUNT.BOUGHT)
        COMI = LOC.CCY.AMT
        CALL IN2AMT('19','AMT')
        LOC.CCY.AMT = V$DISPLAY
    END
RETURN

END
