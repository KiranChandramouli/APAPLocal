* @ValidationCode : MjotMTI3MzM2NzU3MzpDcDEyNTI6MTcwMjk3ODI2MzgwNjphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 15:01:03
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
*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN11.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.RIEN11.EXTRACT
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
* Date                  who                   Reference
* 24-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INCLUDE REGREP.BP TO $INSERT AND $INCLUDE LAPAP.BP TO $INSERT
* 24-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*    $INSERT I_BATCH.FILES
    $USING EB.Service

    $INSERT I_DR.REG.RIEN11.EXTRACT.COMMON
    $INSERT I_F.DR.REG.RIEN11.PARAM


    GOSUB BUILD.CONTROL.LIST
    GOSUB SEL.PROCESS
RETURN

BUILD.CONTROL.LIST:
*******************
*CALL EB.CLEAR.FILE(FN.DR.REG.RIEN11.WORKFILE, FV.DR.REG.RIEN11.WORKFILE)    ;* Clear the WORK file before building for Today
    EB.Service.ClearFile(FN.DR.REG.RIEN11.WORKFILE, FV.DR.REG.RIEN11.WORKFILE)
*CALL EB.CLEAR.FILE(FN.DR.REG.RIEN11.WORKFILE.FCY, FV.DR.REG.RIEN11.WORKFILE.FCY)      ;* Clear the WORK file before building for Today
    EB.Service.ClearFile(FN.DR.REG.RIEN11.WORKFILE.FCY, FV.DR.REG.RIEN11.WORKFILE.FCY)
RETURN
*-----------------------------------------------------------------------------
SEL.PROCESS:
************

    LIST.PARAMETER = ""
    LIST.PARAMETER<2> = "F.ACCT.ENT.LWORK.DAY"
    LIST.PARAMETER<7> = "FILTER"        ;* Call Fillter Routine to filer out the Internal Accounts from process
*CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
    EB.Service.BatchBuildList(LIST.PARAMETER, "")
RETURN

END
