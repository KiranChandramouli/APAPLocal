* @ValidationCode : MjotNzQ2MjE0MjAyOkNwMTI1MjoxNjkzMjg1NDUyMTE0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 29 Aug 2023 10:34:12
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
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>136</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.RT.GET.DT.INFO
*------------------------------------------------------------
*
* Modification History :
*-----------------------
*  DATE             WHO             REFERENCE                    DESCRIPTION
*09/08/2023       VIGNESHWARI  MANUAL R22 CODE CONVERSION  T24.BP,BP is removed in insertfile
*----------------------------------------------------------------------
    $INSERT I_EQUATE ;*MANUAL R22 CODE CONVERSION-START-T24.BP is removed in insertfile
    $INSERT I_COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT ;*MANUAL R22 CODE CONVERSION-END
    $INSERT I_F.TELLER.TRANSACTION ;*MANUAL R22 CODE CONVERSION-START-BP is removed in insertfile
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.LAPAP.LOCALIDAD.SDT.EQU ;*MANUAL R22 CODE CONVERSION-END
    $USING APAP.TAM

    GOSUB LOCREF
    GOSUB OPEN.FILES
    GOSUB INI
*---------------------------------------------------------------------------------------------------------
*Check wheter data has been fetched from ms-fim-dealticket-nc or not.
    MSG = ''
    MSG<-1> = 'Valor C$SPARE(0) = ':C$SPARE(0)
    MSG<-1> = 'Valor COMI = ' : COMI
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
    IF C$SPARE(0) NE COMI THEN
        MSG = ''
        MSG<-1> = 'Hago llamada':C$SPARE(0)
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
        GOSUB DOCALL
    END ELSE

        MSG = ''
        MSG<-1> = 'Else C$SPARE(0) NE COMI'
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
        GOSUB CHECK.PRELIM.CONDITIONS

        MSG = ''
        MSG<-1> = 'Value of PROCESS.GOAHEAD = ' : PROCESS.GOAHEAD
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
        IF PROCESS.GOAHEAD THEN
            GOSUB PROCESS.2
        END
    END
*----------------------------------------------------------------------------------------------------------
LOCREF:
    APPL.NAME.ARR<1> = 'TELLER' ;
    FLD.NAME.ARR<1,1> = 'L.BOL.DIVISA' ;
    FLD.NAME.ARR<1,2> = 'L.NOM.DIVISA' ;
    FLD.NAME.ARR<1,3> = 'L.TT.BASE.AMT' ;
    FLD.NAME.ARR<1,4> = 'L.DEBIT.AMOUNT' ;
    FLD.NAME.ARR<1,5> = 'L.CREDIT.AMOUNT' ;
    FLD.NAME.ARR<1,6> = 'L.DT.ID' ;
    FLD.NAME.ARR<1,7> = 'L.DT.INFO' ;
    FLD.NAME.ARR<1,8> = 'L.DT.PAYMENT.MT' ;
    FLD.NAME.ARR<1,9> = 'DT.PMNT.TYPE' ;
    FLD.NAME.ARR<1,10> = 'L.TT.RCEP.MTHD';
    FLD.NAME.ARR<1,11> = 'L.DT.REC' ;

    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)
    L.BOL.DIVISA.POS = FLD.POS.ARR<1,1>
    L.NOM.DIVISA.POS = FLD.POS.ARR<1,2>
    L.TT.BASE.AMT.POS = FLD.POS.ARR<1,3>
    L.DEBIT.AMOUNT.POS = FLD.POS.ARR<1,4>
    L.CREDIT.AMOUNT.POS = FLD.POS.ARR<1,5>
    L.DT.ID.POS = FLD.POS.ARR<1,6>
    L.DT.INFO.POS = FLD.POS.ARR<1,7>
    L.DT.PAYMENT.MTHD.POS = FLD.POS.ARR<1,8>
    L.DT.PAYMENT.TYPE.POS = FLD.POS.ARR<1,9>
    L.TT.RCEP.MTHD.POS = FLD.POS.ARR<1,10>
    L.DT.REC.POS = FLD.POS.ARR<1,11>

    FN.LOCALIDAD.SDT = 'F.ST.LAPAP.LOCALIDAD.SDT.EQU';
    F.LOCALIDAD.SDT = ''; LOCALIDAD.ERR = '';
    CALL OPF(FN.LOCALIDAD.SDT,F.LOCALIDAD.SDT)

*    CALL F.READ(FN.LOCALIDAD.SDT,"SYSTEM",R.LOCALIDAD,F.LOCALIDAD.SDT,LOCALIDAD.ERR)
IDVAR.1 = "SYSTEM" ;* R22 UTILITY AUTO CONVERSION
    CALL F.READ(FN.LOCALIDAD.SDT,IDVAR.1,R.LOCALIDAD,F.LOCALIDAD.SDT,LOCALIDAD.ERR);* R22 UTILITY AUTO CONVERSION

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

    Y.ID.LOCALIDAD = ID.COMPANY
    Y.RCEP.MTHD = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.RCEP.MTHD.POS>
    Y.PAYMENT.METHOD = R.NEW(TT.TE.LOCAL.REF)<1,L.DT.PAYMENT.MTHD.POS>
    Y.PAYMENT.TYPE = R.NEW(TT.TE.LOCAL.REF)<1,L.DT.PAYMENT.TYPE.POS>

    R.LOCALIDAD.SDT = ''; LOCALIDAD.SDT.ERR = ''
    Y.LOCALIDAD.SDT = ''
    FINDSTR Y.ID.LOCALIDAD IN R.LOCALIDAD SETTING V.FLD,V.VAL THEN
        Y.LOCALIDAD.SDT = R.LOCALIDAD<ST.LAP52.LOCALIDAD.SDT,V.VAL>
        Y.ID.LOCALIDAD = Y.LOCALIDAD.SDT
        MSG = ''
        MSG<-1> = 'Y.LOCALIDAD.SDT = ': Y.LOCALIDAD.SDT
        MSG<-1> = 'Y.ID.LOCALIDAD = ' : Y.ID.LOCALIDAD
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
    END

    param = Y.ID.LOCALIDAD:"::1::1::50::":COMI:"::":Y.PAYMENT.METHOD:"::":Y.PAYMENT.TYPE
*param = "361::1::1::50::DT00063::EFECTIVO::SELL "   ;*R.NEW(TT.TE.LOCAL.REF)<1,L.BOL.DIVISA.POS>
    Y.EB.API.ID = 'LAPAP.GET.DT.INFO'
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

    Y.MICRO.VALIDATION = FIELD(Y.RESPONSE,'^^',1)
    Y.MICRO.RESP.CODE = FIELD(Y.MICRO.VALIDATION,'::',1)
    Y.ASM.VALIDATION = FIELD(Y.RESPONSE,'^^',2)
    Y.DT.RECEPTION.1 = FIELD(Y.RESPONSE,'^^',3)
    Y.DT.RECEPTION.2 = FIELD(Y.RESPONSE,'^^',4)
    Y.DT.RECEPTION.3 = FIELD(Y.RESPONSE,'^^',5)
    Y.DT.RECEPTION.4 = FIELD(Y.RESPONSE,'^^',6)
    Y.DESC.ERROR = ""
    Y.FINAL.STATUS = ""
    Y.ID.ASM = ""

    MSG = ''
    MSG<-1> = 'Full MSG = ' :Y.RESPONSE
    MSG<-1> = 'Y.DT.RECEPTION.1 = ' : Y.DT.RECEPTION.1
    MSG<-1> = 'Y.DT.RECEPTION.2 = ' : Y.DT.RECEPTION.2
    MSG<-1> = 'Y.DT.RECEPTION.3 = ' : Y.DT.RECEPTION.3
    MSG<-1> = 'Y.DT.RECEPTION.4 = ' : Y.DT.RECEPTION.4
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)

    IF Y.CALLJ.ERROR THEN
        BEGIN CASE
*            CASE Y.CALLJ.ERROR = 1
            CASE Y.CALLJ.ERROR EQ 1;* R22 UTILITY AUTO CONVERSION
                MESSAGE = "Fatal error creating thread."
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
*            CASE Y.CALLJ.ERROR = 2
            CASE Y.CALLJ.ERROR EQ 2;* R22 UTILITY AUTO CONVERSION
                MESSAGE = "Cannot create JVM."
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
*            CASE Y.CALLJ.ERROR = 3
            CASE Y.CALLJ.ERROR EQ 3;* R22 UTILITY AUTO CONVERSION
                MESSAGE = "Cannot find JAVA class, please check EB.API Record " : Y.EB.API.ID
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
*            CASE Y.CALLJ.ERROR = 4
            CASE Y.CALLJ.ERROR EQ 4;* R22 UTILITY AUTO CONVERSION
                MESSAGE = "Unicode conversion error"
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
*            CASE Y.CALLJ.ERROR = 5
            CASE Y.CALLJ.ERROR EQ 5;* R22 UTILITY AUTO CONVERSION
                MESSAGE = "Cannot find method, please check EB.API Record  " : Y.EB.API.ID
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
*            CASE Y.CALLJ.ERROR = 6
            CASE Y.CALLJ.ERROR EQ 6;* R22 UTILITY AUTO CONVERSION
                MESSAGE = "Cannot find object constructor"
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
*            CASE Y.CALLJ.ERROR = 7
            CASE Y.CALLJ.ERROR EQ 7;* R22 UTILITY AUTO CONVERSION
                MESSAGE = "Cannot instantiate object, check all dependencies registrered in CLASSPATH env."
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
        END CASE
    END


    IF FIELD(Y.ASM.VALIDATION,'::',1) EQ '0' THEN

        GOSUB FORMARRAY
    END ELSE
        Y.EXTRACTO =FIELD(Y.ASM.VALIDATION,'::',2)
        MESSAGE = Y.EXTRACTO
        E = MESSAGE
        ETEXT = E
        CALL ERR

        GOSUB CHECK.PRELIM.CONDITIONS

        IF PROCESS.GOAHEAD THEN
            GOSUB PROCESS.2
        END

        RETURN
    END


RETURN
*----------------------------------------------------------------------------------------------------------
FORMARRAY:
** Y.RESPONSE = 1: codigo del micro, 2: respuesta, 3: tipo, 4: detalle, 5: detalle error, ^^  1: codigo ASM, 2: respuesta, 3: Dealticket, 4: tipoForma, 5: Item , 6: Tasa cambio, 7: Moneda , 8: Monto, 9:descripcionForma
** ^^ 1: Item ,2: tipoForma,  3: descripcionForma, 4: Tasa cambio, 5: Moneda , 6: Monto
** Y.DT.RECEPTOPN.1 = 1: Item ,2: tipoForma,  3: descripcionForma, 4: Tasa cambio, 5: Moneda , 6: Monto
** Y.ASM.VALIDATION = 1: codigo ASM, 2: respuesta, 3: Dealticket, 4: tipoForma, 5: Item , 6: Tasa cambio, 7: Moneda , 8: Monto, 9:descripcionForma


    Y.INFO = FIELD(Y.ASM.VALIDATION,'::',3):"*":FIELD(Y.ASM.VALIDATION,'::',5):"*":FIELD(Y.ASM.VALIDATION,'::',6):"*":FIELD(Y.ASM.VALIDATION,'::',7):"*":FIELD(Y.ASM.VALIDATION,'::',8):"*":FIELD(Y.ASM.VALIDATION,'::',9)

    IF Y.DT.RECEPTION.1 THEN
        R.NEW(TT.TE.LOCAL.REF)<1,L.DT.REC.POS,1> = FIELD(Y.DT.RECEPTION.1,'::',1):"*":FIELD(Y.DT.RECEPTION.1,'::',2):"*":FIELD(Y.DT.RECEPTION.1,'::',3):"*":FIELD(Y.DT.RECEPTION.1,'::',4):"*":FIELD(Y.DT.RECEPTION.1,'::',5):"*":FIELD(Y.DT.RECEPTION.1,'::',6)
        Y.DT.REC.AMT = FIELD(Y.DT.RECEPTION.1,'::',6)
    END

    IF Y.DT.RECEPTION.2 THEN
        R.NEW(TT.TE.LOCAL.REF)<1,L.DT.REC.POS,2> = FIELD(Y.DT.RECEPTION.2,'::',1):"*":FIELD(Y.DT.RECEPTION.2,'::',2):"*":FIELD(Y.DT.RECEPTION.2,'::',3):"*":FIELD(Y.DT.RECEPTION.2,'::',4):"*":FIELD(Y.DT.RECEPTION.2,'::',5):"*":FIELD(Y.DT.RECEPTION.2,'::',6)
        Y.DT.REC.AMT = Y.DT.REC.AMT + FIELD(Y.DT.RECEPTION.2,'::',6)
    END

    IF Y.DT.RECEPTION.3 THEN
        R.NEW(TT.TE.LOCAL.REF)<1,L.DT.REC.POS,3> = FIELD(Y.DT.RECEPTION.3,'::',1):"*":FIELD(Y.DT.RECEPTION.3,'::',2):"*":FIELD(Y.DT.RECEPTION.3,'::',3):"*":FIELD(Y.DT.RECEPTION.3,'::',4):"*":FIELD(Y.DT.RECEPTION.3,'::',5):"*":FIELD(Y.DT.RECEPTION.3,'::',6)
        Y.DT.REC.AMT = Y.DT.REC.AMT + FIELD(Y.DT.RECEPTION.3,'::',6)
    END


    IF Y.DT.RECEPTION.4 THEN
        R.NEW(TT.TE.LOCAL.REF)<1,L.DT.REC.POS,4> = FIELD(Y.DT.RECEPTION.4,'::',1):"*":FIELD(Y.DT.RECEPTION.4,'::',2):"*":FIELD(Y.DT.RECEPTION.4,'::',3):"*":FIELD(Y.DT.RECEPTION.4,'::',4):"*":FIELD(Y.DT.RECEPTION.4,'::',5):"*":FIELD(Y.DT.RECEPTION.4,'::',6)
        Y.DT.REC.AMT = Y.DT.REC.AMT + FIELD(Y.DT.RECEPTION.4,'::',6)
    END

    R.NEW(TT.TE.LOCAL.REF)<1,L.DT.ID.POS> = FIELD(Y.ASM.VALIDATION,'::',3)
    R.NEW(TT.TE.LOCAL.REF)<1,L.DT.INFO.POS> = Y.INFO

    Y.PAY.AMOUNT = ''
    Y.PAY.CURRENCY = ''
    Y.PAY.RATE = ''

    Y.REC.AMT = ''

    IF Y.PAYMENT.TYPE EQ 'SELL' THEN
        Y.PAY.AMOUNT = FIELD(Y.ASM.VALIDATION,'::',8)
        Y.PAY.CURRENCY = FIELD(Y.ASM.VALIDATION,'::',7)
        Y.PAY.RATE = FIELD(Y.ASM.VALIDATION,'::',6)
        Y.REC.AMT = Y.DT.REC.AMT
    END ELSE
        Y.PAY.AMOUNT = Y.DT.REC.AMT
        Y.PAY.CURRENCY = FIELD(Y.DT.RECEPTION.1,'::',5)
        Y.PAY.RATE = FIELD(Y.DT.RECEPTION.1,'::',4)
        Y.REC.AMT = FIELD(Y.ASM.VALIDATION,'::',8)
    END

    R.NEW(TT.TE.LOCAL.REF)<1,L.TT.BASE.AMT.POS> = Y.PAY.AMOUNT
    R.NEW(TT.TE.CURRENCY.1) = Y.PAY.CURRENCY
    R.NEW(TT.TE.DEAL.RATE) = Y.PAY.RATE

    MSG = ''
    MSG<-1> = 'Y.DT.REC.AMT = ' : Y.DT.REC.AMT
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)

**Implementacion de rutina: SUBROUTINE REDO.VVR.CALC.AMTS.FCYLCY
    Y.BASE.AMT = ''
    R.NEW(TT.TE.AMOUNT.LOCAL.2)<1,1> = ''
*
    R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1> = ''

    Y.BASE.AMT = Y.PAY.AMOUNT
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS.2
    END
*---------------------------------------------------------------------------------------------------------
    C$SPARE(0) = COMI
    C$SPARE(1) = 'true'
*---------------------------------------------------------------------------------------------------------
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

    Y.LCCY.AMT = Y.REC.AMT
    CALL EB.ROUND.AMOUNT(LCCY,Y.LCCY.AMT,"2","")  ;* Fix for PACS00319443
*
    R.NEW(TT.TE.AMOUNT.LOCAL.2)<1,1> = Y.LCCY.AMT
*
    R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1> = Y.LCCY.AMT
*

    MSG = ''
    MSG<-1> = 'Y.LCCY.AMT = ' : Y.LCCY.AMT
    MSG<-1> = 'Rounded = ' : Y.LCCY.AMT
    MSG<-1> = 'R.NEW(TT.TE.AMOUNT.FCY.1)<1,1> = ' : Y.BASE.AMT
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
*PACS00250002 - E

*    CALL REDO.HANDLE.COMM.TAX.FIELDS
    APAP.TAM.redoHandleCommTaxFields();*MANUAL R22 CODE CONVERSION
*
*
RETURN
*

END
