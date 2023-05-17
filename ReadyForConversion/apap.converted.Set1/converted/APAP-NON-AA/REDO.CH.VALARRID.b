SUBROUTINE REDO.CH.VALARRID
**
* Subroutine Type : VERSION
* Attached to     : EB.EXTERNAL.USER,REDO.USER.AUTH
* Attached as     : AUTH.ROUTINE
* Primary Purpose : Validate an AA Arrangement ID is assigned before authorize
*                   the Channel User
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 1/11/10 - First Version
*           ODR Reference: ODR-2010-06-0155
*           Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP)
*           Roberto Mondragon - TAM Latin America
*           rmondragon@temenos.com
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.EB.EXTERNAL.USER

    ARR = ""
    E = ""

    ARR = R.NEW(EB.XU.ARRANGEMENT)

    IF ARR EQ "" THEN
        E = "Arreglo no asignado a este usuario. Por favor esperar la asignacion para autorizar."
    END

RETURN

END
