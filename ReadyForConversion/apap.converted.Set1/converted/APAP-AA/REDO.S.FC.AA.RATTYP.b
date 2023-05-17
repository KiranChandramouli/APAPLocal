SUBROUTINE REDO.S.FC.AA.RATTYP(AA.ID, AA.ARR)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value of AA.ARR.INTEREST>L.AA.REV.RT.TY  field
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
    $INSERT I_F.AA.INTEREST

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    Y.REV.RT.TYPE.POS = LOC.REF.POS<1,1>

    IF Y.REV.RT.TYPE.POS GT 0 THEN
        CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARRG.ID, PROPERTY.CLASS,'','', RET.IDS, INT.COND, RET.ERR)
        AA.ARR = INT.COND<AA.INT.LOCAL.REF,Y.REV.RT.TYPE.POS,1> ;* This hold the Value in the local field
    END
RETURN
*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    Y.ARRG.ID = AA.ID
    PROPERTY.CLASS = 'INTEREST'
    LOC.REF.APPL="AA.ARR.INTEREST"
    LOC.REF.FIELDS="L.AA.REV.RT.TY"
    LOC.REF.POS=" "
    AA.ARR = 'NULO'
RETURN
*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
