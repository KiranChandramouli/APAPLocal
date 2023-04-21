*-----------------------------------------------------------------------------
* <Rating>-66</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.I.NOCUS.DECLINED.RT
    
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO                REFERENCE                 DESCRIPTION

* 21-APR-2023     Conversion tool    R22 Auto conversion       No changes

*-----------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_GTS.COMMON
    $INSERT T24.BP I_System
    $INSERT T24.BP I_F.TELLER
    $INSERT T24.BP I_F.DATES
    $INSERT BP I_F.ST.LAPAP.NOCUS.TXN.BIT
    $INSERT BP I_F.ST.LAPAP.NOCUS.LIMIT
    $INSERT T24.BP I_F.CURRENCY
    $INSERT BP I_F.ST.LAPAP.FX.DECLINED.TXN
    $INSERT T24.BP I_F.USER
    $INSERT T24.BP I_F.TELLER.TRANSACTION

*--------------------------------------------------------------------------------------
* This subroutine is attached as a Input Routine for TELLER,FXSN versions
* , When the occasional customer exceeds its monthly limit this inserts into ...
* ...ST.LAPAP.FX.DECLINED.TXN application
* By J.Q. on Oct 4 2022
*--------------------------------------------------------------------------------------

    Y.ID = 'I-':ID.NEW
*MSG= ''
*MSG<-1> = 'Estoy dentro de LAPAP.I.NOCUS.DECLINED.RT'
*MSG<-1> = 'MESSAGE VALUE: ' : MESSAGE
*CALL LAPAP.LOGGER('TESTLOG',Y.ID,MSG)

    GOSUB DO.INITIALIZE
    GOSUB DO.OPEN.FILES
    GOSUB GET.OP.TYPE
    GOSUB DO.FORM.ARR
    GOSUB DO.SEND.OFS.MSG
*GOSUB DO.DIRECT.WRITE
    RETURN

DO.INITIALIZE:
    APPL.NAME.ARR = "TELLER"
    FLD.NAME.ARR = "L.TT.LEGAL.ID" : @VM : "L.TT.CLIENT.COD" : @VM : "L.ACTUAL.VERSIO"
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)

    Y.L.TT.LEGAL.ID.POS = FLD.POS.ARR<1,1>
    Y.L.TT.CLIENT.COD.POS = FLD.POS.ARR<1,2>
    Y.L.ACTUAL.VERSIO.POS = FLD.POS.ARR<1,3>


    Y.LEGAL.ID = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.LEGAL.ID.POS>
    Y.IDENTIFICATION = FIELD(Y.LEGAL.ID,'.',2)

    Y.TXN.CODE = R.NEW(TT.TE.TRANSACTION.CODE)

    FN.DEC.TXN = "F.ST.LAPAP.FX.DECLINED.TXN"
    F.DEC.TXN = ""
    CALL OPF(FN.DEC.TXN, F.DEC.TXN)

    RETURN

DO.OPEN.FILES:
    FN.T.TX = 'F.TELLER.TRANSACTION';
    F.T.TX = ''
    ERR.T.TX = '';
    R.T.TX = '';
    CALL OPF(FN.T.TX,F.T.TX)

    RETURN

GET.OP.TYPE:
*-->Y.TXN.CODE -> TELLER.TRANSACTION>SHORT.DESC
    Y.OP.TYPE = ''
    CALL F.READ(FN.T.TX,Y.TXN.CODE,R.T.TX,F.T.TX,ERR.T.TX)
    IF R.T.TX THEN
        Y.SHORT.DESC = R.T.TX<TT.TR.SHORT.DESC>
*If Y.SHORT.DESC conatins VENTA o VTA -> Venta, else --> Compra
        Y.CNT.VTA = 0
        Y.CNT.VENTA = 0

        Y.CNT.VTA = COUNT(Y.SHORT.DESC, "VTA")
        Y.CNT.VENTA = COUNT(Y.SHORT.DESC,"VENTA")

        IF (Y.CNT.VTA GT 0) OR (Y.CNT.VENTA GT 0) THEN
            Y.OP.TYPE = 'VENTA'
        END ELSE
            Y.OP.TYPE = 'COMPRA'
        END

    END ELSE
        Y.OP.TYPE = ''
    END

    RETURN

DO.FORM.ARR:
    R.DEC = ''
    R.DEC<ST.LAP32.CUS.IDENTIFICATION> = Y.IDENTIFICATION
    R.DEC<ST.LAP32.TXN.REFERENCE> = ID.NEW
    R.DEC<ST.LAP32.VERSION> = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.ACTUAL.VERSIO.POS>
    R.DEC<ST.LAP32.CURRENCY> = R.NEW(TT.TE.CURRENCY.1)
    R.DEC<ST.LAP32.RATE> = R.NEW(TT.TE.DEAL.RATE)
    R.DEC<ST.LAP32.AMOUNT> = R.NEW(TT.TE.NET.AMOUNT)
    R.DEC<ST.LAP32.DATE> = R.DATES(EB.DAT.TODAY)
    Y.TIME.DATE = TIMEDATE()
    R.DEC<ST.LAP32.TIME> = Y.TIME.DATE[1,8]
    R.DEC<ST.LAP32.BRANCH> = ID.COMPANY
    R.DEC<ST.LAP32.USER> = OPERATOR
    R.DEC<ST.LAP32.USER.NAME> = R.USER<EB.USE.USER.NAME>
    R.DEC<ST.LAP32.OP.TYPE> = Y.OP.TYPE
    R.DEC<ST.LAP32.DEC.REASON> = 'AMT.EXCEED'

    RETURN

DO.SEND.OFS.MSG:
    Y.TRANS.ID = ID.NEW
    Y.APP.NAME = "ST.LAPAP.FX.DECLINED.TXN"
    Y.VER.NAME = Y.APP.NAME :",INPUT"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = ""
    FINAL.OFS = ""
    OPTIONS = ""


    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.DEC,FINAL.OFS)
    Y.ID = 'I-':ID.NEW
*MSG= ''
*MSG<-1> = 'OFS A Enviar: '
*MSG<-1> = FINAL.OFS
*MSG<-1> = 'RUNNING.UNDER.BATCH prior val: ' : RUNNING.UNDER.BATCH
*CALL LAPAP.LOGGER('TESTLOG',Y.ID,MSG)


    RUNNING.UNDER.BATCH = 1
    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"GENOFS",'')

*CALL OFS.GLOBUS.MANAGER('GENOFS',FINAL.OFS)
*CALL JOURNAL.UPDATE('')
    RUNNING.UNDER.BATCH =0
    Y.ID = 'I-':ID.NEW
*MSG= ''
*MSG<-1> = 'OFS Enviado: '
*MSG<-1> = FINAL.OFS
*CALL LAPAP.LOGGER('TESTLOG',Y.ID,MSG)

    RETURN

DO.DIRECT.WRITE:
    Y.ID = 'I-':ID.NEW
    MSG= ''
    MSG<-1> = 'Escribiendo directo... '
    CALL LAPAP.LOGGER('TESTLOG',Y.ID,MSG)

    WRITE R.DEC TO F.DEC.TXN, ID.NEW ON ERROR
        Y.ID = 'I-':ID.NEW
        MSG= ''
        MSG<-1> = 'ERROR, COULD NOT WRITE FIILE'
        *CALL LAPAP.LOGGER('TESTLOG',Y.ID,MSG)
    END
    RETURN
END
