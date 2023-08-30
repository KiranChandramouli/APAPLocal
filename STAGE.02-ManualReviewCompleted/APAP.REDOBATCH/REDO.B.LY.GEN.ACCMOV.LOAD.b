* @ValidationCode : MjotNDc3NDA5OTI3OkNwMTI1MjoxNjgxMjc2MDc2NzYyOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:37:56
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
SUBROUTINE REDO.B.LY.GEN.ACCMOV.LOAD
*-----------------------------------------------------------------------------
* Initialize COMMON variables and Open required files
*
*-----------------------------------------------------------------------------
* Modification History:
*                      2011-06-21 : avelasco@temenos.com
*                                   First version
*                      2013-09-13 : rmondragon@temenos.com
*                                   Update to use EB.ACCOUNTING
* Date                  who                   Reference              
* 12-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.LY.GEN.ACCMOV.COMMON
*-----------------------------------------------------------------------------
* Open files to be used in the XX routine as well as standard variables.
* REDO.LY.PROGRAM
    FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
    F.REDO.LY.PROGRAM  = ''
    CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

* REDO.LY.POINTS.TOT
    FN.REDO.LY.POINTS.TOT = 'F.REDO.LY.POINTS.TOT'
    F.REDO.LY.POINTS.TOT  = ''
    CALL OPF(FN.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT)

* FT.TXN.TYPE.CONDITION
    FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.CONDITION = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

* ACCOUNT
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*-----------------------------------------------------------------------------
END
