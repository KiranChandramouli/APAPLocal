* @ValidationCode : MjoxMzYyODI4Mzk2OkNwMTI1MjoxNjg0ODU0MzgzNDc1OklUU1M6LTE6LTE6LTE1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -15
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
* 10-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
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
