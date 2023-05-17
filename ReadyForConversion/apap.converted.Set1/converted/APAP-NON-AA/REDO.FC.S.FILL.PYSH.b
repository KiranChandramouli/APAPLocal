SUBROUTINE REDO.FC.S.FILL.PYSH
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.CREATE.ARRANGEMENT.VALIDATE
* Attached as     : ROUTINE
* Primary Purpose : Get Paymnent Schedule values related with POLICY and create multivalue records
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
* Date            : 22 Jun 2011
*
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FC.PROD.COLL.POLICY
    $INSERT I_F.REDO.POLIZA.CARGOS

    GOSUB INITIALISE
    GOSUB OPEN.FILES


    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS.MAIN
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS.MAIN:
*============
    GOSUB MAPPING.PAYMENT.SH

RETURN
*-----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------
MAPPING.PAYMENT.SH:
*============

    GOSUB GET.LIST.PY.SH

    GOSUB SET.RCA.PY.SH

    GOSUB SET.RCA.PY.SH.COM

RETURN
*-----------------------------------------------------------------------------------

SET.RCA.PY.SH.COM:
*============
* Setea los valores de Comisiones al Areglo temporal, RCA

    Y.CONT.PROPER =  DCOUNT(R.COM,@FM)
    Y.CONT.INI =  DCOUNT(R.NEW(REDO.FC.PAYMENT.TYPE),@VM)

    Y.POS = 1
    Y.PAY.TYPE.TEMP = ''
    Y.CONTINUAR = 0
    GOSUB GET.CARGOS
    IF Y.CONTINUAR THEN
        Y.CONT.INI = Y.CONTINUAR
        Y.CONT.INI = Y.CONT.INI
    END
    Y.CONT.PROPER += Y.CONT.INI
    FOR Y.I = Y.CONT.INI TO Y.CONT.PROPER
        IF R.COM<Y.POS,COM.TYPE> THEN
            R.NEW(REDO.FC.PROPERTY)<1,Y.I+1> = R.COM<Y.POS,COM.TYPE>
            R.NEW(REDO.FC.PAYMENT.METHOD)<1,Y.I+1> = R.NEW(REDO.FC.PAYMENT.METHOD)<1,1>
            R.NEW(REDO.FC.PAYMENT.FREQ)<1,Y.I+1> = R.NEW(REDO.FC.PAYMENT.FREQ)<1,1>
            R.NEW(REDO.FC.DUE.FREQ)<1,Y.I+1> = R.NEW(REDO.FC.DUE.FREQ)<1,1,1>
            Y.PAY.TYPE.TEMP = R.COM<Y.POS,COM.TYPE>
            GOSUB GET.PROPIEDAD.CARGO
            R.NEW(REDO.FC.PAYMENT.TYPE)<1,Y.I+1> = Y.PAY.TYPE.TEMP

            Y.CONT.VALUES = DCOUNT(R.COM<Y.POS,COM.START.DATE>,@SM)
            IF Y.CONT.VALUES LE DCOUNT(R.COM<Y.POS,COM.END.DATE>,@SM) THEN
                Y.CONT.VALUES = DCOUNT(R.COM<Y.POS,COM.END.DATE>,@SM)
            END
            IF Y.CONT.VALUES LE DCOUNT(R.COM<Y.POS,COM.AMOUNT>,@SM) THEN
                Y.CONT.VALUES = DCOUNT(R.COM<Y.POS,COM.AMOUNT>,@SM)
            END


            FOR Y.J = 1 TO Y.CONT.VALUES
                R.NEW(REDO.FC.START.DATE)<1,Y.I+1,Y.J> = R.COM<Y.POS,COM.START.DATE,Y.J>
                R.NEW(REDO.FC.END.DATE)<1,Y.I+1,Y.J> = R.COM<Y.POS,COM.END.DATE,Y.J>
                R.NEW(REDO.FC.ACTUAL.AMT)<1,Y.I+1,Y.J> = R.COM<Y.POS,COM.AMOUNT,Y.J>
            NEXT Y.J
            Y.POS += 1
        END

    NEXT Y.I

RETURN
*-----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------
GET.CARGOS:
*============
    LOCATE Y.COM.CARGOS IN R.NEW(REDO.FC.PAYMENT.TYPE)<1,1> SETTING POS.K THEN
        Y.CONTINUAR = POS.K
    END

RETURN
*-----------------------------------------------------------------------------------

*-----------------------------------------------------------------------------------
GET.PROPIEDAD.CARGO:
*============
    SELECT.STATEMENT = 'SELECT ':FN.REDO.POLIZA.CARGOS:' ':'WITH PROPIEDAD LIKE ':Y.PAY.TYPE.TEMP:' ONLY'
    REDO.POLIZA.CARGOS.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.CARGO = ''
    CALL EB.READLIST(SELECT.STATEMENT,REDO.POLIZA.CARGOS.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
    LOOP
        REMOVE Y.CARGO FROM REDO.POLIZA.CARGOS.LIST SETTING POS
    WHILE Y.CARGO:POS
        CALL F.READ( FN.REDO.POLIZA.CARGOS, Y.CARGO, R.REDO.POLIZA.CARGOS,F.REDO.POLIZA.CARGOS, Y.ERR)
        Y.PAY.TYPE.TEMP = R.REDO.POLIZA.CARGOS<REDO.CAR.TIPO.PAGO>
    REPEAT

RETURN
*-----------------------------------------------------------------------------------

SET.RCA.PY.SH:
*============
* * Setea los valores de Payment Shcedule al Areglo temporal, RCA

    Y.CONT.PROPER = ''
    Y.CONT.VALUES = ''
    Y.CONT.SVALUES = ''
    Y.CONT.PROPER =  DCOUNT(R.PAYMENT.SHCEDULE,@FM)
    Y.AMOUNT.BAND = 0
    Y.I = 1
    LOOP
    WHILE Y.I LE Y.CONT.PROPER + 1
        Y.AMOUNT.BAND = 0
        Y.CONT.VALUES = DCOUNT(R.PAYMENT.SHCEDULE<Y.I,START.DATE>,@SM)
        Y.J = 1
        LOOP
        WHILE Y.J LE Y.CONT.VALUES
            GOSUB GET.PROPERTY.POS
            Y.J += 1
        REPEAT
        IF Y.AMOUNT.BAND THEN
            R.NEW(REDO.FC.PROPERTY)<1,Y.PROP.POS> = R.PAYMENT.SHCEDULE<Y.I,PROPERTY.NAME>
            R.NEW(REDO.FC.PAYMENT.TYPE)<1,Y.PROP.POS> = R.PAYMENT.SHCEDULE<Y.I,PY.TYPE,1>
            R.NEW(REDO.FC.PAYMENT.METHOD)<1,Y.PROP.POS> = R.NEW(REDO.FC.PAYMENT.METHOD)<1,1>
            R.NEW(REDO.FC.PAYMENT.FREQ)<1,Y.PROP.POS> = R.NEW(REDO.FC.PAYMENT.FREQ)<1,1>
            R.NEW(REDO.FC.DUE.FREQ)<1,Y.PROP.POS> = R.NEW(REDO.FC.DUE.FREQ)<1,1,1>
        END
        Y.I += 1
    REPEAT

RETURN

*-----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------
GET.PROPERTY.POS:
*============
    LOCATE R.PAYMENT.SHCEDULE<Y.I,PROPERTY.NAME> IN R.NEW(REDO.FC.PAYMENT.TYPE)<1,1> SETTING POS.K THEN
        Y.PROP.POS = POS.K
    END ELSE
        Y.PROP.POS = DCOUNT(R.NEW(REDO.FC.PAYMENT.TYPE),@VM) + 1
    END

    IF R.PAYMENT.SHCEDULE<Y.I,AMOUNT,Y.J> GT 0 THEN
        R.NEW(REDO.FC.START.DATE)<1,Y.PROP.POS,Y.J> = R.PAYMENT.SHCEDULE<Y.I,START.DATE,Y.J>
        R.NEW(REDO.FC.END.DATE)<1,Y.PROP.POS,Y.J> = R.PAYMENT.SHCEDULE<Y.I,END.DATE,Y.J>
        R.NEW(REDO.FC.ACTUAL.AMT)<1,Y.PROP.POS,Y.J> = R.PAYMENT.SHCEDULE<Y.I,AMOUNT,Y.J>
        Y.AMOUNT.BAND = 1
    END
RETURN
*-----------------------------------------------------------------------------------

*-----------------------------------------------------------------------------------
GET.LIST.PY.SH:
*============
* Toma todas las polizas, e Iterar todas las polizas

    Y.MAX.POLIZA = DCOUNT(Y.INS.POLICY.TYPE,@VM)
    FOR Y.I = 1 TO Y.MAX.POLIZA + 1
        IF Y.INS.PRI.PROPER<1,Y.I> AND Y.INS.MNG.TYPE<1,Y.I> EQ Y.INCLUIR THEN
* RECORRER PRIMAS
            GOSUB RECORRER.PRIMAS
        END

* RECORRER COMISIONES
        GOSUB RECORRER.COMISIONES

    NEXT Y.I

RETURN
*-----------------------------------------------------------------------------------

*-----------------------------------------------------------------------------------
RECORRER.COMISIONES:
    Y.MAX.COM = DCOUNT(Y.INS.COM.TYPE<1,Y.I>,@SM)

    FOR Y.J = 1 TO Y.MAX.COM + 1
* toma el valor del ID del - verificar prima y extraprima ;)
        IF Y.INS.COM.TYPE<1,Y.I,Y.J> THEN
            Y.COM.TYPE = Y.INS.COM.TYPE<1,Y.I,Y.J>
            Y.COUNT.T = DCOUNT(R.COM,@FM)
            GOSUB PROCESA.COMISION
        END
    NEXT Y.J

RETURN
*-----------------------------------------------------------------------------------

*-----------------------------------------------------------------------------------
PROCESA.COMISION:
    K.VAR = 0
    FOR Y.T = 1 TO Y.COUNT.T + 1
        IF R.COM<Y.T,COM.TYPE> EQ Y.COM.TYPE THEN
            K.VAR = Y.T
        END
    NEXT Y.T
* AGREGARLO A LA SIGUIENTE POSICION
    IF K.VAR GT 0 THEN
        Y.NEW.POS = DCOUNT(R.COM<K.VAR,COM.START.DATE>,@SM) + 1
        R.COM<K.VAR,COM.START.DATE,Y.NEW.POS> = Y.DATE.BEG.CHARG<1,Y.I,Y.J>   ;*VALOR start date
        R.COM<K.VAR,COM.END.DATE,Y.NEW.POS> = Y.DATE.END.CHARG<1,Y.I,Y.J>
        R.COM<K.VAR,COM.AMOUNT,Y.NEW.POS> = Y.INS.SEC.COM.AMT<1,Y.I,Y.J>
    END ELSE
        IF NOT(R.COM) THEN
            R.COM<COM.TYPE,1> = Y.COM.TYPE    ;*VALOR start date
            R.COM<COM.TYPE,COM.START.DATE,1> = Y.DATE.BEG.CHARG<1,Y.I,Y.J>  ;*VALOR start date
            R.COM<COM.TYPE,COM.END.DATE,1> = Y.DATE.END.CHARG<1,Y.I,Y.J>
            R.COM<COM.TYPE,COM.AMOUNT,1> = Y.INS.SEC.COM.AMT<1,Y.I,Y.J>
        END ELSE
            Y.NEW.POS = DCOUNT(R.COM, @FM) + 1
            R.COM<Y.NEW.POS,1> = Y.COM.TYPE   ;*VALOR start date
            R.COM<Y.NEW.POS,COM.START.DATE,1> = Y.DATE.BEG.CHARG<1,Y.I,Y.J> ;*VALOR start date
            R.COM<Y.NEW.POS,COM.END.DATE,1> = Y.DATE.END.CHARG<1,Y.I,Y.J>
            R.COM<Y.NEW.POS,COM.AMOUNT,1> = Y.INS.SEC.COM.AMT<1,Y.I,Y.J>
        END
    END

RETURN
*-----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------
RECORRER.PRIMAS:

    Y.MAX.PRIMA = DCOUNT(Y.INS.PRI.PROPER<1,Y.I>,@SM)
    FOR Y.J = 1 TO Y.MAX.PRIMA + 1
* toma el valor del ID del - verificar prima y extraprima ;)
        IF Y.INS.PRI.PROPER<1,Y.I,Y.J> THEN
            Y.PRIMA.PROPERTI = Y.INS.PRI.PROPER<1,Y.I,Y.J>
            Y.COUNT.T = DCOUNT(R.PAYMENT.SHCEDULE,@FM)

            GOSUB PROCESA.PROPERTI

* toma el valor del ID del - verificar prima y extraprima ;)
            IF Y.INS.EXTRA.PRIMA<1,Y.I,Y.J> THEN
                Y.XPRIMA.PROPERTI = Y.INS.EXTRA.PRIMA<1,Y.I,Y.J>
                Y.COUNT.T = ''
                Y.COUNT.T = DCOUNT(R.PAYMENT.SHCEDULE,@FM)
                GOSUB PROCESA.EXTRA.PROPERTI
            END
        END
    NEXT Y.J

RETURN
*-----------------------------------------------------------------------------------

*-----------------------------------------------------------------------------------
PROCESA.EXTRA.PROPERTI:
    K.VAR = 0
    FOR Y.T = 1 TO Y.COUNT.T + 1
        IF R.PAYMENT.SHCEDULE<Y.T,PROPERTY.NAME> EQ Y.XPRIMA.PROPERTI THEN
            K.VAR = Y.T
*            CONTINUE
        END
    NEXT Y.T

    IF K.VAR GT 0 THEN
* AGREGARLO A LA SIGUIENTE POSICION
        Y.NEW.POS = DCOUNT(R.PAYMENT.SHCEDULE<K.VAR,START.DATE>,@SM) + 1
        R.PAYMENT.SHCEDULE<K.VAR,START.DATE,Y.NEW.POS> = Y.INS.DATE.BEG.CHARG<1,Y.I,Y.J>          ;*VALOR start date
        R.PAYMENT.SHCEDULE<K.VAR,END.DATE,Y.NEW.POS> = Y.INS.DATE.END.CHARG<1,Y.I,Y.J>
        R.PAYMENT.SHCEDULE<K.VAR,AMOUNT,Y.NEW.POS> = Y.INS.XMON.POL.AMT<1,Y.I,Y.J>
    END ELSE
        IF NOT(R.PAYMENT.SHCEDULE) THEN
            R.PAYMENT.SHCEDULE<PROPERTY.NAME,1> = Y.XPRIMA.PROPERTI         ;*VALOR start date
            R.PAYMENT.SHCEDULE<PROPERTY.NAME,START.DATE,1> = Y.INS.DATE.BEG.CHARG<1,Y.I,Y.J>    ;*VALOR start date
            R.PAYMENT.SHCEDULE<PROPERTY.NAME,END.DATE,1> = Y.INS.DATE.END.CHARG<1,Y.I,Y.J>
            R.PAYMENT.SHCEDULE<PROPERTY.NAME,AMOUNT,1> = Y.INS.XMON.POL.AMT<1,Y.I,Y.J>
            R.PAYMENT.SHCEDULE<PROPERTY.NAME,PY.TYPE,1> = Y.INS.PY.TYPE<1,Y.I,Y.J>
        END ELSE
            Y.NEW.POS = DCOUNT(R.PAYMENT.SHCEDULE, @FM) + 1
            R.PAYMENT.SHCEDULE<Y.NEW.POS,PROPERTY.NAME,1> = Y.XPRIMA.PROPERTI         ;*VALOR start date
            R.PAYMENT.SHCEDULE<Y.NEW.POS,START.DATE,1> = Y.INS.DATE.BEG.CHARG<1,Y.I,Y.J>        ;*VALOR start date
            R.PAYMENT.SHCEDULE<Y.NEW.POS,END.DATE,1> = Y.INS.DATE.END.CHARG<1,Y.I,Y.J>
            R.PAYMENT.SHCEDULE<Y.NEW.POS,AMOUNT,1> = Y.INS.XMON.POL.AMT<1,Y.I,Y.J>
            R.PAYMENT.SHCEDULE<Y.NEW.POS,PY.TYPE,1> = Y.INS.PY.TYPE<1,Y.I,Y.J>
        END
    END

RETURN
*-----------------------------------------------------------------------------------

*-----------------------------------------------------------------------------------
PROCESA.PROPERTI:

    K.VAR = 0
    FOR Y.T = 1 TO Y.COUNT.T + 1
        IF R.PAYMENT.SHCEDULE<Y.T,PROPERTY.NAME> EQ Y.PRIMA.PROPERTI THEN
            K.VAR = Y.T
        END
    NEXT Y.T
* AGREGARLO A LA SIGUIENTE POSICION
    IF K.VAR GT 0 THEN
        Y.NEW.POS = DCOUNT(R.PAYMENT.SHCEDULE<K.VAR,START.DATE>,@SM) + 1
        R.PAYMENT.SHCEDULE<K.VAR,START.DATE,Y.NEW.POS> = Y.INS.DATE.BEG.CHARG<1,Y.I,Y.J>          ;*VALOR start date
        R.PAYMENT.SHCEDULE<K.VAR,END.DATE,Y.NEW.POS> = Y.INS.DATE.END.CHARG<1,Y.I,Y.J>
        R.PAYMENT.SHCEDULE<K.VAR,AMOUNT,Y.NEW.POS> = Y.INS.MON.POL.AMT<1,Y.I,Y.J>
    END ELSE
        IF NOT(R.PAYMENT.SHCEDULE)  THEN
            R.PAYMENT.SHCEDULE<PROPERTY.NAME,1> = Y.PRIMA.PROPERTI          ;*VALOR start date
            R.PAYMENT.SHCEDULE<PROPERTY.NAME,PY.TYPE,1> = Y.INS.PY.TYPE<1,Y.I,Y.J>
            R.PAYMENT.SHCEDULE<PROPERTY.NAME,START.DATE,1> = Y.INS.DATE.BEG.CHARG<1,Y.I,Y.J>    ;*VALOR start date
            R.PAYMENT.SHCEDULE<PROPERTY.NAME,END.DATE,1> = Y.INS.DATE.END.CHARG<1,Y.I,Y.J>
            R.PAYMENT.SHCEDULE<PROPERTY.NAME,AMOUNT,1> = Y.INS.MON.POL.AMT<1,Y.I,Y.J>
        END ELSE
            Y.NEW.POS = DCOUNT(R.PAYMENT.SHCEDULE, @FM) + 1
            R.PAYMENT.SHCEDULE<Y.NEW.POS,1> = Y.PRIMA.PROPERTI    ;*VALOR start date
            R.PAYMENT.SHCEDULE<Y.NEW.POS,START.DATE,1> = Y.INS.DATE.BEG.CHARG<1,Y.I,Y.J>        ;*VALOR start date
            R.PAYMENT.SHCEDULE<Y.NEW.POS,END.DATE,1> = Y.INS.DATE.END.CHARG<1,Y.I,Y.J>
            R.PAYMENT.SHCEDULE<Y.NEW.POS,AMOUNT,1> = Y.INS.MON.POL.AMT<1,Y.I,Y.J>
            R.PAYMENT.SHCEDULE<Y.NEW.POS,PY.TYPE,1> = Y.INS.PY.TYPE<1,Y.I,Y.J>
        END
    END

RETURN
*-----------------------------------------------------------------------------------

INITIALISE:
*=========

    Y.PRODUCT = R.NEW(REDO.FC.PRODUCT)

    Y.INS.POLICY.TYPE = R.NEW(REDO.FC.INS.POLICY.TYPE)        ;*las polizas
    Y.INS.PRI.PROPER = R.NEW(REDO.FC.INS.PRI.PROPER)          ;*Prima
    Y.INS.EXTRA.PRIMA = R.NEW(REDO.FC.INS.XPRI.PROPER)        ;*Extra Prima
    Y.INS.MNG.TYPE = R.NEW(REDO.FC.INS.MANAGEM.TYPE)
    Y.INS.DATE.BEG.CHARG = R.NEW(REDO.FC.INS.DATE.BEG.CHARG)
    Y.INS.DATE.END.CHARG = R.NEW(REDO.FC.INS.DATE.END.CHARG)
    Y.INS.MON.POL.AMT = R.NEW(REDO.FC.INS.MON.POL.AMT)
    Y.INS.XMON.POL.AMT = R.NEW(REDO.FC.INS.EXTRA.AMT)
    Y.INS.PY.TYPE = R.NEW(REDO.FC.INS.PAY.TYPE)

    Y.INS.COM.TYPE = R.NEW(REDO.FC.INS.SEC.COM.TYPE)
    Y.INS.SEC.COM.AMT = R.NEW(REDO.FC.INS.SEC.COM.AMT)
    Y.TAX.MANAGEM.TYPE = R.NEW(REDO.FC.TAX.MANAGEM.TYPE)
    Y.DATE.BEG.CHARG = R.NEW(REDO.FC.DATE.BEG.CHARG)
    Y.DATE.END.CHARG = R.NEW(REDO.FC.DATE.END.CHARG)

    Y.PROPERTY  = R.NEW(REDO.FC.PROPERTY)
    Y.STARD.DATE = R.NEW(REDO.FC.START.DATE)
    Y.END.DATE = R.NEW(REDO.FC.END.DATE)
    Y.ACTUAL.AMT = R.NEW(REDO.FC.ACTUAL.AMT)



*************    Tabla temporal para almacenar los Pagos por Propiedad
************ CARGOS
    R.PAYMENT.SHCEDULE = ''
    PROPERTY.NAME = 1
    START.DATE = 2
    END.DATE = 3
    AMOUNT = 4
    PY.TYPE = 5
************* COMISIONES
    R.COM = ''
    COM.TYPE = 1
    COM.AMOUNT = 2
    COM.MNG.TYPE = 3
    COM.START.DATE = 4
    COM.END.DATE = 5
*************

    Y.XPRIMA.PROPERTI = ''
    Y.PRIMA.PROPERTI = ''
    YERR = ''
    PROCESS.GOAHEAD = 1
    Y.MAX.COM = ''
    Y.COM.TYPE = ''
    Y.COM.CARGOS = 'CARGOS'

    Y.INCLUIR = 'INCLUIR EN CUOTA'

* FILES
    FN.REDO.POLIZA.CARGOS = 'F.REDO.POLIZA.CARGOS'
    F.REDO.POLIZA.CARGOS = ''

RETURN

*------------------------
OPEN.FILES:
*=========

    CALL OPF(FN.REDO.POLIZA.CARGOS,F.REDO.POLIZA.CARGOS)

RETURN
*------------
END
