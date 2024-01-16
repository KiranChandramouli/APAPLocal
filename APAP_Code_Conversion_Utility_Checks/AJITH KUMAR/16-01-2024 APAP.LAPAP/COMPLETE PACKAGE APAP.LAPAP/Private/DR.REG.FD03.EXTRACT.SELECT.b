* @ValidationCode : MjotMTYwOTI1ODEwOkNwMTI1MjoxNzAyOTg4MzQxNzUxOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
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
*15-12-2023       Santosh C                   MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*----------------------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*   $INSERT I_BATCH.FILES ;*R22 AUTO CODE CONVERSION ;*R22 Manual Code Conversion_Utility Check

    $INSERT I_DR.REG.FD03.EXTRACT.COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_F.DR.REG.FD03.PARAM ;*R22 AUTO CODE CONVERSION
    $USING EB.Service
    GOSUB SEL.PROCESS

RETURN

*-----------------------------------------------------------------------------
SEL.PROCESS:
************

*   CALL EB.CLEAR.FILE(FN.DR.REG.FD03.WORKFILE, F.DR.REG.FD03.WORKFILE)         ;* Clear the WORK file before building for Today
    EB.Service.ClearFile(FN.DR.REG.FD03.WORKFILE, F.DR.REG.FD03.WORKFILE) ;*R22 Manual Code Conversion_Utility Check

    SEL.CMD = ''
    BUILD.LIST = ''
    Y.SEL.CNT = ''
    Y.ERR = ''
    SEL.CMD = "SELECT ":FN.DR.REG.FD03.CONCAT:" WITH @ID GE ":REP.STRT.DATE:" AND WITH @ID LE ":REP.END.DATE
    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
*   CALL BATCH.BUILD.LIST('',BUILD.LIST)
    EB.Service.BatchBuildList('',BUILD.LIST) ;*R22 Manual Code Conversion_Utility Check
RETURN

*-----------------------------------------------------------------------------
END
