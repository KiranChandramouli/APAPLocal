* @ValidationCode : MjotODk3NjE2NTM6Q3AxMjUyOjE2ODIzMzU5NDU1NjY6SVRTUzotMTotMTotMjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -20
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                BP REMOVED, VM TO @VM , FM TO @FM, I TO I.VAR
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
SUBROUTINE L.APAP.VERIF.CEDULA.RT(Y.CEDULA,OUT.ARR)
*--------------------------------------------------------------------------------------------------------
* Date              Author                      Description
* ==========        ====================        ============
* 2018-04-25        REQUERIMIENTO T.I. C.C.     VALIDA EL DIGITO VERIFICADOR DE CEDULA DOMINICANA.
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE ;* AUTO R22 CODE CONVERSION END

    GOSUB INITIAL
    GOSUB FIRST.VAL

RETURN

INITIAL:
    Y.VERIFICADOR = 0; Y.DIGITO = 0; Y.DIGITO.VER = 0; Y.DIGITO.IMPAR = 0; Y.SUMA.PAR = 0; Y.SUMA.IMPAR = 0;
    Y.SP.SI = 0; OUT.ARR = ''
    Y.CEDULA.MOD = CHANGE(Y.CEDULA,'-','')

    Y.CEDULA.LEN = LEN(Y.CEDULA.MOD)
RETURN

FIRST.VAL:
    IF Y.CEDULA.LEN EQ 11 THEN
        Y.DIGITO.VER = Y.CEDULA.MOD[11,1]

        FOR I.VAR = 10 TO 1 STEP -1
            Y.DIGITO = Y.CEDULA.MOD[I.VAR,1]
            IF MOD((I.VAR-1),2) NE 0 THEN
                Y.DIGITO.IMPAR = Y.DIGITO * 2
*CRT "impar: " : Y.DIGITO.IMPAR
                IF Y.DIGITO.IMPAR GE 10 THEN
                    Y.DIGITO.IMPAR -= 9
*CRT "impar >=: " : Y.DIGITO.IMPAR
                END
                Y.SUMA.IMPAR += Y.DIGITO.IMPAR
*CRT "suma-impar: " : Y.SUMA.IMPAR
            END ELSE
                Y.SUMA.PAR += Y.DIGITO
*CRT "suma-par: " : Y.SUMA.PAR
            END

        NEXT I.VAR
*CRT "suma impar: " : Y.SUMA.IMPAR
*CRT "suma par: " : Y.SUMA.PAR
        Y.SP.SI = Y.SUMA.PAR + Y.SUMA.IMPAR
        Y.VERIFICADOR = 10 - MOD(Y.SP.SI,10)

*SI Y.VERIFICADOR = 10 & Y.DIGITO.VER = 0 : VERDADERO
*O SI Y.VERIFICADOR = Y.DIGITO.VER : VERDADERO
        IF (Y.VERIFICADOR EQ 10 AND Y.DIGITO.VER EQ 0) OR (Y.VERIFICADOR EQ Y.DIGITO.VER) THEN
*CEDULA VALIDA
            OUT.ARR = Y.CEDULA.MOD : @FM : "1" :@FM : "CEDULA VALIDA."
        END ELSE
            OUT.ARR = Y.CEDULA.MOD : @FM : "-1" :@FM : "CEDULA NO VALIDA."
        END
    END ELSE
*SI LLEGAMOS ACA, ES PORQUE EL ARGUMENTO NO POSEE 11 DIGITOS LUEGO DE REMOVER LOS GUIONES
        OUT.ARR = Y.CEDULA.MOD : @FM : "-1" :@FM : "CEDULA NO VALIDA."

    END
RETURN



END
