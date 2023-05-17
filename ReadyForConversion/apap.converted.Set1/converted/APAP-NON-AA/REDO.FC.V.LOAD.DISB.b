SUBROUTINE REDO.FC.V.LOAD.DISB

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.CREATE.ARRANGEMENT.VALIDATE
* Attached as     : ROUTINE
* Primary Purpose : Read and load values from REDO.FC.FORM.DISB in order to display them on screen version
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
* Date            : 16 Jun 2011
*
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FC.FORM.DISB
    $INSERT I_F.REDO.FC.INST.DISB
    $INSERT I_GTS.COMMON

* ------------------------------------------------------------------------------------------
* PA20071025 Se debe ejecutar solo cuando es invocado desde el campo HOT.FIELD de la version
    CAMPO.ACTUAL = OFS$HOT.FIELD
    NOMBRE.CAMPO = "...DIS.TYPE..."
    IF CAMPO.ACTUAL MATCH NOMBRE.CAMPO ELSE
        RETURN
    END
* Fin PA20071025
*-------------------

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
    ID.FORM.DISB = COMI
    CALL CACHE.READ(FN.REDO.FC.FORM.DISB,ID.FORM.DISB,R.REDO.FC.FORM.DISB,YERR)
    IF R.REDO.FC.FORM.DISB THEN
        NRO.CONT = DCOUNT(R.REDO.FC.FORM.DISB<FC.PR.ID.INST.DISB>,@VM)
        R.NEW(REDO.FC.ID.DET.INS)<1,AV>= ""
        R.NEW(REDO.FC.FIELD.DET.INS)<1, AV>= ""
        R.NEW(REDO.FC.VAL.DET.INS)<1,AV>= ""
        FOR I.VAR = 1 TO NRO.CONT
            ID.INST.DISB = R.REDO.FC.FORM.DISB<FC.PR.ID.INST.DISB,I.VAR>
            CALL CACHE.READ(FN.REDO.FC.INST.DISB,ID.INST.DISB,R.REDO.FC.INST.DISB,YERR)
            INST.DESCP = R.REDO.FC.INST.DISB<FC.PR.DESCRIPCION>
            R.NEW(REDO.FC.ID.DET.INS)<1,AV,I.VAR>= ID.INST.DISB
            R.NEW(REDO.FC.FIELD.DET.INS)<1, AV,I.VAR>= INST.DESCP
        NEXT
    END
RETURN
*------------------------
INITIALISE:
*=========
    FN.REDO.FC.FORM.DISB = 'F.REDO.FC.FORM.DISB'
    R.REDO.FC.FORM.DISB = ''

    FN.REDO.FC.INST.DISB = 'F.REDO.FC.INST.DISB'
    R.REDO.FC.INST.DISB = ''

    PROCESS.GOAHEAD = 1
RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
