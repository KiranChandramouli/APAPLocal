* @ValidationCode : MjotMjA0NzcyNjQ5NTpDcDEyNTI6MTY4NDg1NDQwMDAwMzpJVFNTOi0xOi0xOjkzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 93
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UPD.BRANCH.LIMIT.LOAD

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.B.UPD.BRANCH.LIMIT.LOAD
*--------------------------------------------------------------------------------
* Description: This is batch routine to clear the daily balance for each branch.
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
*  20-Oct-2011    Pradeep S     PACS00149084      INITIAL CREATION
* Date                  who                   Reference              
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.UPD.BRANCH.LIMIT.COMMON

    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    FN.REDO.APAP.FX.BRN.POSN  = "F.REDO.APAP.FX.BRN.POSN"
    F.REDO.APAP.FX.BRN.POSN  = ""
    CALL OPF(FN.REDO.APAP.FX.BRN.POSN,F.REDO.APAP.FX.BRN.POSN)

RETURN
END
