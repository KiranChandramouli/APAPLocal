* @ValidationCode : MjoxMjIyMjI2ODU4OkNwMTI1MjoxNzA0NDMyOTAzNDIwOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 11:05:03
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
SUBROUTINE REDO.B.REINV.SYNC.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : SUJITHA S
* Program Name : REDO.B.REINV.SYNC.SELECT
*--------------------------------------------------------------------------------
*Description: Subroutine to perform the selection of the batch job
*
* Linked with   : None
* In Parameter  : None
* Out Parameter : SEL.AZ.ACCOUNT.LIST
*--------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 16-06-2010      SUJITHA.S   ODR-2009-10-0332  INITIAL CREATION
* Date                  who                   Reference
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*18/01/2024         Suresh                 R22 UTILITY AUTO CONVERSION  CALL routine Modified
*----------------------------------------------------------------------------

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_REDO.B.REINV.SYNC.COMMON
    $USING EB.Service

*This selection part is handled in main run routine. This batch is common for both type of deposits
* SEL.AZ.ACCOUNT.CMD="SELECT ":FN.AZACCOUNT:" WITH L.TYPE.INT.PAY EQ Reinvested"
    SEL.AZ.ACCOUNT.CMD="SELECT ":FN.AZACCOUNT
    CALL EB.READLIST(SEL.AZ.ACCOUNT.CMD,SEL.AZ.ACCOUNT.LIST,'',NO.OF.REC,AZ.ERR)
*    CALL BATCH.BUILD.LIST('', SEL.AZ.ACCOUNT.LIST)
    EB.Service.BatchBuildList('', SEL.AZ.ACCOUNT.LIST);* R22 UTILITY AUTO CONVERSION

RETURN
END
