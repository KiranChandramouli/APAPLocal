* @ValidationCode : Mjo3NDY4MDA2NTY6Q3AxMjUyOjE2ODEyOTgyMzE1MjE6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 16:47:11
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.PREVALANCE.STATUS.SELECT
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine selects the ids from ACCOUNT Application
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date            who           Reference            Description
* 03-MAY-2010   S.Jeyachandran  ODR-2010-08-0490      Initial Creation
* 12-04-2023       CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_REDO.B.PREVALANCE.STATUS.COMMON
    $INSERT I_F.REDO.PREVALANCE.STATUS
*----------------------------------------------------------------------------

    GOSUB SELECT.PRGM
    GOSUB PROGRAM.END
RETURN
*-----------------------------------------------------------------------------
SELECT.PRGM:
*-----------------------------------------------------------------------------

    SEL.CMD = "SELECT ":FN.ACCOUNT:" WITH L.AC.STATUS1 NE '' OR L.AC.STATUS2 NE ''"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------
END
