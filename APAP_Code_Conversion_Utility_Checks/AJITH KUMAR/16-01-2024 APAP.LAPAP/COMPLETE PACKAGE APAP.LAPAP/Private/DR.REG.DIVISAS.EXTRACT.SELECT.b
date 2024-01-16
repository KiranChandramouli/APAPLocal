* @ValidationCode : MjotMTA1NDAxNzExNzpDcDEyNTI6MTcwMjk4ODM0MTQ0NjpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:01
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
$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.DIVISAS.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Program Name   : DR.REG.DIVISAS.EXTRACT
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the Buying and selling currencies
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 05-Dec-2017  Ashokkumar.V.P      CN007023 - Initial Version.
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INCLUDE to INSERT
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   NO CHANGE
*14-12-2023    Santosh C           MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*   $INSERT I_BATCH.FILES ;*R22 Manual Code Conversion_Utility Check
    $INSERT I_F.DATES
    $INSERT I_DR.REG.DIVISAS.EXTRACT.COMMON ;*R22 Auto code conversion
    $INSERT I_F.DR.REG.FD01.PARAM
    $USING EB.Service

    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
*   CALL EB.CLEAR.FILE(FN.DR.REG.DIVIAS.WORKFILE, F.DR.REG.DIVIAS.WORKFILE)
    EB.Service.ClearFile(FN.DR.REG.DIVIAS.WORKFILE, F.DR.REG.DIVIAS.WORKFILE) ;*R22 Manual Code Conversion_Utility Check
    R.DR.REG.FD01.CONCAT = ''; ERR.DR.REG.FD01.CONCAT = ''
    CALL F.READ(FN.DR.REG.FD01.CONCAT,Y.LAST.DATE.TIME,R.DR.REG.FD01.CONCAT,F.DR.REG.FD01.CONCAT,ERR.DR.REG.FD01.CONCAT)
*   CALL BATCH.BUILD.LIST('',R.DR.REG.FD01.CONCAT)
    EB.Service.BatchBuildList('',R.DR.REG.FD01.CONCAT) ;*R22 Manual Code Conversion_Utility Check
RETURN

END
