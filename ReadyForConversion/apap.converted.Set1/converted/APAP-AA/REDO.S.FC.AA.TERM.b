SUBROUTINE REDO.S.FC.AA.TERM(AA.ID, AA.ARR)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value of AA.ARR.TERM.AMOUNT>TERM field
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
    $INSERT I_F.AA.TERM.AMOUNT

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
    ID.TERM.AMOUNT = AA.ID:'-COMMITMENT-':Y.START.DATE:'.1'
    CALL F.READ(FN.AA.ARR.TERM.AMOUNT,ID.TERM.AMOUNT,R.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT,"")
    IF R.AA.ARR.TERM.AMOUNT THEN
        AA.ARR = R.AA.ARR.TERM.AMOUNT<AA.AMT.TERM>
    END
RETURN
*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    Y.START.DATE = AA.ARR<AA.ARR.START.DATE>
    AA.ARR = 'NULO'
RETURN

*------------------------
OPEN.FILES:
*=========
    FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'
    F.AA.ARR.TERM.AMOUNT = ''
    R.AA.ARR.TERM.AMOUNT = ''
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)

RETURN
*------------
END
