* @ValidationCode : Mjo1MzAzNDMyMTE6VVRGLTg6MTY4Nzc4MzQwODQ2MDpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Jun 2023 18:13:28
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.CONTROL.ID
*
******************************************************************************
*
*
* =============================================================================
*
*    First Release : R09
*    Developed for : APAP
*    Developed by  : Ana Noriega
*    Date          : 2010/Oct/27
*
* 26-06-2023  Narmadha V  Manual R22 Conversion- REDO.FI.CON.ID were missing in I_REDO.FI.ENQ.VAR.COMMON insert file
*=======================================================================
*

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_REDO.FI.ENQ.VAR.COMMON
    $INSERT I_F.REDO.FI.CONTROL

*  FI.BATCH.ID = R.RECORD<REDO.FI.CON.ID> ;*  Manual R22 Conversion
    CRT "EN REDO.FI.CONTROL.ID " : FI.BATCH.ID

RETURN
END
