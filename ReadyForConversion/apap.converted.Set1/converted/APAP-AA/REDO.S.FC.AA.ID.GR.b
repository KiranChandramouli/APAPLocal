SUBROUTINE REDO.S.FC.AA.ID.GR(AA.ID, AA.ARR)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.FC.ENQPARMS
* Attached as     : ROUTINE
* Primary Purpose : GET THE NUMBER OF DOC ENTER IN THE SELECTION CRITERIA OF ENQUIRY
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
* Development by  : Bryan Torres- TAM Latin America
* Date            : 9/27/2001
*
*-----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON




    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======



    LOCATE 'NRO.DOC' IN D.FIELDS<1> SETTING Y.CAT.POS THEN

        AA.ARR =D.RANGE.AND.VALUE<Y.CAT.POS>

    END

RETURN
*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1


RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
