* @ValidationCode : MjotMTIxNDI1NzE3MDpDcDEyNTI6MTY4MTI3NjEwMzMwMjpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:38:23
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
SUBROUTINE REDO.B.LY.GEN.ACCMOV.SELECT
*-----------------------------------------------------------------------------
* Select routine to setup the common area for the multi-threaded Close of Business
* job XX
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 12-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES

    $INSERT I_REDO.B.LY.GEN.ACCMOV.COMMON

    Y.CURR.YEAR  = TODAY[1,4]
    Y.CURR.MONTH = TODAY[5,2]
    Y.CURR.DAY   = TODAY[7,2]

    SEL.CMD = 'SELECT ':FN.REDO.LY.POINTS.TOT:' WITH @ID LIKE ALL...':Y.CURR.DAY:Y.CURR.MONTH:Y.CURR.YEAR
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',ID.CNT,'')
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
