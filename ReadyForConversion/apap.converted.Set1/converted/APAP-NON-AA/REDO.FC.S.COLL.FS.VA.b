SUBROUTINE REDO.FC.S.COLL.FS.VA
*----------------------------------------------------------------------------------------------------
* Subroutine Type : ROUTINE
* Attached to     : Hotfield
* Attached as     : ROUTINE
* Primary Purpose :
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
* Development by  : Jorge Valarezo - TAM Latin America
* Date            : 17.05.2012
* Notes           : Rebuild it's a dependency of PAC00169926
*-----------------------------------------------------------------------------------

************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_GTS.COMMON


    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

* ======
PROCESS:
* ======


    IF OFS$HOT.FIELD MATCHES 'SEC.NO.STATE.FS...' THEN
        Y.CAMPO.HOTVLD = OFS$HOT.FIELD
        CHANGE "." TO @FM IN Y.CAMPO.HOTVLD
        YPOSU = DCOUNT(Y.CAMPO.HOTVLD,@FM)
        Y.I = FIELD(Y.CAMPO.HOTVLD,@FM,YPOSU)
        Y.SEC.NO      = COMI
        IF COMI THEN
            GOSUB NUMERO.GARANTIA
        END
    END
    ELSE

        Y.COUNT = DCOUNT(R.NEW(REDO.FC.TYPE.OF.SEC.FS),@VM)
        GOSUB CLR.COLL.RIGHT.FLDS
        FOR Y.I = 1 TO Y.COUNT
            Y.SEC.NO = R.NEW(REDO.FC.SEC.NO.STATE.FS)<1,Y.I>
            IF Y.SEC.NO THEN
                GOSUB NUMERO.GARANTIA
            END
        NEXT Y.I

    END

RETURN


* =========
NUMERO.GARANTIA:
* =========

    Y.SEC.TYPE = R.NEW(REDO.FC.TYPE.OF.SEC.FS)<1,Y.I>
    CALL REDO.FC.S.MAPPING(Y.SEC.TYPE, Y.SEC.NO, Y.I)

RETURN


* =========
INITIALISE:
* =========
    Y.CONT = ""
    Y.I = ""
RETURN
*------------------------------------------------------------------------------------------------------------------
CLR.COLL.RIGHT.FLDS:
*------------------------------------------------------------------------------------------------------------------
    R.NEW(REDO.FC.ID.COLLATERL.RIGHT)=''
    R.NEW(REDO.FC.COLL.RIGHT.CODE)=''
    R.NEW(REDO.FC.LIMIT.REFERENCE)=''
    R.NEW(REDO.FC.VALIDITY.DATE)=''
    R.NEW(REDO.FC.SEC.HOLD.IDENTIF)=''
RETURN

END
