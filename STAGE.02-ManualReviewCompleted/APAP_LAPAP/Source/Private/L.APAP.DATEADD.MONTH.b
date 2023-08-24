* @ValidationCode : MjotODIyOTIyMDgxOkNwMTI1MjoxNjgyMzMxMzIxMTg5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
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
SUBROUTINE L.APAP.DATEADD.MONTH (Y.NUM.MONTH,Y.FECHA)
*-----------------------------------------------------------------------------
*
* Developed By            : BY APAP
*
* Developed On            : 19-DIC-2018
* Development Description : Esta rutina recibe una fecha como parametro en formato YYYYMMDD y el mes y retorna la fecha siguiente
*                           sumandole la cantidad de meses enviado en la variable Y.NUM.MONTH
**-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       ++ to +=, BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion
    $INSERT I_EQUATE ;*R22 Auto conversion

    Y.DATE =  Y.FECHA[1,4]
    Y.DATE1 = Y.FECHA[5,2]
    Y.DATE3 = Y.FECHA[7,2]
    IF Y.DATE1 EQ 12 THEN
        Y.DATE1 = '1'
        Y.DATE += 1
    END ELSE
        Y.DATE1 += Y.NUM.MONTH
    END
    IF LEN(Y.DATE1) EQ 1 THEN
        Y.DATE1 = "0":Y.DATE1
    END
    Y.FECHA.FINAL = Y.DATE:Y.DATE1:Y.DATE3
    Y.FECHA = Y.FECHA.FINAL
RETURN

END
