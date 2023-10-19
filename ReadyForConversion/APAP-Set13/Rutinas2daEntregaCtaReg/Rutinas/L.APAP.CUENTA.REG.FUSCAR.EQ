*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.CUENTA.REG.FUSCAR.EQ
*-----------------------------------------------------------------------------
* Proposito: Identifica si la cuenta corresponde a una cuenta de cliente o interna.
* Parametro de entrada: TT o FT de la transaccion
* Parametro de salida: Cuenta regional debito o credito con el formato 1234********************5678

    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INSERT T24.BP I_ENQUIRY.COMMON

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
