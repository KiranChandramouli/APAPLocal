* @ValidationCode : MjotMTkwNTExNDI3NzpDcDEyNTI6MTcwMjk5MTE1NjI4ODpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 18:35:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
$PACKAGE APAP.TAM
SUBROUTINE DR.REG.FD01.EXTRACT.NEW.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.FD01.EXTRACT.NEW
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
*-----------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*24/11/2023         Suresh             R22 Manual Conversion             T24.BP, LAPAP.BP, REGREP.BP  File Removed, INCLUDE TO INSERT
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Manual Conversion - start
    $INSERT I_EQUATE
*  $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.FD01.EXTRACT.NEW.COMMON
    $INSERT I_F.DR.REG.FD01.PARAM ;*R22 Manual Conversion - end
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
