* @ValidationCode : MjoxMzYyODI4Mzk2OkNwMTI1MjoxNjgxMTA5ODgyMjcyOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 12:28:02
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
SUBROUTINE REDO.B.CONV.FILE.SELECT
*-------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Sakthi Sellappillai
* Program Name  : REDO.B.CONV.FILE.SELECT
* ODR           : ODR-2010-08-0031
*-------------------------------------------------------------------------------------
* Description: This routine is a load routine used to load the variables
*-------------------------------------------------------------------------------------
* out parameter : None
*-------------------------------------------------------------------------------------
* MODIFICATION HISTORY
*-------------------------------------------------------------------------------------
*DATE               WHO                       ODR                  DESCRIPTION
*============       ====================      ==================   ==============
*19-10-2010         Sakthi Sellappillai       ODR-2010-08-0031     INITIAL CREATION
* Date                  who                   Reference              
* 10-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.B.CONV.FILE.COMMON
    $INSERT I_F.EB.FILE.UPLOAD.PARAM
    $INSERT I_F.REDO.FILE.DATE.PROCESS
    $INSERT I_F.REDO.SUPPLIER.PAYMENT
    $INSERT I_F.REDO.SUPPLIER.PAY.DATE

    GOSUB PROCESS
    GOSUB GOEND
RETURN
*-------------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------------

    SEL.CMD   = "SELECT " : Y.FILE.DEST.PATH
    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
    CALL BATCH.BUILD.LIST('',BUILD.LIST)
RETURN
*-------------------------------------------------------------------------------------
GOEND:
*-------------------------------------------------------------------------------------
END
*-----------------------------------*END OF SUBROUTINE*-------------------------------
