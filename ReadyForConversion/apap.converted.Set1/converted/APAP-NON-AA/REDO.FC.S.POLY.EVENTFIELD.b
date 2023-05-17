SUBROUTINE REDO.FC.S.POLY.EVENTFIELD
*------------------------------------------------------------------------------------------------------------------
* Developer    : jvalarezoulloa@temenos.com
* Date         : 2012-03-01
* Description  : This routine will provide a behaviour for INSURANCE fields dependin on MANAGEMENT.TYPE record on APAP.H.INSURANCE.EVENTFIELD parameters table.
*
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  :
* Out :
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
* 1.1              2012-03-01    Jorge Valarezo   First Version
* 1.2              2012-05-22    Jorge Valarezo   Set correctly subvalue set
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*
    $INSERT I_F.APAP.H.INSURANCE.EVENTFIELD
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.APP.MAPPING

    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*==================
INITIALISE:
*==================
    FN.APAP.H.INSURANCE.EVENTFIELD = 'F.APAP.H.INSURANCE.EVENTFIELD'
    F.APAP.H.INSURANCE.EVENTFIELD = ''
    EVENTFIELD.ID =  'MANAGEMENT.TYPE'
    R.APAP.H.INSURANCE.EVENTFIELD = ''
    YERR = ''
    FN.REDO.APP.MAPPING = 'F.REDO.APP.MAPPING'
    F.REDO.APP.MAPPING = ''
    REDO.APP.MAPPING.ID = 'INS-RECORDS'
    R.REDO.APP.MAPPING = ''

    Y.POS = 0
    Y.FIELDS.NAME = ''
    Y.NUM.FIELDS = 0
    Y.NUM.POS = 0
    Y.FIELD.POS = 0
    Y.FIELD.BEHAVIOUR = ''

    Y.FC.FIELD.NAME = ''
    Y.FC.FIELD.POS = 0

    Y.MV.POS = 0
    Y.MV.NUM = DCOUNT(R.NEW(REDO.FC.INS.POLICY.TYPE),@VM)
    Y.SV.POS = ''
    Y.SV.NUM = 0

RETURN

*==================
OPENFILES:
*==================
    CALL OPF(FN.APAP.H.INSURANCE.EVENTFIELD,F.APAP.H.INSURANCE.EVENTFIELD)
    CALL OPF(FN.REDO.APP.MAPPING,F.REDO.APP.MAPPING)

RETURN

*==================
PROCESS:
*==================
*REVISA SI EL CONTENIDO DEL CAMPO MANGEMENT.TYPE SE ENCUENTRA PARAMETRIZADO EN APAP.H.INSURANCE.EVENTFIELD

    CALL CACHE.READ(FN.APAP.H.INSURANCE.EVENTFIELD,EVENTFIELD.ID,R.APAP.H.INSURANCE.EVENTFIELD,YERR)

    CALL CACHE.READ(FN.REDO.APP.MAPPING,REDO.APP.MAPPING.ID,R.REDO.APP.MAPPING,YERR)

    IF YERR NE '' OR R.APAP.H.INSURANCE.EVENTFIELD EQ '' OR R.REDO.APP.MAPPING EQ '' OR R.NEW ( REDO.FC.INS.MANAGEM.TYPE) EQ '' THEN
        RETURN
    END

    Y.MV.POS =1
    LOOP
    WHILE Y.MV.POS  LE Y.MV.NUM

        LOCATE R.NEW (REDO.FC.INS.MANAGEM.TYPE)<1,Y.MV.POS> IN R.APAP.H.INSURANCE.EVENTFIELD<INS.EVF.FIELD.VALUE,1> SETTING Y.POS THEN
*EXTRAE LOS CAMPOS PARAMETRIZADOS Y LOS COMPORTAMIENTOS PARAMETRIZDOS
            Y.NUM.FIELDS = DCOUNT (R.APAP.H.INSURANCE.EVENTFIELD<INS.EVF.ASSOCIATED.FIELDS,Y.POS>,@SM)
            Y.FIELDS.NAME = R.APAP.H.INSURANCE.EVENTFIELD<INS.EVF.ASSOCIATED.FIELDS,Y.POS>
            Y.FIELD.BEHAVIOUR = R.APAP.H.INSURANCE.EVENTFIELD<INS.EVF.ASSOCIATED.ACTION,Y.POS>

            CHANGE @SM TO @FM IN Y.FIELDS.NAME
            CHANGE @SM TO @FM IN Y.FIELD.BEHAVIOUR

            GOSUB FIELD.EVAL.BEHA

        END
        Y.MV.POS +=1
    REPEAT


RETURN
*==================
FIELD.EVAL.BEHA:
*==================
*RECORRE TODOS LOS CAMPOS PARAMETRIZADOS Y LOS BUSCA DENTRO DEL MAPEO DE CAMPOS EN CASO DE NO ENCONTRARLO NO APPLICARA EL COMPORTAMIENTO

    Y.NUM.POS =1
    LOOP
    WHILE Y.NUM.POS LE Y.NUM.FIELDS
        LOCATE Y.FIELDS.NAME<Y.NUM.POS> IN R.REDO.APP.MAPPING<REDO.APP.FIELD.TO,1> SETTING Y.FIELD.POS THEN
            Y.SV.NUM = 0
            Y.SV.FLAG =  FIELD(Y.FIELDS.NAME<Y.NUM.POS>,"-",2)
            Y.FC.FIELD.NAME = R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM,Y.FIELD.POS>
            Y.FC.FIELD.POS  = R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM,Y.FIELD.POS>
            CALL EB.GET.APPL.FIELD(R.REDO.APP.MAPPING<REDO.APP.APP.FROM>,Y.FC.FIELD.POS,'',Y.APP.ERR)
            GOSUB LOOP.FIELD.CONTENT
        END

        Y.NUM.POS+=1
    REPEAT

RETURN
*==================
LOOP.FIELD.CONTENT:
*==================
*RECORRE TODOS LOS MULTIVALORES Y SUBVALORES PARA APLICAR LOS COMPORTAMIENTOS
    Y.SV.NUM = DCOUNT(R.NEW(Y.FC.FIELD.POS)<1,Y.MV.POS>, @SM)  ;*VERIFICA SI EL CAMPO POSEE SUBVALORES

    IF Y.SV.NUM EQ 0 THEN
        IF Y.SV.FLAG EQ 1 THEN
            Y.SV.POS = 1
        END
        ELSE
            Y.SV.NUM = ''
        END
        GOSUB FIELD.APPLY.BEHA
    END
    ELSE

        Y.SV.POS=1
        LOOP
        WHILE Y.SV.POS LE Y.SV.NUM
            GOSUB FIELD.APPLY.BEHA
            Y.SV.POS+=1
        REPEAT

    END

RETURN
*==================
FIELD.APPLY.BEHA:
*==================
*APLICA COMPROTAMIENTOS
    BEGIN CASE

        CASE Y.FIELD.BEHAVIOUR<Y.NUM.POS> EQ "INPUT"

            IF Y.SV.NUM NE '' THEN
                Y.VAL.FIELD = R.NEW(Y.FC.FIELD.POS)<1,Y.MV.POS,Y.SV.POS>
            END ELSE
                Y.VAL.FIELD = R.NEW(Y.FC.FIELD.POS)<1,Y.MV.POS>
            END
            IF Y.VAL.FIELD EQ '' THEN
                ETEXT = 'EB-FC-INS-MANDATORY'
                GOSUB THROW.ERROR
            END
        CASE Y.FIELD.BEHAVIOUR<Y.NUM.POS> EQ "HIDDEN"
*NOTHING TO DO
            IF Y.FC.FIELD.NAME EQ 'INS.PRI.PROPER' OR Y.FC.FIELD.NAME EQ 'INS.EXTRA.AMT' OR Y.FC.FIELD.NAME EQ 'INS.MON.POL.AMT' OR Y.FC.FIELD.NAME EQ 'INS.XPRI.PROPER' THEN
                RETURN
            END
            IF Y.SV.NUM NE '' THEN
                R.NEW(Y.FC.FIELD.POS)<1,Y.MV.POS,Y.SV.POS> = ""
            END ELSE
                R.NEW(Y.FC.FIELD.POS)<1,Y.MV.POS> = ""
            END
        CASE Y.FIELD.BEHAVIOUR<Y.NUM.POS> EQ "OPTIONAL"
*NOTHING TO DO
    END CASE
RETURN
*==================
THROW.ERROR:
*==================
    AF = Y.FC.FIELD.POS
    AV = Y.MV.POS
    AS = Y.SV.POS
    CALL STORE.END.ERROR


RETURN
END
