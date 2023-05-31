* @ValidationCode : MjotMTk4ODI0MjgyMjpDcDEyNTI6MTY4NDg1NDA1MTE5MTpJVFNTOi0xOi0xOi04OjE6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:30:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -8
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
* All rights reserved.
$PACKAGE APAP.REDOCHNLS
SUBROUTINE AI.REDO.V.TRD.PARTY.EMAIL
*-----------------------------------------------------------------------------
* This subroutine will validate a field containing an e-mail address.
*-----------------------------------------------------------------------------
*       Revision History
*
*       First Release:  February 8th
*       Developed for:  APAP
*       Developed by:   Martin Macias - Temenos - MartinMacias@temenos.com
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ADD.THIRDPARTY

    GOSUB VALIDA
RETURN

*---------
VALIDA:
*---------

    Y.EMAIL = R.NEW(ARC.TP.EMAIL)

    IF LEN(Y.EMAIL) EQ 0 THEN
        RETURN
    END

    AF = ARC.TP.EMAIL

*CALL AI.REDO.V.EMAIL(Y.EMAIL)
    CALL APAP.REDOCHNLS.aiRedoVEmail(Y.EMAIL)

RETURN

END
