SUBROUTINE REDO.S.FC.AA.GUAR.NAME(AA.ID, AA.ARR)
*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value of AA.ARR.TERM.AMOUNT>L.COL.GUAR.NAME  FIELD
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
    $INSERT I_F.COLLATERAL

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
*Y.TEMP = 0

    IF Y.REV.RT.TYPE.POS GT 0 THEN
        CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARRG.ID, PROPERTY.CLASS,'','', RET.IDS, INT.COND, RET.ERR)
        ID.COLLATERAL = INT.COND<1,AA.AMT.LOCAL.REF,Y.REV.RT.TYPE.POS>    ;* This hold the Value in the local field
        IF NOT(ID.COLLATERAL) THEN
            AA.ARR = 'NULO'
        END ELSE
            LOC.REF.APPL="COLLATERAL"
            LOC.REF.FIELDS="L.COL.GUAR.NAME"
            CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
            POS.GUAR.NAME = LOC.REF.POS<1,1>
            NRO.COLL = DCOUNT(ID.COLLATERAL,@VM)
            FOR I.VAR=1 TO NRO.COLL
                CALL F.READ(FN.COLLATERAL,ID.COLLATERAL<I.VAR>,R.COLLATERAL,F.COLLATERAL,"")
                IF NOT(R.COLLATERAL) THEN
                    AA.ARR = 'NULO'
                END ELSE
                    IF AA.ARR THEN
                        AA.ARR := "#"
                    END
                    AA.ARR := R.COLLATERAL<COLL.LOCAL.REF,POS.GUAR.NAME>
                END
            NEXT
            IF NOT(AA.ARR) THEN
                AA.ARR = 'NULO'
            END

        END

    END ELSE
        AA.ARR = 'NO.EXISTE'
    END
RETURN
*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    Y.ARRG.ID = AA.ID
    PROPERTY.CLASS = 'TERM.AMOUNT'
    LOC.REF.APPL="AA.ARR.TERM.AMOUNT"
    LOC.REF.FIELDS="L.AA.COL"
    FN.COLLATERAL = "F.COLLATERAL"
    F.COLLATERAL = ""
    R.COLLATERAL = ""
    LOC.REF.POS=" "
    AA.ARR = ""
RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)

RETURN
*------------
END
