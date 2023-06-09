*-----------------------------------------------------------------------------
* <Rating>210</Rating>
*-----------------------------------------------------------------------------
*-------------------------------------------------------------------------
* Rutina multi hilo para actualizar el campo ACTUAL.AMT cuota programada
* para los contratos que tiene monto igual a cero 0 en la tabla de
* de prelación con el monto COVID19
* Fecha: 17/12/2020
* Autor: APAP
*--------------------------------------------------------------------------
    SUBROUTINE L.APAP.CAMPO.CUOTA.PROG(ARRANGEMENT.ID)
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.AA.PAYMENT.SCHEDULE
    $INSERT BP I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT BP I_F.L.APAP.LOG.COVID19
    $INSERT LAPAP.BP I_L.APAP.CAMPO.CUOTA.PROG.COMMON

    GOSUB MAIN.PROCESS

    RETURN


MAIN.PROCESS:
    AA.ARR.ID = ARRANGEMENT.ID; Y.ESTADO.CUOTA.PROG = "PROCESADO";
    CALL REDO.B.CON.LNS.BY.DEBTOR.AA.RECS(AA.ARR.ID,OUT.RECORD)
    R.AA.PAYMENT.SCHEDULE.APP = FIELD(OUT.RECORD,"*",3)
    GOSUB GET.AA.PAYMENT.SHEDULE
    GOSUB GET.COVID.PRELACION
    IF R.L.APAP.COVID.PRELACIONIII<ST.L.A76.ESTADO> NE Y.ESTADO.CUOTA.PROG THEN
        GOSUB OFS.STRING.POST

    END
    RETURN

GET.AA.PAYMENT.SHEDULE:
    Y.PAYMENT.TYPE =  R.AA.PAYMENT.SCHEDULE.APP<AA.PS.PAYMENT.TYPE>
    Y.PROPERTY = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.PROPERTY>
    Y.ACTUAL.AMT = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.ACTUAL.AMT>
    Y.PAYMENT.TYPE = CHANGE(Y.PAYMENT.TYPE,SM,FM)
    Y.PAYMENT.TYPE = CHANGE(Y.PAYMENT.TYPE,VM,FM)
    Y.ACTUAL.AMT = CHANGE(Y.ACTUAL.AMT,SM,FM)
    Y.ACTUAL.AMT = CHANGE(Y.ACTUAL.AMT,VM,FM)

    RETURN

GET.COVID.PRELACION:
    CALL F.READ (FN.ST.L.APAP.COVID.PRELACIONIII,AA.ARR.ID,R.L.APAP.COVID.PRELACIONIII,FV.ST.L.APAP.COVID.PRELACIONIII, ERROR.COVID19)
    RETURN
OFS.STRING.POST:
    Y.CUOTA.PROG.ACTUALIZAR = "";
    LOCATE "CONSTANTE" IN Y.PAYMENT.TYPE<1,1> SETTING POS.PAYMENT  THEN
        Y.ACTUAL.AMT = Y.ACTUAL.AMT<1,POS.PAYMENT>
    END

    IF Y.ACTUAL.AMT NE '' OR Y.ACTUAL.AMT GT 0 THEN
        FINDSTR 'CONSTANTE' IN Y.PAYMENT.TYPE SETTING V.FLD, V.VAL THEN
            Y.COMPANY = 'DO0010001'
            Y.OFS.QUEUE = "AA.ARRANGEMENT.ACTIVITY,AA.PRESTAMO/I/PROCESS///,//":Y.COMPANY:",,ARRANGEMENT::=":AA.ARR.ID:",ACTIVITY::=LENDING-CHANGE-REPAYMENT.SCHEDULE,EFFECTIVE.DATE:1:1=":TODAY:",PROPERTY:1:1=REPAYMENT.SCHEDULE,"
            Y.PROPERTY.POS = Y.PROPERTY<1,V.FLD,1>;
            Y.PROPERTY.POS.2 = Y.PROPERTY<1,V.FLD,2>;

            Y.CONTADOR +=1
            Y.FIELD.NAME1 := "FIELD.NAME:1:":Y.CONTADOR:"=PAYMENT.TYPE:":V.FLD:":1,"
            Y.FIELD.NAME1 :="FIELD.VALUE:1:":Y.CONTADOR:"=":Y.PAYMENT.TYPE<V.FLD>:","
            Y.CONTADOR +=1

            IF Y.PROPERTY.POS EQ 'ACCOUNT' THEN
                Y.FIELD.NAME1 := "FIELD.NAME:1:":Y.CONTADOR:"=PROPERTY:":V.FLD:":1,"
                Y.FIELD.NAME1 :="FIELD.VALUE:1:":Y.CONTADOR:"=":Y.PROPERTY.POS:","
            END ELSE

                Y.FIELD.NAME1 := "FIELD.NAME:1:":Y.CONTADOR:"=PROPERTY:":V.FLD:":2,"
                Y.FIELD.NAME1 :="FIELD.VALUE:1:":Y.CONTADOR:"=":Y.PROPERTY.POS.2:","
            END
            Y.CONTADOR +=1
            Y.FIELD.NAME1 := "FIELD.NAME:1:":Y.CONTADOR:"=ACTUAL.AMT:":V.FLD:":1,"
            Y.FIELD.NAME1 :="FIELD.VALUE:1:":Y.CONTADOR:"=":Y.CUOTA.PROG.ACTUALIZAR:","
            Y.OFS.QUEUE :=Y.FIELD.NAME1
            GOSUB SUBPROCESO
            GOSUB WRITE.L.APAP.LOG.COVID19
            GOSUB SET.COVID.PRELACIONIII

        END
        RETURN

SUBPROCESO:
        options = 'AA.COB1'
        RESP = ''
        CALL OFS.CALL.BULK.MANAGER(options,Y.OFS.QUEUE,RESP,COMM)
        Y.RESP.ARRAY1 = '' ; Y.OUT.MSG = '' ; Y.RESP.ARRANGEMENT = '' ; Y.NEW.ARRANGEMENT = ''
        Y.RESP.ARRANGEMENT = FIELD(RESP,'ARRANGEMENT:1:1=',2)
        Y.NEW.ARRANGEMENT = FIELD(Y.RESP.ARRANGEMENT,",ACTIVITY:1:1=",1)
        IF INDEX(RESP,'//-1/',1) THEN
            Y.RESP.ARRAY1 = FIELD(RESP,'//-1/',2)
            Y.OUT.MSG = FIELD(Y.RESP.ARRAY1,'</request><request>',1)
            Y.ESTATUS = 'FAILED'
        END ELSE
            IF Y.NEW.ARRANGEMENT THEN
                Y.OUT.MSG = 'SUCCESS'
                Y.ESTATUS = Y.OUT.MSG
            END
        END
        RETURN

WRITE.L.APAP.LOG.COVID19:
        IF Y.ESTATUS EQ 'FAILED' THEN
            R.L.APAP.LOG.COVID19<ST.L.A57.DETALLE> = Y.OUT.MSG
            CALL F.WRITE(FN.L.APAP.LOG.COVID19,AA.ARR.ID,R.L.APAP.LOG.COVID19)
        END

        RETURN

SET.COVID.PRELACIONIII:
        IF Y.ESTATUS EQ 'SUCCESS' THEN
            R.L.APAP.COVID.PRELACIONIII<ST.L.A76.ESTADO> = Y.ESTADO.CUOTA.PROG;
            CALL F.LIVE.WRITE(FN.ST.L.APAP.COVID.PRELACIONIII,AA.ARR.ID,R.L.APAP.COVID.PRELACIONIII)
        END
        RETURN

    END
