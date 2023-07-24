* @ValidationCode : MjotMjAxNDAxMDkwOTpDcDEyNTI6MTY5MDE3NDM5Mzc0MzpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 10:23:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*14-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*14-07-2023    VICTORIA S          R22 MANUAL CONVERSION   VARIABLE NAME MODIFIED
*----------------------------------------------------------------------------------------
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
*=======================================================================
*

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_REDO.FI.ENQ.VAR.COMMON
    $INSERT I_F.REDO.FI.CONTROL

*FI.BATCH.ID = R.RECORD<REDO.FI.CON.ID>
    FI.BATCH.ID = R.RECORD<REDO.FI.CON.TRANSACTION.ID> ;*R22 MANUAL CONVERSION
    CRT "EN REDO.FI.CONTROL.ID " : FI.BATCH.ID

RETURN
END
