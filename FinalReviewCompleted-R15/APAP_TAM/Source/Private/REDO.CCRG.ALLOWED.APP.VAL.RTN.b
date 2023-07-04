* @ValidationCode : Mjo4NTEyNDM3Nzk6Q3AxMjUyOjE2ODQ4NDE4ODI0Mzc6SVRTUzotMTotMTotMTA6MTpmYWxzZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:08:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -10
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CCRG.ALLOWED.APP.VAL.RTN
*-----------------------------------------------------------------------------
*!** Simple SUBROUTINE template
* @author:    anoriega@temenos.com
* @stereotype subroutine: Validate Routine
* @package:   REDO.CCRG
*!
*-----------------------------------------------------------------------------
*  This routine validate the application to add will be only CUSTOMER
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CCRG.RISK.LIMIT.PARAM
*-----------------------------------------------------------------------------

    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
PROCESS:
* Validate application value inputted
    Y.APPLICATION = COMI
* APAP.TAM.REDO.CCRG.ALLOWED.APP('VAL.RTN',Y.APPLICATION) ;** R22 Manual conversion - CALL method format changed
    APAP.TAM.redoCcrgAllowedApp('VAL.RTN',Y.APPLICATION) ;*R22 Manual Conversion
RETURN
END
