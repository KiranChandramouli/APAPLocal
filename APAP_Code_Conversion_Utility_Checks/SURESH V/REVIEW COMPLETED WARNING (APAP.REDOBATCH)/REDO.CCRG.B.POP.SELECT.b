* @ValidationCode : MjotMTEzMTc0MjkyOTpDcDEyNTI6MTcwNDc5MzEzMjA4NDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jan 2024 15:08:52
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
* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.CCRG.B.POP.SELECT
*-----------------------------------------------------------------------------
* Select routine to setup the common area for the multi-threaded Close of Business
* job REDO.CCRG.B.POP
*REM Just for compile
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 18-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 18-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*18/01/2024         Suresh                 R22 UTILITY AUTO CONVERSION   CALL routine Modified
*-------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.Service
*
    $INSERT I_REDO.CCRG.B.POP.COMMON
*
    LIST.PARAMETERS = '' ; ID.LIST = ''
    LIST.PARAMETERS<2> = FN.REDO.CCRG.POP.QUEUE

*    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,ID.LIST)
    EB.Service.BatchBuildList(LIST.PARAMETERS,ID.LIST);* R22 UTILITY AUTO CONVERSION

RETURN
*-----------------------------------------------------------------------------
END
