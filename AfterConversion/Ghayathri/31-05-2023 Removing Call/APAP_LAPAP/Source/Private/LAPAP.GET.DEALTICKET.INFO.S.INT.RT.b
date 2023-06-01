* @ValidationCode : MjoxMjY0NDEyOTc5OkNwMTI1MjoxNjg1NTM0MDI0MTAyOmhhaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 17:23:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
$PACKAGE APAP.LAPAP

SUBROUTINE LAPAP.GET.DEALTICKET.INFO.S.INT.RT
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE          WHO                    REFERENCE              DESCRIPTION

* 21-APR-2023   Conversion tool       R22 Auto conversion     = to EQ
* 21-APR-2023    Narmadha V           R22 Manual Conversion   CALL routine format modified

*-----------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.FT.COMMISSION.TYPE
    $USING APAP.TAM

    GOSUB LOCREF
    GOSUB OPEN.FILES
    GOSUB INI
*---------------------------------------------------------------------------------------------------------
*Check wheter data has been fetched from ms-fim-dealticket-nc or not.
    IF C$SPARE(0) NE COMI THEN
        GOSUB DOCALL
    END ELSE
        GOSUB CHECK.PRELIM.CONDITIONS

        IF PROCESS.GOAHEAD THEN
            GOSUB PROCESS.2
        END
    END
*----------------------------------------------------------------------------------------------------------

*GOSUB DOCALL
*----------------------------------------------------------------------------------------------------------
LOCREF:
    APPL.NAME.ARR<1> = 'TELLER' ;
    FLD.NAME.ARR<1,1> = 'L.BOL.DIVISA' ;
    FLD.NAME.ARR<1,2> = 'L.NOM.DIVISA' ;
    FLD.NAME.ARR<1,3> = 'L.TT.BASE.AMT' ;
    FLD.NAME.ARR<1,4> = 'L.DEBIT.AMOUNT' ;
    FLD.NAME.ARR<1,5> = 'L.CREDIT.AMOUNT' ;

    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)
    L.BOL.DIVISA.POS = FLD.POS.ARR<1,1>
    L.NOM.DIVISA.POS = FLD.POS.ARR<1,2>
    L.TT.BASE.AMT.POS = FLD.POS.ARR<1,3>
    L.DEBIT.AMOUNT.POS = FLD.POS.ARR<1,4>
    L.CREDIT.AMOUNT.POS = FLD.POS.ARR<1,5>
RETURN

*----------------------------------------------------------------------------------------------------------
OPEN.FILES:
*~~~~~~~~~~
*
    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION = ''

    FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE = ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT);
*
RETURN
*----------------------------------------------------------------------------------------------------------
INI:
    param = COMI    ;*R.NEW(TT.TE.LOCAL.REF)<1,L.BOL.DIVISA.POS>
    Y.EB.API.ID = 'LAPAP.FIM.DT.INFO.GET'

    PROCESS.GOAHEAD = "1"
    LOOP.CNT        = 1
    MAX.LOOPS       = 1

RETURN
*----------------------------------------------------------------------------------------------------------
DOCALL:
    CALL EB.CALL.JAVA.API(Y.EB.API.ID,param,Y.RESPONSE,Y.CALLJ.ERROR)
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------------------------------------------
PROCESS:
    IF Y.CALLJ.ERROR THEN
        BEGIN CASE
            CASE Y.CALLJ.ERROR EQ 1
                MESSAGE = "Fatal error creating thread."
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
            CASE Y.CALLJ.ERROR EQ 2
                MESSAGE = "Cannot create JVM."
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
            CASE Y.CALLJ.ERROR EQ 3
                MESSAGE = "Cannot find JAVA class, please check EB.API Record " : Y.EB.API.ID
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
            CASE Y.CALLJ.ERROR EQ 4
                MESSAGE = "Unicode conversion error"
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
            CASE Y.CALLJ.ERROR EQ 5
                MESSAGE = "Cannot find method, please check EB.API Record  " : Y.EB.API.ID
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
            CASE Y.CALLJ.ERROR EQ 6
                MESSAGE = "Cannot find object constructor"
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
            CASE Y.CALLJ.ERROR EQ 7
                MESSAGE = "Cannot instantiate object, check all dependencies registrered in CLASSPATH env."
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
        END CASE
    END

    IF FIELD(Y.RESPONSE,'*',1) EQ '0' THEN
*DEBUG
        GOSUB FORMARRAY
    END ELSE
        Y.EXTRACTO =FIELD(Y.RESPONSE,'*',2)
        MESSAGE = Y.EXTRACTO
        E = MESSAGE
        ETEXT = E
        CALL ERR
        RETURN
    END


RETURN
*----------------------------------------------------------------------------------------------------------
FORMARRAY:
**1: codigo, 2: Msg, 3: IdInstrumento, 4: Tipo Txn, 5: Identificacion, 6: Nombre contraparte, 7: Monto Origen, 8: Monto Destino, 9: Tasa cambio
**10: Moneda Origen, 11: Moneda Destino, 12: Moneda Origen ISO, 13: Moneda Destino ISO.
    Y.VERSION = PGM.VERSION
    Y.TIPO.TXN = FIELD(Y.RESPONSE,'*',4)
    Y.TIPO.TRIM = LEFT(Y.TIPO.TXN,6)
    Y.TIPO.TRIM = DOWNCASE(Y.TIPO.TRIM)
    MSG<-1> = Y.VERSION
    MSG<-1> = Y.RESPONSE
    MSG<-1> = FIELD(Y.RESPONSE,'*',12)
    MSG<-1> = FIELD(Y.RESPONSE,'*',13)
    MSG<-1> = FIELD(Y.RESPONSE,'*',7)
    MSG<-1> = FIELD(Y.RESPONSE,'*',8)
    MSG<-1> = 'VALOR C$SPARE(1) ' : C$SPARE(1)
    MSG<-1> = 'TIPO TXN: ' : Y.TIPO.TRIM
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
    IF FIELD(Y.RESPONSE,'*',13) NE 'DOP' AND Y.VERSION NE ',L.APAP.ENV.TRF.I.EU.FIM' THEN
        MESSAGE = "DEAL TICKET:": param : ", Moneda destino no es DOP en venta."
        E = MESSAGE
        ETEXT = E
        CALL ERR
        RETURN
    END
    IF FIELD(Y.RESPONSE,'*',1) EQ '-2' THEN
        MESSAGE = "DEAL TICKET:": param : FIELD(Y.RESPONSE,'*',2)
        E = MESSAGE
        ETEXT = E
        CALL ERR
        RETURN
    END
    IF FIELD(Y.RESPONSE,'*',12) NE 'EUR' AND Y.VERSION EQ ',L.APAP.ENV.TRF.I.EU.FIM' THEN
        MESSAGE = "DEAL TICKET:": param : ", especifica moneda origen/destino invalida para envio EUR."
        E = MESSAGE
        ETEXT = E
        CALL ERR
        RETURN
    END

*SQA-4999 --> Moneda Extranjera viene en la posicion 13 de todos modos...

    IF Y.VERSION NE ',L.APAP.ENV.TRF.I.EU.FIM' THEN
        MSG<-1> = ''
        MSG<-1> = 'Ingreso en IF NE'
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)

        R.NEW(TT.TE.CURRENCY.1) = FIELD(Y.RESPONSE,'*',12)
        R.NEW(TT.TE.DEAL.RATE) = FIELD(Y.RESPONSE,'*',9)
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.BASE.AMT.POS> = FIELD(Y.RESPONSE,'*',7)
        R.NEW(TT.TE.LOCAL.REF)<1,L.NOM.DIVISA.POS> = FIELD(Y.RESPONSE,'*',6)

*R.NEW(TT.TE.NET.AMOUNT) = FIELD(Y.RESPONSE,'*',8)

*Y.TEST = FIELD(Y.RESPONSE,'*',8)
*DEBUG
**Implementacion de rutina: SUBROUTINE REDO.VVR.CALC.AMTS.FCYLCY
        Y.BASE.AMT = ''
        R.NEW(TT.TE.AMOUNT.LOCAL.2)<1,1> = ''
*
        R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1> = ''
* BASE AMT es valor 7 en MS.
        Y.BASE.AMT = FIELD(Y.RESPONSE,'*',7)
    END

    IF Y.VERSION EQ ',L.APAP.ENV.TRF.I.EU.FIM' THEN
        MSG<-1> = ''
        MSG<-1> = 'Ingreso en IF EQ'
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)

        R.NEW(TT.TE.CURRENCY.1) = FIELD(Y.RESPONSE,'*',12)
        R.NEW(TT.TE.DEAL.RATE) = FIELD(Y.RESPONSE,'*',9)
*SQA-5284, Euro esta viniendo en la posicion 7 es decir "montoOrigen"
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.BASE.AMT.POS> = FIELD(Y.RESPONSE,'*',7)
        R.NEW(TT.TE.LOCAL.REF)<1,L.NOM.DIVISA.POS> = FIELD(Y.RESPONSE,'*',6)

**Implementacion de rutina: SUBROUTINE REDO.VVR.CALC.AMTS.FCYLCY
        Y.BASE.AMT = ''
        R.NEW(TT.TE.AMOUNT.LOCAL.2)<1,1> = ''

        R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1> = ''
*SQA-5284, Euro esta viniendo en la posicion 7 es decir "montoOrigen"
        Y.BASE.AMT = FIELD(Y.RESPONSE,'*',7)
    END

    C$SPARE(0) = COMI
    C$SPARE(1) = 'true'
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS.2
    END
RETURN
*----------------------------------------------------------------------------------------------------------
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
*
                IF MESSAGE EQ "VAL" THEN
                    PROCESS.GOAHEAD = ""
                END
*
        END CASE
        LOOP.CNT +=1
*
    REPEAT
*
RETURN
*----------------------------------------------------------------------------------------------------------
PROCESS.2:
*----------------------------------------------------------------------
*
    R.NEW(TT.TE.CHARGE.CUSTOMER)  = ""
    R.NEW(TT.TE.CHARGE.ACCOUNT)   = ""
    R.NEW(TT.TE.CHARGE.CATEGORY)  = ""
    R.NEW(TT.TE.CHRG.DR.TXN.CDE)  = ""
    R.NEW(TT.TE.CHRG.CR.TXN.CDE)  = ""
    R.NEW(TT.TE.CHRG.AMT.LOCAL)   = ""
    R.NEW(TT.TE.CHRG.AMT.FCCY)    = ""
    R.NEW(TT.TE.CHARGE.CODE)      = ""
    R.NEW(TT.TE.NET.AMOUNT)       = ""
    R.NEW(TT.TE.DEALER.DESK)      = "00"
*
    R.NEW(TT.TE.AMOUNT.FCY.1)<1,1>   = Y.BASE.AMT
*
    CALL TT.PERFORM.DEF.PROCESSING
    CALL TT.GENERAL.LIBRARY(CALL.CALCULATE.NET.AMOUNT)
*
* PACS00250002 - S
*SQA-4999
    Y.LCCY.AMT = R.NEW(TT.TE.AMOUNT.FCY.1)<1,1> * R.NEW(TT.TE.DEAL.RATE)
*Y.LCCY.AMT = R.NEW(TT.TE.AMOUNT.FCY.1)<1,1>
    CALL EB.ROUND.AMOUNT(LCCY,Y.LCCY.AMT,"2","")  ;* Fix for PACS00319443
*
    R.NEW(TT.TE.AMOUNT.LOCAL.2)<1,1> = Y.LCCY.AMT
*
    R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1> = Y.LCCY.AMT
*
*PACS00250002 - E

*MSG<-1> = Y.LCCY.AMT
*MSG<-1> = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.BASE.AMT.POS>
*MSG<-1> = R.NEW(TT.TE.AMOUNT.FCY.1)<1,1>
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)

    APAP.TAM.redoHandleCommTaxFields() ;*Manual R22 conversion
*
*
RETURN
*

END
