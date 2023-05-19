* @ValidationCode : MjotMTY4MDk0NDQ4NzpDcDEyNTI6MTY4NDQxMDAyMzYzMzpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 May 2023 17:10:23
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.CHANGE.TEXT

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

* Developed by: TAM (marimuthu s)
* Reference : PACS00245134
* Description : This is conversion routine to translate english to spanish


** 21-04-2023 R22 Auto Conversion no changes
** 21-04-2023 Skanda R22 Manual Conversion - No changes

    BEGIN CASE

        CASE O.DATA EQ 'Processing...'
            O.DATA = 'En Proceso...'
        CASE O.DATA EQ 'Executed - Successfully'
            O.DATA = 'Proceso Completado'
        CASE O.DATA EQ 'Completed - Error'
            O.DATA = 'Error en Proceso '
    END CASE

RETURN

END
