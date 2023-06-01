* @ValidationCode : MjozMDUyMjAyOTc6Q3AxMjUyOjE2ODQyMzM0MjQxMTU6SVRTUzotMTotMTotNzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 16:07:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
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

    CALL APAP.LAPAP.lApapSendRabbitMasive(APPLICATION,PGM.VERSION,ID.NEW,MAP);* R22 Manual conversion


RETURN

END
