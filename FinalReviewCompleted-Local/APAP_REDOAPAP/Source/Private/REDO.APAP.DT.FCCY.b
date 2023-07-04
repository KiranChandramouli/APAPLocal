* @ValidationCode : MjoxMjg4MzAwMjI2OkNwMTI1MjoxNjgwNjcyNjM2ODUyOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 11:00:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.DT.FCCY(FRN.CCY)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.APAP.DT.FCCY
* ODR NUMBER    : ODR-2010-07-0074
*----------------------------------------------------------------------------------
*Description: REDO.APAP.DT.FCCY is a deal slip routine for the DEAL.SLIP.FORMAT FX.DEAL.TICKET,
*             the routine reads the currencies from CURRENCY.BOUGHT and CURRENCY.SOLD fetches
*             the foreign currency

* In parameter  : None
* out parameter : FRN.CCY
*Modification
* Date                  who                   Reference              
* 05-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX

    GOSUB PROCESS.PARA
RETURN

PROCESS.PARA:
    GOSUB GET.FCY.CCY
RETURN

GET.FCY.CCY:
*Get the Currency Details

    Y.CCY.SOLD = R.NEW(FX.CURRENCY.SOLD)
    Y.CCY.BUY = R.NEW(FX.CURRENCY.BOUGHT)
    IF Y.CCY.SOLD NE LCCY THEN
        FRN.CCY  = Y.CCY.SOLD
    END
    IF Y.CCY.BUY NE LCCY THEN
        FRN.CCY = Y.CCY.BUY
    END
RETURN

END
