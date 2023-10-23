* @ValidationCode : MjotMTExNDA0MzA1MTpDcDEyNTI6MTY5NzAyOTMwOTI5ODpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Oct 2023 18:31:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.ATM

SUBROUTINE REDO.GIT.CUSGRP.FORMAT(GIT.MAP.DATA,ERR.MSG)
*-----------------------------------------------------------------------------
*DESCRIPTION
*-------------------------------------------------------------------------------------------------------
* This routine is atached to GIT.MAPPING.IN to format the L.CU.G.LEALTAD(Multi value field)
*-------------------------------------------------------------------------------------------------------
*IN/OUT PARAMETERS:
*--------------------
* IN:
*-----
* GIT.MAP.DATA
*OUT:
*-----
* GIT.MAP.DATA
* ERR.MSG
*-----------------------------------------------------------------------------------------------
* MODIFICATION HISTORY:
*---------------------
* Date            Who                Reference               Description
* 07-OCT-2009   SUDHARSANAN S        TAM-ODR-2010-09-0012     INITIAL VERSION
* 06.04.2023    Conversion Tool       R22                     Auto Conversion     - No changes
* 06.04.2023    Shanmugapriya M       R22                     Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.GIT.MAPPING.IN
    $INSERT I_GIT.COMMON

    GOSUB PROCESS
RETURN
*-------------------------------------------------------------------------------------------------------
PROCESS:
*---------
    CHANGE '^' TO CHARX(165) IN GIT.MAP.DATA
RETURN
*-------------------------------------------------------------------------------------------------------
END
