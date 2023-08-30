* @ValidationCode : MjotMTk5MTA1MzI3MTpDcDEyNTI6MTY4MTc5NDk2MjIxMDpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 10:46:02
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
