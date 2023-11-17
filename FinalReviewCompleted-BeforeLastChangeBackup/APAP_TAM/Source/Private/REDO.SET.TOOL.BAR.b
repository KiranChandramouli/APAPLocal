* @ValidationCode : MjozMjMzNDI2ODI6Q3AxMjUyOjE2ODEwNTY0ODYwOTE6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Apr 2023 21:38:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.SET.TOOL.BAR
    
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BROWSER.TOOLS
    $INSERT I_BROWSER.TAGS
    $INSERT I_GTS.COMMON


    IF V$FUNCTION EQ 'S' THEN
        TOOLBAR.ID = 'DSB.TOOL'
        CALL EB.ADD.TOOLBAR(TOOLBAR.ID, LOCATION)
        CALL EB.CHANGE.TOOL("CONTRACT", "TXN.VALIDATE", BRTL.ENABLED, "NO")
    END

RETURN

END
