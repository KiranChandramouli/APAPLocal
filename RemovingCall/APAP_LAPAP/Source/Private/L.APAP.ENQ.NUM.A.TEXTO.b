* @ValidationCode : Mjo5ODQ5NTQzODY6Q3AxMjUyOjE2ODIzMzEzMjIwNzA6SVRTUzotMTotMTo2NjM6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 663
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ENQ.NUM.A.TEXTO

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       = to EQ, > to GT, < to LT, -- to -=, BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB INICIO

RETURN


INICIO:
*************************************

    Y.NUMERO.DECENA = ""
    Y.NUMERO.CENTENA = ""
    Y.NUMERO.UND.MIL = ""
    Y.NUMERO.UND.MILLON = ""
    Y.NUMERO.UND.BILLON = ""
    Y.NUMERO.TEXTO = ""
    Y.RESULTADO = ""
    Y.FINAL = ""
    Y.TEXTO = ""
    Y.DECIMAL = ""
    Y.NUMERO = ""

    Y.NUMERO = FIELD(O.DATA,".",1)
    Y.DECIMAL =INT(FIELD(O.DATA,".",2))
    GOSUB PROCESO

    Y.TEXTO = Y.FINAL

    IF Y.DECIMAL GT 0 THEN
        Y.NUMERO = Y.DECIMAL[1,2]

        GOSUB PROCESO
        O.DATA = TRIM(Y.TEXTO) : " PUNTO " : TRIM(Y.FINAL)
        RETURN
    END ELSE
        O.DATA = TRIM(Y.FINAL)
        RETURN
    END

*************************************

PROCESO:
    BEGIN CASE

        CASE Y.NUMERO EQ 0
            Y.NUMERO.TEXTO = ""

        CASE Y.NUMERO EQ 1

            IF Y.RESULTADO NE "" THEN
                Y.NUMERO.TEXTO = "UN "
            END ELSE
                Y.NUMERO.TEXTO="UNO "
            END

        CASE Y.NUMERO EQ 2
            Y.NUMERO.TEXTO = "DOS "

        CASE Y.NUMERO EQ 3
            Y.NUMERO.TEXTO = "TRES "

        CASE Y.NUMERO EQ 4
            Y.NUMERO.TEXTO = "CUATRO "

        CASE Y.NUMERO EQ 5
            Y.NUMERO.TEXTO = "CINCO "

        CASE Y.NUMERO EQ 6
            Y.NUMERO.TEXTO = "SEIS "

        CASE Y.NUMERO EQ 7
            Y.NUMERO.TEXTO = "SIETE "

        CASE Y.NUMERO EQ 8
            Y.NUMERO.TEXTO = "OCHO "

        CASE Y.NUMERO EQ 9
            Y.NUMERO.TEXTO = "NUEVE "

        CASE Y.NUMERO EQ 10
            Y.NUMERO.TEXTO = "DIEZ "

        CASE Y.NUMERO EQ 11
            Y.NUMERO.TEXTO = "ONCE "

        CASE Y.NUMERO EQ 12
            Y.NUMERO.TEXTO = "DOCE "

        CASE Y.NUMERO EQ 13
            Y.NUMERO.TEXTO = "TRECE "

        CASE Y.NUMERO EQ 14
            Y.NUMERO.TEXTO = "CATORCE "

        CASE Y.NUMERO EQ 15
            Y.NUMERO.TEXTO = "QUINCE "

        CASE Y.NUMERO LT 20
            Y.NUMERO -= 10
            GOSUB PROCESO
            Y.NUMERO.TEXTO = "DIECI" : Y.NUMERO.TEXTO

        CASE Y.NUMERO EQ 20
            Y.NUMERO.TEXTO = "VEINTE "

        CASE Y.NUMERO LT 30
            Y.NUMERO -= 20
            GOSUB PROCESO
            Y.NUMERO.TEXTO = "VEINTI" : Y.NUMERO.TEXTO

        CASE Y.NUMERO EQ 30
            Y.NUMERO.TEXTO = "TREINTA "

        CASE Y.NUMERO EQ 40
            Y.NUMERO.TEXTO = "CUARENTA "

        CASE Y.NUMERO EQ 50
            Y.NUMERO.TEXTO = "CINCUENTA "

        CASE Y.NUMERO EQ 60
            Y.NUMERO.TEXTO = "SESENTA "

        CASE Y.NUMERO EQ 70
            Y.NUMERO.TEXTO = "SETENTA "

        CASE Y.NUMERO EQ 80
            Y.NUMERO.TEXTO = "OCHENTA "

        CASE Y.NUMERO EQ 90
            Y.NUMERO.TEXTO = "NOVENTA "

        CASE Y.NUMERO LT 100

            Y.NUMERO.CENTENA = Y.NUMERO
            Y.NUMERO=INT(Y.NUMERO/10)*10
            GOSUB PROCESO

            Y.RESULTADO = Y.RESULTADO : Y.NUMERO.TEXTO : "Y "

            Y.NUMERO=MOD(Y.NUMERO.CENTENA,10)

            IF Y.NUMERO GT 0 THEN
                GOSUB PROCESO
            END ELSE
                Y.NUMERO.TEXTO = ""
            END

        CASE Y.NUMERO EQ 100

            Y.NUMERO.TEXTO = "CIEN "

        CASE Y.NUMERO LT 200

            Y.RESULTADO = Y.RESULTADO : "CIENTO "
            Y.NUMERO -= 100
            GOSUB PROCESO

        CASE Y.NUMERO EQ 200 OR Y.NUMERO EQ 300 OR Y.NUMERO EQ 400 OR Y.NUMERO EQ 600 OR Y.NUMERO EQ 800
            Y.NUMERO=INT(Y.NUMERO/100)
            GOSUB PROCESO
            Y.NUMERO.TEXTO = TRIM(Y.NUMERO.TEXTO) : "CIENTOS " :

        CASE Y.NUMERO EQ 500

            Y.NUMERO.TEXTO = "QUINIENTOS "

        CASE Y.NUMERO EQ 700

            Y.NUMERO.TEXTO = "SETECIENTOS "

        CASE Y.NUMERO EQ 900

            Y.NUMERO.TEXTO = "NOVECIENTOS "

        CASE Y.NUMERO LT 1000

            Y.NUMERO.UND.MIL = Y.NUMERO
            Y.NUMERO=INT(Y.NUMERO/100)*100
            GOSUB PROCESO

            Y.RESULTADO = Y.RESULTADO : Y.NUMERO.TEXTO
            Y.NUMERO = MOD(Y.NUMERO.UND.MIL,100)

            IF Y.NUMERO GT 0 THEN
                GOSUB PROCESO
            END ELSE
                Y.NUMERO.TEXTO = ""
            END

        CASE Y.NUMERO EQ 1000

            Y.NUMERO.TEXTO="MIL"

        CASE Y.NUMERO LT 2000
            Y.RESULTADO = Y.RESULTADO :  "MIL "
            Y.NUMERO= MOD(Y.NUMERO,1000)

            IF Y.NUMERO GT 0 THEN
                GOSUB PROCESO
            END ELSE
                Y.NUMERO.TEXTO = ""
            END

        CASE Y.NUMERO LT 1000000

            Y.NUMERO.UND.MILLON = Y.NUMERO
            Y.NUMERO = INT(Y.NUMERO/1000)
            GOSUB PROCESO
            Y.RESULTADO = Y.RESULTADO : Y.NUMERO.TEXTO : "MIL "

            Y.NUMERO = MOD(Y.NUMERO.UND.MILLON,1000)

            IF Y.NUMERO GT 0 THEN
                GOSUB PROCESO
            END ELSE
                Y.NUMERO.TEXTO = ""
            END

        CASE Y.NUMERO EQ 1000000
            Y.NUMERO.TEXTO= "UN MILLON"

        CASE Y.NUMERO LT 2000000
            Y.NUMERO=MOD(Y.NUMERO,1000000)

            IF Y.NUMERO GT 0 THEN
                GOSUB PROCESO
            END ELSE
                Y.NUMERO.TEXTO = ""
            END

            Y.RESULTADO = "UN MILLON " : Y.RESULTADO

        CASE Y.NUMERO LT 1000000000000
            Y.NUMERO.UND.BILLON = Y.NUMERO
            Y.NUMERO=INT(Y.NUMERO/1000000)
            GOSUB PROCESO

            Y.RESULTADO = Y.RESULTADO : Y.NUMERO.TEXTO : "MILLONES "
            Y.NUMERO = (Y.NUMERO.UND.BILLON-INT(Y.NUMERO.UND.BILLON/1000000)*1000000)
            GOSUB PROCESO

    END CASE

    Y.FINAL = Y.RESULTADO : Y.NUMERO.TEXTO

RETURN

END
