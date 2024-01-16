* @ValidationCode : MjoxMTIxNTk5MDE1OkNwMTI1MjoxNzA0ODYxNTE5NDgxOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Jan 2024 10:08:39
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
* Limpieza de DEBIT.DIRECT - 2da Fase - Proyecto COVID19
* Fecha: 31/03/2020
* Autor: Oliver Fermin
*----------------------------------------

SUBROUTINE LAPAP.DEBIT.DIRECT.COVID19.SELECT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
   * $INSERT I_BATCH.FILES
   * $INSERT I_TSA.COMMON
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_LAPAP.DEBIT.DIRECT.COVID19.COMO
   $USING EB.Service

*    CALL EB.CLEAR.FILE(FN.LAPAP.DEBIT.DIRECT.COVID19, F.LAPAP.DEBIT.DIRECT.COVID19)
EB.Service.ClearFile(FN.LAPAP.DEBIT.DIRECT.COVID19, F.LAPAP.DEBIT.DIRECT.COVID19);* R22 UTILITY AUTO CONVERSION

    R.CHK.DIR = '' ; CHK.DIR.ERROR = ''
    CALL F.READ(FN.CHK.DIR,Y.ARCHIVO.NOMBRE.ARCHIVO.IN,R.CHK.DIR,F.CHK.DIR,CHK.DIR.ERROR)
    IF NOT(R.CHK.DIR) THEN
        RETURN
    END

    SEL.LIST = R.CHK.DIR
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION

RETURN

END
