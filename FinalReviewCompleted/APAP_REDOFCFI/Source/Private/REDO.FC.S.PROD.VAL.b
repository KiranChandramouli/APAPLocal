* @ValidationCode : MjoxNzc1MDI1NDEyOlVURi04OjE2ODQ4NTEyMDQ2MzI6SVRTUzotMTotMToxMTk2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 19:43:24
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1196
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.PROD.VAL

* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.CREATE.ARRANGEMENT.VALIDATE
* Attached as     : ROUTINE
* Primary Purpose : Get Paymnent Schedule definition in order to populate the fields.
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
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            : 22 Jun 2011
*
* Edited by       : Jorge Valarezo - TAM Latin America
* Date            : 03 Jan 2012
* Edited by       : ;Marcelo G - TAM Latin America
* Date            : 15 May 2012
* 05-APRIL-2023      Harsha                R22 Auto Conversion  - VM to @VM , SM to @SM , I to I.VAR and J to J.VAR
* 05-APRIL-2023      Harsha                R22 Manual Conversion - call routine format modified
*----------------------------------------------------------------------------
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.PRODUCT.DESIGNER
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.AA.PRODUCT
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.CUSTOMER

    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FC.PROD.COLL.POLICY
    $USING APAP.TAM

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS.MAIN
    END


RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS.MAIN:
*============

    GOSUB GET.GRP.PROD
    GOSUB GET.SEC.AND.REV
*GOSUB GET.COLL.CODE
    GOSUB GET.RATE
    GOSUB GET.PAYSCH
    GOSUB SET.DAO
    GOSUB SET.MANDATORYS
* IF LIMIT EXIST, MG 19.08.2011
    IF NOT(R.NEW(REDO.FC.ID.LIMIT)) THEN
        APAP.TAM.redoFcSSetLimit();*R22 Manual Conversion
    END ELSE
        APAP.REDOFCFI.redoFcSSetValLimit() ;*R22 Manual Conversion
    END
RETURN
*-----------------------------------------------------------------------------------
GET.GRP.PROD:
*=============

    CALL CACHE.READ(FN.AA.PRODUCT, Y.PRODUCT, R.AA.PRODUCT, YERR)
    Y.PRODUCT.GROUP = R.AA.PRODUCT<AA.PDT.PRODUCT.GROUP>
    R.NEW(REDO.FC.LOAN.GEN.LED) = Y.PRODUCT.GROUP

    IF NOT(R.NEW(REDO.FC.ID.ARRANGEMENT)) THEN
        CALL AA.GET.ARRANGEMENT.ID(ARRANGEMENT.ID)
        R.NEW(REDO.FC.ID.ARRANGEMENT) = ARRANGEMENT.ID
    END
RETURN
*------------------------
GET.COLL.CODE:
*=============
    CALL CACHE.READ(FN.REDO.FC.PROD.COLL.POLICY, Y.PRODUCT, R.REDO.FC.PROD.COLL.POLICY, YERR)
    NRO.COLL.CODE = DCOUNT(R.REDO.FC.PROD.COLL.POLICY<REDO.CPL.COLLATERAL.CODE>, @VM)
    IF NRO.COLL.CODE NE 1 THEN
        RETURN
    END
    Y.COLL.CODE = R.REDO.FC.PROD.COLL.POLICY<REDO.CPL.COLLATERAL.CODE>
    BEGIN CASE
        CASE Y.COLL.CODE EQ 450
* 450 Bienes raicea
            Y.CONT.BR = DCOUNT(R.NEW(REDO.FC.TYPE.OF.SEC.BR), @VM)
            Y.BR =1
            LOOP
            WHILE Y.BR LE Y.CONT.BR
                R.NEW(REDO.FC.TYPE.OF.SEC.BR)<1,Y.BR> = Y.COLL.CODE
                Y.BR+=1
            REPEAT
        CASE Y.COLL.CODE EQ 350
* 350 Vehiculos
            Y.CONT.VS = DCOUNT(R.NEW(REDO.FC.TYPE.OF.SEC.VS), @VM)
            Y.VS =1
            LOOP
            WHILE Y.VS LE Y.CONT.VS
                R.NEW(REDO.FC.TYPE.OF.SEC.VS)<1,Y.VS> = Y.COLL.CODE
                Y.VS+=1
            REPEAT
        CASE Y.COLL.CODE EQ 100
* 100 Titulos Publicos
            Y.CONT.TP = DCOUNT(R.NEW(REDO.FC.TYPE.OF.SEC.TP), @VM)
            Y.TP = 1
            LOOP
            WHILE Y.TP LE Y.CONT.TP
                R.NEW(REDO.FC.TYPE.OF.SEC.TP) = Y.COLL.CODE
                Y.TP+=1
            REPEAT
        CASE Y.COLL.CODE EQ 150
* 150 Depositos Internos
            Y.CONT.DI = DCOUNT(R.NEW(REDO.FC.TYPE.OF.SEC.DI), @VM)
            Y.DI=1
            LOOP
            WHILE Y.DI LE Y.CONT.DI
                R.NEW(REDO.FC.TYPE.OF.SEC.DI) = Y.COLL.CODE
                Y.DI+=1
            REPEAT

        CASE Y.COLL.CODE EQ 200
* 200 Depositos Externos
            Y.CONT.DE = DCOUNT(R.NEW(REDO.FC.TYPE.OF.SEC.DE), @VM)

            Y.DE=1
            LOOP
            WHILE Y.DE LE Y.CONT.DE
                R.NEW(REDO.FC.TYPE.OF.SEC.DE) = Y.COLL.CODE
                Y.DE+=1
            REPEAT

        CASE Y.COLL.CODE EQ 970
* 970 Firmas Solidarias
            Y.CONT.FS = DCOUNT(R.NEW(REDO.FC.TYPE.OF.SEC.FS), @VM)
            Y.FS=1
            LOOP
            WHILE Y.FS LE Y.CONT.FS
                R.NEW(REDO.FC.TYPE.OF.SEC.FS) = Y.COLL.CODE
                Y.FS+=1
            REPEAT
    END CASE
    IF R.NEW(REDO.FC.SECURED) THEN
        R.NEW(REDO.FC.COLLATERAL.CODE) = Y.COLL.CODE
    END

RETURN
*------------------------
GET.RATE:
*=========
    IF NOT(R.NEW(REDO.FC.FIXED.RATE)) THEN
        SEL.CMD  =  "SELECT ":FN.AA.PRD.CAT.INTEREST:" LIKE "
        SEL.CMD  := Y.PRODUCT:"-PRINCIPALINT-":Y.CURRENCY:"... BY-DSND @ID"
        LISTA.HDR = ''
        NO.REC.HEADER = ''
        RET.CODE = ''
        CALL EB.READLIST(SEL.CMD, LISTA.HDR, '', NO.REC.HEADER, RET.CODE)
        REMOVE ID.RATE FROM LISTA.HDR SETTING POS
        CALL CACHE.READ(FN.AA.PRD.CAT.INTEREST, ID.RATE, R.AA.PRD.CAT.INTEREST, YERR)
* Se pobla la tabla con los datos recuperados de la definicion del producto
        Y.RATE = R.AA.PRD.CAT.INTEREST<AA.INT.FIXED.RATE>
        R.NEW(REDO.FC.FIXED.RATE) = Y.RATE
    END
RETURN
*------------------------
GET.PAYSCH:
*============

* Si se ingresa el ID del Payment Schedule Type NO se realiza la busquedad SINO que se lee directamente.
* Se limpian todos los valores anteriores
    IF OFS$BROWSER THEN
        R.NEW(REDO.FC.PAYMENT.TYPE) = ""
        R.NEW(REDO.FC.PAYMENT.METHOD) = ""
        R.NEW(REDO.FC.PAYMENT.FREQ) = ""
        R.NEW(REDO.FC.PROPERTY) = ""
        R.NEW(REDO.FC.DUE.FREQ) = ""
        R.NEW(REDO.FC.PERCENTAGE) = ""
        R.NEW(REDO.FC.START.DATE) = ""
        R.NEW(REDO.FC.END.DATE) = ""
        R.NEW(REDO.FC.NUM.PAYMENTS) = ""
        R.NEW(REDO.FC.CALC.AMOUNT) = ""
        R.NEW(REDO.FC.ACTUAL.AMT) = ""
        R.NEW(REDO.FC.AMORTISATION.TERM) =  ""
        R.NEW(REDO.FC.RESIDUAL.AMOUNT) =  ""
    END

    IF R.NEW(REDO.FC.PAYMT.SCH.TYPE) THEN
        ID.PAYSCH = R.NEW(REDO.FC.PAYMT.SCH.TYPE)

    END ELSE
        GOSUB CAT.SEL.ELSE
    END


    CALL CACHE.READ(FN.AA.PRD.DES.PAYMENT.SCHEDULE, ID.PAYSCH, R.AA.PRD.DES.PAYMENT.SCHEDULE, YERR)
* Se pobla la tabla con los datos recuperados de la definicion del producto
    NRO.PAYTYPE = DCOUNT(R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.PAYMENT.TYPE>,@VM)


    GOSUB CHK.LOOP

RETURN

CAT.SEL.ELSE:

* Con el codigo de Product lee el PRODUCT.CATALOG
    SEL.CMD  = 'SELECT ':FN.AA.PRODUCT.CATALOG:' LIKE '
    SEL.CMD := R.NEW(REDO.FC.PRODUCT):'-... BY-DSND @ID'
    LISTA.HDR = ''
    NO.REC.HEADER = ''
    RET.CODE = ''
    CALL EB.READLIST(SEL.CMD, LISTA.HDR, '', NO.REC.HEADER, RET.CODE)
    REMOVE ID.PRODUCT FROM LISTA.HDR SETTING POS
    CALL CACHE.READ(FN.AA.PRODUCT.CATALOG, ID.PRODUCT, R.AA.PRODUCT.CATALOG, YERR)
* Segun la PROPERTY recupera la  CONDITION
    ID.PAY = "REPAYMENT.SCHEDULE"
    LOCATE ID.PAY IN R.AA.PRODUCT.CATALOG<AA.PRD.PROPERTY,1> SETTING Y.POS THEN
        ID.COND = R.AA.PRODUCT.CATALOG<AA.PRD.PRD.PROPERTY,Y.POS>

        SEL.CMD  =  "SELECT ":FN.AA.PRD.DES.PAYMENT.SCHEDULE:" LIKE "
        SEL.CMD  := ID.COND:"-":Y.CURRENCY:"... BY-DSND @ID"
        LISTA.HDR = ''
        NO.REC.HEADER = ''
        RET.CODE = ''
        CALL EB.READLIST(SEL.CMD, LISTA.HDR, '', NO.REC.HEADER, RET.CODE)
        REMOVE ID.PAYSCH FROM LISTA.HDR SETTING POS
        R.NEW(REDO.FC.PAYMT.SCH.TYPE) = ID.PAYSCH
    END

RETURN

CHK.LOOP:

    I.VAR =1
    LOOP
    WHILE I.VAR LE NRO.PAYTYPE
        IF NOT(R.NEW(REDO.FC.PAYMENT.TYPE)<1,I.VAR>) THEN
            R.NEW(REDO.FC.PAYMENT.TYPE)<1,I.VAR> = R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.PAYMENT.TYPE,I.VAR>
        END
        IF NOT(R.NEW(REDO.FC.PAYMENT.METHOD)<1,I.VAR>) THEN
            R.NEW(REDO.FC.PAYMENT.METHOD)<1,I.VAR> = R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.PAYMENT.METHOD,I.VAR>
        END
        IF NOT(R.NEW(REDO.FC.PAYMENT.FREQ)<1,I.VAR>) THEN
            R.NEW(REDO.FC.PAYMENT.FREQ)<1,I.VAR> = R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.PAYMENT.FREQ,I.VAR>
        END

        NRO.PROP = DCOUNT(R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.PROPERTY,I.VAR>,@SM)


        IF NOT(R.NEW(REDO.FC.PAYMT.DAY)) THEN
            Y.DATE = R.NEW(REDO.FC.EFFECT.DATE)
            Y.DAY = Y.DATE[7,8]
            R.NEW(REDO.FC.PAYMT.DAY) = Y.DAY
            Y.NXSD = R.NEW(REDO.FC.EFFECT.DATE)
        END ELSE
            Y.DATE = R.NEW(REDO.FC.EFFECT.DATE)
            Y.NXSD = Y.DATE[1,6]:R.NEW(REDO.FC.PAYMT.DAY)
        END
*Se modifica el el dia de pago si existe valor

        GOSUB AMMEND.PAY.DAY

        I.VAR+=1
    REPEAT
    R.NEW(REDO.FC.AMORTISATION.TERM) =  R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.AMORTISATION.TERM>
    R.NEW(REDO.FC.RESIDUAL.AMOUNT) =  R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.RESIDUAL.AMOUNT>

RETURN
*-------------------------
AMMEND.PAY.DAY:
*===============
    IF R.NEW(REDO.FC.PAYMT.DAY) THEN
        YDIA = R.NEW(REDO.FC.PAYMT.DAY)
        YFREQ = R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.PAYMENT.FREQ,I.VAR>
        YDFRQ = "o":YDIA:"D"
        STRYFREQ =  EREPLACE(YFREQ,"e0D",YDFRQ)
        IF R.NEW(REDO.FC.PAYMENT.FREQ)<1,I.VAR> EQ R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.PAYMENT.FREQ,I.VAR> THEN
            R.NEW(REDO.FC.PAYMENT.FREQ)<1,I.VAR> = STRYFREQ
        END ELSE
            YFREQ = R.NEW(REDO.FC.PAYMENT.FREQ)<1,I.VAR>
            STRYFREQ =  EREPLACE(YFREQ,"e0D",YDFRQ)
            R.NEW(REDO.FC.PAYMENT.FREQ)<1,I.VAR> = STRYFREQ
        END
    END
    J.VAR =1
    NRO.PROP = NRO.PROP
    LOOP
    WHILE J.VAR LE NRO.PROP
        IF NOT(R.NEW(REDO.FC.PROPERTY)<1,I.VAR,J.VAR>) THEN
            R.NEW(REDO.FC.PROPERTY)<1,I.VAR,J.VAR> = R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.PROPERTY,I.VAR>
        END
*R.NEW(REDO.FC.DUE.FREQ)<1,I,J> = R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.DUE.FREQ,I,J> ;*WMEZA FEB 3 12
        IF R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.PERCENTAGE,I.VAR> THEN
            R.NEW(REDO.FC.PERCENTAGE)<1,I.VAR,J.VAR> = R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.PERCENTAGE,I.VAR>
        END
        IF STRYFREQ THEN
            R.NEW(REDO.FC.DUE.FREQ)<1,I.VAR,J.VAR> = STRYFREQ   ;*WMEZA FEB 3 12
        END
* Dia de pago
        J.VAR+=1
    REPEAT
    NRO.DATES = DCOUNT(R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.START.DATE,I.VAR>,@SM)

*Y.DUM.COMI = COMI
*COMI = Y.NXSD:' ':STRYFREQ
*CALL CFQ
*Y.XNT.DD = COMI[1,8]
*COMI = Y.DUM.COMI

    GOSUB CHK.NRO.DATES

RETURN

CHK.NRO.DATES:

    J.VAR =1
    LOOP
    WHILE J.VAR LE NRO.DATES

* Y.LOC.PROPS = R.NEW(REDO.FC.PROPERTY)<1,I>

* Y.INIT.DATE = R.NEW(REDO.FC.START.DATE)<1,I>
* Y.IN.CNT = DCOUNT(Y.INIT.DATE,SM)

* LOCATE 'ACCOUNT' IN Y.LOC.PROPS<1,1,1> SETTING POS.SRT THEN
*     IF Y.IN.CNT EQ 0 THEN
*         R.NEW(REDO.FC.START.DATE)<1,I,1> = Y.XNT.DD
*     END
* END

        R.NEW(REDO.FC.START.DATE)<1,I.VAR,J.VAR> = R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.START.DATE,I.VAR,J.VAR>
        R.NEW(REDO.FC.END.DATE)<1,I.VAR,J.VAR> = R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.END.DATE,I.VAR,J.VAR>
        R.NEW(REDO.FC.NUM.PAYMENTS)<1,I.VAR,J.VAR> = R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.NUM.PAYMENTS,I.VAR,J.VAR>
        R.NEW(REDO.FC.CALC.AMOUNT)<1,I.VAR,J.VAR> = R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.CALC.AMOUNT,I.VAR,J.VAR>
        R.NEW(REDO.FC.ACTUAL.AMT)<1,I.VAR,J.VAR> = R.AA.PRD.DES.PAYMENT.SCHEDULE<AA.PS.ACTUAL.AMT,I.VAR,J.VAR>
        J.VAR+=1
    REPEAT

RETURN

*-------------------------
GET.SEC.AND.REV:
*===============
    Y.LIMIT.CATEGORY.CODE = ''

    SEL.CMD  = 'SELECT ':FN.AA.PRD.CAT.ACCOUNT:' LIKE '
    SEL.CMD := R.NEW(REDO.FC.PRODUCT):'-... BY-DSND @ID'
    SEL.LIST = ''
    NO.REC   = ''
    SEL.ERR  = ''

    CALL EB.READLIST(SEL.CMD, SEL.LIST, '', NO.REC, SEL.ERR)
    REMOVE ID.PRODUCT FROM SEL.LIST SETTING POS
    CALL CACHE.READ(FN.AA.PRD.CAT.ACCOUNT, ID.PRODUCT, R.AA.PRD.CAT.ACCOUNT, Y.ERR)
    Y.LIMIT.CATEGORY.CODE = R.AA.PRD.CAT.ACCOUNT<AA.AC.CATEGORY>
*********************************************
* CON GARANTIA
* >= 3000 & <= 3049 | >= 3100 & <= 3149 | >= 3200 & <= 3224
* CREDITO REVOLVENTE CON GARANTIA
* COMERCIAL 3025 3049
* CONSUMO 3125 3149
* CREDITO NO REVOLVENTE CON GARANTIA
* COMERCIAL 3000 3024
* CONSUMO 3100 3124
* HIPOTECARIO 3200 3224
*--------------------------------------------
* SIN GARANTIA
* >= 3050 & <= 3099 | >= 3150 & <= 3199
* CREDITO REVOLVENTE SIN GARANTIA
* COMERCIAL 3075 3099
* CONSUMO 3175 3199
* CREDITO NO REVOLVENTE SIN GARANTIA
* COMERCIAL 3050 3074
* CONSUMO 3150 3174
*******  End of process 1

* Primero se verifica
* si es garantizado o no

    IF (Y.LIMIT.CATEGORY.CODE GE 3000 AND Y.LIMIT.CATEGORY.CODE LE 3049) OR (Y.LIMIT.CATEGORY.CODE GE 3100 AND Y.LIMIT.CATEGORY.CODE LE 3149) OR (Y.LIMIT.CATEGORY.CODE GE 3200 AND Y.LIMIT.CATEGORY.CODE LE 3224) THEN
* SI es garantizado
        R.NEW(REDO.FC.SECURED) = 'SI'
        IF (Y.LIMIT.CATEGORY.CODE GE 3025 AND Y.LIMIT.CATEGORY.CODE LE 3049) OR (Y.LIMIT.CATEGORY.CODE GE 3125 AND Y.LIMIT.CATEGORY.CODE LE 3149) THEN
* SI es revolvente
            R.NEW(REDO.FC.REVOLVING) = 'SI'
        END ELSE
* NO es revolvente
            R.NEW(REDO.FC.REVOLVING) = 'NO'
        END
    END ELSE
* NO es garantizado
        R.NEW(REDO.FC.SECURED) = 'NO'
        IF (Y.LIMIT.CATEGORY.CODE GE 3075 AND Y.LIMIT.CATEGORY.CODE LE 3099) OR (Y.LIMIT.CATEGORY.CODE GE 3175 AND Y.LIMIT.CATEGORY.CODE LE 3199) THEN
* SI es revolvente
            R.NEW(REDO.FC.REVOLVING) = 'SI'
        END ELSE
* NO es revolvente
            R.NEW(REDO.FC.REVOLVING) = 'NO'
        END

    END

RETURN
*---------------------------
SET.DAO:
*===============
    ID.CUST = R.NEW(REDO.FC.CUSTOMER)
    CALL F.READ(FN.CUSTOMER,ID.CUST,R.CUSTOMER,F.CUSTOMER,YERR)
    IF NOT(YERR) THEN
        R.NEW(REDO.FC.PRIM.OFFICER) =  R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
    END ELSE
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.CUSTOMER
        CALL STORE.END.ERROR
    END

RETURN
*------------------------
INITIALISE:
*=========

    Y.PRODUCT = R.NEW(REDO.FC.PRODUCT)
    Y.CURRENCY = R.NEW(REDO.FC.LOAN.CURRENCY)
    Y.PAYMT.SCH.TYPE = R.NEW(REDO.FC.PAYMT.SCH.TYPE)

    FN.AA.PRODUCT.CATALOG = 'F.AA.PRODUCT.CATALOG'
    F.AA.PRODUCT.CATALOG = ''
    R.AA.PRODUCT.CATALOG = ''

    FN.AA.PRODUCT = 'F.AA.PRODUCT'
    F.AA.PRODUCT  = ''
    R.AA.PRODUCT = ''

    FN.AA.PRD.DES.PAYMENT.SCHEDULE = 'F.AA.PRD.DES.PAYMENT.SCHEDULE'
    R.AA.PRD.DES.PAYMENT.SCHEDULE = ''
    F.AA.PRD.DES.PAYMENT.SCHEDULE = ''

    FN.AA.PRD.CAT.INTEREST = 'F.AA.PRD.CAT.INTEREST'
    F.AA.PRD.CAT.INTEREST = ''
    R.AA.PRD.CAT.INTEREST = ''

    FN.REDO.FC.PROD.COLL.POLICY = 'F.REDO.FC.PROD.COLL.POLICY'
    F.REDO.FC.PROD.COLL.POLICY = ''
    R.REDO.FC.PROD.COLL.POLICY = ''

    FN.AA.PRD.CAT.ACCOUNT = 'F.AA.PRD.CAT.ACCOUNT'
    F.AA.PRD.CAT.ACCOUNT = ''
    R.AA.PRD.CAT.ACCOUNT = ''

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    R.CUSTOMER = ''

    Y.DEB.DIR = 'Direct Debit'

    YERR = ''
    PROCESS.GOAHEAD = 1


RETURN
*********End of process 6
*********End of process 5


*------------------------
SET.MANDATORYS:
*=========
    Y.APP.FROM = 'REDO.CREATE.ARRANGEMENT'
    Y.PAY.MET = R.NEW(REDO.FC.PAYMT.MHD)
    Y.ACC.DEBIT = R.NEW(REDO.FC.ACC.TO.DEBIT)


    BEGIN CASE
*edited values according LOCAL.FIELD 304
        CASE R.NEW(REDO.FC.PAYMT.MHD) EQ "Direct Debit"
            R.NEW(REDO.FC.FORM) = ""
            IF R.NEW(REDO.FC.ACC.TO.DEBIT) EQ "" THEN
                AF = REDO.FC.ACC.TO.DEBIT
                ETEXT  = 'EB-FC-MANDOTORY.FIELD'
                CALL STORE.END.ERROR
            END
*edited values according LOCAL.FIELD 304
        CASE R.NEW(REDO.FC.PAYMT.MHD) EQ "External Payroll"
            R.NEW(REDO.FC.ACC.TO.DEBIT) = ""
            IF R.NEW(REDO.FC.FORM) EQ "" THEN
                AF = REDO.FC.FORM
                ETEXT  = 'EB-FC-MANDOTORY.FIELD'
                CALL STORE.END.ERROR

            END
        CASE OTHERWISE
            R.NEW(REDO.FC.ACC.TO.DEBIT) = ""
            R.NEW(REDO.FC.FORM) = ""
    END CASE

*Cuando no existe valores en las instrucciones de desembolso.

    IF R.NEW(REDO.FC.DIS.TYPE) AND  NOT(R.NEW(REDO.FC.VAL.DET.INS)) THEN
        AF = REDO.FC.VAL.DET.INS
        ETEXT  = 'EB-FC-MANDOTORY.FIELD'
        CALL STORE.END.ERROR
    END


    IF NOT (R.NEW (REDO.FC.TYPE.RATE.REV)) AND OFS$BROWSER THEN
        AF = REDO.FC.TYPE.RATE.REV
        ETEXT  = 'EB-FC-MANDOTORY.FIELD'
        CALL STORE.END.ERROR

    END

    IF R.NEW (REDO.FC.TYPE.RATE.REV) NE "PERIODICO" THEN
        R.NEW(REDO.FC.RATE.FQY) = ""
        R.NEW(REDO.FC.FST.RE.DATE)= ""

    END
    IF R.NEW (REDO.FC.DEST.LOAN) LT 50 AND R.NEW (REDO.FC.CIUU.CATEG) EQ "" AND R.NEW (REDO.FC.DEST.LOAN) NE "" THEN
        AF = REDO.FC.CIUU.CATEG
        ETEXT  = 'EB-FC-MANDOTORY.FIELD'
        CALL STORE.END.ERROR
    END

    IF R.NEW (REDO.FC.DEST.LOAN) EQ "" THEN
        R.NEW (REDO.FC.CIUU.CATEG) = ""
    END

RETURN
*********End of process 2
*********End of process 3
*********End of process 4
*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.AA.PRODUCT.CATALOG, F.AA.PRODUCT.CATALOG)
    CALL OPF(FN.AA.PRODUCT, F.AA.PRODUCT)
    CALL OPF(FN.AA.PRD.DES.PAYMENT.SCHEDULE, F.AA.PRD.DES.PAYMENT.SCHEDULE)
    CALL OPF(FN.AA.PRD.CAT.INTEREST, F.AA.PRD.CAT.INTEREST)
    CALL OPF(FN.REDO.FC.PROD.COLL.POLICY, F.REDO.FC.PROD.COLL.POLICY)
    CALL OPF(FN.AA.PRD.CAT.ACCOUNT, F.AA.PRD.CAT.ACCOUNT)
RETURN
*------------
END
