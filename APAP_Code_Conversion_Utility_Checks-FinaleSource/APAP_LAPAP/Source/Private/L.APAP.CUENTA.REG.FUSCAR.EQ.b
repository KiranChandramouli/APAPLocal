* @ValidationCode : MjoxMDU5Mjk2MDY5OkNwMTI1MjoxNjk4MDQyNDkzNzIxOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 Oct 2023 11:58:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*19/10/2023         Suresh                 R22 Manual Conversion          T24.BP FILE REMOVED
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.CUENTA.REG.FUSCAR.EQ
*-----------------------------------------------------------------------------
* Proposito: Identifica si la cuenta corresponde a una cuenta de cliente o interna.
* Parametro de entrada: TT o FT de la transaccion
* Parametro de salida: Cuenta regional debito o credito con el formato 1234********************5678

    $INSERT I_COMMON ;*R22 Manual Conversion - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON ;*R22 Manual Conversion - END

    Y.CUENTA.REGIONAL = '' ; Y.CUENTA.REGIONAL = O.DATA;
    GOSUB GET.ACCOUNT.REG
RETURN


GET.ACCOUNT.REG:

    Y.CUENTA.REGIONAL = TRIM(Y.CUENTA.REGIONAL)
    Y.LONGITUD = LEN(Y.CUENTA.REGIONAL)
    Y.VALOR.INICIAR = Y.CUENTA.REGIONAL[1,4]
    Y.LONGITUD2 = Y.CUENTA.REGIONAL[5,(Y.LONGITUD-4)]
    Y.VALOR.MEDIO = Y.CUENTA.REGIONAL[5,LEN(Y.LONGITUD2)-4]
    Y.VALOR.FINAL = Y.CUENTA.REGIONAL[(Y.LONGITUD - 3 ),Y.LONGITUD]
**-----------------------------RELLENAR CON * LA POSICION DEL MEDIO
    FOR I =  1 TO LEN(Y.VALOR.MEDIO)
        Y.MASK:= "*"
    NEXT I
    O.DATA = Y.VALOR.INICIAR : Y.MASK : Y.VALOR.FINAL
RETURN

END
