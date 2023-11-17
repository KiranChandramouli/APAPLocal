* @ValidationCode : Mjo1NDU0MjMxNTc6Q3AxMjUyOjE2ODQ0OTEwMzMzMjc6SVRTUzotMTotMTotMjU6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -25
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.FC.S.PAY.MTH

*
* Subroutine Type : ROUTINE
* Attached to     : VERSION REDO.CREATE.ARRANGEMENT,MANUAL.DI
* Attached as     : ROUTINE
* Primary Purpose : Validate the payment method
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            : Oct 18, 2011
*
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_GTS.COMMON

* ------------------------------------------------------------------------------------------
* PA20071025 Se debe ejecutar solo cuando es invocado desde el campo HOT.FIELD de la version
    CAMPO.ACTUAL = OFS$HOT.FIELD
    NOMBRE.CAMPO = "...PAYMT.MHD..."
    IF CAMPO.ACTUAL MATCH NOMBRE.CAMPO ELSE
        RETURN
    END
* Fin PA20071025
*-------------------


    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS.MAIN
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS.MAIN:
*============
    BEGIN CASE
        CASE YCOMI EQ "Debito Directo"
            R.NEW(REDO.FC.FORM) = ""

        CASE YCOMI EQ "Nomina Externa"
            R.NEW(REDO.FC.ACC.TO.DEBIT) = ""

    END CASE

RETURN
*------------------------
INITIALISE:
*=========

    YCOMI = COMI
    YERR = ''
    PROCESS.GOAHEAD = 1

RETURN
*------------------------

OPEN.FILES:
*=========

RETURN
*------------
END
