* @ValidationCode : MjotMTMzNzU5OTY1NzpDcDEyNTI6MTY4NDg1NDM5NTIyOTpJVFNTOi0xOi0xOi03OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.REINV.BAL.UPDATE.SELECT

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.B.REINV.BAL.UPDATE.SELECT
*--------------------------------------------------------------------------------
* Description: This routine is a select routine for REDO.B.REINV.BAL.UPDATE
*
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE           DESCRIPTION
* 05-Jul-2011    H GANESH       PACS00072695_N.11  INITIAL CREATION
* Date                  who                   Reference
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.REINV.BAL.UPDATE.COMMON
   $USING EB.Service


    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    SEL.CMD = 'SELECT ':FN.AZ.ACCOUNT:' WITH L.TYPE.INT.PAY EQ Reinvested'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,AZ.ERR)
*    CALL BATCH.BUILD.LIST('', SEL.LIST)
EB.Service.BatchBuildList('', SEL.LIST);* R22 UTILITY AUTO CONVERSION

RETURN
END
