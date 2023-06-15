* @ValidationCode : MjotMTk5MTA1MzI3MTpDcDEyNTI6MTY4NDg1NDQwNTg1MDpJVFNTOi0xOi0xOi0xOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.CCRG.B.EXT.SELECT
*-----------------------------------------------------------------------------
* Select routine to setup the common area for the multi-threaded Close of Business
* job REDO.CCRG.B.EXT
*REM Just for compile
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 18-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 18-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
*
    $INSERT I_REDO.CCRG.B.EXT.COMMON
    $INSERT I_REDO.CCRG.CONSTANT.COMMON
*

    LIST.PARAMETERS = '' ; ID.LIST = ''
    LIST.PARAMETERS<2> = FN.REDO.CCRG.EXT.QUEUE

    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,ID.LIST)

RETURN
*-----------------------------------------------------------------------------
END
