SUBROUTINE APAP.ACTIVAR.TIPO
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : APAP.ACTIVAR.TIPO
* Attached as     : ROUTINE
* Primary Purpose : The purpose is to enable or disable fields found in the
*                   application, F.APAP.H.INSURANCE.EVENTFIELD when the user
*                   selects the type of management.
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
*------------------------------------------------------------------------------

* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            : 27/07/2011
*
* Amended by      : Santiago Jijon
* Date            : 27/10/2011
*------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END


RETURN  ;* Program RETURN
*------------------------------------------------------------------------------

PROCESS:
*======

    VAR.DATO = COMI
    CALL APAP.H.INSURANCE.BEHAVIOUR.RTN
    COMI = VAR.DATO

*Choose the conditions for the field
    SELECT.STATEMENT = "SELECT F.APAP.H.INSURANCE.EVENTFIELD  WITH @ID LIKE '": VAR.NOM.CAMPO :"' AND FIELD.VALUE EQ '": VAR.DATO :"'"
    LOCK.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.ID.AA.PRD = ''
    CALL EB.READLIST(SELECT.STATEMENT,LOCK.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

*GET ALL VALUES FROM THE LIST AND ADD THE LOCK VALUE
    LOOP
        REMOVE Y.ID.AA.PRD FROM LOCK.LIST SETTING POS
    WHILE Y.ID.AA.PRD:POS

        CALL CACHE.READ(FN.LOCK1, Y.ID.AA.PRD, R.LOCK1, Y.ERR)

*Read the firt record
        AP.NAME     = 'APAP.H.INSURANCE.EVENTFIELD'

        IF  COMI EQ "INCLUIR EN CUOTA" THEN
            POS.I = 1
        END
        IF  COMI EQ "NO INCLUIR EN CUOTA" THEN
            POS.I = 2
        END

*Lee los comportamientos de los registros
        FIELD.NAME  = 'ASSOCIATED.FIELDS'
        CALL EB.GET.APPL.FIELD(AP.NAME,FIELD.NAME,'',Y.APP.ERR)

        VAR.REGISTRO  =  R.LOCK1<FIELD.NAME,POS.I>
        VAR.FILAS   = DCOUNT(VAR.REGISTRO,@SM)

*Cambio el SM pof FM File Market para pode recorrer los registros
        VAR.REGISTRO1 = CHANGE(VAR.REGISTRO,@SM,@FM)

*Lee los comportamientos de los registros
        FIELD.NAME  = 'ASSOCIATED.ACTION'
        CALL EB.GET.APPL.FIELD(AP.NAME,FIELD.NAME,'',Y.APP.ERR)

        VAR.REGISTRO2  =  R.LOCK1<FIELD.NAME,POS.I>
*Cambio el SM pof FM Field Market para pode recorrer los registros
        VAR.REGISTRO2 = CHANGE(VAR.REGISTRO2,@SM,@FM)

*Coloca la aplicacion para activar los campos
        Y.APLICACION = "APAP.H.INSURANCE.DETAILS"

*Recorre los campos para setear el valor correspondiente
        FOR VAR.I = 1 TO VAR.FILAS

            VAR.CAMPO   = VAR.REGISTRO1<VAR.I>          ;*Obtiene el nombre del campo
            VAR.COMPORT = VAR.REGISTRO2<VAR.I>          ;*Obtiene el comportamiento del campo

*if the fiels is required then set field how requiered
            GOSUB ACTIVAR

*if the fiels is hiden then set field how hiden
            GOSUB DESACTIVAR

*if the fields is optional
            GOSUB OPCIONAL

        NEXT

        IF Y.ERR NE '' THEN
            P.MESSAGE = "ST-REDO.COLLA.ERR.LEE.LOCK"
            RETURN
        END
    REPEAT

RETURN
*------------------------------------------------------------------------

INITIALISE:
*=========

    PROCESS.GOAHEAD = 1

*Start the vars for get the values
    FN.LOCK1      = 'F.APAP.H.INSURANCE.EVENTFIELD'
    F.LOCK1       = ''
    R.LOCK1       = ''

    VAR.NOM.CAMPO= F(AF)        ;*Return the field name

RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------

ACTIVAR:
*=========
*if the fiels is required then set field how requiered
    IF VAR.COMPORT EQ 'INPUT' THEN
        Y.FIELD.NO = FIELD(VAR.CAMPO,'-',1)
        CALL EB.FIND.FIELD.NO(Y.APLICACION, Y.FIELD.NO)
        IF Y.FIELD.NO GT 0 THEN
            T(Y.FIELD.NO)<3>=''
            N(Y.FIELD.NO) = N(Y.FIELD.NO):'.1'
        END
    END

RETURN
*------------



DESACTIVAR:
*=========

*if the fiels is hiden then set field how requiered
    IF VAR.COMPORT EQ 'HIDDEN' THEN
        Y.FIELD.NO = FIELD(VAR.CAMPO,'-',1,1)
        CALL EB.FIND.FIELD.NO(Y.APLICACION, Y.FIELD.NO)
        IF Y.FIELD.NO GT 0 THEN
*Set the prefix value for hiden the field
            T(Y.FIELD.NO)<3>='NOINPUT'
        END
    END
RETURN
*------------

OPCIONAL:
*=========
*if the fiels is hiden then set field how requiered
    IF VAR.COMPORT EQ 'OPTIONAL' THEN
        Y.FIELD.NO = FIELD(VAR.CAMPO,'-',1,1)
        CALL EB.FIND.FIELD.NO(Y.APLICACION, Y.FIELD.NO)
        IF Y.FIELD.NO GT 0 THEN
*Set the prefix value for hiden the field
            T(Y.FIELD.NO)<3>='NOINPUT'
            T(Y.FIELD.NO)<3>=''
        END
    END
RETURN
*------------

END
