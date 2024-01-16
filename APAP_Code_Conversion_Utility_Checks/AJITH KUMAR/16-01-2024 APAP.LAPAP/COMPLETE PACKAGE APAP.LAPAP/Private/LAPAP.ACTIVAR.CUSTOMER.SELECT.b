* @ValidationCode : MjoxMTUzMjM3MzcwOkNwMTI1MjoxNzA0ODAwNDM4OTczOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 17:10:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Subrutina: LAPAP.ACTIVAR.CUSTOMER.SELECT
*  Creación: 07/02/2022
*     Autor: Félix Trinidad
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.ACTIVAR.CUSTOMER.SELECT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
   * $INSERT I_BATCH.FILES
    *$INSERT I_TSA.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CR.OTHER.PRODUCTS
    $INSERT I_LAPAP.ACTIVAR.CUSTOMER.COMMON
   $USING EB.Service

    GOSUB PROCESS.1

RETURN

PROCESS.1:
*--Leo los Clientes de la Tabla FBNK.CR.OTHER.PRODUCT
    SEL.CMD = "SELECT " : FN.OTHER
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SEL.ERR)

*    CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION
RETURN

END
