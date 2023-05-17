SUBROUTINE REDO.FC.FILL.ACT
*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE AA.ARRANGEMENT.ACTIVITY,AA.NEW.FC
* Attached as     : CHECK.REC.RTN
* Primary Purpose : FILL THE FIELDS .. GETTING THE RCA QUEUE
*
* Incoming:
* ---------
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
* Development by  : mgudino - TAM Latin America
* Date            : 11 AGU 2011
*
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_System

    GOSUB INITIALISE

    IF PROCESS.GOAHEAD THEN
        GOSUB OPEN.FILES
        GOSUB PROCESS.MAIN
    END

RETURN  ;* Program RETURN

PROCESS.MAIN:
*============
    Y.ARR.ID = System.getVariable("CURRENT.RCA")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.ARR.ID = ""
    END

    CALL F.READ(FN.RCA.R.NEW, Y.ARR.ID, R.RCA, F.RCA.R.NEW, Y.ERR)
    IF Y.ERR NE "" THEN
        E = "EB-RECORD.NOT.FOUND":@FM:Y.ARR.ID
        CALL STORE.END.ERROR
        RETURN
    END

* MAPPING

    R.NEW(AA.ARR.ACT.PRODUCT) = R.RCA<REDO.FC.PRODUCT>
    R.NEW(AA.ARR.ACT.CUSTOMER) = R.RCA<REDO.FC.CUSTOMER>
    R.NEW(AA.ARR.ACT.ARRANGEMENT) = R.RCA<REDO.FC.ID.ARRANGEMENT>
    R.NEW(AA.ARR.ACT.CURRENCY) = R.RCA<REDO.FC.LOAN.CURRENCY>
    R.NEW(AA.ARR.ACT.ACTIVITY) = "LENDING-NEW-ARRANGEMENT"
    R.NEW(AA.ARR.ACT.EFFECTIVE.DATE) = R.RCA<REDO.FC.EFFECT.DATE>

    LOC.REF.APPLICATION = 'AA.ARRANGEMENT.ACTIVITY'
    LOC.REF.FIELDS = 'L.AA.LOAN.GL.GP'
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    TXN.REF.ID.POS = LOC.REF.POS<1,1>

    R.NEW(AA.ARR.ACT.LOCAL.REF)<1,TXN.REF.ID.POS> = R.RCA<REDO.FC.LOAN.GEN.LED>

    LOC.REF.FIELDS = 'TXN.REF.ID'
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    TXN.REF.ID.POS = LOC.REF.POS<1,1>

    R.NEW(AA.ARR.ACT.LOCAL.REF)<1,TXN.REF.ID.POS> = Y.ARR.ID


RETURN

INITIALISE:
*=========

    IF V$FUNCTION NE 'I' THEN
        PROCESS.GOAHEAD = 0
        RETURN
    END


    FN.RCA.R.NEW = 'F.RCA.R.NEW'
    F.RCA.R.NEW = ''

    R.RCA = ''
    PROCESS.GOAHEAD = 1

RETURN


OPEN.FILES:
*=========

    CALL OPF(FN.RCA.R.NEW, F.RCA.R.NEW)

RETURN

END
