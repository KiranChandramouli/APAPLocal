$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.AUTH.TT.NC.BIT.RT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.TELLER
    $INSERT I_F.ST.LAPAP.NOCUS.TXN.BIT

*--------------------------------------------------------------------------------
* This subroutine is attached as a AUTH Routine for TELLER,FXSN versions
* , it makes an OFS POST request to ST.LAPAP.NOCUS.TXN.BIT when a not customer makes a transaction.
* By J.Q. on Sep 6 2022
*--------------------------------------------------------------------------------
    MSG = ''
*MSG<-1> = 'Invoco rutina auth.'
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)

    GOSUB DO.INITIALIZE
    GOSUB DO.GET.ID
*MSG = ''
*MSG<-1> = 'Valores:'
*MSG<-1> = 'Legal ID:' : Y.LEGAL.ID
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)

    IF (R.NEW(TT.TE.CUSTOMER.2) EQ '') AND (Y.LEGAL.ID NE '') AND (Y.COD.CLIENT EQ '' OR Y.COD.CLIENT EQ 'NA') THEN
*MSG = ''
*MSG<-1> = 'A procesar'
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
        GOSUB DO.OFS.POST
    END
RETURN

DO.INITIALIZE:
    APPL.NAME.ARR = "TELLER"
    FLD.NAME.ARR = "L.TT.LEGAL.ID" : @VM : "L.TT.CLIENT.COD"
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)

    Y.L.TT.LEGAL.ID.POS = FLD.POS.ARR<1,1>
    Y.L.TT.CLIENT.COD.POS = FLD.POS.ARR<1,2>

*V.VAR1.OCC.CUS = ''
*V.VAR1.OCC.CUS = System.getVariable("CURRENT.VAR.OCC.CUS")
RETURN

DO.GET.ID:
    Y.LEGAL.ID = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.LEGAL.ID.POS>
    Y.COD.CLIENT = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.CLIENT.COD.POS>

RETURN

DO.OFS.POST:
    Y.IDENTIFICATION = FIELD(Y.LEGAL.ID,'.',2)

    Y.TRANS.ID = Y.IDENTIFICATION : '.' : ID.NEW : '.' : TODAY
    Y.APP.NAME = "ST.LAPAP.NOCUS.TXN.BIT"
    Y.VER.NAME = Y.APP.NAME :",INPUT"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = ""
    FINAL.OFS = ""
    OPTIONS = ""
    R.NCB = ""

    R.NCB<ST.LNCTB.IDENTIFICATION> = Y.IDENTIFICATION
    R.NCB<ST.LNCTB.TXN.REFERENCE> = ID.NEW
    R.NCB<ST.LNCTB.TXN.DATE> = TODAY
    R.NCB<ST.LNCTB.TXN.AMT> = R.NEW(TT.TE.NET.AMOUNT)
    R.NCB<ST.LNCTB.TXN.STATUS> = 'AUTH'



    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.NCB,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"GENOFS",'')



RETURN

END
