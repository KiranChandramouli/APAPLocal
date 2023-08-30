* @ValidationCode : MjotMTA2NDk3NjMzOTpDcDEyNTI6MTY4MTEwNTM4NzU4NzpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 11:13:07
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
SUBROUTINE REDO.B.CHECK.INT.RATE.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.B.CHECK.INT.RATE.SELECT
*--------------------------------------------------------------------------------
*Description: Subroutine to perform the selection of the batch job

* Linked with   : None
* In Parameter  : None
* Out Parameter : SEL.AZ.ACCOUNT.LIST
*--------------------------------------------------------------------------------
*Modification History:
*09/12/2009 - ODR-2009-10-0537
*Development for Subroutine to perform the selection of the batch job
**********************************************************************************
*  DATE             WHO         REFERENCE         DESCRIPTION
* 26 Mar 2011    GURU DEV      PACS00033054      Modified as per issue
* Date                  who                   Reference              
* 10-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_REDO.B.CHECK.INT.RATE.COMMON


    SEL.AZ.ACCOUNT.CMD="SELECT " : FN.AZ.ACCOUNT : " WITH MATURITY.DATE GT " : TODAY : " AND MATURITY.DATE LE " : R.DATES(EB.DAT.NEXT.WORKING.DAY) : " AND L.AZ.BAL.CONSOL EQ ''"

    CALL EB.READLIST(SEL.AZ.ACCOUNT.CMD,SEL.AZ.ACCOUNT.LIST,'',NO.OF.REC,AZ.ERR)
    CALL BATCH.BUILD.LIST('', SEL.AZ.ACCOUNT.LIST)

RETURN
END
