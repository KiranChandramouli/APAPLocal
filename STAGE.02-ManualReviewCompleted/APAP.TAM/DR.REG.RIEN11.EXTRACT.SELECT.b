* @ValidationCode : MjoxMjgyMTgxOTk3OkNwMTI1MjoxNjgyMzEzNDU1NTY3OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 10:47:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
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
    $INSERT I_BATCH.FILES

    $INSERT I_DR.REG.RIEN11.EXTRACT.COMMON
    $INSERT I_F.DR.REG.RIEN11.PARAM


    GOSUB BUILD.CONTROL.LIST
    GOSUB SEL.PROCESS
RETURN

BUILD.CONTROL.LIST:
*******************
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN11.WORKFILE, FV.DR.REG.RIEN11.WORKFILE)    ;* Clear the WORK file before building for Today
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN11.WORKFILE.FCY, FV.DR.REG.RIEN11.WORKFILE.FCY)      ;* Clear the WORK file before building for Today
RETURN
*-----------------------------------------------------------------------------
SEL.PROCESS:
************

    LIST.PARAMETER = ""
    LIST.PARAMETER<2> = "F.ACCT.ENT.LWORK.DAY"
    LIST.PARAMETER<7> = "FILTER"        ;* Call Fillter Routine to filer out the Internal Accounts from process
    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
RETURN

END
