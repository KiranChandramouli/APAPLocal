* @ValidationCode : MjotMjI4MjA4MjMwOkNwMTI1MjoxNzA0Nzk0NDk0NDM4OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 15:31:34
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
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.DEB.DIRECT.RTC.AUT.SELECT

    $INSERT I_COMMON                                   ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
  *  $INSERT I_BATCH.FILES
   * $INSERT I_TSA.COMMON
    $INSERT I_L.APAP.DEB.DIRECT.RTC.AUT.COMMON          ;*R22 Auto conversion - End
   $USING EB.Service

*    CALL EB.CLEAR.FILE(FN.LAPAP.CONCATE.DEB.DIR,F.LAPAP.CONCATE.DEB.DIR)
EB.Service.ClearFile(FN.LAPAP.CONCATE.DEB.DIR,F.LAPAP.CONCATE.DEB.DIR);* R22 UTILITY AUTO CONVERSION
    R.CHK.DIR1 = '' ; CHK.DIR.ERROR1 = '';
    CALL F.READ(FN.CHK.DIR1,Y.ARCHIVO.CARGA,R.CHK.DIR1,F.CHK.DIR1,CHK.DIR.ERROR1)
    IF NOT(R.CHK.DIR1) THEN
        RETURN
    END

    SEL.LIST = R.CHK.DIR1;
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION

RETURN

END
