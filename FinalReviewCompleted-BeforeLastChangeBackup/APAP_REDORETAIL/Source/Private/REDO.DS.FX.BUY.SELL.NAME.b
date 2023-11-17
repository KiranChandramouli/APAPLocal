* @ValidationCode : MjotMTc0MjY4MzE2ODpDcDEyNTI6MTY4MTgyOTA5NTI2NTpJVFNTOi0xOi0xOi0xNzoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Apr 2023 20:14:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -17
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.FX.BUY.SELL.NAME(IN.OUT.PARA)
*------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This deal slip routine should be attached to the DEAL.SLIP.FORMAT, REDO.BUY.SELL.DSLIP
*------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : PRADEEP S
* PROGRAM NAME : REDO.DS.FX.BUY.SELL.NAME
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 27-Jun-2012      Pradeep S         PACS00204543                 Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX

    GOSUB INIT
    GOSUB PROCESS

RETURN

*****
INIT:
*****
* Initialisation of variables
*
    Y.ID = IN.OUT.PARA


********
PROCESS:
********
* Getthe description for source

    Y.CCY.BOUGHT = R.NEW(FX.CURRENCY.BOUGHT)
    Y.CCY.SOLD   = R.NEW(FX.CURRENCY.SOLD)

    IF Y.CCY.BOUGHT NE LCCY THEN
        IN.OUT.PARA = "Recibo de Compra de Divisas"
    END ELSE
        IN.OUT.PARA = "Recibo de Venta de Divisas"
    END

RETURN

END
