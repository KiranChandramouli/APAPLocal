* @ValidationCode : MjoxMTU3NzQ0MDY5OkNwMTI1MjoxNjgyMzMxMzIyMTE3OklUU1M6LTE6LTE6NjI4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 628
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ENQ.NUM.DC.A.TXT

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
    Y.DECIMAL =FIELD(O.DATA,".",2)
    GOSUB PROCESO

    Y.TEXTO = Y.FINAL
    IF Y.DECIMAL GT 0 THEN
        Y.NUMERO = Y.DECIMAL[1,2]

        GOSUB PROCESO
        O.DATA = CHANGE(TRIM(Y.TEXTO),"CERO", " ") : " PUNTO " : TRIM(Y.FINAL)
        O.DATA = CHANGE(O.DATA, "PUNTO UNO", "PUNTO DIEZ")
        O.DATA = CHANGE(O.DATA, "PUNTO DOS", "PUNTO VEINTE")
        O.DATA = CHANGE(O.DATA, "PUNTO TRES", "PUNTO TREINTA")
        O.DATA = CHANGE(O.DATA, "PUNTO CUATRO", "PUNTO CUARENTA")
        O.DATA = CHANGE(O.DATA, "PUNTO CINCO", "PUNTO CINCUENTA")
        O.DATA = CHANGE(O.DATA, "PUNTO SEIS", "PUNTO SESENTA")
        O.DATA = CHANGE(O.DATA, "PUNTO SIETE", "PUNTO SETENTA")
        O.DATA = CHANGE(O.DATA, "PUNTO OCHO", "PUNTO OCHENTA")
        O.DATA = CHANGE(O.DATA, "PUNTO NUEVE", "PUNTO NOVENTA")

        RETURN
    END ELSE
        O.DATA = CHANGE(TRIM(Y.FINAL),"CERO"," ")
        RETURN
    END

*************************************
PROCESO:
    BEGIN CASE

        CASE Y.NUMERO EQ "0"
            Y.NUMERO.TEXTO = "CERO"
        CASE Y.NUMERO EQ "01"
            IF Y.NUMERO[1,1] EQ "0" THEN
                Y.NUMERO.TEXTO = "CERO UNO "
            END ELSE
                Y.NUMERO.TEXTO="UNO "
            END
        CASE Y.NUMERO EQ "02"
            IF Y.NUMERO[1,1] EQ "0" THEN
                Y.NUMERO.TEXTO = "CERO DOS "
            END ELSE
                Y.NUMERO.TEXTO="DOS "
            END
        CASE Y.NUMERO EQ "03"
            IF Y.NUMERO[1,1] EQ "0" THEN
                Y.NUMERO.TEXTO = "CERO TRES "
            END ELSE
                Y.NUMERO.TEXTO="TRES "
            END
        CASE Y.NUMERO EQ "04"
            IF Y.NUMERO[1,1] EQ "0" THEN
                Y.NUMERO.TEXTO = "CERO CUATRO "
            END ELSE
                Y.NUMERO.TEXTO="CUATRO "
            END
        CASE Y.NUMERO EQ "05"
            IF Y.NUMERO[1,1] EQ "0" THEN
                Y.NUMERO.TEXTO = "CERO CINCO "
            END ELSE
                Y.NUMERO.TEXTO="CINCO "
            END
        CASE Y.NUMERO EQ "06"
            IF Y.NUMERO[1,1] EQ "0" THEN
                Y.NUMERO.TEXTO = "CERO SEIS "
            END ELSE
                Y.NUMERO.TEXTO="SEIS "
            END
        CASE Y.NUMERO EQ "07"
            IF Y.NUMERO[1,1] EQ "0" THEN
                Y.NUMERO.TEXTO = "CERO SIETE "
            END ELSE
                Y.NUMERO.TEXTO="SIETE "
            END
        CASE Y.NUMERO EQ "08"
            IF Y.NUMERO[1,1] EQ "0" THEN
                Y.NUMERO.TEXTO = "CERO OCHO "
            END ELSE
                Y.NUMERO.TEXTO="OCHO "
            END
        CASE Y.NUMERO EQ "09"
            IF Y.NUMERO[1,1] EQ "0" THEN
                Y.NUMERO.TEXTO = "CERO NUEVE "
            END ELSE
                Y.NUMERO.TEXTO="NUEVE "
            END

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
    END CASE

    Y.FINAL = Y.RESULTADO : Y.NUMERO.TEXTO

RETURN

END
