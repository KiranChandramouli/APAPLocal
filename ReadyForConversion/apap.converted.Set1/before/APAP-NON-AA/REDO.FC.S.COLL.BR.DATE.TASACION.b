*-----------------------------------------------------------------------------
* <Rating>-45</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.FC.S.COLL.BR.DATE.TASACION
*-----------------------------------------------------------------------------
* Subroutine Type : ROUTINE
* Attached to     : TEMPLATE REDO.CREATE.ARRANGEMENT
* Attached as     : FECHA TASACION HOT FIELD
* Primary Purpose : VALIDATE COLLATERAL
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
* Error Variables:
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : mgudino - TAM Latin America
* Date            : Abril 10 2013
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Edwin Charles D
* Date            : 06-May-2018
* Defect          : PACS00674331
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.FC.COLL.CODE.PARAMS
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.COLLATERAL.REA

    $INSERT I_F.COLLATERAL
    $INSERT I_F.COLLATERAL.CODE
    $INSERT I_F.USER

    GOSUB INITIALISE

    GOSUB FECHA.VENCIMIENTO.TASACION
* PACS00674331 - S
*    GOSUB FECHA.FORMALIZACION.GARANTIA
* PACS00674331 - E
    RETURN

* =========
INITIALISE:
* =========
    PROCESS.GOAHEAD = 1

    Y.NOMINAL.VALUE = R.NEW(REDO.FC.SEC.VALUE.BR) ;* VALOR NOMINAL
*PORCENTAJE.MAXIMO.PRESTAR:
    FN.REDO.MAXIMO.PRESTAR.COLLATERAL = 'F.REDO.FC.COLL.CODE.PARAMS'
    F.REDO.MAXIMO.PRESTAR.COLLATERAL  = ''
    R.REDO.MAXIMO.PRESTAR.COLLATERAL  = ''

    Y.REDO.MAXIMO.PRESTAR.COLLATERAL.ID  = R.NEW(REDO.FC.TYPE.OF.SEC.BR)
    Y.ERR.REDO.MAXIMO.PRESTAR.COLLATERAL = ''

*VALOR.ADMISIBLE.REA
    Y.CENTRAL.BANK.VALUE = ''
    FN.REDO.COLLATERAL.REA = 'F.REDO.COLLATERAL.REA'
    F.REDO.COLLATERAL.REA = ''
    R.REDO.COLLATERAL.REA = ''
    Y.REDO.COLLATERAL.REA.ID =  R.NEW(REDO.FC.SEC.CLASSIFY.BR)
    Y.ERR.REDO.COLLATERAL.REA = ''
    PROCESS.GOAHEAD = 1

    YPOS = 0
    Y.COLL.TYPE = R.NEW(REDO.FC.TYPE.OF.SEC.BR)
    Y.EFFECTIVE.DATE = R.NEW(REDO.FC.EFFECT.DATE)
    Y.COLL.ID = R.NEW(REDO.FC.SEC.NO.STATE.BR)
    RETURN


* ========================
FECHA.VENCIMIENTO.TASACION:
* ========================
    Y.ACTUAL   = COMI         ;*FECHA TASACION
    Y.MESES    = R.NEW(REDO.FC.REVIEW.DT.FQU.BR)<1,AV>      ;*FRECUENCIA REVISION EN MESES(SE ENTIENDE QUE SERA SIEMPRE MAYOR A 18)
    IF Y.ACTUAL THEN
        IF Y.MESES THEN
*JV20120424 FIX HOW TO CALC THE NEXT DATE
            Y.COMI = COMI
            Y.AUX    = RIGHT(Y.ACTUAL,4)
            Y.DIA    = RIGHT(Y.AUX,2)
            COMI =Y.ACTUAL:"M":Y.MESES:Y.DIA
            CALL CFQ
            Y.DATE = COMI[1,8]
            R.NEW(REDO.FC.VALUA.DUE.DATE.BR)<1,AV> = Y.DATE ;*FECHA VENCIMIENTO TASACION
            COMI = Y.COMI
        END
    END

    RETURN
* ==========================
FECHA.FORMALIZACION.GARANTIA:
* ==========================

    Y.EXE.DATE.BR = R.NEW(REDO.FC.EXECUTING.DATE.BR)<1,AV>
    IF Y.EXE.DATE.BR THEN
        IF Y.EXE.DATE.BR GT Y.EFFECTIVE.DATE THEN
* PACS00674331 - S
*      AF = REDO.FC.EXECUTING.DATE.BR
*      AV = Y.I
* PACS00674331 - E
            ETEXT = 'EB-FC-DONT-AFTER-DATE'
            CALL STORE.END.ERROR
        END

        IF Y.EXE.DATE.BR LT Y.EFFECTIVE.DATE THEN
* PACS00674331 - S
*      AF = REDO.FC.EXECUTING.DATE.BR
*      AV = Y.I
* PACS00674331 - E
            ETEXT = 'EB-ALOW-BEFORE-DATE'
            CALL STORE.END.ERROR
        END
    END

    RETURN

END
