SUBROUTINE REDO.S.FC.AA.PRODUCT(AA.ID, AA.ARR)
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
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.PRODUCT

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
    CALL CACHE.READ(FN.AA.PRODUCT, Y.PROD.ID, R.AA.PRODUCT, "")
    AA.ARR=R.AA.PRODUCT<AA.PDT.DESCRIPTION>
RETURN
*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    Y.ARRG.ID = AA.ID
    Y.PROD.ID = AA.ARR<AA.ARR.PRODUCT>
    FN.AA.PRODUCT = 'F.AA.PRODUCT'
    F.AA.PRODUCT = ''
    R.AA.PRODUCT = ''
    AA.ARR = 'NULO'
RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.AA.PRODUCT,F.AA.PRODUCT)
RETURN
*------------
END
