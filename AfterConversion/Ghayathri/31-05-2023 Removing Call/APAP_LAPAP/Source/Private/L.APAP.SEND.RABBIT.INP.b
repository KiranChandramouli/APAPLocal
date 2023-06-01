* @ValidationCode : MjotMjEwMTgyOTQ4OTpDcDEyNTI6MTY4NTUzMjM1MjE4MjpoYWk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 16:55:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
$PACKAGE APAP.LAPAP
* Version 2 02/06/00 GLOBUS Release No. G11.0.00 29/06/00
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.SEND.RABBIT.INP
*-----------------------------------------------------------------------------
* Modification History

*-----------------------------------------------------------------------------
* Creation: ARCADIO RUIZ
* Creation Date: 2020/05/14
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_TSS.COMMON

    GOSUB PROCESS

RETURN

*-----------------------------------------------------------------------------

PROCESS:


    MAP = "CUST.STATUS.RESPONSE"

    APAP.LAPAP.lApapSendRabbitMasive(APPLICATION,PGM.VERSION,ID.NEW,MAP);* R22 Manual conversion


RETURN

END
