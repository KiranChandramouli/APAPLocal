* @ValidationCode : MjoyMzM2MDk4NTA6Q3AxMjUyOjE3MDI5ODgzMzg0ODM6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:48:58
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
SUBROUTINE DR.BLD.OPER.DIVISAS.SELECT
*-----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date        Author             Modification Description
* 12-Sep-2014   V.P.Ashokkumar     PACS00318671 - Rewritten to create 2 reports.
* 24-Jun-2015   Ashokkumar.V.P     PACS00466000 - Mapping changes - Fetch customer details to avoid blank
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   LAPAP.BP removed, $INCLUDE gto $INSERT
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*14-12-2023       Santosh C                   MANUAL R22 CODE CONVERSION NO CHANGE   APAP Code Conversion Utility Check
*----------------------------------------------------------------------------------------





*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*   $INSERT I_BATCH.FILES ;*R22 Manual Code Conversion_Utility Check
    $INSERT I_DR.BLD.OPER.DIVISAS ;*R22 AUTO CODE CONVERSION
    $USING EB.Service ;*R22 Manual Code Conversion_Utility Check

    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
    YLCCY = LCCY
*   CALL EB.CLEAR.FILE(FN.DR.OPER.DIVISAS.FILE,F.DR.OPER.DIVISAS.FILE)
    EB.Service.ClearFile(FN.DR.OPER.DIVISAS.FILE,F.DR.OPER.DIVISAS.FILE) ;*R22 Manual Code Conversion_Utility Check
    R.DR.REG.FD01.CONCAT = ''; ERR.DR.REG.FD01.CONCAT = ''
    CALL F.READ(FN.DR.REG.FD01.CONCAT,Y.LAST.WRK.DAY,R.DR.REG.FD01.CONCAT,F.DR.REG.FD01.CONCAT,ERR.DR.REG.FD01.CONCAT)
*   CALL BATCH.BUILD.LIST('',R.DR.REG.FD01.CONCAT)
    EB.Service.BatchBuildList('',R.DR.REG.FD01.CONCAT) ;*R22 Manual Code Conversion_Utility Check
RETURN
END
