* @ValidationCode : MjoxMjcyODE5MjM4OkNwMTI1MjoxNjgyMzMxMzIxOTkyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
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
SUBROUTINE L.APAP.ENQ.MES.A.TEXTO2

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       = to EQ, BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON ;*R22 Auto conversion - END

    Y.NUMERO = O.DATA

    BEGIN CASE

        CASE Y.NUMERO EQ 1
            Y.MES.TEXTO = "Enero"
        CASE Y.NUMERO EQ 2
            Y.MES.TEXTO = "Febrero"
        CASE Y.NUMERO EQ 3
            Y.MES.TEXTO = "Marzo"
        CASE Y.NUMERO EQ 4
            Y.MES.TEXTO = "Abril"
        CASE Y.NUMERO EQ 5
            Y.MES.TEXTO = "Mayo"
        CASE Y.NUMERO EQ 6
            Y.MES.TEXTO = "Junio"
        CASE Y.NUMERO EQ 7
            Y.MES.TEXTO = "Julio"
        CASE Y.NUMERO EQ 8
            Y.MES.TEXTO = "Agosto"
        CASE Y.NUMERO EQ 9
            Y.MES.TEXTO = "Septiembre"
        CASE Y.NUMERO EQ 10
            Y.MES.TEXTO = "Octubre"
        CASE Y.NUMERO EQ 11
            Y.MES.TEXTO = "Noviembre"
        CASE Y.NUMERO EQ 12
            Y.MES.TEXTO = "Diciembre"

    END CASE

    O.DATA = Y.MES.TEXTO

RETURN

END
