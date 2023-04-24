*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.SET.PAY.COVID.IN (Y.AAA.ID)
*-----------------------------------------------------------------------------
* Bank name: APAP
* Decription: Rutina MAIN Validar los pagos realizdos a los cotratos COVID19 con el monto de prelacion
* Logica: Lee todos los pagos realizados en el dia de las tablas (FBNK.AA.ARRANGEMENT.ACTIVITY,FBNK.FUNDS.TRASNFER)
* y va contra la tabla F.ST.L.APAP.COVI.PRELACIONIII
* y verifica si contrato se encuentra en esa tabla y tiene monto pendiente y le recta el valor que tenga
* monto pagado FT
* Developed By: APAP
* Date:  10122020
*-----------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT T24.BP I_F.FUNDS.TRANSFER
    $INSERT T24.BP I_F.AA.PAYMENT.SCHEDULE
    $INSERT T24.BP I_F.AA.ARRANGEMENT
    $INSERT  BP I_F.ST.L.APAP.PRELACION.COVI19.DET
    $INSERT BP I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT LAPAP.BP I_L.APAP.VALI.PAY.COVID.COMMON
    $INSERT T24.BP I_F.USER
    $INSERT T24.BP I_F.COMPANY
    GOSUB MAIN.PROCESS

    RETURN

MAIN.PROCESS:
*************
    FN.L.APAP.COVI.PRELACIONIII = 'F.ST.L.APAP.COVI.PRELACIONIII'
    FV.L.APAP.COVI.PRELACIONIII = ''
    CALL OPF (FN.L.APAP.COVI.PRELACIONIII,FV.L.APAP.COVI.PRELACIONIII)

    FN.L.APAP.COVI.PRELACIONIII.HIST = 'F.ST.L.APAP.COVI.PRELACIONIII$HIS'
    FV.L.APAP.COVI.PRELACIONIII.HIST = ''
    CALL OPF (FN.L.APAP.COVI.PRELACIONIII.HIST,FV.L.APAP.COVI.PRELACIONIII.HIST)


    FN.FT = 'F.FUNDS.TRANSFER'
    FV.FT = ''
    CALL OPF (FN.FT,FV.FT)

    FN.AAA = 'F.AA.ARRANGEMENT.ACTIVITY'
    FV.AAA = ''
    CALL OPF (FN.AAA,FV.AAA)

    FN.L.APAP.PRELACION.COVI19.DET = 'F.ST.L.APAP.PRELACION.COVI19.DET'
    FV.L.APAP.PRELACION.COVI19.DET = ''
    CALL OPF (FN.L.APAP.PRELACION.COVI19.DET,FV.L.APAP.PRELACION.COVI19.DET)
    Y.MONTO.COVID19 = 0 ; Y.MONTO.COVID19.DESPUES = 0 ; Y.ARRANGEMENT.ID = ''; Y.PRESTAMO = ''
    Y.MONTO.CUOTA.PR = 0 ; Y.FECHA = ''; Y.HORA = ''
    GOSUB GET.AAA.INFO
*----Si es campo es igual a vacio entoces fue un pago anticipado
    IF Y.ACTIVITY NE 'LENDING-APPLYPAYMENT-RP.PAYOFF.CHQ' AND Y.ACTIVITY NE 'LENDING-APPLYPAYMENT-RP.PAYOFF' THEN
        IF Y.TXN.AMOUNT EQ 0 THEN
            RETURN
        END
    END
*---------------------------------------------------------------
    GOSUB GET.L.APAP.PRELACION.COVI19.DET
    IF (R.L.APAP.PRELACION.COVI19.DET) THEN
        RETURN
    END


    GOSUB GET.PAYMENT.SCHEDULE
    IF Y.SYSTEM.ID EQ 'FT' THEN
        GOSUB GET.FT.INFO
        CALL L.APAP.MONTO.SOLO.COVID.PR(Y.AAA.ID,Y.MONTO.CUOTA.PR)
        IF Y.MONTO.CUOTA.PR EQ 0 THEN
            RETURN
        END
        GOSUB GET.COVID.PRELACIONIII
        IF (R.ST.L.APAP.COVID.PRELACIONIII) THEN
            GOSUB WRITE.L.APAP.COVID.PRELACIONIII
        END

    END ELSE

**--Nuevo proceso para pagos anticipado
        IF Y.SYSTEM.ID EQ 'AA' AND Y.ACTIVITY EQ 'LENDING-SETTLE-RP.PAGO.ANTICIPADO' THEN
            Y.PRESTAMO = R.ST.L.APAP.COVID.PRELACIONIII<ST.L.A76.CONTRATO>
            CALL L.APAP.MONTO.SOLO.COVID.PR(Y.AAA.ID,Y.MONTO.CUOTA.PR)
            IF Y.MONTO.CUOTA.PR EQ 0 THEN
                RETURN
            END
            GOSUB GET.COVID.PRELACIONIII
            GOSUB GET.ALL.COVID19.DET
            IF (R.ST.L.APAP.COVID.PRELACIONIII) THEN
                IF Y.ELIMINAR.HIST EQ 'SI' THEN
                    GOSUB WRITE.L.APAP.COVID.PRELACIONIII.HIST
                END ELSE
                    GOSUB WRITE.L.APAP.COVID.PRELACIONIII
                END
            END

        END
    END
    CALL JOURNAL.UPDATE(Y.AAA.ID)
**---------------------------------------

    RETURN

GET.AAA.INFO:
*************
    CALL F.READ(FN.AAA,Y.AAA.ID,R.AAA,FV.AAA,ERROR.AA)
    Y.ARRANGEMENT.ID = R.AAA<AA.ARR.ACT.ARRANGEMENT>
    Y.CONTRACT.ID = R.AAA<AA.ARR.ACT.TXN.CONTRACT.ID>
    Y.SYSTEM.ID =   R.AAA<AA.ARR.ACT.TXN.SYSTEM.ID>
    Y.TXN.AMOUNT = R.AAA<AA.ARR.ACT.TXN.AMOUNT>
    Y.ACTIVITY = R.AAA<AA.ARR.ACT.ACTIVITY>
    RETURN

GET.L.APAP.PRELACION.COVI19.DET:
*******************************
    CALL F.READ(FN.L.APAP.PRELACION.COVI19.DET,Y.CONTRACT.ID,R.L.APAP.PRELACION.COVI19.DET,FV.L.APAP.PRELACION.COVI19.DET,ERROR.L.APAP.PRELACION.COVI19.DET)

    RETURN

GET.ALL.COVID19.DET:
    Y.ELIMINAR.HIST = '';
    SEL.CMD1 = "SELECT ":FN.L.APAP.PRELACION.COVI19.DET:" WITH CONTRATO EQ ":R.ST.L.APAP.COVID.PRELACIONIII<ST.L.A76.CONTRATO>
    CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',NO.OF.REC1,RET.CODE1)

    IF DCOUNT(SEL.LIST1,FM) GT 0 THEN
        Y.ELIMINAR.HIST = "NO";
        RETURN
    END

    IF DCOUNT(SEL.LIST1,FM) EQ 0 THEN
        Y.ELIMINAR.HIST = "SI";
        RETURN
    END

    RETURN

GET.PAYMENT.SCHEDULE:
*********************
    CALL REDO.B.CON.LNS.BY.DEBTOR.AA.RECS(Y.ARRANGEMENT.ID,OUT.RECORD)
    R.AA.PAYMENT.SCHEDULE.APP = FIELD(OUT.RECORD,"*",3)
    Y.PAYMENT.TYPE =  R.AA.PAYMENT.SCHEDULE.APP<AA.PS.PAYMENT.TYPE>
    Y.CALC.AMOUNT =  R.AA.PAYMENT.SCHEDULE.APP<AA.PS.CALC.AMOUNT>
    Y.CALC.AMOUNT = CHANGE(Y.CALC.AMOUNT,SM,FM)
    Y.CALC.AMOUNT = CHANGE(Y.CALC.AMOUNT,VM,FM)
    Y.PAYMENT.TYPE = CHANGE(Y.PAYMENT.TYPE,SM,FM)
    Y.PAYMENT.TYPE = CHANGE(Y.PAYMENT.TYPE,VM,FM)
    LOCATE "CONSTANTE" IN Y.PAYMENT.TYPE<1,1> SETTING POS.PAYMENT  THEN
        Y.CALC.AMOUNT = Y.CALC.AMOUNT<1,POS.PAYMENT>
    END
    RETURN

GET.FT.INFO:
************
    CALL F.READ(FN.FT,Y.CONTRACT.ID,R.FT,FV.FT,ERROR.FT)
    Y.PRESTAMO = R.FT<FT.CREDIT.ACCT.NO>
    RETURN

GET.COVID.PRELACIONIII:
***********************
    CALL F.READ(FN.L.APAP.COVI.PRELACIONIII,Y.ARRANGEMENT.ID,R.ST.L.APAP.COVID.PRELACIONIII,FV.L.APAP.COVI.PRELACIONIII,ERROR.PRELACIONIII)

    RETURN



WRITE.L.APAP.COVID.PRELACIONIII.HIST:
********************************
    Y.RESULTADO = 0
    Y.HISTORICO.ID = Y.ARRANGEMENT.ID:";1"

    CALL F.READ(FN.L.APAP.COVI.PRELACIONIII.HIST,Y.HISTORICO.ID, R.L.APAP.COVI.PRELACIONIII.HIST,FV.L.APAP.COVI.PRELACIONIII.HIST,ERROR.COVID)

    IF R.L.APAP.COVI.PRELACIONIII.HIST<ST.L.A76.MONTO.COVI19> GT 0 THEN
        Y.MONTO.COVID19.ACTUAL = R.L.APAP.COVI.PRELACIONIII.HIST<ST.L.A76.MONTO.COVI19>
        Y.RESULTADO = R.L.APAP.COVI.PRELACIONIII.HIST<ST.L.A76.MONTO.COVI19> - Y.MONTO.CUOTA.PR

        IF Y.RESULTADO LT 0 THEN
            Y.MONTO.COVID19 = 0;
        END ELSE
            Y.MONTO.COVID19 = Y.RESULTADO;
        END
        R.ST.L.APAP.COVID.PRELACIONIII<ST.L.A76.MONTO.COVI19> = Y.MONTO.COVID19
        CALL F.LIVE.WRITE(FN.L.APAP.COVI.PRELACIONIII,Y.ARRANGEMENT.ID,R.ST.L.APAP.COVID.PRELACIONIII)
        GOSUB WRITE.L.APAP.PRELACION.COVI19.DET
    END
    RETURN

WRITE.L.APAP.COVID.PRELACIONIII:
********************************
    Y.RESULTADO = 0

    IF R.ST.L.APAP.COVID.PRELACIONIII<ST.L.A76.MONTO.COVI19> GT 0 THEN
        Y.MONTO.COVID19.ACTUAL = R.ST.L.APAP.COVID.PRELACIONIII<ST.L.A76.MONTO.COVI19>
        Y.RESULTADO = R.ST.L.APAP.COVID.PRELACIONIII<ST.L.A76.MONTO.COVI19> - Y.MONTO.CUOTA.PR

        IF Y.RESULTADO LT 0 THEN
            Y.MONTO.COVID19 = 0;
        END ELSE
            Y.MONTO.COVID19 = Y.RESULTADO;
        END
        R.ST.L.APAP.COVID.PRELACIONIII<ST.L.A76.MONTO.COVI19> = Y.MONTO.COVID19
        CALL F.LIVE.WRITE(FN.L.APAP.COVI.PRELACIONIII,Y.ARRANGEMENT.ID,R.ST.L.APAP.COVID.PRELACIONIII)
        GOSUB WRITE.L.APAP.PRELACION.COVI19.DET
    END
    RETURN

WRITE.L.APAP.PRELACION.COVI19.DET:
*********************************

    R.L.APAP.PRELACION.COVI19.DET = ''
    R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.ARRANGEMENT> = Y.ARRANGEMENT.ID
    R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.MONTO.COVI19> = Y.MONTO.COVID19.ACTUAL
    R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.MONTO.CUOTA> = Y.MONTO.CUOTA.PR
    R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.CONTRATO> = R.ST.L.APAP.COVID.PRELACIONIII<ST.L.A76.CONTRATO>
    R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.MONTO.COVI19.DESPU> = Y.MONTO.COVID19
    R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.FECHA> = TODAY
    R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.HORA> = OCONV(TIME(), "MTS")
    R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.ESTADO> = 'CURR'
*Auditoria campos
    R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.INPUTTER> = OPERATOR
    R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.AUTHORISER> = OPERATOR
    R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.DATE.TIME> = R.ST.L.APAP.COVID.PRELACIONIII<ST.L.A76.DATE.TIME>
    R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.CO.CODE> = ID.COMPANY
    R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    IF Y.SYSTEM.ID EQ 'AA' AND Y.ACTIVITY EQ 'LENDING-SETTLE-RP.PAGO.ANTICIPADO' THEN
        CALL F.WRITE(FN.L.APAP.PRELACION.COVI19.DET,Y.AAA.ID,R.L.APAP.PRELACION.COVI19.DET)
    END ELSE
        CALL F.WRITE(FN.L.APAP.PRELACION.COVI19.DET,Y.CONTRACT.ID,R.L.APAP.PRELACION.COVI19.DET)
    END
    RETURN

END