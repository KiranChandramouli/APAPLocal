* @ValidationCode : Mjo2NTA3NDYzNjE6Q3AxMjUyOjE2ODQyMjI3NzM4Njg6SVRTUzotMTotMTo5NDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:09:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 94
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.FD01.LASTD.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Program Name   : DR.REG.FD01.LASTD.EXTRACT
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the Buying and selling currencies
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 14-May-2015  Ashokkumar.V.P          PACS00309078 - Initial Version.
* 24-Jun-2015   Ashokkumar.V.P     PACS00466000 - Mapping changes - Fetch customer details to avoid blank.
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   $INCLUDE to$INSERT , LAPAP.BP &REGREP.BP is removed
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------


*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_DR.REG.FD01.LASTD.EXTRACT.COMMON
    $INSERT I_F.DR.REG.FD01.PARAM

    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
    YLCCY = LCCY
    CALL EB.CLEAR.FILE(FN.DR.REG.FD01.WORKFILE, F.DR.REG.FD01.WORKFILE)
    R.DR.REG.FD01.CONCAT = ''; ERR.DR.REG.FD01.CONCAT = ''
    CALL F.READ(FN.DR.REG.FD01.CONCAT,Y.LAST.DATE.TIME,R.DR.REG.FD01.CONCAT,F.DR.REG.FD01.CONCAT,ERR.DR.REG.FD01.CONCAT)
    CALL BATCH.BUILD.LIST('',R.DR.REG.FD01.CONCAT)
RETURN

END
