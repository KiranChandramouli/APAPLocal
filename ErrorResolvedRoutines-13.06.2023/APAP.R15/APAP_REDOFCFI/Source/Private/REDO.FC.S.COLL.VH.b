* @ValidationCode : MjoxNzU3MDI4MzI3OkNwMTI1MjoxNjg2MjEyNzAyNTgyOklUU1M6LTE6LTE6NTQ3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 08 Jun 2023 13:55:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 547
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.COLL.VH
*=============================================================================
*
* Subroutine Type : ROUTINE
* Attached to     : TEMPLATE REDO.CREATE.ARRANGEMENT
* Attached as     : ROUTINE
* Primary Purpose : VALIDATION TO COLLATERAL FIRMAS SOLIDARIAS
*
*
* Incoming: NA
* Outgoing: NA
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Date            : 06.20.2011
* Development by  : TAM Latin America
*                   Bryan Torres (btorresalbornoz@temenos.com)
* Modified by:    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* Date            : 11.28.2011
* Notes           : PACS00152061 Resolution
* Modified by:    : Jorge Valarezo
* Date            : 01.03.2012
* Notes           : PACS00167218 Resolution
* Modified by     : Jorge Valarezo - TAM Latin America
* Date            : 11.05.2012
* Notes           : Rebuild it's a dependency of PAC00169926
* 06-06-2023      Conversion Tool       R22 Auto Conversion - FM TO @FM AND VM TO @VM AND ++ TO + = 1 AND > TO GT
* 06-06-2023      ANIL KUMAR B          R22 Manual Conversion - ADDING THE Y.CUSTOMER = R.NEW(REDO.FC.CUSTOMER)
*=============================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.COLLATERAL.CODE
    $INSERT I_F.USER
    $INSERT I_F.AA.PRODUCT

    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.COLLATERAL.REA
    $INSERT I_F.REDO.MAX.PRESTAR.VS

*****************************************************************************

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* =========
INITIALISE:
* =========
    Y.SEC.NO = R.NEW(REDO.FC.SEC.NO.STATE.VS)

    Y.SEC.CRET.DATA = R.NEW(REDO.FC.EFFECT.DATE)
    Y.CUSTOMER= R.NEW(REDO.FC.CUSTOMER)   ;*R22 MANUAL CONVERSION ADDING THE Y.CUSTOMER = R.NEW(REDO.FC.CUSTOMER)
    IF NOT(R.NEW(REDO.FC.SEC.CREATE.DATE.VS)) THEN

        R.NEW(REDO.FC.SEC.CREATE.DATE.VS) = Y.SEC.CRET.DATA
    END

    P.MESSAGE = ''

    FN.COLLATERAL.CODE = 'F.COLLATERAL.CODE'
    F.COLLATERAL.CODE = ''

    FN.REDO.COLLATERAL.REA = 'F.REDO.COLLATERAL.REA'
    F.REDO.COLLATERAL.REA = ''
    R.REDO.COLLATERAL.REA = ''
    Y.REDO.COLLATERAL.REA.ID = Y.COLLATERAL.TYPE
    Y.ERR.REDO.COLLATERAL.REA = ''

    FN.USR  = 'F.USER'
    F.USR   = ''
    R.USR   = ''

* Set the field validate user date
    WCAMPOU = "VAL.MODI.DATE"
    WCAMPOU = CHANGE(WCAMPOU,@FM,@VM)
    YPOSU=''

* Get the position for all fields
    CALL MULTI.GET.LOC.REF("USER",WCAMPOU,YPOSU)
    WPOSUSER  = YPOSU<1,1>

    FN.RMPV = 'F.REDO.MAX.PRESTAR.VS'
    F.RMPV = ''
    R.RMPV = ''
    Y.RMPV.ID = ''
    Y.ERR.RMPV = ''

    SEL.CMD = ''
    SEL.LIST = ''
    NO.OF.REC = ''
    Y.ERR = ''

    Y.EFFECTIVE.DATE = R.NEW(REDO.FC.EFFECT.DATE)
    Y.COLL.TYPE = R.NEW(REDO.FC.TYPE.OF.SEC.VS)

    FN.AA.PRODUCT = 'F.AA.PRODUCT'
    F.AA.PRODUCT  = ''
    R.AA.PRODUCT = ''
    Y.PRODUCT = R.NEW(REDO.FC.PRODUCT)

    CALL CACHE.READ(FN.AA.PRODUCT, Y.PRODUCT, R.AA.PRODUCT, YERR)
    Y.PRODUCT.GROUP = R.AA.PRODUCT<AA.PDT.PRODUCT.GROUP>
    R.NEW(REDO.FC.LOAN.GEN.LED) = Y.PRODUCT.GROUP


RETURN

* =========
OPEN.FILES:
* =========
    CALL OPF(FN.COLLATERAL.CODE,F.COLLATERAL.CODE)
    CALL OPF(FN.REDO.COLLATERAL.REA,F.REDO.COLLATERAL.REA)
    CALL OPF(FN.USR,F.USR)
    CALL OPF(FN.RMPV,F.RMPV)

RETURN

* ======
PROCESS:
* ======

    Y.I  = 1
    Y.COUNT = ""
    Y.COUNT = DCOUNT(Y.COLL.TYPE,@VM)

    LOOP
    WHILE Y.I LE Y.COUNT
        IF Y.COLL.TYPE<1,Y.I> AND NOT(Y.SEC.NO<1,Y.I>)THEN
            GOSUB TIPO.GARANTIA
            GOSUB CLASE.GARANTIA
            GOSUB MONEDA

            GOSUB VALOR.NOMINAL
            GOSUB VALOR.MONTO
            GOSUB SET.DESC
            GOSUB VAL.RATE
            GOSUB REA.VAL.CODE
        END
        IF Y.SEC.NO<1,Y.I> THEN
            Y.SEC.TYPE = Y.COLL.TYPE<1,Y.I>
            GOSUB VALIDA.CUST
        END ELSE
            GOSUB FECHA.CREA.GARANTIA
            GOSUB FECHA.CONSTITUCION.GARANTIA
            GOSUB FECHA.FORMALIZACION.GARANTIA
        END
        Y.I += 1
    REPEAT
RETURN

* ============
VALIDA.CUST:
* ============
    Y.CUST = FIELD(Y.SEC.NO<1,Y.I>, '.', 1)
    
    IF Y.CUSTOMER NE Y.CUST THEN
        TEXT = 'EB.FC.CUST.DIF'
        M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
        CALL STORE.OVERRIDE(M.CONT)
    END
RETURN

* ============
TIPO.GARANTIA:
* ============

* Validations applied to vehicles collaterals
    IF Y.COLL.TYPE<1,Y.I> EQ 350 THEN
* Back to Back control
        IF R.NEW(REDO.FC.TYPE.RATE.REV) EQ 'BACK.TO.BACK' OR R.NEW(REDO.FC.TYPE.RATE.REV) EQ '' THEN
            AF = REDO.FC.TYPE.RATE.REV
            ETEXT = 'EB-FC.RATE.REVISION.ERROR'
            CALL STORE.END.ERROR
        END

* Manual only if rev type is fixed
        IF R.NEW(REDO.FC.TYPE.RATE.REV) EQ 'FIJO' AND R.NEW(REDO.FC.FORM.REVIEW) NE 'MANUAL' THEN
            AF = REDO.FC.FORM.REVIEW
            ETEXT = 'EB-FC.FIXED.RATE.REVIEW'
            CALL STORE.END.ERROR
        END
    END
RETURN

* =============
CLASE.GARANTIA:
* =============
    CALL F.READ(FN.COLLATERAL.CODE,Y.COLL.TYPE<1,Y.I>,R.COLLATERAL.CODE,F.COLLATERAL.CODE,Y.COLL.ERR.MSJ)
    IF Y.COLL.ERR.MSJ THEN
        AF = REDO.FC.SEC.CLASSIFY.VS
        AV= Y.I
        ETEXT = "EB-FC-DONT-COLL-ASO"
        CALL STORE.END.ERROR
    END ELSE
        Y.TYPE.CODES = R.COLLATERAL.CODE<COLL.CODE.COLLATERAL.TYPE>
        Y.NEW.TYPE.CODE=R.NEW(REDO.FC.SEC.CLASSIFY.VS)
        LOCATE Y.NEW.TYPE.CODE IN Y.TYPE.CODES<1,1> SETTING YPOS THEN
        END
    END
RETURN

* ===========
REA.VAL.CODE:
* ===========

    Y.COLLATERAL.TYPE = R.NEW(REDO.FC.SEC.CLASSIFY.VS)<1,Y.I>   ;*** CLASE GARANTIA
    Y.VALUE.DATE = R.NEW(REDO.FC.SEC.CREATE.DATE.VS)<1,Y.I>     ;*** FECHA CREACION GARANTIA  REDO.FC.SEC.CREATE.DATE.VS
    Y.NOMINAL.VALUE = R.NEW(REDO.FC.SEC.VALUE.VS)<1,Y.I>        ;*** VALOR NOMINAL  REDO.FC.SEC.VALUE.VS
    Y.BLOCK.NO = R.NEW(REDO.FC.FABR.YEAR.VS)<1,Y.I>   ;*** ANIO FABRICACION REDO.FC.FABR.YEAR.VS
    Y.CENTRAL.BANK.VALUE = ''
    CALL F.READ(FN.REDO.COLLATERAL.REA, Y.COLLATERAL.TYPE, R.REDO.COLLATERAL.REA, F.REDO.COLLATERAL.REA, Y.ERR.REDO.COLLATERAL.REA)
    IF R.REDO.COLLATERAL.REA THEN
        PERC.F.Y = R.REDO.COLLATERAL.REA<R.COL.REA.PERC.FIVE.YEARS>
        PERCENTAGE = R.REDO.COLLATERAL.REA<R.COL.REA.PERCENTAGE>
        IF PERC.F.Y EQ '' THEN
*** DONT CALC WITH YEAR : 356 y 357
            Y.CENTRAL.BANK.VALUE = Y.NOMINAL.VALUE * PERCENTAGE / 100
        END ELSE
*** CALC WITH YEARS AND USE PERCENTAJE FIVE YEARS IF CONDITION APPLY: 351, 352, 353, 354 y 355
            Y.VALUE.YEAR = LEFT(Y.VALUE.DATE, 4)
***MID (CADENA, INICIO, NUMERO CAR)
            NUM.YEARS = Y.VALUE.YEAR - Y.BLOCK.NO
            IF NUM.YEARS GT 5 THEN
                Y.CENTRAL.BANK.VALUE = Y.NOMINAL.VALUE * PERC.F.Y / 100
            END  ELSE
                Y.CENTRAL.BANK.VALUE = Y.NOMINAL.VALUE * PERCENTAGE / 100
            END
        END

        Y.CENTRAL.BANK.VALUE = DROUND(Y.CENTRAL.BANK.VALUE, 2)
        R.NEW(REDO.FC.CENTR.BANK.VAL.VS )<1,Y.I> = Y.CENTRAL.BANK.VALUE
    END
RETURN

* =====
MONEDA:
* =====
    R.NEW(REDO.FC.COLL.CURRENCY.VS)<1,Y.I> = R.NEW(REDO.FC.LOAN.CURRENCY)
*edited for PACS00167218
*R.NEW(REDO.FC.FREC.REV.VS)<1,Y.I> = "12"

RETURN

* ==================
FECHA.CREA.GARANTIA:
* ==================
    Y.CREATE.DATE.VS = R.NEW(REDO.FC.SEC.CREATE.DATE.VS)
    Y.USR.ID = OPERATOR
    USR.ERR = ''
    CALL CACHE.READ(FN.USR,Y.USR.ID,R.USR,USR.ERR)

    IF USR.ERR THEN
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.USR
        CALL STORE.END.ERROR
    END ELSE
        VAR.BAN.DATE = R.USR<EB.USE.LOCAL.REF,WPOSUSER>
    END

    IF VAR.BAN.DATE EQ '' THEN
        AF = REDO.FC.SEC.CREATE.DATE.VS
        AV = Y.I
        ETEXT = 'EB-FC-USER-ALOW-VALID'
        CALL STORE.END.ERROR
    END

    Y.CREATE.DATE.CL = Y.CREATE.DATE.VS<1,Y.I>        ;*FECHA.CREACION.GARANTIA
    AF = REDO.FC.SEC.CREATE.DATE.VS
    AV = Y.I

* Control for back value user permission
    IF (VAR.BAN.DATE EQ 2) AND (Y.CREATE.DATE.CL NE TODAY) THEN
        ETEXT = 'EB-FC-NO.ALLOW-TO-USER'
        CALL STORE.END.ERROR
    END

* Future dates not allowed
    IF Y.CREATE.DATE.CL GT TODAY THEN
        ETEXT = 'EB-FC-DONT-FUTURE-DATE'
        CALL STORE.END.ERROR
    END

* Creation date not allowed to be before the loan creation
    IF Y.CREATE.DATE.CL LT Y.EFFECTIVE.DATE THEN
        Y.COLL.ID = R.NEW(REDO.FC.SEC.NO.STATE.VS)<1,Y.I>
        IF Y.COLL.ID EQ '' THEN
* New Collateral - error
            ETEXT = 'EB-FC-DONT-AFTER-DATE'
            CALL STORE.END.ERROR
        END ELSE
* Existing Collateral - override
            TEXT = 'EB.FC.BEFORE.DATE'
            M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
            CALL STORE.OVERRIDE(M.CONT)
        END
    END
RETURN

* ==========================
FECHA.CONSTITUCION.GARANTIA:
* ==========================
    Y.GTRANT.DATE.VS = R.NEW(REDO.FC.GRANTING.DATET.VS)
    IF Y.GTRANT.DATE.VS<1,Y.I> THEN
        IF Y.GTRANT.DATE.VS<1,Y.I> GT Y.EFFECTIVE.DATE THEN
            AF = REDO.FC.GRANTING.DATET.VS
            AV=Y.I
            ETEXT = 'EB-ALOW-BEFORE-DATE'
            CALL STORE.END.ERROR
        END
    END
RETURN

* ===========================
FECHA.FORMALIZACION.GARANTIA:
* ===========================

    Y.FECHA.CREACION.PRESTAMO = R.NEW(REDO.FC.EFFECT.DATE)
    Y.EXEC.DATE.VS = R.NEW(REDO.FC.EXECUTING.DATE.VS)<1,Y.I>

    IF Y.EXEC.DATE.VS THEN
        IF Y.EXEC.DATE.VS GT Y.EFFECTIVE.DATE THEN
            AF = REDO.FC.EXECUTING.DATE.VS
            AV = Y.I
            ETEXT = 'EB-ALOW-BEFORE-DATE'
            CALL STORE.END.ERROR
        END

        IF Y.EXEC.DATE.VS LT Y.FECHA.CREACION.PRESTAMO THEN
            AF = REDO.FC.EXECUTING.DATE.VS
            AV = Y.I
            ETEXT = 'EB-FC-DONT-AFTER-ACTUAL'
            CALL STORE.END.ERROR
        END
    END

RETURN

* ============
VALOR.NOMINAL:
* ============
    Y.TOTAl.TA = R.NEW(REDO.FC.TOT.VAL.VS)<1,Y.I>
    IF Y.TOTAl.TA THEN
        R.NEW(REDO.FC.SEC.VALUE.VS)<1,Y.I> = R.NEW(REDO.FC.TOT.VAL.VS)<1,Y.I>
        Y.NOMINAL.VALUE = R.NEW(REDO.FC.SEC.VALUE.VS)<1,Y.I>      ;*** VALOR NOMINAL
        R.NEW(REDO.FC.SEC.EXE.VAL.VS)<1,Y.I> = Y.NOMINAL.VALUE    ;*** VALOR DE EJECUCION
        R.NEW(REDO.FC.GEN.LEDGER.VAL.VS)<1,Y.I> = Y.NOMINAL.VALUE ;*** VALOR LIBRO MAYOR
* R.NEW(REDO.FC.MAX.LOAN.AMT.VS) = R.NEW(REDO.FC.GEN.LEDGER.VAL.VS) ; *** VALOR LIBRO MAYOR
    END

RETURN

* ==========
VALOR.MONTO:
* ==========
    Y.BLOCK.NO = R.NEW(REDO.FC.FABR.YEAR.VS)<1,Y.I>   ;*** ANIO FABRICACION
    Y.VALUE.DATE = R.NEW(REDO.FC.SEC.CREATE.DATE.VS)<1,Y.I>     ;*** FECHA CREACION GARANTIA
    Y.COL.SECTOR = R.NEW(REDO.FC.SECURED.VS)<1,Y.I>   ;*** NUEVO O USADO
    Y.NOMINAL.VALUE = R.NEW(REDO.FC.SEC.VALUE.VS)<1,Y.I>        ;*** VALOR NOMINAL

    IF Y.VALUE.DATE EQ '' THEN
        AF = REDO.FC.SEC.CREATE.DATE.VS
        AV= Y.I
        TEXT = "EB-FC-INVALID.CL.DATE "
        CALL STORE.END.ERROR
    END

    GOSUB OBTAIN.PERC.MAX.PRESTAR

RETURN

* =======
VAL.RATE:
* =======
    Y.RAT.DATE = R.NEW(REDO.FC.VAL.DATE.VS)<1,Y.I>
    IF Y.RAT.DATE GT TODAY THEN
        AF = REDO.FC.VAL.DATE.VS
        AV=Y.I
        ETEXT = 'EB-FC-DONT-AFTER-DATE'
        CALL STORE.END.ERROR
    END
RETURN

* ======================
OBTAIN.PERC.MAX.PRESTAR:
* ======================
* lfpazmino 11.12.2011
* Select modified to include the REDO.FC.VEHI.TYPE.VS as condition
    Y.VALUE.YEAR = LEFT(Y.VALUE.DATE, 4)
    NUM.YEARS = Y.VALUE.YEAR - Y.BLOCK.NO
    SEL.CMD  = ""

*MG 2012-12-10
*   IF Y.VALUE.YEAR AND Y.BLOCK.NO AND NUM.YEARS LE 0 AND NOT(R.NEW(REDO.FC.SECURED.VS)) THEN
*       R.NEW(REDO.FC.SECURED.VS)<1,Y.I> = 'NUEVO'
*   END
*   IF Y.VALUE.YEAR AND Y.BLOCK.NO AND NUM.YEARS GT 0 AND NOT(R.NEW(REDO.FC.SECURED.VS)) THEN
*       R.NEW(REDO.FC.SECURED.VS)<1,Y.I> = 'USADO'
*   END

*MG

    Y.VEH.CONDITION = R.NEW(REDO.FC.SECURED.VS)<1,Y.I>
    IF Y.VEH.CONDITION EQ '' THEN
        AF = REDO.FC.SECURED.VS
        AV= Y.I
        ETEXT = "EB-FC-CALC.MAX.PRESTAR"
        CALL STORE.END.ERROR
        RETURN
    END

    SEL.CMD  = " SELECT " : FN.RMPV
    SEL.CMD := " WITH VEH.TYPE EQ '" : Y.VEH.CONDITION : "'"
    IF Y.VEH.CONDITION EQ 'USADO' THEN
        SEL.CMD := " AND VEH.USE.FROM LE " : NUM.YEARS : " AND VEH.USE.TO GE " : NUM.YEARS
    END

    SEL.CMD := " AND PRODUCT.GROUP EQ '" : Y.PRODUCT.GROUP : "'"

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,Y.ERR)

    IF NO.OF.REC EQ 0 THEN
        ETEXT = "EB-FC-NO-DE-PARAMS"
        CALL STORE.END.ERROR
        RETURN
    END

    REMOVE Y.RMPV.ID FROM SEL.LIST SETTING Y.POS

    CALL F.READ(FN.RMPV, Y.RMPV.ID, R.RMPV, F.RMPV, Y.ERR.RMPV)
    IF Y.ERR.RMPV THEN
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.RMPV
        CALL STORE.END.ERROR
    END ELSE
        R.NEW(REDO.FC.LOAN.MAX.PERC.VS)<1,Y.I> = R.RMPV<R.MPV.PERC.MAX.AMT.LOAN>
*JV 20121210
        R.NEW(REDO.FC.MAX.LOAN.AMT.VS)<1,Y.I> = DROUND(R.NEW(REDO.FC.TOT.VAL.VS)<1,Y.I> * (R.RMPV<R.MPV.PERC.MAX.AMT.LOAN> / 100), 2)
    END

RETURN
* ======================
SET.DESC:
* ======================

    DESCRIP.TXT = R.NEW(REDO.FC.SERIAL.NUMBER.VS)<1,Y.I>:" ":R.NEW(REDO.FC.PLATE.NUMBER.VS)<1,Y.I>:" ":R.NEW(REDO.FC.VEHI.MARK.VS)<1,Y.I>:" ":R.NEW(REDO.FC.FABR.YEAR.VS)<1,Y.I>:" ":R.NEW(REDO.FC.MODEL.VS)<1,Y.I>:" ":R.NEW(REDO.FC.COLOR.VS)<1,Y.I>:" ":R.NEW(REDO.FC.CHASSIS.NUM.VS)<1,Y.I>
    DESCRIP.TXT := " ":R.NEW(REDO.FC.VEHI.TYPE.VS)<1,Y.I>:" ": R.NEW(REDO.FC.SECURED.VS)<1,Y.I>
    VAR.SUBCA = ''
    VAR.CONTADOR = LEN(DESCRIP.TXT)
    VAR.DIFE = VAR.CONTADOR / 35
    VAR.FILAS  = INT(VAR.DIFE)  + 1

    VAR.POS = 0
    VAR.I = 1
    LOOP
    WHILE VAR.I LE VAR.FILAS
        VAR.SUBCA = SUBSTRINGS(DESCRIP.TXT, VAR.POS + 1, 35)
        IF LEN(VAR.SUBCA) GT 0 THEN
            R.NEW(REDO.FC.DESCRIPTION.VS)<1,Y.I,VAR.I> = VAR.SUBCA
            VAR.POS += 35
        END
        VAR.I += 1
    REPEAT




RETURN
END
