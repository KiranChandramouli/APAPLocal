* @ValidationCode : MjoxMzQ0ODgxMjQxOkNwMTI1MjoxNjgyMzMxMzIxOTc3OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ENQ.MES.A.TEXTO

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion      = to EQ, BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    Y.NUMERO = O.DATA

    BEGIN CASE

        CASE Y.NUMERO EQ 1
            Y.MES.TEXTO = "ENERO"
        CASE Y.NUMERO EQ 2
            Y.MES.TEXTO = "FEBRERO"
        CASE Y.NUMERO EQ 3
            Y.MES.TEXTO = "MARZO"
        CASE Y.NUMERO EQ 4
            Y.MES.TEXTO = "ABRIL"
        CASE Y.NUMERO EQ 5
            Y.MES.TEXTO = "MAYO"
        CASE Y.NUMERO EQ 6
            Y.MES.TEXTO = "JUNIO"
        CASE Y.NUMERO EQ 7
            Y.MES.TEXTO = "JULIO"
        CASE Y.NUMERO EQ 8
            Y.MES.TEXTO = "AGOSTO"
        CASE Y.NUMERO EQ 9
            Y.MES.TEXTO = "SEPTIEMBRE"
        CASE Y.NUMERO EQ 10
            Y.MES.TEXTO = "OCTUBRE"
        CASE Y.NUMERO EQ 11
            Y.MES.TEXTO = "NOVIEMBRE"
        CASE Y.NUMERO EQ 12
            Y.MES.TEXTO = "DICIEMBRE"

    END CASE

    O.DATA = Y.MES.TEXTO

RETURN

END
