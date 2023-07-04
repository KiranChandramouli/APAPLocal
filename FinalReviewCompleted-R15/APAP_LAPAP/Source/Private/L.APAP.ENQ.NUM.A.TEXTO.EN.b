* @ValidationCode : MjoxMzA2MDQ3OTE6Q3AxMjUyOjE2ODIzMzEzMjIwMzg6SVRTUzotMTotMTo2NjM6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
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
SUBROUTINE L.APAP.ENQ.NUM.A.TEXTO.EN
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       > to GT, < to LT, -- to -=, BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON ;*R22 Auto conversion - END

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
        O.DATA = TRIM(Y.TEXTO) : " POINT " : TRIM(Y.FINAL)
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
                Y.NUMERO.TEXTO = "ONE "
            END ELSE
                Y.NUMERO.TEXTO="ONE "
            END

        CASE Y.NUMERO EQ 2
            Y.NUMERO.TEXTO = "TWO "

        CASE Y.NUMERO EQ 3
            Y.NUMERO.TEXTO = "THREE "

        CASE Y.NUMERO EQ 4
            Y.NUMERO.TEXTO = "FOUR "

        CASE Y.NUMERO EQ 5
            Y.NUMERO.TEXTO = "FIVE "

        CASE Y.NUMERO EQ 6
            Y.NUMERO.TEXTO = "SIX "

        CASE Y.NUMERO EQ 7
            Y.NUMERO.TEXTO = "SEVEN "

        CASE Y.NUMERO EQ 8
            Y.NUMERO.TEXTO = "EIGHT "

        CASE Y.NUMERO EQ 9
            Y.NUMERO.TEXTO = "NINE "

        CASE Y.NUMERO EQ 10
            Y.NUMERO.TEXTO = "TEN "

        CASE Y.NUMERO EQ 11
            Y.NUMERO.TEXTO = "ELEVEN "

        CASE Y.NUMERO EQ 12
            Y.NUMERO.TEXTO = "TWELVE "

        CASE Y.NUMERO EQ 13
            Y.NUMERO.TEXTO = "THIRTEEN "

        CASE Y.NUMERO EQ 14
            Y.NUMERO.TEXTO = "FOURTEEN "

        CASE Y.NUMERO EQ 15
            Y.NUMERO.TEXTO = "FIFTEEN "

        CASE Y.NUMERO LT 20
            Y.NUMERO -= 10
            GOSUB PROCESO
            Y.NUMERO.TEXTO = Y.NUMERO.TEXTO : "TEEN"

        CASE Y.NUMERO EQ 20
            Y.NUMERO.TEXTO = "TWENTY "

        CASE Y.NUMERO LT 30
            Y.NUMERO -= 20
            GOSUB PROCESO
            Y.NUMERO.TEXTO = "TWENTY" : Y.NUMERO.TEXTO

        CASE Y.NUMERO EQ 30
            Y.NUMERO.TEXTO = "THIRTY "

        CASE Y.NUMERO EQ 40
            Y.NUMERO.TEXTO = "FOURTY "

        CASE Y.NUMERO EQ 50
            Y.NUMERO.TEXTO = "FIFTY "

        CASE Y.NUMERO EQ 60
            Y.NUMERO.TEXTO = "SIXTY "

        CASE Y.NUMERO EQ 70
            Y.NUMERO.TEXTO = "SEVENTY "

        CASE Y.NUMERO EQ 80
            Y.NUMERO.TEXTO = "EIGHTY "

        CASE Y.NUMERO EQ 90
            Y.NUMERO.TEXTO = "NINETY "

        CASE Y.NUMERO LT 100

            Y.NUMERO.CENTENA = Y.NUMERO
            Y.NUMERO=INT(Y.NUMERO/10)*10
            GOSUB PROCESO

            Y.RESULTADO = Y.RESULTADO : Y.NUMERO.TEXTO : "AND "

            Y.NUMERO=MOD(Y.NUMERO.CENTENA,10)

            IF Y.NUMERO GT 0 THEN
                GOSUB PROCESO
            END ELSE
                Y.NUMERO.TEXTO = ""
            END

        CASE Y.NUMERO EQ 100

            Y.NUMERO.TEXTO = "ONE HUNDRED "

        CASE Y.NUMERO LT 200

            Y.RESULTADO = Y.RESULTADO : "ONE HUNDRED "
            Y.NUMERO -= 100
            GOSUB PROCESO

        CASE Y.NUMERO EQ 200 OR Y.NUMERO EQ 300 OR Y.NUMERO EQ 400 OR Y.NUMERO EQ 600 OR Y.NUMERO EQ 800
            Y.NUMERO=INT(Y.NUMERO/100)
            GOSUB PROCESO
            Y.NUMERO.TEXTO = TRIM(Y.NUMERO.TEXTO) : " HUNDRED " :

        CASE Y.NUMERO EQ 500

            Y.NUMERO.TEXTO = "FIVE HUNDRED "

        CASE Y.NUMERO EQ 700

            Y.NUMERO.TEXTO = "SEVEN HUNDRED "

        CASE Y.NUMERO EQ 900

            Y.NUMERO.TEXTO = "NINE HUNDRED "

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

            Y.NUMERO.TEXTO="ONE THOUSAND"

        CASE Y.NUMERO LT 2000
            Y.RESULTADO = Y.RESULTADO :  "ONE THOUSAND "
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
            Y.RESULTADO = Y.RESULTADO : Y.NUMERO.TEXTO : " THOUSAND "

            Y.NUMERO = MOD(Y.NUMERO.UND.MILLON,1000)

            IF Y.NUMERO GT 0 THEN
                GOSUB PROCESO
            END ELSE
                Y.NUMERO.TEXTO = ""
            END

        CASE Y.NUMERO EQ 1000000
            Y.NUMERO.TEXTO= "ONE MILLION"

        CASE Y.NUMERO LT 2000000
            Y.NUMERO=MOD(Y.NUMERO,1000000)

            IF Y.NUMERO GT 0 THEN
                GOSUB PROCESO
            END ELSE
                Y.NUMERO.TEXTO = ""
            END

            Y.RESULTADO = "ONE MILLION " : Y.RESULTADO

        CASE Y.NUMERO LT 1000000000000
            Y.NUMERO.UND.BILLON = Y.NUMERO
            Y.NUMERO=INT(Y.NUMERO/1000000)
            GOSUB PROCESO

            Y.RESULTADO = Y.RESULTADO : Y.NUMERO.TEXTO : " MILLIONS "
            Y.NUMERO = (Y.NUMERO.UND.BILLON-INT(Y.NUMERO.UND.BILLON/1000000)*1000000)
            GOSUB PROCESO

    END CASE

    Y.FINAL = Y.RESULTADO : Y.NUMERO.TEXTO

RETURN

END
