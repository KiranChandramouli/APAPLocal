* @ValidationCode : MjotMzUwMzE0NDU2OkNwMTI1MjoxNjg0MjIyNzczNDM4OklUU1M6LTE6LTE6LTE1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:09:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -15
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.COMM.LOAN.SECTOR.EXT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.COMMERCIAL.LOAN.SECTOR.EXTRACT
* Date           : 16-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the AA.ARRANGEMENT application where the AA.GROUP.PRODUCT = COMERCIAL
* and the AA.STATUS is equal to  ("CURRENT" or "EXPIRED")
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 03-Oct-2014  Ashokkumar           PACS00305229:- Displaying Credit lines details
* 12-May-2015  Ashokkumar.V.P       PACS00305229:- Added new fields mapping change.
* 26-Jun-2015  Ashokkumar.V.P       PACS00466618:- Fixed the NAB account created on same date for old NAB loans
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   T24.BP ,LAPAP.BP is removed, $INCLUDE to $INSERT
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.COMMON

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.PROCESS
RETURN

*-----------------------------------------------------------------------------
BUILD.CONTROL.LIST:
*******************

    CALL EB.CLEAR.FILE(FN.DR.REG.COM.LOAN.SECTOR.WORKFILE,F.DR.REG.COM.LOAN.SECTOR.WORKFILE)

    CONTROL.LIST<-1> = "AA.DETAILS"

RETURN
*-----------------------------------------------------------------------------

SEL.PROCESS:
************

    LIST.PARAMETER = ""

    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "AA.DETAILS"
            LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
            LIST.PARAMETER<3> := "PRODUCT.LINE EQ ":"LENDING"
            LIST.PARAMETER<3> := " AND PRODUCT.GROUP EQ ":Y.TXNPGRP.VAL.ARR
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
        CASE 1
            DUMMY.LIST = ""
            CALL BATCH.BUILD.LIST("",DUMM.LIST)
    END CASE

RETURN
*-----------------------------------------------------------------------------
END
