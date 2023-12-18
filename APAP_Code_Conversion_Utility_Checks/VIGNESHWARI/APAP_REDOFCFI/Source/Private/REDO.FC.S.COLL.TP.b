* @ValidationCode : MjoxNjAwMjc5MTk1OkNwMTI1MjoxNzAyNjM5NTMyMTIyOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Dec 2023 16:55:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.COLL.TP

*-----------------------------------------------------------------------------
* Subroutine Type : ROUTINE
* Attached to     : TEMPLATE REDO.CREATE.ARRANGEMENT
* Attached as     : ROUTINE
* Primary Purpose : VALIDATION FOR TITULOS PUBLICOS
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
* Error Variables:
* ----------------
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Meza William - TAM Latin America
* Date            : 20.06.2011
*
* Modified by     : Luis Fernando Pazmino - TAM Latin America
* Notes           : Code review - PACS00170994
* Date            : 22.12.2011

* Modified by     : Jorge Valarezo - TAM Latin America
* Date            : 11.05.2012
* Notes           : Rebuild it's a dependency of PAC00169926


* Modified by     : mgudino - TAM Latin America
* Date            : 04.01.2013
* Notes           : Get the creation loan dates
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION        call routine format modified
*15-12-2023          VIGNESHWARI                      MANUAL R22 CODE CONVERSION        OPF IS ADDED,CHANGE F.READ TO F.CACHE.READ
*-----------------------------------------------------------------------------

******************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.COLLATERAL.CODE
    $INSERT I_F.USER
    $INSERT I_F.COLLATERAL

    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.COLLATERAL.REA
    $INSERT I_F.REDO.FC.COLL.CODE.PARAMS
******************************************************************************

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* =========
INITIALISE:
* =========
    Y.SEC.NO = R.NEW(REDO.FC.SEC.NO.STATE.TP)

* PORCENTAJE.MAXIMO.PRESTAR:
    Y.COLL.TYPE = R.NEW(REDO.FC.TYPE.OF.SEC.TP)     ;* TIPO GARANTIA
    FN.REDO.MAXIMO.PRESTAR.COLLATERAL = 'F.REDO.FC.COLL.CODE.PARAMS'
    F.REDO.MAXIMO.PRESTAR.COLLATERAL = ''
    R.REDO.MAXIMO.PRESTAR.COLLATERAL = ''
    Y.REDO.MAXIMO.PRESTAR.COLLATERAL.ID = Y.COLL.TYPE
    Y.ERR.REDO.MAXIMO.PRESTAR.COLLATERAL = ''

    P.MESSAGE = ''

* VALOR.ADMISIBLE.REA
    Y.COLLATERAL.CLASS = R.NEW(REDO.FC.SEC.CLASSIFY.TP)       ;* CLASE GARANTIA SE ESPERA 101 102 ETC
    Y.NOMINAL.VALUE = R.NEW(REDO.FC.SEC.VALUE.TP)   ;* VALOR NOMINAL

    FN.REDO.COLLATERAL.REA = 'F.REDO.COLLATERAL.REA'
    F.REDO.COLLATERAL.REA = ''
    R.REDO.COLLATERAL.REA = ''
    Y.REDO.COLLATERAL.REA.ID = Y.COLLATERAL.CLASS
    Y.ERR.REDO.COLLATERAL.REA = ''

    FN.USR  = 'F.USER'
    F.USR   = ''
    R.USR   = ''
    CALL OPF(FN.USR,F.USR) ;*MANUAL R22 CODE CONVERSION -  OPF IS ADDED

    FN.COLLATERAL = "F.COLLATERAL"
    F.COLLATERAL = ""

    FN.PARMS = 'F.REDO.FC.COLL.CODE.PARAMS'
    F.PARMS = ''
    R.PARMS = ''
    Y.PARMS.ERR.MSG = ''

    FN.COLLATERAL.CODE= "F.COLLATERAL.CODE"
    F.COLLATERAL.CODE=""
    CALL OPF(FN.COLLATERAL.CODE,F.COLLATERAL.CODE);* MANUAL R22 CODE CONVERSION-OPF IS ADDED

    FN.REDO.COLLATERAL.REA = 'F.REDO.COLLATERAL.REA'
    F.REDO.COLLATERAL.REA = ''
    R.REDO.COLLATERAL.REA = ''

    WCAMPO = "VAL.MODI.DATE"

    Y.APP = "USER"
    ZPOS = ''
    CALL MULTI.GET.LOC.REF(Y.APP,WCAMPO,ZPOS)
    WPOSUSER     = ZPOS<1,1>
RETURN

* =========
OPEN.FILES:
* =========
    CALL OPF(FN.REDO.MAXIMO.PRESTAR.COLLATERAL, F.REDO.MAXIMO.PRESTAR.COLLATERAL)
    CALL OPF(FN.REDO.COLLATERAL.REA, F.REDO.COLLATERAL.REA)

RETURN

* ======
PROCESS:
* ======
    GOSUB TASA.REV
    Y.COUNT = DCOUNT(Y.COLL.TYPE,@VM)
    Y.I = 1
    LOOP
    WHILE Y.I LE Y.COUNT
        IF NOT(Y.SEC.NO<1,Y.I>) THEN
            GOSUB ID.TITULAR.GARANTIA
            GOSUB CLASE.GARANTIA
            GOSUB PORCENTAJE.MAXIMO.PRESTAR
            GOSUB MONTO.MAXIMO.PRESTAR
            GOSUB VALOR.LIBRO.MAYOR
            GOSUB VALOR.ADMISIBLE.REA
            GOSUB MONEDA
        END
        IF Y.SEC.NO<1,Y.I> THEN
            Y.SEC.TYPE = Y.COLL.TYPE<1,Y.I>
            APAP.REDOFCFI.redoFcSMapping(Y.SEC.TYPE , Y.SEC.NO<1,Y.I>, Y.I) ;* MANUAL R22 CODE CONVERSION 
        END ELSE
            GOSUB FECHA.CREACION.GARANTIA
            GOSUB FECHA.CONSTITUCION.GARANTIA
        END
        Y.I += 1
    REPEAT
RETURN


* ==================
ID.TITULAR.GARANTIA:
* ==================
    IF R.NEW(REDO.FC.TYPE.OF.SEC.TP)<1,Y.I> NE '' AND R.NEW(REDO.FC.SEC.HLD.IDEN.TP)<1,Y.I> EQ '' THEN
        AF = REDO.FC.SEC.HLD.IDEN.TP
        ETEXT = 'EB-FC-CL.HLD.ID.MISSING'
        CALL STORE.END.ERROR
    END

RETURN

* =======
TASA.REV:
* =======
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

* Fixed clean RATE.FQY value
    IF R.NEW(REDO.FC.TYPE.RATE.REV) EQ 'FIJO' THEN
        R.NEW(REDO.FC.RATE.FQY) = ''
    END

* Setting Fecha Primera Revision
    IF  R.NEW(REDO.FC.RATE.FQY) NE '' AND R.NEW(REDO.FC.FST.RE.DATE) EQ '' THEN
        Y.MAT.DATE = R.NEW(REDO.FC.RATE.FQY)
        Y.EFFEC.DT = R.NEW(REDO.FC.EFFECT.DATE)
        CALL CALENDAR.DAY(Y.EFFEC.DT,'+', Y.MAT.DATE)
        R.NEW(REDO.FC.FST.RE.DATE) = Y.MAT.DATE
    END

RETURN

* ========================
PORCENTAJE.MAXIMO.PRESTAR:
* ========================
    CALL F.READ(FN.REDO.MAXIMO.PRESTAR.COLLATERAL, Y.COLLATERAL.CLASS<1,Y.I>, R.REDO.MAXIMO.PRESTAR.COLLATERAL, F.REDO.MAXIMO.PRESTAR.COLLATERAL, Y.ERR.REDO.MAXIMO.PRESTAR.COLLATERAL)
   CALL F.CACHE.READ(FN.REDO.MAXIMO.PRESTAR.COLLATERAL, Y.COLLATERAL.CLASS<1,Y.I>, R.REDO.MAXIMO.PRESTAR.COLLATERAL, F.REDO.MAXIMO.PRESTAR.COLLATERAL, Y.ERR.REDO.MAXIMO.PRESTAR.COLLATERAL);* MANUAL R22 CODE CONVERSION -CHANGE F.READ TO F.CACHE.READ
    PERCENTAGE = R.REDO.MAXIMO.PRESTAR.COLLATERAL<FC.PR.PER.MAX.PRESTAR>          ;* PENDIENTE DEFINIR CAMPO % DE ESTA TABLA
    IF (PERCENTAGE) GT 0 THEN
        R.NEW(REDO.FC.LOAN.MAX.PERC.TP)<1, Y.I> = PERCENTAGE
    END ELSE
        AF = REDO.FC.LOAN.MAX.PERC.TP
        AV = Y.I
        TEXT = 'EB-FC-NO-DE-PARAMS '
        CALL STORE.END.ERROR
    END
RETURN

* ===================
MONTO.MAXIMO.PRESTAR:
* ===================
    Y.PORCENTAJE.MAX.PRES = R.NEW(REDO.FC.LOAN.MAX.PERC.TP)<1,Y.I>
    Y.VALOR.NOMINAL = R.NEW(REDO.FC.SEC.VALUE.TP)<1,Y.I>
    R.NEW(REDO.FC.MAX.LOAN.AMT.TP)<1,Y.I> = DROUND((Y.VALOR.NOMINAL*Y.PORCENTAJE.MAX.PRES/100), 2)

RETURN

* ================
VALOR.LIBRO.MAYOR:
* ================
    R.NEW(REDO.FC.GEN.LEDGER.VAL.TP)<1,Y.I> = R.NEW(REDO.FC.SEC.VALUE.TP)<1,Y.I>
    R.NEW(REDO.FC.SEC.EXE.VAL.TP)<1,Y.I> = R.NEW(REDO.FC.SEC.VALUE.TP)<1,Y.I>
RETURN

* ======================
FECHA.CREACION.GARANTIA:
* ======================

    Y.FEC1 = R.NEW(REDO.FC.SEC.CREATE.DATE.TP)
* starts mgudino
    Y.SEC.CRET.DATA = R.NEW(REDO.FC.EFFECT.DATE)
    IF NOT(Y.FEC1) THEN
        R.NEW(REDO.FC.SEC.CREATE.DATE.TP) = Y.SEC.CRET.DATA
    END
* mgudino
    Y.ERR = ''
    Y.USR.ID = OPERATOR
    CALL CACHE.READ(FN.USR, Y.USR.ID, R.USR, Y.ERR) ;* AUTO R22 CODE CONVERSION
    VAR.BAN.DATE = R.USR<EB.USE.LOCAL.REF,WPOSUSER>

    IF (VAR.BAN.DATE EQ '') THEN
        AF = REDO.FC.SEC.CREATE.DATE.TP
        TEXT = 'EB-FC-USER-ALOW-VALID'
        CALL STORE.END.ERROR
    END

    Y.F.CREA.GAR = R.NEW(REDO.FC.SEC.CREATE.DATE.TP)<1,Y.I>   ;*FECHA.CREACION.GARANTIA
    IF (VAR.BAN.DATE EQ 2) AND (Y.F.CREA.GAR NE TODAY) THEN
        AF = REDO.FC.SEC.CREATE.DATE.TP
        AV = Y.I
        ETEXT = 'EB-FC-NO.ALLOW-TO-USER'
        CALL STORE.END.ERROR
    END
    IF Y.F.CREA.GAR<1,Y.I> GT TODAY THEN
        AF = REDO.FC.SEC.CREATE.DATE.TP
        AV = Y.I
        ETEXT = 'EB-FC-DONT-AFTER-DATE'
        CALL STORE.END.ERROR
    END
    IF Y.F.CREA.GAR<1,Y.I> LT TODAY THEN
        TEXT = 'EB.FC.BEFORE.DATE'
        M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
        CALL STORE.OVERRIDE(M.CONT)

    END
RETURN

* ==========================
FECHA.CONSTITUCION.GARANTIA:
* ==========================

*Get the values for the local fields (Granting Date)
    Y.FEC2 = R.NEW(REDO.FC.GRANTI.DATE.TP)<1,Y.I>
* CHECK THE DATE THAT NOT GREAT THAN THE ACTUAL DATE
*This validation must be related with creation date instaed TODAY
    IF Y.FEC2 LT Y.F.CREA.GAR OR Y.FEC2 GT Y.F.CREA.GAR THEN
        AF = REDO.FC.GRANTI.DATE.TP
        AV = Y.I
        ETEXT = 'EB-FC-JUST-TODAY'
        CALL STORE.END.ERROR
    END

    Y.FEC3 = R.NEW(REDO.FC.EXECUTING.DATE.TP)<1,Y.I>
    IF Y.FEC3 THEN
        IF Y.FEC3 GT Y.F.CREA.GAR OR Y.FEC2<1,Y.I> LT Y.F.CREA.GAR THEN
            AF = REDO.FC.EXECUTING.DATE.TP
            AV = Y.I
            ETEXT = 'EB-FC-JUST-TODAY'
            CALL STORE.END.ERROR
        END
    END


RETURN

* ==================
VALOR.ADMISIBLE.REA:
* ==================
    CALL F.READ(FN.REDO.COLLATERAL.REA, Y.REDO.COLLATERAL.REA.ID<1,Y.I>, R.REDO.COLLATERAL.REA, F.REDO.COLLATERAL.REA, Y.ERR.REDO.COLLATERAL.REA)
    PERCENTAGE = R.REDO.COLLATERAL.REA<R.COL.REA.PERCENTAGE>  ;* PORCENTAJE DEL REA--> %  DEL VALOR DEL BIEN  QUE SE TOMARA EN CUENTA
    Y.CENTRAL.BANK.VALUE = Y.NOMINAL.VALUE<1,Y.I>*(PERCENTAGE/100)
    Y.CENTRAL.BANK.VALUE = DROUND(Y.CENTRAL.BANK.VALUE, 2)
    R.NEW(REDO.FC.CENT.BANK.VAL.TP)<1,Y.I> = Y.CENTRAL.BANK.VALUE       ;*VALOR ADMISIBLE DEL REA

RETURN

* =============
CLASE.GARANTIA:
* =============
    CALL F.READ(FN.COLLATERAL.CODE,Y.COLL.TYPE<1,Y.I>,R.COLLATERAL.CODE,F.COLLATERAL.CODE,ERR.MSJ)
    IF R.COLLATERAL.CODE THEN
        Y.TYPE.CODES = R.COLLATERAL.CODE<COLL.CODE.COLLATERAL.TYPE>
        Y.NEW.TYPE.CODE = R.NEW(REDO.FC.SEC.CLASSIFY.TP)<1, Y.I>
        LOCATE Y.NEW.TYPE.CODE IN Y.TYPE.CODES<1,1> SETTING YPOS ELSE
            AF = REDO.FC.SEC.CLASSIFY.TP
            AV = Y.I
            ETEXT = 'EB-FC-DONT-COLL-ASO'
            CALL STORE.END.ERROR
        END
    END
RETURN

* =====
MONEDA:
* =====
    R.NEW(REDO.FC.COLL.CURRENCY.TP)<1,Y.I> = R.NEW(REDO.FC.LOAN.CURRENCY)
RETURN

END
