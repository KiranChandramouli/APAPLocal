*-----------------------------------------------------------------------------
* <Rating>255</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.INP.TAX.CHRG.RT
*-----------------------------------------------------------------------------
* Develop By                 : APAP, Requerimiento para Tranferencias Únicas 
*
* Developed On               : 23/2/2023
*
* Development Reference      : CDI-307
*
* Development Description    : Basada en la rutina de TEMENOS REDO.INP.TAX.CHRG.RT, 
*                              es la encargada de generar el número de Comprobante Fiscal (NCF) 
*                              relacionado al impuesto de la transacción es decir 
*                              el 0.15% para un FT generado desde una version LAPAP 
*                              cuando el FTTC esta bien parametrizado.
*
* Attached to                : LAPAP.BP>LAPAP.INP.TAX.CHRG.RT
* Attached as                : SAVEDLISTS>APAP001.CDI307
*-----------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.FUNDS.TRANSFER
    $INSERT T24.BP I_F.FT.COMMISSION.TYPE
    $INSERT T24.BP I_F.FT.TXN.TYPE.CONDITION
    $INSERT T24.BP I_F.CURRENCY

    IF V$FUNCTION EQ 'I' AND APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB ABRIDORES
        GOSUB BUSCAR.TXN.TYPE

    END
    RETURN          ;*Fin del codigo alcanzable
ABRIDORES:
    FN.FTCT = "F.FT.COMMISSION.TYPE"
    FV.FTCT = ""
    R.FTCT = ""
    FTCT.ERR = ""
    CALL OPF(FN.FTCT,FV.FTCT)
*
    FN.FTTTC = "F.FT.TXN.TYPE.CONDITION"
    FV.FTTTC = ""
    R.FTTTC = ""
    FTTTC.ERR = ""
    CALL OPF(FN.FTTTC,FV.FTTTC)

*
    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)
*
    Y.LOC.APPL = "FUNDS.TRANSFER"
    Y.LOC.FLD  = "L.TT.COMM.CODE":VM:"L.TT.WV.COMM":VM:"L.TT.COMM.AMT"
    Y.LOC.FLD := VM:"L.TT.TAX.CODE":VM:"L.TT.WV.TAX":VM:"L.TT.TAX.AMT"
    Y.LOC.FLD := VM:"L.TT.WV.TAX.AMT":VM:'L.TT.BASE.AMT':VM:'L.TT.TRANS.AMT'
    Y.LOC.FLD := VM:"L.FT.COMM.CODE"
*
    CALL MULTI.GET.LOC.REF(Y.LOC.APPL,Y.LOC.FLD,Y.LOC.POS)
*
    Y.L.TT.COMM.CODE    = Y.LOC.POS<1,1>
    Y.L.TT.WV.COMM      = Y.LOC.POS<1,2>
    Y.L.TT.COMM.AMT     = Y.LOC.POS<1,3>
    Y.L.TT.TAX.CODE     = Y.LOC.POS<1,4>
    Y.L.TT.WV.TAX       = Y.LOC.POS<1,5>
    Y.L.TT.TAX.AMT      = Y.LOC.POS<1,6>
    Y.L.TT.WV.TAX.AMT   = Y.LOC.POS<1,7>
    Y.L.TT.BASE.AMT     = Y.LOC.POS<1,8>
    Y.L.TT.TRANS.AMT    = Y.LOC.POS<1,9>
    Y.L.FT.COMM.POS     = Y.LOC.POS<1,10>

    V.CONT.COMM = 0
    V.CONT.TAX = 0
    RETURN

BUSCAR.TXN.TYPE:
    FT.CODE = R.NEW(FT.TRANSACTION.TYPE)
    CALL F.READ(FN.FTTTC ,FT.CODE,R.FTTTC , FV.FTTTC , FTTTC.ERR)
*FT6.COMM.TYPES
    IF R.FTTTC THEN
        V.COMM.TYPES = R.FTTTC<FT6.COMM.TYPES>
        V.CAN.CT = DCOUNT(V.COMM.TYPES,@VM)
        FOR A = 1 TO V.CAN.CT
            V.ACTUAL = A
            V.TMP.CT = V.COMM.TYPES<1,A>
*MSG<-1> = 'Comision a calcular: ' : V.TMP.CT
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
            GOSUB BUSCAR.COMM.TYPE

        NEXT A

    END
*DEBUG
    RETURN
BUSCAR.COMM.TYPE:
    CALL F.READ(FN.FTCT ,V.TMP.CT,R.FTCT , FV.FTCT , FTCT.ERR)
    IF R.FTCT THEN
        V.MONTO.TXN = R.NEW(FT.CREDIT.AMOUNT)
        V.MONEDA.TXN = R.NEW(FT.CREDIT.CURRENCY)
        V.MONEDA.MARKET = R.NEW(FT.CURRENCY.MKT.CR)
        IF V.MONTO.TXN EQ '' THEN
            V.MONTO.TXN = R.NEW(FT.DEBIT.AMOUNT)
            V.MONEDA.TXN = R.NEW(FT.DEBIT.CURRENCY)
            V.MONEDA.MARKET = R.NEW(FT.CURRENCY.MKT.DR)
        END

        IF V.MONEDA.TXN NE 'DOP' THEN
            V.MONTO.ORIG = V.MONTO.TXN
            CALL F.READ(FN.CURRENCY ,V.MONEDA.TXN,R.CURR , FV.CURRENCY , CURRENCY.ERR)
            IF R.CURR THEN
                Y.CURR.MARKET = R.CURR<EB.CUR.CURRENCY.MARKET>
                FIND V.MONEDA.MARKET IN Y.CURR.MARKET SETTING Ap, Vp THEN
                    Y.CURRENT.CURRENCY.MARKET = R.CURR<EB.CUR.CURRENCY.MARKET,Vp>
*Y.CURRENT.MID.RATE = R.CURR<EB.CUR.MID.REVAL.RATE,Vp>
                    Y.CURRENT.SELL.RATE = R.CURR<EB.CUR.SELL.RATE,Vp>
*Y.CURRENT.MID.RATE = Y.CURRENT.MID.RATE *1;
                    Y.CURRENT.SELL.RATE = Y.CURRENT.SELL.RATE * 1;
                    V.MONTO.TXN = V.MONTO.TXN * Y.CURRENT.SELL.RATE;
                END
            END
        END


        CALL GET.LOC.REF("FT.COMMISSION.TYPE","L.FT4.TX.CMM.FL",Y.L.FT4.TX.CMM.FL.POS)
        V.T.O.C = R.FTCT<FT4.LOCAL.REF,Y.L.FT4.TX.CMM.FL.POS>
        V.CALC.TYPE = R.FTCT<FT4.CALC.TYPE>

*MSG = ''
*MSG<-1> = 'V.T.O.C : ': V.T.O.C
*MSG<-1> = 'Calc type: ' : V.CALC.TYPE
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
        IF V.T.O.C EQ "T" THEN

            V.CONT.TAX += 1
            R.NEW(FT.LOCAL.REF)<1,Y.L.TT.WV.TAX,V.CONT.TAX>     = "NO"
            R.NEW(FT.LOCAL.REF)<1,Y.L.TT.TAX.CODE,V.CONT.TAX> = V.TMP.CT

            IF V.CALC.TYPE EQ "FLAT" THEN
                R.NEW(FT.LOCAL.REF)<1,Y.L.TT.TAX.AMT,V.CONT.TAX>  = R.FTCT<FT4.FLAT.AMT>
            END ELSE
                V.PERCENT = R.FTCT<FT4.PERCENTAGE>
                R.NEW(FT.LOCAL.REF)<1,Y.L.TT.TAX.AMT,V.CONT.TAX>  = (V.PERCENT*V.MONTO.TXN)/100
                V.TEMP.MONTO.TAX = (V.PERCENT*V.MONTO.TXN)/100

*MSG = ''
*MSG<-1> = 'V.PERCENT: ' : V.PERCENT
*MSG<-1> = 'V.MONTO.TXN : ' : V.MONTO.TXN
*MSG<-1> = 'V.CONT.COMM : ' : V.CONT.COMM
*MSG<-1> = 'V.CONT.TAX el que se esta utilizando.. ' : V.CONT.TAX
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)

            END

        END
*
        IF V.T.O.C EQ "C" THEN
            V.CONT.COMM += 1
            R.NEW(FT.LOCAL.REF)<1,Y.L.TT.WV.COMM,V.CONT.COMM>  = "NO"
            R.NEW(FT.LOCAL.REF)<1,Y.L.TT.COMM.CODE,V.CONT.COMM> = V.TMP.CT

            IF V.CALC.TYPE EQ "FLAT" THEN
                R.NEW(FT.LOCAL.REF)<1,Y.L.TT.COMM.AMT,V.CONT.COMM>  = R.FTCT<FT4.FLAT.AMT>
                V.TEMP.MONTO.COMM = R.FTCT<FT4.FLAT.AMT>
            END ELSE
                V.PERCENT = R.FTCT<FT4.PERCENTAGE>
                R.NEW(FT.LOCAL.REF)<1,Y.L.TT.COMM.AMT,V.CONT.COMM>  = (V.PERCENT*V.MONTO.TXN)/100
            END

        END
*DEBUG
    END
    RETURN
END
