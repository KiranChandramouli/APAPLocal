* @ValidationCode : MjotMTE2NDkxNjEwNDpDcDEyNTI6MTcwMjY0MDc0MDU4ODozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 15 Dec 2023 17:15:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
SUBROUTINE DR.REG.RIEN4.AZ.EXT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN4.AZ.EXT
* Date           : 27-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the AZ.ACCOUNT Details product wise.
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*16-09-2014   Ashokkumar             PACS00367490- Removed the multiple select statement on same file.
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*06-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*06-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*14/12/2023       Suresh                      R22 Manual Conversion      Call routine Modified
*----------------------------------------------------------------------------------------



*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*   $INSERT I_BATCH.FILES ;*R22 Manual Conversion
    $INSERT I_DR.REG.RIEN4.AZ.EXT.COMMON
    
    $USING EB.Service ;*R22 Manual Conversion

    IF NOT(CONTROL.LIST) THEN

        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.PROCESS
RETURN

BUILD.CONTROL.LIST:
*******************

*    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AZ.REP,F.DR.REG.RIEN4.AZ.REP)
    EB.Service.ClearFile(FN.DR.REG.RIEN4.AZ.REP,F.DR.REG.RIEN4.AZ.REP) ;*R22 Manual Conversion
*    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AZ.REP.OUT,F.DR.REG.RIEN4.AZ.REP.OUT)
    EB.Service.ClearFile(FN.DR.REG.RIEN4.AZ.REP.OUT,F.DR.REG.RIEN4.AZ.REP.OUT) ;*R22 Manual Conversion
*    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AZ.REP2,F.DR.REG.RIEN4.AZ.REP2)
    EB.Service.ClearFile(FN.DR.REG.RIEN4.AZ.REP2,F.DR.REG.RIEN4.AZ.REP2) ;*R22 Manual Conversion
*    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AZ.REP.OUT2,F.DR.REG.RIEN4.AZ.REP.OUT2)
    EB.Service.ClearFile(FN.DR.REG.RIEN4.AZ.REP.OUT2,F.DR.REG.RIEN4.AZ.REP.OUT2) ;*R22 Manual Conversion
*    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AZ.REP3,F.DR.REG.RIEN4.AZ.REP3)
    EB.Service.ClearFile(FN.DR.REG.RIEN4.AZ.REP3,F.DR.REG.RIEN4.AZ.REP3) ;*R22 Manual Conversion
*    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AZ.REP.OUT3,F.DR.REG.RIEN4.AZ.REP.OUT3)
    EB.Service.ClearFile(FN.DR.REG.RIEN4.AZ.REP.OUT3,F.DR.REG.RIEN4.AZ.REP.OUT3) ;*R22 Manual Conversion
*    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AZ.REP4,F.DR.REG.RIEN4.AZ.REP4)
    EB.Service.ClearFile(FN.DR.REG.RIEN4.AZ.REP4,F.DR.REG.RIEN4.AZ.REP4) ;*R22 Manual Conversion
*    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AZ.REP.OUT4,F.DR.REG.RIEN4.AZ.REP.OUT4)
    EB.Service.ClearFile(FN.DR.REG.RIEN4.AZ.REP.OUT4,F.DR.REG.RIEN4.AZ.REP.OUT4) ;*R22 Manual Conversion
*    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AC.REP1,F.DR.REG.RIEN4.AC.REP1)
    EB.Service.ClearFile(FN.DR.REG.RIEN4.AC.REP1,F.DR.REG.RIEN4.AC.REP1) ;*R22 Manual Conversion
*    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN4.AC.REP2,F.DR.REG.RIEN4.AC.REP2)
    EB.Service.ClearFile(FN.DR.REG.RIEN4.AC.REP2,F.DR.REG.RIEN4.AC.REP2) ;*R22 Manual Conversion

    CONTROL.LIST<-1> = "REP1"
    CONTROL.LIST<-1> = "REP2"
RETURN

SEL.PROCESS:
************

    LIST.PARAMETER = ""

    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "REP1"
            LIST.PARAMETER<2> = "F.AZ.ACCOUNT"
            LIST.PARAMETER<3> = "CATEGORY EQ ":YAZ.CAT.LIST
*           CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
            EB.Service.BatchBuildList(LIST.PARAMETER, "") ;*R22 Manual Conversion

        CASE CONTROL.LIST<1,1> EQ "REP2"
            LIST.PARAMETER<2> = "F.ACCOUNT"
            LIST.PARAMETER<3> = "CATEGORY EQ ":YAC.CAT.LIST
*           CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
            EB.Service.BatchBuildList(LIST.PARAMETER, "") ;*R22 Manual Conversion

        CASE 1
            DUMMY.LIST = ""
*           CALL BATCH.BUILD.LIST("",DUMM.LIST)
            EB.Service.BatchBuildList("",DUMM.LIST) ;*R22 Manual Conversion
    END CASE

RETURN

END
