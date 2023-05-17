******************************************************************************
SUBROUTINE REDO.FC.CL.VERIFY.BALANCE
******************************************************************************
* Company Name:   Asociacion Popular de Ahorro y Prestamo (APAP)
* Developed By:   Reginal Temenos Application Management
* ----------------------------------------------------------------------------
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :  Verifies Collateral Amounts against AA Amount
*
* Incoming        :  NA
* Outgoing        :  NA
*
*-----------------------------------------------------------------------------
* Modification History:
* ====================
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : Agosto 2011
* Modify by       : Jorge Valarezo (jvalarezoulloa@temenos.com) - TAM Latin America
* Date            : 02 Abril 2012 ;Change Override instaed to Error throw when Collaterals not cobered all Loan Amount

******************************************************************************

******************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL

    $INSERT I_REDO.FC.COMMON
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.APP.MAPPING
    $INSERT I_F.REDO.FC.PROD.COLL.POLICY
******************************************************************************

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* =========
INITIALISE:
* =========
    Y.PRODUCT = ''
    Y.NUM.CL.CODES  = ''
    Y.NUM.CL.FIELDS = ''

    FN.REDO.APP.MAPPING = 'F.REDO.APP.MAPPING'
    F.REDO.APP.MAPPING  = ''
    R.REDO.APP.MAPPING  = ''

    FN.REDO.FC.PROD.COLL.POLICY = 'F.REDO.FC.PROD.COLL.POLICY'
    F.REDO.FC.PROD.COLL.POLICY  = ''
    R.REDO.FC.PROD.COLL.POLICY  = ''

    Y.PRODUCT   = R.NEW(REDO.FC.PRODUCT)
    Y.AA.AMOUNT = R.NEW(REDO.FC.AMOUNT)
*JV02042012 TAKE ALL VALUES STORED AT REDO.FC.SEC.NO.STATE ACCORDING TYPE OF COLLATERAL
    Y.NUM.ID    = ''

    Y.RECORD.ID = ''
    Y.CL.CODE   = ''
    Y.TYPE.COLL = ''
    Y.TOT.COLL.SD.END = ''

RETURN

* =========
OPEN.FILES:
* =========
    CALL OPF(FN.REDO.FC.PROD.COLL.POLICY,F.REDO.FC.PROD.COLL.POLICY)
    CALL OPF(FN.REDO.APP.MAPPING,F.REDO.APP.MAPPING)

RETURN

* ======
PROCESS:
* ======
    GOSUB GET.COLL.CODE
    GOSUB GET.SD.COLL
    Y.AA.BALANCE = SUM(Y.TOT.COLL.SD.END)

* Validacion de Cobertura del Saldo Total del Prestamo
* a traves de las garantias
*  IF Y.AA.BALANCE LT Y.AA.AMOUNT THEN
    IF (Y.AA.BALANCE NE '') AND (Y.AA.BALANCE NE '0') AND (Y.AA.BALANCE LT Y.AA.AMOUNT) THEN        ;*PACS00744025
*jv02042012 Use Override Instead Error
        TEXT = 'EB-FC.DOES.NOT.SUFFICIENT.GUARANTEE'
        M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
        CALL STORE.OVERRIDE(M.CONT)
*ETEXT = "EB-FC.DOES.NOT.SUFFICIENT.GUARANTEE"
*CALL STORE.END.ERROR
*CALL TRANSACTION.ABORT
    END

RETURN

*=============
GET.COLL.CODE:
*=============
    CALL CACHE.READ(FN.REDO.FC.PROD.COLL.POLICY, Y.PRODUCT, R.REDO.FC.PROD.COLL.POLICY, YERR)
    Y.TYPES.CODES = R.REDO.FC.PROD.COLL.POLICY<REDO.CPL.COLLATERAL.CODE>

* Titulos Publicos
    LOCATE 100 IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
        IF YPOS THEN
            IF Y.TYPE.COLL NE '' THEN
                Y.TYPE.COLL := @VM : 100
            END ELSE
                Y.TYPE.COLL = 100
            END
            YPOS = ''
        END
        AF = REDO.FC.AVAIL.COLL.BAL.TP
        Y.NUM.ID    = R.NEW(REDO.FC.SEC.NO.STATE.TP)
    END

* Depositos Internos
    LOCATE 150 IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
        IF YPOS THEN
            IF Y.TYPE.COLL NE '' THEN
                Y.TYPE.COLL := @VM : 150
            END ELSE
                Y.TYPE.COLL = 150
            END
            YPOS = ''
        END
        AF = REDO.FC.AVAIL.COLL.BAL.DI
        Y.NUM.ID    = R.NEW(REDO.FC.SEC.NO.STATE.DI)
    END

* Depositos Externos
    LOCATE 200 IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
        IF YPOS THEN
            IF Y.TYPE.COLL NE '' THEN
                Y.TYPE.COLL := @VM : 200
            END ELSE
                Y.TYPE.COLL = 200
            END
            YPOS = ''
        END
        AF = REDO.FC.AVAIL.COLL.BAL.DE
        Y.NUM.ID    = R.NEW(REDO.FC.SEC.NO.STATE.DE)
    END

* Vehiculos
    LOCATE 350 IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
        IF YPOS THEN
            IF Y.TYPE.COLL NE '' THEN
                Y.TYPE.COLL := @VM : 350
            END ELSE
                Y.TYPE.COLL = 350
            END
            YPOS = ''
        END
        AF = REDO.FC.AVAIL.COLL.BAL.VS
        Y.NUM.ID    = R.NEW(REDO.FC.SEC.NO.STATE.VS)
    END

* Bienes Raices
    LOCATE 450 IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
        IF YPOS THEN
            IF Y.TYPE.COLL NE '' THEN
                Y.TYPE.COLL := @VM : 450
            END ELSE
                Y.TYPE.COLL = 450
            END
            YPOS = ''
        END
        AF = REDO.FC.AVAIL.COLL.BAL.BR
        Y.NUM.ID    = R.NEW(REDO.FC.SEC.NO.STATE.BR)
    END

* Firmas Solidarias
    LOCATE 970 IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
        IF YPOS THEN
            IF Y.TYPE.COLL NE '' THEN
                Y.TYPE.COLL := @VM : 970
            END ELSE
                Y.TYPE.COLL = 970
            END
            YPOS = ''
        END
        AF = REDO.FC.AVAIL.COLL.BAL.FS
        Y.NUM.ID    = R.NEW(REDO.FC.SEC.NO.STATE.FS)
    END

RETURN

* =========
GET.SD.COLL:
* =========
    Y.COUNT.C.U = DCOUNT(Y.TYPE.COLL,@VM)
    FOR Y.C.U = 1 TO Y.COUNT.C.U
        REDO.APP.MAPPING.ID = 'CC-' : Y.TYPE.COLL<1,Y.C.U>
        CALL CACHE.READ(FN.REDO.APP.MAPPING,REDO.APP.MAPPING.ID, R.REDO.APP.MAPPING, Y.ERR)

        IF R.REDO.APP.MAPPING THEN
            Y.MAPP.FILED = R.REDO.APP.MAPPING<REDO.APP.FIELD.TO>
            Y.APLICATION  = FIELD(R.REDO.APP.MAPPING<REDO.APP.APP.FROM>,@VM,1)

* Valor Disponible de la Garantia
            LOCATE "L.COL.VAL.AVA" IN Y.MAPP.FILED<1,1> SETTING ZPOS THEN
                Y.NAME.FIELD.SD  = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM>,@VM,ZPOS)
            END

* Monto Maximo a Prestar
            LOCATE "L.COL.LN.MX.VAL" IN Y.MAPP.FILED<1,1> SETTING ZPOS THEN
                Y.NAME.FIELD.MVP  = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM>,@VM,ZPOS)
            END

            GOSUB CALC.TOTAL.VALUES
        END

    NEXT Y.C.U

RETURN

* ==============
CALC.TOTAL.VALUES:
* ==============
    Y.TOT.COLL.SD = ""
    CALL EB.FIND.FIELD.NO(Y.APLICATION, Y.NAME.FIELD.SD)
    Y.COLL.NEW.SD  =  R.NEW(Y.NAME.FIELD.SD)

    CALL EB.FIND.FIELD.NO(Y.APLICATION, Y.NAME.FIELD.MVP)
    Y.COLL.NEW.VMP = R.NEW(Y.NAME.FIELD.MVP)

    Y.COUNT.C = DCOUNT(Y.COLL.NEW.VMP,@VM)
    FOR Y.C = 1 TO Y.COUNT.C
        IF Y.COLL.NEW.VMP<1,Y.C> NE "" AND ( Y.COLL.NEW.SD<1,Y.C> NE "" OR Y.NUM.ID<1,Y.C> )THEN    ;*EVALUATE IF IT CONTAINS ID OF COLLATERAL THAT IT WAS CREATED PREVIOUSLY
            IF Y.TOT.COLL.SD NE '' THEN
                Y.TOT.COLL.SD := @VM : Y.COLL.NEW.SD<1,Y.C>
            END ELSE
                Y.TOT.COLL.SD = Y.COLL.NEW.SD<1,Y.C>
            END
        END

        IF Y.COLL.NEW.VMP<1,Y.C> NE "" AND Y.COLL.NEW.SD<1,Y.C> EQ "" AND NOT( Y.NUM.ID<1,Y.C>) THEN    ;*EVALUATE IF IT CONTAINS ID OF COLLATERAL THAT IT WAS CREATED PREVIOUSLY
            IF Y.TOT.COLL.SD NE '' THEN
                Y.TOT.COLL.SD := @VM : Y.COLL.NEW.VMP<1,Y.C>
            END ELSE
                Y.TOT.COLL.SD = Y.COLL.NEW.VMP<1,Y.C>
            END
        END
    NEXT Y.C

    IF Y.TOT.COLL.SD.END EQ '' THEN
        Y.TOT.COLL.SD.END = SUM(Y.TOT.COLL.SD)
    END ELSE
        Y.TOT.COLL.SD.END := @VM : SUM(Y.TOT.COLL.SD)
    END

RETURN

END
