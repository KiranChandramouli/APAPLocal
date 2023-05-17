SUBROUTINE REDO.SET.FIELDS
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.SET.FIELDS
* Attached as     : ROUTINE
* Primary Purpose : Set default values for multivalues fields.
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
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            : 29/07/2011
*
*-----------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS


    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END


RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
    VAR.POL    = R.NEW(INS.DET.MON.POL.AMT)
    VAR.FILAS  = DCOUNT(VAR.POL,@VM)

*Cambio el SM pof FM File Market para pode recorrer los registros
    VAR.REGISTRO1 = CHANGE(VAR.POL,@VM,@FM)
    VAR.VALOR     = VAR.REGISTRO1<1>

    FOR VAR.I = 2 TO VAR.FILAS
        VAR.AUX = VAR.REGISTRO1<VAR.I>
        IF VAR.AUX EQ '' THEN
            VAR.REGISTRO1<VAR.I> = VAR.VALOR
        END
    NEXT

    VAR.REGISTRO1 = CHANGE(VAR.REGISTRO1,@FM,@VM)
    R.NEW(INS.DET.MON.POL.AMT) = VAR.REGISTRO1


*FOR CHARGE
    VAR.POL    = R.NEW(INS.DET.CHARGE)
    VAR.FILAS  = DCOUNT(VAR.POL,@VM)

*Change the SM for FM File Market for get informtion file
    VAR.REGISTRO1 = CHANGE(VAR.POL,@VM,@FM)
    VAR.VALOR     = VAR.REGISTRO1<1>

    FOR VAR.I = 2 TO VAR.FILAS
        VAR.AUX = VAR.REGISTRO1<VAR.I>
        IF VAR.AUX EQ '' THEN
            VAR.REGISTRO1<VAR.I> = VAR.VALOR
        END
    NEXT

    VAR.REGISTRO1 = CHANGE(VAR.REGISTRO1,@FM,@VM)
    R.NEW(INS.DET.CHARGE) = VAR.REGISTRO1

RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
*incializacion de variables

RETURN

*------------------------
OPEN.FILES:
*=========
*Abrir archivos

RETURN
*------------
END
