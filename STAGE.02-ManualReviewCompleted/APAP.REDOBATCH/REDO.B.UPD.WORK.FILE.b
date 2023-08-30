* @ValidationCode : MjoxNDU1Nzk1NjAxOkNwMTI1MjoxNjgxNzA3MTA4NjM4OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 10:21:48
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
SUBROUTINE REDO.B.UPD.WORK.FILE

*-------------------------------------------------------------------L-------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.B.UPD.WORK.FILE
*--------------------------------------------------------------------------------
* Description: This routine is for Deleting local template for the COB preformanace issue
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 02-12-2011      Jeeva T     For COB Performance
* Date                  who                   Reference              
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.PARAMETER

    GOSUB OPEN.FILE
    GOSUB PROCESS.FILE
RETURN

*---------------------------------------------------------------------------------
OPEN.FILE:
*---------------------------------------------------------------------------------
    FN.REDO.W.ACCOUNT.UPDATE = 'F.REDO.W.ACCOUNT.UPDATE'
    F.REDO.W.ACCOUNT.UPDATE = ''
    CALL OPF(FN.REDO.W.ACCOUNT.UPDATE,F.REDO.W.ACCOUNT.UPDATE)
    R.REDO.W.ACCOUNT.UPDATE = '' ; Y.FUNCTION = ''
RETURN
*---------------------------------------------------------------------------------
PROCESS.FILE:
*---------------------------------------------------------------------------------
    CALL F.DELETE(FN.REDO.W.ACCOUNT.UPDATE,TODAY)
RETURN
END
