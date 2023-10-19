* @ValidationCode : MjotMjA4NTEyNTIyOTpDcDEyNTI6MTY4ODQ2NDg4MTQzNTp2aWN0bzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Jul 2023 15:31:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------

*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*04-07-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.CH.ABONO.CUS.TIME
    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON ;*R22 MANUAL CONVERSION END

    Y.HORA          = ""
    Y.MINUTOS       = ""
    Y.TIME          = ""
    Y.DATA          = O.DATA

    Y.HORA1         = Y.DATA[7,8]
    Y.HORA          = Y.HORA1[1,2]
    Y.MINUTOS       = Y.DATA[9,10]

    Y.TIME          = Y.HORA:":":Y.MINUTOS

    O.DATA          = Y.TIME

RETURN
END
