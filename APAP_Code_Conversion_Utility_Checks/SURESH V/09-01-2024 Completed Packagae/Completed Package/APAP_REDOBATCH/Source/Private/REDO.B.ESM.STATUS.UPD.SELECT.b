* @ValidationCode : MjotMTY5OTg5NTI4OkNwMTI1MjoxNzAzNTg2MjEwNjIzOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Dec 2023 15:53:30
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
SUBROUTINE  REDO.B.ESM.STATUS.UPD.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.B.ESM.STATUS.UPD.SELECT
*--------------------------------------------------------------------------------
*Description: Subroutine to perform the selection of the batch job

* Linked with   : None
* In Parameter  : None
* Out Parameter : REDO.B.ESM.STATUS.UPD.SELECT
*--------------------------------------------------------------------------------
*Modification History:
*09/12/2009 - ODR-2009-10-0537
*Development for Subroutine to perform the selection
**********************************************************************************
*  DATE             WHO         REFERENCE         DESCRIPTION
* 09 AUG 2011    Prabhu N      PACS00100804      Selection routine for table REDO.T.MSG.DET
* Date                  who                   Reference
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023         Suresh                R22 Manual Conversion    CALL routine modified
*--------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_REDO.B.ESM.STATUS.UPD.COMMON
    
    $USING EB.Service ;*R22 Manual Conversion

    SEL.CMD="SELECT " : FN.REDO.T.MSG.DET

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,AZ.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST) ;*R22 Manual Conversion

RETURN
END
