* @ValidationCode : MjoxNDM1MTk4MjYzOkNwMTI1MjoxNjgyNDEyMzQ2Nzg4OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:46
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
SUBROUTINE REDO.V.FX.CHK.SPOT
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.FX.CHK.SPOT
*--------------------------------------------------------------------------------------------------------
*Description  : This routine will check for deal type SPOT if not raise an error
*Linked With  : Version group FOREX,SP
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date           Who                  Reference                          Description
* ------         ------               -------------                     -------------
* 14 FEB 2013    Riyas                PACS00243434                    Initial Creation
*11-04-2023      Conversion Tool      R22 Auto Code conversion          No Changes
*11-04-2023      Samaran T            R22 Manual Code Conversion         No Changes
 
*--------------------------------------------------------------------------------------------------------

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

    IF Y.DEAL.TYPE NE 'SP' THEN
        E = 'EB-VERSION.DIFFERS'
        CALL STORE.END.ERROR
    END

RETURN  ;* Return from PROCESS

END
