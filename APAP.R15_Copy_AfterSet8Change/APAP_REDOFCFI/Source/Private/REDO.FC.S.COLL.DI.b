* @ValidationCode : MjotMTE3MzY5Nzc2NTpVVEYtODoxNjgzNjE2MDg4OTIzOklUU1M6LTE6LTE6MTYyOToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 May 2023 12:38:08
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1629
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.COLL.DI

*------------------------------------------------------------------------------------------------------------------
* Developer    : mgudino@temenos.com
* Date         : 2011-06-13
* Description  : This routine its in charge to validate DI COLL
* Input/Output:
* -------------
* In  :P.FIELD.NAME              Name of field that we have tu validate
*      R.NEW                     Common Variable with current Application Info
* Out :P.MESSAGE                  Message to send by pharent call.
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
* 1.0              2011-06-13    Marcelo Gudino   First Version
* 1.1              2011-09-13    Bryan Torres     Second Version
* 1.1              2011-10-18    Jorge Valarezo   Code Review
* 1.2              2011-12-13    Victor Panchi    PACS00169926
* 1.3              2012-01-08    Meza William     Code Review
* 1.2              2012-01-11    Jorge Valarezo   PACS00151814
* 2.0              2012-03-29    Jorge Valarezo   PACS00169936 Rebuild to get better performance when it going to use
*                                                 again a collateral
* 04-APRIL-2023      Conversion Tool       R22 Auto Conversion  - VM to @VM , FM to @FM ,F.READ to CACHE.READ and ++ to +=1
* 04-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_EB.TRANS.COMMON
*
    $INSERT I_F.LIMIT
    $INSERT I_F.COLLATERAL.RIGHT
    $INSERT I_F.COLLATERAL
    $INSERT I_F.OFS.SOURCE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.USER
    $INSERT I_F.COLLATERAL.CODE
    $INSERT I_F.CUSTOMER
*
    $INSERT I_RAPID.APP.DEV.COMMON
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FC.PROD.COLL.POLICY
    $INSERT I_F.REDO.FC.POL.TYPE.CLASS
    $INSERT I_F.REDO.COLLATERAL.REA
    $INSERT I_F.REDO.FC.COLL.TYPE.PARAMS
    $INSERT I_F.REDO.FC.COLL.CODE.PARAMS
    $INSERT I_F.AA.TERM.AMOUNT

    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

*------------------------------------------------------------------------------------------------------------------
* <region name=PROCESS>
PROCESS:
*------------------------------------------------------------------------------------------------------------------

* starts mgudino
    Y.SEC.CRET.DATA = R.NEW(REDO.FC.EFFECT.DATE)
    IF NOT(R.NEW(REDO.FC.SEC.CREATE.DATE.DI)) THEN
        R.NEW(REDO.FC.SEC.CREATE.DATE.DI) = Y.SEC.CRET.DATA
    END
* mgudino

    GOSUB TIPO.GARANTIA
    GOSUB EXTRACT.PRODUCT.DET
    APAP.REDOFCFI.redoFcSCollDiMontDisp() ;*R22 Manual Conversion - Added APAP.REDOFCFI
     
    Y.I = 1
    LOOP
    WHILE Y.I LE Y.COUNT
        IF NOT (Y.SEC.NO<1,Y.I>) THEN

            GOSUB CLASE.GARANTIA
            GOSUB MONTO.MAX
            GOSUB VALOR.NOMINAL
            GOSUB MONEDA
            GOSUB VALOR.ADMISIBLE

            GOSUB FECHA.CREACION.GARANTIA
            GOSUB NO.INSTR.GARANTIA
        END
        IF (Y.SEC.NO<1,Y.I>) THEN
            GOSUB VALIDA.CUST
        END
        Y.I += 1
    REPEAT
*

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

* </region>
*------------------------------------------------------------------------------------------------------------------
* <region name=TIPO.GARANTIA>
TIPO.GARANTIA:
*-----------------------------------------------------------------------------------------------------------------
    R.NEW(REDO.FC.TYPE.RATE.REV) = 'BACK.TO.BACK'
RETURN
* </region>
*------------------------------------------------------------------------------------------------------------------
EXTRACT.PRODUCT.DET:
*------------------------------------------------------------------------------------------------------------------
    Y.ID.ARR.PRD.CAT.TERM.AMOUNT = Y.ARR.PRODUCT:'-COMMITMENT':'-':Y.ARR.CURRENCY:'...'
    SELECT.STATEMENT = 'SELECT ':FN.AA.PRD.CAT.TERM.AMOUNT:' ':'WITH @ID LIKE ':Y.ID.ARR.PRD.CAT.TERM.AMOUNT
    AA.PRD.CAT.TERM.AMOUNT.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.ID.AA.PRD = ''
    CALL EB.READLIST(SELECT.STATEMENT,AA.PRD.CAT.TERM.AMOUNT.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    REMOVE Y.ID.AA.PRD FROM AA.PRD.CAT.TERM.AMOUNT.LIST SETTING POS

    CALL CACHE.READ(FN.AA.PRD.CAT.TERM.AMOUNT, Y.ID.AA.PRD, R.ARR.PRD.CAT.TERM.AMOUNT, Y.ERR)

    Y.VAL.AA.RISK.PER = R.ARR.PRD.CAT.TERM.AMOUNT<AA.AMT.LOCAL.REF,TXN.REF.ID.POS<3>>
    Y.VAL.NOMINAL.COLL = (Y.VAL.AA.RISK.PER/100) * Y.ARR.AMOUNT
    CALL SC.FORMAT.CCY.AMT(LCCY,Y.VAL.NOMINAL.COLL)


RETURN
*------------------------------------------------------------------------------------------------------------------
VALOR.NOMINAL:
*------------------------------------------------------------------------------------------------------------------

    IF Y.COUNT EQ 1 THEN
        YVALDISPINT = R.NEW(REDO.FC.MAX.LOAN.AMT.DI)<1,Y.I> * (Y.VAL.AA.RISK.PER/100)
* PACS00349144 - S
        CALL SC.FORMAT.CCY.AMT(LCCY,YVALDISPINT)
* PACS00349144 - E
        IF YVALDISPINT GE Y.VAL.NOMINAL.COLL THEN
            R.NEW(REDO.FC.SEC.VALUE.DI)<1,Y.I> = Y.VAL.NOMINAL.COLL
            R.NEW(REDO.FC.SEC.EXE.VAL.DI)<1,Y.I> = Y.VAL.NOMINAL.COLL
            R.NEW(REDO.FC.GEN.LEDGER.VAL.DI)<1,Y.I> = Y.VAL.NOMINAL.COLL
        END ELSE
            R.NEW(REDO.FC.SEC.VALUE.DI)<1,Y.I> = YVALDISPINT
            R.NEW(REDO.FC.SEC.EXE.VAL.DI)<1,Y.I> = YVALDISPINT
            R.NEW(REDO.FC.GEN.LEDGER.VAL.DI)<1,Y.I> = YVALDISPINT
        END
    END ELSE


        IF  Y.COLL.CLASS<1,Y.I> EQ 151 OR Y.COLL.CLASS<1,Y.I> EQ 152 OR Y.COLL.CLASS<1,Y.I> EQ 153 THEN
            IF R.NEW(REDO.FC.AVAIL.COLL.VAL.DI)<1,Y.I> THEN
                YVALDISPINT = DROUND(R.NEW(REDO.FC.MAX.LOAN.AMT.DI)<1,Y.I> * (Y.VAL.AA.RISK.PER/100), 2)
                YAMTACU += YVALDISPINT
                GOSUB VALOR.NOMINAL2
                CALL SC.FORMAT.CCY.AMT(LCCY,YVALDISP)
                R.NEW(REDO.FC.SEC.VALUE.DI)<1,Y.I> = YVALDISP
                R.NEW(REDO.FC.SEC.EXE.VAL.DI)<1,Y.I> = YVALDISP
                R.NEW(REDO.FC.GEN.LEDGER.VAL.DI)<1,Y.I> = YVALDISP
                YVALDISPACU += YVALDISPINT
            END
        END

    END
RETURN
*------------------------------------------------------------------------------------------------------------------
VALOR.NOMINAL2:
* -----------------------------------------------------------------------------------------------------------------
    IF YAMTACU LE Y.VAL.NOMINAL.COLL THEN
        YVALDISP = YVALDISPINT
    END ELSE
        YVALDISP = Y.VAL.NOMINAL.COLL - YVALDISPACU
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
VALOR.ADMISIBLE:
* -----------------------------------------------------------------------------------------------------------------
*POBLAR VALOR ADMISIBLE DEL REA
    Y.COLLATERAL.TYPE.DI = R.NEW(REDO.FC.SEC.CLASSIFY.DI)
    CALL F.READ(FN.REDO.COLLATERAL.REA, Y.COLLATERAL.TYPE.DI<1,Y.I>, R.REDO.COLLATERAL.REA, F.REDO.COLLATERAL.REA, Y.ERR.REDO.COLLATERAL.REA)
    IF Y.ERR.REDO.COLLATERAL.REA NE '' THEN
        ETEXT="EB-FC-READ.ERROR": @FM : FN.REDO.COLLATERAL.REA
        CALL STORE.END.ERROR
        RETURN
    END
    Y.NOMINAL.VALUE.DI = R.NEW(REDO.FC.SEC.VALUE.DI)<1,Y.I>
    PERCENTAGE = R.REDO.COLLATERAL.REA<R.COL.REA.PERCENTAGE>  ;*%  DEL VALOR DEL BIEN  QUE SE TOMARA EN CUENTA
*R.NEW(REDO.FC.LOAN.MAX.PERC.DI)<1,Y.I>=PERCENTAGE
    Y.CENTRAL.BANK.VALUE = Y.NOMINAL.VALUE.DI * PERCENTAGE / 100
    CALL SC.FORMAT.CCY.AMT(LCCY,Y.CENTRAL.BANK.VALUE)
    Y.CENTRAL.BANK.VALUE = DROUND(Y.CENTRAL.BANK.VALUE, 2)
    R.NEW(REDO.FC.CENT.BANK.VAL.DI)<1,Y.I> = Y.CENTRAL.BANK.VALUE

RETURN
*------------------------------------------------------------------------------------------------------------------
CLASE.GARANTIA:
* Ejecute events described in this field
*------------------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.COLLATERAL.CODE,Y.COLL.TYPE<1,Y.I>,R.COLLATERAL.CODE,F.COLLATERAL.CODE,ERR.MSJ)
    IF R.COLLATERAL.CODE THEN
        Y.TYPE.CODES= R.COLLATERAL.CODE<COLL.CODE.COLLATERAL.TYPE>
        Y.NEW.TYPE.CODE=R.NEW(REDO.FC.SEC.CLASSIFY.DI)<1,Y.I>
        GOSUB TEST2
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
TEST2:
    LOCATE Y.NEW.TYPE.CODE IN Y.TYPE.CODES<1,1> SETTING YPOS ELSE
        AF = REDO.FC.SEC.CLASSIFY.DI
        AV = Y.I
        ETEXT = "EB-FC-DONT-COLL-ASO"
        CALL STORE.END.ERROR
    END

RETURN
*------------------------------------------------------------------------------------------------------------------
MONEDA:
*------------------------------------------------------------------------------------------------------------------
* SETEAR VALORES POR DEFECTO REDO.FC.TYPE.OF.SEC.DI   POBLAR MONEDA COLL.CURRENCY
    R.NEW(REDO.FC.COLL.CURRENCY.DI)<1,Y.I>  = R.NEW(REDO.FC.LOAN.CURRENCY)
RETURN
*------------------------------------------------------------------------------------------------------------------
FECHA.CREACION.GARANTIA:
*------------------------------------------------------------------------------------------------------------------
    Y.FEC1=R.NEW(REDO.FC.SEC.CREATE.DATE.DI)
    Y.USR.ID = OPERATOR
    CALL CACHE.READ(FN.USR, Y.USR.ID, R.USR, Y.ERR)   ;*R22 Auto Conversion  - F.READ to CACHE.READ
    VAR.BAN.DATE = R.USR<EB.USE.LOCAL.REF,WPOSUSER>

    IF (VAR.BAN.DATE EQ '') THEN
        AF = REDO.FC.SEC.CREATE.DATE.DI
        ETEXT = 'EB-FC-USER-ALOW-VALID'
        CALL STORE.END.ERROR
    END
    Y.ERR.DT = ""
    GOSUB TEST1
    GOSUB FECHA.CONSTITUCION.GARANTIA
RETURN
*------------------------------------------------------------------------------------------------------------------
TEST1:
*------------------------------------------------------------------------------------------------------------------
    Y.F.CREA.GAR = R.NEW(REDO.FC.SEC.CREATE.DATE.DI)<1,Y.I>   ;*FECHA.CREACION.GARANTIA

    IF (VAR.BAN.DATE EQ 2) AND (Y.F.CREA.GAR NE TODAY) THEN
        AF = REDO.FC.SEC.CREATE.DATE.DI
        AV = Y.I
        ETEXT = 'EB-FC-NO.ALLOW-TO-USER'
        CALL STORE.END.ERROR
    END
    IF Y.F.CREA.GAR GT Y.EFFECT.DAY THEN
        Y.ERR.DT = "1"
        AF = REDO.FC.SEC.CREATE.DATE.DI
        AV = Y.I
        ETEXT = 'EB-FC-DONT-AFTER-DATE'
        CALL STORE.END.ERROR
    END
    IF Y.F.CREA.GAR LT Y.EFFECT.DAY THEN
* PACS00297652 - S
        Y.EF.DATE = 1
* PACS00297652 - E
        TEXT = 'EB.FC.BEFORE.EF.DATE'
        M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
        CALL STORE.OVERRIDE(M.CONT)
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
FECHA.CONSTITUCION.GARANTIA:
*------------------------------------------------------------------------------------------------------------------

    Y.GRTNG.DATE.DI = R.NEW(REDO.FC.GRANTING.DATE.DI)         ;*FECHA CONSTITUCION GARANTIA
    Y.F.CREA.GAR = R.NEW(REDO.FC.SEC.CREATE.DATE.DI)<1,Y.I>
    IF Y.GRTNG.DATE.DI<1,Y.I> GT Y.EFFECT.DAY THEN
        Y.ERR.DT = "1"
        AF = REDO.FC.GRANTING.DATE.DI
        AV = Y.I
        ETEXT = 'EB-FC-DONT-AFTER-DATE'
        CALL STORE.END.ERROR
    END

    Y.EXE.DATE = R.NEW(REDO.FC.EXECUTING.DATE.DI)<1,Y.I>
    IF Y.EXE.DATE GT Y.EFFECT.DAY THEN
        Y.ERR.DT = "1"
        AF = REDO.FC.EXECUTING.DATE.DI
        AV = Y.I
        ETEXT = 'EB-FC-DONT-AFTER-DATE'
        CALL STORE.END.ERROR
    END

    IF Y.EXE.DATE LT Y.EFFECT.DAY OR Y.GRTNG.DATE.DI<1,Y.I> NE Y.EFFECT.DAY AND Y.EF.DATE EQ "" THEN  ;* PACS00297652 - S/E
        TEXT = 'EB.FC.BEFORE.EF.DATE'
        M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
        CALL STORE.OVERRIDE(M.CONT)
    END

    IF Y.GRTNG.DATE.DI<1,Y.I> LT Y.EFFECT.DAY  AND Y.SEC.NO<1,Y.I> EQ "" THEN
        Y.ERR.DT = "1"
        AF = REDO.FC.GRANTING.DATE.DI
        AV = Y.I
        ETEXT = 'EB-FC-DONT-BEFORE-DATE'
        CALL STORE.END.ERROR
    END
    IF Y.EXE.DATE LT Y.EFFECT.DAY AND Y.SEC.NO<1,Y.I> EQ "" THEN
        Y.ERR.DT = "1"
        AF = REDO.FC.EXECUTING.DATE.DI
        AV = Y.I
        ETEXT = 'EB-FC-DONT-BEFORE-DATE'
        CALL STORE.END.ERROR

    END

    IF Y.F.CREA.GAR LT Y.EFFECT.DAY AND Y.SEC.NO<1,Y.I> EQ "" THEN
        Y.ERR.DT = "1"
        AF = REDO.FC.SEC.CREATE.DATE.DI
        AV = Y.I
        ETEXT = 'EB-FC-DONT-BEFORE-DATE'
        CALL STORE.END.ERROR
    END

    IF Y.ERR.DT NE "1" AND ( Y.GRTNG.DATE.DI<1,Y.I> NE Y.EXE.DATE OR Y.EXE.DATE NE Y.F.CREA.GAR OR Y.F.CREA.GAR NE Y.GRTNG.DATE.DI<1,Y.I> ) THEN
        IF Y.F.CREA.GAR NE Y.GRTNG.DATE.DI<1,Y.I> THEN
            AF = REDO.FC.GRANTING.DATE.DI
        END
        IF Y.F.CREA.GAR NE Y.EXE.DATE THEN
            AF = REDO.FC.EXECUTING.DATE.DI
        END
        AV = Y.I
        ETEXT = 'EB-FC-GAR-DAT-NMATCH'
        CALL STORE.END.ERROR
    END
RETURN
**------------------------------------------------------------------------------------------------------------------
NO.INSTR.GARANTIA:
**------------------------------------------------------------------------------------------------------------------

    IF Y.COLLATERAL.TYPE.DI<1,Y.I> EQ 152 THEN      ;* INSTRUMENTO A PLAZO
        GOSUB INSTRUMENTO.PLAZO
    END
    IF Y.COLLATERAL.TYPE.DI<1,Y.I> EQ 151 OR  Y.COLLATERAL.TYPE.DI<1,Y.I> EQ 153 THEN       ;* CTA AHORRO
        GOSUB CTA.AHORRO
    END
    IF Y.INSTR.CUSTOMER NE R.NEW(REDO.FC.SEC.HLD.IDEN.DI)<1,Y.I> THEN
        ETEXT = 'EB-FC.NOT.INST.OWNER'      ;*EL INSTRUMENTO DE LA GARANTIA NO PERTENCE AL GARANTE
        AF = REDO.FC.SEC.HLD.IDEN.DI
        AV = Y.I
        CALL STORE.END.ERROR
    END
    IF Y.INSTR.CUSTOMER NE '' THEN
        CALL CACHE.READ(FN.CUSTOMER, Y.INSTR.CUSTOMER, R.CUSTOMER, Y.ERR)
        R.NEW(REDO.FC.NAME.COLL.OWNER.DI)<1,Y.I> = R.CUSTOMER<EB.CUS.SHORT.NAME>
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
INSTRUMENTO.PLAZO:
*------------------------------------------------------------------------------------------------------------------
    CALL CACHE.READ(FN.AZ.ACCOUNT, Y.NO.INSTRUMENTO<1,Y.I>, R.AZ.ACCOUNT, Y.ERR)

    Y.INSTR.CUSTOMER = R.AZ.ACCOUNT<AZ.CUSTOMER>
    IF Y.INSTR.CUSTOMER NE Y.CUSTOMER THEN
        TEXT = 'EB-FC-IS-NOT-CUSTOMER'
        AV = Y.I
        M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
        CALL STORE.OVERRIDE(M.CONT)
    END
    Y.AZ.STATUS1 = R.AZ.ACCOUNT<AZ.LOCAL.REF,TXN.REF.ID.POS<1>>
    Y.AZ.STATUS2 = R.AZ.ACCOUNT<AZ.LOCAL.REF,TXN.REF.ID.POS<2>>

    IF Y.AZ.STATUS1 NE 'ACTIVE'  OR Y.AZ.STATUS2 EQ 'DECEASED' OR Y.AZ.STATUS2 EQ 'GARNISHMENT' THEN
        E = 'EB-FC-INST.INCOR'    ;*NUMERO DE INSTRUMENTO INCORRECTO
        AF = REDO.FC.NUM.INST.COLL.DI
        AV = Y.I
        ETEXT = E
        CALL STORE.END.ERROR
    END
    Y.FECHA.VENC.INSTR = R.AZ.ACCOUNT<AZ.MATURITY.DATE>
    R.NEW(REDO.FC.MATUR.DATE.DI)<1,Y.I> = Y.FECHA.VENC.INSTR

    IF Y.FECHA.VENC.INSTR LT Y.DATE.COLL.CRE THEN
        TEXT = 'EB.FC.BEFORE.DATE'
        M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
        CALL STORE.OVERRIDE(M.CONT)
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
CTA.AHORRO:
*------------------------------------------------------------------------------------------------------------------
    CALL CACHE.READ(FN.ACCOUNT, Y.NO.INSTRUMENTO<1,Y.I>, R.ACCOUNT, Y.ERR)
    Y.INSTR.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
    IF Y.INSTR.CUSTOMER NE Y.CUSTOMER THEN
        TEXT = 'EB-FC-ACCOUNT-ISNT-CUST'
        AF = REDO.FC.NUM.INST.COLL.DI
        AV = Y.I
        M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
        CALL STORE.OVERRIDE(M.CONT)
    END

    Y.AZ.STATUS1 = R.ACCOUNT<AC.LOCAL.REF,TXN.REF.ID.POS<4>>
    Y.AZ.STATUS2 = R.ACCOUNT<AC.LOCAL.REF,TXN.REF.ID.POS<5>>

    IF Y.AZ.STATUS2 EQ 'DECEASED' OR Y.AZ.STATUS2 EQ 'GARNISHMENT' OR Y.AZ.STATUS1 NE 'ACTIVE'  THEN
        E = 'EB-FC-INST.INCOR'
        AF = REDO.FC.NUM.INST.COLL.DI
        ETEXT = E
        CALL STORE.END.ERROR
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
MONTO.MAX:
*------------------------------------------------------------------------------------------------------------------
    Y.ERR=""
    CALL F.READ(FN.COLL.CODE.PARAMS, Y.COLL.CLASS<1,Y.I>, R.COLL.CODE.PARAMS, F.COLL.CODE.PARAMS, Y.ERR)
    R.NEW(REDO.FC.LOAN.MAX.PERC.DI)<1,Y.I>=R.COLL.CODE.PARAMS<FC.PR.PER.MAX.PRESTAR>
    YAMTMAX = (R.NEW(REDO.FC.LOAN.MAX.PERC.DI)<1,Y.I>/100) * R.NEW(REDO.FC.AVAIL.COLL.VAL.DI)<1,Y.I>
    CALL SC.FORMAT.CCY.AMT(LCCY,YAMTMAX)
    YAMTMAX = DROUND(YAMTMAX, 2)
    R.NEW(REDO.FC.MAX.LOAN.AMT.DI)<1,Y.I> = YAMTMAX
RETURN
*------------------------------------------------------------------------------------------------------------------
INITIALISE:
*------------------------------------------------------------------------------------------------------------------
    Y.ARR.PRODUCT        = R.NEW(REDO.FC.PRODUCT)   ;* PRODUCTO
    Y.ARR.CURRENCY       = R.NEW(REDO.FC.LOAN.CURRENCY)
    Y.ARR.AMOUNT         = R.NEW(REDO.FC.AMOUNT)
    Y.CUSTOMER           = R.NEW(REDO.FC.CUSTOMER)  ;* ID CUSTOMER
    Y.EFFECT.DAY         = R.NEW(REDO.FC.EFFECT.DATE)
    Y.COLL.TYPE          = R.NEW(REDO.FC.TYPE.OF.SEC.DI)      ;*COLLATERAL CODE
    Y.COLLATERAL.TYPE.DI = R.NEW(REDO.FC.SEC.CLASSIFY.DI)     ;* CLASE GARANTIA DI -> COLLATERAL TYPE
    Y.COLL.CLASS         = R.NEW(REDO.FC.SEC.CLASSIFY.DI)     ;* COLLATERAL TYPE
    Y.SEC.NO             = R.NEW(REDO.FC.SEC.NO.STATE.DI)     ;* SECUENCE NUMBER
    Y.DATE.COLL.CRE      = R.NEW(REDO.FC.SEC.CREATE.DATE.DI)  ;* FECHA DE CREACION DEL PRESTAMO
    Y.NOMINAL.VALUE.DI   = R.NEW(REDO.FC.SEC.VALUE.DI)        ;* VALOR NOMINAL
    Y.COUNT = DCOUNT(Y.COLL.TYPE,@VM)
    Y.NO.INSTRUMENTO     = R.NEW(REDO.FC.NUM.INST.COLL.DI)    ;*


    FN.USR               = 'F.USER'
    F.USR                = ''
    R.USR                = ''
    FN.LOCKING           = 'F.LOCKING'
    F.LOCKING            = ''
    R.LOCKING            = ''
    YERR                 = ''
    LOCKING.ID           = 'F.REDO.FC.POLNUM'
    F.REDO.COLLATERAL.REA = ''
    R.REDO.COLLATERAL.REA = ''
    Y.ERR.REDO.COLLATERAL.REA = ''
    FN.COLLATERAL        = "F.COLLATERAL"
    F.COLLATERAL         = ""
    FN.CUSTOMER          = "F.CUSTOMER"
    F.CUSTOMER           = ""
    R.CUSTOMER           = ""
    FN.COLLATERAL.CODE   = "F.COLLATERAL.CODE"
    F.COLLATERAL.CODE    = ""
    FN.COLL.CODE.PARAMS  = "F.REDO.FC.COLL.CODE.PARAMS"
    F.COLL.CODE.PARAMS   = ""
    R.COLL.CODE.PARAMS   = ""
    FN.AA.PRD.CAT.TERM.AMOUNT = 'F.AA.PRD.CAT.TERM.AMOUNT'
    F.AA.PRD.CAT.TERM.AMOUNT  = ''
    FN.REDO.COLLATERAL.REA    = 'F.REDO.COLLATERAL.REA'
    F.REDO.COLLATERAL.REA     = ''
    FN.AZ.ACCOUNT        = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT         = ''
    FN.ACCOUNT           = 'F.ACCOUNT'
    F.ACCOUNT            = ''
    FN.REDO.FC.PROD.COLL.POLICY = 'F.REDO.FC.PROD.COLL.POLICY'
    F.REDO.FC.PROD.COLL.POLICY  = ''

    Y.APP.NAME         = ''
    Y.FIELD.NAME       = ''
    Y.FECHA.VENC.INSTR = ''
    CONTINUAR          = 1
    Y.INSTR.CUSTOMER   = ''
* subir a variables globales y cargarlos en el OnRecord del RCA
    LOOP.CNT           = 1
    MAX.LOOPS          = 1
    PROCESS.GOAHEAD    = 1
    P.MESSAGE          = ''
    Y.REDO.FC.POL.ERR  = ''
    YPOSU              = ''
    GOSUB GET.LOCAL.FIELD
    WPOSUSER  = YPOSU<1,1>
    YAMTACU = 0
    YVALDISPACU = 0

    Y.EF.DATE = ''    ;* PACS00297652 - S/E

RETURN
*------------------------------------------------------------------------------------------------------------------
OPENFILES:
*------------------------------------------------------------------------------------------------------------------
    CALL OPF(FN.LOCKING,F.LOCKING)
    CALL OPF(FN.AA.PRD.CAT.TERM.AMOUNT, F.AA.PRD.CAT.TERM.AMOUNT)
    CALL OPF(FN.REDO.COLLATERAL.REA, F.REDO.COLLATERAL.REA)
    CALL OPF(FN.AZ.ACCOUNT, F.AZ.ACCOUNT)
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)
    CALL OPF(FN.COLLATERAL.CODE, F.COLLATERAL.CODE)
    CALL OPF(FN.USR, F.USR)
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)
    CALL OPF (FN.COLL.CODE.PARAMS,F.COLL.CODE.PARAMS)
RETURN

*------------------------------------------------------------------------------------------------------------------
GET.LOCAL.FIELD:
*------------------------------------------------------------------------------------------------------------------

    WCAMPOU         = 'VAL.MODI.DATE'
    Y.APP.NAME      = 'AZ.ACCOUNT'
    Y.FIELD.NAME<1> = 'L.AC.STATUS1'
    Y.FIELD.NAME<2> = 'L.AC.STATUS2'
    Y.FIELD.NAME    = CHANGE(Y.FIELD.NAME,@FM,@VM)

    TXN.REF.ID.POS      = ''
    LOC.REF.APPLICATION = Y.APP.NAME : @FM : 'AA.PRD.CAT.TERM.AMOUNT': @FM : 'USER' :@FM : 'ACCOUNT'
    LOC.REF.FIELDS      = Y.FIELD.NAME : @FM : 'L.AA.RISK.PER' : @FM : WCAMPOU : @FM : Y.FIELD.NAME
    LOC.REF.POS         = ''

    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    TXN.REF.ID.POS<1> = LOC.REF.POS<1,1>  ;*AZ.ACCOUNT L.FIELD.POS
    TXN.REF.ID.POS<2> = LOC.REF.POS<1,2>  ;*AZ.ACCOUNT L.FIELD.POS
    TXN.REF.ID.POS<3> = LOC.REF.POS<2,1>  ;*AA.PRD.CAT.TERM.AMOUNT L.FIELD.POS
    YPOSU             = LOC.REF.POS<3,1>  ;*USER L.FIELD.POS
    TXN.REF.ID.POS<4> = LOC.REF.POS<4,1>  ;*ACCOUNT L.FIELD.POS
    TXN.REF.ID.POS<5> = LOC.REF.POS<4,2>  ;*ACCOUNT L.FIELD.POS
RETURN

END
