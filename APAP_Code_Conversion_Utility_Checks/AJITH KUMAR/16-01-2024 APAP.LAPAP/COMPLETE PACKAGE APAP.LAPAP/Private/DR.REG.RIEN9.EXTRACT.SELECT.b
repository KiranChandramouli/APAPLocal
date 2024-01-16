* @ValidationCode : Mjo0ODM2ODEzMzc6Q3AxMjUyOjE3MDI5ODgzNDI5NzQ6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:02
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
SUBROUTINE DR.REG.RIEN9.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN9.EXTRACT
* Date           : 3-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the MM and SEC.TRADE in DOP and non DOP.
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 28-08-2014     V.P.Ashokkumar       PACS00313072- Filter to avoid ARC-IB records.
* 09-12-2014     V.P.Ashokkumar       PACS00313072- Removed the AUTH status.
* 10-02-2015     V.P.Ashokkumar       PACS00313072- Fixed the select problem
* 21-10-2016     V.P.Ashokkumar       R15 Upgrade
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INCLUDE REGREP.BP TO $INSERT AND $INCLUDE LAPAP.BP TO $INSERT
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* 15-12-2023       Santosh C               MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*   $INSERT I_BATCH.FILES ;*R22 Manual Code Conversion_Utility Check
    $INSERT I_DR.REG.RIEN9.EXTRACT.COMMON
    $INSERT I_F.DR.REG.RIEN9.PARAM
    $USING EB.Service


    GOSUB BUILD.CONTROL.LIST
    GOSUB SEL.PROCESS
RETURN

BUILD.CONTROL.LIST:
*******************
*R22 Manual Code Conversion_Utility Check-Start
*   CALL EB.CLEAR.FILE(FN.DR.REG.RIEN9.WORKFILE, F.DR.REG.RIEN9.WORKFILE)
*   CALL EB.CLEAR.FILE(FN.DR.REG.RIEN9.WORKFILE.FCY, F.DR.REG.RIEN9.WORKFILE.FCY)
    
    EB.Service.ClearFile(FN.DR.REG.RIEN9.WORKFILE, F.DR.REG.RIEN9.WORKFILE)
    EB.Service.ClearFile(FN.DR.REG.RIEN9.WORKFILE.FCY, F.DR.REG.RIEN9.WORKFILE.FCY)
*R22 Manual Code Conversion_Utility Check-End
RETURN

SEL.PROCESS:
************
    LIST.PARAMETER = ""
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
    LIST.PARAMETER<3> := "PRODUCT.LINE EQ 'LENDING'"

*   CALL BATCH.BUILD.LIST(LIST.PARAMETER, "") ;*R22 Manual Code Conversion_Utility Check
    EB.Service.BatchBuildList(LIST.PARAMETER, "")
RETURN

END
