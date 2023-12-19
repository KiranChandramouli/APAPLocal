* @ValidationCode : MjotMTgxNDM0OTYxMTpDcDEyNTI6MTcwMjk3ODE5NTE5OTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 14:59:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE DR.REG.FD01.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.FD01.EXTRACT
* Date           : 13-June-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the Buying and selling currencies
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
* 14-May-2015  Ashokkumar.V.P      PACS00309078 - Select the today inputted TXN
* 24-Jun-2015   Ashokkumar.V.P     PACS00466000 - Mapping changes - Fetch customer details to avoid blank.
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*30/05/2023      CONVERSION TOOL            AUTO R22 CODE CONVERSION           BP Removed in insertfile
*30/05/2023      HARISH VIKRAM              MANUAL R22 CODE CONVERSION         FN.POS.MVMT.TDY  added in insert file   I_DR.REG.FD01.EXTRACT.COMMON

*----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
* $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.FD01.EXTRACT.COMMON ;*AUTO R22 CODE CONVERSION
    $INSERT I_F.DR.REG.FD01.PARAM ;*AUTO R22 CODE CONVERSION
    $USING EB.Service

    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
    YLCCY = LCCY
*CALL EB.CLEAR.FILE(FN.DR.REG.FD01.TDYWORKFILE, F.DR.REG.FD01.TDYWORKFILE)
    EB.Service.ClearFile(FN.DR.REG.FD01.TDYWORKFILE, F.DR.REG.FD01.TDYWORKFILE)
    SEL.CMD = ''; SEL.IDS = ''; SELLIST = '';  SEL.STS = ''
    SEL.CMD = "SELECT ":FN.POS.MVMT.TDY:" WITH SYSTEM.ID EQ 'TT' 'FT' AND BOOKING.DATE EQ ":Y.TODAY.DATE.TIME:" AND CURRENCY NE ":YLCCY
    CALL EB.READLIST(SEL.CMD,SEL.IDS,'',SELLIST,SEL.STS)
*CALL BATCH.BUILD.LIST('',SEL.IDS)
    EB.Service.BatchBuildList('',SEL.IDS)
RETURN

END
