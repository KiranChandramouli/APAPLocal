SUBROUTINE L.APAP.ENQ.TABLA.COVID19(Y.ARREGLO)
*-----------------------------------------------------------------------------
* Bank name: APAP
* Decription: Rutina tipo NOFILES enquiry para buscar el historico de pago covid19 en efectivo y cheque
* tabla FBNK.ST.L.APAP.COVI.PRELACIONIII y FBNK.ST.L.APAP.PRELACION.COVI19.DET
* Developed By: APAP
* Date:  30/12/2020
* Modification date: 21/02/2022
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT I_F.ST.L.APAP.PRELACION.COVI19.DET
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT

    GOSUB OPEN.TABLA
    GOSUB READ.ACCOUNT
    GOSUB READ.LIVE.PRELACION

RETURN

OPEN.TABLA:
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    CALL OPF (FN.ACC,F.ACC)


    FN.ACC$HIS = 'F.ACCOUNT$HIS'
    F.ACC$HIS = ''
    CALL OPF (FN.ACC$HIS,F.ACC$HIS)



    FN.PRELACIONIII = 'F.ST.L.APAP.COVI.PRELACIONIII'
    F.PRELACIONIII = ''
    CALL OPF (FN.PRELACIONIII,F.PRELACIONIII)
    FN.L.APAP.PRELACION.COVI19.DET = 'F.ST.L.APAP.PRELACION.COVI19.DET'
    FV.L.APAP.PRELACION.COVI19.DET = ''
    CALL OPF (FN.L.APAP.PRELACION.COVI19.DET,FV.L.APAP.PRELACION.COVI19.DET)

    FN.PRELACIONIII$HIS = 'F.ST.L.APAP.COVI.PRELACIONIII$HIS'
    F.PRELACIONIII$HIS = ''
    CALL OPF (FN.PRELACIONIII$HIS,F.PRELACIONIII$HIS)

    LOCATE "CONTRATO" IN D.FIELDS<1> SETTING PRO.POS THEN
        Y.CONTRATO = D.RANGE.AND.VALUE<PRO.POS>
        Y.CONTRATO = TRIM(Y.CONTRATO)
    END

RETURN

READ.ACCOUNT:
    CALL F.READ (FN.ACC,Y.CONTRATO,R.ACC,F.ACC,ERROR.ACC)
    Y.ARRANGEMENT.ID = R.ACC<AC.ARRANGEMENT.ID>
    IF NOT (Y.ARRANGEMENT.ID) THEN
        Y.HISTORICO1 = Y.CONTRATO:";1"
        CALL F.READ (FN.ACC$HIS,Y.HISTORICO1,R.ACCHIS,F.ACC$HIS,ERROR.ACC)
        Y.ARRANGEMENT.ID = R.ACCHIS<AC.ARRANGEMENT.ID>
    END

RETURN

READ.HISTORICO.PRELACION:
    Y.HIS.ARRANGEMENT =  Y.ARRANGEMENT.ID:";1":
    CALL F.READ (FN.PRELACIONIII$HIS,Y.HIS.ARRANGEMENT, R.PRELACIONIII$HIS,F.PRELACIONIII$HIS,ERROR.PRELACIONIII$HIS)
    Y.MONTO.INICIAL.COVID19 = R.PRELACIONIII$HIS<ST.L.A76.MONTO.COVI19>
RETURN
READ.LIVE.PRELACION:
    CALL F.READ(FN.PRELACIONIII,Y.ARRANGEMENT.ID,R.PRELACIONIII,F.PRELACIONIII,ERROR.PRELACIONIII)
    Y.MONTO.COVID19.PEND =  R.PRELACIONIII<ST.L.A76.MONTO.COVI19>
    IF NOT(R.PRELACIONIII) THEN
        Y.ID.HIS = Y.ARRANGEMENT.ID
        CALL EB.READ.HISTORY.REC(F.PRELACIONIII$HIS,Y.ID.HIS,R.PRELACIONIII.HIS,ERROR.PRELACIONIII)
        Y.MONTO.COVID19.PEND =  R.PRELACIONIII.HIS<ST.L.A76.MONTO.COVI19>
    END

    GOSUB READ.HISTORICO.PRELACION
    GOSUB SEARCH.L.APAP.PRELACION.COVI19.DET

RETURN

SEARCH.L.APAP.PRELACION.COVI19.DET:
*********************************
    SEL.CMD.IN = '' ; SEL.LIST.IN = '' ; NO.OF.REC.IN = '' ; RET.CODE.IN= ''
    Y.VALOR = ''; Y.MONTO.COVID.ANTES = ''; Y.MONTO.COVID.DESPUES = ''; Y.MONTO.PAGADO = ''
    Y.ESTADO = ''; Y.ID.FT = ''; Y.ARRANGEMENT.1 = ''; Y.CONTRATO.1 = ''
    SEL.CMD.IN = "SELECT ":FN.L.APAP.PRELACION.COVI19.DET:" WITH CONTRATO EQ ":Y.CONTRATO
    CALL EB.READLIST(SEL.CMD.IN,SEL.LIST.IN,'',NO.OF.REC.IN,RET.CODE.IN)
    LOOP
        REMOVE Y.ID.FT FROM SEL.LIST.IN SETTING PRE.POST.IN
    WHILE Y.ID.FT  DO
        CALL F.READ(FN.L.APAP.PRELACION.COVI19.DET,Y.ID.FT,R.L.APAP.PRELACION.COVI19.DET,FV.L.APAP.PRELACION.COVI19.DET,ERRO.DETAILS)
        Y.ARRANGEMENT.1 = R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.ARRANGEMENT>
        Y.CONTRATO.1 =   R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.CONTRATO>
        Y.MONTO.COVID.ANTES = R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.MONTO.COVI19>
        Y.MONTO.COVID.DESPUES = R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.MONTO.COVI19.DESPU>
        Y.MONTO.PAGADO = R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.MONTO.CUOTA>
        Y.ESTADO = R.L.APAP.PRELACION.COVI19.DET<ST.L.A64.ESTADO>
        Y.VALOR = ''
        Y.VALOR =  Y.ARRANGEMENT.ID:"*":Y.CONTRATO:"*":Y.ID.FT:"*":Y.MONTO.COVID19.PEND:"*":Y.MONTO.INICIAL.COVID19
        Y.VALOR :="*":Y.MONTO.COVID.ANTES:"*":Y.MONTO.COVID.DESPUES:"*":Y.MONTO.PAGADO:"*":Y.ESTADO
        Y.VALOR :="*":Y.ARRANGEMENT.1:"*":Y.CONTRATO.1
        Y.ARREGLO<-1> = Y.VALOR

    REPEAT
    IF Y.VALOR EQ '' THEN
        IF NOT(Y.MONTO.INICIAL.COVID19) THEN
            Y.MONTO.INICIAL.COVID19 = Y.MONTO.COVID19.PEND
        END
        Y.VALOR = ''
        Y.VALOR =  Y.ARRANGEMENT.ID:"*":Y.CONTRATO:"*":Y.ID.FT:"*":Y.MONTO.COVID19.PEND:"*":Y.MONTO.INICIAL.COVID19
        Y.VALOR :="*":Y.MONTO.COVID.ANTES:"*":Y.MONTO.COVID.DESPUES:"*":Y.MONTO.PAGADO:"*":Y.ESTADO
        Y.VALOR :="*":Y.ARRANGEMENT.1:"*":Y.CONTRATO.1
        Y.ARREGLO<-1> = Y.VALOR
    END

RETURN


END
