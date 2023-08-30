* @ValidationCode : MjotMTM2NDEyNDQ3NDpDcDEyNTI6MTY4MTE5NzAzNzE3OTpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 12:40:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.FX.CHK.FWD
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.FX.CHK.FWD
*--------------------------------------------------------------------------------------------------------
*Description  : This routine will check for deal type FORWARD if not raise an error
*Linked With  : Version group FOREX,FW
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date           Who                  Reference           Description
* ------         ------               -------------       -------------
* 14 FEB 2013    Riyas                PACS00243434        Initial Creation
*--------------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*11-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*11-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------------
 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX

    IF R.NEW(FX.RECORD.STATUS) NE '' THEN
        GOSUB PROCESS
    END

RETURN  ;* Return to end

PROCESS:
*********

    Y.DEAL.TYPE  = R.NEW(FX.DEAL.TYPE)
    Y.CCY.BOUGHT = R.NEW(FX.CURRENCY.BOUGHT)

    IF Y.DEAL.TYPE NE 'FW' THEN
        E = 'EB-VERSION.DIFFERS'
        CALL STORE.END.ERROR
    END

RETURN  ;* Return from PROCESS

END
