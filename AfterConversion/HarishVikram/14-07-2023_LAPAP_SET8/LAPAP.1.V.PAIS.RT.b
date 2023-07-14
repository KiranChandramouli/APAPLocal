* @ValidationCode : MjotNzQzNzgxNjM1OkNwMTI1MjoxNjg5MzE0MzU0Njg2OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 14 Jul 2023 11:29:14
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
SUBROUTINE LAPAP.1.V.PAIS.RT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ST.LAPAP.MOD.DIRECCIONES

    Y.VALUE = COMI

    IF Y.VALUE EQ '' THEN
        ETEXT = 'ESTE CAMPO ES MANDATORIO'
        CALL STORE.END.ERROR
    END

END
