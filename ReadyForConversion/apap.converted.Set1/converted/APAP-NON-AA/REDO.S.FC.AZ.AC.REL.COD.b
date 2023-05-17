SUBROUTINE REDO.S.FC.AZ.AC.REL.COD(AC.ID, AC.REC)
*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose :
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* AA.ARR - data returned to the routine
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            :
*
*-----------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
    Y.AC.REL.COD = AC.REC<AC.RELATION.CODE>
    AC.REC = Y.AC.REL.COD
RETURN
*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    AC.REC = 'NULO'
RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
