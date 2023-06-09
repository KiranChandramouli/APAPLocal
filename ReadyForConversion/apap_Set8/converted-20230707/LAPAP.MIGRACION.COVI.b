SUBROUTINE LAPAP.MIGRACION.COVI(Y.ARRANGEMENT.ID)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_LAPAP.MIGRACION.COVI.COMO

    GOSUB MAIN.PROCESS

RETURN

MAIN.PROCESS:
************

    AA.ARR.ID = Y.ARRANGEMENT.ID
    AA.ARR.ID = CHANGE(AA.ARR.ID,',',@FM)
    AA.ARR.ID = AA.ARR.ID<1>
    CALL REDO.B.CON.LNS.BY.DEBTOR.AA.RECS(AA.ARR.ID,OUT.RECORD)
    R.AA.PAYMENT.SCHEDULE.APP = FIELD(OUT.RECORD,"*",3)
*Y.YYYY.CUOTA.NOPAGO.SOLO.INTERES.ABRIL = "202006"
    GOSUB GET.ARRAGEMENT
    GOSUB READ.BILL.DETAILS

    IF Y.FECHA.CREACION.PRESTMO GE Y.FECHA.FACTURA  AND Y.FECHA.CREACION.PRESTMO LE Y.FECHA.FIN.FACTURA AND Y.GENERO.PAGADA EQ 'YES' THEN
        GOSUB GET.AA.PAYMENT.SHEDULE
        RETURN
    END

    IF Y.FECHA.CREACION.PRESTMO GE Y.FECHA.FACTURA  AND Y.FECHA.CREACION.PRESTMO LE Y.FECHA.FIN.FACTURA  AND Y.GENERO.PAGADA EQ 'NO' THEN
        GOSUB READ.FACTURA.GRUPO2
        RETURN
    END

    IF Y.GENERO.PAGADA EQ 'YES' THEN
        GOSUB GET.AA.PAYMENT.SHEDULE
    END ELSE
        GOSUB READ.FACTURA.GRUPO2
    END

RETURN

GET.ARRAGEMENT:
*******************
    R.ARRANGEMENT = ''; ERR.ARRAGEMENT = ''; CLIENTE.ID = ''
    CALL AA.GET.ARRANGEMENT(AA.ARR.ID,R.ARRANGEMENT,ERR.ARRAGEMENT)
    Y.COMPANY =  R.ARRANGEMENT<AA.ARR.CO.CODE>
    Y.ARR.STATUS =  R.ARRANGEMENT<AA.ARR.ARR.STATUS>
    Y.PRODUCT.GROUP = R.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    Y.FECHA.CREACION.PRESTMO = R.ARRANGEMENT<AA.ARR.START.DATE>
RETURN

READ.BILL.DETAILS:
******************

    Y.GENERO.PAGADA = "NO" ;
    SEL.CMD = ''; SEL.LIST = ''; NO.OF.REC = ''; SEL.ERR = '' ; Y.OS.TOTAL.AMOUNT = ''
    SEL.CMD = " SELECT " : FN.AA.BILL: " WITH ARRANGEMENT.ID EQ " :"'":AA.ARR.ID:"'":" AND PAYMENT.DATE GE ":"'":Y.FECHA.FACTURA:"'":" AND PAYMENT.DATE LE ":"'":Y.FECHA.FIN.FACTURA:"'"
    SEL.CMD = SEL.CMD :" AND PROPERTY EQ 'ACCOUNT'"
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR)
    SEL.LIST.CONSTANTE = SORT(SEL.LIST)
    SEL.LIST = SORT(SEL.LIST)

    IF NO.OF.REC EQ 0 THEN
        GOSUB GET.HISTORY.BILL.HIST.CONSTANTE
    END ELSE
        LOOP
            REMOVE Y.BILL.ID FROM SEL.LIST SETTING BILL.POS
        WHILE Y.BILL.ID DO
            R.AA.BILL = '';
            BL.ERR = ''
            Y.BL.ID = '';
            Y.BL.ID = Y.BILL.ID
            CALL F.READ(FN.AA.BILL,Y.BL.ID,R.AA.BILL,F.AA.BILL,BL.ERR)
***Si la factura es generada con balance de cancelacion no considerar
            Y.AA.BD.PROPERTY = R.AA.BILL<AA.BD.PROPERTY>
            Y.BILL.TYPE = R.AA.BILL<AA.BD.BILL.TYPE>
            LOCATE 'PAYOFF' IN Y.BILL.TYPE<1,1> SETTING BIII.POSN THEN
                CONTINUE
            END

            Y.OS.TOTAL.AMOUNT = SUM(R.AA.BILL<AA.BD.OS.TOTAL.AMOUNT>)
            Y.PAYMENT.DATE = R.AA.BILL<AA.BD.PAYMENT.DATE>
            IF (Y.OS.TOTAL.AMOUNT EQ '' OR Y.OS.TOTAL.AMOUNT EQ 0) THEN
                Y.GENERO.PAGADA = "YES"
            END ELSE
                Y.GENERO.PAGADA = "NO"
            END

        REPEAT
    END


*---Verificar SOLO.INTERES
    IF Y.GENERO.PAGADA EQ "NO" THEN

        SEL.CMD = ''; SEL.LIST = ''; NO.OF.REC = ''; SEL.ERR = '' ; Y.OS.TOTAL.AMOUNT = ''
        SEL.CMD = " SELECT " : FN.AA.BILL: " WITH ARRANGEMENT.ID EQ " :"'":AA.ARR.ID:"'":" AND PAYMENT.DATE GE ":"'":Y.FECHA.FACTURA:"'":" AND PAYMENT.DATE LE ":"'":Y.FECHA.FIN.FACTURA:"'"
        SEL.CMD := " AND PROPERTY NE 'ACCOUNT'"
        CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR)
        SEL.LIST.INTERES = SORT(SEL.LIST)
        SEL.LIST = SORT(SEL.LIST)
        IF NO.OF.REC EQ 0 THEN
            GOSUB GET.HISTORY.BILL.HIST.SOLO.INTERES
        END ELSE
            LOOP
                REMOVE Y.BILL.ID FROM SEL.LIST SETTING BILL.POS
            WHILE Y.BILL.ID DO
                R.AA.BILL = ''; BL.ERR = ''
                Y.BL.ID = ''; Y.BL.ID = Y.BILL.ID
                CALL F.READ(FN.AA.BILL,Y.BL.ID,R.AA.BILL,F.AA.BILL,BL.ERR)
***Si la factura es generada con balance de cancelacion no considerar
                Y.AA.BD.PROPERTY = R.AA.BILL<AA.BD.PROPERTY>
                Y.BILL.TYPE = R.AA.BILL<AA.BD.BILL.TYPE>
                LOCATE 'PAYOFF' IN Y.BILL.TYPE<1,1> SETTING BIII.POSN THEN
                    CONTINUE
                END

                Y.OS.TOTAL.AMOUNT = SUM(R.AA.BILL<AA.BD.OS.TOTAL.AMOUNT>)
                Y.PAYMENT.DATE = R.AA.BILL<AA.BD.PAYMENT.DATE>
                Y.PAYMENT.TYPE = R.AA.BILL<AA.BD.PAYMENT.TYPE>

                IF (Y.OS.TOTAL.AMOUNT EQ '' OR Y.OS.TOTAL.AMOUNT EQ 0) AND Y.PAYMENT.TYPE EQ 'SOLO.INTERES' THEN
                    Y.GENERO.PAGADA = "YES"
                    RETURN
                END

            REPEAT
        END
    END

RETURN

GET.HISTORY.BILL.HIST.CONSTANTE:
*******************************

    Y.GENERO.PAGADA = "NO" ;
    SEL.CMD = ''; SEL.LIST = ''; NO.OF.REC = ''; SEL.ERR = '' ; Y.OS.TOTAL.AMOUNT = ''
    SEL.CMD = " SELECT " : FN.AA.BILL.DETAILS.HIST: " WITH ARRANGEMENT.ID EQ " :"'":AA.ARR.ID:"'":" AND PAYMENT.DATE GE ":"'":Y.FECHA.FACTURA:"'":" AND PAYMENT.DATE LE ":"'":Y.FECHA.FIN.FACTURA:"'"
    SEL.CMD = SEL.CMD :" AND PROPERTY EQ 'ACCOUNT'"
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR)
    SEL.LIST.CONSTANTE = SORT(SEL.LIST)
    SEL.LIST = SORT(SEL.LIST)
    LOOP
        REMOVE Y.BILL.ID FROM SEL.LIST SETTING BILL.POS
    WHILE Y.BILL.ID DO
        R.AA.BILL = ''; BL.ERR = ''
        Y.BL.ID = ''; Y.BL.ID = Y.BILL.ID
        CALL F.READ(FN.AA.BILL.DETAILS.HIST,Y.BL.ID,R.AA.BILL,FV.AA.BILL.DETAILS.HIST,BL.ERR)
***Si la factura es generada con balance de cancelacion no considerar
        Y.AA.BD.PROPERTY = R.AA.BILL<AA.BD.PROPERTY>
        Y.BILL.TYPE = R.AA.BILL<AA.BD.BILL.TYPE>
        LOCATE 'PAYOFF' IN Y.BILL.TYPE<1,1> SETTING BIII.POSN THEN
            CONTINUE
        END

        Y.OS.TOTAL.AMOUNT = SUM(R.AA.BILL<AA.BD.OS.TOTAL.AMOUNT>)
        Y.PAYMENT.DATE = R.AA.BILL<AA.BD.PAYMENT.DATE>
        IF (Y.OS.TOTAL.AMOUNT EQ '' OR Y.OS.TOTAL.AMOUNT EQ 0) THEN
            Y.GENERO.PAGADA = "YES"
        END ELSE
            Y.GENERO.PAGADA = "NO"
        END
    REPEAT

RETURN

GET.HISTORY.BILL.HIST.SOLO.INTERES:
**********************************

    SEL.CMD = ''; SEL.LIST = ''; NO.OF.REC = ''; SEL.ERR = '' ; Y.OS.TOTAL.AMOUNT = ''
    SEL.CMD = " SELECT " : FN.AA.BILL.DETAILS.HIST: " WITH ARRANGEMENT.ID EQ " :"'":AA.ARR.ID:"'":" AND PAYMENT.DATE GE ":"'":Y.FECHA.FACTURA:"'":" AND PAYMENT.DATE LE ":"'":Y.FECHA.FIN.FACTURA:"'"
    SEL.CMD := " AND PROPERTY NE 'ACCOUNT'"
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR)
    SEL.LIST.INTERES = SORT(SEL.LIST)
    SEL.LIST = SORT(SEL.LIST)
    LOOP
        REMOVE Y.BILL.ID FROM SEL.LIST SETTING BILL.POS
    WHILE Y.BILL.ID DO
        R.AA.BILL = ''; BL.ERR = ''
        Y.BL.ID = ''; Y.BL.ID = Y.BILL.ID
        CALL F.READ(FN.AA.BILL.DETAILS.HIST,Y.BL.ID,R.AA.BILL,FV.AA.BILL.DETAILS.HIST,BL.ERR)
***Si la factura es generada con balance de cancelacion no considerar
        Y.AA.BD.PROPERTY = R.AA.BILL<AA.BD.PROPERTY>
        Y.BILL.TYPE = R.AA.BILL<AA.BD.BILL.TYPE>
        LOCATE 'PAYOFF' IN Y.BILL.TYPE<1,1> SETTING BIII.POSN THEN
            CONTINUE
        END

        Y.OS.TOTAL.AMOUNT = SUM(R.AA.BILL<AA.BD.OS.TOTAL.AMOUNT>)
        Y.PAYMENT.DATE = R.AA.BILL<AA.BD.PAYMENT.DATE>
        Y.PAYMENT.TYPE = R.AA.BILL<AA.BD.PAYMENT.TYPE>
        IF (Y.OS.TOTAL.AMOUNT EQ '' OR Y.OS.TOTAL.AMOUNT EQ 0) AND Y.PAYMENT.TYPE EQ 'SOLO.INTERES' THEN
            Y.GENERO.PAGADA = "YES"
* RETURN
        END ELSE
            Y.GENERO.PAGADA = "NO"
        END
    REPEAT

RETURN

READ.FACTURA.GRUPO2:
********************

    BILL.POS = '' ;  Y.BILL.ID = '' ; SEL.LIST = ''
    Y.GENERO.PAGADA = "" ;
    Y.PAYMENT.DATE = '';
    Y.FECHA.CUOTA.NOPAGA = '';
    Y.TIPO.PAYMENT.NOPAGA = '';
    FECHA.CUOTA.MAS.ANTIGUA = '';
    Y.COUNT.CUOTAS.SINPAGAR = 0;
    SEL.LIST = SORT(SEL.LIST.CONSTANTE)

    LOOP
        REMOVE Y.BILL.ID FROM SEL.LIST SETTING BILL.POS
    WHILE Y.BILL.ID DO

        R.AA.BILL = ''; BL.ERR = ''
        Y.BL.ID = ''; Y.BL.ID = Y.BILL.ID
        CALL F.READ(FN.AA.BILL,Y.BL.ID,R.AA.BILL,F.AA.BILL,BL.ERR)

        Y.OS.TOTAL.AMOUNT = SUM(R.AA.BILL<AA.BD.OS.TOTAL.AMOUNT>)
        Y.AA.BD.PROPERTY = R.AA.BILL<AA.BD.PROPERTY>

        Y.BILL.TYPE = R.AA.BILL<AA.BD.BILL.TYPE>
        LOCATE 'PAYOFF' IN Y.BILL.TYPE<1,1> SETTING BIII.POSN THEN
            CONTINUE
        END

        Y.PAYMENT.DATE       = R.AA.BILL<AA.BD.PAYMENT.DATE>
        Y.FECHA.CUOTA.NOPAGA = R.AA.BILL<AA.BD.PAYMENT.DATE>
        Y.PAYMENT.TYPE.BII = R.AA.BILL<AA.BD.PAYMENT.TYPE>

        LOCATE 'CONSTANTE' IN Y.PAYMENT.TYPE.BII<1,1> SETTING BIII.POSN THEN

            IF Y.OS.TOTAL.AMOUNT GT 0 THEN
                Y.TIPO.PAYMENT.NOPAGA ='CONSTANTE'
                Y.GENERO.PAGADA = "NO"
                DAY.COUNT = "-1W"
                CALL CDT('', Y.PAYMENT.DATE, DAY.COUNT)
                Y.COUNT.CUOTAS.SINPAGAR += 1;

                IF FECHA.CUOTA.MAS.ANTIGUA EQ '' THEN
                    FECHA.CUOTA.MAS.ANTIGUA = Y.PAYMENT.DATE
                END

                GOSUB GET.AA.PAYMENT.SHEDULE.NOPAGO

                RETURN
            END
        END
    REPEAT

*---Verificar SOLO.INTERES
    BILL.POS = '' ;  Y.BILL.ID = '' ; SEL.LIST = ''
    Y.GENERO.PAGADA = "" ;
    Y.PAYMENT.DATE = '';
    Y.FECHA.CUOTA.NOPAGA = '';
    Y.TIPO.PAYMENT.NOPAGA = '';
    FECHA.CUOTA.MAS.ANTIGUA = '';
    Y.COUNT.CUOTAS.SINPAGAR = 0;

    SEL.LIST = SORT(SEL.LIST.INTERES)

    LOOP
        REMOVE Y.BILL.ID FROM SEL.LIST SETTING BILL.POS
    WHILE Y.BILL.ID DO
        R.AA.BILL = ''; BL.ERR = ''
        Y.BL.ID = ''; Y.BL.ID = Y.BILL.ID
        CALL F.READ(FN.AA.BILL,Y.BL.ID,R.AA.BILL,F.AA.BILL,BL.ERR)

        Y.OS.TOTAL.AMOUNT = SUM(R.AA.BILL<AA.BD.OS.TOTAL.AMOUNT>)
        Y.AA.BD.PROPERTY = R.AA.BILL<AA.BD.PROPERTY>

        Y.BILL.TYPE = R.AA.BILL<AA.BD.BILL.TYPE>
        LOCATE 'PAYOFF' IN Y.BILL.TYPE<1,1> SETTING BIII.POSN THEN
            CONTINUE
        END

        Y.PAYMENT.DATE       = R.AA.BILL<AA.BD.PAYMENT.DATE>
        Y.PAYMENT.TYPE.BII   = R.AA.BILL<AA.BD.PAYMENT.TYPE>
        Y.FECHA.CUOTA.NOPAGA = R.AA.BILL<AA.BD.PAYMENT.DATE>

        LOCATE 'SOLO.INTERES' IN Y.PAYMENT.TYPE.BII<1,1> SETTING BIII.POSN THEN
            IF Y.OS.TOTAL.AMOUNT GT 0 THEN

                Y.GENERO.PAGADA = "NO"
                Y.TIPO.PAYMENT.NOPAGA ='SOLO.INTERES'
                DAY.COUNT = "-1W"
                CALL CDT('', Y.PAYMENT.DATE, DAY.COUNT)
                Y.COUNT.CUOTAS.SINPAGAR += 1;

                IF FECHA.CUOTA.MAS.ANTIGUA EQ '' THEN
                    FECHA.CUOTA.MAS.ANTIGUA = Y.PAYMENT.DATE
                END

                GOSUB GET.AA.PAYMENT.SHEDULE.NOPAGO

                RETURN
            END
        END

    REPEAT
RETURN

GET.AA.PAYMENT.SHEDULE:
**********************

    Y.TIPO.CUOTA = ""; Y.DIA.FRECUENCIA = ''
    Y.PAYMENT.TYPE =  R.AA.PAYMENT.SCHEDULE.APP<AA.PS.PAYMENT.TYPE>
    Y.PAYMENT.METHOD = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.PAYMENT.METHOD>
    Y.PAYMENT.METHOD = CHANGE(Y.PAYMENT.METHOD,@SM,@FM)
    Y.PAYMENT.METHOD = CHANGE(Y.PAYMENT.METHOD,@VM,@FM)
    Y.PROPERTY = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.PROPERTY>
    Y.AA.DUE.FREQ  = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.DUE.FREQ>
    Y.AA.DUE.FREQ = CHANGE(Y.AA.DUE.FREQ,@SM,@FM)
    Y.AA.DUE.FREQ = CHANGE(Y.AA.DUE.FREQ,@VM,@FM)

    IF DCOUNT(Y.AA.DUE.FREQ,@FM) GT 1 THEN
        Y.AA.DUE.FREQ = Y.AA.DUE.FREQ<1>
    END

    Y.NEW.DUE.FREQ = Y.AA.DUE.FREQ[14,2]
    IF NUM(Y.NEW.DUE.FREQ) EQ 0 THEN
        Y.NEW.DUE.FREQ = Y.AA.DUE.FREQ[14,1]
    END

    Y.DIA.FRECUENCIA = Y.NEW.DUE.FREQ
    Y.DIA.DE.PAGO = Y.NEW.DUE.FREQ
    Y.DIA.DE.PAGO1 = Y.NEW.DUE.FREQ
    Y.FRECUENCY = "e0Y e1M e0W o":Y.DIA.FRECUENCIA:"D":" e0F"

    IF LEN (Y.DIA.DE.PAGO) EQ 1 THEN
        Y.DIA.DE.PAGO = "0":Y.DIA.DE.PAGO
    END
    Y.START.DATE = Y.YYYY.MM:Y.DIA.DE.PAGO

    IF LEN(Y.DIA.DE.PAGO1) EQ 1 THEN
        Y.DIA.DE.PAGO1 = "0":Y.DIA.DE.PAGO1
    END
    IF Y.DIA.DE.PAGO1 EQ '31' THEN
        Y.DIA.DE.PAGO1 -= 1
    END

    Y.START.DATE1 = Y.YYYY.MM1:Y.DIA.DE.PAGO1
    Y.PAYMENT.TYPE = CHANGE(Y.PAYMENT.TYPE,@SM,@FM)
    Y.PAYMENT.TYPE = CHANGE(Y.PAYMENT.TYPE,@VM,@FM)

    LOCATE "CONSTANTE" IN Y.PAYMENT.TYPE<1,1> SETTING POS.PAYMENT  THEN
        Y.TIPO.CUOTA = "CONSTANTE"
        GOSUB GET.STRING.CONSTANTE
    END ELSE

        LOCATE "SOLO.INTERES" IN Y.PAYMENT.TYPE<1,1> SETTING POS.PAYMENT  THEN
            Y.TIPO.CUOTA = "SOLO.INTERES"
            GOSUB GET.STRING.SOLO.INTERES
        END

    END

RETURN

GET.AA.PAYMENT.SHEDULE.NOPAGO:
*****************************

    Y.DIA.FRECUENCIA = ''
    Y.PAYMENT.TYPE =  R.AA.PAYMENT.SCHEDULE.APP<AA.PS.PAYMENT.TYPE>
    Y.PAYMENT.METHOD = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.PAYMENT.METHOD>
    Y.PAYMENT.METHOD = CHANGE(Y.PAYMENT.METHOD,@SM,@FM)
    Y.PAYMENT.METHOD = CHANGE(Y.PAYMENT.METHOD,@VM,@FM)
    Y.PROPERTY = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.PROPERTY>
    Y.AA.DUE.FREQ  = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.DUE.FREQ>
    Y.AA.DUE.FREQ = CHANGE(Y.AA.DUE.FREQ,@SM,@FM)
    Y.AA.DUE.FREQ = CHANGE(Y.AA.DUE.FREQ,@VM,@FM)

    IF DCOUNT(Y.AA.DUE.FREQ,@FM) GT 1 THEN
        Y.AA.DUE.FREQ = Y.AA.DUE.FREQ<1>
    END

    Y.NEW.DUE.FREQ = Y.AA.DUE.FREQ[14,2]
    IF NUM(Y.NEW.DUE.FREQ) EQ 0 THEN
        Y.NEW.DUE.FREQ = Y.AA.DUE.FREQ[14,1]
    END

    Y.DIA.DE.PAGO = Y.NEW.DUE.FREQ
    Y.DIA.DE.PAGO1 = Y.NEW.DUE.FREQ
    Y.DIA.FRECUENCIA = Y.NEW.DUE.FREQ
    Y.FRECUENCY = "e0Y e1M e0W o":Y.DIA.FRECUENCIA:"D":" e0F"

    IF LEN(Y.DIA.DE.PAGO) EQ 1 THEN
        Y.DIA.DE.PAGO = "0":Y.DIA.DE.PAGO
    END

    IF Y.DIA.DE.PAGO EQ '31' THEN
        Y.DIA.DE.PAGO -= 1
    END
**************** MEDIDA PARA LOS PRESTAMOS CON 1 SOLA CUOTA EN ABRIL *****************************
    Y.START.DATE = Y.YYYY.MM.NOPAGO:Y.DIA.DE.PAGO

    IF LEN(Y.DIA.DE.PAGO1) EQ 1 THEN
        Y.DIA.DE.PAGO1 = "0":Y.DIA.DE.PAGO1
    END

    Y.START.DATE1 = Y.YYYY.MM1.NOPAGO:Y.DIA.DE.PAGO1

    IF Y.FECHA.CUOTA.NOPAGA NE '' THEN

        Y.MES.CUOTA = Y.FECHA.CUOTA.NOPAGA[5,2];

*Si el cliente posee la cuota de ABRIL impaga, entonces colocar la gracia de 3 meses
        IF Y.MES.CUOTA EQ Y.MM.MES.NOPAGO.ABRIL AND Y.COUNT.CUOTAS.SINPAGAR EQ 1 AND (Y.TIPO.PAYMENT.NOPAGA EQ 'CONSTANTE' OR Y.TIPO.PAYMENT.NOPAGA EQ 'SOLO.INTERES') THEN
            Y.START.DATE  = Y.YYYY.CUOTA.NOPAGO.ABRIL:Y.DIA.DE.PAGO
            Y.START.DATE1 = Y.YYYY.CUOTA.NOPAGO.SOLO.INTERES.ABRIL:Y.DIA.DE.PAGO1
        END

    END
**************************************************************************************************


    Y.PAYMENT.TYPE.PRESTAMO = ''
    Y.PAYMENT.TYPE = CHANGE(Y.PAYMENT.TYPE,@SM,@FM)
    LOCATE "CONSTANTE" IN Y.PAYMENT.TYPE<1,1> SETTING POS.PAYMENT  THEN
        Y.PAYMENT.TYPE.PRESTAMO = 'CONSTANTE';
    END ELSE
        LOCATE "SOLO.INTERES" IN Y.PAYMENT.TYPE<1,1> SETTING POS.PAYMENT  THEN
            Y.PAYMENT.TYPE.PRESTAMO = 'SOLO.INTERES';
        END
    END

    Y.PAYMENT.TYPE = CHANGE(Y.PAYMENT.TYPE,@VM,@FM)
    LOCATE "CONSTANTE" IN Y.PAYMENT.TYPE<1,1> SETTING POS.PAYMENT  THEN
        Y.PAYMENT.TYPE.PRESTAMO = 'CONSTANTE';
    END ELSE

        LOCATE "SOLO.INTERES" IN Y.PAYMENT.TYPE<1,1> SETTING POS.PAYMENT  THEN
            Y.PAYMENT.TYPE.PRESTAMO = 'SOLO.INTERES';
        END
    END

    IF Y.PAYMENT.TYPE.PRESTAMO EQ "CONSTANTE" THEN
        GOSUB GET.STRING.CONSTANTE.NOPAGO
    END ELSE
        IF Y.PAYMENT.TYPE.PRESTAMO EQ "SOLO.INTERES" THEN
            GOSUB GET.STRING.SOLO.INTERES.NOPAGO
        END
    END

RETURN

GET.STRING.CONSTANTE:
********************

    J.VAR = '' ; Y.CONTADOR = 0
    Y.CNT = 0 ; Y.CNT = DCOUNT(Y.PAYMENT.TYPE,@FM)
    Y.CNT1 = Y.CNT + 1
    Y.NUEVO.PAYMENT.TYPE = "PAYMENT.TYPE:":Y.CNT1:":1::":"PAYMENT.METHOD:":Y.CNT1:":1::":"PAYMENT.FREQ:":Y.CNT1:":1::":"PROPERTY:":Y.CNT1:":1::":"START.DATE:":Y.CNT1:":1::":"END.DATE:":Y.CNT1:":1":"||"
    Y.NUEVO.PAYMENT.VALUE = "SOLO.INTERES::DUE::":Y.FRECUENCY:"::PRINCIPALINT::":Y.START.DATE1:"::":Y.START.DATE1:"||"
    Y.FIELD.NAME = ""
    Y.FIELD.NAME ="||":AA.ARR.ID:"||LENDING-CHANGE-REPAYMENT.SCHEDULE||":Y.COMPANY:"||REPAYMENT.SCHEDULE||"
    Y.FIELD.VALUE = ""
    FOR J.VAR = 1 TO Y.CNT
        Y.FIELD.NAME := "PAYMENT.TYPE:":J.VAR:":1::PAYMENT.METHOD:":J.VAR:":1::PROPERTY:":J.VAR:":1::START.DATE:":J.VAR:":1::"
        Y.FIELD.VALUE := Y.PAYMENT.TYPE<J.VAR>:"::":Y.PAYMENT.METHOD<J.VAR>:"::":Y.PROPERTY<1,J.VAR,1>:"::":Y.START.DATE:"::"
    NEXT J.VAR

    Y.FIELD.NAME := Y.NUEVO.PAYMENT.TYPE
    Y.FIELD.VALUE := Y.NUEVO.PAYMENT.VALUE
    Y.PARTE1.ARCHIVO.GRUPO.A = Y.FIELD.NAME:Y.FIELD.VALUE
    R.L.APAP.CONVI.MIG = Y.PARTE1.ARCHIVO.GRUPO.A
    Y.ID.GRUPO = AA.ARR.ID
    Y.ID.GRUPO = AA.ARR.ID:"*":"GRUPO1A"
    GOSUB CHECK.ARCHIVO.FILES

RETURN


GET.STRING.SOLO.INTERES:
***********************

    J.VAR = '' ; Y.CONTADOR = 0
    Y.FIELD.NAME ="||":AA.ARR.ID:"||LENDING-CHANGE-REPAYMENT.SCHEDULE||":Y.COMPANY:"||REPAYMENT.SCHEDULE||"
    Y.CNT = 0 ; Y.CNT = DCOUNT(Y.PAYMENT.TYPE,@FM)
    Y.CNT1 = Y.CNT + 1
    Y.NUEVO.PAYMENT.TYPE = "PAYMENT.TYPE:":Y.CNT1:":1::":"PAYMENT.METHOD:":Y.CNT1:":1::":"PAYMENT.FREQ:":Y.CNT1:":1::":"PROPERTY:":Y.CNT1:":1::":"START.DATE:":Y.CNT1:":1::":"END.DATE:":Y.CNT1:":1":"||"
    Y.NUEVO.PAYMENT.VALUE = "SOLO.INTERES::DUE::":Y.FRECUENCY:"::PRINCIPALINT::":Y.START.DATE1:"::":Y.START.DATE1:"||"
    Y.FIELD.VALUE = ""
    FOR J.VAR = 1 TO Y.CNT
        Y.CONTADOR = J.VAR
        IF Y.PAYMENT.TYPE<J.VAR> EQ 'CAPVENC' THEN
            CONTINUE
        END
        Y.FIELD.NAME := "PAYMENT.TYPE:":J.VAR:":1::PAYMENT.METHOD:":J.VAR:":1::PROPERTY:":Y.CONTADOR:":1::START.DATE:":J.VAR:":1::"
        Y.FIELD.VALUE := Y.PAYMENT.TYPE<J.VAR>:"::":Y.PAYMENT.METHOD<J.VAR>:"::":Y.PROPERTY<1,J.VAR,1>:"::":Y.START.DATE:"::"
    NEXT J.VAR

    Y.FIELD.NAME := Y.NUEVO.PAYMENT.TYPE
    Y.FIELD.VALUE := Y.NUEVO.PAYMENT.VALUE
    Y.PARTE1.ARCHIVO.GRUPO.B = Y.FIELD.NAME:Y.FIELD.VALUE
    R.L.APAP.CONVI.MIG = Y.PARTE1.ARCHIVO.GRUPO.B
    Y.ID.GRUPO = AA.ARR.ID
    Y.ID.GRUPO = AA.ARR.ID:"*":"GRUPO1B"
    GOSUB CHECK.ARCHIVO.FILES

RETURN

GET.STRING.CONSTANTE.NOPAGO:
***************************

    J.VAR = '' ; Y.CONTADOR = 0
    Y.CNT = 0 ; Y.CNT = DCOUNT(Y.PAYMENT.TYPE,@FM)
    Y.CNT1 = Y.CNT + 1
    Y.NUEVO.PAYMENT.TYPE = "PAYMENT.TYPE:":Y.CNT1:":1::":"PAYMENT.METHOD:":Y.CNT1:":1::":"PAYMENT.FREQ:":Y.CNT1:":1::":"PROPERTY:":Y.CNT1:":1::":"START.DATE:":Y.CNT1:":1::":"END.DATE:":Y.CNT1:":1":"||"
    Y.NUEVO.PAYMENT.VALUE = "SOLO.INTERES::DUE::":Y.FRECUENCY:"::PRINCIPALINT::":Y.START.DATE1:"::":Y.START.DATE1:"||"
    Y.FIELD.NAME = ""
    Y.FIELD.NAME ="||":AA.ARR.ID:"||LENDING-CHANGE-REPAYMENT.SCHEDULE||":Y.COMPANY:"||REPAYMENT.SCHEDULE||":FECHA.CUOTA.MAS.ANTIGUA:"||"
    Y.FIELD.VALUE = ""
    FOR J.VAR = 1 TO Y.CNT
        Y.FIELD.NAME := "PAYMENT.TYPE:":J.VAR:":1::PAYMENT.METHOD:":J.VAR:":1::PROPERTY:":J.VAR:":1::START.DATE:":J.VAR:":1::"
        Y.FIELD.VALUE := Y.PAYMENT.TYPE<J.VAR>:"::":Y.PAYMENT.METHOD<J.VAR>:"::":Y.PROPERTY<1,J.VAR,1>:"::":Y.START.DATE:"::"
    NEXT J.VAR

    Y.FIELD.NAME := Y.NUEVO.PAYMENT.TYPE
    Y.FIELD.VALUE := Y.NUEVO.PAYMENT.VALUE
    Y.SEGUNDO.ARCHIVO.GRUPO.A = Y.FIELD.NAME:Y.FIELD.VALUE
    R.L.APAP.CONVI.MIG = Y.SEGUNDO.ARCHIVO.GRUPO.A
    Y.ID.GRUPO = AA.ARR.ID
    Y.ID.GRUPO = AA.ARR.ID:"*":"GRUPO2A"
    GOSUB CHECK.ARCHIVO.FILES
RETURN

GET.STRING.SOLO.INTERES.NOPAGO:
******************************

    J.VAR = '' ; Y.CONTADOR = 0
    Y.FIELD.NAME ="||":AA.ARR.ID:"||LENDING-CHANGE-REPAYMENT.SCHEDULE||":Y.COMPANY:"||REPAYMENT.SCHEDULE||":FECHA.CUOTA.MAS.ANTIGUA:"||"
    Y.CNT = 0 ; Y.CNT = DCOUNT(Y.PAYMENT.TYPE,@FM)
    Y.CNT1 = Y.CNT + 1
    Y.NUEVO.PAYMENT.TYPE = "PAYMENT.TYPE:":Y.CNT1:":1::":"PAYMENT.METHOD:":Y.CNT1:":1::":"PAYMENT.FREQ:":Y.CNT1:":1::":"PROPERTY:":Y.CNT1:":1::":"START.DATE:":Y.CNT1:":1::":"END.DATE:":Y.CNT1:":1":"||"
    Y.NUEVO.PAYMENT.VALUE = "SOLO.INTERES::DUE::":Y.FRECUENCY:"::PRINCIPALINT::":Y.START.DATE1:"::":Y.START.DATE1:"||"
    Y.FIELD.VALUE = ""
    FOR J.VAR = 1 TO Y.CNT
        Y.CONTADOR = J.VAR
        IF Y.PAYMENT.TYPE<J.VAR> EQ 'CAPVENC' THEN
            CONTINUE
        END
        Y.FIELD.NAME := "PAYMENT.TYPE:":J.VAR:":1::PAYMENT.METHOD:":J.VAR:":1::PROPERTY:":Y.CONTADOR:":1::START.DATE:":J.VAR:":1::"
        Y.FIELD.VALUE := Y.PAYMENT.TYPE<J.VAR>:"::":Y.PAYMENT.METHOD<J.VAR>:"::":Y.PROPERTY<1,J.VAR,1>:"::":Y.START.DATE:"::"
    NEXT J.VAR

    Y.FIELD.NAME := Y.NUEVO.PAYMENT.TYPE
    Y.FIELD.VALUE := Y.NUEVO.PAYMENT.VALUE
    Y.SEGUNDO.ARCHIVO.GRUPO.B = Y.FIELD.NAME:Y.FIELD.VALUE
    R.L.APAP.CONVI.MIG = Y.SEGUNDO.ARCHIVO.GRUPO.B
    Y.ID.GRUPO = AA.ARR.ID
    Y.ID.GRUPO = AA.ARR.ID:"*":"GRUPO2B"
    GOSUB CHECK.ARCHIVO.FILES

RETURN


CHECK.ARCHIVO.FILES:
    CALL F.WRITE(FN.L.APAP.CONVI.MIG,Y.ID.GRUPO,R.L.APAP.CONVI.MIG)
RETURN

END
