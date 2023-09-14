* @ValidationCode : MjotMTU1Mzc4MDExNzpDcDEyNTI6MTY4MjMyMzIzMjE5MDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 13:30:32
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
$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.FD03.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.FD03.EXTRACT
* Date           : 10-June-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the transactions over 1000 USD made by individual customer
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  REGREP.BP ,LAPAP.BP , T24.BP is removed ,$INCLUDE to$INSERT
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES ;*R22 AUTO CODE CONVERSION

    $INSERT I_DR.REG.FD03.EXTRACT.COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_F.DR.REG.FD03.PARAM ;*R22 AUTO CODE CONVERSION

    GOSUB SEL.PROCESS

RETURN

*-----------------------------------------------------------------------------
SEL.PROCESS:
************

    CALL EB.CLEAR.FILE(FN.DR.REG.FD03.WORKFILE, F.DR.REG.FD03.WORKFILE)         ;* Clear the WORK file before building for Today

    SEL.CMD = ''
    BUILD.LIST = ''
    Y.SEL.CNT = ''
    Y.ERR = ''
    SEL.CMD = "SELECT ":FN.DR.REG.FD03.CONCAT:" WITH @ID GE ":REP.STRT.DATE:" AND WITH @ID LE ":REP.END.DATE
    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
    CALL BATCH.BUILD.LIST('',BUILD.LIST)
RETURN

*-----------------------------------------------------------------------------
END
