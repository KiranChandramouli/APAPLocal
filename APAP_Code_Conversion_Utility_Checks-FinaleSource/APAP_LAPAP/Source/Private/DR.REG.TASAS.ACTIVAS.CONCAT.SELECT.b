* @ValidationCode : MjoxNzg0NjExNTI3OkNwMTI1MjoxNzAyOTg4MzQzNTA5OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:03
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
SUBROUTINE DR.REG.TASAS.ACTIVAS.CONCAT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.TASAS.ACTIVAS.CONCAT
* Date           : 27-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the Active rates
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*  ======        ========            ==========================
* 09-Oct-2014  Ashokkumar.V.P      PACS00305233:- Changed the parameter values
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INCLUDE LAPAP.BP TO $INSERT
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* 15-12-2023       Santosh C               MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*   $INSERT I_BATCH.FILES ;*R22 Manual Code Conversion_Utility Check
    $INSERT I_DR.REG.TASAS.ACTIVAS.CONCAT.COMMON
    $USING EB.Service


    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
*   CALL EB.CLEAR.FILE(FN.DR.REG.ACTIVAS.GROUP, F.DR.REG.ACTIVAS.GROUP)
    EB.Service.ClearFile(FN.DR.REG.ACTIVAS.GROUP, F.DR.REG.ACTIVAS.GROUP) ;*R22 Manual Code Conversion_Utility Check
    LIST.PARAMETER = ""
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
    LIST.PARAMETER<3> = "ARR.STATUS EQ 'CURRENT' AND START.DATE EQ ":LAST.WORK.DAY
*   CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
    EB.Service.BatchBuildList(LIST.PARAMETER, "") ;*R22 Manual Code Conversion_Utility Check
RETURN

END
