* @ValidationCode : MjotMTQ4NDg2MTExOkNwMTI1MjoxNzAyOTkwOTQ1NjEzOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 18:32:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.COLL.DE

*=============================================================================
* Subroutine Type : ROUTINE
* Attached to     : TEMPLATE REDO.CREATE.ARRANGEMENT
* Attached as     : ROUTINE
* Primary Purpose : VALIDATION TO COLLATERAL DEPOSITOS EXTERNOS
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
*------------------------------------------------------------- ----------------
* Modification History:
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : JUNIO 16 2011
*
* Modified by     : Luis Fernando Pazmino - TAM Latin America
* Notes           : Code review - PACS00170994
* Date            : 22.12.2011

* Modified by     : Jorge Valarezo - TAM Latin America
* Date            : 11.05.2012
* Notes           : Rebuild it's a dependency of PAC00169926
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*15-12-2023         VIGNESHWARI                     MANUAL R22 CODE CONVERSION            OPF IS ADDED,CHANGE F.READ TO F.CACHE.READ
*=============================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.COLLATERAL.CODE
    $INSERT I_F.USER

    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FC.COLL.CODE.PARAMS
    $INSERT I_F.REDO.COLLATERAL.REA
*************************************************************************

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* ======
PROCESS:
* ======
    GOSUB TASA.REV

    Y.I = ""
    Y.COUNT = ""
    Y.COUNT = DCOUNT(Y.COLL.TYPE,@VM)
    Y.I = 1
    LOOP
    WHILE Y.I LE Y.COUNT
        IF Y.COLL.TYPE<1,Y.I> AND NOT(Y.SEC.NO<1,Y.I>)THEN
            GOSUB ID.TITULAR.GARANTIA
            GOSUB CLASE.GARANTIA
            GOSUB VAL.MAX.PRESTAR
            GOSUB VAL.REA.COLL
            GOSUB MONEDA
            GOSUB NOMINAL.VALUE
        END

* starts mgudino
        Y.SEC.CRET.DATA = R.NEW(REDO.FC.EFFECT.DATE)
        IF NOT(R.NEW(REDO.FC.SEC.CREATE.DATE.DE)) THEN
            R.NEW(REDO.FC.SEC.CREATE.DATE.DE) = Y.SEC.CRET.DATA
        END
* mgudino
        IF Y.SEC.NO<1,Y.I> THEN
            Y.SEC.TYPE = Y.COLL.TYPE<1,Y.I>
            GOSUB VALIDA.CUST
        END ELSE
            GOSUB FECHA.CREA.GARANTIA.USUA
            GOSUB FECHA.CREA.GARANTIA
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

* ==================
ID.TITULAR.GARANTIA:
* ==================
    IF R.NEW(REDO.FC.TYPE.OF.SEC.DE) NE '' AND R.NEW(REDO.FC.SEC.HLD.IDEN.DE) EQ '' THEN
        AF = REDO.FC.SEC.HLD.IDEN.DE
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


* ==============
VAL.MAX.PRESTAR:
* ==============
 *   CALL F.READ(FN.PARMS,R.NEW(REDO.FC.SEC.CLASSIFY.DE)<1,Y.I> ,R.PARMS,F.PARMS,Y.PARMS.ERR.MSG)
     CALL F.CACHE.READ(FN.PARMS,R.NEW(REDO.FC.SEC.CLASSIFY.DE)<1,Y.I> ,R.PARMS,F.PARMS,Y.PARMS.ERR.MSG);*MANUAL R22 CODE CONVERSION-CHANGE F.READ TO F.CACHE.READ
    IF Y.PARMS.ERR.MSG THEN
        AF = REDO.FC.TYPE.OF.SEC.DE
        AV = Y.I
        ETEXT = 'EB-FC-NO-DE-PARAMS '
        CALL STORE.END.ERROR
    END ELSE
        Y.MAX.PERC.LOAN =  R.PARMS<FC.PR.PER.MAX.PRESTAR>
    END
    IF Y.MAX.PERC.LOAN GT 0 THEN
        R.NEW(REDO.FC.LOAN.MAX.PERC.DE)<1,Y.I>=Y.MAX.PERC.LOAN
        R.NEW(REDO.FC.MAX.LOAN.AMT.DE)= DROUND((Y.NOMINAL.VALUE * Y.MAX.PERC.LOAN / 100), 2)

    END

RETURN

* =============
CLASE.GARANTIA:
* =============
    CALL F.READ(FN.COLLATERAL.CODE,Y.COLL.TYPE<1,Y.I>,R.COLLATERAL.CODE,F.COLLATERAL.CODE,ERR.MSJ)
    IF R.COLLATERAL.CODE THEN
        Y.TYPE.CODES = R.COLLATERAL.CODE<COLL.CODE.COLLATERAL.TYPE>
        Y.NEW.TYPE.CODE = R.NEW(REDO.FC.SEC.CLASSIFY.DE)
        LOCATE Y.NEW.TYPE.CODE IN Y.TYPE.CODES<1,1> SETTING YPOS ELSE
            AF = REDO.FC.SEC.CLASSIFY.DE
            AV = Y.I
            ETEXT = 'EB-FC-DONT-COLL-ASO'
            CALL STORE.END.ERROR
        END
    END
RETURN

* ===========
VAL.REA.COLL:
* ===========
    Y.COLLATERAL.TYPE = R.NEW(REDO.FC.SEC.CLASSIFY.DE)<1,Y.I>
    CALL F.READ(FN.REDO.COLLATERAL.REA, Y.COLLATERAL.TYPE , R.REDO.COLLATERAL.REA, F.REDO.COLLATERAL.REA, Y.ERR.REDO.COLLATERAL.REA)
    IF R.REDO.COLLATERAL.REA THEN
        PERC.F.Y = R.REDO.COLLATERAL.REA<R.COL.REA.PERC.FIVE.YEARS>
        PERCENTAGE = R.REDO.COLLATERAL.REA<R.COL.REA.PERCENTAGE>
        Y.CENTRAL.BANK.VALUE = Y.NOMINAL.VALUE * PERCENTAGE / 100
        Y.CENTRAL.BANK.VALUE = DROUND(Y.CENTRAL.BANK.VALUE, 2)
        R.NEW(REDO.FC.CENT.BANK.VAL.DE)<1,Y.I> = Y.CENTRAL.BANK.VALUE
    END
RETURN

* =====
MONEDA:
* =====
    R.NEW(REDO.FC.COLL.CURRENCY.DE)<1,Y.I> = R.NEW(REDO.FC.LOAN.CURRENCY)
RETURN

* =======================
FECHA.CREA.GARANTIA.USUA:
* =======================
    Y.USR.ID = OPERATOR
    CALL CACHE.READ(FN.USR, Y.USR.ID, R.USR, Y.USR.ERROR);* R22 Auto Conversion
    IF Y.USR.ERROR THEN
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.USR
        CALL STORE.END.ERROR
    END ELSE
        VAR.BAN.DATE = R.USR<EB.USE.LOCAL.REF,WPOSUSER>
    END

    IF VAR.BAN.DATE EQ '' THEN
        AF = REDO.FC.SEC.CREATE.DATE.DE
        AV = Y.I
        ETEXT = 'EB-FC-USER-ALOW-VALID'
        CALL STORE.END.ERROR
    END

    Y.FEC1 = R.NEW(REDO.FC.SEC.CREATE.DATE.DE)<1,Y.I>
*VALIDATE THAT THE USER HAVE ACCESS TO MODIFY THE DATE
    IF (VAR.BAN.DATE EQ 2) AND (Y.FEC1 NE TODAY) THEN
        AF = REDO.FC.SEC.CREATE.DATE.DE
        AV = Y.I
        ETEXT = 'EB-FC-NO.ALLOW-TO-USE'
        CALL STORE.END.ERROR
    END

*TEST THE DATE
    IF Y.FEC1 GT TODAY THEN
        AF = REDO.FC.SEC.CREATE.DATE.DE
        AV = Y.I
        ETEXT = 'EB-FC-DONT-AFTER-DATE'
        CALL STORE.END.ERROR
    END

*VALIDATE THE DATE IS LESS THAN ACTUAL DATE
    IF (Y.FEC1 LT TODAY) THEN
        TEXT = 'EB.FC.BEFORE.DATE'
        M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
        CALL STORE.OVERRIDE(M.CONT)
    END


* ==================
FECHA.CREA.GARANTIA:
* ==================

*Get the values for the local fields (Granting Date)
    Y.FEC2 = R.NEW(REDO.FC.GRANTING.DATE.DE)<1,Y.I>
    IF Y.FEC2 THEN
* CHECK THE DATE THAT NOT GREAT THAN THE ACTUAL DATE
        IF Y.FEC2 LT Y.FEC1 OR Y.FEC2 GT TODAY THEN
            AF = REDO.FC.GRANTING.DATE.DE
            AV = Y.I
            ETEXT = 'EB-FC-JUST-TODAY'
            CALL STORE.END.ERROR
        END
    END

*Get the values for the local fields (Granting Date)
    Y.FEC3 = R.NEW(REDO.FC.EXECUTING.DATE.DE)<1,Y.I>
    IF Y.FEC3 THEN
* CHECK THE DATE THAT NOT GREAT THAN THE ACTUAL DATE
        IF Y.FEC3 LT Y.FEC1 OR Y.FEC3 GT Y.FEC1 THEN
            AF = REDO.FC.EXECUTING.DATE.DE
            AV= Y.I
            ETEXT = 'EB-FC-DATE-SAME-CREATE'
            CALL STORE.END.ERROR
        END
    END

RETURN

* ===========================
FECHA.FORMALIZACION.GARANTIA:
* ===========================

    Y.FECHA.CREACION.PRESTAMO = R.NEW(REDO.FC.EFFECT.DATE)

    Y.FEC3 = R.NEW(REDO.FC.EXECUTING.DATE.DE)<1,Y.I>
    IF Y.FEC3 THEN
        IF Y.FEC3 GT TODAY THEN
            AF = REDO.FC.EXECUTING.DATE.DE
            AV = Y.I
            ETEXT = 'EB-ALOW-BEFORE-DATE'
            CALL STORE.END.ERROR
        END

        IF Y.FEC3 LT Y.FECHA.CREACION.PRESTAMO THEN
            TEXT = 'EB.FC.BEFORE.DATE'
            M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
            CALL STORE.OVERRIDE(M.CONT)
        END
    END

RETURN

* ============
NOMINAL.VALUE:
* ============
    Y.NOMINAL.VALUE = R.NEW(REDO.FC.SEC.VALUE.DE)<1,Y.I>        ;*** VALOR NOMINAL
    R.NEW(REDO.FC.SEC.EXE.VAL.DE)<1,Y.I> = Y.NOMINAL.VALUE      ;*** VALOR DE EJECUCION
    R.NEW(REDO.FC.GEN.LEDGER.VAL.DE)<1,Y.I> = Y.NOMINAL.VALUE   ;*** VALOR LIBRO MAYOR
RETURN

* =========
OPEN.FILES:
* =========
RETURN

* =========
INITIALISE:
* =========

    WCAMPO = "VAL.MODI.DATE"
    Y.APP = "USER"
    ZPOS = ''
    CALL MULTI.GET.LOC.REF(Y.APP,WCAMPO,ZPOS)
    WPOSUSER = ZPOS<1,1>

    P.MESSAGE = ''
    FN.COLLATERAL= "F.COLLATERAL"
    F.COLLATERAL=""

    FN.PARMS  = 'F.REDO.FC.COLL.CODE.PARAMS'
    F.PARMS   = ''
    R.PARMS   = ''
    Y.PARMS.ERR.MSG = ''
    CALL OPF(FN.PARMS,F.PARMS);*MANUAL R22 CODE CONVERSION -OPF IS ADDED

    FN.COLLATERAL.CODE= "F.COLLATERAL.CODE"
    F.COLLATERAL.CODE=""
    CALL OPF(FN.COLLATERAL.CODE,F.COLLATERAL.CODE);*MANUAL R22 CODE CONVERSION -OPF IS ADDED

    FN.REDO.COLLATERAL.REA = 'F.REDO.COLLATERAL.REA'
    F.REDO.COLLATERAL.REA = ''
    R.REDO.COLLATERAL.REA = ''
    CALL OPF(FN.REDO.COLLATERAL.REA,F.REDO.COLLATERAL.REA);*MANUAL R22 CODE CONVERSION -OPF IS ADDED

    FN.USR = 'F.USER'
    F.USR = ''
    R.USR = ''
    CALL OPF(FN.USR,F.USR)  ;*MANUAL R22 CODE CONVERSION -OPF IS ADDED
    Y.COLL.TYPE = R.NEW(REDO.FC.TYPE.OF.SEC.DE)
    Y.SEC.NO = R.NEW(REDO.FC.SEC.NO.STATE.DE)
    Y.NOMINAL.VALUE = R.NEW(REDO.FC.SEC.VALUE.DE)
    Y.CUSTOMER           = R.NEW(REDO.FC.CUSTOMER)

RETURN

END
