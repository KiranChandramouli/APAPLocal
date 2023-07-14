* @ValidationCode : MjoxMjk3OTU5NDg5OkNwMTI1MjoxNjg5MjQyODgzMTUyOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 15:38:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
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
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_L.APAP.DEB.DIRECT.RTC.AUT.COMMON          ;*R22 Auto conversion - End

    CALL EB.CLEAR.FILE(FN.LAPAP.CONCATE.DEB.DIR,F.LAPAP.CONCATE.DEB.DIR)
    R.CHK.DIR1 = '' ; CHK.DIR.ERROR1 = '';
    CALL F.READ(FN.CHK.DIR1,Y.ARCHIVO.CARGA,R.CHK.DIR1,F.CHK.DIR1,CHK.DIR.ERROR1)
    IF NOT(R.CHK.DIR1) THEN
        RETURN
    END

    SEL.LIST = R.CHK.DIR1;
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
