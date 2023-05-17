SUBROUTINE REDO.FC.VAL.VALUE.DATE
* ============================================================================
* Subroutine Type : ROUTINE
* Attached to     : VALUE.DATE FIELD IN REDO.CREATE.ARRANGEMENT TEMPLATE
* Attached as     : HOLD.FIELD in VALUE.DATE field
* Primary Purpose : VALIDATE THE DATE THAT THE USER INPUT IN VALUE.DATE FIELD
*                   IN OF HEADER TO REDO.CREATE.ARRANGEMENT TEMPLATE
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : Agosto 25 2011
*
* Modified by     : Luis Pazmino - TAM Latin America
* Date            : Sept 19 2011
* Notes           : F.READ Error Handling and delete CHECK.PRELIM.CONDITIONS

* Version          Date          Name              Description
* -------          ----          ----              ------------
* 1.0              2011-09-19    Luis Pazmino      Version
* 1.1              2012-01-07    Meza William      Code Review
* 1.2              2012-02-22    Jorge Valarezo    PAC 167218
* 1.2              2012-02-22    Jorge Valarezo    PAC 167218 added "return" inside of if's to throw errors
*==============================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.PRODUCT.DESIGNER
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.USER
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_GTS.COMMON
********************************************************************************

* ------------------------------------------------------------------------------------------
* PA20071025 Se debe ejecutar solo cuando es invocado desde el campo HOT.FIELD de la version


* Fin PA20071025
*-------------------

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* ======
PROCESS:
* ======
    GOSUB FECHA.CREACION.GARANTIA
RETURN

* =====================
FECHA.CREACION.GARANTIA:
* =====================
    Y.USR.ID = OPERATOR
    CALL CACHE.READ(FN.USR, Y.USR.ID, R.USR, USR.ERR)

    IF USR.ERR THEN
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.USR
        CALL STORE.END.ERROR
        RETURN
    END

    VAR.BAN.DATE = R.USR<EB.USE.LOCAL.REF,WPOSUSER>

    IF (VAR.BAN.DATE EQ '') THEN
        AF = REDO.FC.EFFECT.DATE
        TEXT = 'EB-FC-USER-ALOW-VALID'
        CALL STORE.END.ERROR
        RETURN
    END


    IF Y.F.CREA.GAR THEN
        IF (VAR.BAN.DATE EQ 2) AND (Y.F.CREA.GAR NE Y.TODAY) THEN
            AF = REDO.FC.EFFECT.DATE
            ETEXT = 'EB-FC-NO.ALLOW-TO-USER'
            CALL STORE.END.ERROR
            RETURN
        END
        IF Y.F.CREA.GAR GT Y.TODAY THEN
            AF = REDO.FC.EFFECT.DATE
            ETEXT = 'EB-FC-DONT-AFTER-TD'
            CALL STORE.END.ERROR
            RETURN
        END
        IF VAR.BAN.DATE EQ 1 THEN

            GOSUB SELECT.COLLATERAL
        END
    END

RETURN

* =========
OPEN.FILES:
* =========
    CALL OPF(FN.USR, F.USR)
RETURN

* =========
INITIALISE:
* =========
    Y.TODAY= TODAY
    Y.APP.ERR = ""

    FN.USR  = 'F.USER'
    F.USR   = ''
    R.USR   = ''
    WCAMPOU = "VAL.MODI.DATE"
    WCAMPOU = CHANGE(WCAMPOU,@FM,@VM)
    YPOSU=''
    CALL MULTI.GET.LOC.REF("USER",WCAMPOU,YPOSU)
    WPOSUSER  = YPOSU<1,1>

    Y.FIELD.POS = DCOUNT ( R.GTS,@FM )
    Y.POS    = ''
    Y.ACTUAL = TODAY

    CAMPO.ACTUAL = OFS$HOT.FIELD
    NOMBRE.CAMPO = "EFFECT.DATE"

    IF CAMPO.ACTUAL EQ NOMBRE.CAMPO THEN
        Y.F.CREA.GAR = COMI
    END
    ELSE

        Y.F.CREA.GAR = R.NEW(REDO.FC.EFFECT.DATE)
    END


RETURN
*================
DEF.TYPE.GARANTIA:
*================
*add to edited the collateral date dependes of collateral type and if it was create previouslly
    BEGIN CASE

*  CASE R.NEW(REDO.FC.TYPE.OF.SEC.DI)
        CASE Y.NUM.COL.TP EQ 1
            Y.COLL.NUM=R.NEW(REDO.FC.TYPE.OF.SEC.DI)
            Y.SUFIX.VALUE  = 'DI'
            Y.GAR.ID       = R.NEW(REDO.FC.SEC.NO.STATE.DI)
*  CASE R.NEW(REDO.FC.TYPE.OF.SEC.VS)
        CASE Y.NUM.COL.TP EQ 2
            Y.COLL.NUM=R.NEW(REDO.FC.TYPE.OF.SEC.VS)
            Y.SUFIX.VALUE  = 'VS'
            Y.FLD.FORM.GAR = 'GRANTING.DATET.'
            Y.GAR.ID       = R.NEW(REDO.FC.SEC.NO.STATE.VS)
*  CASE R.NEW(REDO.FC.TYPE.OF.SEC.BR)
        CASE Y.NUM.COL.TP EQ 3
            Y.COLL.NUM=R.NEW(REDO.FC.TYPE.OF.SEC.BR)
            Y.SUFIX.VALUE  = 'BR'
            Y.FLD.FORM.GAR = 'GRANTING.DATET.'
            Y.GAR.ID       = R.NEW(REDO.FC.SEC.NO.STATE.BR)
*   CASE R.NEW(REDO.FC.TYPE.OF.SEC.TP)
        CASE Y.NUM.COL.TP EQ 4
            Y.COLL.NUM = R.NEW(REDO.FC.TYPE.OF.SEC.TP)
            Y.FLD.FORM.GAR = 'GRANTI.DATE.'
            Y.SUFIX.VALUE  = 'TP'
            Y.GAR.ID       = R.NEW(REDO.FC.SEC.NO.STATE.TP)
*  CASE R.NEW(REDO.FC.TYPE.OF.SEC.FS)
        CASE Y.NUM.COL.TP EQ 5
            Y.COLL.NUM=R.NEW(REDO.FC.TYPE.OF.SEC.FS)
            Y.SUFIX.VALUE  = 'FS'
            Y.GAR.ID       = R.NEW(REDO.FC.SEC.NO.STATE.FS)
*   CASE R.NEW(REDO.FC.TYPE.OF.SEC.DE)
        CASE Y.NUM.COL.TP EQ 6
            Y.COLL.NUM=R.NEW(REDO.FC.TYPE.OF.SEC.DE)
            Y.SUFIX.VALUE  = 'DE'
            Y.GAR.ID       = R.NEW(REDO.FC.SEC.NO.STATE.DE)
    END CASE
    IF Y.SUFIX.VALUE NE "" THEN

        Y.FLD.CREA.GAR = Y.FLD.CREA.GAR:Y.SUFIX.VALUE
        Y.FLD.FORM.GAR = Y.FLD.FORM.GAR:Y.SUFIX.VALUE
        Y.FLD.EXEC.GAR = Y.FLD.EXEC.GAR:Y.SUFIX.VALUE
        CALL EB.GET.APPL.FIELD(APPLICATION,Y.FLD.CREA.GAR,'',Y.APP.ERR)
        CALL EB.GET.APPL.FIELD(APPLICATION,Y.FLD.FORM.GAR,'',Y.APP.ERR)
        CALL EB.GET.APPL.FIELD(APPLICATION,Y.FLD.EXEC.GAR,'',Y.APP.ERR)
        Y.FIELD.SEARCH = Y.FLD.EXEC.GAR : @FM : Y.FLD.FORM.GAR : @FM : Y.FLD.CREA.GAR

    END

RETURN
*==============
ASSING.VALUES:
*==============
    R.NEW(Y.FLD.CREA.GAR)<1,Y.I>  = Y.F.CREA.GAR

    IF Y.SUFIX.VALUE  NE 'BR' THEN
        R.NEW(Y.FLD.FORM.GAR)<1,Y.I>    = Y.F.CREA.GAR
        R.NEW(Y.FLD.EXEC.GAR)<1,Y.I>   = Y.F.CREA.GAR
        Y.FIELD.SEARCH = Y.FLD.CREA.GAR
    END
    LOOP
    WHILE Y.FIELD.POS GE 1

        LOCATE R.GTS<Y.FIELD.POS,3> IN Y.FIELD.SEARCH<1> SETTING Y.POS THEN
            R.GTS<Y.FIELD.POS,2> = Y.F.CREA.GAR
            Y.FIELD.POS -= 1
        END
        ELSE
            Y.FIELD.POS -= 1
        END

    REPEAT
RETURN
*==============
SELECT.COLLATERAL:
*==============
    Y.NUM.COL.TP = 1
    Y.NUM.COL.MX = 6
    LOOP
    WHILE Y.NUM.COL.TP LE Y.NUM.COL.MX
        Y.FLD.CREA.GAR = 'SEC.CREATE.DATE.'
        Y.FLD.FORM.GAR = 'GRANTING.DATE.'
        Y.FLD.EXEC.GAR = 'EXECUTING.DATE.'
        Y.SUFIX.VALUE  = ''
        GOSUB DEF.TYPE.GARANTIA

        Y.I = 1
        Y.COUNT = DCOUNT(Y.COLL.NUM,@VM)
*Add to allow to modify at least once time all dates for all collateral types
        IF Y.COUNT EQ 0 THEN
            Y.COUNT = 1
        END
        LOOP
        WHILE Y.I LE Y.COUNT

            IF CAMPO.ACTUAL MATCH NOMBRE.CAMPO AND Y.GAR.ID<1,Y.I> EQ "" THEN
                GOSUB ASSING.VALUES
            END
            Y.I += 1
        REPEAT

        Y.NUM.COL.TP += 1
    REPEAT

RETURN

END
