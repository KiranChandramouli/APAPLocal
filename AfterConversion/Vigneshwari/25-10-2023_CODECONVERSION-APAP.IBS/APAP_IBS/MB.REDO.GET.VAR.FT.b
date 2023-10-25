* @ValidationCode : Mjo2OTUyODI4MDI6Q3AxMjUyOjE2OTgyMzIzMjQyNjk6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Oct 2023 16:42:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                VM TO @VM,SM TO @SM,FM TO @FM
*-----------------------------------------------------------------------------------------------------------------------------------

    SUBROUTINE MB.REDO.GET.VAR.FT
*-----------------------------------------------------------------------------
* Description :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_EB.EXTERNAL.COMMON

*-----------------------------------------------------------------------------

    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
* Main Process
PROCESS:
*-------

*    CALL System.setVariable('EXT.SMS.CUSTOMERS',R.NEW(ARC.BEN.OWNING.CUSTOMER)<1,1,1>)
    Y.NAME = "EXT.EXTERNAL.USER"
    CALL System.getUserVariables(Y.NAME ,Y.NAME.1)
    CONVERT @VM TO "-" IN Y.NAME
    CONVERT @FM TO "," IN Y.NAME
    CONVERT @SM TO "/" IN Y.NAME
    CONVERT @FM TO "," IN Y.NAME.1
    CONVERT @VM TO "-" IN Y.NAME.1
    CONVERT @SM TO "/" IN Y.NAME.1
    R.NEW(FT.PAYMENT.DETAILS) =  Y.NAME : " " : Y.NAME.1 :  " test"
*    CALL STORE.END.ERROR

    RETURN

*-----------------------------------------------------------------------------

END
