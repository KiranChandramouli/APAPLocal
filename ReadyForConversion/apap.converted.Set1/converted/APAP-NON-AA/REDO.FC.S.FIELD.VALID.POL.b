SUBROUTINE REDO.FC.S.FIELD.VALID.POL(FIELD.NO, BEHAVIOUR, VALUE, FIELD.NAME, MV.POS, SV.POS)
*-----------------------------------------------------------------------------
* Subroutine Type : ROUTINE
* Attached to     : TEMPLATE REDO.CREATE.ARRANGEMENT.VALIDATE
* Attached as     : ROUTINE
* Primary Purpose : APPLY the behavior that need each field in a Policy as
*                   incoming receive Policy type and Policy Class
* Incoming:
*-----------------------------------------------------------------------------
*
* Outgoing:
*-----------------------------------------------------------------------------
*
* Error Variables:
*-----------------------------------------------------------------------------
* Modification History:
* Development for : Asociacion Popular de Ahorros y Prestamos
* Adapted  by     : Marcelo Gudino - TAM Latin America
*                   Luis Pazmino   - TAM Latin America
* Date            : Junio 30 2011
* Edited by       : Jorge Valarezo - TAM Latin America
* Date            : Jan 30 2012
* Edited by       : Jorge Valarezo - TAM Latin America
* Date            : Feb 29 2012 - Se modifico para que solo permita cambiar el valor por defecto en el campo INS.AMOUNT
*                   cuando cuando el Behavior sea Default
*-----------------------------------------------------------------------------

* <region name="INCLUDES">
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.CREATE.ARRANGEMENT
* </region>

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* <region name="INITIALISE" description="Init variables">
INITIALISE:
    P.MESSAGE = ''
    Y.VAL.FIELD = ''
    SET.VALUES = 0
RETURN
* </region>

* <region name="OPEN.FILES" description="Open Files">
OPEN.FILES:

RETURN
* </region>

* <region name="PROCESS" description="Main process">
PROCESS:

    P.MESSAGE = ''

    CHANGE '.' TO @FM IN FIELD.NO
    FIELD.NO = FIELD.NO<1>

    BEGIN CASE
        CASE BEHAVIOUR EQ 'INPUT'
            GOSUB BEHAVIOUR.INPUT

        CASE BEHAVIOUR EQ 'FIXED.VALUE'
            GOSUB ASSIGN.VALUES

        CASE BEHAVIOUR EQ 'DEFAULT'
            GOSUB ASSIGN.VALUES

        CASE BEHAVIOUR EQ 'MULTIVALUE'
* La rutina debe asignar como no expansible en el registro de la version
            LOCATE FIELD.NO IN R.VERSION(13) SETTING POS THEN
                R.VERSION(15)<POS> = 'NO'
            END

            FOR I.VAR = 0 TO 1
                FIELD.NO1 = FIELD.NO:'.1'
                LOCATE FIELD.NO1 IN R.VERSION(13) SETTING POS THEN
                    R.VERSION(15)<1,POS> = 'NO'
                END
            NEXT I.VAR

        CASE 1
            P.MESSAGE = "EB-FC-INS-UNKWN-BEHAV"

    END CASE

    IF P.MESSAGE NE '' THEN
        GOSUB DO.ERROR
    END

RETURN
* </region>

* <region name="BEHAVIOUR.INPUT" description="Apply a behaviour">
BEHAVIOUR.INPUT:

    IF VALUE EQ 'CAMPO NO APLICA' THEN
* lfpazmino 09/08/2011
* Test para setear el comportamiento a un campo especifico
* T(FIELD.NO)<3> = 'NOINPUT'
* Alternativa para control NOINPUT Fields
        IF SV.POS NE '' THEN
            Y.VAL.FIELD = R.NEW(FIELD.NO)<1,MV.POS,SV.POS>
        END ELSE
            Y.VAL.FIELD = R.NEW(FIELD.NO)<1,MV.POS>
        END

        IF Y.VAL.FIELD NE '' THEN
            P.MESSAGE = "EB-FC-INS-NOINPUT"
        END
        RETURN
    END

    IF VALUE EQ 'CAMPO MANDATORIO' THEN
        CHANGE '.' TO @FM IN N(FIELD.NO)
* lfpazmino 09/08/2011
* Test para setear el comportamiento a un campo especifico
* N(FIELD.NO) = N(FIELD.NO)<1>
* N(FIELD.NO) := '.1'
* Alternativa para control MANDATORY Fields
        IF SV.POS NE '' THEN
            Y.VAL.FIELD = R.NEW(FIELD.NO)<1,MV.POS,SV.POS>
        END ELSE
            Y.VAL.FIELD = R.NEW(FIELD.NO)<1,MV.POS>
        END

        IF Y.VAL.FIELD EQ '' THEN
            P.MESSAGE = 'EB-FC-INS-MANDATORY'
        END
        RETURN
    END

RETURN
* </region>

* <region name="ASSIGN.VALUES" description="Asign default values">
ASSIGN.VALUES:

    IF VALUE EQ 'FECHA DEL SISTEMA' THEN
*JV201204242 * En lugar de colocar la fecha de sistema debe colocar la fecha de creacion del prestamo y permitir editar si es posible
        IF R.NEW(FIELD.NO)<1,MV.POS,SV.POS> NE '' AND BEHAVIOUR EQ 'DEFAULT' AND SV.POS NE '' THEN
            VALUE = ""
            IF R.NEW(FIELD.NO)<1,MV.POS,SV.POS> GT R.NEW(REDO.FC.EFFECT.DATE) THEN
                AF = FIELD.NO
                AV = MV.POS
                AS = SV.POS
                ETEXT = 'EB-FC-DONT-AFTER-DATE'
                CALL STORE.END.ERROR
            END
            RETURN
        END
        IF  R.NEW(FIELD.NO)<1,MV.POS> NE '' AND BEHAVIOUR EQ 'DEFAULT' THEN
            VALUE = ""
            IF R.NEW(FIELD.NO)<1,MV.POS> GT R.NEW(REDO.FC.EFFECT.DATE) THEN
                AF = FIELD.NO
                AV = MV.POS
                ETEXT = 'EB-FC-DONT-AFTER-DATE'
                CALL STORE.END.ERROR
            END
            RETURN
        END
        GOSUB INS.AMOUNT.BEHA

        RETURN
    END

    IF VALUE EQ 'FECHA VENCIMIENTO PRESTAMO' THEN
* Set the last SM field
        Y.MAT.DATE = R.NEW(REDO.FC.TERM)
        Y.FEC.CREA = R.NEW(REDO.FC.EFFECT.DATE)
        CALL CALENDAR.DAY(Y.FEC.CREA,'+',Y.MAT.DATE)
        GOSUB SET.VALUES.NOT.NULL

        RETURN
    END

    IF (FIELD.NAME EQ 'MANAGEMENT.TYPE' OR FIELD.NAME EQ 'POLICY.STATUS') AND SET.VALUES EQ 0 THEN
        CHANGE ' ' TO '.' IN VALUE
        IF SV.POS NE '' THEN
            R.NEW(FIELD.NO)<1,MV.POS,SV.POS> = VALUE
        END ELSE
            R.NEW(FIELD.NO)<1,MV.POS> = VALUE
        END
        RETURN
    END

    IF FIELD.NAME EQ 'INS.POL.EXP.DATE' THEN
        RETURN
    END

    IF FIELD.NAME EQ 'INS.AMOUNT' THEN
* JV 29FEB2012
        IF  R.NEW(FIELD.NO)<1,MV.POS,SV.POS> NE '' AND BEHAVIOUR EQ 'DEFAULT' AND SV.POS NE '' THEN
            VALUE = ""
            RETURN
        END
        IF  R.NEW(FIELD.NO)<1,MV.POS> NE '' AND BEHAVIOUR EQ 'DEFAULT' THEN
            VALUE = ""
            RETURN
        END
* JV 29FEB2012
        GOSUB INS.AMOUNT.BEHA
        RETURN
    END

    IF SV.POS NE '' THEN
        R.NEW(FIELD.NO)<1,MV.POS,SV.POS> = VALUE
    END ELSE
        R.NEW(FIELD.NO)<1,MV.POS> = VALUE
    END

RETURN
* </region>

* <region name="DO.ERROR" description="Capture error">
DO.ERROR:
    AF = FIELD.NO
    AV = MV.POS
    AS = SV.POS

    ETEXT = P.MESSAGE
    CALL STORE.END.ERROR

RETURN
* </region>
* <region name="INS.AMOUNT.BEHA" description="Extrac Insurance Amount ">
INS.AMOUNT.BEHA:

    VALUES = ''
    BEGIN CASE
        CASE VALUE EQ 'MONTO DEL PRESTAMO'    ;*EXTRACT AMOUNT FROM ASSOCIATED LOAN
            VALUES = R.NEW(REDO.FC.AMOUNT)


        CASE VALUE EQ 'VALOR DE LA CONSTRUCCION'        ;*EXTRACT TOTAL AMOUNT OF BUILDING FROM COLLATERAL
            IF R.NEW(REDO.FC.TYPE.OF.SEC.BR) EQ 450 THEN
                VALUES = R.NEW(REDO.FC.TOT.BUIL.AREA.BR)
            END

        CASE VALUE EQ 'VALOR NOMINAL GARANTIA'          ;*EXTRACT ALL NOMINAL AMOUNTS FROM COLLATERAL ID
            GOSUB NOMINAL.AMT

        CASE VALUE EQ 'FECHA DEL SISTEMA'     ;*EXTRACT AMOUNT FROM ASSOCIATED LOAN
            VALUES = R.NEW(REDO.FC.EFFECT.DATE)


    END CASE

    IF SV.POS NE '' THEN
        R.NEW(FIELD.NO)<1,MV.POS,SV.POS> = VALUES
    END ELSE
        R.NEW(FIELD.NO)<1,MV.POS> = VALUES
    END

RETURN
* </region>

* <region name="NOMINAL.AMT" description="Extract Nominal Value from different collaterals ">
NOMINAL.AMT:

    BEGIN CASE
        CASE R.NEW (REDO.FC.TYPE.OF.SEC.BR) EQ 450
            VALUES  = R.NEW(REDO.FC.SEC.VALUE.BR)
        CASE R.NEW (REDO.FC.TYPE.OF.SEC.VS) EQ 350
            VALUES  = R.NEW(REDO.FC.SEC.VALUE.VS)
        CASE R.NEW (REDO.FC.TYPE.OF.SEC.TP) EQ 100
            VALUES  = R.NEW(REDO.FC.SEC.VALUE.TP)
        CASE R.NEW (REDO.FC.TYPE.OF.SEC.DI) EQ 150
            VALUES  = R.NEW(REDO.FC.SEC.VALUE.DI)
        CASE R.NEW (REDO.FC.TYPE.OF.SEC.DE) EQ 200
            VALUES  = R.NEW(REDO.FC.SEC.VALUE.DE)
        CASE R.NEW (REDO.FC.TYPE.OF.SEC.FS) EQ 970
            VALUES  = R.NEW(REDO.FC.SEC.VALUE.FS)

    END CASE
RETURN
* </region>


* <region name="SET.VALUES.NOT.NULL" description="SET DEFAULT VALUES IF THE FIELD DOESNT HAVE VALUES PREVIOUSLY ">
SET.VALUES.NOT.NULL:
    IF SV.POS NE '' THEN
        IF R.NEW(FIELD.NO)<1,MV.POS,SV.POS> EQ "" THEN
            R.NEW(FIELD.NO)<1,MV.POS,SV.POS> = Y.MAT.DATE
        END
        Y.EXP.DATE = R.NEW(FIELD.NO)<1,MV.POS,SV.POS>
    END ELSE
        IF R.NEW(FIELD.NO)<1,MV.POS> EQ "" THEN
            R.NEW(FIELD.NO)<1,MV.POS> = Y.MAT.DATE
        END
        Y.EXP.DATE = R.NEW(FIELD.NO)<1,MV.POS>
    END
    IF Y.EXP.DATE GT Y.MAT.DATE THEN
        P.MESSAGE = 'EB-FC.EXP.DATE.GT'

    END

    IF Y.EXP.DATE LT Y.FEC.CREA THEN
        P.MESSAGE = 'EB-FC.EXP.DATE.LT'

    END

    IF P.MESSAGE NE '' THEN
        GOSUB DO.ERROR
        P.MESSAGE = ""
    END


RETURN
* </region>

END
