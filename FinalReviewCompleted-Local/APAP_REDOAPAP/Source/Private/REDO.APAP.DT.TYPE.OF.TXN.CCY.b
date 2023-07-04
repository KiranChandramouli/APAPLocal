* @ValidationCode : Mjo5MDMxMDU3MjU6Q3AxMjUyOjE2ODEyOTU2MTk0OTU6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 16:03:39
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
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   F.READ to CACHE.READ
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------


SUBROUTINE REDO.APAP.DT.TYPE.OF.TXN.CCY(COUNTRY.CODE)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.APAP.DT.TYPE.OF.TXN.CCY
* ODR NUMBER    : ODR-2010-07-0074
*----------------------------------------------------------------------------------
*Description:  REDO.APAP.DT.TYPE.OF.TXN.CCY is a deal slip routine for the DEAL.SLIP.FORMAT FX.DEAL.TICKET,
*              the routine reads the currencies from CURRENCY.BOUGHT and CURRENCY.SOLD
*              fetches the foreign currency and gets the COUNTRY.CODE
*

* In parameter  : None
* out parameter : COUNTRY.CODE
*----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
    $INSERT I_F.CURRENCY

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN

OPEN.PARA:
    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

RETURN

PROCESS.PARA:
    GOSUB GET.FCY.CCY
    IF CURRENCY.ID THEN
        GOSUB GET.COUNTRY.CODE
    END
RETURN

GET.FCY.CCY:
*Get the Currency Details

    Y.CCY.SOLD = R.NEW(FX.CURRENCY.SOLD)
    Y.CCY.BUY = R.NEW(FX.CURRENCY.BOUGHT)
    IF Y.CCY.SOLD NE LCCY THEN
        CURRENCY.ID  = Y.CCY.SOLD
    END
    IF Y.CCY.BUY NE LCCY THEN
        CURRENCY.ID = Y.CCY.BUY
    END
RETURN


GET.COUNTRY.CODE:
    CALL CACHE.READ(FN.CURRENCY, CURRENCY.ID, R.CURRENCY, ERR.CURR) ;*R22 AUTO CODE CONVERSION
    COUNTRY.CODE = R.CURRENCY<EB.CUR.COUNTRY.CODE>
RETURN
END
