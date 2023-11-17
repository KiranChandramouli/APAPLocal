* @ValidationCode : MjozMTE0MTg2MTg6Q3AxMjUyOjE2ODExODk5OTYxNzI6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 10:43:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE  REDO.VISA.GEN.OUT.SELECT
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
**Developed By      : Temenos Application Management
*Program Name      : REDO.VISA.GEN.ACQ.REC.SELECT
*Date              : 07.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*07/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
* 11.04.2023       Conversion Tool                  R22            Auto Conversion     - No changes
* 11.04.2023       Shanmugapriya M                  R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON
*$INCLUDE TAM.BP I_REDO.VISA.GEN.OUT.COMMON

    GOSUB PROCESS

RETURN


*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------


    SEL.CMD="SELECT ":FN.REDO.VISA.GEN.OUT
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('', SEL.LIST)
RETURN
END
