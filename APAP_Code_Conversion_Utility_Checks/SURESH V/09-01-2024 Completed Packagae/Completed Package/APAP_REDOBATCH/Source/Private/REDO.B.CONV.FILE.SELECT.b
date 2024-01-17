* @ValidationCode : MjoxNTg1MzYzNDAzOkNwMTI1MjoxNzAzNTY4MzU0NTU2OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Dec 2023 10:55:54
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
*    $INSERT I_BATCH.FILES ;*R22 Manual Conversion
    $INSERT I_REDO.B.CONV.FILE.COMMON
    $INSERT I_F.EB.FILE.UPLOAD.PARAM
    $INSERT I_F.REDO.FILE.DATE.PROCESS
    $INSERT I_F.REDO.SUPPLIER.PAYMENT
    $INSERT I_F.REDO.SUPPLIER.PAY.DATE
    
    $USING EB.Service ;*R22 Manual Conversion

    GOSUB PROCESS
    GOSUB GOEND
RETURN
*-------------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------------

    SEL.CMD   = "SELECT " : Y.FILE.DEST.PATH
    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
*    CALL BATCH.BUILD.LIST('',BUILD.LIST)
    EB.Service.BatchBuildList('',BUILD.LIST) ;*R22 Manual Conversion
RETURN
*-------------------------------------------------------------------------------------
GOEND:
*-------------------------------------------------------------------------------------
END
*-----------------------------------*END OF SUBROUTINE*-------------------------------
